# Immersive WebView - Architecture & Layout Diagrams

## Layout Architecture

### Before (❌ Not Scrollable)
```
┌─────────────────────────────────────┐
│         SystemUiOverlayStyle        │
│                                     │
│  ┌───────────────────────────────┐  │
│  │      Scaffold (body)          │  │
│  │                               │  │
│  │  ┌─────────────────────────┐  │  │
│  │  │    SafeArea(top)        │  │  │
│  │  │                         │  │  │
│  │  │  ┌───────────────────┐  │  │  │
│  │  │  │ Padding (top)     │  │  │  │
│  │  │  │                   │  │  │  │
│  │  │  │  ┌─────────────┐  │  │  │  │
│  │  │  │  │    Stack    │  │  │  │  │
│  │  │  │  │             │  │  │  │  │
│  │  │  │  │ RefreshInd. │  │  │  │  │
│  │  │  │  │  CustomSV   │  │  │  │  │ ❌ PARENT SCROLL
│  │  │  │  │  SliverFill │  │  │  │  │    INTERFERES
│  │  │  │  │  WebView    │  │  │  │  │
│  │  │  │  │             │  │  │  │  │
│  │  │  │  └─────────────┘  │  │  │  │
│  │  │  │                   │  │  │  │
│  │  │  └───────────────────┘  │  │  │
│  │  │                         │  │  │
│  │  └─────────────────────────┘  │  │
│  │                               │  │
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
     ❌ Scrolling doesn't work
     ❌ Content gets clipped
     ❌ Momentum broken
```

### After (✅ Native Scrolling)
```
┌──────────────────────────────────────────┐
│       SystemUiOverlayStyle               │
│  (statusBarColor: transparent)           │
│                                          │
│  ┌────────────────────────────────────┐  │
│  │      Scaffold                      │  │
│  │  (appBar: null, extendBody: true)  │  │
│  │                                    │  │
│  │  ┌──────────────────────────────┐  │  │
│  │  │    Stack (body)              │  │  │
│  │  │                              │  │  │
│  │  │  ┌────────────────────────┐  │  │  │
│  │  │  │  Positioned.fill       │  │  │  │
│  │  │  │                        │  │  │  │
│  │  │  │  ┌──────────────────┐  │  │  │  │
│  │  │  │  │  Column          │  │  │  │  │
│  │  │  │  │                  │  │  │  │  │
│  │  │  │  │  ┌────────────┐  │  │  │  │  │
│  │  │  │  │  │ SafeArea   │  │  │  │  │  │ ✅ STATUS BAR
│  │  │  │  │  │ Padding    │  │  │  │  │  │    AWARE
│  │  │  │  │  └────────────┘  │  │  │  │  │
│  │  │  │  │                  │  │  │  │  │
│  │  │  │  │  ┌────────────┐  │  │  │  │  │
│  │  │  │  │  │ Expanded   │  │  │  │  │  │ ✅ FLEXIBLE
│  │  │  │  │  │ (fills)    │  │  │  │  │  │    HEIGHT
│  │  │  │  │  │            │  │  │  │  │  │
│  │  │  │  │  │ ImmersiveWV│  │  │  │  │  │
│  │  │  │  │  │   Stack    │  │  │  │  │  │ ✅ NO PARENT
│  │  │  │  │  │   WebView  │  │  │  │  │  │    SCROLL
│  │  │  │  │  │            │  │  │  │  │  │
│  │  │  │  │  │ (scrolls   │  │  │  │  │  │ ✅ NATIVE
│  │  │  │  │  │  natively) │  │  │  │  │  │    SCROLLING
│  │  │  │  │  │            │  │  │  │  │  │
│  │  │  │  │  └────────────┘  │  │  │  │  │
│  │  │  │  │                  │  │  │  │  │
│  │  │  │  └──────────────────┘  │  │  │  │
│  │  │  │                        │  │  │  │
│  │  │  │ ┌────────────────────┐ │  │  │  │
│  │  │  │ │ ProgressBar        │ │  │  │  │ ✅ OVERLAY
│  │  │  │ │ (if loading)       │ │  │  │  │    (non-blocking)
│  │  │  │ └────────────────────┘ │  │  │  │
│  │  │  │                        │  │  │  │
│  │  │  └────────────────────────┘  │  │  │
│  │  │                              │  │  │
│  │  └──────────────────────────────┘  │  │
│  │                                    │  │
│  └────────────────────────────────────┘  │
│                                          │
└──────────────────────────────────────────┘
    ✅ Full native scrolling
    ✅ Works beyond viewport
    ✅ Smooth momentum
    ✅ No interference
```

## Component Tree

### Widget Hierarchy
```
MainApp
 └─ MaterialApp
     └─ SmartWebViewScreen (StatefulWidget)
         └─ _SmartWebViewScreenState
             └─ build() → Scaffold
                 └─ AnnotatedRegion<SystemUiOverlayStyle>
                     └─ Scaffold
                         └─ Stack (body)
                             ├─ Positioned.fill (showEngagement)
                             │   └─ AnimatedSwitcher
                             │       ├─ LoadingScreen
                             │       ├─ NoInternetScreen
                             │       └─ ServerErrorScreen
                             │
                             ├─ Positioned.fill (showWebView)
                             │   └─ Column
                             │       ├─ SizedBox (statusBarHeight)
                             │       └─ Expanded
                             │           └─ AnimatedOpacity
                             │               └─ ImmersiveWebView
                             │                   └─ Stack
                             │                       ├─ WebViewWidget
                             │                       └─ CircularProgressIndicator (if refreshing)
                             │
                             └─ Positioned (ProgressBar)
                                 └─ LinearProgressIndicator
```

## State Flow Diagram

```
┌──────────────┐
│   App Start  │
└──────┬───────┘
       │
       ▼
┌──────────────────────────┐
│ _validateAndLoad()       │
│ LinkState = CHECKING     │
└──────┬───────────────────┘
       │
       ├─ Check Network Status ──┐
       │                         │
       ◄─────────────────────────┘
       │
       ├─ Yes, Online ─────┐
       │                   │
       │                   ▼
       │            ┌─────────────────────┐
       │            │ _validateUrl()      │
       │            │ (HTTP HEAD request) │
       │            └──────┬──────────────┘
       │                   │
       │                   ├─ Response 200-399 ──┐
       │                   │                      │
       │                   │    ┌─────────────────┘
       │                   │    │
       │                   │    ▼
       │                   │  ┌────────────────────┐
       │                   │  │ _createWebView()   │
       │                   │  │ LinkState = AVAIL. │
       │                   │  └──────┬─────────────┘
       │                   │         │
       │                   │         ▼
       │                   │  ┌─────────────────────┐
       │                   │  │ WebView Loads URL   │
       │                   │  │ Shows Fallback      │
       │                   │  │ or WebView          │
       │                   │  └─────────────────────┘
       │                   │
       │                   ├─ Response non-200 ──┐
       │                   │                      │
       │                   │    ┌─────────────────┘
       │                   │    │
       │                   │    ▼
       │                   │  ┌──────────────────────┐
       │                   │  │ LinkState = UNAVAIL. │
       │                   │  │ _scheduleRetry()     │
       │                   │  │ (retry in 6 seconds) │
       │                   │  └──────────────────────┘
       │                   │
       │                   └─ Error / Timeout ────┐
       │                                          │
       │       ┌──────────────────────────────────┘
       │       │
       ├─ No, Offline ─────┐
       │                   │
       │                   ▼
       │            ┌──────────────────────┐
       │            │ LinkState = UNAVAIL. │
       │            │ Show Error Screen     │
       │            └──────────────────────┘
       │
       ▼
┌──────────────────────────────────────┐
│ Monitor Connectivity Changes         │
│ Monitor Network Availability (15s)   │
│ Support Manual Retry                 │
└──────────────────────────────────────┘
```

## Scrolling Architecture

### Touch Event Flow
```
┌─────────────────────────────┐
│    User Touch on Screen     │
│  (Drag, Fling, Momentum)    │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│    Stack.build()            │
│  (Non-interactive container)│
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│ ImmersiveWebView.build()    │
│  (Stack - non-interactive)  │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  WebViewWidget              │
│  (Native scroll handler)    │
└──────────┬──────────────────┘
           │
           ▼
┌──────────────────────────────────────┐
│ Platform Native Scroll               │
│ ✓ Momentum Scrolling                 │
│ ✓ Bounce Overscroll                  │
│ ✓ Fling Gesture                      │
│ ✓ Continuous Scroll to End           │
└──────────────────────────────────────┘

❌ NO INTERCEPTION
❌ NO PARENT SCROLL CONTAINER
❌ DIRECT GESTURE PROPAGATION
```

### What Doesn't Work (Common Mistake)
```
❌ INCORRECT APPROACH:

┌─────────────────────────────┐
│    User Touch on Screen     │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  RefreshIndicator           │
│  (Intercepts scroll events) │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  CustomScrollView           │
│  (Creates parent scroll)     │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  SliverFillRemaining        │
│  (Constrains WebView height)│
└──────────┬──────────────────┘
           │
           ▼
┌──────────────────────────────────────┐
│  WebViewWidget                       │
│  ❌ Scroll gestures already consumed │
│  ❌ Height is limited by parent      │
│  ❌ Momentum scrolling broken        │
│  ❌ Can't scroll beyond viewport     │
└──────────────────────────────────────┘
```

## Height Calculation

### Status Bar Safe-Area Padding
```
Screen Height = 2400 pixels (example full-screen phone)

┌────────────────────────────────────────────┐ ▲
│   Status Bar (system-managed)              │ │ statusBarHeight
├────────────────────────────────────────────┤ ▼
│                                            │
│                                            │ ▲
│                                            │ │
│  ImmersiveWebView                          │ │
│  (WebViewWidget)                           │ │ flexibleHeight
│                                            │ │ = Screen - statusBar
│  Scrollable Content                        │ │
│  (can exceed WebView height)               │ │
│                                            │ ▼
└────────────────────────────────────────────┘
│   System Navigation Bar (if present)       │
└────────────────────────────────────────────┘

statusBarHeight = MediaQuery.of(context).padding.top
flexibleHeight = Expanded (matches parent height - statusBar)
```

## Data Flow for WebView Loading

```
┌──────────────────┐
│  _validateUrl()  │
│  HTTP HEAD       │
│  Request         │
│  (Non-blocking)  │
└────────┬─────────┘
         │
         ├─ Success ────────┐
         │                  │
         │                  ▼
         │          ┌──────────────────┐
         │          │ _createWebView() │
         │          │                  │
         │          │ Set JS: ON       │
         │          │ Set DOM: ON      │
         │          │ Set Zoom: OFF    │
         │          │                  │
         │          │ SetNavigationDel.│
         │          │ onProgress()     │ ← Updates _progress
         │          │ onPageFinished() │ ← Hides progress bar
         │          │ onError()        │ ← Triggers fallback
         │          │                  │
         │          │ loadRequest()    │
         │          └──────┬───────────┘
         │                 │
         │                 ▼
         │          ┌──────────────────┐
         │          │  WebView Loads   │
         │          │  Content Renders │
         │          │  Page Scrollable │
         │          └──────────────────┘
         │
         ├─ Failure ────────┐
         │                  │
         │                  ▼
         │          ┌──────────────────┐
         │          │ _scheduleRetry() │
         │          │ Retry in 6 sec   │
         │          │ Show Error       │
         │          └──────────────────┘
         │
         └─ Error ──────────┐
                            │
                            ▼
                   ┌──────────────────┐
                   │ Catch Exception  │
                   │ Fallback Screen  │
                   └──────────────────┘
```

## Memory & Resource Management

```
┌─────────────────────────────────────┐
│  initState()                        │
│  - Create connectivity listener     │
│  - Start validation                 │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│  WebView Available                  │
│  - Create WebViewController         │
│  - Load URL                         │
│  - Monitor progress                 │
│  - Monitor connectivity             │
│  - Periodic health checks           │
└────────┬────────────────────────────┘
         │
         ├─ Error Occurs ──────────────┐
         │                             │
         │                             ▼
         │                    ┌────────────────────┐
         │                    │ _tearDownWebView() │
         │                    │ - Null controller  │
         │                    │ - Reset progress   │
         │                    │ - Free memory      │
         │                    └────────┬───────────┘
         │                             │
         │                             ▼
         │                    ┌────────────────────┐
         │                    │ Show Fallback      │
         │                    │ Schedule Retry     │
         │                    └────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│  dispose()                          │
│  - Cancel all subscriptions         │
│  - Cancel all timers                │
│  - Null controller                  │
│  - Free all resources               │
└─────────────────────────────────────┘
```

## Gesture Handling Detail

### Direct Gesture Path (Correct)
```
User Interaction
    ↓
Stack.hit_test() → (non-opaque, transparent)
    ↓
Column.hit_test() → (non-interactive)
    ↓
Expanded.hit_test() → (non-interactive)
    ↓
ImmersiveWebView.hit_test() → Stack (transparent)
    ↓
WebViewWidget.hit_test() → (native widget)
    ↓
Platform Native Handler
    ↓
✓ Scroll gesture recognized
✓ Passed to WebView engine
✓ Content scrolls smoothly
```

### Blocked Gesture Path (Wrong - Causes Scrolling Issues)
```
User Interaction
    ↓
RefreshIndicator.hit_test() → (can intercept)
    ↓
CustomScrollView.hit_test() → (INTERCEPTS scroll)
    ↓
SliverFillRemaining.hit_test() → (might consume gesture)
    ↓
WebViewWidget.hit_test() → (gesture already consumed)
    ↓
❌ Gesture lost
❌ Parent scrolling tried instead
❌ WebView content doesn't scroll
```

## Performance Optimization Points

```
Layout Construction (one-time):
  Scaffold → Stack → Column/Positioned → Expanded → WebView
  └─ O(1) layout pass, minimal cost

Rendering (per frame):
  Only affected widgets re-render
  └─ WebView rendering delegated to platform

Scrolling (continuous):
  Stack is GPU-accelerated
  └─ Transforms don't trigger rebuilds
  └─ Minimal JS engine overhead

Memory:
  ✓ Single WebView instance
  ✓ Proper cleanup on error
  ✓ Subscriptions managed
  ✓ Timers cancelled
```

