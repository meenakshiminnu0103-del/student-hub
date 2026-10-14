# CampusX — Your College Life, Organized

> **All-in-One B.Tech Student Success Platform**  
> Built for the B.Tech First-Year Innovation Hackathon.

CampusX unifies the fragmented tools freshmen juggle daily (study planners, WhatsApp groups, coding portals, Discord servers, and messy syllabus PDFs) into one cohesive, beautifully designed academic productivity dashboard.

---

## 🌟 The Seven Connected Modules

1. **Student Dashboard**
   - Command center showing today's class timetable, pending study tasks, countdown to mid-semester exams, Pomodoro focus shortcuts, top peer study matches, and the daily coding sprint.
   - Live weekly study minutes chart powered by Recharts.
   - Real-time streak counter and XP progression bar.

2. **StudySync — Smart Study Planner**
   - **Smart Task Prioritizer Algorithm:** Calculates urgency scores (0–100) based on approaching deadlines, overdue status, inherent priority, and task duration. Every task displays a transparent algorithmic rationale explaining why it was prioritized.
   - **Integrated Pomodoro Timer:** 25m Focus / 5m Break / 15m Long Break with Web Audio bell synthesis and focus history logs (+25 XP per session).
   - **2-Hour Rescue Plan:** Emergency revision triage dividing available cramming time into High-Yield Core Concepts (45%), Problem Archetypes (40%), Formula Sheet Active Recall, and cognitive reset breaks with realistic academic disclaimers.

3. **SkillSwap Campus — Peer-to-Peer Learning**
   - Complementary matching algorithm pairing students who can teach what another student wants to learn.
   - Working request, scheduling, and completion workflows.
   - Learning credits system: Spend 10 credits to request a session, earn 25 credits + 100 XP upon completion.
   - Built-in privacy protection: no raw emails or phone numbers exposed publicly; peer reporting and blocking controls.

4. **ConceptBridge — Engineering Core Concepts**
   - 12 deeply curated first-year concepts spanning:
     - **Engineering Mathematics:** Eigenvalues & Eigenvectors, Taylor Series, Multivariable Calculus.
     - **Basic Electrical & Electronics (BEEE):** Thévenin's Theorem, Kirchhoff's Laws (KCL/KVL).
     - **Engineering Physics:** Quantum Mechanics (1D Well), Laser Fundamentals & Stimulated Emission.
     - **Engineering Chemistry:** Water Hardness EDTA Titration, Electrochemical Corrosion & Cathodic Protection.
     - **Programming Fundamentals:** C Pointers & Dynamic Memory, Recursion & Call Stack, Big-O Complexity.
     - **Engineering Problem-Solving:** Free Body Diagrams, Buckingham Pi Dimensional Analysis.
   - *"Why Do I Need This?"* button highlighting real-world engineering relevance.
   - Interactive practice quizzes with immediate feedback and step-by-step explanations.

5. **CampusCompass — Campus Navigation & Timetable**
   - Full Monday-to-Saturday interactive timetable with subject color codes, faculty tags, and room numbers.
   - Classroom & Laboratory finder with equipment details, timing, and contact information.
   - Freshman FAQs (75% minimum attendance rule, SGPA calculation, lab record observation verification).
   - College Survival Guide with senior tips for balancing grades, clubs, and hackathons.
   - Campus notice board labeled `[Demo Data]`.

6. **CodeQuest — Gamified Programming Sprints**
   - Beginner C and Python practice tracks.
   - Predict-the-output puzzles, operator precedence challenges, pointer arithmetic, struct memory alignment, Python mutable default argument traps, and list slicing.
   - Hints, test cases, and safe deterministic client evaluation (strictly no `eval()` or unsafe execution).
   - Demo leaderboard ranking freshman students by XP.

7. **TeamTrack — Group Project Management**
   - 4-Column interactive Kanban board (`To Do`, `In Progress`, `Blocked`, `Done`).
   - Project milestone timelines and shared meeting minute logs.
   - Member contribution transparency metrics with academic integrity disclaimer.

8. **Shared Gamification Engine**
   - Single unified XP, streak, and level system (`Fresher Scout` → `Campus Explorer` → `Code Apprentice` → `Semester Warrior` → `Campus Prodigy`).
   - Duplicate reward prevention: tracks unique action keys to prevent exploit farming.
   - In-app notification center and badge collection.

---

## 🛠️ Technology Stack

- **Frontend:** React 18 with Vite
- **Language:** TypeScript (Strict mode enabled)
- **Styling:** Tailwind CSS (Soft lavender, indigo, violet, slate palette with dark mode support)
- **Icons:** Lucide React
- **Routing:** React Router v6
- **Data Visualization:** Recharts
- **Gamification & Audio:** Web Audio API synthesis & Canvas Confetti
- **Backend & Database:** Supabase PostgreSQL (schema script included in `supabase/schema.sql`)
- **Persistence:** LocalStorage Demo Persistence with one-click data reset
- **Testing:** Vitest & React Testing Library (100% passing tests)

---

## 🚀 Quick Start (Running Locally)

### 1. Prerequisites
- Node.js (v18 or v20+ recommended)
- npm

### 2. Start Development Server
```bash
npm run dev
```
Open your browser at `http://localhost:5173`.

### 3. Run Test Suite
```bash
npm run test
```

### 4. Build for Production
```bash
npm run build
```

---

## 🎯 Interactive Demo Mode for Judges

CampusX runs out of the box in **Interactive Demo Mode** without requiring external credentials or API keys:
- Click **"Instant Demo Login (Aarav Sharma)"** on the login page, or start directly from the landing page.
- All tasks, Pomodoro logs, peer requests, and quiz scores persist in your browser's `localStorage`.
- Click the **"Reset Demo State"** button in the top banner anytime to instantly restore fresh hackathon sample records.

---

## 🗄️ Supabase PostgreSQL Setup (Optional)

To connect a live Supabase backend:
1. Create a project at [supabase.com](https://supabase.com).
2. Execute the SQL script in `supabase/schema.sql` inside the Supabase SQL Editor.
3. Create a `.env` file in the project root:
   ```env
   VITE_SUPABASE_URL=https://your-project.supabase.co
   VITE_SUPABASE_ANON_KEY=your-anon-key
   ```
4. Restart the development server. CampusX will automatically detect your credentials and display the **Supabase Connected** badge in the top banner.

---

## 📝 License
Built with ❤️ for student success and academic collaboration.
