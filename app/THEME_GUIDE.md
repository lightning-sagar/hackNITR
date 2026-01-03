# Agricultural Theme Design System

## Overview
This document describes the visual design system for the Agricultural LMS app, featuring a clean White + Light Green palette that represents agriculture, animal livestock, growth, and sustainability.

## Design Philosophy

### Core Values
- **Trustworthy & Reliable**: Professional appearance suitable for farmers and agribusinesses
- **Data-Driven**: Clear information hierarchy and high readability
- **Nature-Connected**: Colors and visuals inspired by agriculture and growth
- **Accessible**: High contrast design optimized for outdoor lighting conditions
- **Modern & Clean**: Minimal, spacious layout with soft interactions

## Color Palette

### Primary Colors
- **Primary Green** (`#7CB342`): Soft agricultural green inspired by leaves and pastures
- **Light Green** (`#9CCC65`): Light pasture green for secondary elements
- **Mint Green** (`#A5D6A7`): Light mint/sage green for accents
- **Pale Green** (`#C5E1A5`): Very light green for subtle backgrounds

### Base Colors
- **Pure White** (`#FFFFFF`): Main surface color
- **Off-White** (`#FAFAFA`): Background color
- **Light Background** (`#F5F5F5`): Alternative background

### Accent Earth Tones (Subtle Usage)
- **Light Brown** (`#BCAAA4`): Tertiary accent
- **Muted Yellow** (`#FFF9C4`): Warning states
- **Warm Beige** (`#EFEBE9`): Subtle backgrounds

### Text Colors (High Contrast)
- **Dark Text** (`#1B5E20`): Primary text (dark green)
- **Medium Text** (`#558B2F`): Secondary text (medium green)
- **Light Text** (`#689F38`): Tertiary text (light green)
- **Subtle Text** (`#9E9E9E`): Hint text (gray)

### Status Colors
- **Success Green** (`#66BB6A`): Positive states, growth indicators
- **Warning Yellow** (`#FFEE58`): Attention needed
- **Critical Red** (`#EF5350`): Critical alerts only
- **Info Blue** (`#81C784`): Informational messages (muted blue-green)

## Design Patterns

### Cards
- **Border Radius**: 16px for soft, approachable feel
- **Elevation**: 2-4px for subtle depth
- **Shadow**: Soft, barely visible (`rgba(0,0,0,0.1)`)
- **Background**: Pure white with optional subtle green tint
- **Padding**: Generous spacing (16px minimum)

### Buttons

#### Primary (Filled)
- Background: Primary Green (`#7CB342`)
- Text: Pure White
- Border Radius: 12px
- Padding: 24px horizontal, 14px vertical
- Font Weight: 600

#### Secondary (Outlined)
- Border: Primary Green 1.5px
- Text: Primary Green
- Background: Transparent
- Border Radius: 12px

#### Tertiary (Text)
- Text: Primary Green
- Background: None
- Border Radius: 8px

### Forms & Inputs
- **Background**: Pure white
- **Border**: Light gray (`#E0E0E0`) 1.5px
- **Focus Border**: Primary Green 2px
- **Border Radius**: 12px
- **Padding**: 16px
- **Label**: Medium Text color
- **Hint**: Subtle Text with 60% opacity

### Icons
- **Size**: 24px default
- **Color**: Medium Text (`#558B2F`)
- **Style**: Outlined for lightness, filled for emphasis
- **Agricultural Icons**: Prefer farming, livestock, sensor, growth indicators

### Typography

#### Headings
- **Display Large**: 57px, weight 700, dark text
- **Display Medium**: 45px, weight 700, dark text
- **Display Small**: 36px, weight 600, dark text
- **Headline Large**: 32px, weight 600, dark text
- **Headline Medium**: 28px, weight 600, dark text
- **Headline Small**: 24px, weight 600, dark text

#### Body & Labels
- **Title Large**: 22px, weight 600, dark text
- **Title Medium**: 16px, weight 600, dark text
- **Body Large**: 16px, weight 400, dark text
- **Body Medium**: 14px, weight 400, dark text
- **Body Small**: 12px, weight 400, medium text
- **Label Large**: 14px, weight 600, dark text
- **Label Medium**: 12px, weight 600, medium text

### Spacing System
- **Extra Small**: 4px
- **Small**: 8px
- **Medium**: 12px
- **Standard**: 16px
- **Large**: 24px
- **Extra Large**: 32px
- **XXL**: 48px

## Gradients

### Background Gradient
```dart
LinearGradient(
  colors: [
    Color(0xFFFAFAFA), // Off-white
    Color(0xFFF1F8E9), // Very light green
    Color(0xFFE8F5E9), // Pale mint
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
)
```

### Card Gradient (Subtle)
```dart
LinearGradient(
  colors: [
    Color(0xFFFFFFFF), // Pure white
    Color(0xFFC5E1A5).withOpacity(0.1), // Pale green 10%
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
```

### Growth/Success Gradient
```dart
LinearGradient(
  colors: [
    Color(0xFF81C784), // Light green
    Color(0xFF66BB6A), // Medium green
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
```

## UI Components

### Dashboard Cards
- **Metric Cards**: White background, primary green accents
- **Health Cards**: Success green gradient for positive status
- **Alert Cards**: Muted yellow for warnings, red only for critical
- **Data Cards**: Clean white with subtle green borders

### Charts & Graphs
- **Primary Data**: Light green to primary green gradients
- **Background**: White with light gray gridlines
- **Text**: Dark text for labels, medium text for values
- **Accent Lines**: Primary green

### Status Indicators
- **Healthy/Good**: Success Green (`#66BB6A`)
- **Warning/Attention**: Warning Yellow (`#FFEE58`)
- **Critical/Error**: Critical Red (`#EF5350`)
- **Info/Neutral**: Mint Green (`#A5D6A7`)

### Navigation
- **Active State**: Primary Green with white text
- **Inactive State**: Medium Text color
- **Hover**: Pale Green background
- **Focus**: Primary Green border

## Animations & Interactions

### Transitions
- **Duration**: 200-350ms for most interactions
- **Easing**: `Curves.easeInOut` for smooth, natural feel
- **Micro-interactions**: Gentle scale (0.95-1.0) on press

### Loading States
- **Spinner**: Primary Green
- **Progress Bar**: Primary Green fill, Pale Green track
- **Skeleton**: Light gray shimmer

### Hover Effects
- **Cards**: Subtle elevation increase (2px → 4px)
- **Buttons**: Slight darkening of background (10%)
- **Links**: Underline in primary green

## Accessibility

### Contrast Ratios
- **Primary Text**: 4.5:1 minimum (WCAG AA)
- **Large Text**: 3:1 minimum
- **Buttons**: 4.5:1 minimum
- **Status Indicators**: 3:1 minimum

### Touch Targets
- **Minimum Size**: 44x44px
- **Spacing**: 8px minimum between targets

### Outdoor Readability
- High contrast colors for bright sunlight
- No pure black backgrounds (reduces glare)
- Clear borders and shadows for definition

## Usage Guidelines

### Do's
✅ Use primary green for important actions and key information  
✅ Keep backgrounds light and clean  
✅ Use soft shadows for depth  
✅ Apply rounded corners consistently  
✅ Use agricultural icons where appropriate  
✅ Maintain generous spacing  
✅ Use status colors purposefully  

### Don'ts
❌ Avoid dark or flashy colors  
❌ Don't overuse accent earth tones  
❌ Avoid aggressive animations  
❌ Don't use red for non-critical states  
❌ Avoid cluttered layouts  
❌ Don't use low contrast colors  

## Implementation

### Using the Theme
```dart
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MaterialApp(
    theme: AppTheme.lightTheme,
    home: MyApp(),
  ));
}
```

### Accessing Theme Colors
```dart
// In your widgets
final primaryColor = AppTheme.primaryGreen;
final backgroundColor = AppTheme.offWhite;
final textColor = AppTheme.darkText;

// Or through Theme
final theme = Theme.of(context);
final primaryColor = theme.colorScheme.primary;
```

### Using Predefined Gradients
```dart
Container(
  decoration: AppTheme.agriculturalGradient,
  child: YourContent(),
)

Container(
  decoration: AppTheme.cardGradient,
  child: YourCard(),
)
```

## Examples

### Metric Card
```dart
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.agriculture, color: AppTheme.primaryGreen),
        SizedBox(height: 8),
        Text('Livestock Health', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 4),
        Text('95% Healthy', style: Theme.of(context).textTheme.headlineMedium),
      ],
    ),
  ),
)
```

### Action Button
```dart
ElevatedButton.icon(
  onPressed: () {},
  icon: Icon(Icons.refresh),
  label: Text('Update Data'),
)
```

### Status Chip
```dart
Chip(
  avatar: Icon(Icons.check_circle, size: 18),
  label: Text('Healthy'),
  backgroundColor: AppTheme.successGreen.withOpacity(0.2),
  labelStyle: TextStyle(color: AppTheme.darkText),
)
```

## Resources

### Icon Sets (Recommended)
- Material Icons: `agriculture`, `pets`, `grass`, `eco`, `nature_people`
- Consider: Sensors, monitoring devices, livestock indicators

### Font Recommendations
- System default for optimal legibility
- Consider: Roboto, Inter, or SF Pro for consistency

### Testing
- Test in bright outdoor conditions
- Verify contrast ratios with accessibility tools
- Check on various device sizes
- Test with farmers and end users

---

**Version**: 1.0  
**Last Updated**: January 3, 2026  
**Design Team**: Agricultural LMS
