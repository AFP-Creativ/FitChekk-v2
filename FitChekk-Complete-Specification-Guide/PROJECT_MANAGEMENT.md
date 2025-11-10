# FitChekk - Project Management Guide

**For**: All Team Members, Project Managers  
**Read Time**: 10 minutes  
**Last Updated**: November 2025

---

## Overview

**Methodology**: Agile with pragmatism (not dogmatic)  
**Sprint Length**: 2 weeks  
**Team Size**: 5-7 people  
**Tools**: Notion (tasks), GitHub (code), Slack (communication)

**Philosophy**: Process serves the team, not the other way around.

---

## Sprint Cadence

### 2-Week Sprint Structure

```
Week 1:
Monday    - Sprint Planning (1h)
Tue-Fri   - Development
Thursday  - Mid-sprint check-in (15 min, async)

Week 2:
Mon-Thu   - Development
Thursday  - Sprint Review prep
Friday    - Sprint Review (30 min) + Retrospective (30 min)
```

---

## Ceremonies

### 1. Sprint Planning (Monday, 10:00 AM, 1 hour)

**Attendees**: Entire team

**Agenda**:
1. **Review Last Sprint** (10 min)
   - What was completed?
   - What was not completed (and why)?
   - Velocity: Actual vs. planned story points

2. **Sprint Goal** (5 min)
   - What's the focus? (e.g., "Complete Wardrobe Management")
   - Why does it matter?

3. **Backlog Refinement** (20 min)
   - Review top priority tickets
   - Clarify requirements
   - Ask questions

4. **Estimation** (15 min)
   - Team estimates story points (planning poker)
   - T-shirt sizes: XS (1), S (2), M (3), L (5), XL (8)
   - Consensus-based

5. **Commitment** (10 min)
   - Team commits to sprint backlog
   - Assign tickets to individuals
   - Identify dependencies

**Output**: Sprint backlog with story points and assignees

**Template** (Notion):
```markdown
# Sprint 5: Wardrobe Management (Jan 15 - Jan 26)

## Sprint Goal
Complete core wardrobe management (add, view, edit items)

## Committed Stories (23 points)
- [8 pts] WardrobeFeature with TCA (@Emma)
- [5 pts] Image capture and processing (@Marcus)
- [3 pts] Item detail view (@Emma)
- [3 pts] Database CRUD operations (@David)
- [2 pts] Design wardrobe grid (@Sarah)
- [2 pts] Unit tests for reducer (@Emma)

## Stretch Goals (if time)
- [3 pts] Add filters by category
- [2 pts] Pull-to-refresh
```

---

### 2. Daily Standup (Async-First, 9:00 AM)

**Format**: Slack thread in `#dev`

**Each person posts**:
```
✅ Yesterday: [What I completed]
🚧 Today: [What I'm working on]
❌ Blockers: [Any impediments]
```

**Example**:
```
Emma (iOS Engineer)
✅ Yesterday: Completed WardrobeFeature reducer, all tests passing ✅
🚧 Today: Starting on ItemDetailView, pairing with Sarah at 2pm
❌ Blockers: None

Marcus (Backend)
✅ Yesterday: Set up Supabase RLS policies for wardrobe_items
🚧 Today: Optimizing image upload endpoint
❌ Blockers: Waiting on API key for Portkey (asked CEO)

Sarah (Designer)
✅ Yesterday: Finalized HomeView designs, handed off to Emma
🚧 Today: Starting ItemDetailView mockups
❌ Blockers: None
```

**Sync Video Call** (Optional, if needed):
- 15 minutes max
- Only if blockers or complex discussion needed
- Not required daily

---

### 3. Mid-Sprint Check-In (Thursday, Async)

**Purpose**: Catch issues early, adjust if needed

**Format**: Quick Slack update

**Questions**:
1. Are we on track to complete sprint goal?
2. Any risks or blockers?
3. Do we need to adjust scope?

**Action**: If off track, async discussion or quick sync to replan

---

### 4. Sprint Review (Friday, 2:00 PM, 30 minutes)

**Attendees**: Entire team

**Agenda**:
1. **Demo Completed Work** (20 min)
   - Each person shows what they built
   - Focus on user-facing features
   - Celebrate wins! 🎉

2. **Review Sprint Metrics** (5 min)
   - Velocity: Completed vs. planned points
   - Quality: Bugs found, tests passing
   - Velocity trend (are we improving?)

3. **Backlog Adjustments** (5 min)
   - Re-prioritize based on learnings
   - Add/remove tickets

**Output**: Updated backlog, velocity data

---

### 5. Sprint Retrospective (Friday, 3:00 PM, 30 minutes)

**Attendees**: Entire team

**Format**: Start/Stop/Continue

**Each person shares**:
- **Start**: What should we start doing?
- **Stop**: What should we stop doing?
- **Continue**: What should we keep doing?

**Example**:
```
Emma:
Start: More pair programming (I learned a lot this sprint)
Stop: Over-estimating stories (we finished early)
Continue: Using AI for boilerplate code (huge time saver)

Marcus:
Start: Weekly architecture discussions
Stop: Last-minute PRs (hard to review Friday afternoon)
Continue: Async standups (working well)
```

**Action Items**:
- Pick 1-2 things to improve next sprint
- Assign owner for each action
- Check progress in mid-sprint

---

## Ticket Management

### Ticket States

```
Backlog → Ready → In Progress → In Review → Done
```

**Definitions**:
- **Backlog**: Not ready for development (needs refinement)
- **Ready**: Refined, estimated, ready to start
- **In Progress**: Actively being worked on
- **In Review**: PR submitted, waiting for approval
- **Done**: Merged, deployed, tested

---

### Ticket Template (Notion)

```markdown
# [Feature Name]

## User Story
As a [user type], I want to [action], so that [benefit].

Example: As a user, I want to add wardrobe items via camera, so that I can quickly digitize my closet.

## Acceptance Criteria
- [ ] User can open camera from "Add Item" button
- [ ] Camera captures image
- [ ] Image is processed (background removal)
- [ ] Item is saved to database
- [ ] Item appears in wardrobe grid

## Design
[Link to Figma mockups]

## Technical Notes
- Use PhotosPicker for iOS 17+
- Apply background removal via Vision framework
- Compress image to <2MB
- Store in Supabase Storage
- Update local SwiftData model

## Story Points
5 (Medium)

## Dependencies
- Requires: Supabase Storage setup (TASK-123)
- Blocks: AI Categorization (TASK-125)

## Assignee
@Emma (iOS Engineer)
```

---

### Story Point Estimation

**Reference Guide**:

| Points | Complexity | Time | Examples |
|--------|-----------|------|----------|
| **1** | Trivial | 1-2 hours | Add button, copy change, simple UI tweak |
| **2** | Small | Half day | New view with existing components, simple logic |
| **3** | Medium-Small | 1 day | Feature with moderate complexity, some tests |
| **5** | Medium | 2-3 days | Complete feature with tests, integration |
| **8** | Large | 3-5 days | Complex feature, multiple files, edge cases |
| **13** | X-Large | 1 week+ | Epic-level, should be broken down |

**Rule**: If story is >8 points, break it down into smaller stories.

**Planning Poker**:
1. Everyone shows estimate simultaneously (no anchoring)
2. If consensus: Use that estimate
3. If divergence: Highest and lowest explain, then re-estimate
4. Converge on estimate within 2 rounds

---

## Backlog Management

### Backlog Prioritization

**Priority Levels**:
1. **P0 (Critical)**: Blocks launch, security issues, data loss
2. **P1 (High)**: Core MVP features, major bugs
3. **P2 (Medium)**: Nice-to-have features, minor bugs
4. **P3 (Low)**: Future enhancements, polish

**Prioritization Framework** (RICE):
```
RICE Score = (Reach × Impact × Confidence) / Effort

Reach: How many users affected? (1-1000+)
Impact: How much does it help? (0.25, 0.5, 1, 2, 3)
Confidence: How sure are we? (0-100%)
Effort: How long to build? (person-days)

Example:
Feature: AI Outfit Suggestions
Reach: 1000 (all premium users)
Impact: 3 (massive value)
Confidence: 80% (validated in beta)
Effort: 10 days

RICE = (1000 × 3 × 0.8) / 10 = 240

Higher RICE score = higher priority
```

---

### Backlog Grooming (Ongoing)

**Who**: Product Lead + iOS Lead (or full team if needed)  
**When**: As needed (typically 1-2 hours per week)  
**Goal**: Ensure top of backlog is always ready

**Activities**:
1. Refine user stories (add details, acceptance criteria)
2. Break down large stories
3. Estimate (if not done)
4. Prioritize (RICE scoring)
5. Remove obsolete tickets

---

## Code Review Process

### Pull Request (PR) Workflow

**1. Create Branch**
```bash
git checkout -b feature/TASK-123-wardrobe-grid
```

**2. Develop Feature**
- Write code
- Write tests
- Run locally
- Lint and format

**3. Create PR**
```markdown
# PR Template (GitHub)

## Summary
Brief description of what this PR does.

## Related Ticket
Closes #123

## Changes
- Added WardrobeFeature reducer
- Created WardrobeView with grid
- Added unit tests (95% coverage)

## Screenshots/Video
[If UI change, attach screenshots or screen recording]

## Testing
- [ ] Unit tests passing
- [ ] Manually tested on device
- [ ] No linter errors
- [ ] No performance regressions

## Checklist
- [ ] Code follows style guide
- [ ] Tests written and passing
- [ ] Documentation updated (if needed)
- [ ] No hardcoded secrets
- [ ] Accessibility labels added
```

**4. Request Review**
- Assign reviewer (typically Lead Engineer)
- Move ticket to "In Review"
- Notify in Slack if urgent

**5. Address Feedback**
- Make requested changes
- Respond to comments
- Re-request review

**6. Merge**
- After approval
- Squash commits (keep history clean)
- Delete branch after merge

**7. Deploy**
- Automatic via CI/CD (if set up)
- Or manual deployment
- Monitor for issues

---

### Code Review Checklist

**Reviewer checks**:
- [ ] **Functionality**: Does it work? Edge cases handled?
- [ ] **Tests**: Are tests added? Do they pass? Good coverage?
- [ ] **Architecture**: Follows TCA? Proper separation?
- [ ] **Performance**: Any obvious inefficiencies?
- [ ] **Security**: No secrets? Input validation?
- [ ] **Accessibility**: Labels? Dynamic Type?
- [ ] **Readability**: Clear naming? Comments where needed?
- [ ] **Style**: Follows guidelines? Linted?

**Review Turnaround SLA**:
- Small PR (<100 lines): < 2 hours
- Medium PR (100-500 lines): < 4 hours
- Large PR (500+ lines): < 1 day

---

## Bug Tracking

### Bug Lifecycle

```
Reported → Triaged → Assigned → In Progress → Fixed → Verified → Closed
```

---

### Bug Template

```markdown
# Bug Title (Short, descriptive)

## Severity
- [ ] P0 - Critical (data loss, crash, security)
- [ ] P1 - High (major feature broken)
- [ ] P2 - Medium (minor feature issue)
- [ ] P3 - Low (cosmetic, edge case)

## Environment
- App version: 1.0.0
- iOS version: 18.1
- Device: iPhone 15 Pro
- User type: Premium

## Steps to Reproduce
1. Open app
2. Tap "Add Item"
3. Take photo
4. App crashes

## Expected Behavior
App should save item and return to wardrobe grid.

## Actual Behavior
App crashes immediately after taking photo.

## Screenshots/Logs
[Attach crash log or screenshot]

## Additional Context
Only happens on iOS 18.1, not on 17.5.
```

---

### Bug Triage (Daily or as needed)

**Who**: iOS Lead + Product Lead  
**Process**:
1. Review new bugs
2. Assign severity (P0-P3)
3. Assign to engineer (or backlog if low priority)
4. Set expected fix date based on severity:
   - P0: Same day
   - P1: Within 2 days
   - P2: Next sprint
   - P3: Backlog

---

## Release Management

### Release Cadence

**During Development** (Weeks 1-15):
- TestFlight builds: Weekly (every Friday)
- Beta testers get new builds automatically

**After Launch** (Week 16+):
- App Store releases: Bi-weekly or as needed for critical fixes
- TestFlight: Weekly for beta testers (get features early)

---

### Release Checklist

**Before Every Release**:
- [ ] All tests passing (CI green)
- [ ] Manual testing of critical flows
- [ ] No P0 or P1 bugs
- [ ] App Store Connect metadata updated (if first release or major change)
- [ ] Release notes written
- [ ] Version number bumped
- [ ] Screenshots updated (if UI changed significantly)

**Build & Upload**:
```bash
# 1. Update version
# Xcode → Project → General → Version: 1.1.0, Build: 10

# 2. Archive
Product → Archive

# 3. Upload to App Store Connect
Distribute App → App Store Connect

# 4. Submit for Review (if production release)
App Store Connect → Select build → Submit for Review
```

**Post-Release**:
- [ ] Monitor crash rate (should be <1%)
- [ ] Monitor reviews (respond within 24h)
- [ ] Track metrics (downloads, conversions, retention)
- [ ] Announce release (Twitter, blog, email)

---

## Metrics & Reporting

### Weekly Metrics Report

**Who**: Product Lead  
**When**: Every Monday morning  
**Format**: Slack post in `#general`

**Template**:
```markdown
📊 **Weekly Metrics** (Jan 15-21)

**Users**
- Total: 12,500 (+1,200 vs last week)
- DAU: 4,500 (36% DAU/MAU ✅)
- New signups: 1,200

**Engagement**
- Session length: 3.2 min (↑ 0.3 min)
- Items added: 15,600 (+800)
- Outfits created: 1,250 (+150)

**Revenue**
- Paid subscribers: 1,125 (+125)
- MRR: $8,960 (+$995)
- Conversion rate: 9% (target: 12% by March)

**Quality**
- Crash-free rate: 99.6% ✅
- App Store rating: 4.7 ⭐ ✅
- P0/P1 bugs: 0 ✅

**Focus This Week**
- Launch calendar planning feature
- Optimize AI suggestion latency
- A/B test new paywall copy
```

---

### Sprint Velocity Tracking

**Calculate after each sprint**:
```
Velocity = Total story points completed

Example Sprint 5:
- Committed: 23 points
- Completed: 21 points
- Velocity: 21 (91% completion rate)

Rolling Average (Last 3 sprints):
Sprint 3: 18 points
Sprint 4: 19 points
Sprint 5: 21 points
Average: 19.3 points

Use for planning: Commit to ~19 points next sprint
```

**Velocity Trends**:
- Increasing: Team is getting faster (or better at estimating)
- Stable: Predictable, good for planning
- Decreasing: Investigate (complexity? technical debt? distractions?)

---

## Tools & Workflows

### Notion (Project Management)

**Workspace Structure**:
```
📁 FitChekk
├── 📋 Sprint Board (Active sprint, Kanban view)
├── 📝 Backlog (All tickets, prioritized)
├── 🐛 Bugs (Bug tracker)
├── 📚 Documentation (Meeting notes, decisions)
├── 📊 Metrics Dashboard (Key KPIs)
└── 🗓️ Roadmap (High-level features by quarter)
```

---

### GitHub (Code & Reviews)

**Branch Strategy**:
```
main (production)
  ├── feature/TASK-123-wardrobe-grid
  ├── feature/TASK-124-ai-categorization
  └── hotfix/critical-crash-fix
```

**Commit Message Format**:
```
[TASK-123] Add wardrobe grid view

- Implemented LazyVGrid with adaptive columns
- Added category filters
- Unit tests for WardrobeFeature reducer

Closes #123
```

---

### Slack (Communication)

**Channel Purposes**:
- `#general`: Announcements, celebrations, all-hands updates
- `#dev`: Engineering discussions, PRs, deployments
- `#design`: Design reviews, mockups, feedback
- `#marketing`: Marketing updates, campaigns, metrics
- `#bugs`: Bug reports, triage discussions
- `#random`: Non-work chat, memes, fun

**Best Practices**:
- Use threads (keep channels organized)
- @mention sparingly (respect focus time)
- Async-first (don't expect immediate response)
- Over-communicate (better than under)

---

## Decision Log

**Keep record of major decisions**

**Format** (Notion page):
```markdown
# Decision: Use The Composable Architecture (TCA)

**Date**: January 5, 2025
**Decided By**: iOS Lead + CEO
**Status**: Approved

## Context
Need to choose architecture for app. Options: MVVM, TCA, Redux-like.

## Decision
Use The Composable Architecture (TCA)

## Rationale
1. Testability: TestStore makes testing easy
2. Predictability: Explicit state management
3. AI-friendly: Clear patterns for AI to generate
4. Modularity: Features are independent
5. Community: Growing, well-documented

## Consequences
- Learning curve for team (1 week)
- More boilerplate than MVVM (offset by AI generation)
- Dependency on Point-Free (low risk, open source)

## Alternatives Considered
- MVVM: Simpler but harder to test, less AI-friendly
- Custom Redux: Too much work to build framework
```

---

## Risk Management

### Risk Register (Updated Monthly)

| Risk | Probability | Impact | Mitigation | Owner |
|------|-------------|--------|------------|-------|
| **AI costs too high** | Medium | High | Portkey gateway with caching, monitor daily | Backend Lead |
| **Key person leaves** | Low | High | Document knowledge, cross-train team | CEO |
| **App Store rejection** | Low | High | Follow guidelines, test with TestFlight | iOS Lead |
| **Competitor launches** | Medium | Medium | Move fast, differentiate with AI quality | CEO |
| **Slow user growth** | Medium | High | Invest in marketing, optimize conversion | Marketing |

**Review quarterly, update mitigation plans**

---

## Conclusion

**Process is a tool, not a goal.**

Use what works, adapt what doesn't. The goal is to ship great product, not to follow process perfectly.

**Guiding Principles**:
1. Communicate clearly
2. Move fast, break things (safely)
3. Learn from mistakes
4. Celebrate wins
5. Support each other

---

**Last Updated**: November 2025  
**Document Version**: 1.0  
**Status**: Living Document (will evolve)

