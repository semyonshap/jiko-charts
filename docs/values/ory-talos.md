Directory structure:
└── ory-talos/
    ├── api/
    │   └── talos.openapi-v3.json
    ├── deployments/
    │   └── docker/
    │       ├── compose.yaml
    │       ├── Dockerfile.init
    │       ├── Dockerfile.oss.init
    │       ├── prometheus.yml
    │       ├── config/
    │       │   ├── config.oss.yaml
    │       │   ├── config.yaml
    │       │   ├── jwks.json
    │       │   └── tenants/
    │       │       ├── default.yaml
    │       │       ├── tenant1.yaml
    │       │       └── tenant2.yaml
    │       └── scripts/
    │           ├── init-db-oss.sh
    │           └── init-db.sh
    └── .docker/
        ├── Dockerfile-alpine
        ├── Dockerfile-distroless-static
        └── Dockerfile-local-build


Files Content:

================================================
FILE: api/talos.openapi-v3.json
================================================
{
  "components": {
    "schemas": {
      "AdminRevokeImportedApiKeyBody": {
        "description": "RevokeImportedApiKeyRequest revokes an imported API key by its key_id.",
        "properties": {
          "description": {
            "description": "Optional free-text explanation. Only allowed when reason is PRIVILEGE_WITHDRAWN.",
            "type": "string"
          },
          "reason": {
            "$ref": "#/components/schemas/RevocationReason"
          }
        },
        "type": "object"
      },
      "AdminRevokeIssuedApiKeyBody": {
        "description": "RevokeIssuedApiKeyRequest revokes an issued API key by its key_id.",
        "properties": {
          "description": {
            "description": "Optional free-text explanation. Only allowed when reason is PRIVILEGE_WITHDRAWN.",
            "type": "string"
          },
          "reason": {
            "$ref": "#/components/schemas/RevocationReason"
          }
        },
        "type": "object"
      },
      "AdminRotateIssuedApiKeyBody": {
        "description": "RotateIssuedApiKeyRequest is the request for AdminRotateIssuedApiKey.\n\nRotation is a custom method (AIP-136) that swaps an active key for a new\none with a fresh secret and key_id, then revokes the old key. It is not a\npartial update, so it does not carry an update_mask. Mutable fields use\npresence-based semantics: an absent field inherits from the old key, while\na present field (including an explicitly empty value) overrides.",
        "properties": {
          "ip_restriction": {
            "$ref": "#/components/schemas/IPRestriction"
          },
          "metadata": {
            "description": "metadata for the new API key. Absent (nil) inherits from the old key;\npresent (including empty Struct) overrides.",
            "type": "object"
          },
          "name": {
            "description": "name for the new API key. Absent (HasName() == false) inherits from the\nold key; present (including empty string) overrides.",
            "type": "string"
          },
          "rate_limit_policy": {
            "$ref": "#/components/schemas/RateLimitPolicy"
          },
          "scopes": {
            "description": "scopes for the new API key. Absent (nil slice) inherits from the old key;\npresent (including empty list) overrides.",
            "items": {
              "type": "string"
            },
            "type": "array"
          },
          "visibility": {
            "$ref": "#/components/schemas/KeyVisibility"
          }
        },
        "type": "object"
      },
      "Any": {
        "additionalProperties": {},
        "properties": {
          "@type": {
            "type": "string"
          }
        },
        "type": "object"
      },
      "BatchCreateImportedApiKeysErrorCode": {
        "default": "BATCH_CREATE_IMPORTED_API_KEYS_ERROR_UNSPECIFIED",
        "description": "BatchCreateImportedApiKeysErrorCode classifies per-item batch import failures.\n\n - BATCH_CREATE_IMPORTED_API_KEYS_ERROR_UNSPECIFIED: No error (import succeeded)\n - BATCH_CREATE_IMPORTED_API_KEYS_ERROR_INVALID_ARGUMENT: The key data is malformed or missing required fields\n - BATCH_CREATE_IMPORTED_API_KEYS_ERROR_ALREADY_EXISTS: A key with this identifier already exists\n - BATCH_CREATE_IMPORTED_API_KEYS_ERROR_FAILED_PRECONDITION: State conflict prevents the import\n - BATCH_CREATE_IMPORTED_API_KEYS_ERROR_INTERNAL: Server error during import\n - BATCH_CREATE_IMPORTED_API_KEYS_ERROR_RESOURCE_EXHAUSTED: Per-tenant quota cap reached",
        "enum": [
          "BATCH_CREATE_IMPORTED_API_KEYS_ERROR_UNSPECIFIED",
          "BATCH_CREATE_IMPORTED_API_KEYS_ERROR_INVALID_ARGUMENT",
          "BATCH_CREATE_IMPORTED_API_KEYS_ERROR_ALREADY_EXISTS",
          "BATCH_CREATE_IMPORTED_API_KEYS_ERROR_FAILED_PRECONDITION",
          "BATCH_CREATE_IMPORTED_API_KEYS_ERROR_INTERNAL",
          "BATCH_CREATE_IMPORTED_API_KEYS_ERROR_RESOURCE_EXHAUSTED"
        ],
        "type": "string"
      },
      "BatchCreateImportedApiKeysRequest": {
        "description": "BatchCreateImportedApiKeysRequest imports multiple external API keys in one request.\nThe maximum batch size is 1000 keys.",
        "properties": {
          "requests": {
            "items": {
              "$ref": "#/components/schemas/ImportApiKeyRequest"
            },
            "title": "Keys to import",
            "type": "array"
          }
        },
        "type": "object"
      },
      "BatchCreateImportedApiKeysResponse": {
        "description": "BatchCreateImportedApiKeysResponse returns per-item results and summary counters.",
        "properties": {
          "failure_count": {
            "format": "int32",
            "type": "integer"
          },
          "results": {
            "items": {
              "$ref": "#/components/schemas/BatchCreateImportedApiKeysResult"
            },
            "type": "array"
          },
          "success_count": {
            "format": "int32",
            "type": "integer"
          }
        },
        "type": "object"
      },
      "BatchCreateImportedApiKeysResult": {
        "description": "BatchCreateImportedApiKeysResult contains the result for one key in a batch import request.",
        "properties": {
          "error_code": {
            "$ref": "#/components/schemas/BatchCreateImportedApiKeysErrorCode"
          },
          "error_message": {
            "title": "Human-readable failure reason",
            "type": "string"
          },
          "imported_api_key": {
            "$ref": "#/components/schemas/ImportedApiKey"
          },
          "index": {
            "format": "int32",
            "title": "Zero-based index in request.requests",
            "type": "integer"
          }
        },
        "type": "object"
      },
      "BatchVerifyApiKeysRequest": {
        "properties": {
          "requests": {
            "items": {
              "$ref": "#/components/schemas/VerifyApiKeyRequest"
            },
            "type": "array"
          }
        },
        "type": "object"
      },
      "BatchVerifyApiKeysResponse": {
        "properties": {
          "results": {
            "items": {
              "$ref": "#/components/schemas/VerifyApiKeyResponse"
            },
            "type": "array"
          }
        },
        "type": "object"
      },
      "DeriveTokenRequest": {
        "properties": {
          "algorithm": {
            "$ref": "#/components/schemas/TokenAlgorithm"
          },
          "credential": {
            "title": "The API key secret (issued or imported) to derive a token from",
            "type": "string"
          },
          "custom_claims": {
            "description": "custom_claims is a JSON object whose entries are merged into the JWT\npayload (or macaroon caveats) at signing time. Reserved JWT claims\n(iss, sub, aud, exp, nbf, iat, jti) are rejected. Total serialized\nsize is capped at 4KB.",
            "type": "object"
          },
          "scopes": {
            "items": {
              "type": "string"
            },
            "type": "array"
          },
          "ttl": {
            "description": "ttl sets the expiry as a duration from now. Encoded as a\ngoogle.protobuf.Duration (string ending in \"s\", e.g. \"3600s\").\nAccepted bounds: 1s to 315360000s (~10 years). If unset or zero, the\nproject default TTL applies.\nFor convenience, the server also accepts Go-style duration strings\n(\"24h\", \"30m\", \"1h30m\") and an extended unit set (\"1d\", \"1w\", \"1mo\",\n\"1y\"; approximations: 1mo = 30d, 1y = 365d). Clients should prefer\nthe standard Duration encoding for portability.",
            "type": "string"
          }
        },
        "title": "Token derivation messages",
        "type": "object"
      },
      "DeriveTokenResponse": {
        "properties": {
          "token": {
            "$ref": "#/components/schemas/Token"
          }
        },
        "type": "object"
      },
      "GetJWKSResponse": {
        "properties": {
          "jwks": {
            "description": "A JSON Web Key Set (RFC 7517). Contains a single field `keys`, an array of JWK objects.",
            "properties": {
              "keys": {
                "description": "Array of JWK objects. Each key has at minimum `kty` (key type) and `kid` (key ID) plus key-type-specific material (e.g. `x`/`crv` for OKP/Ed25519, `n`/`e` for RSA).",
                "items": {
                  "properties": {
                    "alg": {
                      "type": "string"
                    },
                    "crv": {
                      "type": "string"
                    },
                    "e": {
                      "type": "string"
                    },
                    "kid": {
                      "type": "string"
                    },
                    "kty": {
                      "type": "string"
                    },
                    "n": {
                      "type": "string"
                    },
                    "use": {
                      "type": "string"
                    },
                    "x": {
                      "type": "string"
                    },
                    "y": {
                      "type": "string"
                    }
                  },
                  "required": [
                    "kty",
                    "kid"
                  ],
                  "type": "object"
                },
                "type": "array"
              }
            },
            "required": [
              "keys"
            ],
            "type": "object"
          }
        },
        "type": "object"
      },
      "IPRestriction": {
        "description": "IPRestriction defines IP-based access controls for an API key.\nWhen allowed_cidrs is non-empty, only requests from IPs matching at least one\nCIDR range are permitted. Empty allowed_cidrs means no IP restriction (all IPs allowed).\nIP restrictions apply to root API key and imported key verification only;\nderived tokens (JWT/macaroon) are stateless and not subject to IP checks.",
        "properties": {
          "allowed_cidrs": {
            "description": "allowed_cidrs is a list of CIDR ranges that are allowed to use this key.\nSupports both IPv4 (e.g., \"10.0.0.0/8\") and IPv6 (e.g., \"2001:db8::/32\").\nIf empty, all IPs are allowed (no restriction).",
            "items": {
              "type": "string"
            },
            "type": "array"
          }
        },
        "type": "object"
      },
      "ImportApiKeyRequest": {
        "description": "Example:\n  {\n    \"raw_key\": \"imported-key-EXAMPLE-not-a-real-secret\",\n    \"name\": \"Example imported key\",\n    \"actor_id\": \"payment-processor\",\n    \"scopes\": [\"read\", \"write\"],\n    \"ttl\": \"8760h\",  // 1 year (also accepts: 31536000s)\n    \"metadata\": {\"source\": \"example-provider\", \"environment\": \"staging\"}\n  }",
        "properties": {
          "actor_id": {
            "description": "actor_id is the identifier of the entity that owns this imported key.\nRequired so every imported key is traceable to an actor for revocation and\naudit queries.",
            "type": "string"
          },
          "ip_restriction": {
            "$ref": "#/components/schemas/IPRestriction"
          },
          "metadata": {
            "description": "metadata is a free-form JSON object for caller-defined attributes (e.g.,\nsource, environment, tags). Values may be strings, numbers, booleans,\narrays, objects, or null. Total serialized size is capped at 4KB.\nAIP-148 metadata field.",
            "type": "object"
          },
          "name": {
            "title": "Human-readable name (REQUIRED)",
            "type": "string"
          },
          "rate_limit_policy": {
            "$ref": "#/components/schemas/RateLimitPolicy"
          },
          "raw_key": {
            "title": "The actual key string to import (REQUIRED)",
            "type": "string"
          },
          "request_id": {
            "title": "Client-controlled idempotency key (AIP-155)",
            "type": "string"
          },
          "scopes": {
            "items": {
              "type": "string"
            },
            "title": "Scopes for the imported key (OPTIONAL)",
            "type": "array"
          },
          "ttl": {
            "description": "ttl sets the expiry as a duration from now. Encoded as a\ngoogle.protobuf.Duration (string ending in \"s\", e.g. \"3600s\").\nAccepted bounds: 1s to 315360000s (~10 years). If unset or zero, the\nproject default TTL applies.\nFor convenience, the server also accepts Go-style duration strings\n(\"24h\", \"30m\", \"1h30m\") and an extended unit set (\"1d\", \"1w\", \"1mo\",\n\"1y\"; approximations: 1mo = 30d, 1y = 365d). Clients should prefer\nthe standard Duration encoding for portability.",
            "type": "string"
          },
          "visibility": {
            "$ref": "#/components/schemas/KeyVisibility"
          }
        },
        "title": "ImportApiKeyRequest imports an external HMAC-based API key",
        "type": "object"
      },
      "ImportedApiKey": {
        "description": "ImportedApiKey represents an API key imported from an external system.\nThe raw key is hashed (SHA-512/256) and stored. The original key is never retained.",
        "properties": {
          "actor_id": {
            "type": "string"
          },
          "create_time": {
            "format": "date-time",
            "type": "string"
          },
          "expire_time": {
            "format": "date-time",
            "type": "string"
          },
          "ip_restriction": {
            "$ref": "#/components/schemas/IPRestriction"
          },
          "key_id": {
            "title": "SHA-512/256 hash of credential",
            "type": "string"
          },
          "last_used_time": {
            "format": "date-time",
            "type": "string"
          },
          "metadata": {
            "description": "metadata is a free-form JSON object for caller-defined attributes\n(e.g., source, environment, tags). Values may be strings, numbers,\nbooleans, arrays, objects, or null. Total serialized size is capped\nat 4KB. AIP-148 metadata field.",
            "type": "object"
          },
          "name": {
            "type": "string"
          },
          "rate_limit_policy": {
            "$ref": "#/components/schemas/RateLimitPolicy"
          },
          "revocation_description": {
            "description": "revocation_description provides free-form context for a revocation.\nOnly set when revocation_reason is PRIVILEGE_WITHDRAWN.\nJSON API change: field was formerly revocation_reason_text. Field number 13\nis unchanged so the change is wire-compatible for binary proto encoding.",
            "type": "string"
          },
          "revocation_reason": {
            "$ref": "#/components/schemas/RevocationReason"
          },
          "scopes": {
            "items": {
              "type": "string"
            },
            "type": "array"
          },
          "status": {
            "$ref": "#/components/schemas/KeyStatus"
          },
          "update_time": {
            "format": "date-time",
            "type": "string"
          },
          "visibility": {
            "$ref": "#/components/schemas/KeyVisibility"
          }
        },
        "type": "object"
      },
      "IssueApiKeyRequest": {
        "properties": {
          "actor_id": {
            "type": "string"
          },
          "ip_restriction": {
            "$ref": "#/components/schemas/IPRestriction"
          },
          "metadata": {
            "description": "metadata is a free-form JSON object for caller-defined attributes\n(e.g., source, environment, tags). Values may be strings, numbers,\nbooleans, arrays, objects, or null. Total serialized size is capped\nat 4KB. AIP-148 metadata field.",
            "type": "object"
          },
          "name": {
            "type": "string"
          },
          "rate_limit_policy": {
            "$ref": "#/components/schemas/RateLimitPolicy"
          },
          "request_id": {
            "title": "Client-controlled idempotency key (AIP-155)",
            "type": "string"
          },
          "scopes": {
            "items": {
              "type": "string"
            },
            "type": "array"
          },
          "ttl": {
            "description": "ttl sets the expiry as a duration from now. Encoded as a\ngoogle.protobuf.Duration (string ending in \"s\", e.g. \"3600s\").\nAccepted bounds: 1s to 315360000s (~10 years). If unset or zero, the\nproject default TTL applies.\nFor convenience, the server also accepts Go-style duration strings\n(\"24h\", \"30m\", \"1h30m\") and an extended unit set (\"1d\", \"1w\", \"1mo\",\n\"1y\"; approximations: 1mo = 30d, 1y = 365d). Clients should prefer\nthe standard Duration encoding for portability.",
            "type": "string"
          },
          "visibility": {
            "$ref": "#/components/schemas/KeyVisibility"
          }
        },
        "type": "object"
      },
      "IssueApiKeyResponse": {
        "properties": {
          "issued_api_key": {
            "$ref": "#/components/schemas/IssuedApiKey"
          },
          "secret": {
            "title": "Only returned on creation",
            "type": "string"
          }
        },
        "type": "object"
      },
      "IssuedApiKey": {
        "description": "IssuedApiKey represents an API key issued (generated) by Talos.\nRoot keys are opaque v1 format tokens stored in the database.\nDerived tokens (JWT/Macaroon) are created via DeriveToken and are stateless (not stored).",
        "properties": {
          "actor_id": {
            "type": "string"
          },
          "create_time": {
            "format": "date-time",
            "type": "string"
          },
          "expire_time": {
            "format": "date-time",
            "type": "string"
          },
          "ip_restriction": {
            "$ref": "#/components/schemas/IPRestriction"
          },
          "key_id": {
            "type": "string"
          },
          "last_used_time": {
            "format": "date-time",
            "type": "string"
          },
          "metadata": {
            "description": "metadata is a free-form JSON object for caller-defined attributes\n(e.g., source, environment, tags). Values may be strings, numbers,\nbooleans, arrays, objects, or null. Total serialized size is capped\nat 4KB. AIP-148 metadata field.",
            "type": "object"
          },
          "name": {
            "type": "string"
          },
          "rate_limit_policy": {
            "$ref": "#/components/schemas/RateLimitPolicy"
          },
          "revocation_description": {
            "description": "revocation_description provides free-form context for a revocation.\nOnly set when revocation_reason is PRIVILEGE_WITHDRAWN.\nJSON API change: field was formerly revocation_reason_text. Field number 13\nis unchanged so the change is wire-compatible for binary proto encoding.",
            "type": "string"
          },
          "revocation_reason": {
            "$ref": "#/components/schemas/RevocationReason"
          },
          "scopes": {
            "items": {
              "type": "string"
            },
            "type": "array"
          },
          "status": {
            "$ref": "#/components/schemas/KeyStatus"
          },
          "update_time": {
            "format": "date-time",
            "type": "string"
          },
          "visibility": {
            "$ref": "#/components/schemas/KeyVisibility"
          }
        },
        "type": "object"
      },
      "KeyStatus": {
        "default": "KEY_STATUS_UNSPECIFIED",
        "description": "KeyStatus represents the lifecycle state of an API key.\n\n - KEY_STATUS_UNSPECIFIED: Default zero value. Never returned by the server. Treated as ACTIVE for\nbackward compatibility but should not be relied on.\n - KEY_STATUS_ACTIVE: The key is valid and can be used to authenticate.\n - KEY_STATUS_REVOKED: The key was revoked and can no longer authenticate. On the API key object,\nthe revocation_reason field carries the cause (set via the admin and\nself-revocation flows). Verification responses do not include this status:\na revoked key fails verification with error_code VERIFICATION_ERROR_REVOKED.\n - KEY_STATUS_EXPIRED: The key passed its expire_time. Verification fails with\nVERIFICATION_ERROR_EXPIRED. The transition is computed at read time and\nnot persisted.",
        "enum": [
          "KEY_STATUS_UNSPECIFIED",
          "KEY_STATUS_ACTIVE",
          "KEY_STATUS_REVOKED",
          "KEY_STATUS_EXPIRED"
        ],
        "type": "string"
      },
      "KeyVisibility": {
        "default": "KEY_VISIBILITY_UNSPECIFIED",
        "description": "KeyVisibility distinguishes public (client-safe) keys from secret (server-only) keys.\nPublic keys use a different configurable prefix for visual distinction.\nBoth types share the same scope/permission system — visibility is about exposure safety.\n\n - KEY_VISIBILITY_UNSPECIFIED: Treated as SECRET",
        "enum": [
          "KEY_VISIBILITY_UNSPECIFIED",
          "KEY_VISIBILITY_SECRET",
          "KEY_VISIBILITY_PUBLIC"
        ],
        "type": "string"
      },
      "ListImportedApiKeysResponse": {
        "properties": {
          "imported_api_keys": {
            "items": {
              "$ref": "#/components/schemas/ImportedApiKey"
            },
            "title": "List of imported keys",
            "type": "array"
          },
          "next_page_token": {
            "title": "Token for fetching the next page (empty if no more results)",
            "type": "string"
          }
        },
        "title": "ListImportedApiKeysResponse returns paginated list of imported keys",
        "type": "object"
      },
      "ListIssuedApiKeysResponse": {
        "properties": {
          "issued_api_keys": {
            "items": {
              "$ref": "#/components/schemas/IssuedApiKey"
            },
            "type": "array"
          },
          "next_page_token": {
            "type": "string"
          }
        },
        "type": "object"
      },
      "NullValue": {
        "default": "NULL_VALUE",
        "description": "`NullValue` is a singleton enumeration to represent the null value for the\n`Value` type union.\n\nThe JSON representation for `NullValue` is JSON `null`.\n\n - NULL_VALUE: Null value.",
        "enum": [
          "NULL_VALUE"
        ],
        "type": "string"
      },
      "RateLimitPolicy": {
        "description": "RateLimitPolicy describes the rate limit policy for an API key.\n\nIn OSS mode, this policy is informational and meant to be consumed by\nupstream gateways (Envoy, Cloudflare, etc.) for enforcement.\nIn commercial mode, Talos enforces rate limits using in-memory or Redis backends,\nboth powered by the GCRA (Generic Cell Rate Algorithm).\n\nCompliant with draft-ietf-httpapi-ratelimit-headers-10.",
        "properties": {
          "quota": {
            "description": "quota is the number of requests allowed per window.",
            "format": "int64",
            "type": "string"
          },
          "unit": {
            "title": "unit describes the quota unit type.\nDefault: \"requests\"\nOther valid values per IETF spec: \"content-bytes\", \"concurrent-requests\"",
            "type": "string"
          },
          "window": {
            "description": "window is the time window for the quota.\nCommon values: 60s (1 minute), 3600s (1 hour), 86400s (1 day).",
            "type": "string"
          }
        },
        "type": "object"
      },
      "RevocationReason": {
        "default": "REVOCATION_REASON_UNSPECIFIED",
        "description": "RevocationReason provides structured revocation reasons inspired by RFC 5280.\nUsed in both admin and self-revocation flows.\n\n - REVOCATION_REASON_UNSPECIFIED: Default zero value. Use a specific reason; UNSPECIFIED is rejected by\nadmin and self-revocation endpoints.\n - REVOCATION_REASON_KEY_COMPROMISE: The key was leaked or believed to be in the hands of an unauthorized\nparty.\n - REVOCATION_REASON_AFFILIATION_CHANGED: The owning actor's relationship with the issuer changed (e.g., role\nchange, departure).\n - REVOCATION_REASON_SUPERSEDED: A new key has replaced this one as part of a rotation.\n - REVOCATION_REASON_PRIVILEGE_WITHDRAWN: Admin-only. The actor's privilege to use this key was withdrawn by\nan operator. Self-revocation requests using this reason are rejected\nwith InvalidArgument. Pair with `description` on the admin revoke requests\nto record the operator-supplied justification.",
        "enum": [
          "REVOCATION_REASON_UNSPECIFIED",
          "REVOCATION_REASON_KEY_COMPROMISE",
          "REVOCATION_REASON_AFFILIATION_CHANGED",
          "REVOCATION_REASON_SUPERSEDED",
          "REVOCATION_REASON_PRIVILEGE_WITHDRAWN"
        ],
        "type": "string"
      },
      "RotateIssuedApiKeyResponse": {
        "properties": {
          "issued_api_key": {
            "$ref": "#/components/schemas/IssuedApiKey"
          },
          "old_issued_api_key": {
            "$ref": "#/components/schemas/IssuedApiKey"
          },
          "secret": {
            "title": "secret is the new API key secret (only returned once, never retrievable again)",
            "type": "string"
          }
        },
        "type": "object"
      },
      "SelfRevokeApiKeyRequest": {
        "description": "SelfRevokeApiKeyRequest allows an API key holder to revoke their own key\nby providing the full key secret as proof of possession.",
        "properties": {
          "credential": {
            "title": "Full API key secret or imported key (REQUIRED)",
            "type": "string"
          },
          "reason": {
            "$ref": "#/components/schemas/RevocationReason"
          }
        },
        "type": "object"
      },
      "SelfRevokeApiKeyResponse": {
        "description": "SelfRevokeApiKeyResponse is returned on successful self-revocation.\n\nEmpty on success",
        "type": "object"
      },
      "Status": {
        "properties": {
          "code": {
            "format": "int32",
            "type": "integer"
          },
          "details": {
            "items": {
              "$ref": "#/components/schemas/Any"
            },
            "type": "array"
          },
          "message": {
            "type": "string"
          }
        },
        "type": "object"
      },
      "Token": {
        "properties": {
          "claims": {
            "description": "claims is the decoded token payload. For JWT, this contains the\nstandard claims (iss, sub, aud, exp, iat, jti) plus custom claims.\nFor macaroons, this lists the caveats. The shape is backend-dependent\nand should be treated as opaque diagnostic data.",
            "type": "object"
          },
          "expire_time": {
            "format": "date-time",
            "type": "string"
          },
          "scopes": {
            "items": {
              "type": "string"
            },
            "type": "array"
          },
          "token": {
            "description": "The encoded token string. JWT tokens are signed JWS in compact\nserialization (header.payload.signature). Macaroons are base64-encoded\nbinary blobs.",
            "type": "string"
          }
        },
        "title": "Token represents a short-lived derived token (JWT or Macaroon)",
        "type": "object"
      },
      "TokenAlgorithm": {
        "default": "TOKEN_ALGORITHM_UNSPECIFIED",
        "description": "- TOKEN_ALGORITHM_JWT: JWT with EdDSA (self-contained, signed)\n - TOKEN_ALGORITHM_MACAROON: Macaroon with HMAC (self-contained, caveat-based)",
        "enum": [
          "TOKEN_ALGORITHM_UNSPECIFIED",
          "TOKEN_ALGORITHM_JWT",
          "TOKEN_ALGORITHM_MACAROON"
        ],
        "title": "TokenAlgorithm specifies the cryptographic algorithm used for derived tokens\nNote: API keys (root tokens) are always opaque; this enum is only for DeriveToken",
        "type": "string"
      },
      "VerificationErrorCode": {
        "default": "VERIFICATION_ERROR_UNSPECIFIED",
        "description": "- VERIFICATION_ERROR_UNSPECIFIED: No error (key is valid)\n - VERIFICATION_ERROR_INVALID_FORMAT: Credential format is invalid\n - VERIFICATION_ERROR_EXPIRED: Credential has expired\n - VERIFICATION_ERROR_REVOKED: Credential has been revoked\n - VERIFICATION_ERROR_NOT_FOUND: Credential not found in database\n - VERIFICATION_ERROR_SIGNATURE_INVALID: Cryptographic signature verification failed\n - VERIFICATION_ERROR_INTERNAL: Internal server error during verification\n - VERIFICATION_ERROR_IP_NOT_ALLOWED: Request IP is not in the key's allowed CIDR ranges\n - VERIFICATION_ERROR_RATE_LIMITED: Rate limit quota exhausted (commercial-only)",
        "enum": [
          "VERIFICATION_ERROR_UNSPECIFIED",
          "VERIFICATION_ERROR_INVALID_FORMAT",
          "VERIFICATION_ERROR_EXPIRED",
          "VERIFICATION_ERROR_REVOKED",
          "VERIFICATION_ERROR_NOT_FOUND",
          "VERIFICATION_ERROR_SIGNATURE_INVALID",
          "VERIFICATION_ERROR_INTERNAL",
          "VERIFICATION_ERROR_IP_NOT_ALLOWED",
          "VERIFICATION_ERROR_RATE_LIMITED"
        ],
        "title": "VerificationErrorCode provides type-safe error codes for verification failures",
        "type": "string"
      },
      "VerifyApiKeyRequest": {
        "properties": {
          "credential": {
            "title": "API key or derived token (any format: sk_*, JWT, macaroon)",
            "type": "string"
          }
        },
        "type": "object"
      },
      "VerifyApiKeyResponse": {
        "properties": {
          "actor_id": {
            "type": "string"
          },
          "error_code": {
            "$ref": "#/components/schemas/VerificationErrorCode"
          },
          "error_message": {
            "title": "Human-readable error message (only set if is_valid=false)",
            "type": "string"
          },
          "expire_time": {
            "format": "date-time",
            "type": "string"
          },
          "is_valid": {
            "description": "is_valid reports whether verification succeeded. It is true only when the\ncredential parses, the signature checks out, the key was found, all\npolicy gates (expiry, revocation, IP allowlist, rate limit) pass, and the\nkey's status is KEY_STATUS_ACTIVE. When false, error_code and\nerror_message describe the reason. Use this field for authentication\ndecisions; use status to inspect lifecycle state independently.",
            "type": "boolean"
          },
          "issuer": {
            "description": "The configured token issuer for this project. For derived tokens (JWT/macaroon),\nthis matches the iss claim embedded in the verified token.",
            "type": "string"
          },
          "key_id": {
            "type": "string"
          },
          "metadata": {
            "description": "metadata mirrors the metadata stored on the verified key. AIP-148\nmetadata field.",
            "type": "object"
          },
          "rate_limit_policy": {
            "$ref": "#/components/schemas/RateLimitPolicy"
          },
          "rate_limit_remaining": {
            "description": "Approximate number of requests available before the rate limit is reached\n(commercial-only, only set when enforcement is active).",
            "format": "int64",
            "type": "string"
          },
          "rate_limit_reset_time": {
            "description": "Time when the rate limiter returns to full capacity (all quota recovered).",
            "format": "date-time",
            "type": "string"
          },
          "scopes": {
            "items": {
              "type": "string"
            },
            "type": "array"
          },
          "status": {
            "$ref": "#/components/schemas/KeyStatus"
          },
          "visibility": {
            "$ref": "#/components/schemas/KeyVisibility"
          }
        },
        "type": "object"
      }
    }
  },
  "info": {
    "description": "Ory Talos is a high-performance API key management service. It handles the full API key lifecycle: issuing keys, verifying them at low latency, deriving short-lived tokens (JWT and Macaroon), and revoking access.\n\n## Authentication\n\n`Admin*`-prefixed RPCs require admin authentication: send a bearer token in the `Authorization` header. Talos does not bundle an identity provider for the admin surface, so deploy it behind your own authentication and authorization. The self-service `RevokeApiKey` RPC is the exception: it authenticates by proof of possession (the caller supplies the raw credential secret) and needs no admin token.\n\n## API surfaces\n\nTalos is a single binary with three deployment modes: **admin** (the full lifecycle and verification surface), **self-service** (only proof-of-possession self-revocation for credential holders), and **all-in-one** (both surfaces in one process). Run the admin and self-service surfaces separately to keep the privileged API off the public network.\n\n## Requests and responses\n\nThe API speaks JSON over HTTP. All paths are versioned under `/v2alpha1/`. Errors use the standard `google.rpc.Status` shape with a numeric `code`, a human-readable `message`, and a `details` array for machine-readable context.\n\n## Versioning and stability\n\nThis is `v2alpha1`. While the API is in alpha, request and response shapes may change without notice. Pin to a specific build and review the release notes before upgrading.",
    "title": "Ory Talos API",
    "version": "v2alpha1"
  },
  "openapi": "3.0.3",
  "paths": {
    "/v2alpha1/admin/apiKeys:batchVerify": {
      "post": {
        "description": "Verifies multiple credentials in a single request. Efficiently verifies up\nto 100 credentials in parallel. Each credential is verified independently;\npartial failures are returned. Admin access only.\n\nCache Control (HTTP Headers):\n  - Cache-Control: no-cache  - Bypasses cache read, forces fresh DB lookup\n  - Cache-Control: no-store  - Bypasses cache read AND write (never cached)\n  - Pragma: no-cache         - Same as Cache-Control: no-cache (HTTP/1.0)\n\nThe cache directive applies to every credential in the batch.\n\n```http\nPOST /v2alpha1/admin/apiKeys:batchVerify\n{\n  \"requests\": [\n    {\"credential\": \"sk_live_abc123...\"},\n    {\"credential\": \"eyJhbGciOiJFZERTQSI...\"}\n  ]\n}\n```",
        "operationId": "adminBatchVerifyApiKeys",
        "parameters": [
          {
            "description": "Cache-directive controlling the verifier cache. `no-cache` forces a fresh database lookup (cache read is bypassed). `no-store` additionally prevents the result from being written to the cache. Any other value is ignored.",
            "in": "header",
            "name": "Cache-Control",
            "schema": {
              "type": "string"
            }
          },
          {
            "description": "HTTP/1.0 alias for `Cache-Control: no-cache`. Behaves identically when set to `no-cache`; ignored otherwise.",
            "in": "header",
            "name": "Pragma",
            "schema": {
              "type": "string"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/BatchVerifyApiKeysRequest"
              }
            }
          },
          "required": true,
          "x-originalParamName": "body"
        },
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/BatchVerifyApiKeysResponse"
                }
              }
            },
            "description": "A successful response."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Batch Verify API Keys",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/admin/apiKeys:derive": {
      "post": {
        "description": "Mints a short-lived JWT or Macaroon token from an API key. Works with both\nissued and imported keys. The derived token inherits the permissions of the\nparent API key.\n\n```http\nPOST /v2alpha1/admin/apiKeys:derive\n{\n  \"credential\": \"eyJhbGciOiJFZERTQSI...\",\n  \"ttl\": \"1h\"\n}\n```",
        "operationId": "adminDeriveToken",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/DeriveTokenRequest"
              }
            }
          },
          "required": true,
          "x-originalParamName": "body"
        },
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/DeriveTokenResponse"
                }
              }
            },
            "description": "A successful response."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Derive Token",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/admin/apiKeys:verify": {
      "post": {
        "description": "Verifies a single API key or derived token. Validates the credential's\nsignature, expiration, and revocation status. Works with any credential\ntype (issued keys, imported keys, JWT, macaroon). The verification result\nincludes decoded claims and metadata — admin access only.\n\nCache Control (HTTP Headers):\n  - Cache-Control: no-cache  - Bypasses cache read, forces fresh DB lookup\n  - Cache-Control: no-store  - Bypasses cache read AND write (never cached)\n  - Pragma: no-cache         - Same as Cache-Control: no-cache (HTTP/1.0)\n\n```http\nPOST /v2alpha1/admin/apiKeys:verify\n{\n  \"credential\": \"sk_live_abc123...\"\n}\n```",
        "operationId": "adminVerifyApiKey",
        "parameters": [
          {
            "description": "Cache-directive controlling the verifier cache. `no-cache` forces a fresh database lookup (cache read is bypassed). `no-store` additionally prevents the result from being written to the cache. Any other value is ignored.",
            "in": "header",
            "name": "Cache-Control",
            "schema": {
              "type": "string"
            }
          },
          {
            "description": "HTTP/1.0 alias for `Cache-Control: no-cache`. Behaves identically when set to `no-cache`; ignored otherwise.",
            "in": "header",
            "name": "Pragma",
            "schema": {
              "type": "string"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/VerifyApiKeyRequest"
              }
            }
          },
          "required": true,
          "x-originalParamName": "body"
        },
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/VerifyApiKeyResponse"
                }
              }
            },
            "description": "A successful response."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Verify API Key",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/admin/importedApiKeys": {
      "get": {
        "description": "Lists all imported keys with filtering. Returns imported keys only (not\nissued keys). Supports pagination and AIP-160 filter expressions.\n\n```http\nGET /v2alpha1/admin/importedApiKeys?page_size=50\u0026filter=status%3DKEY_STATUS_ACTIVE\n```",
        "operationId": "adminListImportedApiKeys",
        "parameters": [
          {
            "description": "Number of items per page (default: 50, max: 1000)",
            "in": "query",
            "name": "page_size",
            "schema": {
              "format": "int32",
              "type": "integer"
            }
          },
          {
            "description": "Cursor token for pagination (OPTIONAL)",
            "in": "query",
            "name": "page_token",
            "schema": {
              "type": "string"
            }
          },
          {
            "description": "filter is an AIP-160 expression. Indexed fields (efficient at any scale):\n  actor_id, status. Other fields are not indexed and may be rejected.\nExamples:\n  actor_id=\"user_123\"\n  status=KEY_STATUS_ACTIVE\n  actor_id=\"user_123\" AND status=KEY_STATUS_ACTIVE",
            "in": "query",
            "name": "filter",
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ListImportedApiKeysResponse"
                }
              }
            },
            "description": "A successful response."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "List Imported API Keys",
        "tags": [
          "ApiKeys"
        ]
      },
      "post": {
        "description": "Imports an external API key into the system. Allows importing keys from\nlegacy systems or external providers. The raw key is hashed and stored\nsecurely (HMAC). Imported keys support token derivation (JWT/Macaroon)\nlike issued keys.\n\n```http\nPOST /v2alpha1/admin/importedApiKeys\n{\n  \"raw_key\": \"imported-key-EXAMPLE-not-a-real-secret\",\n  \"name\": \"Example imported key\",\n  \"actor_id\": \"user_123\"\n}\n```",
        "operationId": "adminImportApiKey",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/ImportApiKeyRequest"
              }
            }
          },
          "description": "Example:\n  {\n    \"raw_key\": \"imported-key-EXAMPLE-not-a-real-secret\",\n    \"name\": \"Example imported key\",\n    \"actor_id\": \"payment-processor\",\n    \"scopes\": [\"read\", \"write\"],\n    \"ttl\": \"8760h\",  // 1 year (also accepts: 31536000s)\n    \"metadata\": {\"source\": \"example-provider\", \"environment\": \"staging\"}\n  }",
          "required": true,
          "x-originalParamName": "body"
        },
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ImportedApiKey"
                }
              }
            },
            "description": "A successful response."
          },
          "201": {
            "content": {
              "application/json": {
                "schema": {}
              }
            },
            "description": "API key imported successfully."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Import API Key",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/admin/importedApiKeys/{imported_api_key.key_id}": {
      "patch": {
        "description": "Updates metadata, scopes, or rate limits of an imported key. Supports\npartial updates via the update_mask query parameter (AIP-134). Omitting\nupdate_mask is equivalent to a mask of every populated field in the body.\nTo clear a field to its zero value, list it explicitly in update_mask and\nleave it unset (or empty) in the body.\n\n```http\nPATCH /v2alpha1/admin/importedApiKeys/{key_id}?update_mask=name\n{\n  \"imported_api_key\": {\n    \"key_id\": \"{key_id}\",\n    \"name\": \"New name\"\n  }\n}\n```",
        "operationId": "adminUpdateImportedApiKey",
        "parameters": [
          {
            "description": "SHA-512/256 hash of credential",
            "in": "path",
            "name": "imported_api_key.key_id",
            "required": true,
            "schema": {
              "type": "string"
            }
          },
          {
            "description": "The list of fields to update. See AIP-134.",
            "in": "query",
            "name": "update_mask",
            "schema": {
              "type": "string"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "description": "ImportedApiKey represents an API key imported from an external system.\nThe raw key is hashed (SHA-512/256) and stored. The original key is never retained.",
                "properties": {
                  "actor_id": {
                    "type": "string"
                  },
                  "create_time": {
                    "format": "date-time",
                    "type": "string"
                  },
                  "expire_time": {
                    "format": "date-time",
                    "type": "string"
                  },
                  "ip_restriction": {
                    "$ref": "#/components/schemas/IPRestriction"
                  },
                  "last_used_time": {
                    "format": "date-time",
                    "type": "string"
                  },
                  "metadata": {
                    "description": "metadata is a free-form JSON object for caller-defined attributes\n(e.g., source, environment, tags). Values may be strings, numbers,\nbooleans, arrays, objects, or null. Total serialized size is capped\nat 4KB. AIP-148 metadata field.",
                    "type": "object"
                  },
                  "name": {
                    "type": "string"
                  },
                  "rate_limit_policy": {
                    "$ref": "#/components/schemas/RateLimitPolicy"
                  },
                  "revocation_description": {
                    "description": "revocation_description provides free-form context for a revocation.\nOnly set when revocation_reason is PRIVILEGE_WITHDRAWN.\nJSON API change: field was formerly revocation_reason_text. Field number 13\nis unchanged so the change is wire-compatible for binary proto encoding.",
                    "type": "string"
                  },
                  "revocation_reason": {
                    "$ref": "#/components/schemas/RevocationReason"
                  },
                  "scopes": {
                    "items": {
                      "type": "string"
                    },
                    "type": "array"
                  },
                  "status": {
                    "$ref": "#/components/schemas/KeyStatus"
                  },
                  "update_time": {
                    "format": "date-time",
                    "type": "string"
                  },
                  "visibility": {
                    "$ref": "#/components/schemas/KeyVisibility"
                  }
                },
                "type": "object"
              }
            }
          },
          "required": true,
          "x-originalParamName": "imported_api_key"
        },
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ImportedApiKey"
                }
              }
            },
            "description": "A successful response."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Update Imported API Key",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/admin/importedApiKeys/{key_id}": {
      "delete": {
        "description": "Permanently deletes an imported key (hard delete). The key is removed from\nthe database. Use AdminRevokeImportedApiKey for soft deletion (recommended).\n\n```http\nDELETE /v2alpha1/admin/importedApiKeys/{key_id}\n```",
        "operationId": "adminDeleteImportedApiKey",
        "parameters": [
          {
            "description": "SHA512/256 hash of the imported key (REQUIRED)",
            "in": "path",
            "name": "key_id",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "type": "object"
                }
              }
            },
            "description": "A successful response."
          },
          "204": {
            "description": "Imported key deleted successfully."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Delete Imported API Key",
        "tags": [
          "ApiKeys"
        ]
      },
      "get": {
        "description": "Retrieves details about a specific imported key. Returns metadata about\nthe imported key. The original raw key is never returned.\n\n```http\nGET /v2alpha1/admin/importedApiKeys/{key_id}\n```",
        "operationId": "adminGetImportedApiKey",
        "parameters": [
          {
            "description": "SHA512/256 hash of the imported key (REQUIRED)",
            "in": "path",
            "name": "key_id",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ImportedApiKey"
                }
              }
            },
            "description": "A successful response."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Get Imported API Key",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/admin/importedApiKeys/{key_id}:revoke": {
      "post": {
        "description": "Immediately revokes an imported API key. Once revoked, the key can no longer\nbe used for authentication. This operation is irreversible. Revoked keys\nare retained for audit purposes.\n\n```http\nPOST /v2alpha1/admin/importedApiKeys/9a3f051b2c7e8d4f1a6b9c0e5f2d8a3b:revoke\n{\n  \"reason\": \"REVOCATION_REASON_KEY_COMPROMISE\"\n}\n```",
        "operationId": "adminRevokeImportedApiKey",
        "parameters": [
          {
            "description": "SHA-512/256 hash of the imported key (REQUIRED)",
            "in": "path",
            "name": "key_id",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/AdminRevokeImportedApiKeyBody"
              }
            }
          },
          "required": true,
          "x-originalParamName": "body"
        },
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "type": "object"
                }
              }
            },
            "description": "A successful response."
          },
          "204": {
            "description": "API key revoked successfully."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Revoke Imported API Key",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/admin/importedApiKeys:batchCreate": {
      "post": {
        "description": "Imports up to 1000 external API keys in one request. Returns per-item\nresults. If at least one item succeeds, response is 200 OK. If all items\nfail, the endpoint returns a non-200 error.\n\n```http\nPOST /v2alpha1/admin/importedApiKeys:batchCreate\n{\n  \"requests\": [\n    {\"raw_key\": \"sk_live_abc\", \"name\": \"Stripe key\", \"actor_id\": \"user_1\"},\n    {\"raw_key\": \"ghp_xyz\", \"name\": \"GitHub PAT\", \"actor_id\": \"user_2\"}\n  ]\n}\n```",
        "operationId": "adminBatchCreateImportedApiKeys",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/BatchCreateImportedApiKeysRequest"
              }
            }
          },
          "description": "BatchCreateImportedApiKeysRequest imports multiple external API keys in one request.\nThe maximum batch size is 1000 keys.",
          "required": true,
          "x-originalParamName": "body"
        },
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/BatchCreateImportedApiKeysResponse"
                }
              }
            },
            "description": "Batch import completed. Check per-item results for individual status."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Batch Import API Keys",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/admin/issuedApiKeys": {
      "get": {
        "description": "Lists issued API keys with optional filtering. Supports cursor-based\npagination and AIP-160 filter expressions. Returns only issued\n(generated) API keys; use ListImportedApiKeys for imported keys.\n\n```http\nGET /v2alpha1/admin/issuedApiKeys?page_size=50\u0026filter=actor_id%3D%22user_123%22\n```",
        "operationId": "adminListIssuedApiKeys",
        "parameters": [
          {
            "description": "Number of items per page (default: 50, max: 1000)",
            "in": "query",
            "name": "page_size",
            "schema": {
              "format": "int32",
              "type": "integer"
            }
          },
          {
            "description": "Cursor token for pagination",
            "in": "query",
            "name": "page_token",
            "schema": {
              "type": "string"
            }
          },
          {
            "description": "filter is an AIP-160 expression. Indexed fields (efficient at any scale):\n  actor_id, status. Other fields are not indexed and may be rejected.\nExamples:\n  actor_id=\"user_123\"\n  status=KEY_STATUS_ACTIVE\n  actor_id=\"user_123\" AND status=KEY_STATUS_ACTIVE",
            "in": "query",
            "name": "filter",
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ListIssuedApiKeysResponse"
                }
              }
            },
            "description": "A successful response."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "List Issued API Keys",
        "tags": [
          "ApiKeys"
        ]
      },
      "post": {
        "description": "Creates a new API key for a given actor. The secret is returned only once\nin the response and cannot be retrieved later. Keys can be scoped with\nspecific permissions and have optional expiration.\n\n```http\nPOST /v2alpha1/admin/issuedApiKeys\n{\n  \"name\": \"production-service\",\n  \"actor_id\": \"user_123\",\n  \"scopes\": [\"read\", \"write\"],\n  \"ttl\": \"8760h\"\n}\n```",
        "operationId": "adminIssueApiKey",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/IssueApiKeyRequest"
              }
            }
          },
          "required": true,
          "x-originalParamName": "body"
        },
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/IssueApiKeyResponse"
                }
              }
            },
            "description": "A successful response."
          },
          "201": {
            "content": {
              "application/json": {
                "schema": {}
              }
            },
            "description": "API key issued successfully."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Issue API Key",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/admin/issuedApiKeys/{issued_api_key.key_id}": {
      "patch": {
        "description": "Updates metadata, scopes, or rate limits of an issued key without rotating\nthe secret. Use RotateIssuedApiKey to change the secret.\n\nFollows AIP-134: the request body is the IssuedApiKey resource itself,\nand the update_mask query parameter names the subset of fields to apply.\nOmitting update_mask is equivalent to a mask of every populated field\nin the body. To clear a field to its zero value, list it explicitly in\nupdate_mask and leave it unset (or empty) in the body.\n\n```http\nPATCH /v2alpha1/admin/issuedApiKeys/01HQZX9VYQKJB8XQZQXQZQXQXQ?update_mask=scopes\n{\n  \"issued_api_key\": {\n    \"key_id\": \"01HQZX9VYQKJB8XQZQXQZQXQXQ\",\n    \"scopes\": [\"read\"]\n  }\n}\n```",
        "operationId": "adminUpdateIssuedApiKey",
        "parameters": [
          {
            "in": "path",
            "name": "issued_api_key.key_id",
            "required": true,
            "schema": {
              "type": "string"
            }
          },
          {
            "description": "The list of fields to update. See AIP-134.",
            "in": "query",
            "name": "update_mask",
            "schema": {
              "type": "string"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "description": "IssuedApiKey represents an API key issued (generated) by Talos.\nRoot keys are opaque v1 format tokens stored in the database.\nDerived tokens (JWT/Macaroon) are created via DeriveToken and are stateless (not stored).",
                "properties": {
                  "actor_id": {
                    "type": "string"
                  },
                  "create_time": {
                    "format": "date-time",
                    "type": "string"
                  },
                  "expire_time": {
                    "format": "date-time",
                    "type": "string"
                  },
                  "ip_restriction": {
                    "$ref": "#/components/schemas/IPRestriction"
                  },
                  "last_used_time": {
                    "format": "date-time",
                    "type": "string"
                  },
                  "metadata": {
                    "description": "metadata is a free-form JSON object for caller-defined attributes\n(e.g., source, environment, tags). Values may be strings, numbers,\nbooleans, arrays, objects, or null. Total serialized size is capped\nat 4KB. AIP-148 metadata field.",
                    "type": "object"
                  },
                  "name": {
                    "type": "string"
                  },
                  "rate_limit_policy": {
                    "$ref": "#/components/schemas/RateLimitPolicy"
                  },
                  "revocation_description": {
                    "description": "revocation_description provides free-form context for a revocation.\nOnly set when revocation_reason is PRIVILEGE_WITHDRAWN.\nJSON API change: field was formerly revocation_reason_text. Field number 13\nis unchanged so the change is wire-compatible for binary proto encoding.",
                    "type": "string"
                  },
                  "revocation_reason": {
                    "$ref": "#/components/schemas/RevocationReason"
                  },
                  "scopes": {
                    "items": {
                      "type": "string"
                    },
                    "type": "array"
                  },
                  "status": {
                    "$ref": "#/components/schemas/KeyStatus"
                  },
                  "update_time": {
                    "format": "date-time",
                    "type": "string"
                  },
                  "visibility": {
                    "$ref": "#/components/schemas/KeyVisibility"
                  }
                },
                "type": "object"
              }
            }
          },
          "required": true,
          "x-originalParamName": "issued_api_key"
        },
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/IssuedApiKey"
                }
              }
            },
            "description": "A successful response."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Update Issued API Key",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/admin/issuedApiKeys/{key_id}": {
      "get": {
        "description": "Retrieves details about a specific issued API key including its status,\nscopes, expiration, and usage statistics. The secret is never returned.\n\n```http\nGET /v2alpha1/admin/issuedApiKeys/01HQZX9VYQKJB8XQZQXQZQXQXQ\n```",
        "operationId": "adminGetIssuedApiKey",
        "parameters": [
          {
            "in": "path",
            "name": "key_id",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/IssuedApiKey"
                }
              }
            },
            "description": "A successful response."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Get Issued API Key",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/admin/issuedApiKeys/{key_id}:revoke": {
      "post": {
        "description": "Immediately revokes an issued API key. Once revoked, the key can no longer\nbe used for authentication. This operation is irreversible. Revoked keys\nare retained for audit purposes.\n\n```http\nPOST /v2alpha1/admin/issuedApiKeys/01HQZX9VYQKJB8XQZQXQZQXQXQ:revoke\n{\n  \"reason\": \"REVOCATION_REASON_KEY_COMPROMISE\"\n}\n```",
        "operationId": "adminRevokeIssuedApiKey",
        "parameters": [
          {
            "description": "UUID of the issued key (REQUIRED)",
            "in": "path",
            "name": "key_id",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/AdminRevokeIssuedApiKeyBody"
              }
            }
          },
          "required": true,
          "x-originalParamName": "body"
        },
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "type": "object"
                }
              }
            },
            "description": "A successful response."
          },
          "204": {
            "description": "API key revoked successfully."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Revoke Issued API Key",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/admin/issuedApiKeys/{key_id}:rotate": {
      "post": {
        "description": "Generates a new secret for an issued API key. Creates a new API key with a\nnew key_id and secret, and immediately revokes the old key. This is the\nrecommended way to update scopes, metadata, or rotate credentials.\n\nFor zero-downtime rotation, use this workflow instead:\n  1. IssueApiKey with new credentials\n  2. Deploy new secret to all services\n  3. Verify new secret works everywhere\n  4. AdminRevokeIssuedApiKey to remove the old key\n\n```http\nPOST /v2alpha1/admin/issuedApiKeys/01HQZX9VYQKJB8XQZQXQZQXQXQ:rotate\n{\n  \"scopes\": [\"read\"]\n}\n```",
        "operationId": "adminRotateIssuedApiKey",
        "parameters": [
          {
            "description": "key_id is the ID of the existing API key to rotate",
            "in": "path",
            "name": "key_id",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/AdminRotateIssuedApiKeyBody"
              }
            }
          },
          "required": true,
          "x-originalParamName": "body"
        },
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/RotateIssuedApiKeyResponse"
                }
              }
            },
            "description": "A successful response."
          },
          "201": {
            "content": {
              "application/json": {
                "schema": {}
              }
            },
            "description": "API key rotated successfully. New key issued, old key revoked."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Rotate Issued API Key",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/apiKeys:selfRevoke": {
      "post": {
        "description": "Proof-of-possession variant of revocation. The `Self*` prefix on the\nrequest/response messages disambiguates from the admin variants\n(`AdminRevokeIssuedApiKey` / `AdminRevokeImportedApiKey`).\n\nAllows an API key holder to revoke their own key. The caller must provide\nthe full API key secret as proof of possession. Supports issued API keys\nand imported keys. JWT and macaroon tokens cannot be self-revoked (they\nare stateless).\n\nThe PRIVILEGE_WITHDRAWN reason is not allowed for self-revocation\n(admin-only).\n\n```http\nPOST /v2alpha1/apiKeys:selfRevoke\n{\n  \"credential\": \"sk_live_abc123...\",\n  \"reason\": \"REVOCATION_REASON_KEY_COMPROMISE\"\n}\n```",
        "operationId": "revokeApiKey",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/SelfRevokeApiKeyRequest"
              }
            }
          },
          "description": "SelfRevokeApiKeyRequest allows an API key holder to revoke their own key\nby providing the full key secret as proof of possession.",
          "required": true,
          "x-originalParamName": "body"
        },
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/SelfRevokeApiKeyResponse"
                }
              }
            },
            "description": "A successful response."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Revoke API Key (self-service)",
        "tags": [
          "ApiKeys"
        ]
      }
    },
    "/v2alpha1/derivedKeys/jwks.json": {
      "get": {
        "description": "Returns the JSON Web Key Set for token verification. Provides the public\nkeys needed to verify JWT tokens issued by this service. Keys are loaded\nfrom configuration (file://, https://, or base64:// URIs). Follows the\nJWKS standard (RFC 7517).\n\n```http\nGET /v2alpha1/derivedKeys/jwks.json\n```",
        "operationId": "getJwks",
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/GetJWKSResponse"
                }
              }
            },
            "description": "A successful response."
          },
          "default": {
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Status"
                }
              }
            },
            "description": "An unexpected error response."
          }
        },
        "summary": "Get JWKS",
        "tags": [
          "ApiKeys"
        ]
      }
    }
  },
  "tags": [
    {
      "description": "Administrative operations for managing API keys. Deploy behind authentication and authorization. Supports issued keys (generated by Talos), imported keys (from external systems), and key verification.",
      "name": "ApiKeys"
    }
  ]
}



================================================
FILE: deployments/docker/compose.yaml
================================================
version: '3.8'

services:
  # PostgreSQL database
  postgres:
    image: postgres:16-alpine
    container_name: ory-talos-postgres
    environment:
      POSTGRES_USER: talos
      POSTGRES_PASSWORD: talos123
      POSTGRES_DB: talos
      POSTGRES_HOST_AUTH_METHOD: md5
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U talos"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - ory-talos-network

  # Redis cache
  redis:
    image: redis:7-alpine
    container_name: ory-talos-redis
    command: redis-server --appendonly yes --requirepass redis123
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - ory-talos-network

  # Jaeger for tracing (development)
  jaeger:
    image: jaegertracing/all-in-one:latest
    container_name: ory-talos-jaeger
    environment:
      COLLECTOR_OTLP_ENABLED: "true"
    ports:
      - "6831:6831/udp"   # Thrift Compact
      - "6832:6832/udp"   # Thrift Binary
      - "5778:5778"       # Config HTTP
      - "16686:16686"     # UI
      - "4317:4317"       # OTLP gRPC
      - "4318:4318"       # OTLP HTTP
      - "14250:14250"     # Model Proto
      - "14268:14268"     # Thrift HTTP
      - "14269:14269"     # Admin HTTP
      - "9411:9411"       # Zipkin
    networks:
      - ory-talos-network

  # Prometheus for metrics
  prometheus:
    image: prom/prometheus:latest
    container_name: ory-talos-prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/usr/share/prometheus/console_libraries'
      - '--web.console.templates=/usr/share/prometheus/consoles'
    ports:
      - "9092:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    networks:
      - ory-talos-network

  # Grafana for dashboards
  grafana:
    image: grafana/grafana:latest
    container_name: ory-talos-grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_USERS_ALLOW_SIGN_UP=false
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/dashboards:/etc/grafana/provisioning/dashboards:ro
      - ./grafana/datasources:/etc/grafana/provisioning/datasources:ro
    depends_on:
      - prometheus
    networks:
      - ory-talos-network

  # Ory Talos (uncomment to run with docker-compose)
  # talos:
  #   build:
  #     context: ../..
  #     dockerfile: talos/talos/.docker/Dockerfile-local-build
  #   container_name: ory-talos-server
  #   environment:
  #     DB_DSN: "postgres://talos:talos123@postgres:5432/talos?sslmode=disable"
  #     REDIS_ADDR: "redis:6379"
  #     REDIS_PASSWORD: "redis123"
  #     OTEL_EXPORTER_OTLP_ENDPOINT: "jaeger:4317"
  #     TLS_ENABLED: "false"
  #   ports:
  #     - "4420:4420"  # HTTP API
  #     - "4422:4422"  # Metrics
  #   depends_on:
  #     postgres:
  #       condition: service_healthy
  #     redis:
  #       condition: service_healthy
  #   networks:
  #     - ory-talos-network
  #   restart: unless-stopped

networks:
  ory-talos-network:
    driver: bridge

volumes:
  postgres_data:
  redis_data:
  prometheus_data:
  grafana_data:


================================================
FILE: deployments/docker/Dockerfile.init
================================================
# Database Initialization Dockerfile
# Builds Ory Talos binary and runs migrations + tenant seeding
#
# This is a specialized container that:
# 1. Builds the commercial binary
# 2. Runs database migrations
# 3. Seeds tenant data
# 4. Exits (one-shot container)

# =============================================================================
# Build stage
# =============================================================================
FROM golang:1.26-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git make ca-certificates

WORKDIR /build

# Copy the replaced sibling modules referenced by talos/talos/go.mod.
COPY cloudlib ./cloudlib
COPY x ./x

# Copy talos sources (context is the repository root).
COPY talos/talos ./talos/talos

WORKDIR /build/talos/talos

RUN go mod download

# Build the commercial binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -tags commercial \
    -ldflags="-w -s" \
    -o talos .

# =============================================================================
# Init stage
# =============================================================================
FROM alpine:3.19

# Install runtime dependencies
RUN apk add --no-cache \
    ca-certificates \
    postgresql-client

# Copy the binary
COPY --from=builder /build/talos/talos/talos /talos

# Copy migrations
COPY --from=builder /build/talos/talos/internal/persistence/migrations /migrations
COPY --from=builder /build/talos/talos/commercial/persistence/migrations /migrations-commercial

# Copy init script
COPY talos/talos/deployments/docker/scripts/init-db.sh /init-db.sh
RUN chmod +x /init-db.sh

# Run init script
ENTRYPOINT ["/init-db.sh"]



================================================
FILE: deployments/docker/Dockerfile.oss.init
================================================
# Database Initialization Dockerfile for Ory Talos OSS Edition
# Builds Ory Talos OSS binary and runs migrations on SQLite
#
# This is a specialized container that:
# 1. Builds the OSS binary
# 2. Runs database migrations
# 3. Exits (one-shot container)

# =============================================================================
# Build stage
# =============================================================================
FROM golang:1.26-alpine AS builder

# Install build dependencies. Talos uses the pure-Go modernc.org/sqlite driver,
# so CGO (and gcc/musl-dev) are not required.
RUN apk add --no-cache git ca-certificates

WORKDIR /build

# Build context is the talos repository. ory/x is supplied as the "oryx" build
# context (monorepo: ../../x). Build against the cloudlib-free OSS module manifest in
# .oss/. The OSS sync collapses these four COPY lines to a single `COPY . ./`: there
# oryx/ is a real subdirectory and go.mod/go.sum are already the cloudlib-free ones.
COPY . .

RUN go mod download

# Build the OSS binary (no commercial tag, pure-Go SQLite so CGO is disabled).
RUN CGO_ENABLED=0 go build \
    -ldflags="-w -s" \
    -o talos .

# =============================================================================
# Init stage
# =============================================================================
FROM alpine:3.19

# Install runtime dependencies
RUN apk add --no-cache ca-certificates

# Copy the binary
COPY --from=builder /build/talos /talos

# Copy migrations (OSS only)
COPY --from=builder /build/internal/persistence/migrations /migrations

# Copy init script
COPY deployments/docker/scripts/init-db-oss.sh /init-db.sh
RUN chmod +x /init-db.sh

# Run init script. This one-shot container runs as root so it can create and
# chown the SQLite data directory to the nonroot runtime user (UID 65532) used
# by the server images.
ENTRYPOINT ["/init-db.sh"]



================================================
FILE: deployments/docker/prometheus.yml
================================================
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'ory-talos'
    static_configs:
      - targets: ['host.docker.internal:4422']
        labels:
          service: 'ory-talos'
          environment: 'development'

  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'redis'
    static_configs:
      - targets: ['redis:6379']

  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres:5432']


================================================
FILE: deployments/docker/config/config.oss.yaml
================================================
# Ory Talos OSS Edition Configuration
# Used by docker-compose.oss.yaml for local development/testing

# Server configuration
serve:
  http:
    host: "0.0.0.0"
    port: 4420
    request_log:
      exclude_health_endpoints: true
    cors:
      enabled: true
      allowed_origins:
        - "http://localhost:3001"

      allowed_methods:
        - "GET"
        - "POST"
        - "PUT"
        - "DELETE"
        - "PATCH"
      allowed_headers:
        - "Content-Type"
        - "Authorization"
      exposed_headers:
        - "Content-Type"
      allow_credentials: true
      max_age: 86400
      debug: false

  metrics:
    host: "0.0.0.0"
    port: 4422

# Credential configuration
credentials:
  issuer: "https://api.talos.local"
  api_keys:
    default_ttl: "720h"  # 30 days
    max_ttl: "8760h"  # 365 days
    prefix:
      current: "talos"
      retired: []

  derived_tokens:
    default_ttl: "1h"
    jwt:
      signing_keys:
        urls:
          - "base64://eyAgImtleXMiOiBbICAgIHsgICAgICAiYWxnIjogIkVkRFNBIiwgICAgICAiY3J2IjogIkVkMjU1MTkiLCAgICAgICJkIjogIjl3VTNfV3p0dmx3TXg0SGlfN2dsSVduY09XNlVIR2I5amxDdDZEZkVGa2MiLCAgICAgICJraWQiOiAiZG9ja2VyLWRldi0wMDEiLCAgICAgICJrdHkiOiAiT0tQIiwgICAgICAidXNlIjogInNpZyIsICAgICAgIngiOiAiNGtTQTdtNU5jYnFDUC1mZk9fNGhQM2tsNHB0NGctLTNRQ21zQmwzb05lVSIgICAgfSAgXX0="

    macaroon:
      prefix:
        current: "mc"
        retired: []

# Token issuer (required)
# Database configuration
db:
  dsn: "sqlite3:///var/lib/talos/talos.db?_journal_mode=WAL"

# Logging
log:
  level: "info"
  format: "json"

# Secrets (CHANGE THESE IN PRODUCTION!)
secrets:
  hmac:
    current: "docker-compose-hmac-secret-minimum-32-chars-long"
    retired: []

# Tracing - exports spans to local Jaeger from docker-compose.oss.yaml
tracing:
  enabled: true
  service_name: "ory-talos-oss"
  service_version: "dev"
  environment: "development"
  exporter: "otlp"
  endpoint: "jaeger:4317"
  sample_rate: 1.0

# Cache configuration
cache:
  type: "noop"
  ttl: "5m"

# Multi-tenancy disabled for OSS
multitenancy:
  enabled: false



================================================
FILE: deployments/docker/config/config.yaml
================================================
# Ory Talos Commercial Edition Configuration
# Used by docker-compose for local development/testing

# Server configuration
serve:
  http:
    host: "0.0.0.0"
    port: 4420
    request_log:
      exclude_health_endpoints: true
    cors:
      enabled: true
      allowed_origins:
        - "http://localhost:3001"

        - "http://default.talos.local:3001"
        - "http://tenant1.talos.local:3001"
        - "http://tenant2.talos.local:3001"
      allowed_methods:
        - "GET"
        - "POST"
        - "PUT"
        - "DELETE"
        - "PATCH"
      allowed_headers:
        - "Content-Type"
        - "Authorization"
        - "X-Forwarded-Host"
      exposed_headers:
        - "Content-Type"
      allow_credentials: true
      max_age: 86400
      debug: false

  metrics:
    host: "0.0.0.0"
    port: 4422

# Credential configuration
credentials:
  issuer: "https://api.talos.local"
  api_keys:
    default_ttl: "720h"  # 30 days
    max_ttl: "8760h"  # 365 days
    prefix:
      current: "talos"
      retired: []

  derived_tokens:
    default_ttl: "1h"
    jwt:
      signing_keys:
        urls:
          - "base64://eyAgImtleXMiOiBbICAgIHsgICAgICAiYWxnIjogIkVkRFNBIiwgICAgICAiY3J2IjogIkVkMjU1MTkiLCAgICAgICJkIjogIjl3VTNfV3p0dmx3TXg0SGlfN2dsSVduY09XNlVIR2I5amxDdDZEZkVGa2MiLCAgICAgICJraWQiOiAiZG9ja2VyLWRldi0wMDEiLCAgICAgICJrdHkiOiAiT0tQIiwgICAgICAidXNlIjogInNpZyIsICAgICAgIngiOiAiNGtTQTdtNU5jYnFDUC1mZk9fNGhQM2tsNHB0NGctLTNRQ21zQmwzb05lVSIgICAgfSAgXX0="

    macaroon:
      prefix:
        current: "mc"
        retired: []

# Token issuer (required)
# Database configuration
db:
  dsn: "postgres://talos:talos@postgres:5432/talos?sslmode=disable"

# Logging
log:
  level: "info"
  format: "json"

# Secrets (CHANGE THESE IN PRODUCTION!)
secrets:
  hmac:
    current: "docker-compose-hmac-secret-minimum-32-chars-long"
    retired: []

# Tracing - exports spans to local Tempo instance from docker-compose.commercial.yaml
tracing:
  enabled: true
  service_name: "ory-talos-commercial"
  service_version: "dev"
  environment: "development"
  exporter: "otlp"
  endpoint: "tempo:4317"
  sample_rate: 1.0

# Cache - distributed Redis cache for API key verification (Commercial)
cache:
  type: "redis"
  ttl: "5m"
  redis:
    addrs:
      - "redis:6379"
    password: ""
    db: 0
    pool_size: 100
    timeout: "3s"

# Rate limit enforcement (Commercial)
# Uses Redis backend for distributed counting across pods
rate_limit:
  enabled: true
  backend: redis

# Multi-tenancy configuration (Commercial)
# Each network requires config_path pointing to its tenant-specific config
multitenancy:
  enabled: true
  networks:
    # Default tenant (localhost access)
    - hostname: "localhost"
      id: "00000000-0000-0000-0000-000000000000"
      config_path: "/etc/talos/tenants/default.yaml"
    # Default tenant (internal docker-compose service name)
    - hostname: "backend"
      id: "00000000-0000-0000-0000-000000000000"
      config_path: "/etc/talos/tenants/default.yaml"
    # Default tenant (multi-tenant hostname)
    - hostname: "default.talos.local"
      id: "00000000-0000-0000-0000-000000000000"
      config_path: "/etc/talos/tenants/default.yaml"
    # Tenant 1
    - hostname: "tenant1.talos.local"
      id: "00000000-0000-0000-0000-000000000001"
      config_path: "/etc/talos/tenants/tenant1.yaml"
    # Tenant 2
    - hostname: "tenant2.talos.local"
      id: "00000000-0000-0000-0000-000000000002"
      config_path: "/etc/talos/tenants/tenant2.yaml"



================================================
FILE: deployments/docker/config/jwks.json
================================================
{
  "keys": [
    {
      "alg": "EdDSA",
      "crv": "Ed25519",
      "d": "9wU3_WztvlwMx4Hi_7glIWncOW6UHGb9jlCt6DfEFkc",
      "kid": "docker-dev-001",
      "kty": "OKP",
      "use": "sig",
      "x": "4kSA7m5NcbqCP-ffO_4hP3kl4pt4g--3QCmsBl3oNeU"
    }
  ]
}


================================================
FILE: deployments/docker/config/tenants/default.yaml
================================================
# Default tenant configuration
secrets:
  hmac:
    current: "docker-compose-default-tenant-hmac-secret-32"
    retired: []

# Signing keys for token derivation (JWT and macaroon)
credentials:
  derived_tokens:
    jwt:
      signing_keys:
        urls:
          - "file:///etc/talos/jwks.json"



================================================
FILE: deployments/docker/config/tenants/tenant1.yaml
================================================
# Tenant 1 configuration
secrets:
  hmac:
    current: "docker-compose-tenant1-hmac-secret-32-chars"
    retired: []

# Signing keys for token derivation (JWT and macaroon)
credentials:
  derived_tokens:
    jwt:
      signing_keys:
        urls:
          - "file:///etc/talos/jwks.json"



================================================
FILE: deployments/docker/config/tenants/tenant2.yaml
================================================
# Tenant 2 configuration
secrets:
  hmac:
    current: "docker-compose-tenant2-hmac-secret-32-chars"
    retired: []

# Signing keys for token derivation (JWT and macaroon)
credentials:
  derived_tokens:
    jwt:
      signing_keys:
        urls:
          - "file:///etc/talos/jwks.json"



================================================
FILE: deployments/docker/scripts/init-db-oss.sh
================================================
#!/bin/sh
# Database initialization script for Ory Talos OSS Edition
# Runs migrations on SQLite database

set -e

echo "[init] Starting OSS database initialization..."

# Ensure data directory exists with correct ownership.
# The backend container runs as the nonroot user (UID 65532) used by the Ory
# runtime images, so files must be writable by that user.
mkdir -p /var/lib/talos
chown -R 65532:65532 /var/lib/talos

# Run migrations
echo "[init] Running migrations..."
/talos migrate up --database "$DB_DSN"

# Fix ownership after migration (migration runs as root and creates DB files)
chown -R 65532:65532 /var/lib/talos

echo "[init] OSS database initialization complete!"




================================================
FILE: deployments/docker/scripts/init-db.sh
================================================
#!/bin/sh
# Database initialization script for Ory Talos
# Runs migrations and seeds tenant data

set -e

echo "[init] Starting database initialization..."

# Run migrations
echo "[init] Running migrations..."
/talos migrate up --database "$DB_DSN"

echo "[init] Seeding tenant networks..."

# Seed networks (tenants)
# Note: Hostname-to-network mapping is done via config file (multitenancy.networks)
# The networks table just stores network IDs and metadata
psql -c "
INSERT INTO networks (id, created_at, updated_at)
VALUES
  ('00000000-0000-0000-0000-000000000000', NOW(), NOW()),
  ('00000000-0000-0000-0000-000000000001', NOW(), NOW()),
  ('00000000-0000-0000-0000-000000000002', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;
"

echo "[init] Database initialization complete!"
echo "[init] Configured networks (tenants):"
echo "[init]   - Default: 00000000-0000-0000-0000-000000000000"
echo "[init]   - Tenant1: 00000000-0000-0000-0000-000000000001"
echo "[init]   - Tenant2: 00000000-0000-0000-0000-000000000002"
echo "[init]"
echo "[init] Hostname-to-network mapping is configured in /etc/talos/config.yaml"



================================================
FILE: .docker/Dockerfile-alpine
================================================
FROM alpine:3.21

RUN <<HEREDOC
    apk add --no-cache --upgrade ca-certificates

    # Add a user/group for nonroot with a stable UID + GID. Values are from nonroot from distroless
    # for interoperability with other containers.
    addgroup --system --gid 65532 nonroot
    adduser --system --uid 65532 \
      --gecos "nonroot User" \
      --home /home/nonroot \
      --ingroup nonroot \
      --shell /sbin/nologin \
      nonroot

    # Talos supports SQLite. Create the data directory owned by the nonroot user so a
    # mounted volume inherits the correct ownership and is writable without running as root.
    mkdir -p /var/lib/talos
    chown nonroot:nonroot /var/lib/talos
HEREDOC

COPY talos /usr/bin/talos

VOLUME /var/lib/talos

USER nonroot

EXPOSE 4420 4422

ENTRYPOINT ["talos"]
CMD ["serve"]



================================================
FILE: .docker/Dockerfile-distroless-static
================================================
FROM gcr.io/distroless/static-debian12:nonroot

COPY talos /usr/bin/talos

EXPOSE 4420 4422

ENTRYPOINT ["talos"]
CMD ["serve"]



================================================
FILE: .docker/Dockerfile-local-build
================================================
FROM golang:1.26 AS builder

WORKDIR /build

# Build context is the talos repository. ory/x is supplied as the "oryx" build
# context (monorepo: ../../x). Build against the cloudlib-free OSS module manifest in
# .oss/. The OSS sync collapses these four COPY lines to a single `COPY . ./`: there
# oryx/ is a real subdirectory and go.mod/go.sum are already the cloudlib-free ones.
COPY . .

RUN go mod download

# Talos uses the pure-Go modernc.org/sqlite driver, so CGO is not required.
RUN CGO_ENABLED=0 go build -ldflags="-w -s" -o /usr/bin/talos .

#########################

FROM gcr.io/distroless/static-debian12:debug-nonroot AS runner

COPY --from=builder /usr/bin/talos /usr/bin/talos

EXPOSE 4420 4422

ENTRYPOINT ["talos"]
CMD ["serve"]


