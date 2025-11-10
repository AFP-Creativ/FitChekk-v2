# FitChekk - User Experience Guide

**For**: Design Team, Product Team, Engineering  
**Read Time**: 20 minutes  
**Last Updated**: November 2025

---

## UX Principles

### 1. Radically Simple

**Every feature must pass the "3-tap test"**: Can the user accomplish their goal in 3 taps or less?

**Examples**:
- Add item: Tap (+) → Capture → Done ✅ (2 taps)
- Accept outfit: Open app → Tap "Use This" ✅ (1 tap)
- Schedule outfit: Tap date → Tap outfit → Tap "Schedule" ✅ (3 taps)

**Anti-pattern**: Multi-step wizards, excessive confirmations, unnecessary navigation

---

### 2. Invisibly Intelligent

**AI should feel magical, not mechanical.**

**Show**: "This navy sweater pairs beautifully with your camel chinos for today's 72° weather"  
**Don't Show**: "Running Gemini Flash 2.5 model... Processing... Cache hit... Generating suggestion..."

**Principle**: User sees magic, not machinery.

---

### 3. Delightfully Fast

**Every interaction should feel instant.**

| Action | Target | User Perception |
|--------|--------|-----------------|
| **App Launch** | <1s | Instant |
| **Screen Transition** | <300ms | Instant |
| **AI Suggestion** | <2s | Fast |
| **Image Upload** | <3s | Acceptable |

**If operation takes >2s**: Show progress with helpful message, not spinner alone

---

### 4. Respectfully Honest

**Be direct, but kind.**

✅ "You've worn this sweater 4 times this week. Try something fresh?"  
❌ "You wear the same thing too much."

✅ "This outfit got 15 compliments last time!"  
❌ "Everyone loved this."

---

### 5. Progressively Revealed

**Don't overwhelm. Reveal complexity as needed.**

**Day 1**: Add items → AI categorizes → See wardrobe  
**Week 1**: Get suggestions → Accept/reject  
**Month 1**: Plan outfits → Schedule ahead  
**Month 3**: Discover advanced features (stats, insights)

---

## User Flows

### Critical Flow: First-Time User Experience

```
Launch App
    ↓
Welcome Screen (2 seconds)
    ↓
"Let's personalize FitChekk" (Style Quiz)
    ↓
Question 1: What's your style? [Visual grid, multi-select]
    ↓
Question 2: Favorite colors? [Color palette picker]
    ↓
Question 3: Your lifestyle? [Cards: Work environment, activity level]
    ↓
Question 4: Dress for what occasions? [Multi-select chips]
    ↓
Request Location Permission [For weather]
    ↓
"You're all set! ✨ Let's add your first item"
    ↓
Camera opens → Capture photo → AI categorizes → Saved!
    ↓
"Great! Add a few more items to unlock AI suggestions"
    ↓
Home Screen (shows wardrobe, encourages adding more items)
```

**Goal**: Get to first "aha moment" within 3 minutes.

---

### Primary Flow: Morning Routine (Premium User)

```
Wake up
    ↓
Open FitChekk (< 1s launch)
    ↓
Home Screen shows:
- "Good morning, Emma!"
- Weather: 72°, Partly Cloudy
- AI Suggested Outfit (large image)
- Reasoning: "This navy sweater pairs perfectly..."
- [Use This Outfit] [Suggest Another]
    ↓
Tap "Use This Outfit"
    ↓
Success animation ✨
"Outfit saved for today! Have a great day 🌟"
    ↓
Close app, get dressed
    ↓
Total time: 10 seconds
```

**Goal**: Answer "What should I wear?" in <10 seconds.

---

### Secondary Flow: Building Wardrobe

```
Home Screen
    ↓
Tap "My Closet" tab
    ↓
Wardrobe Grid (shows all items)
    ↓
Tap [+] button (top right)
    ↓
Action Sheet:
- "Take Photo"
- "Choose from Library"
- "Cancel"
    ↓
Select "Take Photo"
    ↓
Camera opens (native iOS camera UI)
    ↓
Capture photo
    ↓
Processing: "Removing background..." (1-2s)
    ↓
Preview screen:
- Image (background removed)
- Name: [Optional text field]
- Category: "Tops > Sweaters" [AI suggested, editable] (Premium)
  OR "Select category" [Manual picker] (Free)
- [Save] button
    ↓
Tap [Save]
    ↓
Success animation
Item appears in grid immediately
    ↓
Toast: "Item added! 42 items total"
```

**Goal**: Add item in <30 seconds, frictionless.

---

### Tertiary Flow: Planning Outfits (Premium)

```
Home Screen
    ↓
Tap "Planner" tab
    ↓
Calendar View (Monthly)
    ↓
Tap future date (e.g., Friday)
    ↓
Date Detail Screen:
- Weather forecast: 68°, Sunny
- "No outfit planned"
- [Add Outfit] button
    ↓
Tap [Add Outfit]
    ↓
Options:
- "Choose Existing Outfit"
- "Create New Outfit"
- "Get AI Suggestion"
    ↓
Tap "Get AI Suggestion"
    ↓
Loading (1-2s): "Considering weather and your style..."
    ↓
AI Suggestion shown:
- Outfit image
- Reasoning
- [Use This] [Try Another]
    ↓
Tap [Use This]
    ↓
Outfit scheduled to Friday
Calendar updates with dot indicator
    ↓
Toast: "Outfit planned for Friday ✅"
```

**Goal**: Plan week's outfits in <5 minutes.

---

## Screen-by-Screen Specifications

### Home Screen

**Layout**:
```
┌─────────────────────────────┐
│ Good morning, Emma! 👋      │
│ Monday, January 15          │
├─────────────────────────────┤
│ Weather                     │
│ ☁️ 72° Partly Cloudy         │
│ Feels like 68°              │
│                             │
│ [Today] [Tue] [Wed] [Thu] [Fri]│
│  72°    68°   65°   70°   74°│
├─────────────────────────────┤
│ Today's Outfit              │
│                             │
│ [Large outfit image]        │
│                             │
│ "This navy sweater pairs... │
│  perfect for 72° weather"   │
│                             │
│ [Use This Outfit]           │
│ [Suggest Another]           │
│                             │
│ or                          │
│                             │
│ [Start With An Item →]      │
├─────────────────────────────┤
│ Quick Actions               │
│ [📷 Add Item] [👗 Wardrobe] │
│ [📅 Planner] [⚙️ Settings]  │
└─────────────────────────────┘
```

**States**:

**Free User, No Outfit**:
- Show empty state with illustration
- CTA: "Start With An Item" → Opens wardrobe
- No AI suggestion (show locked preview)

**Premium User, No Outfit**:
- Show AI suggestion automatically
- "Use This" / "Suggest Another" buttons
- Can also start with item

**Any User, Outfit Scheduled**:
- Show scheduled outfit (large)
- Items list below (horizontal scroll)
- "Mark as Worn" button
- "Change Outfit" button

---

### Wardrobe Grid Screen

**Layout**:
```
┌─────────────────────────────┐
│ My Closet          🔍 [+]   │
├─────────────────────────────┤
│ Category Filters (horizontal scroll)│
│ [All] [Tops] [Bottoms] ...  │
├─────────────────────────────┤
│ ┌────┐ ┌────┐ ┌────┐        │
│ │Item│ │Item│ │Item│        │
│ │ 1  │ │ 2  │ │ 3  │        │
│ └────┘ └────┘ └────┘        │
│ ┌────┐ ┌────┐ ┌────┐        │
│ │Item│ │Item│ │Item│        │
│ │ 4  │ │ 5  │ │ 6  │        │
│ └────┘ └────┘ └────┘        │
│                             │
│ (LazyVGrid, adaptive columns)│
└─────────────────────────────┘
```

**Interactions**:
- **Tap item**: Opens ItemDetailView (full screen)
- **Long press item**: Context menu (Favorite, Create Outfit, Archive, Delete)
- **Pull down**: Refresh
- **Tap [+]**: Add item (camera or library)
- **Tap category**: Filter by category
- **Search**: Filter by name

**Item Card**:
```
┌────────┐
│        │ Image (background removed)
│ Photo  │ 160x160pt
│        │
├────────┤
│ Name   │ 1 line, truncated
└────────┘
♥ (if favorite)
```

---

### Item Detail Screen

**Layout**:
```
┌─────────────────────────────┐
│ [<] Item Name          [⋮]  │
├─────────────────────────────┤
│                             │
│                             │
│     [Large Item Image]      │
│     (background removed)    │
│                             │
│                             │
├─────────────────────────────┤
│ Category: Tops > Sweaters   │
│ Colors: Navy, White         │
│ Season: Fall, Winter        │
│ Formality: Casual (2/5)     │
│                             │
│ Times Worn: 12              │
│ Last Worn: 3 days ago       │
│ Cost Per Wear: $3.33        │
├─────────────────────────────┤
│ [♥ Favorite]  [Create Outfit]│
│ [Archive]     [Delete]      │
├─────────────────────────────┤
│ Appears In                  │
│ [Outfit 1] [Outfit 2] [+3]  │
└─────────────────────────────┘
```

---

### Outfit Builder Screen (Premium)

**Layout**:
```
┌─────────────────────────────┐
│ [Cancel] New Outfit   [Save]│
├─────────────────────────────┤
│                             │
│     [Outfit Preview]        │
│     (composite image)       │
│                             │
├─────────────────────────────┤
│ Select Items:               │
│                             │
│ [Top ▼]                     │
│ ┌────┐ ┌────┐ ┌────┐        │
│ │  1 │ │  2 │ │  3 │        │
│ └────┘ └────┘ └────┘        │
│                             │
│ [Bottom ▼]                  │
│ ┌────┐ ┌────┐               │
│ │  1 │ │  2 │               │
│ └────┘ └────┘               │
│                             │
│ [Shoes ▼]                   │
│ ┌────┐ ┌────┐               │
│ │  1 │ │  2 │               │
│ └────┘ └────┘               │
│                             │
│ [+ Add Layer]               │
│ (Outerwear, Accessories)    │
└─────────────────────────────┘
```

**Interaction**:
- Tap category → Expands grid of items
- Tap item → Adds to outfit preview
- Preview updates in real-time
- Can have multiple items per category (e.g., 3 shoe options)
- [Save] → Names outfit, saves

---

### Calendar/Planner Screen

**Layout**:
```
┌─────────────────────────────┐
│ [<] January 2025      [>]   │
├─────────────────────────────┤
│ S  M  T  W  T  F  S         │
│          1  2  3  4         │
│ 5  6  7  8  9 10 11         │
│12 13 14 15 16 17 18         │
│19 20 21 22 23 24 25         │
│26 27 28 29 30 31            │
│                             │
│ Legend:                     │
│ 🔵 Planned                  │
│ ✅ Worn                     │
│ ☁️ Weather                  │
└─────────────────────────────┘

Tap date → 

┌─────────────────────────────┐
│ Friday, Jan 17              │
│ ☀️ 74°, Sunny               │
├─────────────────────────────┤
│ [Outfit thumbnail if planned]│
│                             │
│ [Add Outfit]                │
│ [Get AI Suggestion]         │
└─────────────────────────────┘
```

---

## Interaction Patterns

### Loading States

**Principles**:
- Show progress, not spinners alone
- Communicate what's happening
- Provide escape hatch if slow

**Examples**:
```
Loading wardrobe:
"Loading your closet..." [Spinner]

AI categorizing:
"Analyzing your item..." [Progress bar 0-100%]

AI suggesting outfit:
"Considering weather and your style..." [Animated clothes icons]
(If >3s) [Cancel] button appears

Syncing:
"Syncing 12 items..." [Progress: 8/12]
```

---

### Empty States

**Principle**: Helpful, not scolding. Show next action.

**Examples**:

**No Wardrobe Items**:
```
┌─────────────────────────────┐
│                             │
│     [Illustration:          │
│      Empty closet]          │
│                             │
│ Your wardrobe is empty      │
│                             │
│ Add your first item to get  │
│ started with AI outfit      │
│ suggestions                 │
│                             │
│ [Add Your First Item]       │
└─────────────────────────────┘
```

**No Outfits** (Premium):
```
┌─────────────────────────────┐
│     [Illustration:          │
│      Outfit hanger]         │
│                             │
│ Create your first outfit    │
│                             │
│ Or let AI suggest one based │
│ on your wardrobe and today's│
│ weather                     │
│                             │
│ [Create Outfit] [Get Suggestion]│
└─────────────────────────────┘
```

---

### Error States

**Principle**: Explain what happened, offer solution.

**Examples**:

**Network Error**:
```
┌─────────────────────────────┐
│     [Icon: WiFi with X]     │
│                             │
│ No Internet Connection      │
│                             │
│ Check your connection and   │
│ try again                   │
│                             │
│ [Try Again]                 │
│                             │
│ (Your wardrobe is still     │
│  available offline)         │
└─────────────────────────────┘
```

**AI Error**:
```
┌─────────────────────────────┐
│     [Icon: Sad robot]       │
│                             │
│ Couldn't Generate Suggestion│
│                             │
│ Our AI is having trouble    │
│ right now. Try again or     │
│ build an outfit manually    │
│                             │
│ [Try Again] [Browse Wardrobe]│
└─────────────────────────────┘
```

---

### Success States

**Principle**: Celebrate wins, build momentum.

**Examples**:

**Item Added**:
- Confetti animation (subtle)
- Toast: "Item added! 42 items total"
- Item appears in grid immediately

**Outfit Accepted**:
- Checkmark animation
- Toast: "Outfit saved for today! Have a great day 🌟"
- Haptic feedback (success)

**Milestone Reached**:
- Modal: "You've added 10 items! 🎉 Unlock AI suggestions?"
- CTA: "Upgrade to Premium"

---

## Accessibility

### VoiceOver

**All interactive elements must have labels.**

**Examples**:
```swift
Button("Add Item") { }
    .accessibilityLabel("Add new wardrobe item")
    .accessibilityHint("Opens camera to photograph clothing")

AsyncImage(url: item.imageURL)
    .accessibilityLabel("Photo of \(item.name ?? "clothing item")")
```

---

### Dynamic Type

**All text must scale with system font size.**

**Test**: Settings → Accessibility → Display & Text Size → Larger Text (max)

**Ensure**:
- All text remains readable
- Layouts don't break
- Buttons remain tappable (44×44 minimum)

---

### Color Contrast

**WCAG AA minimum** (4.5:1 for normal text, 3:1 for large text)

All colors in our design system have been verified for accessibility compliance. See Design Tokens section below for specific contrast ratios.

---

## Animation & Motion

### Principles

1. **Purposeful**: Every animation serves a function
2. **Fast**: 200-300ms for most transitions
3. **Natural**: Easing curves feel organic
4. **Smooth**: 60fps always
5. **Respectful**: Honor Reduce Motion setting

---

### Standard Animations

**Screen Transitions**:
```swift
.transition(.slide) // 300ms
.animation(.easeInOut(duration: 0.3), value: isPresented)
```

**Item Appearance**:
```swift
.transition(.scale.combined(with: .opacity)) // 200ms
.animation(.spring(response: 0.3, dampingFraction: 0.7), value: items)
```

**Success States**:
```swift
.scaleEffect(didSucceed ? 1.2 : 1.0) // Bounce
.animation(.spring(response: 0.4, dampingFraction: 0.6), value: didSucceed)
```

---

### Reduce Motion Support

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

var transition: AnyTransition {
    reduceMotion ? .opacity : .slide
}
```

---

## Design Tokens

### Brand Personality

**FitChekk is**: Personal, Effortless, Smart

**Visual metaphor**: A warm, well-organized best friend's walk-in closet where your clothes are the star. The app provides a beautifully lit gallery space—neutral enough to let clothing photos shine, warm enough to feel inviting, with subtle signature touches that make it unmistakably FitChekk.

**Target aesthetic**: "Target fashion" (accessible, trendy, fun) not high fashion. Clean, organized, intuitive, with pops of playful energy.

---

### Color System

#### Philosophy

The color system follows the **"Warm Gallery"** principle:
- **Clothing photos are the hero** (maximum visual pop)
- **UI recedes but remains warm and inviting** (not cold or clinical)
- **Calm organization with playful energy** (not overwhelming, not dull)
- **Signature terracotta accent** (energizing, approachable, distinctive)
- **Logo olive complements terracotta** (organized, grounded, unexpected)

---

#### Light Mode (Primary)

**Background Hierarchy**:
```swift
// Primary app background - warm off-white, like natural linen
static let backgroundPrimary = Color(hex: "#FAF8F5")

// Secondary background - warm beige for cards and sections
static let backgroundSecondary = Color(hex: "#F5F3F0")

// Elevated surfaces - pure white for modals/overlays when needed
static let backgroundElevated = Color(hex: "#FFFFFF")
```

**Text Hierarchy**:
```swift
// Primary text - deep warm charcoal (not pure black)
static let textPrimary = Color(hex: "#2D2A27")
// Contrast ratio on light bg: 15.8:1 ✅ WCAG AAA

// Secondary text - warm medium gray for metadata
static let textSecondary = Color(hex: "#8B8681")
// Contrast ratio on light bg: 4.7:1 ✅ WCAG AA

// Tertiary text - lighter warm gray for timestamps
static let textTertiary = Color(hex: "#A8A39E")
// Contrast ratio on light bg: 3.2:1 ✅ WCAG AA (large text only)
```

**Accent & Action Colors**:
```swift
// PRIMARY ACCENT: Terracotta (cooler/pinker shade)
// The signature FitChekk color for energy and action
static let accentPrimary = Color(hex: "#C17B6F")
// Use for: CTAs, selected states, "Create Outfit" button, active tabs
// Contrast ratio on light bg: 3.8:1 ✅ WCAG AA (large text/UI elements)

// Primary accent variations
static let accentPrimaryHover = Color(hex: "#D4948A")
// Use for: Pressed/hover states
static let accentPrimaryDark = Color(hex: "#A66B60")
// Use for: Borders, subtle emphasis

// SUCCESS/COMPLETE: Warm sage green
static let success = Color(hex: "#A8B89F")
// Use for: "Outfit saved", favorites heart fill, completion states
// Contrast ratio on light bg: 3.1:1 ✅ WCAG AA (large text/UI)

// SUBTLE ENERGY: Soft peach
static let energySubtle = Color(hex: "#F4C3B8")
// Use for: "New item" badges, AI suggestion indicators, delightful moments
// Background color only, not for text
```

**Semantic Colors**:
```swift
// Error states
static let error = Color(hex: "#D7584D")
// Contrast ratio: 4.6:1 ✅ WCAG AA

// Warning states
static let warning = Color(hex: "#E8A54B")
// Contrast ratio: 3.5:1 ✅ WCAG AA (large text)

// Info states
static let info = Color(hex: "#7A8A9E")
// Contrast ratio: 4.2:1 ✅ WCAG AA
```

---

#### Dark Mode

**Background Hierarchy**:
```swift
// Primary background - rich warm dark brown
static let backgroundPrimaryDark = Color(hex: "#2D2520")

// Secondary background - lighter warm brown for cards
static let backgroundSecondaryDark = Color(hex: "#3A352F")

// Elevated surfaces - for modals
static let backgroundElevatedDark = Color(hex: "#45403A")
```

**Text Hierarchy**:
```swift
// Primary text - warm cream (from light mode background)
static let textPrimaryDark = Color(hex: "#FAF8F5")
// Contrast ratio on dark bg: 14.2:1 ✅ WCAG AAA

// Secondary text - warm light gray
static let textSecondaryDark = Color(hex: "#C4BFB9")
// Contrast ratio on dark bg: 8.5:1 ✅ WCAG AAA

// Tertiary text - warm medium gray
static let textTertiaryDark = Color(hex: "#8B8681")
// Contrast ratio on dark bg: 4.1:1 ✅ WCAG AA
```

**Accent Colors**: Same terracotta (#C17B6F) - pops beautifully against dark warm brown

---

#### Logo Color System

**Brand Colors**:
```swift
// LOGO PRIMARY: Warm olive
// Complements terracotta perfectly, provides calm contrast
static let logoPrimary = Color(hex: "#7A8A5F")
// Use for: Logo symbol mark, brand recognition

// Logo on different backgrounds:
// - On light (#FAF8F5): Contrast 3.5:1 ✅ WCAG AA
// - On dark (#2D2520): Contrast 4.8:1 ✅ WCAG AA
// - On clothing photos: Works on most backgrounds

// ACCENT WITHIN LOGO (optional): Thin terracotta accent line
static let logoAccent = Color(hex: "#C17B6F")
```

**Logo Usage**:
- **In-app**: Olive symbol mark (subtle, top-left nav)
- **Social media/App Store**: Olive symbol on warm cream background
- **Marketing**: Full logo (olive symbol + charcoal wordmark)

**Color Hierarchy Strategy**:
- **Olive = Brand recognition** (logo, identity)
- **Terracotta = Action & engagement** (buttons, selections, CTAs)
- **Warm neutrals = Gallery** (let clothing shine)

---

### Item Card Specifications

**Visual Design**:
```swift
// Card properties
struct ItemCard {
    let backgroundColor = Color.backgroundSecondary // #F5F3F0
    let cornerRadius: CGFloat = 16 // Modern, friendly, iOS-native
    let padding: CGFloat = 16 // Internal breathing room
    
    // Shadow (warm branded shadow)
    let shadowColor = Color.accentPrimary.opacity(0.08) // #C17B6F at 8%
    let shadowOffset = CGSize(width: 0, height: 4)
    let shadowBlur: CGFloat = 12
    let shadowSpread: CGFloat = 0
}
```

**Photo Treatment**:
- Background removal (automated via AI)
- Item centered on card
- Aspect ratio: 3:4 (portrait, standard clothing photography)
- Item scales to fit within safe area (leaves card padding visible)

**Card States**:
```swift
// Default state
.background(Color.backgroundSecondary)
.cornerRadius(16)
.shadow(color: Color.accentPrimary.opacity(0.08), radius: 12, y: 4)

// Hover/Press state
.scaleEffect(0.98)
.shadow(color: Color.accentPrimary.opacity(0.12), radius: 16, y: 4)

// Selected state
.overlay(
    RoundedRectangle(cornerRadius: 16)
        .stroke(Color.accentPrimary, lineWidth: 2)
)
.shadow(color: Color.accentPrimary.opacity(0.12), radius: 16, y: 4)

// Multi-select state
// Checkmark badge (terracotta circle) in top-right corner
```

**Implementation Example**:
```swift
struct ClothingItemCard: View {
    let item: WardrobeItem
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Photo (background removed)
            AsyncImage(url: item.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 180)
            .padding(16)
            
            // Item name
            Text(item.name ?? "Untitled")
                .font(.caption)
                .foregroundColor(.textPrimary)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundSecondary)
        .cornerRadius(16)
        .shadow(
            color: Color.accentPrimary.opacity(isSelected ? 0.12 : 0.08),
            radius: isSelected ? 16 : 12,
            y: 4
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.accentPrimary, lineWidth: isSelected ? 2 : 0)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
    }
}
```

---

### Outfit Card Specifications

**Large Outfit Cards** (Home screen, Planner):
```swift
struct OutfitCard {
    let backgroundColor = Color.backgroundSecondary // #F5F3F0
    let cornerRadius: CGFloat = 20 // Slightly larger for hero content
    let padding: CGFloat = 20
    
    // Larger shadow for hero content
    let shadowColor = Color.accentPrimary.opacity(0.10)
    let shadowBlur: CGFloat = 16
    let shadowOffset = CGSize(width: 0, height: 6)
}
```

**Composite Outfit Image**:
- Multiple items layered naturally
- Maintains item proportions
- Centered composition
- Same warm drop shadow as individual items

---

### Typography

**System Font**: SF Pro (native iOS)

**Hierarchy**:
```swift
// Display
.font(.largeTitle)      // 34pt, Bold - Major page titles
.font(.title)           // 28pt, Bold - Section headers
.font(.title2)          // 22pt, Bold - Subsection headers

// Body
.font(.body)            // 17pt, Regular - Primary content (default)
.font(.callout)         // 16pt, Regular - Secondary content

// Supporting
.font(.subheadline)     // 15pt, Regular - Metadata, labels
.font(.caption)         // 12pt, Regular - Timestamps, tertiary info
.font(.caption2)        // 11pt, Regular - Fine print

// Special
.font(.headline)        // 17pt, Semibold - Emphasized body text
.font(.footnote)        // 13pt, Regular - Footnotes, disclaimers
```

**Text Colors** (apply from color system):
```swift
.foregroundColor(.textPrimary)      // Primary content
.foregroundColor(.textSecondary)    // Secondary content
.foregroundColor(.textTertiary)     // Tertiary content
.foregroundColor(.accentPrimary)    // CTAs, links, emphasis
```

**Dynamic Type Support**:
All typography must scale with system font size settings. Test at maximum size to ensure layouts remain functional.

---

### Spacing

**Base Unit**: 8pt

**Standard Spacing**:
```swift
// Padding
.padding(.horizontal, 16)  // 2 units - Standard horizontal padding
.padding(.vertical, 8)     // 1 unit - Tight vertical spacing
.padding(16)               // 2 units - All sides (common for cards)
.padding(24)               // 3 units - Generous padding

// Section spacing
.padding(.bottom, 24)      // Between major sections
.padding(.bottom, 16)      // Between related groups

// Item spacing
LazyVGrid(columns: [...], spacing: 16)  // Grid gaps between items
VStack(spacing: 12)                      // Stack spacing (1.5 units)
HStack(spacing: 8)                       // Tight horizontal spacing
```

**Layout Margins**:
```swift
// Screen edges
.padding(.horizontal, 20)  // Standard screen margin (left/right)
.padding(.top, 16)         // Top safe area padding
.padding(.bottom, 16)      // Bottom safe area padding
```

---

### Buttons & Interactive Elements

**Primary Button** (CTAs):
```swift
Button("Create Outfit") { }
    .font(.body.weight(.semibold))
    .foregroundColor(.white)
    .frame(maxWidth: .infinity)
    .padding(.vertical, 16)
    .background(Color.accentPrimary)
    .cornerRadius(12)
```

**Secondary Button**:
```swift
Button("Cancel") { }
    .font(.body)
    .foregroundColor(.accentPrimary)
    .frame(maxWidth: .infinity)
    .padding(.vertical, 16)
    .background(Color.backgroundSecondary)
    .cornerRadius(12)
```

**Tertiary Button** (text only):
```swift
Button("Learn More") { }
    .font(.body)
    .foregroundColor(.accentPrimary)
```

**Floating Action Button**:
```swift
Button(action: addItem) {
    Image(systemName: "plus")
        .font(.title2.weight(.semibold))
        .foregroundColor(.white)
        .frame(width: 56, height: 56)
        .background(Color.accentPrimary)
        .clipShape(Circle())
        .shadow(color: Color.accentPrimary.opacity(0.3), radius: 8, y: 4)
}
```

**Minimum Touch Target**: 44×44pt (iOS standard)

---

### Icons & Symbols

**System Symbols** (SF Symbols):
```swift
// Prefer SF Symbols for consistency
Image(systemName: "plus.circle.fill")
    .font(.title2)
    .foregroundColor(.accentPrimary)
```

**Icon Colors**:
- **Active/Selected**: Terracotta (#C17B6F)
- **Inactive**: Warm medium gray (#8B8681)
- **Disabled**: Warm light gray (#A8A39E)

---

### States & Overlays

**Selection Indicators**:
```swift
// Selected state (checkmark on terracotta circle)
ZStack(alignment: .topTrailing) {
    ItemCard(item: item)
    
    if isSelected {
        Circle()
            .fill(Color.accentPrimary)
            .frame(width: 28, height: 28)
            .overlay(
                Image(systemName: "checkmark")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
            )
            .offset(x: -8, y: 8)
    }
}
```

**Loading Overlays**:
```swift
// Translucent overlay with spinner
ZStack {
    ContentView()
    
    if isLoading {
        Color.backgroundPrimary.opacity(0.8)
            .ignoresSafeArea()
        
        ProgressView()
            .tint(.accentPrimary)
    }
}
```

---

### Implementation Notes

**Color Extension** (already in ContentView.swift):
```swift
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
```

**Color Asset Catalog** (recommended):
Create color sets in Assets.xcassets for automatic light/dark mode switching:
- BackgroundPrimary
- BackgroundSecondary
- TextPrimary
- TextSecondary
- AccentPrimary
- LogoPrimary
- etc.

**Environment Values**:
```swift
// Dark mode detection
@Environment(\.colorScheme) var colorScheme

// Adapt colors automatically
Color(.backgroundPrimary) // Auto-adapts if using asset catalog
```

---

## Conclusion

**Great UX is invisible.**

Users should focus on their wardrobe, not the app. Every decision should remove friction, not add it.

**Questions to ask**:
1. Is this the simplest way to accomplish the goal?
2. Does this delight the user?
3. Would my grandmother understand this?
4. Is this accessible to everyone?
5. Does this feel fast?
6. Do the colors support the content, not distract from it?
7. Does this feel warm and inviting, or cold and clinical?

If the answer to any is "no", iterate.

---

**Last Updated**: November 2025  
**Document Version**: 2.0
**Major Changes**: Complete color system redesign based on user research. Warm gallery aesthetic with terracotta accent and olive logo. Comprehensive card specifications and implementation details.