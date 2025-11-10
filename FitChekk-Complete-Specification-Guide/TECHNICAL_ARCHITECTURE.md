# FitChekk - Technical Architecture

**For**: Engineering Team, Technical Leadership  
**Read Time**: 20 minutes  
**Last Updated**: November 2025

---

## Architecture Overview

### Core Principles

1. **Composition Over Inheritance**: TCA architecture for testable, predictable state management
2. **AI-First Design**: Every component optimized for AI-assisted development
3. **Offline-First**: App works without network, syncs when available
4. **Privacy-Respecting**: User data stays in their control (Supabase, not our servers)
5. **Cost-Efficient**: Smart AI gateway reduces API costs by 60-80%
6. **Type-Safe**: Swift 6 strict concurrency, comprehensive type safety

---

## Technology Stack

### Frontend (iOS)

```swift
Platform: iOS 17.0+
Language: Swift 6.0
UI Framework: SwiftUI
Architecture: The Composable Architecture (TCA)
Concurrency: Swift Concurrency (async/await, actors)
Data: SwiftData (modern Core Data replacement)
Networking: URLSession + async/await
Image Processing: Vision framework (background removal)
```

**Why These Choices**:

**iOS 17+**: Broad device compatibility (90% of users), Vision framework for background removal, optional iOS 18 features for enhanced experience
**Swift 6**: Strict concurrency, better type safety, modern language features
**SwiftUI**: Declarative UI, less boilerplate, faster development
**TCA**: Testable, predictable state management, excellent for AI code generation
**SwiftData**: Modern syntax, less boilerplate than Core Data, easier for AI to generate

### Backend (Supabase)

```yaml
Database: PostgreSQL 15
Authentication: Supabase Auth (Apple, Google, Email)
Storage: Supabase Storage (S3-compatible)
Realtime: Supabase Realtime (WebSocket sync)
Functions: Supabase Edge Functions (Deno)
Row-Level Security: Built-in, automatic
```

**Why Supabase**:
- ✅ **Open Source**: Not vendor-locked, can self-host
- ✅ **PostgreSQL**: Industry standard, powerful queries, JSON support
- ✅ **Realtime**: Built-in multi-device sync
- ✅ **Auth**: Multiple providers, secure by default
- ✅ **Cost**: Free tier generous, scales predictably
- ✅ **DX**: Excellent documentation, TypeScript SDK, instant APIs

### AI Infrastructure

```yaml
AI Gateway: Portkey
Primary Vision Model: Gemini 2.5 Pro
Primary Language Model: Claude Sonnet 4
Fallback Models: GPT-4o, Gemini 2.0 Flash
Prompt Management: Portkey Prompts
Cost Optimization: Automatic caching, routing, fallbacks
```

**Why Portkey**:
- ✅ **Multi-Model**: Switch models without code changes
- ✅ **Fallback**: If Claude fails, auto-switch to GPT-4o
- ✅ **Caching**: Automatic semantic caching (60-80% cost savings)
- ✅ **Analytics**: Track costs, latency, quality per model
- ✅ **A/B Testing**: Compare models in production
- ✅ **Cost**: $1,000+/month savings at scale

---

## Project Structure

```
FitChekk/
├── App/
│   ├── FitChekkApp.swift              # App entry point
│   ├── AppState.swift                  # Global app state (TCA)
│   └── AppView.swift                   # Root view
│
├── Features/                           # Feature modules (TCA)
│   ├── Wardrobe/
│   │   ├── WardrobeFeature.swift       # TCA reducer
│   │   ├── WardrobeView.swift          # Main view
│   │   ├── Components/
│   │   │   ├── ItemGridView.swift
│   │   │   ├── ItemDetailView.swift
│   │   │   └── AddItemView.swift
│   │   └── Models/
│   │       └── WardrobeItem.swift      # SwiftData model
│   │
│   ├── Outfits/
│   │   ├── OutfitFeature.swift
│   │   ├── OutfitView.swift
│   │   ├── Components/
│   │   │   ├── OutfitCanvas.swift
│   │   │   ├── OutfitSuggestion.swift
│   │   │   └── OutfitListView.swift
│   │   └── Models/
│   │       └── Outfit.swift
│   │
│   ├── Planner/
│   │   ├── PlannerFeature.swift
│   │   ├── PlannerView.swift
│   │   ├── Components/
│   │   │   ├── CalendarView.swift
│   │   │   └── DayDetailView.swift
│   │   └── Models/
│   │       └── PlannerEntry.swift
│   │
│   ├── Home/
│   │   ├── HomeFeature.swift
│   │   ├── HomeView.swift
│   │   └── Components/
│   │       ├── WeatherCard.swift
│   │       ├── OutfitSuggestionCard.swift
│   │       └── QuickActionsView.swift
│   │
│   ├── Authentication/
│   │   ├── AuthFeature.swift
│   │   ├── AuthView.swift
│   │   └── Components/
│   │       ├── SignInView.swift
│   │       └── OnboardingView.swift
│   │
│   └── Settings/
│       ├── SettingsFeature.swift
│       ├── SettingsView.swift
│       └── Components/
│           ├── ProfileView.swift
│           └── SubscriptionView.swift
│
├── Services/                           # Business logic layer
│   ├── AI/
│   │   ├── AIGateway.swift             # Portkey integration
│   │   ├── CategorizationService.swift # Gemini for categorization
│   │   ├── OutfitService.swift         # Claude for suggestions
│   │   └── PromptTemplates.swift       # Reusable prompts
│   │
│   ├── Data/
│   │   ├── SupabaseClient.swift        # Supabase SDK wrapper
│   │   ├── DatabaseService.swift       # CRUD operations
│   │   ├── StorageService.swift        # Image upload/download
│   │   └── SyncService.swift           # Realtime sync
│   │
│   ├── Authentication/
│   │   └── AuthService.swift           # Supabase Auth wrapper
│   │
│   ├── Weather/
│   │   └── WeatherService.swift        # WeatherKit integration
│   │
│   ├── Image/
│   │   ├── ImageProcessor.swift        # Background removal
│   │   └── ImageOptimizer.swift        # Compression, thumbnails
│   │
│   └── Subscription/
│       └── SubscriptionService.swift   # StoreKit 2 integration
│
├── Shared/                             # Reusable components
│   ├── Components/
│   │   ├── AsyncButton.swift           # Loading states
│   │   ├── EmptyStateView.swift        # Empty states
│   │   ├── ErrorView.swift             # Error handling
│   │   └── LoadingView.swift           # Loading indicators
│   │
│   ├── Extensions/
│   │   ├── View+Extensions.swift
│   │   ├── Color+Extensions.swift
│   │   ├── Date+Extensions.swift
│   │   └── String+Extensions.swift
│   │
│   ├── Utilities/
│   │   ├── Logger.swift                # Structured logging
│   │   ├── Analytics.swift             # Event tracking
│   │   └── FeatureFlags.swift          # Feature toggles
│   │
│   └── Models/
│       ├── Weather.swift
│       ├── Subscription.swift
│       └── User.swift
│
├── Resources/
│   ├── Assets.xcassets/                # Colors, images
│   ├── Localizable.strings             # Localization
│   └── Configuration/
│       ├── Development.xcconfig         # Dev API keys
│       ├── Production.xcconfig          # Prod API keys
│       └── Info.plist
│
└── Tests/
    ├── FitChekkTests/                  # Unit tests
    │   ├── Features/
    │   ├── Services/
    │   └── Models/
    │
    └── FitChekkUITests/                # UI tests
        └── Flows/
```

---

## Data Architecture

### SwiftData Models

#### WardrobeItem

```swift
import SwiftData
import Foundation

@Model
final class WardrobeItem {
    // MARK: - Identity
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Basic Info
    var name: String?
    var category: ItemCategory
    var subCategory: ItemSubCategory
    var brand: String?
    var purchaseDate: Date?
    var purchasePrice: Decimal?
    
    // MARK: - Images
    var originalImageURL: URL?          // Supabase Storage path
    var processedImageURL: URL?         // Background-removed version
    var thumbnailURL: URL?              // Optimized for lists
    
    // MARK: - AI-Generated Attributes (Premium only)
    var aiGenerated: Bool = false
    var colors: [String] = []           // ["navy", "cream", "white"]
    var pattern: String?                // "striped", "solid", "floral"
    var formality: FormalityLevel?
    var styleTags: [String] = []        // ["preppy", "classic"]
    var seasons: [Season] = []          // [.fall, .winter]
    var materialType: String?           // "cotton", "wool"
    var aiConfidence: Double = 0.0      // 0.0 - 1.0
    
    // MARK: - User Metadata
    var isFavorite: Bool = false
    var notes: String?
    var isArchived: Bool = false
    
    // MARK: - Usage Statistics
    var timesWorn: Int = 0
    var lastWornDate: Date?
    var wearHistory: [WearRecord] = []
    
    // MARK: - Relationships
    @Relationship(deleteRule: .nullify, inverse: \Outfit.items)
    var outfits: [Outfit] = []
    
    // MARK: - Sync
    var userId: UUID                    // Owner
    var needsSync: Bool = false
    
    init(
        id: UUID = UUID(),
        category: ItemCategory,
        subCategory: ItemSubCategory,
        userId: UUID
    ) {
        self.id = id
        self.category = category
        self.subCategory = subCategory
        self.userId = userId
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Supporting Types

enum ItemCategory: String, Codable, CaseIterable {
    case tops, bottoms, dresses, outerwear, accessories, jewelry, footwear
}

enum ItemSubCategory: String, Codable {
    // Tops
    case graphicTees, dressedUpTops, sweaters, bodysuits, activewear, buttonDowns, tanks
    // Bottoms
    case jeans, shorts, skirts, leggings, dressPants
    // ... etc
}

enum FormalityLevel: Int, Codable, CaseIterable {
    case casual = 1
    case smartCasual = 2
    case businessCasual = 3
    case business = 4
    case formal = 5
}

enum Season: String, Codable, CaseIterable {
    case spring, summer, fall, winter
}

struct WearRecord: Codable, Identifiable {
    var id: UUID = UUID()
    var date: Date
    var outfitId: UUID?
}
```

#### Outfit

```swift
import SwiftData
import Foundation

@Model
final class Outfit {
    // MARK: - Identity
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Basic Info
    var name: String
    var occasion: OccasionType?
    var season: Season?
    var notes: String?
    
    // MARK: - Images
    var canvasImageURL: URL?            // Generated outfit composition
    var userPhotoURL: URL?              // User wearing the outfit
    var thumbnailURL: URL?
    
    // MARK: - AI Metadata
    var aiGenerated: Bool = false
    var aiReasoning: String?            // Why this outfit works
    var aiStyleScore: Double?
    var weatherSnapshot: WeatherSnapshot?
    
    // MARK: - Usage
    var timesWorn: Int = 0
    var lastWornDate: Date?
    var userRating: Int?                // 1-5 stars
    
    // MARK: - Relationships
    @Relationship(deleteRule: .nullify)
    var items: [WardrobeItem] = []
    
    @Relationship(deleteRule: .cascade, inverse: \PlannerEntry.outfit)
    var plannerEntries: [PlannerEntry] = []
    
    // MARK: - Sync
    var userId: UUID
    var needsSync: Bool = false
    
    init(
        id: UUID = UUID(),
        name: String,
        userId: UUID,
        items: [WardrobeItem] = []
    ) {
        self.id = id
        self.name = name
        self.userId = userId
        self.items = items
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

enum OccasionType: String, Codable, CaseIterable {
    case work, casual, date, athletic, formal, travel, weekend
}

struct WeatherSnapshot: Codable {
    var date: Date
    var tempHigh: Double
    var tempLow: Double
    var condition: String
    var feelsLike: Double
    var humidity: Double
}
```

#### PlannerEntry

```swift
import SwiftData
import Foundation

@Model
final class PlannerEntry {
    // MARK: - Identity
    @Attribute(.unique) var date: Date  // Normalized to 00:00:00
    
    // MARK: - Relationships
    @Relationship(deleteRule: .nullify)
    var outfit: Outfit?
    
    // MARK: - Metadata
    var isWorn: Bool = false
    var markedWornAt: Date?
    var notes: String?
    
    // MARK: - Weather Cache
    var cachedWeather: WeatherSnapshot?
    
    // MARK: - Sync
    var userId: UUID
    var needsSync: Bool = false
    
    init(date: Date, userId: UUID, outfit: Outfit? = nil) {
        self.date = Calendar.current.startOfDay(for: date)
        self.userId = userId
        self.outfit = outfit
    }
}
```

### Supabase Database Schema

```sql
-- Users table (Supabase Auth handles most of this)
CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    email TEXT,
    display_name TEXT,
    subscription_tier TEXT DEFAULT 'free',
    subscription_ends_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Wardrobe items
CREATE TABLE wardrobe_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Basic info
    name TEXT,
    category TEXT NOT NULL,
    sub_category TEXT NOT NULL,
    brand TEXT,
    purchase_date DATE,
    purchase_price NUMERIC(10,2),
    
    -- Images (Supabase Storage paths)
    original_image_url TEXT,
    processed_image_url TEXT,
    thumbnail_url TEXT,
    
    -- AI attributes
    ai_generated BOOLEAN DEFAULT FALSE,
    colors TEXT[],
    pattern TEXT,
    formality INT,
    style_tags TEXT[],
    seasons TEXT[],
    material_type TEXT,
    ai_confidence NUMERIC(3,2),
    
    -- User metadata
    is_favorite BOOLEAN DEFAULT FALSE,
    notes TEXT,
    is_archived BOOLEAN DEFAULT FALSE,
    
    -- Usage stats
    times_worn INT DEFAULT 0,
    last_worn_date DATE,
    wear_history JSONB DEFAULT '[]',
    
    -- Sync
    needs_sync BOOLEAN DEFAULT FALSE,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Indexes
    CONSTRAINT wardrobe_items_user_id_idx FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX idx_wardrobe_items_user_id ON wardrobe_items(user_id);
CREATE INDEX idx_wardrobe_items_category ON wardrobe_items(category);
CREATE INDEX idx_wardrobe_items_favorite ON wardrobe_items(is_favorite) WHERE is_favorite = TRUE;

-- Outfits
CREATE TABLE outfits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Basic info
    name TEXT NOT NULL,
    occasion TEXT,
    season TEXT,
    notes TEXT,
    
    -- Images
    canvas_image_url TEXT,
    user_photo_url TEXT,
    thumbnail_url TEXT,
    
    -- AI metadata
    ai_generated BOOLEAN DEFAULT FALSE,
    ai_reasoning TEXT,
    ai_style_score NUMERIC(3,2),
    weather_snapshot JSONB,
    
    -- Usage
    times_worn INT DEFAULT 0,
    last_worn_date DATE,
    user_rating INT CHECK (user_rating BETWEEN 1 AND 5),
    
    -- Sync
    needs_sync BOOLEAN DEFAULT FALSE,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_outfits_user_id ON outfits(user_id);

-- Outfit items (many-to-many)
CREATE TABLE outfit_items (
    outfit_id UUID REFERENCES outfits(id) ON DELETE CASCADE,
    item_id UUID REFERENCES wardrobe_items(id) ON DELETE CASCADE,
    position INT NOT NULL, -- For ordering in visual canvas
    PRIMARY KEY (outfit_id, item_id)
);

-- Planner entries
CREATE TABLE planner_entries (
    date DATE NOT NULL,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    outfit_id UUID REFERENCES outfits(id) ON DELETE SET NULL,
    
    -- Metadata
    is_worn BOOLEAN DEFAULT FALSE,
    marked_worn_at TIMESTAMPTZ,
    notes TEXT,
    
    -- Weather cache
    cached_weather JSONB,
    
    -- Sync
    needs_sync BOOLEAN DEFAULT FALSE,
    
    PRIMARY KEY (date, user_id)
);

CREATE INDEX idx_planner_entries_user_id ON planner_entries(user_id);
CREATE INDEX idx_planner_entries_date ON planner_entries(date);

-- User preferences (for AI)
CREATE TABLE user_preferences (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    
    -- Style quiz results
    style_preferences TEXT[],           -- ["minimalist", "classic"]
    favorite_colors TEXT[],              -- ["navy", "white", "camel"]
    lifestyle_type TEXT,
    activity_level TEXT,
    occasion_frequency JSONB,            -- {"work": 5, "casual": 7}
    climate_type TEXT,
    
    -- Location
    location_name TEXT,
    latitude NUMERIC(9,6),
    longitude NUMERIC(9,6),
    use_device_location BOOLEAN DEFAULT TRUE,
    
    -- Profile
    display_name TEXT,
    profile_image_url TEXT,
    onboarding_completed BOOLEAN DEFAULT FALSE,
    onboarding_date TIMESTAMPTZ,
    
    -- Settings
    use_background_removal BOOLEAN DEFAULT TRUE,
    use_metric BOOLEAN DEFAULT FALSE,
    notifications_enabled BOOLEAN DEFAULT FALSE,
    notification_time TIME,
    
    -- AI settings
    ai_personalization_enabled BOOLEAN DEFAULT TRUE,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- AI cache (for cost optimization)
CREATE TABLE ai_cache (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    
    -- Cached prompt components
    cached_wardrobe_inventory TEXT,      -- JSON of all items
    cached_user_profile TEXT,            -- JSON of preferences
    cache_generated_at TIMESTAMPTZ,
    cache_valid_until TIMESTAMPTZ,
    
    -- Cost tracking
    total_api_calls_today INT DEFAULT 0,
    total_tokens_used_today INT DEFAULT 0,
    estimated_cost_today NUMERIC(10,4) DEFAULT 0,
    
    -- Rate limiting
    last_api_call_time TIMESTAMPTZ,
    api_calls_last_hour INT DEFAULT 0,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Row Level Security (RLS)
ALTER TABLE wardrobe_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE outfits ENABLE ROW LEVEL SECURITY;
ALTER TABLE planner_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_cache ENABLE ROW LEVEL SECURITY;

-- RLS Policies (users can only access their own data)
CREATE POLICY "Users can view own wardrobe items"
    ON wardrobe_items FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own wardrobe items"
    ON wardrobe_items FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own wardrobe items"
    ON wardrobe_items FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own wardrobe items"
    ON wardrobe_items FOR DELETE
    USING (auth.uid() = user_id);

-- Similar policies for other tables...

-- Functions for updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_wardrobe_items_updated_at BEFORE UPDATE
    ON wardrobe_items FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Similar triggers for other tables...
```

---

## The Composable Architecture (TCA)

### Why TCA?

**Perfect for AI-Assisted Development**:
- ✅ Predictable patterns → AI generates correct code
- ✅ Explicit state → Easy to understand and modify
- ✅ Testable by design → AI can generate comprehensive tests
- ✅ Composable → Features are independent modules
- ✅ Side effects isolated → Clear separation of concerns

### Example Feature: WardrobeFeature

```swift
import ComposableArchitecture
import SwiftData

@Reducer
struct WardrobeFeature {
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var items: [WardrobeItem] = []
        var selectedCategory: ItemCategory?
        var selectedSubCategory: ItemSubCategory?
        var searchQuery: String = ""
        var isLoading: Bool = false
        var errorMessage: String?
        
        // Child features
        @Presents var addItem: AddItemFeature.State?
        @Presents var itemDetail: ItemDetailFeature.State?
        
        // Computed
        var filteredItems: [WardrobeItem] {
            items
                .filter { item in
                    if let category = selectedCategory, item.category != category {
                        return false
                    }
                    if let subCategory = selectedSubCategory, item.subCategory != subCategory {
                        return false
                    }
                    if !searchQuery.isEmpty {
                        return item.name?.localizedCaseInsensitiveContains(searchQuery) ?? false
                    }
                    return !item.isArchived
                }
                .sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    // MARK: - Actions
    enum Action: Equatable {
        // User actions
        case onAppear
        case addItemButtonTapped
        case itemTapped(WardrobeItem)
        case categoryFilterChanged(ItemCategory?)
        case searchQueryChanged(String)
        case toggleFavorite(WardrobeItem)
        case deleteItem(WardrobeItem)
        
        // System actions
        case loadItemsResponse(TaskResult<[WardrobeItem]>)
        case itemsUpdated([WardrobeItem])
        
        // Child actions
        case addItem(PresentationAction<AddItemFeature.Action>)
        case itemDetail(PresentationAction<ItemDetailFeature.Action>)
    }
    
    // MARK: - Dependencies
    @Dependency(\.databaseService) var database
    @Dependency(\.syncService) var sync
    @Dependency(\.logger) var logger
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    let result = await TaskResult {
                        try await database.fetchWardrobeItems()
                    }
                    await send(.loadItemsResponse(result))
                }
                
            case .addItemButtonTapped:
                state.addItem = AddItemFeature.State()
                return .none
                
            case let .itemTapped(item):
                state.itemDetail = ItemDetailFeature.State(item: item)
                return .none
                
            case let .categoryFilterChanged(category):
                state.selectedCategory = category
                state.selectedSubCategory = nil
                return .none
                
            case let .searchQueryChanged(query):
                state.searchQuery = query
                return .none
                
            case let .toggleFavorite(item):
                return .run { _ in
                    var updatedItem = item
                    updatedItem.isFavorite.toggle()
                    updatedItem.needsSync = true
                    try await database.updateWardrobeItem(updatedItem)
                    await sync.scheduleSync()
                }
                
            case let .deleteItem(item):
                return .run { send in
                    try await database.deleteWardrobeItem(item.id)
                    await sync.scheduleSync()
                    let items = try await database.fetchWardrobeItems()
                    await send(.itemsUpdated(items))
                }
                
            case let .loadItemsResponse(.success(items)):
                state.isLoading = false
                state.items = items
                logger.info("Loaded \(items.count) wardrobe items")
                return .none
                
            case let .loadItemsResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                logger.error("Failed to load items: \(error)")
                return .none
                
            case let .itemsUpdated(items):
                state.items = items
                return .none
                
            case .addItem(.presented(.delegate(.itemAdded))):
                state.addItem = nil
                return .run { send in
                    let items = try await database.fetchWardrobeItems()
                    await send(.itemsUpdated(items))
                }
                
            case .addItem:
                return .none
                
            case .itemDetail:
                return .none
            }
        }
        .ifLet(\.$addItem, action: \.addItem) {
            AddItemFeature()
        }
        .ifLet(\.$itemDetail, action: \.itemDetail) {
            ItemDetailFeature()
        }
    }
}

// MARK: - View

struct WardrobeView: View {
    @Bindable var store: StoreOf<WardrobeFeature>
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Category filter
                    CategoryFilterView(
                        selectedCategory: store.selectedCategory,
                        onCategorySelected: { store.send(.categoryFilterChanged($0)) }
                    )
                    
                    // Items grid
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)]) {
                        ForEach(store.filteredItems) { item in
                            ItemCardView(item: item)
                                .onTapGesture {
                                    store.send(.itemTapped(item))
                                }
                                .contextMenu {
                                    Button("Favorite") {
                                        store.send(.toggleFavorite(item))
                                    }
                                    Button("Delete", role: .destructive) {
                                        store.send(.deleteItem(item))
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("My Wardrobe")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        store.send(.addItemButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $store.searchQuery.sending(\.searchQueryChanged))
            .sheet(item: $store.scope(state: \.addItem, action: \.addItem)) { store in
                AddItemView(store: store)
            }
            .sheet(item: $store.scope(state: \.itemDetail, action: \.itemDetail)) { store in
                ItemDetailView(store: store)
            }
            .overlay {
                if store.isLoading {
                    LoadingView()
                }
            }
            .alert(
                "Error",
                isPresented: $store.errorMessage.isPresent(),
                actions: {
                    Button("OK") { store.errorMessage = nil }
                },
                message: {
                    Text(store.errorMessage ?? "")
                }
            )
            .task {
                store.send(.onAppear)
            }
        }
    }
}
```

---

## AI Integration Architecture

### Portkey Gateway Setup

```swift
import Foundation

struct PortkeyConfig {
    static let apiKey = Bundle.main.object(forInfoDictionaryKey: "PORTKEY_API_KEY") as! String
    static let baseURL = "https://api.portkey.ai/v1"
    
    // Virtual keys for different models
    static let geminiKey = "pk_gemini_vision"
    static let claudeKey = "pk_claude_sonnet"
    static let fallbackKey = "pk_gpt4o"
}

final class AIGateway: Sendable {
    private let session: URLSession
    private let logger: Logger
    
    init(session: URLSession = .shared, logger: Logger = .default) {
        self.session = session
        self.logger = logger
    }
    
    func callVisionModel(
        image: Data,
        prompt: String,
        cacheKey: String? = nil
    ) async throws -> VisionResponse {
        let request = VisionRequest(
            model: "gemini-2.5-pro",
            image: image.base64EncodedString(),
            prompt: prompt,
            cacheKey: cacheKey
        )
        
        var urlRequest = URLRequest(url: URL(string: "\(PortkeyConfig.baseURL)/chat/completions")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(PortkeyConfig.apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue(PortkeyConfig.geminiKey, forHTTPHeaderField: "x-portkey-virtual-key")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let cacheKey = cacheKey {
            urlRequest.setValue(cacheKey, forHTTPHeaderField: "x-portkey-cache-key")
            urlRequest.setValue("3600", forHTTPHeaderField: "x-portkey-cache-ttl") // 1 hour
        }
        
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIError.invalidResponse
        }
        
        // Track costs
        if let cost = httpResponse.value(forHTTPHeaderField: "x-portkey-cost") {
            logger.info("AI call cost: $\(cost)")
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("AI call failed: \(httpResponse.statusCode)")
            throw AIError.requestFailed(statusCode: httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(VisionResponse.self, from: data)
    }
    
    func callLanguageModel(
        prompt: String,
        systemPrompt: String? = nil,
        cacheKey: String? = nil,
        temperature: Double = 0.7
    ) async throws -> LanguageResponse {
        let request = LanguageRequest(
            model: "claude-sonnet-4-20250514",
            messages: [
                Message(role: "system", content: systemPrompt ?? "You are a helpful fashion stylist."),
                Message(role: "user", content: prompt)
            ],
            temperature: temperature,
            maxTokens: 2048
        )
        
        var urlRequest = URLRequest(url: URL(string: "\(PortkeyConfig.baseURL)/chat/completions")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(PortkeyConfig.apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue(PortkeyConfig.claudeKey, forHTTPHeaderField: "x-portkey-virtual-key")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Enable prompt caching
        if let cacheKey = cacheKey {
            urlRequest.setValue(cacheKey, forHTTPHeaderField: "x-portkey-cache-key")
            urlRequest.setValue("86400", forHTTPHeaderField: "x-portkey-cache-ttl") // 24 hours
        }
        
        // Enable automatic fallback
        urlRequest.setValue(PortkeyConfig.fallbackKey, forHTTPHeaderField: "x-portkey-fallback-virtual-keys")
        urlRequest.setValue("3", forHTTPHeaderField: "x-portkey-retry-count")
        
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIError.invalidResponse
        }
        
        // Track performance
        if let latency = httpResponse.value(forHTTPHeaderField: "x-portkey-latency") {
            logger.info("AI latency: \(latency)ms")
        }
        if let cacheHit = httpResponse.value(forHTTPHeaderField: "x-portkey-cache-hit") {
            logger.info("Cache hit: \(cacheHit)")
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("AI call failed: \(httpResponse.statusCode)")
            throw AIError.requestFailed(statusCode: httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(LanguageResponse.self, from: data)
    }
}

enum AIError: Error {
    case invalidResponse
    case requestFailed(statusCode: Int)
    case decodingFailed
}
```

### Categorization Service (Gemini)

```swift
import Foundation

struct CategorizationService {
    private let gateway: AIGateway
    private let logger: Logger
    
    init(gateway: AIGateway = AIGateway(), logger: Logger = .default) {
        self.gateway = gateway
        self.logger = logger
    }
    
    func categorizeItem(image: Data) async throws -> ItemAttributes {
        let prompt = """
        Analyze this clothing item and provide detailed categorization.
        
        Categories and subcategories:
        - Tops: graphicTees, dressedUpTops, sweaters, bodysuits, activewear, buttonDowns, tanks
        - Bottoms: jeans, shorts, skirts, leggings, dressPants
        - Dresses: dayDresses, partyDresses, rompers, maxiDresses, casualDresses
        - Outerwear: jackets, coats, blazers, rainJackets
        - Accessories: hats, bags, belts, sunglasses, scarves
        - Jewelry: necklaces, bracelets, rings, earrings, watches
        - Footwear: heels, flats, sneakers, boots, socks
        
        Return JSON with:
        {
          "category": "tops",
          "subCategory": "sweaters",
          "colors": ["navy", "cream"],
          "pattern": "striped",
          "formality": 1,  // 1=casual, 2=smart-casual, 3=business-casual, 4=business, 5=formal
          "styleTags": ["preppy", "classic", "nautical"],
          "seasons": ["fall", "winter", "spring"],
          "materialType": "knit",
          "confidence": 0.92  // 0.0-1.0
        }
        """
        
        logger.info("Categorizing item...")
        
        let response = try await gateway.callVisionModel(
            image: image,
            prompt: prompt,
            cacheKey: nil // Don't cache categorization (unique per image)
        )
        
        guard let jsonString = response.choices.first?.message.content,
              let jsonData = jsonString.data(using: .utf8) else {
            throw AIError.decodingFailed
        }
        
        let attributes = try JSONDecoder().decode(ItemAttributes.self, from: jsonData)
        
        logger.info("Categorized as: \(attributes.category)/\(attributes.subCategory) (confidence: \(attributes.confidence))")
        
        return attributes
    }
}

struct ItemAttributes: Codable {
    let category: String
    let subCategory: String
    let colors: [String]
    let pattern: String?
    let formality: Int
    let styleTags: [String]
    let seasons: [String]
    let materialType: String?
    let confidence: Double
}
```

### Outfit Suggestion Service (Claude)

```swift
import Foundation

struct OutfitService {
    private let gateway: AIGateway
    private let logger: Logger
    
    init(gateway: AIGateway = AIGateway(), logger: Logger = .default) {
        self.gateway = gateway
        self.logger = logger
    }
    
    func suggestOutfit(
        wardrobeItems: [WardrobeItem],
        userPreferences: UserPreferences,
        weather: WeatherSnapshot,
        occasion: OccasionType?,
        recentOutfits: [Outfit]
    ) async throws -> OutfitSuggestion {
        // Build cached context (wardrobe + preferences)
        let cachedContext = buildCachedContext(
            wardrobeItems: wardrobeItems,
            preferences: userPreferences,
            recentOutfits: recentOutfits
        )
        
        // Build dynamic request (weather + occasion)
        let dynamicRequest = buildDynamicRequest(
            weather: weather,
            occasion: occasion
        )
        
        let systemPrompt = """
        You are a professional fashion stylist. Create outfit suggestions that:
        1. Match the user's personal style
        2. Are appropriate for the weather
        3. Avoid recently worn items (unless necessary)
        4. Create cohesive, stylish combinations
        5. Provide clear reasoning
        
        Always return valid JSON.
        """
        
        let fullPrompt = """
        # User Context (Cached)
        \(cachedContext)
        
        # Today's Request
        \(dynamicRequest)
        
        # Task
        Suggest a complete outfit from the wardrobe that meets all criteria.
        
        Return JSON:
        {
          "outfit": {
            "items": [
              {"itemId": "uuid", "category": "tops", "role": "primary_top"},
              {"itemId": "uuid", "category": "bottoms", "role": "bottom"},
              {"itemId": "uuid", "category": "footwear", "role": "shoes"}
            ],
            "reasoning": "Detailed explanation of why this outfit works",
            "styleScore": 0.94,
            "weatherAppropriate": true
          },
          "alternatives": [
            {
              "itemToReplace": "uuid",
              "alternativeItem": "uuid",
              "reason": "Why this alternative works"
            }
          ]
        }
        """
        
        logger.info("Requesting outfit suggestion...")
        
        let cacheKey = "wardrobe_\(userPreferences.userId)_\(wardrobeItems.count)"
        
        let response = try await gateway.callLanguageModel(
            prompt: fullPrompt,
            systemPrompt: systemPrompt,
            cacheKey: cacheKey,  // Cache user context for 24h
            temperature: 0.8
        )
        
        guard let jsonString = response.choices.first?.message.content,
              let jsonData = jsonString.data(using: .utf8) else {
            throw AIError.decodingFailed
        }
        
        let suggestion = try JSONDecoder().decode(OutfitSuggestion.self, from: jsonData)
        
        logger.info("Suggestion generated (score: \(suggestion.outfit.styleScore))")
        
        return suggestion
    }
    
    private func buildCachedContext(
        wardrobeItems: [WardrobeItem],
        preferences: UserPreferences,
        recentOutfits: [Outfit]
    ) -> String {
        // Convert wardrobe to JSON for AI
        let itemsJSON = wardrobeItems.map { item in
            """
            {
              "id": "\(item.id.uuidString)",
              "category": "\(item.category.rawValue)",
              "subCategory": "\(item.subCategory.rawValue)",
              "colors": \(item.colors),
              "formality": \(item.formality?.rawValue ?? 1),
              "styleTags": \(item.styleTags),
              "seasons": \(item.seasons.map(\.rawValue)),
              "isFavorite": \(item.isFavorite),
              "lastWornDate": "\(item.lastWornDate?.ISO8601Format() ?? "never")",
              "timesWorn": \(item.timesWorn)
            }
            """
        }.joined(separator: ",\n")
        
        return """
        ## User Profile
        - Style: \(preferences.stylePreferences.joined(separator: ", "))
        - Favorite Colors: \(preferences.favoriteColors.joined(separator: ", "))
        - Lifestyle: \(preferences.lifestyleType ?? "not specified")
        
        ## Wardrobe (\(wardrobeItems.count) items)
        [\(itemsJSON)]
        
        ## Recent Outfits (Last 7 Days)
        \(recentOutfits.map { "- \($0.name): \($0.items.map(\.id.uuidString))" }.joined(separator: "\n"))
        """
    }
    
    private func buildDynamicRequest(
        weather: WeatherSnapshot,
        occasion: OccasionType?
    ) -> String {
        """
        ## Weather
        - Temperature: \(Int(weather.tempHigh))°F high, \(Int(weather.tempLow))°F low
        - Condition: \(weather.condition)
        - Feels Like: \(Int(weather.feelsLike))°F
        - Humidity: \(Int(weather.humidity))%
        
        ## Occasion
        \(occasion?.rawValue ?? "casual daily activities")
        
        ## Requirements
        - Must include: top, bottom, footwear (minimum)
        - Weather appropriate for \(Int(weather.tempHigh))°F
        - Avoid items worn in last 3 days if possible
        - Match user's style preferences
        - Consider occasion: \(occasion?.rawValue ?? "casual")
        """
    }
}

struct OutfitSuggestion: Codable {
    let outfit: SuggestedOutfit
    let alternatives: [OutfitAlternative]
}

struct SuggestedOutfit: Codable {
    let items: [OutfitItem]
    let reasoning: String
    let styleScore: Double
    let weatherAppropriate: Bool
}

struct OutfitItem: Codable {
    let itemId: String
    let category: String
    let role: String
}

struct OutfitAlternative: Codable {
    let itemToReplace: String
    let alternativeItem: String
    let reason: String
}
```

---

## Networking & Sync

### Supabase Client

```swift
import Foundation
import Supabase

final class SupabaseClient {
    static let shared = SupabaseClient()
    
    private let client: SupabaseClient
    
    private init() {
        guard let supabaseURL = URL(string: Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as! String),
              let supabaseKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as! String else {
            fatalError("Supabase configuration missing")
        }
        
        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
    
    var auth: AuthClient {
        client.auth
    }
    
    var database: DatabaseClient {
        client.database
    }
    
    var storage: StorageClient {
        client.storage
    }
    
    var realtime: RealtimeClient {
        client.realtime
    }
}
```

### Sync Service

```swift
import Foundation
import Supabase

final class SyncService {
    private let supabase = SupabaseClient.shared
    private let logger = Logger.default
    
    func syncWardrobeItems(userId: UUID) async throws {
        logger.info("Syncing wardrobe items...")
        
        // Fetch items that need sync from local database
        let itemsNeedingSync = try await fetchLocalItemsNeedingSync(userId: userId)
        
        // Upload to Supabase
        for item in itemsNeedingSync {
            try await uploadItem(item)
        }
        
        // Fetch any changes from Supabase
        let remoteChanges = try await fetchRemoteChanges(userId: userId)
        
        // Merge into local database
        for item in remoteChanges {
            try await mergeItem(item)
        }
        
        logger.info("Sync complete: \(itemsNeedingSync.count) uploaded, \(remoteChanges.count) downloaded")
    }
    
    private func uploadItem(_ item: WardrobeItem) async throws {
        // Convert to JSON
        let json = try JSONEncoder().encode(item)
        
        // Upload to Supabase
        try await supabase.database
            .from("wardrobe_items")
            .upsert(json)
            .execute()
        
        // Mark as synced locally
        var updatedItem = item
        updatedItem.needsSync = false
        // Update local database...
    }
    
    private func fetchRemoteChanges(userId: UUID) async throws -> [WardrobeItem] {
        let response = try await supabase.database
            .from("wardrobe_items")
            .select()
            .eq("user_id", value: userId.uuidString)
            .gt("updated_at", value: lastSyncTimestamp())
            .execute()
        
        return try JSONDecoder().decode([WardrobeItem].self, from: response.data)
    }
}
```

---

## Testing Strategy

### Unit Tests (TCA)

```swift
import XCTest
import ComposableArchitecture
@testable import FitChekk

@MainActor
final class WardrobeFeatureTests: XCTestCase {
    func testLoadItems() async {
        let store = TestStore(initialState: WardrobeFeature.State()) {
            WardrobeFeature()
        } withDependencies: {
            $0.databaseService = .mock(items: [
                .mock(name: "Blue Shirt", category: .tops),
                .mock(name: "Black Pants", category: .bottoms)
            ])
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(\.loadItemsResponse.success) {
            $0.isLoading = false
            $0.items = [
                .mock(name: "Blue Shirt", category: .tops),
                .mock(name: "Black Pants", category: .bottoms)
            ]
        }
    }
    
    func testCategoryFilter() async {
        let store = TestStore(
            initialState: WardrobeFeature.State(
                items: [
                    .mock(name: "Shirt", category: .tops),
                    .mock(name: "Pants", category: .bottoms)
                ]
            )
        ) {
            WardrobeFeature()
        }
        
        await store.send(.categoryFilterChanged(.tops)) {
            $0.selectedCategory = .tops
        }
        
        XCTAssertEqual(store.state.filteredItems.count, 1)
        XCTAssertEqual(store.state.filteredItems.first?.name, "Shirt")
    }
}
```

---

## Performance Optimization

### Image Optimization

```swift
import UIKit
import Vision

final class ImageProcessor {
    func processImage(_ image: UIImage) async throws -> ProcessedImage {
        // 1. Remove background
        let backgroundRemoved = try await removeBackground(image)
        
        // 2. Optimize for storage
        let optimized = try await optimizeForStorage(backgroundRemoved)
        
        // 3. Generate thumbnail
        let thumbnail = try await generateThumbnail(optimized)
        
        return ProcessedImage(
            original: image,
            processed: optimized,
            thumbnail: thumbnail
        )
    }
    
    @available(iOS 18.0, *)
    private func removeBackground(_ image: UIImage) async throws -> UIImage {
        let request = VNGeneratePersonSegmentationRequest()
        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        
        try handler.perform([request])
        
        guard let mask = request.results?.first?.pixelBuffer else {
            throw ImageError.backgroundRemovalFailed
        }
        
        return try await applyMask(mask, to: image)
    }
    
    private func optimizeForStorage(_ image: UIImage) async -> UIImage {
        // Resize to max 2000px width
        let maxWidth: CGFloat = 2000
        if image.size.width > maxWidth {
            let scale = maxWidth / image.size.width
            let newHeight = image.size.height * scale
            let newSize = CGSize(width: maxWidth, height: newHeight)
            
            return await image.byPreparingThumbnail(ofSize: newSize) ?? image
        }
        
        return image
    }
    
    private func generateThumbnail(_ image: UIImage) async -> UIImage {
        let thumbnailSize = CGSize(width: 400, height: 400)
        return await image.byPreparingThumbnail(ofSize: thumbnailSize) ?? image
    }
}
```

---

**Continue reading**:
- [AI_DEVELOPMENT_GUIDE.md](./AI_DEVELOPMENT_GUIDE.md) - How to leverage AI for development
- [IMPLEMENTATION_ROADMAP.md](./IMPLEMENTATION_ROADMAP.md) - Step-by-step build plan
- [DEVELOPMENT_STANDARDS.md](./DEVELOPMENT_STANDARDS.md) - Code quality & testing

---

**Last Updated**: November 2025  
**Document Version**: 1.0

