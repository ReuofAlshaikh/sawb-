# صَوْب Sawb — Smart Metro App (interactive demo)

Sawb plans the "last mile" of a Riyadh Metro trip. A rider picks a destination near a station, Sawb shows the best exit and the walking distance, and the rider can book a short ride from the station pickup point. Drivers are assigned to stations and accept or reject requests within 15 seconds. Operators run everything from a web dashboard.

This repository is a **working prototype for an evaluation committee**. Every screen and flow from the Figma file works end to end. External services (SMS, push, payments, live vehicle location) are **simulated** and are labelled as simulated inside the app. See [docs/SIMULATED_SERVICES.md](docs/SIMULATED_SERVICES.md).

> **No real money is ever charged.** There is no payment gateway in this code. Every payment is a demo transaction, stored with `simulated: true` and shown with a "محاكاة / Simulated" badge.

## What's inside

| Path | What it is |
|---|---|
| `apps/mobile` | Rider and driver app. Expo SDK 58, React Native 0.88, TypeScript, expo-router. Android, iOS and web. |
| `apps/admin` | Admin dashboard (web). Vite + React, RTL Arabic. |
| `apps/server` | Demo server. Express + Socket.IO with a JSON file store. Serves the API, real-time events and the built admin dashboard at `/admin`. |
| `packages/shared` | Shared domain engine: auth, rides, matching, payments, permissions, journey planner, metro and places data, seed data. The server runs it, and the phone can also run it on its own. |
| `docs/` | Build, simulation, production and screen-coverage documentation. |

## Quick start

Requires Node 22+.

```bash
npm install
npm test            # 23 engine and API tests
npm run demo        # builds the admin dashboard, then starts the server on :4000
```

- **Admin dashboard:** http://localhost:4000/admin/
- **Mobile app on a phone:** `npm run mobile`, then scan the QR code with Expo Go. Or install the APK (see below).
- **Mobile app in a browser:** `cd apps/mobile && npx expo start --web`

## Two ways to run the app

1. **Standalone (default).** The engine and its data run on the phone, so it works offline (map tiles still need internet). Data persists on the device. Simulated drivers accept your ride requests automatically. This is the simplest setup for a committee member with only the APK.
2. **Demo server.** Run `npm run demo` on a laptop. On each phone, open **حسابي → وضع العرض والخادم** and enter the address the server prints, e.g. `http://192.168.1.20:4000`. All phones and the admin dashboard then share one database in real time. For example, a rider phone requests a ride, a driver phone receives it with the 15-second countdown, and the dashboard shows the trip live.

## Demo accounts

| Role | Sign in with | Notes |
|---|---|---|
| Rider | `0551234567` + password `Sawb@1234` | You can also sign in by OTP, create a new account, or browse as a guest. |
| Driver (approved) | `0501234567` | Phone + OTP. The demo code appears in an on-screen "SMS" banner with a **استخدام الرمز** button. |
| Driver (under review) | `0501112233` | Shows the "Under review" state and cannot receive requests. |
| Driver (rejected) | `0502223344` | Shows the rejection reason and can re-upload documents and resubmit. |
| Driver (suspended) | `0503334455` | Shows the suspended state. |
| New driver | any other `05xxxxxxxx` | Goes through registration: ID, licence, vehicle, documents (sample files allowed). |
| Admin (super admin) | `admin@sawb.demo` / `Admin@1234` | Full access. |
| Admin (support agent) | `support@sawb.demo` / `Support@1234` | Limited permissions. Server-side RBAC rejects other actions. |
| Admin invite | `ops@sawb.demo` + code `SAWB-2026` | Use **عندي دعوة لتفعيل حساب** on the admin login page (no public admin sign-up). |

Demo payment cards: any number ending in `0002` is **declined** (simulated failure). Every other test card succeeds.

The full committee walkthrough is in [docs/TESTING.md](docs/TESTING.md).

## Installing on phones

- **Android APK:** see [docs/BUILD.md](docs/BUILD.md). There are two free routes: the GitHub Actions workflow (`.github/workflows/android-apk.yml`, no Expo account needed) or `eas build -p android --profile preview`.
- **iOS / TestFlight:** `eas build -p ios --profile production`, then `eas submit -p ios`. This needs an Apple Developer account. Steps are in [docs/BUILD.md](docs/BUILD.md).

## Documentation

- [docs/TESTING.md](docs/TESTING.md) — demo accounts and step-by-step user journeys for evaluators
- [docs/SIMULATED_SERVICES.md](docs/SIMULATED_SERVICES.md) — what is simulated, what is verified, and what each real integration needs
- [docs/SCREENS.md](docs/SCREENS.md) — each Figma screen and pop-up mapped to its route, plus screens added for PDF requirements
- [docs/BUILD.md](docs/BUILD.md) — Android APK, iOS/TestFlight, hosting the demo server
- [docs/PRODUCTION.md](docs/PRODUCTION.md) — path to production: database schema, security hardening, real providers

## Design fidelity

- **Colors, type scale, spacing and radii** come from the Figma variables (`packages/shared/src/tokens.ts`), with light and dark themes.
- **Fonts:** Noto Sans Arabic for Arabic and Inter for English.
- **Icons:** Lucide, the icon set used in the Figma file.
- **Language and direction:** Arabic (RTL) and English (LTR) switch at runtime with no restart.
- **Place photos and texts** are the Figma samples, labelled "بيانات تجريبية / Sample data" in the app.

## Project rules carried from the brief

- No AI, chatbot or "smart assistant" features.
- Permission checks run on the server/engine for every method, not only in the UI. Rider, driver and admin access levels plus admin RBAC are covered by tests.
- Simulated or approximate data is never shown as verified. Badges in the app distinguish *Verified*, *Approximate*, *Sample* and *Simulated*.
