# DartPay

DartPay is an intermediate-level Flutter UPI payment learning app. It upgrades the original beginner app with Provider, GoRouter, SharedPreferences, fake API calls, loading states, error states, search, filters, and reusable widgets while keeping the code easy to follow.

> This is a learning/demo app only. It does not process real UPI payments or authenticate real users.

## What this project teaches

1. Better but still simple folder structure
2. Provider state management with `ChangeNotifier` and `notifyListeners()`
3. API integration with the `http` package
4. Proper model classes with `fromJson()` and `toJson()`
5. Local storage with `SharedPreferences`
6. Async/await, loading states, and try/catch error handling
7. Reusable UI widgets
8. Named navigation and protected routes with GoRouter
9. Search and filter UI
10. Basic animation and snackbar feedback

## Folder structure

```text
lib/
  models/
    payment_model.dart
    transaction.dart
    user_model.dart
  providers/
    auth_provider.dart
    payment_provider.dart
    theme_provider.dart
    transaction_provider.dart
  routes/
    app_routes.dart
  screens/
    dashboard_screen.dart
    history_screen.dart
    home_screen.dart
    login_screen.dart
    profile_screen.dart
    qr_scanner_screen.dart
    register_screen.dart
    send_money_screen.dart
    splash_screen.dart
    success_screen.dart
  services/
    api_service.dart
    auth_service.dart
    theme_service.dart
  utils/
    app_constants.dart
    snackbar_helper.dart
    validators.dart
  widgets/
    app_logo.dart
    balance_card.dart
    custom_button.dart
    custom_text_field.dart
    empty_state_widget.dart
    loading_widget.dart
    primary_button.dart
    transaction_card.dart
    transaction_tile.dart
  main.dart
```

## Step-by-step learning path

### 1. App startup and Provider setup

Open `lib/main.dart`. The app loads `SharedPreferences`, creates services, and registers providers with `MultiProvider` before showing the UI.

### 2. Protected navigation

Open `lib/routes/app_routes.dart`. GoRouter checks `AuthProvider` and redirects logged-out users to login while allowing logged-in users into the dashboard.

### 3. Authentication flow

Open `lib/providers/auth_provider.dart`, `lib/services/auth_service.dart`, `lib/screens/login_screen.dart`, and `lib/screens/register_screen.dart`.

- Login and register validate forms.
- AuthProvider simulates async work.
- AuthService saves the user and token locally.
- GoRouter reacts to auth changes.

### 4. API and transaction flow

Open `lib/services/api_service.dart` and `lib/providers/transaction_provider.dart`.

- `fetchTransactions()` demonstrates a GET request.
- `sendPayment()` demonstrates a POST request.
- Providers store loading, error, and data state.
- UI screens use `Consumer` to rebuild only the needed sections.

### 5. Local storage flow

Open `lib/services/theme_service.dart` and `lib/providers/theme_provider.dart`.

- Theme mode is saved with SharedPreferences.
- The profile switch toggles the theme and persists the choice.

## Run on your device

```bash
flutter pub get
flutter run
```

Useful checks:

```bash
flutter analyze
flutter test
```

## Demo login

The login screen is pre-filled with demo values:

- Mobile: `9876543210`
- PIN: `1234`

You can also create a new demo user from the register screen.
