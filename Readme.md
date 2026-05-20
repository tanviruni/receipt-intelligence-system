# Receipt Intelligence System (RIS)

Upload a receipt image → OCR extracts the text → parser pulls out vendor, date, total, and line items → everything is stored and browsable via a Flutter web UI.

Built as a technical exercise for Remonon.

---

## Stack

| Layer      | Technology                                 |
| ---------- | ------------------------------------------ |
| Backend    | Node.js, TypeScript, Express               |
| ORM / DB   | Prisma, SQLite                             |
| OCR        | Tesseract.js + sharp (image preprocessing) |
| Validation | Zod                                        |
| Frontend   | Flutter Web, flutter_bloc, go_router, Dio  |

---

## Setup

```bash
git clone https://github.com/tanviruni/receipt-intelligence-system.git
cd receipt-intelligence-system/backend && npm install && cp .env.example .env
npx prisma migrate dev --name init
npm run dev
```

Open a second terminal:

```bash
cd receipt-intelligence-system/frontend && flutter pub get
flutter run -d chrome
```

Backend runs at `http://localhost:3000`. Flutter opens its own dev port automatically.

---

## Project structure

```
receipt-intelligence-system/
  backend/
    src/
      config/           # env, constants
      db/               # Prisma client singleton
      modules/
        receipts/       # controller, service, repository, routes
      services/
        ocr/            # Tesseract.js + sharp preprocessing
        parsing/        # vendor / date / total / line item extraction
        categorisation/ # keyword-based category assignment
      middleware/
        upload.ts       # multer config, file type validation
        error.ts        # global error handler
      app.ts
      server.ts
    prisma/
      schema.prisma
    .env.example
  frontend/
    lib/
      core/
        network/        # Dio client singleton
      features/
        receipts/
          data/         # models, datasource, repository implementation
          domain/       # entities, repository interface
          presentation/ # per-page Bloc + pages + widgets
  backend/samples/      # sample receipt images for testing
```

---

## Architecture & decisions

The backend follows a layered architecture — routes delegate to controllers, controllers call services, services talk to the repository, and the repository owns all database access. This separation means the OCR, parsing, and categorisation logic can be tested independently without a running database. Tesseract.js was chosen because it runs entirely in Node.js with no system dependencies, which keeps the setup to a single `npm install`. SQLite via Prisma keeps the data layer simple — no external database process required to run the project. The Flutter frontend uses clean architecture with Bloc for state management: each page owns its own Bloc with clearly defined events and states, making the data flow explicit and easy to follow.

---

## Tests

```bash
# Backend — 15 unit tests for the parsing service
cd backend && npm test

# Frontend — 7 widget tests for StatusBadge and ReceiptCard
cd frontend && flutter test
```

---

## Sample receipts

Five real German supermarket receipts are included in `backend/samples/` (ALDI, REWE, EDEKA, DM, FreshHarvest). Upload them via the UI to test the full pipeline end to end.

---

## What I would improve with more time

OCR accuracy is the biggest limitation — Tesseract.js struggles with crumpled receipts, unusual fonts, and German umlauts (ü, ä, ö). A server-side service like Google Vision API or AWS Textract would significantly improve extraction quality, especially for vendor name detection. The frontend design is functional but minimal — with more time I would invest in better visual polish and a more refined mobile-responsive layout. Authentication and authorisation are missing — in a production system each user should only see their own receipts, protected behind a JWT-based auth layer. Finally, the polling approach for OCR status (refresh after 5 seconds) is a pragmatic shortcut — a WebSocket connection between backend and frontend would give real-time status updates without the delay or the missed-update risk.
