# FitChekk - Feature Specifications

**For**: Product Team, Engineering, QA  
**Read Time**: 20 minutes  
**Last Updated**: November 2025

---

## Document Purpose

This document provides detailed, actionable specifications for each feature. For higher-level product vision, see [PRODUCT_VISION.md](./PRODUCT_VISION.md).

**Format**: Each feature includes:
- User story
- Acceptance criteria
- Technical requirements
- Edge cases
- Test scenarios

---

## Feature Catalog

### Core Features (MVP)
1. [Authentication](#1-authentication)
2. [Onboarding & Style Quiz](#2-onboarding--style-quiz)
3. [Wardrobe Management](#3-wardrobe-management)
4. [AI Categorization](#4-ai-categorization-premium)
5. [AI Outfit Suggestions](#5-ai-outfit-suggestions-premium)
6. [Outfit Creation](#6-outfit-creation-premium)
7. [Calendar Planner](#7-calendar-planner-premium)
8. [Home Screen](#8-home-screen)
9. [Weather Integration](#9-weather-integration)
10. [Subscription System](#10-subscription-system)

---

## 1. Authentication

### User Story
> As a user, I want to sign in securely so that my wardrobe syncs across devices.

### Acceptance Criteria

**Supported Methods**:
- ✅ Sign in with Apple (primary)
- ✅ Sign in with Google
- ✅ Email/Password
- ✅ Email verification for email/password signup
- ✅ Password reset via email

**Flow**:
1. User opens app → Sees welcome screen
2. Chooses auth method
3. Completes auth flow (OS-native for Apple/Google)
4. Redirected to onboarding (first time) or home (returning)

**Session Management**:
- ✅ JWT tokens stored securely (Keychain)
- ✅ Auto-refresh before expiry
- ✅ Sign out clears tokens
- ✅ "Remember me" persists across app launches

### Technical Requirements

**Supabase Auth Integration**:
```swift
// Sign in with Apple
let supabase = SupabaseClient.shared
let result = try await supabase.auth.signInWithApple()

// Store session
KeychainWrapper().set(result.session.accessToken, forKey: "auth_token")

// Auth state listener
supabase.auth.onAuthStateChange { event, session in
    switch event {
    case .signedIn:
        // Navigate to home
    case .signedOut:
        // Navigate to welcome
    case .tokenRefreshed:
        // Update stored token
    }
}
```

**Database**:
```sql
-- Automatically created by Supabase Auth
-- Reference in our tables:
CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    email TEXT,
    display_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Edge Cases

1. **Network Error During Sign-in**:
   - Show: "Could not connect. Check your internet and try again."
   - Action: Retry button

2. **Account Already Exists** (different provider):
   - Show: "An account with this email already exists. Sign in with [provider]."
   - Action: Redirect to correct provider

3. **Email Not Verified** (email/password):
   - Block access until verified
   - Show: "Please verify your email. Didn't receive it? [Resend]"

4. **Token Expired Mid-Session**:
   - Auto-refresh if possible
   - If refresh fails, sign out gracefully and redirect to welcome

### Test Scenarios

```gherkin
Scenario: Sign in with Apple (Happy Path)
  Given I am a new user
  When I tap "Sign in with Apple"
  And I complete Apple's auth flow
  Then I am signed in
  And I see the onboarding screen

Scenario: Sign in with existing account
  Given I have an account
  When I sign in with correct credentials
  Then I am signed in
  And I see the home screen (skip onboarding)

Scenario: Network error during sign-in
  Given I have no internet connection
  When I attempt to sign in
  Then I see "No internet connection" error
  And I can tap "Retry"

Scenario: Sign out
  Given I am signed in
  When I tap "Sign Out" in Settings
  Then I am signed out
  And I see the welcome screen
  And my session is cleared
```

---

## 2. Onboarding & Style Quiz

### User Story
> As a new user, I want to set my style preferences so that AI recommendations match my taste.

### Acceptance Criteria

**Quiz Flow**:
- ✅ 5 questions, visual and engaging
- ✅ Progress indicator shown (e.g., "3 of 5")
- ✅ Can go back to previous question
- ✅ Can skip questions (with sensible defaults)
- ✅ Completes in < 2 minutes
- ✅ Smooth transitions between questions
- ✅ Saved to database and synced

**Questions**:
1. **Style**: Multi-select from visual cards (Minimalist, Boho, Preppy, etc.)
2. **Colors**: Color palette picker (select 3-5 favorites)
3. **Lifestyle**: Work environment, activity level, social frequency
4. **Occasions**: Multi-select (Work, Casual, Date, Athletic, etc.)
5. **Climate**: Auto-filled via location (editable)

**Permissions**:
- ✅ Location request (for weather)
- ✅ Notifications request (for outfit reminders - optional, can skip)

### Technical Requirements

**Data Model**:
```swift
struct StylePreferences: Codable {
    var styles: [String] // ["Minimalist", "Classic"]
    var favoriteColors: [String] // ["navy", "white", "camel"]
    var lifestyleType: String // "remote_worker"
    var activityLevel: String // "moderate"
    var occasions: [String] // ["work", "casual", "date"]
    var climateType: String // "temperate_four_seasons"
    var location: Location?
}

struct Location: Codable {
    var latitude: Double
    var longitude: Double
    var cityName: String
}
```

**Database**:
```sql
CREATE TABLE user_preferences (
    user_id UUID PRIMARY KEY REFERENCES users(id),
    style_preferences TEXT[], -- ["minimalist", "classic"]
    favorite_colors TEXT[], -- ["navy", "white"]
    lifestyle_type TEXT,
    occasions TEXT[], -- ["work", "casual"]
    climate_type TEXT,
    latitude NUMERIC(9,6),
    longitude NUMERIC(9,6),
    onboarding_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**TCA Reducer**:
```swift
@Reducer
struct OnboardingFeature {
    @ObservableState
    struct State: Equatable {
        var currentQuestion: Int = 0
        var totalQuestions: Int = 5
        var selectedStyles: Set<String> = []
        var selectedColors: Set<String> = []
        // ... other preferences
        var isComplete: Bool = false
    }
    
    enum Action: Equatable {
        case nextButtonTapped
        case backButtonTapped
        case skipButtonTapped
        case styleSelected(String)
        case colorSelected(String)
        case savePreferences
        case saveResponse(TaskResult<Void>)
    }
}
```

### Edge Cases

1. **User Skips All Questions**:
   - Use defaults: styles = [], colors = [], climate = "temperate"
   - AI suggestions will be more generic (still works)

2. **Location Permission Denied**:
   - Ask for city name manually
   - Or use IP-based geolocation (less accurate)

3. **User Wants to Retake Quiz**:
   - Settings → "Retake Style Quiz"
   - Overwrites previous preferences

### Test Scenarios

```gherkin
Scenario: Complete onboarding (Happy Path)
  Given I am a new user
  When I complete all 5 quiz questions
  And I allow location permission
  Then my preferences are saved
  And I see "You're all set!" confirmation
  And I am redirected to home screen

Scenario: Skip questions
  Given I am on question 3
  When I tap "Skip"
  Then I advance to question 4
  And defaults are used for skipped questions

Scenario: Go back to previous question
  Given I am on question 4
  When I tap "Back"
  Then I see question 3
  And my previous answer is still selected

Scenario: Retake quiz
  Given I have completed onboarding
  When I go to Settings → "Retake Quiz"
  Then I see quiz from the beginning
  And I can update my preferences
```

---

## 3. Wardrobe Management

### User Story
> As a user, I want to add, view, edit, and organize my clothing items.

### Acceptance Criteria

**Add Item**:
- ✅ Via camera capture or photo library
- ✅ Background removal (on-device, automatic)
- ✅ AI categorization (Premium) or manual categorization (Free)
- ✅ Optional: Add name, notes
- ✅ Image compressed (<2MB)
- ✅ Saved to database and synced

**View Wardrobe**:
- ✅ Grid view (LazyVGrid, adaptive columns ~160pt)
- ✅ Filter by category (Tops, Bottoms, etc.)
- ✅ Filter by subcategory (within category)
- ✅ Search by name
- ✅ Sort: Recent, Name (A-Z), Most Worn
- ✅ Favorites filter

**Edit Item**:
- ✅ Change name, category, notes
- ✅ Toggle favorite
- ✅ Archive (hide from wardrobe, recoverable)
- ✅ Delete (with confirmation)

**Item Limits**:
- Free: 50 items max
- Premium: Unlimited

### Technical Requirements

**SwiftData Model**:
```swift
@Model
final class WardrobeItem {
    @Attribute(.unique) var id: UUID
    var name: String?
    var category: ItemCategory
    var subCategory: ItemSubCategory
    
    var originalImageURL: URL? // Full resolution
    var processedImageURL: URL? // Background removed
    var thumbnailURL: URL? // 400x400 for grid
    
    // AI attributes (Premium only)
    var aiGenerated: Bool = false
    var colors: [String] = []
    var formality: Int? // 1-5
    var styleTags: [String] = []
    var seasons: [String] = []
    
    // User metadata
    var isFavorite: Bool = false
    var isArchived: Bool = false
    var notes: String?
    
    // Usage stats
    var timesWorn: Int = 0
    var lastWornDate: Date?
    
    var userId: UUID
    var createdAt: Date
    var updatedAt: Date
}
```

**Image Processing Pipeline**:
```swift
func processImage(_ image: UIImage) async throws -> ProcessedImages {
    // 1. Remove background (Vision framework iOS 17+, Apple Intelligence iOS 18+)
    let backgroundRemoved = try await removeBackground(image)
    
    // 2. Compress for storage (<2MB)
    let compressed = await compress(backgroundRemoved, maxSizeMB: 2)
    
    // 3. Generate thumbnail (400x400)
    let thumbnail = await generateThumbnail(compressed, size: CGSize(width: 400, height: 400))
    
    // 4. Upload to Supabase Storage
    let originalURL = try await upload(image, folder: "originals")
    let processedURL = try await upload(compressed, folder: "processed")
    let thumbnailURL = try await upload(thumbnail, folder: "thumbnails")
    
    return ProcessedImages(
        originalURL: originalURL,
        processedURL: processedURL,
        thumbnailURL: thumbnailURL
    )
}
```

### Edge Cases

1. **Free User Hits 50-Item Limit**:
   - Block adding more items
   - Show upgrade prompt: "You've reached the 50-item limit. Upgrade to add unlimited items."
   - CTA: "Upgrade to Premium"

2. **Image Too Large** (>10MB original):
   - Compress before processing
   - If still fails, show: "Image is too large. Try a smaller photo."

3. **Background Removal Fails**:
   - Use original image (with background)
   - Log error for investigation
   - Continue flow normally

4. **Offline Mode**:
   - Save item locally
   - Mark as "needs sync"
   - Upload when online

5. **Sync Conflict** (edited on two devices):
   - Last-write-wins (use `updated_at` timestamp)
   - Alternative: Show conflict resolution UI (future enhancement)

### Test Scenarios

```gherkin
Scenario: Add item with camera (Premium)
  Given I am a Premium user
  When I tap "Add Item" → "Take Photo"
  And I capture a photo
  Then background is removed automatically
  And AI suggests category "Tops > Sweaters"
  When I tap "Save"
  Then item is added to my wardrobe
  And item appears in grid immediately

Scenario: Add item manually (Free)
  Given I am a Free user
  When I add an item
  Then I must select category manually
  And item is saved without AI attributes

Scenario: Hit 50-item limit (Free)
  Given I am a Free user
  And I have 50 items
  When I try to add item #51
  Then I see "Upgrade to Premium" prompt
  And item is not added

Scenario: Edit item
  Given I have an item "Blue Shirt"
  When I tap the item → tap "Edit"
  And I change name to "Navy Sweater"
  And I tap "Save"
  Then name is updated
  And updated_at timestamp is updated

Scenario: Delete item
  Given I have an item
  When I tap "Delete"
  And I confirm deletion
  Then item is removed from database
  And item disappears from grid
  And images are deleted from storage

Scenario: Filter by category
  Given I have 50 items across all categories
  When I tap "Tops" filter
  Then I see only tops items
  And count shows "12 items"
```

---

## 4. AI Categorization (Premium)

### User Story
> As a Premium user, I want AI to automatically categorize my clothing so I don't have to do it manually.

### Acceptance Criteria

**AI Analysis**:
- ✅ Analyzes image after capture
- ✅ Extracts: category, subcategory, colors, pattern, formality, style tags, seasons
- ✅ Returns confidence score (0-1)
- ✅ Completes in < 2 seconds (P95)

**Confidence Handling**:
- High (>85%): Auto-apply, show user
- Medium (70-85%): Suggest with easy override
- Low (<70%): Require user confirmation

**User Override**:
- ✅ User can change any AI suggestion
- ✅ One-tap to accept AI suggestion
- ✅ Override is logged (for future model improvement)

### Technical Requirements

**Gemini 2.5 Pro Integration**:
```swift
func categorize(image: Data) async throws -> ItemAttributes {
    let prompt = """
    Analyze this clothing item and categorize it.
    
    Categories: Tops, Bottoms, Dresses, Outerwear, Accessories, Jewelry, Footwear
    Subcategories: [Full list here]
    
    Return JSON:
    {
      "category": "tops",
      "subCategory": "sweaters",
      "colors": ["navy", "cream"],
      "pattern": "striped",
      "formality": 1, // 1=casual, 5=formal
      "styleTags": ["preppy", "classic"],
      "seasons": ["fall", "winter", "spring"],
      "confidence": 0.92
    }
    """
    
    let response = try await aiGateway.callVisionModel(
        image: image,
        prompt: prompt,
        model: "gemini-2.5-pro"
    )
    
    return try JSONDecoder().decode(ItemAttributes.self, from: response)
}
```

**Cost Tracking**:
```swift
struct AIUsage {
    var userId: UUID
    var operation: String // "categorization"
    var model: String // "gemini-2.5-pro"
    var cost: Decimal // ~$0.0001
    var timestamp: Date
}

// Track every AI call
analytics.track("ai_categorization", properties: [
    "cost": 0.0001,
    "latency_ms": 1200,
    "confidence": 0.92
])
```

### Edge Cases

1. **AI Returns Invalid Category**:
   - Fallback to "Tops" (most common)
   - Log error for investigation
   - Prompt user to select manually

2. **AI Times Out** (>5s):
   - Show error: "AI is taking too long. Categorize manually?"
   - Offer manual categorization
   - Retry button available

3. **Low Confidence** (<70%):
   - Show AI suggestion with warning: "AI is unsure. Please confirm."
   - Require user to confirm or change

4. **User Consistently Overrides AI** (>50% of time):
   - Log pattern for model improvement
   - Consider showing manual categorization by default for this user

### Test Scenarios

```gherkin
Scenario: High-confidence categorization
  Given I am a Premium user
  When I add a clear photo of a navy sweater
  Then AI categorizes as "Tops > Sweaters" (confidence 94%)
  And suggestion is auto-applied
  And I see "AI Categorized ✨"
  And I can still edit if needed

Scenario: Medium-confidence categorization
  Given AI returns confidence 75%
  When I add item
  Then AI suggestion is shown with "Confirm?" prompt
  And I must tap "Looks Good" or "Change"

Scenario: User override
  Given AI suggests "Tops > T-Shirts"
  When I change to "Tops > Sweaters"
  And I save
  Then my choice is saved
  And override is logged

Scenario: AI error handling
  Given AI service is down
  When I add an item
  Then I see "AI unavailable. Categorize manually?"
  And I can still add item manually
```

---

## 5. AI Outfit Suggestions (Premium)

### User Story
> As a Premium user, I want AI to suggest outfits based on my wardrobe, weather, and style so I don't have to think about what to wear.

### Acceptance Criteria

**Suggestion Generation**:
- ✅ Considers: wardrobe items, weather (current + 5-day), style preferences, recently worn, occasion
- ✅ Returns: outfit (3+ items), reasoning (why it works), alternatives, style score
- ✅ Completes in < 3 seconds (P95)
- ✅ First suggestion each day shown automatically on Home screen

**Suggestion Quality**:
- ✅ Weather appropriate (95%+ accuracy)
- ✅ Style consistent (matches user preferences)
- ✅ Variety (doesn't repeat within 7 days)
- ✅ User acceptance rate: >35% target

**User Interactions**:
- ✅ "Use This" → Save outfit, schedule for today
- ✅ "Suggest Another" → Generate new suggestion (unlimited)
- ✅ Tap item → See alternatives for that item

### Technical Requirements

**Claude Sonnet 4 Integration**:
```swift
func suggestOutfit(
    wardrobeItems: [WardrobeItem],
    userPreferences: UserPreferences,
    weather: WeatherSnapshot,
    occasion: OccasionType?,
    recentOutfits: [Outfit]
) async throws -> OutfitSuggestion {
    
    // Build cached context (updated daily)
    let cachedContext = """
    # User Profile
    Styles: \(userPreferences.styles.joined(separator: ", "))
    Colors: \(userPreferences.favoriteColors.joined(separator: ", "))
    Lifestyle: \(userPreferences.lifestyleType)
    
    # Wardrobe (\(wardrobeItems.count) items)
    \(wardrobeItems.map { itemJSON($0) }.joined(separator: "\n"))
    
    # Recent Outfits (Last 7 Days)
    \(recentOutfits.map { outfitJSON($0) }.joined(separator: "\n"))
    """
    
    // Build dynamic request
    let dynamicRequest = """
    # Today's Weather
    Temp: \(weather.tempHigh)°F high, \(weather.tempLow)°F low
    Condition: \(weather.condition)
    Feels like: \(weather.feelsLike)°F
    
    # Occasion
    \(occasion?.rawValue ?? "casual daily")
    
    # Instructions
    Suggest an outfit that:
    1. Matches user's style preferences
    2. Is appropriate for \(weather.tempHigh)°F weather
    3. Avoids recently worn items (prefer items not worn in 5+ days)
    4. Includes at least top, bottom, footwear
    
    Return JSON with outfit, reasoning, alternatives.
    """
    
    let response = try await aiGateway.callLanguageModel(
        systemPrompt: "You are a professional fashion stylist...",
        prompt: cachedContext + "\n\n" + dynamicRequest,
        model: "claude-sonnet-4",
        cacheKey: "user_\(userPreferences.userId)_wardrobe" // 24h cache
    )
    
    return try JSONDecoder().decode(OutfitSuggestion.self, from: response)
}
```

**Response Format**:
```swift
struct OutfitSuggestion: Codable {
    let outfit: SuggestedOutfit
    let alternatives: [OutfitAlternative]
}

struct SuggestedOutfit: Codable {
    let items: [OutfitItem] // [top, bottom, shoes, ...]
    let reasoning: String // "This navy sweater pairs..."
    let styleScore: Double // 0.94
    let weatherAppropriate: Bool // true
}

struct OutfitItem: Codable {
    let itemId: UUID
    let category: String
    let role: String // "primary_top", "bottom", "shoes"
}

struct OutfitAlternative: Codable {
    let itemToReplace: UUID
    let alternativeItem: UUID
    let reason: String // "For a softer look..."
}
```

### Edge Cases

1. **Insufficient Wardrobe** (<10 items):
   - Show: "Add more items to get better suggestions"
   - Still generate suggestion if possible (may be limited)

2. **No Items Match Weather**:
   - AI suggests best available
   - Reasoning explains: "You don't have heavy coats, but this jacket is your warmest option"

3. **All Items Worn Recently**:
   - Repeat least-recently-worn
   - Reasoning mentions: "All items worn recently, so here's a favorite combination"

4. **AI Suggests Inappropriate Outfit** (user rejects):
   - Log rejection
   - Use rejection signal for next suggestion
   - After 3 rejections, ask: "What are you looking for?" (optional feedback)

5. **Cache Expired** (first suggestion takes longer):
   - Show: "Analyzing your wardrobe..." (3-5s)
   - Subsequent suggestions faster (<2s)

### Test Scenarios

```gherkin
Scenario: Daily suggestion (Happy Path)
  Given I am a Premium user with 30+ items
  And it's 7 AM
  When I open app
  Then I see AI-suggested outfit
  And reasoning explains why it works
  And it's appropriate for today's weather
  When I tap "Use This"
  Then outfit is saved for today
  And I see success message

Scenario: Request another suggestion
  Given I see a suggestion
  When I tap "Suggest Another"
  Then a new suggestion is generated (different items)
  And it loads in < 2 seconds

Scenario: Suggestion acceptance
  Given I see a suggestion
  When I tap "Use This"
  Then outfit is saved
  And items' "last worn" dates are updated
  And outfit appears in my "Outfits" list

Scenario: View alternative items
  Given I see a suggestion with navy chinos
  When I tap the chinos
  Then I see "Try Instead:" alternatives
  And I can swap to gray pants
```

---

## Summary

This document provides detailed specifications for all core features. For implementation, refer to:
- [TECHNICAL_ARCHITECTURE.md](./TECHNICAL_ARCHITECTURE.md) - How to build
- [IMPLEMENTATION_ROADMAP.md](./IMPLEMENTATION_ROADMAP.md) - When to build
- [USER_EXPERIENCE.md](./USER_EXPERIENCE.md) - How it should feel

**For remaining features** (6-10), see full specifications in the PRD at [FitChekk-PRD-v2-2025.md](../FitChekk-PRD-v2-2025.md).

---

**Last Updated**: November 2025  
**Document Version**: 1.0

