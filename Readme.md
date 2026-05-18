# Receipt Intelligence System (RIS)

Upload a receipt image → OCR extracts the text → parser pulls out vendor,
date, total, and line items → everything is stored and browsable via a
Flutter web UI.

Built as a technical exercise for Remonon.

---

## Stack

| Layer      | Technology                                      |
|------------|-------------------------------------------------|
| Backend    | Node.js, TypeScript, Express                    |
| ORM / DB   | Prisma, SQLite                                  |
| OCR        | Tesseract.js + sharp (preprocessing)            |
| Validation | Zod                                             |
| Frontend   | Flutter Web, Riverpod, go_router, Dio           |

---

## Setup

```bash
git clone https://github.com/<your-handle>/ris.git && cd ris
cd backend && cp .env.example .env
npm install && npx prisma migrate dev --name init
npm run dev
# open a second terminal from the repo root
cd frontend && flutter run -d chrome
```

The app will be at `http://localhost:3000` (API) and Flutter opens its own
dev port automatically.

---

## Project structure

```
ris/
  backend/
    src/
      config/           # env, constants
      db/               # Prisma client singleton
      modules/
        receipts/       # controller, service, repository, routes, schema
      services/
        ocr/            # Tesseract.js + sharp wrapper
        parsing/        # vendor / date / total / line item extraction
        categorisation/ # keyword-based category assignment
      middleware/
        upload.ts       # multer config
        error.ts        # global error handler
      app.ts
      server.ts
    prisma/
      schema.prisma
    .env.example
  frontend/
    lib/
      core/
        network/        # Dio client
        errors/         # failure types
      features/
        receipts/
          data/         # models, API repository implementation
          domain/       # entities, repository interface
          presentation/ # screens, widgets, Riverpod providers
      main.dart
      router.dart
  samples/              # two example receipt images for testing
```

---

## Architecture & decisions

<!-- TODO: fill in at Step 14 — 3-5 sentences on why each major tool was chosen -->

---

## What I would improve with more time

<!-- TODO: fill in at Step 14 — 3-5 sentences, honest and specific -->

---

## Sample receipts

Two German supermarket receipts are included in `samples/` for testing.
Use them to verify the full pipeline end to end.
