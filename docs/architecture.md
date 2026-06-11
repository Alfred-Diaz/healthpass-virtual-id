# HealthPass Virtual ID Architecture

## Purpose

HealthPass Virtual ID is a digital identity, eligibility, claims tracking, and e-consult platform for an HMO serving approximately 130,000 members.

The Version 1.0 platform focuses on five high-impact capabilities:

1. Dynamic QR Member ID
2. Digital Insurance Card
3. Provider Scan App
4. Claim Status Tracking
5. E-Consult Integration

## High-Level Architecture

```text
Member Mobile App         Provider Portal          Admin Portal
       |                        |                       |
       +------------------------+-----------------------+
                                |
                            API Gateway
                                |
        -------------------------------------------------
        |        |         |         |          |        |
      Auth     Member   Virtual ID  Claims   Consult  Notify
     Service   Service   Service    Service  Service  Service
        |        |         |         |          |        |
        -------------------------------------------------
                                |
                         PostgreSQL Database
                                |
                         Redis Cache / Queue
                                |
                         Object Storage
```

## Core Services

### Auth Service

Responsibilities:

- OTP login
- JWT issuance
- Refresh token management
- Role-based access control
- Member, provider, admin authentication separation

### Member Service

Responsibilities:

- Member profile
- Digital insurance card
- Plan and coverage display
- Dependent relationship lookup

### Virtual ID Service

Responsibilities:

- Dynamic QR token generation
- Token signing and validation
- Token expiry and revocation
- Provider-facing verification response

### Provider Verification Service

Responsibilities:

- Provider QR scan validation
- Eligibility response
- Provider scan audit logs
- Device and user traceability

### Claims Service

Responsibilities:

- Claim status tracking
- Claim timeline events
- Claim document references
- Member claim inquiry reduction

### Consultation Service

Responsibilities:

- Specialty selection
- Doctor availability
- E-consult booking
- Meeting link storage
- Prescription and medical certificate references

### Notification Service

Responsibilities:

- Push notifications
- SMS notifications
- Email notifications
- Claim and consultation alerts

## Recommended Stack

### Backend

- NestJS
- PostgreSQL
- Redis
- Prisma or TypeORM
- JWT
- OpenAPI / Swagger

### Mobile

- Flutter
- Firebase Cloud Messaging
- Secure local storage

### Web Portals

- Next.js
- Role-based dashboards
- Camera-based QR scanning

### Infrastructure

- AWS, Azure, or GCP
- Managed PostgreSQL
- Managed Redis
- S3-compatible object storage
- Containerized deployments
- CI/CD via GitHub Actions

## Security Model

### QR Security

The QR code must never contain raw member data. It should contain only a short-lived signed token.

Bad pattern:

```text
member_no=HMO-123456
```

Recommended pattern:

```json
{
  "sid": "opaque-session-id",
  "exp": "timestamp",
  "sig": "server-signature"
}
```

The provider app sends the token to the server. The server validates the token and returns eligibility data.

### Audit Logging

Every sensitive action must be logged:

- Member login
- QR generation
- Provider scan
- Claim status update
- Admin profile view
- Consultation booking

### Data Protection

- TLS for all traffic
- Encrypted database storage
- Encrypted object storage
- Strong role boundaries
- No public exposure of health data
- No raw PHI in logs

## Scalability Notes

For 130,000 members, this platform can start as a modular monolith with service boundaries and later split into microservices when traffic grows.

Initial scale target:

- 130,000 members
- 500-2,000 providers
- Thousands of daily QR scans
- Thousands of daily claim status views
- Hundreds of daily e-consults

## Recommended Release Sequence

### Release 1

- OTP login
- Member dashboard
- Digital card
- Dynamic QR ID

### Release 2

- Provider portal
- QR scanner
- Eligibility verification API
- Provider scan logs

### Release 3

- Claims tracking
- Claim timeline
- Push notifications

### Release 4

- E-consult booking
- Doctor profiles
- Meeting links
- Prescription / certificate references
