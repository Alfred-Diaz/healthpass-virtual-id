# Integration Strategy: CSV First, ERP Ready

## Current MVP Approach

For early testing and rollout, HealthPass will use CSV files as the source of member, coverage, provider, claims, and doctor data.

This is useful because CSV allows the team to:

- Validate business workflows quickly
- Load real-like data without ERP integration delays
- Test provider verification
- Test claim status visibility
- Test member app screens
- Clean and standardize member data before ERP integration

## Future Production Approach

When deployed, CSV import should be replaced or supplemented by ERP connectors.

The platform must therefore use an adapter pattern:

```text
Flutter App
   |
HealthPass API
   |
Repository / Domain Services
   |
Integration Adapter Interface
   |
-----------------------------
| CSV Adapter                |
| ERP Adapter                |
| Claims System Adapter      |
| Provider System Adapter    |
-----------------------------
```

## Rule

The Flutter app and provider portal should never know whether data came from CSV, ERP, or another internal system.

They should only call HealthPass APIs.

## Data Domains

### Member Data

CSV now:

```text
members.csv
```

ERP later:

```text
ERP member master / customer master / policy master
```

### Coverage Data

CSV now:

```text
coverage.csv
```

ERP later:

```text
ERP benefits, plan, policy, utilization, ledger, or claims module
```

### Claims Data

CSV now:

```text
claims.csv
claim_events.csv
```

ERP later:

```text
ERP claims module or claims processing system
```

### Provider Data

CSV now:

```text
providers.csv
```

ERP later:

```text
Provider network master file
```

### E-Consult Data

CSV now:

```text
doctors.csv
```

Telemedicine integration later:

```text
Doctor availability API / telemedicine provider API
```

## Recommended CSV Import Flow

```text
Admin uploads CSV
        |
Validate required columns
        |
Validate data types
        |
Show preview and errors
        |
Import valid rows
        |
Store import batch log
        |
Update member, coverage, claims, provider, or doctor tables
```

## Import Batch Tracking

The production database should track every import batch.

Recommended fields:

```text
id
file_name
data_type
uploaded_by
status
rows_total
rows_success
rows_failed
error_report_url
created_at
completed_at
```

## CSV Safety Rules

- Never import directly into production tables without validation.
- Normalize member numbers before matching.
- Reject duplicate member numbers unless update mode is explicitly selected.
- Keep original CSV file in secure object storage.
- Produce row-level error reports.
- Log every import.

## ERP Migration Plan

### Phase 1: CSV MVP

- Manual CSV upload
- Scheduled import support
- Admin review before import

### Phase 2: Hybrid

- CSV still available for fallback
- ERP read-only connector added
- Nightly sync from ERP

### Phase 3: ERP Primary

- ERP becomes source of truth
- HealthPass stores optimized read models
- CSV only used for exceptional backfills or corrections

## Adapter Interface Example

```ts
export interface MemberDataSource {
  findMemberByNumber(memberNo: string): Promise<MemberDto | null>;
  listUpdatedMembersSince(date: Date): Promise<MemberDto[]>;
}
```

CSV implementation:

```ts
export class CsvMemberDataSource implements MemberDataSource {}
```

ERP implementation later:

```ts
export class ErpMemberDataSource implements MemberDataSource {}
```

The service layer uses only the interface, not the implementation.
