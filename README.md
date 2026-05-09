# SwiftPay

SwiftPay is a real-payment capable Flutter UPI fintech learning app. It keeps the same beginner/intermediate-friendly structure, but now demonstrates real payment concepts: UPI Intent, Razorpay Checkout, QR scanning, SDK callbacks, transaction persistence, connectivity checks, and receipt UI.

> Important: this project is for learning. Use Razorpay **test mode** while learning. Production apps must create orders and verify payment signatures on a backend before delivering goods/services.

## What this upgrade teaches

1. Real UPI Intent payments with `upi_pay`
2. Razorpay Checkout integration with callback handling
3. UPI QR scanning with `mobile_scanner`
4. Payment states: success, failed, submitted, cancelled
5. Local transaction persistence with `SharedPreferences`
6. Connectivity checks with `connectivity_plus`
7. Receipt UI with copy/share and retry failed payment
8. Android/iOS permissions for camera, internet, UPI app discovery, and SDK usage
9. Provider async state management for payment loading and errors

## Folder structure

```text
lib/
  models/
    payment_model.dart
    payment_request.dart
    transaction.dart
    upi_app_model.dart
    user_model.dart
  providers/
    auth_provider.dart
    connectivity_provider.dart
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
    transaction_detail_screen.dart
  services/
    api_service.dart
    auth_service.dart
    connectivity_service.dart
    razorpay_service.dart
    theme_service.dart
    transaction_storage_service.dart
    upi_payment_service.dart
  utils/
    app_constants.dart
    snackbar_helper.dart
    upi_qr_parser.dart
    validators.dart
  widgets/
    app_logo.dart
    balance_card.dart
    custom_button.dart
    custom_text_field.dart
    empty_state_widget.dart
    loading_widget.dart
    offline_banner.dart
    transaction_tile.dart
  main.dart
```

## Step-by-step learning guide

### 1. App startup

Open `lib/main.dart`. SwiftPay loads `SharedPreferences`, creates payment/API services, and registers providers with `MultiProvider`.

### 2. UPI Intent payment flow

Open `lib/services/upi_payment_service.dart` and `lib/screens/send_money_screen.dart`.

Flow:

1. Detect installed UPI apps using `upi_pay`.
2. User selects an app such as Google Pay, PhonePe, Paytm, or BHIM.
3. SwiftPay launches the selected UPI app with receiver UPI ID, name, amount, and note.
4. The UPI app asks the user to confirm and enter UPI PIN.
5. The plugin returns a response.
6. SwiftPay parses the response and saves a receipt locally.

UPI Intent is useful because your Flutter app does **not** collect UPI PIN. The installed UPI app handles secure authorization.

### 3. Razorpay flow

Open `lib/services/razorpay_service.dart`.

Flow:

1. SwiftPay opens Razorpay Checkout with test key and amount.
2. Razorpay shows UPI/cards/wallets/netbanking options.
3. Razorpay triggers one callback:
   - payment success
   - payment failure
   - external wallet
4. SwiftPay converts the callback into a `PaymentModel`.
5. SwiftPay saves the transaction and shows the status screen.

Production note: create Razorpay orders on your backend and verify `paymentId`, `orderId`, and `signature` server-side.

### 4. QR scanning flow

Open `lib/screens/qr_scanner_screen.dart` and `lib/utils/upi_qr_parser.dart`.

Flow:

1. `mobile_scanner` opens the camera.
2. User scans a UPI QR code.
3. SwiftPay reads payloads like `upi://pay?pa=name@bank&pn=Receiver&am=100&tn=Note`.
4. The parser extracts UPI ID, receiver name, amount, and note.
5. GoRouter passes that data to the send-money screen for auto-fill.

### 5. Transaction persistence

Open `lib/services/transaction_storage_service.dart` and `lib/providers/transaction_provider.dart`.

Every payment result is stored locally using `SharedPreferences`, so the history survives app restarts. History supports search, status filters, receipt screen, and retry for failed/cancelled payments.

### 6. Connectivity handling

Open `lib/providers/connectivity_provider.dart` and `lib/widgets/offline_banner.dart`.

SwiftPay shows an offline banner and prevents opening Razorpay while offline. UPI Intent can still open installed apps, but the final payment depends on that UPI app and bank/network availability.

## Android setup

`android/app/src/main/AndroidManifest.xml` includes:

- `INTERNET`
- `ACCESS_NETWORK_STATE`
- `CAMERA`
- UPI intent package visibility through `<queries>`
- A sample `swiftpay://payment` deep link placeholder

## iOS setup

`ios/Runner/Info.plist` includes:

- `NSCameraUsageDescription` for QR scanning
- `LSApplicationQueriesSchemes` for UPI app discovery/opening

## Run on your device

Real UPI and camera features must be tested on a physical device.

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

## Security notes for real fintech apps

- Never store payment secrets in Flutter.
- Razorpay key secret must stay on your backend.
- Always verify payment signatures on the backend.
- Treat frontend callbacks as user-interface signals, not final proof of payment.
- UPI Intent responses can be unreliable across apps and platforms; verify with backend/payment provider where possible.
