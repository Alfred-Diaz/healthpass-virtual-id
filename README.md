# HealthPass Virtual ID

A production-oriented starter blueprint for an HMO Virtual ID platform serving approximately 130,000 members.

## Core MVP Features

1. Dynamic QR Member ID
2. Digital Insurance Card
3. Provider Scan App
4. Claim Status Tracking
5. E-Consult Integration

## Recommended Architecture

```text
Member Mobile App
Provider Web Scanner
Admin Web Portal
        |
API Gateway
        |
Auth Service
Member Service
Virtual ID Service
Provider Verification Service
Claims Service
Consultation Service
Notification Service
        |
PostgreSQL + Redis + Object Storage
```

## Technology Recommendation

- Mobile: Flutter
- Backend: NestJS or Spring Boot
- Web Portal: React / Next.js
- Database: PostgreSQL
- Cache / QR token state: Redis
- File Storage: S3-compatible storage
- Notifications: Firebase Cloud Messaging, SMS, Email
- Video Consult: Twilio Video, Zoom SDK, or WebRTC provider

## First 90-Day Build Focus

### Month 1
- Member login with OTP
- Digital insurance card
- Dynamic QR Virtual ID
- Coverage display

### Month 2
- Provider portal
- QR scanner
- Eligibility verification API
- Verification audit logs

### Month 3
- Claim status tracking
- Push notifications
- E-consult booking foundation

## Security Principles

- Never encode raw member data directly inside QR codes.
- Use short-lived signed QR tokens.
- Keep full verification server-side.
- Log every provider scan.
- Encrypt sensitive health and member data.
- Separate member, provider, and admin roles.

## Project Status

Initial scaffold for planning and implementation.
