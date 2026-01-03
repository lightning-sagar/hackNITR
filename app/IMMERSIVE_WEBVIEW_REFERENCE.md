# Immersive WebView - Quick Reference Card

## One-Page Reference

### The Problem (Before)
```
❌ WebView wrapped in CustomScrollView
❌ Parent scroll intercepted gestures
❌ Content frozen after first viewport
❌ Momentum scrolling broken
```

### The Solution (After)
```
✅ WebView in Expanded widget only
✅ Stack passes gestures directly
✅ Content scrolls end-to-end
✅ Native momentum scrolling works
```

---

## Architecture at a Glance

```
Scaffold (no appBar)
  └─ Stack (body)
      ├─ Column (safe-area + WebView)
      │  ├─ SizedBox (statusBarHeight)
      │  └─ Expanded
      │     └─ ImmersiveWebView
      │        └─ Stack
      │           ├─ WebViewWidget ← Direct rendering
      │           └─ Progress (if refreshing)
      │
      └─ Progress Bar (overlay)
```

---

## Key Settings

### JavaScript
```dart
controller.setJavaScriptMode(JavaScriptMode.unrestricted);
```

### DOM Storage
```dart
controller.setDomStorageEnabled(true);
```

### Zoom
```dart
controller.enableZoom(false);
```

### Media Playback
```dart
controller.setMediaPlaybackRequiresUserGesture(true);
```

---

## State Management

```
CHECKING → validate URL
    ↓
├─ AVAILABLE → show WebView
├─ UNAVAILABLE → show error screen, retry
└─ on error → teardown, retry
```

---

## File Locations

| What | Where |
|------|-------|
| Main code | `lib/main.dart` |
| Theme colors | `lib/theme/app_theme.dart` |
| Error screens | `lib/widgets/error_screens.dart` |
| Loading screen | `lib/widgets/loading_screen.dart` |

---

## Common Code Snippets

### Access Progress
```dart
// Progress is 0.0 to 1.0
setState(() => _progress = value.clamp(0, 100) / 100);
```

### Check Connectivity
```dart
// Listen to changes
_connectivity.onConnectivityChanged.listen((results) {
  final offline = results.contains(ConnectivityResult.none);
});
```

### Validate URL
```dart
// HTTP HEAD request (lightweight)
final response = await http.head(Uri.parse(url)).timeout(...);
final isReachable = response.statusCode >= 200 && statusCode < 400;
```

### Handle Web Error
```dart
// onWebResourceError callback
if (mounted) {
  _tearDownWebView();
  setState(() => _linkState = LinkState.unavailable);
  _scheduleRetry();
}
```

---

## Performance Checklist

- ✅ Single WebView instance (no duplication)
- ✅ Proper cleanup in dispose() (no leaks)
- ✅ Stack layout (GPU-efficient)
- ✅ No re-layout during scroll (smooth)
- ✅ Mounted checks before setState() (safe)
- ✅ Timer cancellation (no dangling)
- ✅ Subscription cancellation (no dangling)

---

## Scrolling Verification

| Test | Expected | Check |
|------|----------|-------|
| Slow scroll | Smooth drag | ✅ |
| Fast fling | Momentum continues | ✅ |
| Beyond viewport | Reaches bottom | ✅ |
| No freeze | Content responsive | ✅ |
| Link tap | Navigation works | ✅ |
| Form input | Keyboard appears | ✅ |

---

## Error Recovery

```
Network Down
    ↓
Show: NoInternetScreen
    ↓
Wait for Reconnection
    ↓
Auto-validate
    ↓
Show: WebView
```

---

## Memory Management

```
App Start
  ↓
_validateAndLoad()
  ├─ Success → _createWebView()
  └─ Fail → _scheduleRetry()
  
Error Occurs
  ↓
_tearDownWebView()
  └─ controller = null
  
App Exit
  ↓
dispose()
  ├─ _connectivitySub.cancel()
  ├─ _validationTimer.cancel()
  ├─ _periodicCheckTimer.cancel()
  └─ _controller = null
```

---

## URL Configuration

### Change WebView URL
```dart
const String kHardcodedUrl = 'https://your-site.com';
```

### Enable JavaScript Bridge (Optional)
```dart
// Execute JavaScript
await controller.runJavaScript('alert("Hello");');

// Listen to messages
controller.addJavaScriptChannel('Flutter', onMessageReceived: (msg) {
  print('Message from JS: ${msg.message}');
});
```

---

## Troubleshooting Matrix

| Symptom | Cause | Fix |
|---------|-------|-----|
| Not scrolling | CustomScrollView wrapping | Remove wrapper |
| Frozen at bottom | Fixed height | Use Expanded |
| Status bar overlap | Missing padding | Add SizedBox(height: statusBarHeight) |
| Sluggish scroll | Gesture interception | Remove GestureDetector |
| White side gaps | Left/right padding | Remove side padding |
| Progress invisible | Wrong condition | Check `_progress < 1 && _progress > 0` |

---

## Testing Commands

```bash
# Run in debug mode (hot reload)
flutter run

# Run in release mode (performance)
flutter run --release

# Run on specific device
flutter run -d chrome
flutter run -d emulator
flutter run -d iphone

# Check logs
flutter logs

# DevTools (profiling)
flutter run --profile
# Then visit http://localhost:9100 in browser
```

---

## Build Commands

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS App
flutter build ios --release

# Clean build
flutter clean && flutter pub get && flutter run
```

---

## Key Classes

### SmartWebViewScreen
- State manager for WebView
- Handles validation, connectivity, retry logic
- Controls layout and fallback screens

### ImmersiveWebView
- StatefulWidget for immersive layout
- Renders WebView directly (no parent scroll)
- Handles refresh state

### WebViewController
- Platform-specific WebView control
- Configured with JS, DOM storage, etc.
- Handles navigation, progress, errors

---

## Enum: LinkState

```dart
enum LinkState {
  checking,       // Initial validation
  available,      // WebView shown
  unavailable,    // Error screen shown
}
```

---

## Constants

```dart
const String kHardcodedUrl = 'https://lms-iota-seven.vercel.app/';

// Timing
const Duration validateTimeout = Duration(seconds: 8);
const Duration retryDelay = Duration(seconds: 6);
const Duration healthCheckInterval = Duration(seconds: 15);

// Animation
const Duration progressBarFade = Duration(milliseconds: 400);
const Duration screenTransition = Duration(milliseconds: 350);
```

---

## Boolean Flags

```dart
_offline              // No internet connection
_isRefreshing         // Pull-to-refresh in progress
showEngagement        // Show fallback screen
```

---

## Timers & Subscriptions

```dart
late final Connectivity _connectivity;
StreamSubscription? _connectivitySub;  // ← Cancel in dispose()
Timer? _validationTimer;               // ← Cancel in dispose()
Timer? _periodicCheckTimer;            // ← Cancel in dispose()
```

---

## Important Methods

| Method | Purpose |
|--------|---------|
| `_validateAndLoad()` | Validate URL before WebView |
| `_validateUrl()` | HTTP HEAD request to test reachability |
| `_createWebView()` | Create WebViewController with config |
| `_tearDownWebView()` | Clean up WebView instance |
| `_handleConnectivity()` | React to connectivity changes |
| `_scheduleRetry()` | Retry after 6 seconds |
| `_startPeriodicCheck()` | Health check every 15 seconds |
| `_buildFallbackScreen()` | Select appropriate error screen |
| `_buildMinimalProgressBar()` | Render loading progress indicator |

---

## Layout Dimensions

```
Screen: Full device height/width
├─ Status bar: ~24-48dp (system)
├─ WebView: Full remaining height/width
└─ Navigation bar: ~48-56dp (system, if visible)
```

---

## Networking

```
Validation (before WebView)
  └─ HTTP HEAD (lightweight)
  └─ 8-second timeout
  └─ Non-blocking

Health Check (periodic)
  └─ Every 15 seconds
  └─ Only when available
  └─ Auto-retry on failure

Auto-Retry
  └─ 6 seconds after unavailable
  └─ On network reconnection
  └─ Manual button available
```

---

## Colors & Styling

```dart
AppTheme.primaryGreen      // Main brand color
AppTheme.lightGreen        // Secondary color
Colors.transparent         // WebView background
Colors.white              // Scaffold background
```

---

## Gesture Flow

```
Touch Event
  ↓
Stack.onPointerDown() [pass-through]
  ↓
ImmersiveWebView.onPointerDown() [pass-through]
  ↓
WebViewWidget.onPointerDown() [native handler]
  ↓
Platform WebView Engine
  ↓
✅ Scroll happens
```

---

## Most Common Fixes

### Issue: Not Scrolling
**Quick Fix:** Search for `CustomScrollView` or `RefreshIndicator` wrapping WebViewWidget and remove them.

### Issue: Content Frozen
**Quick Fix:** Wrap WebView in `Expanded` widget, not fixed-height container.

### Issue: Status Bar Overlap
**Quick Fix:** Add `SizedBox(height: statusBarHeight)` before WebView.

### Issue: Performance Lag
**Quick Fix:** Ensure `mounted` check before `setState()` calls.

---

## Documentation Links

- 📖 [IMMERSIVE_WEBVIEW_GUIDE.md](IMMERSIVE_WEBVIEW_GUIDE.md) - Full guide
- 🏗️ [IMMERSIVE_WEBVIEW_ARCHITECTURE.md](IMMERSIVE_WEBVIEW_ARCHITECTURE.md) - Diagrams
- ✅ [IMMERSIVE_WEBVIEW_CHECKLIST.md](IMMERSIVE_WEBVIEW_CHECKLIST.md) - Verification
- 🚀 [IMMERSIVE_WEBVIEW_QUICK_START.md](IMMERSIVE_WEBVIEW_QUICK_START.md) - Getting started
- 📋 [IMMERSIVE_WEBVIEW_SUMMARY.md](IMMERSIVE_WEBVIEW_SUMMARY.md) - Overview

---

## Version Info

```
Flutter: 3.x+
Dart: 3.x+
webview_flutter: 4.x+
connectivity_plus: 5.x+
http: 1.x+
```

---

## Success Criteria

✅ WebView renders full-screen  
✅ No app bar visible  
✅ Status bar safe-area respected  
✅ Vertical scrolling works  
✅ Scrolling works beyond viewport  
✅ No parent scroll interference  
✅ Momentum scrolling smooth  
✅ Touch gestures pass through  
✅ Network validation working  
✅ Error handling graceful  
✅ Resource cleanup proper  
✅ No memory leaks  

---

**Print this card for quick reference!** 📋

