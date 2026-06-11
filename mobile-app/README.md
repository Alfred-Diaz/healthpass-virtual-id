# HealthPass Mobile App

Flutter member app for the HealthPass Virtual ID HMO platform.

## Goal

The mobile app is designed to be integration-ready for most HMO environments, including existing systems for:

- Member master records
- Claims processing
- Provider network management
- Eligibility verification
- CRM / call center tools
- Telemedicine platforms
- Payment / reimbursement systems
- Notification providers

## Architecture

```text
Flutter UI Screens
       |
View Models / State Layer
       |
Repository Layer
       |
API Client Layer
       |
Existing HMO APIs / HealthPass Backend / Third-Party Systems
```

## Integration Principles

1. Do not hardcode vendor-specific APIs inside screens.
2. Keep all external calls inside service or repository classes.
3. Use DTO models for request and response mapping.
4. Support environment-based API configuration.
5. Keep QR, claims, consult, and provider modules independent.
6. Use token-based authentication that can integrate with OAuth2, OIDC, SSO, or custom OTP systems.

## MVP Screens

- Login / OTP
- Home dashboard
- Digital insurance card
- Dynamic QR Virtual ID
- Claim status tracking
- E-consult entry screen
- Profile screen

## Recommended Flutter Packages

- dio: HTTP client
- flutter_riverpod: state management
- go_router: navigation
- qr_flutter: QR display
- flutter_secure_storage: secure token storage
- firebase_messaging: push notifications

## Local Setup

```bash
cd mobile-app
flutter pub get
flutter run
```

## Environment Configuration

Create environment-specific files or use build-time variables:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

For Android emulator, use:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```
