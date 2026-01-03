# 🌾 Quick Start Guide - Agriculture Screens

## How to Use the New Screens

### 1. The Screens Work Automatically! 🎉

The app now intelligently shows the right screen based on the situation:

```dart
// In main.dart - it's already set up!

if (_linkState == LinkState.checking) {
  // Shows LoadingScreen
  return LoadingScreen(message: 'Connecting...');
}

if (_offline) {
  // Shows NoInternetScreen
  return NoInternetScreen(onRetry: _manualRetry);
}

// Shows ServerErrorScreen
return ServerErrorScreen(onRetry: _manualRetry);
```

**No additional code needed!** The app handles everything automatically.

---

## 2. Testing Different Screens

### Test Loading Screen:
1. Launch the app
2. You'll see the loading screen with a farming fact
3. It automatically transitions when connected

### Test No Internet Screen:
1. Turn off your Wi-Fi and mobile data
2. Open the app or refresh
3. You'll see connectivity tips + agricultural facts
4. Turn internet back on → auto-reconnects!

### Test Server Error Screen:
1. The app automatically shows this if the server doesn't respond
2. Shows farming insights while waiting
3. Auto-retries every 6 seconds

---

## 3. Customizing Agricultural Facts

### Add More Facts:
Edit `lib/services/agricultural_facts_service.dart`:

```dart
static const List<String> livestockFacts = [
  'Your existing facts...',
  'Add new fact here!',
  'Another interesting livestock fact!',
];
```

### Add New Categories:
```dart
// In agricultural_facts_service.dart

static const List<String> fisheryFacts = [
  'Fish farming fact 1',
  'Fish farming fact 2',
];

String getRandomFisheryFact() {
  return fisheryFacts[_random.nextInt(fisheryFacts.length)];
}
```

---

## 4. Using Individual Screens

### LoadingScreen:
```dart
// Show while loading data
LoadingScreen(
  message: 'Loading livestock data...',
)
```

### NoInternetScreen:
```dart
// Show when offline
NoInternetScreen(
  onRetry: () {
    // Your retry logic
  },
)
```

### ServerErrorScreen:
```dart
// Show when server unavailable
ServerErrorScreen(
  onRetry: () {
    // Your retry logic
  },
)
```

### InlineLoadingIndicator:
```dart
// For smaller loading states
InlineLoadingIndicator(
  message: 'Fetching data...',
  size: 40,
)
```

---

## 5. Changing Animation Speed

### Fact Carousel Speed:
In `engagement_screen.dart`:

```dart
// Current: 8 seconds per fact
Timer.periodic(const Duration(seconds: 8), (timer) { ... });

// Change to 5 seconds:
Timer.periodic(const Duration(seconds: 5), (timer) { ... });
```

### Auto-Retry Timing:
In `main.dart`:

```dart
// Current: 6 seconds between retries
Timer(const Duration(seconds: 6), () { ... });

// Change to 10 seconds:
Timer(const Duration(seconds: 10), () { ... });
```

---

## 6. Styling Options

### Change Primary Green Color:
In `lib/theme/app_theme.dart`:

```dart
static const Color primaryGreen = Color(0xFF7CB342);  // Current
// Change to darker green:
static const Color primaryGreen = Color(0xFF558B2F);
```

### Adjust Card Radius:
In any screen file:

```dart
// Current radius
borderRadius: BorderRadius.circular(16),

// Sharper corners
borderRadius: BorderRadius.circular(8),

// Rounder corners
borderRadius: BorderRadius.circular(24),
```

---

## 7. Adding Custom Lottie Animations

### Replace Agriculture Animation:
In any screen file:

```dart
Lottie.network(
  'YOUR_LOTTIE_URL_HERE',  // Change this
  repeat: true,
  fit: BoxFit.contain,
  errorBuilder: (_, __, ___) => Icon(...),  // Fallback
)
```

**Good Free Lottie Sources:**
- https://lottiefiles.com (search "agriculture", "farm", "cow", etc.)
- https://lordicon.com
- https://www.iconscout.com

---

## 8. Fact Service API

### Get Random Fact:
```dart
final service = AgriculturalFactsService();
String fact = service.getRandomFact();
```

### Get Category-Specific Fact:
```dart
String livestockFact = service.getRandomLivestockFact();
String dairyFact = service.getRandomDairyFact();
String poultryFact = service.getRandomPoultryFact();
String farmingTip = service.getRandomFarmingTip();
String healthFact = service.getRandomHealthFact();
```

### Get Multiple Facts:
```dart
List<String> facts = service.getRandomFacts(10);  // Get 10 random facts
```

### Get Facts by Category:
```dart
List<String> allLivestockFacts = service.getFactsByCategory('livestock');
List<String> allDairyFacts = service.getFactsByCategory('dairy');
```

---

## 9. Common Customizations

### Change Loading Message:
```dart
LoadingScreen(
  message: 'Your custom message here...',
)
```

### Disable Auto-Scroll:
In `engagement_screen.dart`, comment out:

```dart
// _startAutoScroll();  // Comment this line in initState
```

### Change Number of Quick Facts:
In `engagement_screen.dart`:

```dart
// Current: 4 quick facts
final quickFacts = [
  (Icons.water_drop_outlined, 'Hydration', 'Key to health'),
  (Icons.restaurant_outlined, 'Nutrition', 'Balanced diet'),
  (Icons.health_and_safety_outlined, 'Prevention', 'Regular checks'),
  (Icons.sunny_outlined, 'Environment', 'Clean & safe'),
  // Add more here!
];
```

---

## 10. Debugging & Troubleshooting

### Check Which Screen is Showing:
Add debug prints in `main.dart`:

```dart
Widget _buildFallbackScreen() {
  if (_linkState == LinkState.checking) {
    print('🔄 Showing LoadingScreen');
    return LoadingScreen(...);
  }
  if (_offline) {
    print('📡 Showing NoInternetScreen');
    return NoInternetScreen(...);
  }
  print('⚠️ Showing ServerErrorScreen');
  return ServerErrorScreen(...);
}
```

### Force Show Specific Screen:
```dart
// Temporarily replace in main.dart
Widget _buildFallbackScreen() {
  return NoInternetScreen(onRetry: _manualRetry);  // Always show this
}
```

### Test Animations:
```dart
// In any screen's build method
print('Animation loaded: ${animationLoaded}');
```

---

## 11. Integration with Existing Features

### Add Fact to Existing Widget:
```dart
import '../services/agricultural_facts_service.dart';

class YourWidget extends StatefulWidget {
  @override
  State<YourWidget> createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  final _factsService = AgriculturalFactsService();
  
  @override
  Widget build(BuildContext context) {
    return Text(_factsService.getRandomFact());
  }
}
```

### Show Loading Screen During Operation:
```dart
Future<void> fetchData() async {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: LoadingScreen(message: 'Fetching data...'),
    ),
  );
  
  await Future.delayed(Duration(seconds: 2));
  Navigator.pop(context);
}
```

---

## 12. Performance Tips

### Optimize Fact Loading:
```dart
// Preload facts at app startup (in main.dart initState)
final _factsService = AgriculturalFactsService();
final _cachedFacts = _factsService.getRandomFacts(50);
```

### Reduce Animation Load:
```dart
// Use simple icons instead of Lottie when needed
errorBuilder: (_, __, ___) => Icon(
  Icons.eco_rounded,
  size: 80,
  color: AppTheme.primaryGreen,
)
```

### Lazy Load Widgets:
```dart
// Already implemented - screens only build when shown
if (showEngagement)
  Positioned.fill(child: _buildFallbackScreen())
```

---

## 13. Localization (Future Enhancement)

### Prepare for Multi-Language:
```dart
// In agricultural_facts_service.dart

class AgriculturalFactsService {
  final String locale;
  
  AgriculturalFactsService({this.locale = 'en'});
  
  List<String> get livestockFacts {
    switch (locale) {
      case 'hi':  // Hindi
        return [...hindiLivestockFacts];
      case 'te':  // Telugu
        return [...teluguLivestockFacts];
      default:
        return [...englishLivestockFacts];
    }
  }
}
```

---

## 14. Analytics Integration (Optional)

### Track Which Screens Users See Most:
```dart
Widget _buildFallbackScreen() {
  if (_offline) {
    // Log analytics event
    // analytics.logEvent('screen_view', {'screen': 'no_internet'});
    return NoInternetScreen(...);
  }
  // ... similar for other screens
}
```

---

## 15. Quick Reference

### File Locations:
```
lib/
├── services/
│   └── agricultural_facts_service.dart  ← Add/edit facts
├── widgets/
│   ├── engagement_screen.dart           ← Auto-scroll carousel
│   ├── error_screens.dart               ← Error UI
│   └── loading_screen.dart              ← Loading UI
└── main.dart                             ← Screen routing logic
```

### Key Methods:
- `getRandomFact()` - Get any random fact
- `getRandomLivestockFact()` - Livestock-specific
- `getRandomDairyFact()` - Dairy-specific
- `getRandomPoultryFact()` - Poultry-specific
- `getRandomFarmingTip()` - Farming tips
- `getRandomHealthFact()` - Health facts

### Key Widgets:
- `LoadingScreen` - Shows during connection check
- `NoInternetScreen` - Shows when offline
- `ServerErrorScreen` - Shows when server unavailable
- `EngagementScreen` - Generic idle screen (optional)
- `InlineLoadingIndicator` - Small loading widget

---

## Need Help?

### Common Issues:

**Problem:** Animations not loading  
**Solution:** Check internet connection for Lottie network files, or animations will use fallback icons automatically

**Problem:** Facts not changing  
**Solution:** Call `_refreshFacts()` or restart the timer

**Problem:** Screen not showing  
**Solution:** Check `_linkState` value and connectivity

**Problem:** Colors look different  
**Solution:** Check `app_theme.dart` for color values

---

## Summary

🎯 **Everything works automatically** - screens show based on app state  
🔧 **Easy to customize** - change facts, colors, animations  
📚 **Well documented** - see implementation guide for details  
🚀 **Production ready** - tested and formatted  

Just run your app and the new agriculture-focused screens will work! 🌾
