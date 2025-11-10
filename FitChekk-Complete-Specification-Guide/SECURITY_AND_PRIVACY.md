# FitChekk - Security & Privacy

**For**: Engineering, Legal, Compliance  
**Read Time**: 10 minutes  
**Last Updated**: November 2025

---

## Overview

**Privacy Philosophy**: User owns their data. We're a tool, not a surveillance platform.

**Security Posture**: Defense in depth, privacy by design, zero trust.

**Compliance**: GDPR, CCPA, Apple App Store guidelines.

---

## Data Classification

### Public Data
**Definition**: Can be shared publicly without harm  
**Examples**: App screenshots, marketing materials  
**Protection**: None required

### Internal Data
**Definition**: Useful to company, no user PII  
**Examples**: Aggregated analytics, performance metrics  
**Protection**: Access control, audit logs

### Confidential Data
**Definition**: User PII, business secrets  
**Examples**: Email addresses, subscription status, API keys  
**Protection**: Encryption at rest, access logs, limited access

### Highly Sensitive Data
**Definition**: Could cause significant harm if leaked  
**Examples**: Payment info (handled by Apple), user photos  
**Protection**: End-to-end encryption, strict access control, audit trails

---

## Data Collection

### What We Collect

**Account Information**:
- Email address (for auth)
- Display name (optional)
- Authentication provider (Apple, Google, Email)
- Subscription tier and status
- Account creation/last login dates

**Wardrobe Data**:
- Photos of clothing items (stored in user's Supabase bucket)
- Item metadata (name, category, colors, etc.)
- AI-generated attributes (style tags, formality)
- Usage statistics (times worn, last worn date)

**Outfits & Planning**:
- Saved outfits (combinations of items)
- Calendar entries (which outfit for which date)
- User ratings of outfits

**User Preferences**:
- Style preferences from quiz
- Favorite colors
- Lifestyle and occasion preferences
- Location (for weather, with permission)

**Usage Analytics** (Aggregated, Anonymous):
- Feature usage (which screens visited)
- Performance metrics (app launch time, API latency)
- Crash reports (via Crashlytics)
- Error logs (sanitized, no PII)

### What We DON'T Collect

❌ Precise location (only general area for weather)  
❌ Contacts list  
❌ Other apps installed  
❌ Browsing history  
❌ Clipboard content  
❌ Photos outside of FitChekk  
❌ Microphone/camera outside of item capture  

---

## Data Storage

### Architecture

```
User Device (iOS)
    ↓ (HTTPS)
Supabase (Cloud)
    ├── PostgreSQL (Metadata)
    │   └── Row-Level Security (RLS)
    │       → Users can only access their own data
    │
    ├── Storage (Images)
    │   └── Private Buckets
    │       → Each user has isolated bucket
    │
    └── Realtime (Sync)
        └── Authenticated WebSocket
            → Only syncs user's own data
```

---

### Supabase Row-Level Security (RLS)

**All tables have RLS enabled.**

**Example Policy** (wardrobe_items):
```sql
-- Users can only select their own items
CREATE POLICY "Users can view own items"
ON wardrobe_items FOR SELECT
USING (auth.uid() = user_id);

-- Users can only insert items for themselves
CREATE POLICY "Users can insert own items"
ON wardrobe_items FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Users can only update their own items
CREATE POLICY "Users can update own items"
ON wardrobe_items FOR UPDATE
USING (auth.uid() = user_id);

-- Users can only delete their own items
CREATE POLICY "Users can delete own items"
ON wardrobe_items FOR DELETE
USING (auth.uid() = user_id);
```

**Result**: User A cannot see, modify, or delete User B's data. Enforced at database level.

---

### Image Storage

**Supabase Storage with Private Buckets**:

```typescript
// Bucket configuration
{
  name: 'wardrobe-images',
  public: false, // NOT publicly accessible
  allowedMimeTypes: ['image/jpeg', 'image/png', 'image/heic'],
  fileSizeLimit: 10485760, // 10MB max
}

// RLS Policy for images
CREATE POLICY "Users can upload own images"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'wardrobe-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

// File path structure
storage/wardrobe-images/{user_id}/{item_id}.jpg
// Users can only access files in their folder
```

**Image Access**:
- Signed URLs (expire after 1 hour)
- User must be authenticated
- Cannot access other users' images

---

## Encryption

### Data at Rest

**Supabase (PostgreSQL)**:
- Encrypted at rest (AES-256)
- Managed by Supabase
- Encryption keys rotated regularly

**Supabase Storage (Images)**:
- Encrypted at rest (AES-256)
- Object versioning enabled (accidental deletion recovery)

**iOS Keychain** (For sensitive local data):
```swift
// Store auth tokens
let keychain = KeychainWrapper()
keychain.set(authToken, forKey: "auth_token", withAccessibility: .afterFirstUnlock)
```

---

### Data in Transit

**HTTPS Everywhere**:
```swift
// Enforce HTTPS
let url = URL(string: "https://api.fitchekk.com")
// ❌ Never http://

// Certificate pinning (optional, for extra security)
let serverTrustPolicy = ServerTrustPolicy.pinCertificates(
    certificates: ServerTrustPolicy.certificates(),
    validateCertificateChain: true,
    validateHost: true
)
```

**WebSocket (Realtime Sync)**:
- WSS (WebSocket Secure)
- Authenticated with JWT

---

## Authentication & Authorization

### Authentication (Supabase Auth)

**Supported Methods**:
1. **Sign in with Apple** (Preferred)
   - Apple ID token verified by Supabase
   - User can hide email (privacy+)
   - Automatic on Apple devices

2. **Google Sign-In**
   - OAuth 2.0 flow
   - Google token verified by Supabase

3. **Email/Password**
   - Password hashed with bcrypt (handled by Supabase)
   - Never stored in plaintext
   - Password reset via email

**Token Management**:
```swift
// JWT token stored in Keychain
let supabase = SupabaseClient(...)

// Auth state listener
supabase.auth.onAuthStateChange { event, session in
    switch event {
    case .signedIn:
        // Store session
        store(session.accessToken)
    case .signedOut:
        // Clear session
        clearTokens()
    case .tokenRefreshed:
        // Update stored token
        store(session.accessToken)
    }
}

// Auto-refresh before expiry
// Supabase SDK handles this automatically
```

---

### Authorization (What Users Can Do)

**Free Tier**:
- ✅ Add up to 50 wardrobe items
- ✅ Manual categorization
- ✅ View wardrobe
- ❌ AI categorization (Premium only)
- ❌ AI outfit suggestions (Premium only)
- ❌ Outfit creation (Premium only)
- ❌ Calendar planning (Premium only)

**Premium Tier**:
- ✅ All Free tier features
- ✅ Unlimited items
- ✅ AI features

**Enforcement**:
```swift
// Check subscription status before allowing Premium features
guard subscriptionManager.isPremium else {
    showPaywall()
    return
}

// Call AI service
let suggestion = try await outfitService.suggest(...)
```

**Server-Side Enforcement** (Supabase Edge Functions):
```typescript
// Verify subscription before expensive AI calls
const { data: user } = await supabase
  .from('users')
  .select('subscription_tier')
  .eq('id', userId)
  .single();

if (user.subscription_tier === 'free') {
  return new Response('Premium feature', { status: 403 });
}

// Proceed with AI call
const aiResponse = await callAI(...);
```

---

## API Security

### API Keys Management

**Never Hardcode Keys**:
```swift
// ❌ BAD
let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

// ✅ GOOD
let apiKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_KEY") as! String
```

**Configuration Files**:
```bash
# .env (Git-ignored)
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
PORTKEY_API_KEY=pk_...

# Load in Xcode build phase
if [ -f .env ]; then
    export $(cat .env | xargs)
fi
```

**Environment-Specific Keys**:
- Development: Low-privilege keys, test data
- Production: Full privilege, real data
- Separate keys for each environment

---

### Rate Limiting

**Supabase** (Built-in):
- 100 requests/minute per user
- 10,000 requests/hour per project
- Automatic DDoS protection

**Portkey AI Gateway** (Custom limits):
```typescript
// Set rate limits per user
const config = {
  rateLimits: {
    categorization: { requests: 50, window: '1h' },
    suggestions: { requests: 100, window: '24h' },
  }
};

// Enforced by Portkey
```

**Client-Side Throttling**:
```swift
// Debounce rapid requests
func searchItems(query: String) {
    searchTask?.cancel()
    searchTask = Task {
        try await Task.sleep(nanoseconds: 300_000_000) // 300ms
        let results = try await database.search(query)
        // Update UI
    }
}
```

---

## Privacy Compliance

### GDPR (EU General Data Protection Regulation)

**User Rights**:
1. **Right to Access**: User can export all their data
2. **Right to Rectification**: User can edit their data
3. **Right to Erasure** ("Right to be Forgotten"): User can delete account
4. **Right to Data Portability**: Export in machine-readable format (JSON)
5. **Right to Object**: Opt-out of analytics

**Implementation**:
```swift
// Export all user data
func exportAllData() async throws -> Data {
    let user = try await fetchUser()
    let items = try await fetchWardobeItems()
    let outfits = try await fetchOutfits()
    let preferences = try await fetchPreferences()
    
    let export = UserDataExport(
        user: user,
        items: items,
        outfits: outfits,
        preferences: preferences,
        exportedAt: Date()
    )
    
    return try JSONEncoder().encode(export)
}

// Delete all user data
func deleteAccount() async throws {
    let userId = currentUser.id
    
    // Delete from database (cascading deletes handled by foreign keys)
    try await supabase
        .from('users')
        .delete()
        .eq('id', userId)
        .execute()
    
    // Delete images from storage
    try await supabase.storage
        .from('wardrobe-images')
        .remove(["\(userId)/"])
    
    // Sign out
    try await supabase.auth.signOut()
}
```

---

### CCPA (California Consumer Privacy Act)

**Requirements**:
- Disclose data collection practices (Privacy Policy)
- Allow users to opt-out of data "sale" (we don't sell data)
- Allow users to request deletion

**"Do Not Sell My Personal Information"**:
```swift
// We don't sell data, but provide opt-out for analytics
UserDefaults.standard.set(true, forKey: "analytics_opt_out")

if UserDefaults.standard.bool(forKey: "analytics_opt_out") {
    // Don't send analytics events
    return
} else {
    analytics.track(event)
}
```

---

### Apple Privacy Requirements

**Privacy Nutrition Label** (App Store Connect):
```
Data Linked to User:
- Email Address (for account management)
- Photos (wardrobe items, stored in user's control)
- User Content (outfits, preferences)

Data Not Linked to User:
- Diagnostics (crash logs, anonymized)

Data Not Collected:
- Location (only approximate for weather, with permission)
- Browsing History
- Search History
- Purchases (handled by Apple, we don't see payment info)
```

**App Tracking Transparency (ATT)**:
```swift
// We DON'T track across apps, so we DON'T need ATT prompt
// If we add third-party ad networks later, we'd need this:

import AppTrackingTransparency

ATTrackingManager.requestTrackingAuthorization { status in
    switch status {
    case .authorized:
        // User allows tracking
    case .denied, .restricted:
        // User denies tracking, still use app normally
    @unknown default:
        break
    }
}
```

---

## Secure Development Practices

### Code Review Security Checklist

**Every PR Must Check**:
- [ ] No hardcoded secrets (API keys, passwords)
- [ ] Input validation (don't trust user input)
- [ ] SQL injection prevention (use parameterized queries - Supabase does this)
- [ ] XSS prevention (sanitize user-generated content)
- [ ] HTTPS only (no HTTP)
- [ ] Sensitive data not logged (no passwords, tokens in logs)
- [ ] Auth checks for protected endpoints
- [ ] Rate limiting on expensive operations

---

### Dependency Security

**Audit Dependencies**:
```bash
# Check for known vulnerabilities
swift package audit

# Or use GitHub Dependabot (automatic)
```

**Keep Dependencies Updated**:
- Review security advisories
- Update promptly if security fix
- Test thoroughly after update

**Pin Versions**:
```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/supabase/supabase-swift", exact: "2.5.0")
    // Use exact version, not `.upToNextMajor`
]
```

---

### Secure Coding Practices

**Input Validation**:
```swift
// ✅ GOOD: Validate user input
func createItem(name: String?, category: ItemCategory) throws {
    guard let name = name, !name.isEmpty, name.count <= 100 else {
        throw ValidationError.invalidName
    }
    
    // Proceed with validated input
}

// ❌ BAD: Trust user input blindly
func createItem(name: String?) {
    database.insert(name: name) // What if name is nil? Or 10,000 characters?
}
```

**SQL Injection Prevention** (Handled by Supabase):
```swift
// ✅ GOOD: Parameterized query (Supabase SDK does this)
let items = try await supabase
    .from('wardrobe_items')
    .select()
    .eq('user_id', userId)
    .execute()

// ❌ BAD: String interpolation (don't do this)
let query = "SELECT * FROM wardrobe_items WHERE user_id = '\(userId)'"
// Vulnerable to: userId = "1' OR '1'='1"
```

**Safe Logging**:
```swift
// ✅ GOOD: Log without sensitive data
logger.info("User signed in: \(user.id)")

// ❌ BAD: Log sensitive data
logger.info("User signed in: \(user.email), password: \(password)")
// Passwords/tokens NEVER go in logs
```

---

## Incident Response

### Security Incident Process

**If Security Breach Detected**:

**1. Contain** (Immediate):
- Disable affected systems
- Revoke compromised credentials
- Block suspicious traffic

**2. Assess** (Within 1 hour):
- What data was accessed?
- How many users affected?
- What's the attack vector?

**3. Notify** (Within 24-72 hours, depending on jurisdiction):
- Affected users (email)
- Regulatory authorities (if required by law)
- Press (if significant breach)

**4. Remediate** (ASAP):
- Fix vulnerability
- Deploy patch
- Force password resets (if needed)
- Enhanced monitoring

**5. Post-Mortem** (Within 1 week):
- Root cause analysis
- What went wrong?
- How to prevent in future?
- Update incident response plan

**6. Learn** (Ongoing):
- Implement preventive measures
- Security training for team
- Third-party security audit (if major breach)

---

### Example Notification

```markdown
Subject: Important Security Notice - Your FitChekk Account

Dear [User],

We recently discovered a security incident that may have affected your FitChekk account.

What Happened:
On [date], we detected unauthorized access to our database that lasted approximately [duration]. 

What Information Was Involved:
- Email addresses
- Account creation dates
[NO passwords, payment info, or photos were accessed]

What We're Doing:
- We've closed the security vulnerability
- We're requiring all users to change passwords (out of abundance of caution)
- We've added additional security monitoring
- We're working with security experts to prevent future incidents

What You Should Do:
1. Change your password immediately: [link]
2. Enable two-factor authentication: [link]
3. Watch for suspicious activity on your account

We sincerely apologize for this incident. Your trust is our top priority.

Questions? Email security@fitchekk.com

[Name]
CEO, FitChekk
```

---

## Privacy Policy (Summary)

**Full policy**: https://fitchekk.com/privacy

**Key Points**:
1. **What we collect**: Email, photos (your wardrobe), usage data
2. **How we use it**: To provide the service (outfit suggestions, wardrobe management)
3. **Who we share with**: 
   - Supabase (hosting)
   - AI providers (Gemini, Claude - via Portkey, images processed not stored)
   - Apple (for payments, via StoreKit)
4. **Your rights**: Access, export, delete your data anytime
5. **Security**: Encryption, access controls, regular audits
6. **Retention**: As long as your account is active, or 30 days after deletion
7. **Children**: Not intended for users under 13
8. **Changes**: We'll notify you of material changes
9. **Contact**: privacy@fitchekk.com

---

## Terms of Service (Summary)

**Full terms**: https://fitchekk.com/terms

**Key Points**:
1. **Service**: Wardrobe management and AI outfit suggestions
2. **Account**: You're responsible for account security
3. **Content**: You own your photos, we have license to process them for providing service
4. **AI Accuracy**: We strive for accuracy but don't guarantee perfection
5. **Subscriptions**: Cancel anytime, refund policy per Apple's terms
6. **Acceptable Use**: Don't abuse service, hack, or violate laws
7. **Termination**: We can terminate for violations, you can terminate anytime
8. **Liability**: Limited to amount paid (standard software terms)
9. **Disputes**: Arbitration (standard clause)
10. **Changes**: We'll notify of material changes

---

## Security Checklist for Launch

**Before Public Launch**:
- [ ] All API keys stored securely (not in code)
- [ ] HTTPS enforced everywhere
- [ ] Row-Level Security (RLS) enabled on all tables
- [ ] Image buckets are private (not public)
- [ ] Rate limiting configured
- [ ] Dependencies audited (no known vulnerabilities)
- [ ] Privacy Policy published and linked in app
- [ ] Terms of Service published and linked in app
- [ ] Security headers configured (CORS, CSP)
- [ ] Input validation on all user inputs
- [ ] No sensitive data in logs
- [ ] Incident response plan documented
- [ ] Security contact email set up (security@fitchekk.com)
- [ ] Penetration test completed (or scheduled)
- [ ] Bug bounty program considered (optional, for later)

---

## Resources

### External Tools

**Security Scanning**:
- GitHub Dependabot (dependency vulnerabilities)
- Snyk (code security scanning)
- OWASP ZAP (penetration testing)

**Privacy Compliance**:
- Termly (privacy policy generator)
- iubenda (compliance management)

**Monitoring**:
- Sentry (error tracking)
- Firebase Crashlytics (crash reporting)
- Supabase Logs (database access logs)

---

## Conclusion

**Security and privacy are not checkboxes - they're ongoing commitments.**

**Core Principles**:
1. **Privacy by Design**: Build with privacy from the start
2. **Defense in Depth**: Multiple layers of security
3. **Least Privilege**: Users/systems only access what they need
4. **Transparency**: Clear privacy policy, honest communication
5. **Continuous Improvement**: Regular audits, learn from incidents

**Remember**: Users trust us with their personal photos and style. That's a responsibility we take seriously.

---

**Last Updated**: November 2025  
**Document Version**: 1.0  
**Security Contact**: security@fitchekk.com

