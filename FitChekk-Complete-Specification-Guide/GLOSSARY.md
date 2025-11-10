# FitChekk - Glossary

**For**: All Team Members  
**Last Updated**: November 2025

---

## How to Use This Glossary

- **Bold** terms are defined in this glossary
- *Italic* terms are industry-standard
- Terms are organized alphabetically within categories

---

## Business & Product Terms

### A

**Acceptance Rate**  
Percentage of AI outfit suggestions that users accept (tap "Use This Outfit"). Target: 40%+.

**Active User**  
User who opens the app at least once in a given time period.

### B

**Beta**  
Pre-launch version of app available to limited testers via TestFlight. Used to gather feedback before public launch.

### C

**CAC (Customer Acquisition Cost)**  
Average cost to acquire one paying customer. Target: <$20. Calculated as: Total marketing spend / New paying customers.

**Churn Rate**  
Percentage of subscribers who cancel per month. Target: <5%. Formula: (Cancellations / Total subscribers) × 100.

**Conversion Rate**  
Percentage of free users who upgrade to Premium. Target: 15% after 30 days.

### D

**DAU (Daily Active Users)**  
Number of unique users who open the app each day.

**DAU/MAU Ratio**  
Daily Active Users divided by Monthly Active Users. Measures engagement "stickiness". Target: 40%+. Formula: (DAU / MAU) × 100.

### F

**Feature Gate**  
Logic that restricts features to specific user tiers (Free vs. Premium). Example: AI suggestions are feature-gated to Premium users only.

**Freemium**  
Business model where basic app is free, advanced features require paid subscription. FitChekk model: Free tier (50 items, manual), Premium tier (unlimited, AI).

### K

**K-Factor**  
Viral growth coefficient. Measures how many new users each user brings. Formula: (Invites sent per user × Conversion rate). Target: 2.0+ (each user brings 2 more).

**KPI (Key Performance Indicator)**  
Metric used to measure success. FitChekk KPIs: Downloads, conversion rate, retention, NPS.

### L

**LTV (Lifetime Value)**  
Total revenue expected from average customer over their lifetime. FitChekk LTV: $75 (14-month average subscription). Formula: (Average subscription value × Average months subscribed).

**LTV:CAC Ratio**  
Lifetime Value divided by Customer Acquisition Cost. Healthy: >3:1. FitChekk target: 5:1 ($75 LTV / $15 CAC).

### M

**MAU (Monthly Active Users)**  
Number of unique users who open the app in a given month.

**MRR (Monthly Recurring Revenue)**  
Predictable monthly revenue from subscriptions. Month 12 target: $105K.

**MVP (Minimum Viable Product)**  
Simplest version of product that delivers core value. FitChekk MVP: Wardrobe + AI categorization + outfit suggestions + planner.

### N

**NPS (Net Promoter Score)**  
Metric measuring customer satisfaction. Scale: -100 to +100. FitChekk target: 60+. Formula: % Promoters (9-10 rating) - % Detractors (0-6 rating).

### P

**Paywall**  
UI screen prompting free users to upgrade to Premium. Triggered when accessing Premium features.

**Premium Tier**  
Paid subscription ($7.99/month, $59.99/year) unlocking AI features, unlimited items, outfit creation, calendar planning.

### R

**Retention Rate**  
Percentage of users who return to app after first use. Day 1: 40%, Day 7: 25%, Day 30: 15% (industry averages).

### S

**Subscription Tier**  
User's payment level. FitChekk has two tiers: Free and Premium.

### T

**TestFlight**  
Apple's platform for distributing beta versions of iOS apps to testers before public release.

---

## Technical Terms

### A

**API (Application Programming Interface)**  
Way for software to communicate with other software. FitChekk uses APIs for: Supabase (database), Portkey (AI), WeatherKit (weather).

**ARR (Annual Recurring Revenue)**  
Yearly predictable revenue from subscriptions. Formula: MRR × 12.

**Async/Await**  
Swift pattern for writing asynchronous code that reads like synchronous. Replaces callback hell.
```swift
// Old way (callbacks)
fetchData { result in
    processData(result) { processed in
        saveData(processed) { _ in
            print("Done")
        }
    }
}

// New way (async/await)
let result = await fetchData()
let processed = await processData(result)
await saveData(processed)
print("Done")
```

### B

**Background Removal**  
Process of removing image background, isolating subject (clothing). Uses Apple Intelligence (iOS 18+) or Vision framework (iOS 17).

### C

**Cache / Caching**  
Storing data temporarily for faster access later. Types:
- **HTTP Cache**: Store API responses
- **Image Cache**: Store downloaded images
- **Prompt Cache**: Store AI prompt context (60-80% cost savings)

**CI/CD (Continuous Integration / Continuous Deployment)**  
Automated process for building, testing, and deploying code. FitChekk uses GitHub Actions.

**CloudKit**  
Apple's cloud service for syncing data across devices. Alternative to Firebase for Apple platforms.

**Codable**  
Swift protocol for encoding/decoding data to/from JSON, XML, etc. Makes API integration easy.
```swift
struct User: Codable {
    let id: UUID
    let email: String
}
// Auto-generates JSON encoding/decoding
```

**Composable Architecture (TCA)**  
State management framework for iOS. Makes apps predictable, testable, modular. Key concepts: State, Actions, Reducers, Effects.

**Core Data**  
Apple's framework for local data persistence. Older alternative to SwiftData.

### D

**Dependency Injection**  
Design pattern for providing dependencies (services) to objects instead of objects creating them. Makes testing easier.
```swift
// Without DI (bad for testing)
class ViewModel {
    let database = Database()
}

// With DI (testable)
class ViewModel {
    let database: DatabaseProtocol
    init(database: DatabaseProtocol) {
        self.database = database
    }
}
```

**DocC**  
Apple's documentation compiler. Generates beautiful documentation from code comments.

### E

**Effect**  
Side effect in TCA. Any operation that interacts with outside world (network, database, sensors). Wrapped in `.run` block.

### F

**Firebase**  
Google's mobile backend platform. Provides auth, database, storage, analytics. Alternative to Supabase.

**FSCalendar**  
Popular iOS calendar library. Used for FitChekk planner feature (or native alternative).

### G

**Gemini**  
Google's AI model family. FitChekk uses **Gemini 2.5 Pro** for image analysis and clothing categorization.

**GitHub Actions**  
CI/CD platform for automating workflows. FitChekk uses for: running tests, building app, deployment.

### I

**Identifiable**  
Swift protocol for objects with stable identity. Required for SwiftUI `ForEach`.
```swift
struct WardrobeItem: Identifiable {
    let id: UUID
}
```

### J

**JSON (JavaScript Object Notation)**  
Text format for data exchange. APIs return JSON.
```json
{
  "name": "Navy Sweater",
  "category": "tops",
  "colors": ["navy", "white"]
}
```

### L

**LazyVGrid / LazyHGrid**  
SwiftUI views that load items lazily (only visible ones). Essential for performance with large lists.

**LLM (Large Language Model)**  
AI model trained on massive text datasets. Examples: GPT-4, Claude, Gemini. Used for reasoning and text generation.

### M

**Mock**  
Fake implementation of service/API for testing. Returns predictable data.
```swift
class MockDatabase: DatabaseProtocol {
    func fetchItems() -> [Item] {
        return [.mock, .mock] // Predictable test data
    }
}
```

**MVVM (Model-View-ViewModel)**  
Architecture pattern. Alternative to TCA. Less boilerplate, but harder to test.

### O

**Observable / @Observable**  
Swift macro for making classes observable in SwiftUI. Automatically updates views when properties change.

**ObservableObject**  
Legacy protocol for observable classes (pre-Swift 5.9). Replaced by `@Observable` macro.

### P

**Portkey**  
AI gateway that routes requests to multiple AI models. Provides: fallback, caching, cost tracking, A/B testing.

**PostgreSQL / Postgres**  
Open-source relational database. Industry standard. Used by Supabase as underlying database.

**Prompt**  
Input text sent to AI model. Quality of prompt determines quality of output. FitChekk uses carefully engineered prompts for categorization and suggestions.

**Prompt Caching**  
Reusing parts of AI prompts across requests to reduce cost. Portkey caches user context (wardrobe + preferences) for 24h, saving 60-80% on costs.

**Pull to Refresh**  
UI pattern where user drags down to refresh content. Standard iOS interaction.

### R

**Realtime Sync**  
Immediate synchronization of data changes across devices. Supabase Realtime provides this via WebSockets.

**Reducer**  
Pure function in TCA that takes current State + Action → returns new State + Effects. Heart of TCA architecture.
```swift
func reduce(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .buttonTapped:
        state.isLoading = true
        return .run { send in
            let data = await fetchData()
            await send(.dataLoaded(data))
        }
    }
}
```

**Row-Level Security (RLS)**  
Database security feature where each row can have access policies. Supabase uses RLS to ensure users only access their own data.

### S

**Semantic Caching**  
AI optimization where similar prompts reuse cached results. More advanced than exact-match caching.

**StoreKit**  
Apple's framework for in-app purchases and subscriptions. FitChekk uses StoreKit 2 (modern async API).

**Supabase**  
Open-source Firebase alternative. Provides: PostgreSQL database, auth, storage, realtime, edge functions.

**SwiftData**  
Apple's modern data persistence framework (2023+). Replacement for Core Data with simpler API.

**SwiftUI**  
Apple's declarative UI framework. Modern alternative to UIKit. Used for all FitChekk views.

### T

**TCA**  
See **Composable Architecture**.

**TestStore**  
TCA's testing utility. Allows step-by-step verification of state changes and effects.

### U

**URLSession**  
Apple's API for making network requests. Used for Supabase and Portkey API calls.

**UUID (Universally Unique Identifier)**  
128-bit identifier that's globally unique. Format: `550e8400-e29b-41d4-a716-446655440000`. Used for database IDs.

### V

**VisionKit / Vision Framework**  
Apple's framework for image analysis. Used for background removal on iOS 17.

**VoiceOver**  
Apple's screen reader for blind/low-vision users. Accessibility testing requires VoiceOver support.

### W

**WeatherKit**  
Apple's native weather API (2022+). Provides current weather + forecasts. FitChekk uses for outfit suggestions.

### X

**Xcode**  
Apple's IDE for iOS/Mac development. Required for FitChekk development.

**XCTest**  
Apple's testing framework. Used for unit and UI tests.

---

## AI & ML Terms

### A

**AI Gateway**  
Service that routes AI requests to multiple models. FitChekk uses Portkey as AI gateway.

**Anthropic**  
Company that created Claude AI models. Known for safety-focused AI.

### C

**Claude**  
AI model family by Anthropic. FitChekk uses **Claude Sonnet 4** for outfit suggestions with reasoning.

**Confidence Score**  
Number (0.0-1.0) indicating AI's certainty in its output. FitChekk shows confidence for categorization: >85% auto-apply, <70% require user confirmation.

**Context Window**  
Amount of text AI can "remember" in one conversation. Claude Sonnet 4: 200K tokens.

### F

**Fallback Model**  
Backup AI model used if primary fails. FitChekk: Claude → GPT-4o → Gemini.

**Fine-tuning**  
Training AI model on specific dataset to improve performance for specific task. FitChekk may fine-tune if user corrections show consistent patterns.

### G

**GPT (Generative Pre-trained Transformer)**  
AI model architecture. GPT-4 by OpenAI is fallback model in FitChekk.

### H

**Hallucination**  
When AI generates false or nonsensical information confidently. Mitigated by: structured outputs, validation, confidence scoring.

### M

**Model**  
Trained AI system. Examples: Gemini 2.5 Pro (vision model), Claude Sonnet 4 (language model).

### P

**Prompt Engineering**  
Art of crafting AI prompts for optimal results. Critical for FitChekk's AI quality. Example:
```
Bad: "Categorize this clothing"
Good: "Analyze this clothing item. Return JSON with: category (from list: tops, bottoms...), subCategory, colors (array), formality (1-5), confidence (0-1)"
```

### R

**RAG (Retrieval-Augmented Generation)**  
AI technique that retrieves relevant information before generating response. FitChekk uses variant: caches user's wardrobe, retrieves for each suggestion.

**Reasoning**  
AI's explanation of its decision. FitChekk shows reasoning for outfit suggestions: "This navy sweater pairs well with these chinos because..."

### T

**Token**  
Unit of text for AI models. ~4 characters = 1 token. "Hello world" = ~2 tokens. AI costs calculated per token.

**Temperature**  
AI creativity parameter (0.0-2.0). Low = consistent, High = creative. FitChekk uses 0.3 for categorization (consistent), 0.8 for suggestions (creative).

### V

**Vision Model**  
AI model specialized in understanding images. FitChekk uses Gemini 2.5 Pro for clothing analysis.

---

## Fashion Terms

### B

**Business Casual**  
Dress code between casual and formal. No suit required, but polished. Example: button-down + chinos.

### C

**Capsule Wardrobe**  
Minimal wardrobe with mix-and-match pieces. Typically 30-40 versatile items.

**Cost-Per-Wear**  
Item cost divided by times worn. Metric for clothing value. Formula: Purchase price / Times worn.

### F

**Formality Level**  
How dressy clothing is. FitChekk scale: 1 (casual) to 5 (formal).
- 1: Casual (t-shirt, jeans)
- 2: Smart Casual (nice shirt, jeans)
- 3: Business Casual (button-down, chinos)
- 4: Business (suit, no tie)
- 5: Formal (suit + tie, cocktail dress)

### O

**Occasion**  
Context for outfit. FitChekk types: work, casual, date, athletic, formal, travel, weekend.

### S

**Seasonality**  
Which seasons clothing is appropriate for. FitChekk tags: spring, summer, fall, winter.

**Style Tags**  
Descriptors for fashion aesthetic. Examples: minimalist, boho, preppy, edgy, classic, streetwear.

### W

**Wardrobe**  
Collection of all clothing items owned by person. FitChekk manages digital wardrobe.

---

## Acronyms Quick Reference

- **API**: Application Programming Interface
- **ARR**: Annual Recurring Revenue
- **CAC**: Customer Acquisition Cost
- **CI/CD**: Continuous Integration/Deployment
- **DAU**: Daily Active Users
- **JSON**: JavaScript Object Notation
- **KPI**: Key Performance Indicator
- **LLM**: Large Language Model
- **LTV**: Lifetime Value
- **MAU**: Monthly Active Users
- **MRR**: Monthly Recurring Revenue
- **MVP**: Minimum Viable Product
- **NPS**: Net Promoter Score
- **PR**: Pull Request
- **RLS**: Row-Level Security
- **TCA**: The Composable Architecture
- **UI**: User Interface
- **UUID**: Universally Unique Identifier
- **UX**: User Experience

---

## Need a Term Added?

This glossary is living document. If you encounter term not defined here:

1. Ask in `#fitchekk-questions` Slack channel
2. Add to this document via PR
3. Help teammates by defining clearly

---

**Last Updated**: November 2025  
**Document Version**: 1.0  
**Maintained by**: Product & Engineering Teams

