# 🌾 Agriculture-Focused Screens - Visual Preview

## Screen Flow Overview

```
App Launch
    ↓
┌─────────────────┐
│ LoadingScreen   │ ← Checking connection
│ "Connecting..."  │
└─────────────────┘
    ↓
    ├─── ✅ Connected ───→ WebView (Agricultural LMS)
    │
    ├─── ❌ No Internet ─→ NoInternetScreen
    │                      ↓
    │                      Retry Button
    │                      ↓
    │                      (Auto-retry in background)
    │
    └─── ❌ Server Error ─→ ServerErrorScreen
                          ↓
                          Retry Button
                          ↓
                          (Auto-retry every 6s)
```

## 1. LoadingScreen Preview

```
╔════════════════════════════════════════╗
║         Smart Farming                  ║
║      Livestock Intelligence            ║
║                                        ║
║    ┌──────────────────────────┐      ║
║    │   🌱 [Lottie Animation]  │      ║
║    │    Agricultural Icon     │      ║
║    │                          │      ║
║    └──────────────────────────┘      ║
║                                        ║
║   Connecting to Agricultural LMS...    ║
║                                        ║
║   ▓▓▓▓▓▓▓▓▓▓░░░░░░░░░ (Loading bar)  ║
║                                        ║
║    ┌──────────────────────────┐      ║
║    │  Did you know? 🌾         │      ║
║    │                           │      ║
║    │  Cows drink up to 70      │      ║
║    │  liters of water per day  │      ║
║    │  in hot weather.          │      ║
║    └──────────────────────────┘      ║
╚════════════════════════════════════════╝
```

**Features:**
- Soft green gradient background (white → pale mint)
- Rotating agricultural icon/animation
- Progress bar in agricultural green
- Random farming fact during load
- Clean, professional appearance

---

## 2. NoInternetScreen Preview

```
╔════════════════════════════════════════╗
║                                        ║
║    ┌──────────────────────────┐      ║
║    │   📡❌ [Pulse Animation]  │      ║
║    │    No Signal Tower       │      ║
║    │      [Offline Badge]     │      ║
║    └──────────────────────────┘      ║
║                                        ║
║     No Internet Connection            ║
║                                        ║
║   It seems you're offline. Don't      ║
║   worry, we'll reconnect auto-        ║
║   matically when your internet        ║
║   is back.                            ║
║                                        ║
║    ┌──────────────────────────┐      ║
║    │  💡 Quick Tips            │      ║
║    │  • Try switching to Wi-Fi │      ║
║    │  • Switch to mobile data  │      ║
║    │  • Move to better signal  │      ║
║    │  • Check airplane mode    │      ║
║    └──────────────────────────┘      ║
║                                        ║
║    ┌──────────────────────────┐      ║
║    │  Did you know? 🐄  [↻]    │      ║
║    │                           │      ║
║    │  Early disease detection  │      ║
║    │  can reduce livestock     │      ║
║    │  loss by over 40%.        │      ║
║    └──────────────────────────┘      ║
║                                        ║
║    ┌──────────────────────────┐      ║
║    │      ↻ Try Again          │      ║
║    └──────────────────────────┘      ║
║                                        ║
║   ⟲ Checking connection auto...       ║
╚════════════════════════════════════════╝
```

**Features:**
- Pulsing wifi-off animation
- Clear error messaging
- Practical connectivity tips
- Educational agricultural fact with refresh
- Prominent retry button
- Auto-reconnection indicator
- Calm, reassuring tone

---

## 3. ServerErrorScreen Preview

```
╔════════════════════════════════════════╗
║                                        ║
║    ┌──────────────────────────┐      ║
║    │   ☁️❌ [Cloud Animation]  │      ║
║    │    Server Offline        │      ║
║    │    [Reconnecting...]     │      ║
║    └──────────────────────────┘      ║
║                                        ║
║       Content Unavailable             ║
║                                        ║
║   The page isn't responding right     ║
║   now. We're reconnecting auto-       ║
║   matically, or you can try again.    ║
║                                        ║
║    ┌──────────────────────────┐      ║
║    │  Farming Insight 🌾 [↻]   │      ║
║    │                           │      ║
║    │  Regular movement         │      ║
║    │  improves digestion and   │      ║
║    │  milk yield in cattle.    │      ║
║    └──────────────────────────┘      ║
║                                        ║
║    ┌──────────────────────────┐      ║
║    │   ↻ Try Again Now         │      ║
║    └──────────────────────────┘      ║
║                                        ║
║   ℹ️ Automatic reconnection in        ║
║      progress                          ║
╚════════════════════════════════════════╝
```

**Features:**
- Server error illustration
- Non-alarming messaging
- Agricultural insight during wait
- Manual retry option
- Auto-reconnection status
- Consistent agriculture theme

---

## 4. EngagementScreen Preview (Optional)

```
╔════════════════════════════════════════╗
║   🌾   Smart Farming                   ║
║      Livestock Intelligence            ║
║                                        ║
║    ┌──────────────────────────┐      ║
║    │   🐄 [Agriculture Anim]   │      ║
║    │                           │      ║
║    │  Loading your             │      ║
║    │  agricultural insights... │      ║
║    └──────────────────────────┘      ║
║                                        ║
║  ┌────────────────────────────────┐  ║
║  │    🐄                           │  ║
║  │                                 │  ║
║  │  Cows drink up to 70 liters    │  ║
║  │  of water per day in hot       │  ║
║  │  weather.                       │  ║
║  │                                 │  ║
║  └────────────────────────────────┘  ║
║         ● ○ ○ ○ ○  (Page dots)       ║
║                                        ║
║  ┌─────────┐  ┌─────────┐           ║
║  │ 💧 Hydra │  │ 🍽️ Nutri │           ║
║  │  tion    │  │  tion   │           ║
║  │ Key to   │  │ Balanced│           ║
║  │ health   │  │  diet   │           ║
║  └─────────┘  └─────────┘           ║
║  ┌─────────┐  ┌─────────┐           ║
║  │ 🏥 Preven│  │ 🌞 Envir │           ║
║  │  tion    │  │  onment │           ║
║  │ Regular  │  │ Clean & │           ║
║  │ checks   │  │  safe   │           ║
║  └─────────┘  └─────────┘           ║
║                                        ║
║    ┌──────────────────────────┐      ║
║    │   ↻ Retry Connection      │      ║
║    └──────────────────────────┘      ║
║    [ ↻ Show New Facts ]               ║
╚════════════════════════════════════════╝
```

**Features:**
- Auto-scrolling fact carousel (8s interval)
- Page indicators
- Quick facts grid (4 key topics)
- Refresh for new facts
- Retry connection button
- Educational and engaging

---

## Color Palette

```
Primary Green:   #7CB342 ██████ (Agricultural green)
Light Green:     #9CCC65 ██████ (Pasture green)
Mint Green:      #A5D6A7 ██████ (Light mint)
Pale Green:      #C5E1A5 ██████ (Very light green)

Pure White:      #FFFFFF ██████
Off-White:       #FAFAFA ██████
Light Gray:      #F5F5F5 ██████

Dark Text:       #1B5E20 ██████ (Dark green)
Medium Text:     #558B2F ██████ (Medium green)
Light Text:      #689F38 ██████ (Light green)

Success:         #66BB6A ██████
Warning:         #FFEE58 ██████
Info:            #81C784 ██████
```

---

## Icons Used

### Loading & Engagement:
- 🌾 `Icons.agriculture_rounded` - Main agriculture icon
- 🌱 `Icons.eco_rounded` - Eco/growth icon
- 🐄 `Icons.pets_rounded` - Livestock icon
- 💧 `Icons.water_drop_rounded` - Hydration
- 🍽️ `Icons.restaurant_outlined` - Nutrition
- 🏥 `Icons.health_and_safety_rounded` - Health
- 🌞 `Icons.sunny_outlined` - Environment

### Error States:
- 📡❌ `Icons.wifi_off_rounded` - No internet
- ☁️❌ `Icons.cloud_off_rounded` - Server error
- 📶 `Icons.signal_cellular_alt` - Mobile data
- 📍 `Icons.location_on_outlined` - Location
- ✈️ `Icons.airplanemode_inactive` - Airplane mode

### Actions:
- ↻ `Icons.refresh_rounded` - Retry/refresh
- 💡 `Icons.lightbulb_outline_rounded` - Tips
- ℹ️ `Icons.info_outline_rounded` - Info
- ⟲ `Icons.autorenew_rounded` - Auto-refresh

---

## Animation Types

### 1. **Lottie Animations** (with fallbacks)
   - Agriculture/farming scenes
   - Livestock animations
   - WiFi/signal animations
   - Loading spinners

### 2. **Flutter Animations**
   - Pulse animation (offline indicator)
   - Rotation animation (loading fallback)
   - Page transitions (smooth fades)
   - Carousel scrolling (auto & manual)

### 3. **Interactive Animations**
   - Page indicator transitions
   - Button press effects
   - Card hover states
   - Fact refresh animations

---

## Fact Categories & Examples

### 🐄 Livestock Facts (10)
- "Cows drink up to 70 liters of water per day in hot weather."
- "Regular movement improves digestion and milk yield in cattle."
- "Cattle have a 330-degree panoramic view around them."

### 🥛 Dairy Facts (10)
- "Fresh water access increases milk production by 5-10%."
- "The first milk after birth, colostrum, boosts calf immunity."
- "Cows produce more milk when listening to calming music."

### 🐔 Poultry Facts (10)
- "Chickens need 14-16 hours of light for optimal egg production."
- "Clean coops reduce respiratory diseases by 60%."
- "Proper ventilation prevents 70% of poultry health issues."

### 🌾 Farming Tips (10)
- "Soil testing before planting increases crop yield by 20%."
- "Early morning irrigation reduces water loss by 30%."
- "Drip irrigation saves 40-60% more water than flooding."

### 🏥 Health Facts (10)
- "Early disease detection reduces livestock loss by over 40%."
- "Vaccinations prevent 90% of common livestock diseases."
- "Clean drinking water prevents 50% of livestock illnesses."

---

## User Experience Flow

### Normal Flow:
1. User opens app
2. `LoadingScreen` appears with fact
3. Connection succeeds
4. WebView loads content
5. User browses Agricultural LMS

### Offline Flow:
1. User loses connection
2. `NoInternetScreen` appears immediately
3. Shows connectivity tips + fact
4. Auto-checks connection every 6s
5. User can manually retry
6. When online → auto-transitions to content

### Server Error Flow:
1. Server becomes unavailable
2. `ServerErrorScreen` appears
3. Shows farming insight + retry
4. Auto-retries every 6s
5. User can manually retry
6. When available → loads content

---

## Technical Features

### State Management:
- ✅ Proper state transitions
- ✅ No race conditions
- ✅ Clean state cleanup

### Performance:
- ✅ Lazy loading of widgets
- ✅ Efficient animations
- ✅ Memory management
- ✅ Background checks

### Accessibility:
- ✅ High contrast text
- ✅ Large touch targets
- ✅ Clear messaging
- ✅ Screen reader support

### Error Handling:
- ✅ Graceful degradation
- ✅ Fallback UI elements
- ✅ Clear error messages
- ✅ Recovery mechanisms

---

## Summary

All screens follow the **agriculture-first** design principle:

✅ **Educational** - Every idle moment teaches something valuable  
✅ **Practical** - Facts are actionable and relevant to farmers  
✅ **Professional** - Clean, modern design suitable for serious use  
✅ **Reassuring** - Calm language reduces user frustration  
✅ **Consistent** - Unified theme across all states  
✅ **Accessible** - Clear, readable in outdoor lighting  

The implementation transforms error states from frustrations into opportunities for learning and engagement with the agricultural community.
