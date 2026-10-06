# License System 1.0.0

Secure license administration and device-bound activation API for Cloudflare Workers, D1, and Workers Assets.

[![Deploy to Cloudflare](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/ramtinahmadi1020/license-system)

## Requirements

Node.js 20 or newer and a Cloudflare account.

## First deployment

1. Create a GitHub repository named `license-system` and upload this directory.
2. Open the Deploy to Cloudflare button above and authorize Cloudflare.
3. Create a D1 database named `license-db` in the Cloudflare dashboard, or run:

```sh
npx wrangler d1 create license-db
```

4. Copy the returned database ID into `wrangler.toml` as `database_id`.
5. Set the API signing secret:

```sh
npx wrangler secret put API_HMAC_SECRET
```

Use a random value of at least 32 bytes. The Android client must use the same secret through its protected native configuration.

6. Apply the schema:

```sh
npx wrangler d1 migrations apply license-db --remote
```

7. Generate the administrator PBKDF2 seed without placing the password in source:

```sh
node seed-admin.mjs | npx wrangler d1 execute license-db --remote --command
```

When prompted, enter the administrator password. The generated SQL contains only the derived hash and salt.

8. Deploy:

```sh
npm install
npx wrangler deploy
```

## Local development

```sh
npm install
npx wrangler dev
```

Use a local D1 database and apply the migration before signing in.

## Security model

The Worker uses prepared D1 statements, PBKDF2 password hashing, secure HttpOnly sessions, strict CSP and security headers, IP rate limits, device binding, and HMAC-SHA256 API responses. API responses include `X-Signature` computed over the exact JSON response body.

The administrator account is not created by application code. It is inserted only through the interactive seed command.

## API

`POST /api/v1/activate` and `POST /api/v1/verify` accept JSON with `key` and `device_id`. Every response is JSON and contains an `X-Signature` response header.

## Repository settings

Set the GitHub repository visibility and branch protection according to your release policy. Do not commit `.env` files, Cloudflare credentials, generated secrets, keystores, or administrator passwords.
