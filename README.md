# Bodega Esports Platform — Frontend

![Node.js](https://img.shields.io/badge/node-%3E=18.x-green.svg)
![Railway](https://img.shields.io/badge/-Railway-0B0D0E?style=flat&logo=railway&logoColor=white)
![CI](https://github.com/wersplat/bodega-esports-platform/actions/workflows/ci.yml/badge.svg)
![License: GPLv3](https://img.shields.io/badge/license-GPLv3-blue)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)

## Overview

A React/Next.js dashboard for Bodega Esports Platform. View teams, players, matches, standings, leaderboards, and review OCR errors. Prioritizes function and data clarity for admins and users.

## Tech Stack

- [Next.js](https://nextjs.org/) & [React](https://react.dev/)
- [Tailwind CSS](https://tailwindcss.com/) for styling
- [Recharts](https://recharts.org/) for charts
- Fetch-based API integration (FastAPI backend)

## Features

- Core pages: Dashboard (`/`), Leaderboard, Standings, Player Profile, Admin Review, OCR Error Review
- Export data to CSV/Google Sheets
- Filters: season, team, division, stat
- Charts for stats over time (Recharts)
- Pagination, interactive embeds

## Folder Structure

```
/app/             # App router (Next.js 13+)
/components/      # Reusable UI components
/hooks/           # Custom React hooks
/layout/          # Layout components
/lib/             # API clients, utilities
/pages/           # Route pages (legacy, some may redirect)
/public/          # Static assets
/scripts/         # Utility scripts
/styles/          # Tailwind/global styles
/theme/           # Theme config and styles
/types/           # TypeScript types
/utils/           # Utility functions
```

## Quick Start

```bash
git clone https://github.com/wersplat/bodega-esports-platform.git
cd bodega-esports-platform/frontend
npm install
cp .env.local.example .env.local
npm run dev
```

## Configuration

Set these in `.env.local`:

```env
NEXT_PUBLIC_API_URL=https://your-api-url
# Add other required variables as needed
```

## Scripts

- `npm run dev` — Start development server
- `npm run build` — Build for production
- `npm run start` — Start production server
- `npm run lint` — Lint codebase (no warnings allowed)
- `npm run lint:fix` — Auto-fix lint issues
- `npm run type-check` — TypeScript type check
- `npm run format` — Format codebase with Prettier

## Deployment

### Railway, Docker, or Render

- Root path: `/frontend`
- Build command: `npm run build`
- Start command: `npm run start`
- Health check: `/` (or `/api/health` if available)
- Set environment variables in your deployment dashboard

### Docker

A `Dockerfile` is provided for containerized builds and Sentry source map upload:

```sh
docker build -t bodega-frontend .
docker run -p 3000:3000 --env-file .env.local bodega-frontend
```

- Uses multi-stage build for production
- Sentry sourcemaps are uploaded in production builds if SENTRY_DSN is set
- Healthcheck is set up for `/` on port 3000

### Sentry

- Sentry is integrated for error monitoring. Configure `SENTRY_DSN` in `.env.local` and/or your deployment environment.

## Testing & Linting

- Run tests: `npm test` (if available)
- Lint: `npm run lint`
- Format: `npm run format` (Prettier)

## Usage

- Login via Discord OAuth
- Navigate pages from sidebar/menu
- Use filters to refine data
- Export tables to CSV/Sheets via export button

## Contributing

- Open issues/PRs on [GitHub](https://github.com/wersplat/bodega-esports-platform)
- Follow coding conventions (Prettier, ESLint)
- Branches: `master` = production, `react` = frontend work

## License & Acknowledgments

- [GPLv3](./LICENSE)
- By [Bodega Cats Gaming Club](https://bodegacats.gg)
- UI libraries: [shadcn/ui](https://ui.shadcn.com/), [lucide-react](https://lucide.dev/)
- Sentry for error monitoring
