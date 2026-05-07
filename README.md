# SwiftPay

SwiftPay is a beginner-friendly Flutter UPI payment demo app. It uses a simple folder structure, Material 3, reusable widgets, and `setState` for state management.

## What you can learn

- Splash screen navigation with `Timer`
- Login screen UI basics
- Bottom navigation with `NavigationBar`
- Forms, controllers, and validators
- Passing callbacks between widgets
- Simple model and service classes
- Dark and light theme toggling

## Folder structure

```text
lib/
  models/
    transaction.dart
  screens/
    dashboard_screen.dart
    history_screen.dart
    home_screen.dart
    login_screen.dart
    send_money_screen.dart
    splash_screen.dart
    success_screen.dart
  services/
    transaction_service.dart
  widgets/
    app_logo.dart
    primary_button.dart
    transaction_card.dart
  main.dart
```

## Run the app

```bash
flutter pub get
flutter run
```

> Note: This is a learning app only. It does not process real UPI payments or authenticate real users.
