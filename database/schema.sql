-- HealthPass Virtual ID MVP Database Schema
-- Target: HMO platform for 130,000 members

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    annual_limit NUMERIC(14,2) NOT NULL DEFAULT 0,
    requires_preauth BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    member_no VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birthdate DATE,
    mobile VARCHAR(30),
    email VARCHAR(255),
    plan_id UUID REFERENCES plans(id),
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE member_coverages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    member_id UUID NOT NULL REFERENCES members(id),
    annual_limit NUMERIC(14,2) NOT NULL DEFAULT 0,
    utilized_amount NUMERIC(14,2) NOT NULL DEFAULT 0,
    remaining_amount NUMERIC(14,2) NOT NULL DEFAULT 0,
    coverage_start DATE NOT NULL,
    coverage_end DATE NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE dependents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    principal_member_id UUID NOT NULL REFERENCES members(id),
    member_id UUID NOT NULL REFERENCES members(id),
    relationship VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE providers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    provider_type VARCHAR(50) NOT NULL,
    address TEXT,
    city VARCHAR(100),
    province VARCHAR(100),
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE qr_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    member_id UUID NOT NULL REFERENCES members(id),
    token_hash TEXT NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    revoked_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE provider_verifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_id UUID NOT NULL REFERENCES providers(id),
    member_id UUID NOT NULL REFERENCES members(id),
    result VARCHAR(30) NOT NULL,
    reason TEXT,
    device_id VARCHAR(150),
    ip_address VARCHAR(80),
    verified_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE claims (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    claim_no VARCHAR(50) UNIQUE NOT NULL,
    member_id UUID NOT NULL REFERENCES members(id),
    provider_id UUID REFERENCES providers(id),
    amount NUMERIC(14,2) NOT NULL DEFAULT 0,
    status VARCHAR(40) NOT NULL DEFAULT 'SUBMITTED',
    filed_at TIMESTAMP NOT NULL DEFAULT NOW(),
    expected_release_at TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE claim_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    claim_id UUID NOT NULL REFERENCES claims(id),
    status VARCHAR(40) NOT NULL,
    note TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE doctors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_id UUID REFERENCES providers(id),
    full_name VARCHAR(255) NOT NULL,
    specialty VARCHAR(100) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE consultations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    member_id UUID NOT NULL REFERENCES members(id),
    doctor_id UUID NOT NULL REFERENCES doctors(id),
    specialty VARCHAR(100) NOT NULL,
    status VARCHAR(40) NOT NULL DEFAULT 'REQUESTED',
    scheduled_at TIMESTAMP,
    meeting_url TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    member_id UUID REFERENCES members(id),
    channel VARCHAR(30) NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    sent_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    actor_type VARCHAR(50) NOT NULL,
    actor_id UUID,
    action VARCHAR(150) NOT NULL,
    entity_type VARCHAR(80),
    entity_id UUID,
    metadata JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_members_member_no ON members(member_no);
CREATE INDEX idx_members_status ON members(status);
CREATE INDEX idx_qr_tokens_member_expires ON qr_tokens(member_id, expires_at);
CREATE INDEX idx_claims_member_status ON claims(member_id, status);
CREATE INDEX idx_provider_verifications_member ON provider_verifications(member_id, verified_at);
CREATE INDEX idx_consultations_member_status ON consultations(member_id, status);
