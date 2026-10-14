-- =========================================================================
-- CAMPUSX: PostgreSQL Schema & Row Level Security (Supabase)
-- B.Tech First-Year Student Success Platform
-- =========================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. PROFILES TABLE
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT NOT NULL,
  display_name TEXT NOT NULL,
  college_name TEXT NOT NULL,
  department TEXT NOT NULL,
  current_semester TEXT NOT NULL,
  learning_format TEXT DEFAULT 'hybrid' CHECK (learning_format IN ('online', 'in-person', 'hybrid')),
  avatar_url TEXT,
  bio TEXT,
  credits INTEGER DEFAULT 100 CHECK (credits >= 0),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS: Profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public profiles are viewable by authenticated users" ON public.profiles
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Users can insert their own profile" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update their own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

-- 2. PROFILE SKILLS
CREATE TABLE IF NOT EXISTS public.profile_skills (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  profile_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  skill_name TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('teach', 'learn')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.profile_skills ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Skills viewable by authenticated users" ON public.profile_skills FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Users manage their own skills" ON public.profile_skills FOR ALL USING (auth.uid() = profile_id);

-- 3. STUDY TASKS TABLE
CREATE TABLE IF NOT EXISTS public.study_tasks (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  subject TEXT NOT NULL,
  description TEXT,
  priority TEXT DEFAULT 'medium' CHECK (priority IN ('urgent', 'high', 'medium', 'low')),
  due_date DATE NOT NULL,
  estimated_duration INTEGER NOT NULL DEFAULT 45,
  completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  priority_score NUMERIC(5, 2),
  priority_reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.study_tasks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own study tasks" ON public.study_tasks
  FOR ALL USING (auth.uid() = user_id);

-- 4. EXAMS & DEADLINES
CREATE TABLE IF NOT EXISTS public.exams (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  subject TEXT NOT NULL,
  exam_date DATE NOT NULL,
  type TEXT DEFAULT 'exam' CHECK (type IN ('exam', 'assignment', 'lab')),
  weightage TEXT,
  syllabus TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.exams ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage their own exams" ON public.exams FOR ALL USING (auth.uid() = user_id);

-- 5. FOCUS SESSIONS (Pomodoro history)
CREATE TABLE IF NOT EXISTS public.focus_sessions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  task_id UUID REFERENCES public.study_tasks(id) ON DELETE SET NULL,
  task_title TEXT NOT NULL,
  duration_minutes INTEGER NOT NULL,
  session_type TEXT DEFAULT 'work' CHECK (session_type IN ('work', 'break')),
  completed_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.focus_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view own focus sessions" ON public.focus_sessions FOR ALL USING (auth.uid() = user_id);

-- 6. SKILL REQUESTS & SESSIONS
CREATE TABLE IF NOT EXISTS public.skill_requests (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  sender_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  receiver_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  skill_offered TEXT NOT NULL,
  skill_requested TEXT NOT NULL,
  format TEXT DEFAULT 'hybrid' CHECK (format IN ('online', 'in-person', 'hybrid')),
  message TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'cancelled', 'completed')),
  session_date DATE,
  session_time TEXT,
  session_venue TEXT,
  session_notes TEXT,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  review TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.skill_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view requests they are involved in" ON public.skill_requests
  FOR SELECT USING (auth.uid() = sender_id OR auth.uid() = receiver_id);
CREATE POLICY "Users can create requests" ON public.skill_requests
  FOR INSERT WITH CHECK (auth.uid() = sender_id);
CREATE POLICY "Users can update requests they are involved in" ON public.skill_requests
  FOR UPDATE USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

-- 7. LEARNING CREDITS LEDGER
CREATE TABLE IF NOT EXISTS public.learning_credits_ledger (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  amount INTEGER NOT NULL,
  reason TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.learning_credits_ledger ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view own credits ledger" ON public.learning_credits_ledger FOR ALL USING (auth.uid() = user_id);

-- 8. CONCEPTS & QUIZ ATTEMPTS
CREATE TABLE IF NOT EXISTS public.concept_bookmarks (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  concept_id TEXT NOT NULL,
  mastered BOOLEAN DEFAULT FALSE,
  best_quiz_score INTEGER DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (user_id, concept_id)
);
ALTER TABLE public.concept_bookmarks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own concept progress" ON public.concept_bookmarks FOR ALL USING (auth.uid() = user_id);

-- 9. CAMPUS TIMETABLE ENTRIES
CREATE TABLE IF NOT EXISTS public.timetable_entries (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  day_of_week TEXT NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  subject TEXT NOT NULL,
  room TEXT NOT NULL,
  faculty TEXT,
  color TEXT,
  type TEXT DEFAULT 'lecture' CHECK (type IN ('lecture', 'lab', 'tutorial')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.timetable_entries ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own timetable" ON public.timetable_entries FOR ALL USING (auth.uid() = user_id);

-- 10. CAMPUS ANNOUNCEMENTS (Notice Board)
CREATE TABLE IF NOT EXISTS public.campus_announcements (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('academic', 'club', 'hackathon', 'general')),
  content TEXT NOT NULL,
  published_date DATE DEFAULT CURRENT_DATE,
  author TEXT NOT NULL,
  is_official_demo BOOLEAN DEFAULT TRUE,
  priority TEXT DEFAULT 'normal' CHECK (priority IN ('urgent', 'normal')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.campus_announcements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Announcements are public to authenticated users" ON public.campus_announcements FOR SELECT USING (true);

-- 11. CODING ATTEMPTS
CREATE TABLE IF NOT EXISTS public.coding_attempts (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  challenge_id TEXT NOT NULL,
  language TEXT NOT NULL CHECK (language IN ('c', 'python')),
  solved BOOLEAN DEFAULT FALSE,
  selected_answer TEXT,
  completed_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, challenge_id)
);
ALTER TABLE public.coding_attempts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage coding attempts" ON public.coding_attempts FOR ALL USING (auth.uid() = user_id);

-- 12. SHARED GAMIFICATION: XP & BADGES
CREATE TABLE IF NOT EXISTS public.user_gamification (
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE PRIMARY KEY,
  total_xp INTEGER DEFAULT 0 CHECK (total_xp >= 0),
  current_level INTEGER DEFAULT 1 CHECK (current_level >= 1),
  current_streak INTEGER DEFAULT 1 CHECK (current_streak >= 0),
  max_streak INTEGER DEFAULT 1,
  last_active_date DATE DEFAULT CURRENT_DATE
);
ALTER TABLE public.user_gamification ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own gamification state" ON public.user_gamification FOR ALL USING (auth.uid() = user_id);

CREATE TABLE IF NOT EXISTS public.xp_history (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  reason TEXT NOT NULL,
  points INTEGER NOT NULL,
  action_key TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, action_key) -- Deduplication constraint!
);
ALTER TABLE public.xp_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view and insert xp history" ON public.xp_history FOR ALL USING (auth.uid() = user_id);

-- 13. PROJECTS (TeamTrack)
CREATE TABLE IF NOT EXISTS public.projects (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  owner_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  course TEXT NOT NULL,
  description TEXT,
  deadline DATE,
  repo_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Members can view projects" ON public.projects FOR SELECT USING (true);
CREATE POLICY "Owner can update projects" ON public.projects FOR ALL USING (auth.uid() = owner_id);

CREATE TABLE IF NOT EXISTS public.project_members (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  role TEXT DEFAULT 'Developer' CHECK (role IN ('Lead', 'Developer', 'Designer', 'Researcher', 'Documentation')),
  UNIQUE(project_id, user_id)
);
ALTER TABLE public.project_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Project members can view member lists" ON public.project_members FOR SELECT USING (true);

CREATE TABLE IF NOT EXISTS public.project_tasks (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  priority TEXT DEFAULT 'medium' CHECK (priority IN ('urgent', 'high', 'medium', 'low')),
  status TEXT DEFAULT 'todo' CHECK (status IN ('todo', 'inprogress', 'blocked', 'done')),
  assignee_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  due_date DATE,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.project_tasks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Project members can manage tasks" ON public.project_tasks FOR ALL USING (true);
