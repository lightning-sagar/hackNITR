# Agricultural Theme - Quick Reference

## 🎨 Color Palette

### Primary Colors
| Color | Hex | Usage |
|-------|-----|-------|
| Primary Green | `#7CB342` | Main actions, key information |
| Light Green | `#9CCC65` | Secondary elements |
| Mint Green | `#A5D6A7` | Accents, hover states |
| Pale Green | `#C5E1A5` | Backgrounds, tints |

### Base Colors
| Color | Hex | Usage |
|-------|-----|-------|
| Pure White | `#FFFFFF` | Cards, surfaces |
| Off-White | `#FAFAFA` | Main background |
| Light Background | `#F5F5F5` | Alternative backgrounds |

### Text Colors
| Color | Hex | Usage |
|-------|-----|-------|
| Dark Text | `#1B5E20` | Primary text |
| Medium Text | `#558B2F` | Secondary text |
| Light Text | `#689F38` | Tertiary text |
| Subtle Text | `#9E9E9E` | Hints, disabled |

### Status Colors
| Color | Hex | Usage |
|-------|-----|-------|
| Success Green | `#66BB6A` | Positive states |
| Warning Yellow | `#FFEE58` | Warnings |
| Critical Red | `#EF5350` | Critical only |
| Info Blue-Green | `#81C784` | Information |

## 🎯 Key Design Principles

1. **Clean & Minimal** - Spacious layouts with generous padding
2. **High Contrast** - Optimized for outdoor readability
3. **Soft Shadows** - Subtle depth without harshness
4. **Rounded Corners** - 12-16px for approachability
5. **Agricultural Icons** - Nature-inspired visual language

## 📐 Component Sizes

- **Cards**: 16px border radius, 2-4px elevation
- **Buttons**: 12px border radius, 24px horizontal padding
- **Inputs**: 12px border radius, 16px padding
- **Icons**: 24px default size
- **Touch Targets**: 44px minimum

## 🎭 Theme Usage

```dart
import 'theme/app_theme.dart';

// In MaterialApp
MaterialApp(
  theme: AppTheme.lightTheme,
  ...
)

// Direct color access
Container(
  color: AppTheme.primaryGreen,
  ...
)

// Gradients
Container(
  decoration: AppTheme.agriculturalGradient,
  ...
)
```

## ✨ Visual Style

### Typography
- Headings: Bold, dark green text
- Body: Regular, high contrast
- Labels: Semi-bold, clear hierarchy

### Shadows
- Soft: `rgba(0,0,0,0.1)`
- Blur: 8-12px
- Offset: (0, 2-4)

### Animations
- Duration: 200-350ms
- Easing: easeInOut
- Subtle scale on press

## 🌱 Brand Feel

**Trustworthy** • **Reliable** • **Data-Driven** • **Natural** • **Professional**

The theme communicates care, stability, and transparency while balancing modern technology with agricultural tradition.
