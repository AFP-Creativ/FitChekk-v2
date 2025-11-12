//
//  BatchCategorizationView.swift
//  FitChekk
//
//  View for batch AI categorization of existing wardrobe items
//

import SwiftUI
import ComposableArchitecture

@MainActor
struct BatchCategorizationView: View {
    @Bindable var store: StoreOf<BatchCategorizationFeature>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.lg) {
                if store.isProcessing {
                    // Processing State
                    processingView
                } else if store.isComplete {
                    // Complete State
                    completionView
                } else {
                    // Initial State
                    initialView
                }
            }
            .padding(Spacing.md)
            .background(Color.backgroundPrimary)
            .navigationTitle("Batch Categorization")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Initial View
    
    private var initialView: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            Image(systemName: "sparkles.rectangle.stack")
                .font(.system(size: 60))
                .foregroundColor(Color.accentPrimary)
            
            VStack(spacing: Spacing.sm) {
                Text("Auto-Categorize Your Wardrobe")
                    .font(Font.displayMedium)
                    .foregroundColor(Color.textPrimary)
                
                Text("Found \(store.itemsToProcess.count) items that haven't been AI-categorized yet.")
                    .font(Font.bodyMedium)
                    .foregroundColor(Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Automatic category detection")
                        .font(Font.bodyRegular)
                }
                
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Color and pattern recognition")
                        .font(Font.bodyRegular)
                }
                
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Season and formality suggestions")
                        .font(Font.bodyRegular)
                }
            }
            .padding(Spacing.md)
            .background(Color.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Spacer()
            
            VStack(spacing: Spacing.sm) {
                PrimaryButton(
                    title: "Start Categorization",
                    action: { store.send(.startProcessing) }
                )
                
                Text("This may take a few minutes")
                    .font(Font.captionRegular)
                    .foregroundColor(Color.textTertiary)
            }
        }
    }
    
    // MARK: - Processing View
    
    private var processingView: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            // Progress Indicator
            ZStack {
                Circle()
                    .stroke(Color.backgroundSecondary, lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: store.progress)
                    .stroke(Color.accentPrimary, lineWidth: 8)
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.5), value: store.progress)
                
                VStack(spacing: 4) {
                    Text("\(Int(store.progress * 100))%")
                        .font(Font.displayMedium)
                        .foregroundColor(Color.textPrimary)
                    
                    Text("\(store.processedCount)/\(store.totalCount)")
                        .font(Font.captionRegular)
                        .foregroundColor(Color.textSecondary)
                }
            }
            
            VStack(spacing: Spacing.sm) {
                Text("Analyzing items...")
                    .font(Font.headlineMedium)
                    .foregroundColor(Color.textPrimary)
                
                Text("Please don't close this screen")
                    .font(Font.bodyRegular)
                    .foregroundColor(Color.textSecondary)
            }
            
            if let currentItem = store.currentItemName {
                Text("Processing: \(currentItem)")
                    .font(Font.captionRegular)
                    .foregroundColor(Color.textTertiary)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Completion View
    
    private var completionView: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            VStack(spacing: Spacing.sm) {
                Text("All Done!")
                    .font(Font.displayMedium)
                    .foregroundColor(Color.textPrimary)
                
                Text("Successfully categorized \(store.successCount) of \(store.totalCount) items")
                    .font(Font.bodyMedium)
                    .foregroundColor(Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if store.failedCount > 0 {
                VStack(spacing: Spacing.xs) {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("\(store.failedCount) items couldn't be categorized")
                            .font(Font.bodyRegular)
                    }
                    
                    Text("You can categorize these manually")
                        .font(Font.captionRegular)
                        .foregroundColor(Color.textTertiary)
                }
                .padding(Spacing.md)
                .background(Color.backgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Spacer()
            
            PrimaryButton(
                title: "Done",
                action: { dismiss() }
            )
        }
    }
}

// MARK: - BatchCategorizationFeature

@Reducer
struct BatchCategorizationFeature {
    @ObservableState
    struct State: Equatable {
        var itemsToProcess: [WardrobeItem] = []
        var isProcessing = false
        var isComplete = false
        var processedCount = 0
        var successCount = 0
        var failedCount = 0
        var currentItemName: String?
        
        var totalCount: Int {
            itemsToProcess.count
        }
        
        var progress: Double {
            guard totalCount > 0 else { return 0 }
            return Double(processedCount) / Double(totalCount)
        }
    }
    
    enum Action: Equatable {
        case startProcessing
        case processNextItem
        case itemProcessed(success: Bool, itemName: String)
        case processingComplete
    }
    
    @Dependency(\.categorizationService) var categorizationService
    @Dependency(\.databaseService) var databaseService
    @Dependency(\.imageService) var imageService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startProcessing:
                state.isProcessing = true
                state.processedCount = 0
                state.successCount = 0
                state.failedCount = 0
                return .send(.processNextItem)
                
            case .processNextItem:
                guard state.processedCount < state.totalCount else {
                    return .send(.processingComplete)
                }
                
                let item = state.itemsToProcess[state.processedCount]
                state.currentItemName = item.displayName
                
                return .run { send in
                    // Download image
                    guard let imageURL = item.imageURL,
                          let imageData = try? await downloadImage(from: imageURL) else {
                        await send(.itemProcessed(success: false, itemName: item.displayName))
                        return
                    }
                    
                    do {
                        // Categorize
                        let result = try await categorizationService.categorizeItem(image: imageData)
                        
                        // Update item
                        try await updateItem(item, with: result)
                        
                        await send(.itemProcessed(success: true, itemName: item.displayName))
                    } catch {
                        await send(.itemProcessed(success: false, itemName: item.displayName))
                    }
                }
                
            case let .itemProcessed(success, _):
                state.processedCount += 1
                if success {
                    state.successCount += 1
                } else {
                    state.failedCount += 1
                }
                
                // Add small delay between items to avoid rate limiting
                return .run { send in
                    try await Task.sleep(nanoseconds: 500_000_000) // 0.5s
                    await send(.processNextItem)
                }
                
            case .processingComplete:
                state.isProcessing = false
                state.isComplete = true
                state.currentItemName = nil
                return .none
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func downloadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    private func updateItem(_ item: WardrobeItem, with result: CategorizationResult) async throws {
        // Update item properties
        item.category = result.category.rawValue
        item.subCategory = result.subCategory.rawValue
        item.colors = result.colors
        item.pattern = result.pattern
        item.formality = result.formality.rawValue
        item.seasons = result.seasons.map { $0.rawValue }
        item.materialType = result.materialType
        item.aiGenerated = true
        item.aiConfidence = result.confidence
        item.needsSync = true
        
        // Save to database
        _ = try await databaseService.updateWardrobeItem(item)
    }
}

// MARK: - Preview

#Preview {
    BatchCategorizationView(
        store: Store(
            initialState: BatchCategorizationFeature.State(
                itemsToProcess: [
                    WardrobeItem(
                        userId: UUID(),
                        category: .tops,
                        subCategory: .basicTees
                    ),
                    WardrobeItem(
                        userId: UUID(),
                        category: .bottoms,
                        subCategory: .jeans
                    )
                ]
            )
        ) {
            BatchCategorizationFeature()
        }
    )
}
