# Arohya Development Rules & Guidelines

## Feature Folder Structure
Whenever creating or organizing a feature folder under `lib/features/<feature_name>/`, strictly adhere to the following 4-folder structure:

```
lib/features/<feature_name>/
├── screens/    # Presentation screens that import from provider, widget, models
├── provider/   # Business logic and Riverpod state management
├── widget/     # Reusable UI components and widgets specific to the feature
└── models/     # Data models for API serialization/deserialization (e.g., fromJson/toJson)
```

### Folder Responsibilities:
- **`screens/`**: Contains page/screen-level widgets (e.g., `login_screen.dart`, `onboarding_screen.dart`). These coordinate state and UI by importing providers, widgets, and models.
- **`provider/`**: Houses business logic, state notifiers, and Riverpod providers.
- **`widget/`**: Feature-specific reusable UI elements, cards, dialogs, and components.
- **`models/`**: Data classes, entity definitions, and serialization (`fromJson` / `toJson`).

## Dependencies
- **Never install or add dependencies yourself.** Do not run `flutter pub add` / `flutter pub get`, and do not edit `pubspec.yaml` to add packages.
- If a feature needs a new package, list it for the user (package name, version, and why it is needed) so they can install it manually.
- Prefer solutions built on Flutter's SDK and the packages already in `pubspec.yaml` before suggesting a new one.
