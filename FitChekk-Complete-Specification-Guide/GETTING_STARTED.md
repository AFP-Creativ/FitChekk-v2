# FitChekk - Getting Started Guide

**For**: All Team Members (First Day)  
**Read Time**: 10 minutes  
**Last Updated**: November 2025

---

## Welcome to FitChekk! 👋

You're joining a team building an AI-powered wardrobe assistant that helps people look and feel great every day. This guide will get you productive on **Day 1**.

---

## Your First Hour

### 1. Understand the Vision (15 minutes)

**What is FitChekk?**

FitChekk answers one simple question every morning: **"What should I wear today?"**

It's not just a closet catalog - it's an intelligent assistant that considers:
- Today's weather
- Your calendar and plans
- Your style preferences
- What you wore recently

**Why does it matter?**

- Average person spends 18 minutes daily deciding what to wear
- 40% of clothes are rarely worn
- People want help, not just organization

**Our Goal**: Make getting dressed the easiest part of your day.

---

### 2. Review Key Documents (30 minutes)

**For Everyone**:
- [README.md](./README.md) - Complete overview and navigation

**Role-Specific** (pick your track):

**Executives/Leadership**:
1. [EXECUTIVE_SUMMARY.md](./EXECUTIVE_SUMMARY.md) - Business case (5 min)
2. [GO_TO_MARKET.md](./GO_TO_MARKET.md) - Launch strategy (10 min)

**Product/Design**:
1. [PRODUCT_VISION.md](./PRODUCT_VISION.md) - Product strategy (15 min)
2. [USER_EXPERIENCE.md](./USER_EXPERIENCE.md) - UX principles (15 min)

**Engineering**:
1. [TECHNICAL_ARCHITECTURE.md](./TECHNICAL_ARCHITECTURE.md) - Tech stack (20 min)
2. [AI_DEVELOPMENT_GUIDE.md](./AI_DEVELOPMENT_GUIDE.md) - How we use AI (15 min)

**Project Management**:
1. [IMPLEMENTATION_ROADMAP.md](./IMPLEMENTATION_ROADMAP.md) - Build plan (15 min)
2. [TEAM_STRUCTURE.md](./TEAM_STRUCTURE.md) - Roles & responsibilities (10 min)

---

### 3. Set Up Your Environment (15 minutes)

**All Roles**:
```bash
# 1. Clone repository (if applicable)
git clone [repo-url]
cd FitChekk

# 2. Join communication channels
# - Slack: #fitchekk-general, #fitchekk-dev, #fitchekk-design
# - Email: team@fitchekk.com

# 3. Access tools
# - GitHub: Request access to FitChekk org
# - Figma: Request access to design files
# - Notion: Request access to project board
```

**Engineers Only**:
```bash
# Install Xcode (latest)
xcode-select --install

# Install Cursor (AI code editor)
brew install --cask cursor

# Install dependencies
cd FitChekk
open FitChekk.xcodeproj

# Install Swift packages (automatic on first build)
# - The Composable Architecture
# - Supabase Swift SDK

# Set up environment variables
cp .env.example .env
# Add your API keys (ask team lead)

# Run app
# Xcode → Select scheme → Run (⌘R)
```

**Designers Only**:
```bash
# Access Figma files
# - Request access from design lead
# - Review design system
# - Familiarize with components

# Tools
brew install --cask figma
brew install --cask sketch (if needed)
```

---

## Quick Reference

### Product Overview

**Core Features**:
1. **Wardrobe Management**: Add items via camera, AI categorizes (Premium)
2. **AI Suggestions**: Daily outfit recommendations with reasoning (Premium)
3. **Outfit Creation**: Build and save outfits (Premium)
4. **Calendar Planning**: Schedule outfits in advance (Premium)
5. **Weather Integration**: 5-day forecast, weather-aware suggestions

**Free vs. Premium**:
- **Free**: 50 items, manual categorization, browse wardrobe
- **Premium** ($7.99/mo): Unlimited items, AI features, outfit creation, planning

---

### Tech Stack at a Glance

**Frontend**:
- Swift 6, SwiftUI, iOS 17+
- Architecture: The Composable Architecture (TCA)
- Data: SwiftData

**Backend**:
- Supabase (PostgreSQL, Auth, Storage, Realtime)

**AI**:
- Portkey Gateway (multi-model, caching)
- Gemini 2.5 Pro (image categorization)
- Claude Sonnet 4 (outfit suggestions)

---

### Key Concepts

**TCA (The Composable Architecture)**:
- State management pattern (like Redux for iOS)
- Predictable, testable, composable
- Every feature has: State, Actions, Reducer

**Portkey**:
- AI gateway that routes to multiple models
- Automatic fallback (Claude fails → GPT-4o)
- Semantic caching (60-80% cost savings)

**Supabase**:
- Open-source Firebase alternative
- PostgreSQL database, auth, storage, realtime
- Row-level security built-in

---

## Your First Tasks

### Everyone

**Day 1**:
- ✅ Read this guide
- ✅ Read role-specific docs
- ✅ Set up accounts and tools
- ✅ Join team channels
- ✅ Introduce yourself to team

**Week 1**:
- Attend daily standups
- Shadow experienced team member
- Ask questions (Slack: #fitchekk-questions)
- Review all documentation
- Understand project structure

---

### Engineers

**Day 1**:
- ✅ Clone repo, build app
- ✅ Run on simulator (or device)
- ✅ Read [TECHNICAL_ARCHITECTURE.md](./TECHNICAL_ARCHITECTURE.md)
- ✅ Review codebase structure
- ✅ Run tests: `⌘U`

**First Week**:
- Pick up "good first issue" from backlog
- Pair program with senior engineer
- Write your first feature with AI assistance
- Submit first PR

**First Tasks** (Suggested):
1. Add unit test for existing feature
2. Fix small UI bug
3. Add new enum case to Category
4. Implement simple view component

---

### Designers

**Day 1**:
- ✅ Access Figma files
- ✅ Review design system
- ✅ Read [USER_EXPERIENCE.md](./USER_EXPERIENCE.md)
- ✅ Install app on device
- ✅ Complete onboarding flow

**First Week**:
- Review all screens and flows
- Identify UX improvements
- Create mockups for feedback
- Pair with engineer on implementation

**First Tasks**:
1. Audit accessibility (color contrast, text sizes)
2. Design improved empty state
3. Create icon variations
4. Prototype animation concept

---

### Product Managers

**Day 1**:
- ✅ Read [PRODUCT_VISION.md](./PRODUCT_VISION.md)
- ✅ Review [IMPLEMENTATION_ROADMAP.md](./IMPLEMENTATION_ROADMAP.md)
- ✅ Understand success metrics
- ✅ Review backlog
- ✅ Install app and test

**First Week**:
- Meet with all team members 1:1
- Attend all ceremonies (standups, planning)
- Review user feedback
- Prioritize backlog
- Write first user story

---

## Communication

### Channels

**Slack**:
- `#fitchekk-general` - Announcements, celebrations
- `#fitchekk-dev` - Engineering discussions
- `#fitchekk-design` - Design reviews
- `#fitchekk-questions` - Ask anything!
- `#fitchekk-wins` - Share victories

**Meetings** (All times PST):
- **Daily Standup**: 9:00 AM (15 min)
- **Sprint Planning**: Monday 10:00 AM (1 hour)
- **Sprint Review**: Friday 2:00 PM (30 min)
- **Retrospective**: Friday 3:00 PM (45 min)

**Office Hours**:
- Tech Lead: Tuesday/Thursday 2-3 PM
- Design Lead: Wednesday 1-2 PM
- Product Manager: Daily 11-12 PM

---

## FAQs

### General

**Q: What's our timeline?**  
A: 16 weeks from kickoff to App Store launch. We're currently in [Phase X, Week Y].

**Q: Who are our users?**  
A: Style-conscious professionals (25-40) who value their time and want to look good without the stress.

**Q: Who are our competitors?**  
A: Indyx, Fits, Stylebook, GetWardrobe. We differentiate with AI reasoning and modern UX.

**Q: What's our business model?**  
A: Freemium subscription. Free tier is genuinely useful, Premium ($7.99/mo) unlocks AI features.

---

### Technical

**Q: Why TCA and not MVVM?**  
A: TCA is more testable, predictable, and easier for AI to generate. See [TECHNICAL_ARCHITECTURE.md](./TECHNICAL_ARCHITECTURE.md).

**Q: Why Supabase and not Firebase?**  
A: Open-source, PostgreSQL (more powerful), better pricing, easier to self-host if needed.

**Q: Why Portkey for AI?**  
A: Multi-model support (switch without code changes), automatic caching (60% cost savings), fallback resilience.

**Q: Can I use a different AI model?**  
A: Yes! Portkey makes it easy to A/B test models. Just change virtual key.

**Q: How do we handle AI costs?**  
A: Prompt caching (user context cached 24h), rate limiting, cost monitoring, premium-only for expensive features.

---

### Process

**Q: How do we use AI in development?**  
A: 80% of code is AI-generated (Cursor, GitHub Copilot). Human architects, AI implements, human reviews. See [AI_DEVELOPMENT_GUIDE.md](./AI_DEVELOPMENT_GUIDE.md).

**Q: What's our testing strategy?**  
A: Unit tests for all reducers/services (TCA TestStore), UI tests for critical flows, aim for 85%+ coverage.

**Q: How do we handle feature requests?**  
A: Log in backlog, product manager prioritizes, discussion in planning. Post-MVP features go to v1.1+.

**Q: What's our branching strategy?**  
A: Feature branches → PR → Review → Merge to `main`. Main is always deployable.

---

## Resources

### Documentation
- [Complete Specification Folder](./README.md) - All docs in one place
- [Glossary](./GLOSSARY.md) - Terms and definitions
- [Architecture Quick Ref](./TECHNICAL_ARCHITECTURE.md#architecture-overview)

### External Links
- [TCA Documentation](https://pointfreeco.github.io/swift-composable-architecture/)
- [Supabase Docs](https://supabase.com/docs)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Portkey Docs](https://portkey.ai/docs)

### Design Resources
- Figma Files: [Link to be added]
- Design System: [Link to be added]
- Brand Guidelines: [Link to be added]

---

## Getting Help

### Stuck on something?

**1. Search documentation** (this folder)  
**2. Check Slack** (#fitchekk-questions - someone may have asked)  
**3. Ask team** (Don't stay stuck for > 30 min)  
**4. Office hours** (Regular slots with leads)  
**5. Pair program** (Screen share and work together)

**Remember**: There are no stupid questions. We're all learning!

---

## Your First Week Goals

### By End of Week 1

**Everyone**:
- [ ] Understand product vision and strategy
- [ ] Know all team members and their roles
- [ ] Familiar with tools and processes
- [ ] Completed first contribution (doc edit, bug fix, design feedback, etc.)
- [ ] Feel comfortable asking questions

**Engineers**:
- [ ] App running on device
- [ ] Understand TCA architecture
- [ ] First PR merged
- [ ] Written/updated tests

**Designers**:
- [ ] Reviewed all screens
- [ ] Understand design system
- [ ] First design delivered
- [ ] Collaborated with engineer

**PMs**:
- [ ] Backlog understood and prioritized
- [ ] First user story written
- [ ] Stakeholder alignment
- [ ] Sprint ceremonies attended

---

## Culture & Values

### How We Work

**1. Ship Fast, Iterate Often**
- Perfect is the enemy of done
- Launch early, get feedback, improve
- MVP mindset (what's the smallest version that delivers value?)

**2. Leverage AI, But Think Critically**
- AI is a tool, not a replacement for thinking
- Always review AI-generated code
- Architecture and UX need human creativity

**3. User-Centric**
- Every decision starts with "What's best for the user?"
- Test with real users early and often
- Listen to feedback, but balance with vision

**4. Transparent Communication**
- Over-communicate (especially async)
- Share blockers immediately
- Celebrate wins, learn from failures

**5. Quality Matters**
- Code reviews are mandatory (no self-merges)
- Tests are non-negotiable
- Performance is a feature
- Accessibility is not optional

### What We Value

- ✅ **Ownership**: Take responsibility, see things through
- ✅ **Collaboration**: Help teammates, ask for help
- ✅ **Learning**: Share knowledge, grow together
- ✅ **Impact**: Focus on what moves the needle
- ✅ **Craft**: Take pride in your work
- ❌ **Ego**: Leave it at the door
- ❌ **Blame**: We win/lose as a team
- ❌ **Perfection**: Done is better than perfect

---

## Onboarding Checklist

### Day 1
- [ ] Read this guide (GETTING_STARTED.md)
- [ ] Read role-specific docs
- [ ] Set up accounts (GitHub, Slack, etc.)
- [ ] Install tools (Xcode, Cursor, Figma, etc.)
- [ ] Introduce yourself to team
- [ ] Attend first daily standup

### Week 1
- [ ] Read all documentation
- [ ] Understand product vision
- [ ] Familiar with codebase/design system
- [ ] Complete first contribution
- [ ] 1:1 with manager/lead
- [ ] Shadow experienced team member

### Week 2
- [ ] Pick up first feature/design
- [ ] Pair program/design with teammate
- [ ] Submit first substantial contribution
- [ ] Give feedback in sprint review
- [ ] Feel comfortable with process

### Month 1
- [ ] Independently pick up tasks
- [ ] Contributing regularly
- [ ] Understand full app flow
- [ ] Comfortable with AI workflow
- [ ] Integrated into team

---

## Next Steps

**You've completed the Getting Started guide!** 🎉

**Now**:
1. Pick your role-specific path from "Your First Hour" section
2. Set up your environment
3. Complete your first task
4. Ask questions in Slack

**Welcome to the team!** Let's build something people love. 🚀

---

## Contact

**Questions about this guide?**  
→ Update it! This is a living document.

**Can't find what you need?**  
→ Ask in #fitchekk-questions

**Have suggestions?**  
→ Create issue or PR

---

**Last Updated**: November 2025  
**Document Version**: 1.0  
**Maintained by**: Product Team

---

*Remember: Everyone was new once. Ask questions, make mistakes, learn fast, and have fun!* 🎯

