# Combis App - Setup & Integration Guide

## Overview
This document explains the development environment setup, project structure, and installation steps for Combis App.

## Project Structure
```text
combisapp/
├── lib/
│   ├── main.dart                      # Main app entry
│   |          # SQLite manager (singleton)
│   |                 # Database installation logic
│   ├── data/                        # Data models
│   │   ├── route.dart                 # Route model
│   │   └── street.dart                # Street model
│   ├── pages/                         # UI Pages
│   │   ├── home_page.dart             # Cales/Home page 
│   │   ├── main_screen.dart    # Search page
│   │   └── profile_page.dart 
│   |   └── routes_page.dart
│   |   └── search_page.dart  
|   ├── Theme/
|   |   └── app_theme.dart 
|   |   └── app_colors.dart       # Theme configuration
│   └── utils/
│   |   └── common.dart             # Shared utilities/ debug & error logs
|   |        
|   └── widgets/
|       └── map_widget.dart       # Map widget with polyline and marker overlays
├── data/
│   └── init.sql                       # Database schema
└── pubspec.yaml                       # Dependencies
```

## Installation Steps
### 1. Create Directories & Files
Ensure the project structure matches the layout above.
```bash
cd combisapp
mkdir -p lib/pages lib/utils lib/models data
```

### 2. Verify Dependencies
Your `pubspec.yaml` should have the required packages:
```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.4.2
  path: ^1.9.0
```
If not present, run:
```bash
flutter pub add sqflite path
flutter pub get
```

### 3. Test Run
```bash
flutter clean
flutter pub get
```

#### On Android Emulator
Start the emulator:
```bash
emulator -list-avds
emulator -avd emulator_name &
```
Run the app:
```bash
flutter run
# Or with debug: flutter run -d emulator-5554 --debug
```

### 4. Development Flow
- **First Run**: App launches and tries to access the database. If it doesn't exist, it creates it automatically. Or use the Dev tab to install it.
- **UI Changes**: Hot reload works.
- **Database Changes**: You need a full restart (`flutter run --no-fast-start`).
- **Dev Tab**: Useful to reset the database if needed.

## Testing Checklist
- [ ] App runs without errors
- [ ] Bottom navigation switches between pages
- [ ] City/Street dropdowns work perfectly
- [ ] Routes display correctly and search filters work
- [ ] Visual feedbacks (snackbars) appear

## Troubleshooting
**Error: "sqflite plugin not found"**
```bash
flutter clean
flutter pub get
```

**Emulator won't start**
Check AVDs via Android Studio or run `flutter emulators --launch <emulator_id>`.

**Hot reload not working**
Remember that database changes require a full restart.