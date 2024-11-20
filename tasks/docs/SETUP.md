# Setup Instructions

## Prerequisites
- Node.js (Latest LTS)
- Git
- GitHub account
- Vercel account
- Supabase account (or equivalent)

## Initial Setup

1. **Clone Repository**

   git clone [REPOSITORY_URL]
   cd [REPOSITORY_NAME]


2. **Start Assessment**

   chmod +x start-assessment.sh
   ./start-assessment.sh


3. **Create Next.js Project**

   npx create-next-app@latest . --typescript --tailwind --app


4. **Install Dependencies**

   npm install @supabase/supabase-js @supabase/auth-helpers-nextjs @tremor/react


5. **Service Setup**
   - Create Supabase project
   - Configure Vercel project
   - Set up environment variables

## Development
- Run locally: `npm run dev`
- Build: `npm run build`
- Test deployment: `npm run start`

## Environment Variables
Create `.env.local`:
```
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_key
```