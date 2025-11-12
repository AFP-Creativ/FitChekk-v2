//
//  AddItemView.swift
//  FitChekk
//
//  View for adding new wardrobe items with image selection and form fields
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

@MainActor
struct AddItemView: View {
    @Bindable var store: StoreOf<AddItemFeature>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Image Selection Section
                    imageSelectionSection

                    // Basic Info Section
                    basicInfoSection

                    // Category Section
                    categorySection

                    // Details Section
                    detailsSection

                    // Save Button
                    PrimaryButton(
                        title: "Add to Wardrobe",
                        action: { store.send(.saveTapped) },
                        isLoading: store.isSaving,
                        isDisabled: !store.canSave
                    )
                    .padding(.horizontal, Spacing.md)
                    .padding(.bottom, Spacing.xl)
                }
                .padding(.top, Spacing.md)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        store.send(.cancelTapped)
                    }
                }
            }
            .photosPicker(
                isPresented: .init(
                    get: { store.showPhotosPicker },
                    set: { if !$0 { store.send(.dismissPhotosPicker) } }
                ),
                selection: .init(
                    get: { store.selectedPhotoItem },
                    set: { store.send(.photoItemChanged($0)) }
                ),
                matching: .images
            )
            .alert(
                "Error",
                isPresented: .init(
                    get: { store.errorMessage != nil },
                    set: { if !$0 { store.send(.clearError) } }
                ),
                actions: {
                    Button("OK") {
                        store.send(.clearError)
                    }
                },
                message: {
                    if let errorMessage = store.errorMessage {
                        Text(errorMessage)
                    }
                }
            )
            .alert(
                "Unsaved Changes",
                isPresented: .init(
                    get: { store.showCancelConfirmation },
                    set: { if !$0 { store.send(.cancelConfirmationDismissed) } }
                ),
                actions: {
                    Button("Keep Editing", role: .cancel) {
                        store.send(.cancelConfirmationDismissed)
                    }
                    Button("Discard", role: .destructive) {
                        dismiss()
                    }
                },
                message: {
                    Text("You have unsaved changes. Are you sure you want to discard them?")
                }
            )
        }
    }

    // MARK: - Image Selection Section

    private var imageSelectionSection: some View {
        VStack(spacing: Spacing.sm) {
            if let image = store.selectedImage {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Button(action: { store.send(.removeImageTapped) }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.5)))
                    }
                    .padding(Spacing.xs)
                }
                .padding(.horizontal, Spacing.md)

                // Background Removal Toggle
                Toggle("Remove Background", isOn: .init(
                    get: { store.shouldRemoveBackground },
                    set: { store.send(.backgroundRemovalToggled($0)) }
                ))
                .padding(.horizontal, Spacing.md)
                .disabled(store.isProcessingImage)

                if store.isProcessingImage {
                    HStack(spacing: Spacing.xs) {
                        ProgressView()
                        Text("Processing image...")
                            .font(Font.captionRegular)
                            .foregroundColor(Color.textSecondary)
                    }
                }

                // Auto-Categorize Button
                if !store.isCategorizingWithAI {
                    PrimaryButton(
                        title: "✨ Auto-Categorize with AI",
                        action: { store.send(.autoCategorizeTapped) }
                    )
                    .padding(.horizontal, Spacing.md)
                } else {
                    HStack(spacing: Spacing.xs) {
                        ProgressView()
                        Text("Analyzing item...")
                            .font(Font.bodyMedium)
                            .foregroundColor(Color.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.sm)
                }
                
                // Change Photo Button
                SecondaryButton(
                    title: "Change Photo",
                    action: { store.send(.selectPhotoTapped) }
                )
                .padding(.horizontal, Spacing.md)

            } else {
                // Empty State
                VStack(spacing: Spacing.md) {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(Color.textTertiary)

                    Text("Add a photo of your item")
                        .font(Font.bodyMedium)
                        .foregroundColor(Color.textSecondary)

                    PrimaryButton(
                        title: "Select Photo",
                        action: { store.send(.selectPhotoTapped) }
                    )
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(Color.backgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, Spacing.md)
            }
        }
    }

    // MARK: - Basic Info Section

    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Basic Info")
                .font(Font.headlineSmall)
                .foregroundColor(Color.textPrimary)
                .padding(.horizontal, Spacing.md)

            VStack(spacing: Spacing.md) {
                TextField("Item Name (Optional)", text: .init(
                    get: { store.name },
                    set: { store.send(.nameChanged($0)) }
                ))
                .textFieldStyle(FitChekkTextFieldStyle())

                TextField("Brand (Optional)", text: .init(
                    get: { store.brand },
                    set: { store.send(.brandChanged($0)) }
                ))
                .textFieldStyle(FitChekkTextFieldStyle())
            }
            .padding(.horizontal, Spacing.md)
        }
    }

    // MARK: - Category Section

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text("Category")
                    .font(Font.headlineSmall)
                    .foregroundColor(Color.textPrimary)
                
                if let confidence = store.aiConfidence {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 10))
                        Text("\(Int(confidence * 100))% confident")
                            .font(Font.captionRegular)
                    }
                    .padding(.horizontal, Spacing.xs)
                    .padding(.vertical, 2)
                    .background(confidenceColor(for: confidence))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                
                Spacer()
            }
            .padding(.horizontal, Spacing.md)

            // Category Picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.sm) {
                    ForEach(ItemCategory.allCases, id: \.self) { category in
                        Button(action: {
                            store.send(.categoryChanged(category))
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: category.icon)
                                    .font(.system(size: 24))
                                Text(category.displayName)
                                    .font(Font.captionMedium)
                            }
                            .frame(width: 80, height: 80)
                            .background(
                                store.category == category ?
                                    Color.accentPrimary : Color.backgroundSecondary
                            )
                            .foregroundColor(
                                store.category == category ?
                                    .white : Color.textSecondary
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(.horizontal, Spacing.md)
            }

            // Subcategory Picker
            if !store.availableSubcategories.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Subcategory")
                        .font(Font.captionMedium)
                        .foregroundColor(Color.textSecondary)
                        .padding(.horizontal, Spacing.md)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Spacing.sm) {
                            ForEach(store.availableSubcategories, id: \.self) { subcategory in
                                Button(action: {
                                    store.send(.subCategoryChanged(subcategory))
                                }) {
                                    Text(subcategory.displayName)
                                        .font(Font.captionMedium)
                                        .padding(.horizontal, Spacing.sm)
                                        .padding(.vertical, Spacing.xs)
                                        .background(
                                            store.subCategory == subcategory ?
                                                Color.accentPrimary : Color.backgroundSecondary
                                        )
                                        .foregroundColor(
                                            store.subCategory == subcategory ?
                                                .white : Color.textSecondary
                                        )
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal, Spacing.md)
                    }
                }
            }
        }
    }

    // MARK: - Details Section

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Details")
                .font(Font.headlineSmall)
                .foregroundColor(Color.textPrimary)
                .padding(.horizontal, Spacing.md)

            // Colors
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Colors")
                    .font(Font.captionMedium)
                    .foregroundColor(Color.textSecondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        ForEach(store.availableColors, id: \.self) { color in
                            Button(action: {
                                store.send(.colorToggled(color))
                            }) {
                                Text(color)
                                    .font(Font.captionMedium)
                                    .padding(.horizontal, Spacing.sm)
                                    .padding(.vertical, Spacing.xs)
                                    .background(
                                        store.selectedColors.contains(color) ?
                                            Color.accentPrimary : Color.backgroundSecondary
                                    )
                                    .foregroundColor(
                                        store.selectedColors.contains(color) ?
                                            .white : Color.textSecondary
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.md)

            // Seasons
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Seasons")
                    .font(Font.captionMedium)
                    .foregroundColor(Color.textSecondary)

                HStack(spacing: Spacing.sm) {
                    ForEach(Season.allCases, id: \.self) { season in
                        Button(action: {
                            store.send(.seasonToggled(season))
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: season.icon)
                                    .font(.system(size: 12))
                                Text(season.displayName)
                                    .font(Font.captionMedium)
                            }
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, Spacing.xs)
                            .background(
                                store.selectedSeasons.contains(season) ?
                                    Color.accentPrimary : Color.backgroundSecondary
                            )
                            .foregroundColor(
                                store.selectedSeasons.contains(season) ?
                                    .white : Color.textSecondary
                            )
                            .clipShape(Capsule())
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.md)

            // Formality
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Formality")
                    .font(Font.captionMedium)
                    .foregroundColor(Color.textSecondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        ForEach(FormalityLevel.allCases, id: \.self) { level in
                            Button(action: {
                                store.send(.formalityChanged(level))
                            }) {
                                Text(level.displayName)
                                    .font(Font.captionMedium)
                                    .padding(.horizontal, Spacing.sm)
                                    .padding(.vertical, Spacing.xs)
                                    .background(
                                        store.formality == level ?
                                            Color.accentPrimary : Color.backgroundSecondary
                                    )
                                    .foregroundColor(
                                        store.formality == level ?
                                            .white : Color.textSecondary
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.md)

            // Notes
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Notes (Optional)")
                    .font(Font.captionMedium)
                    .foregroundColor(Color.textSecondary)

                TextField("Add any notes about this item...", text: .init(
                    get: { store.notes },
                    set: { store.send(.notesChanged($0)) }
                ), axis: .vertical)
                .lineLimit(3...6)
                .textFieldStyle(FitChekkTextFieldStyle())
            }
            .padding(.horizontal, Spacing.md)
        }
    }
    
    // MARK: - Helper Functions
    
    private func confidenceColor(for confidence: Double) -> Color {
        switch confidence {
        case 0.8...1.0:
            return .green
        case 0.5..<0.8:
            return .orange
        default:
            return .red
        }
    }
}

// MARK: - AddItemFeature

@Reducer
struct AddItemFeature {
    @ObservableState
    struct State: Equatable {
        // Image
        var selectedImage: UIImage?
        var selectedPhotoItem: PhotosPickerItem?
        var showPhotosPicker = false
        var isProcessingImage = false
        var shouldRemoveBackground = false

        // Form Fields
        var name = ""
        var brand = ""
        var category: ItemCategory = .tops
        var subCategory: ItemSubCategory = .basicTees
        var selectedColors: Set<String> = []
        var selectedSeasons: Set<Season> = []
        var formality: FormalityLevel = .casual
        var notes = ""

        // AI Categorization
        var isCategorizingWithAI = false
        var aiConfidence: Double?
        var aiGenerated = false

        // State
        var isSaving = false
        var errorMessage: String?
        var showCancelConfirmation = false

        // User Context
        var userId: UUID

        // Computed
        var canSave: Bool {
            selectedImage != nil && !isSaving
        }

        var hasChanges: Bool {
            selectedImage != nil || !name.isEmpty || !brand.isEmpty || !notes.isEmpty
        }

        var availableSubcategories: [ItemSubCategory] {
            ItemSubCategory.allCases.filter { $0.category == category }
        }

        var availableColors: [String] {
            ["Black", "White", "Gray", "Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Pink", "Brown", "Beige", "Navy", "Cream"]
        }
    }

    enum Action {
        case selectPhotoTapped
        case photoItemChanged(PhotosPickerItem?)
        case dismissPhotosPicker
        case removeImageTapped
        case backgroundRemovalToggled(Bool)
        case processImage(UIImage)
        case imageProcessed(UIImage)

        case nameChanged(String)
        case brandChanged(String)
        case categoryChanged(ItemCategory)
        case subCategoryChanged(ItemSubCategory)
        case colorToggled(String)
        case seasonToggled(Season)
        case formalityChanged(FormalityLevel)
        case notesChanged(String)

        case autoCategorizeTapped
        case categorizationResponse(Result<CategorizationResult, Error>)

        case saveTapped
        case saveComplete(WardrobeItem)
        case cancelTapped
        case cancelConfirmationDismissed

        case clearError
        case setError(String)
    }

    @Dependency(\.backgroundRemovalService) var backgroundRemovalService
    @Dependency(\.categorizationService) var categorizationService
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .selectPhotoTapped:
                state.showPhotosPicker = true
                return .none

            case let .photoItemChanged(item):
                state.selectedPhotoItem = item

                guard let item = item else { return .none }

                return .run { send in
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        await send(.processImage(image))
                    }
                }

            case .dismissPhotosPicker:
                state.showPhotosPicker = false
                return .none

            case .removeImageTapped:
                state.selectedImage = nil
                state.selectedPhotoItem = nil
                state.shouldRemoveBackground = false
                return .none

            case let .backgroundRemovalToggled(enabled):
                state.shouldRemoveBackground = enabled

                if enabled, let image = state.selectedImage {
                    state.isProcessingImage = true
                    return .run { send in
                        do {
                            let processedImage = try await backgroundRemovalService.removeBackground(from: image)
                            await send(.imageProcessed(processedImage))
                        } catch {
                            await send(.setError("Couldn't remove background. Using original image."))
                            await send(.imageProcessed(image))
                        }
                    }
                }
                return .none

            case let .processImage(image):
                state.selectedImage = image
                state.showPhotosPicker = false
                return .none

            case let .imageProcessed(image):
                state.selectedImage = image
                state.isProcessingImage = false
                return .none

            case let .nameChanged(name):
                state.name = name
                return .none

            case let .brandChanged(brand):
                state.brand = brand
                return .none

            case let .categoryChanged(category):
                state.category = category
                // Reset subcategory to first available for new category
                state.subCategory = state.availableSubcategories.first ?? .basicTees
                return .none

            case let .subCategoryChanged(subCategory):
                state.subCategory = subCategory
                return .none

            case let .colorToggled(color):
                if state.selectedColors.contains(color) {
                    state.selectedColors.remove(color)
                } else {
                    state.selectedColors.insert(color)
                }
                return .none

            case let .seasonToggled(season):
                if state.selectedSeasons.contains(season) {
                    state.selectedSeasons.remove(season)
                } else {
                    state.selectedSeasons.insert(season)
                }
                return .none

            case let .formalityChanged(formality):
                state.formality = formality
                return .none

            case let .notesChanged(notes):
                state.notes = notes
                return .none

            case .autoCategorizeTapped:
                guard let image = state.selectedImage,
                      let imageData = image.jpegData(compressionQuality: 0.8) else {
                    return .send(.setError("Please select an image first"))
                }
                
                state.isCategorizingWithAI = true
                state.errorMessage = nil
                
                return .run { send in
                    do {
                        let result = try await categorizationService.categorizeItem(image: imageData)
                        await send(.categorizationResponse(.success(result)))
                    } catch {
                        await send(.categorizationResponse(.failure(error)))
                    }
                }
            
            case let .categorizationResponse(.success(result)):
                state.isCategorizingWithAI = false
                
                // Update form fields with AI results
                state.category = result.category
                state.subCategory = result.subCategory
                state.selectedColors = Set(result.colors)
                state.formality = result.formality
                state.selectedSeasons = Set(result.seasons)
                state.aiConfidence = result.confidence
                state.aiGenerated = true
                
                // Set material if available
                if let material = result.materialType {
                    state.notes = state.notes.isEmpty ? "Material: \(material)" : "\(state.notes)\nMaterial: \(material)"
                }
                
                // Show warning if confidence is low
                if result.needsHumanReview {
                    return .send(.setError("AI is \(Int(result.confidence * 100))% confident. Please review and adjust if needed."))
                }
                
                return .none
            
            case let .categorizationResponse(.failure(error)):
                state.isCategorizingWithAI = false
                
                let errorMessage: String
                if let categorizationError = error as? CategorizationError {
                    switch categorizationError {
                    case .invalidImage:
                        errorMessage = "Couldn't analyze this image. Try a different photo."
                    case .networkError:
                        errorMessage = "Network error. Check your connection and try again."
                    case .apiLimitReached:
                        errorMessage = "AI limit reached. Please try again later."
                    case .timeout:
                        errorMessage = "Request timed out. Please try again."
                    default:
                        errorMessage = "Couldn't categorize item. You can still add it manually."
                    }
                } else {
                    errorMessage = "Couldn't categorize item. You can still add it manually."
                }
                
                return .send(.setError(errorMessage))

            case .saveTapped:
                guard state.selectedImage != nil else { return .none }

                // Create wardrobe item
                let item = WardrobeItem(
                    userId: state.userId,
                    name: state.name.isEmpty ? nil : state.name,
                    category: state.category,
                    subCategory: state.subCategory,
                    brand: state.brand.isEmpty ? nil : state.brand,
                    aiGenerated: state.aiGenerated,
                    colors: Array(state.selectedColors),
                    formality: state.formality,
                    seasons: Array(state.selectedSeasons),
                    aiConfidence: state.aiConfidence ?? 0.0,
                    notes: state.notes.isEmpty ? nil : state.notes
                )

                return .send(.saveComplete(item))

            case .saveComplete:
                // Handled by parent
                return .none

            case .cancelTapped:
                if state.hasChanges {
                    state.showCancelConfirmation = true
                    return .none
                } else {
                    return .run { _ in
                        await dismiss()
                    }
                }

            case .cancelConfirmationDismissed:
                state.showCancelConfirmation = false
                return .none

            case .clearError:
                state.errorMessage = nil
                return .none

            case let .setError(message):
                state.errorMessage = message
                return .none
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AddItemView(
        store: Store(
            initialState: AddItemFeature.State(userId: UUID())
        ) {
            AddItemFeature()
        }
    )
}
