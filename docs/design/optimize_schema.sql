-- SQL Migration: Schema Optimizations, Constraints, and Indexes
-- Target: Supabase PostgreSQL Database

-- ==========================================
-- 1. PREPARATION & DEPENDENCY ALIGNMENT
-- ==========================================

-- Ensure the 'aijr' cohort exists in the cohorts table so foreign keys do not fail on existing records.
INSERT INTO public.cohorts (name, description)
VALUES ('aijr', 'Default AI Junior Cohort')
ON CONFLICT (name) DO NOTHING;

-- ==========================================
-- 2. ADDING MISSING FOREIGN KEY CONSTRAINTS
-- ==========================================

-- A. Link access_codes to cohorts
ALTER TABLE public.access_codes
  ADD CONSTRAINT access_codes_cohort_fkey 
  FOREIGN KEY (cohort) 
  REFERENCES public.cohorts(name) 
  ON UPDATE CASCADE;

-- B. Link homework_submissions to class_config, access_codes, and cohorts
ALTER TABLE public.homework_submissions
  ADD CONSTRAINT homework_submissions_class_number_fkey 
  FOREIGN KEY (class_number) 
  REFERENCES public.class_config(class_number),
  
  ADD CONSTRAINT homework_submissions_access_code_fkey 
  FOREIGN KEY (access_code) 
  REFERENCES public.access_codes(code) 
  ON UPDATE CASCADE,
  
  ADD CONSTRAINT homework_submissions_cohort_fkey 
  FOREIGN KEY (cohort) 
  REFERENCES public.cohorts(name) 
  ON UPDATE CASCADE;

-- C. Link caio_final_exam_results to class_config and access_codes
ALTER TABLE public.caio_final_exam_results
  ADD CONSTRAINT caio_final_exam_results_class_number_fkey 
  FOREIGN KEY (class_number) 
  REFERENCES public.class_config(class_number),
  
  ADD CONSTRAINT caio_final_exam_results_access_code_fkey 
  FOREIGN KEY (access_code) 
  REFERENCES public.access_codes(code) 
  ON UPDATE CASCADE;


-- ==========================================
-- 3. INDEXES FOR PERFORMANCE OPTIMIZATION
-- ==========================================

-- Indexes for homework_submissions queries (frequently filtered in Teacher Dashboard)
CREATE INDEX IF NOT EXISTS idx_homework_submissions_cohort 
  ON public.homework_submissions(cohort);

CREATE INDEX IF NOT EXISTS idx_homework_submissions_class 
  ON public.homework_submissions(class_number);

CREATE INDEX IF NOT EXISTS idx_homework_submissions_student 
  ON public.homework_submissions(student_name);

-- Indexes for access_codes lookup
CREATE INDEX IF NOT EXISTS idx_access_codes_cohort 
  ON public.access_codes(cohort);

CREATE INDEX IF NOT EXISTS idx_access_codes_code 
  ON public.access_codes(code);

-- Indexes for project progress and definitions
CREATE INDEX IF NOT EXISTS idx_project_notes_student 
  ON public.project_progress_notes(student_name);

CREATE INDEX IF NOT EXISTS idx_project_def_student 
  ON public.final_project_definitions(student_name);


-- ==========================================
-- 4. PROPOSED OPTIMIZATION: UNIFIED STUDENTS TABLE
-- ==========================================
-- Uncomment the block below to migrate from raw student text names to a relational student model.

/*
-- Step 1: Create students table
CREATE TABLE public.students (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  first_name text NOT NULL,
  last_name text NOT NULL,
  email text UNIQUE,
  cohort text REFERENCES public.cohorts(name) ON UPDATE CASCADE,
  created_at timestamp with time zone DEFAULT now()
);

-- Step 2: Extract distinct students from existing submissions
INSERT INTO public.students (first_name, last_name, cohort)
SELECT DISTINCT 
  split_part(student_name, ' ', 1) as first_name,
  substring(student_name from ' (.*)$') as last_name,
  cohort
FROM public.homework_submissions
WHERE student_name IS NOT NULL AND student_name LIKE '% %'
ON CONFLICT DO NOTHING;
*/
