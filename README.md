# jiko-charts

Helm charts for the Ory stack.

| Chart        | Type        | Description                                                                                          |
| ------------ | ----------- | ---------------------------------------------------------------------------------------------------- |
| `common`     | library     | Generic helpers (name, labels, probes) and NOTES                                                     |
| `nextjs`     | library     | Reusable templates for Next.js apps (deployment, service, HPA, probes, security)                     |
| `nextjs-app` | application | Universal chart for any Next.js app                                                                  |
| `ory-admin`  | application | Admin panel for Ory (Kratos, Hydra, Keto)                                                            |
| `ory-auth`   | application | Authentication forms for Ory (login, registration, recovery, verification, settings, OAuth2 consent) |
| `ory-talos`  | application | Ory Talos API key management service                                                                 |
