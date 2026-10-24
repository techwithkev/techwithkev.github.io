# System Changes & Database Optimizations

This document summarizes the changes made to the AI Junior Competition portal to support dynamic classes/cohorts, fix rendering bugs, and optimize the database schema.

---

## 1. Teacher Portal Enhancements

### Dynamic Class List
* **File:** [Generate_Access_Codes_with_login.html](file:///Users/kevinng/Kevin/kevin/techwithkev.github.io/pages/teacher/Generate_Access_Codes_with_login.html)
* **Changes:**
  * Removed hardcoded `<option>` elements (Classes 10–16) from the class selector dropdown.
  * Added `loadClasses()` JavaScript function to fetch active classes dynamically from the `class_config` table in Supabase.
  * Displays class names dynamically using the `title` column.

### Dynamic Cohort Management
* **Files:** 
  * [Generate_Access_Codes_with_login.html](file:///Users/kevinng/Kevin/kevin/techwithkev.github.io/pages/teacher/Generate_Access_Codes_with_login.html)
  * [manage_cohorts.html](file:///Users/kevinng/Kevin/kevin/techwithkev.github.io/pages/teacher/manage_cohorts.html) *(New)*
  * [index.html](file:///Users/kevinng/Kevin/kevin/techwithkev.github.io/pages/teacher/index.html)
* **Changes:**
  * Created a dedicated cohort management dashboard (`manage_cohorts.html`) with teacher authentication to create, view, and delete active cohorts.
  * Replaced the hardcoded cohort datalist in the Access Code Generator with a dynamic query (`loadCohorts()`) pointing to the new `cohorts` table.
  * Added a **Manage Cohorts** button to the generator UI and a navigation card to the main Instructor Hub (`index.html`).

---

## 2. Student Homework Bug Fixes

### Code Snippet Formatting
* **File:** [homework.html](file:///Users/kevinng/Kevin/kevin/techwithkev.github.io/pages/aijr/homework.html)
* **Issue:** Python code snippets containing literal `\n` character escape sequences (e.g., `a = np.array([[1, 2, 3],\n [4, 5, 6]])`) rendered the string `\n` literally instead of breaking onto newlines.
* **Fix:** Updated the question-rendering engine to replace literal string escape sequences (`\\n`) with actual newlines (`\n`) before injecting the HTML. This allows the CSS `white-space: pre` rule to correctly format multi-line code snippets.

---

## 3. Database Schema Optimizations

### Backend Enhancements
* **File:** [optimize_schema.sql](file:///Users/kevinng/Kevin/kevin/techwithkev.github.io/docs/design/optimize_schema.sql) *(New)*
* **Key Changes Defined:**
  * **Table Creation:** Schema definition for the new `public.cohorts` table.
  * **Data Integrity (Foreign Keys):**
    * Links `access_codes.cohort` to `cohorts.name`.
    * Links `homework_submissions.class_number` to `class_config.class_number`.
    * Links `homework_submissions.access_code` to `access_codes.code`.
    * Links `homework_submissions.cohort` to `cohorts.name`.
    * Links `caio_final_exam_results.class_number` to `class_config.class_number`.
    * Links `caio_final_exam_results.access_code` to `access_codes.code`.
  * **Performance Optimization (Indexes):**
    * Created index tables on columns frequently filtered or queried in teacher dashboards (`cohort`, `class_number`, `code`, and `student_name`).
  * **Relational Student Model (Future Recommendation):**
    * Included commented-out SQL scripts to migrate flat text-based `student_name` columns into a unified relational `students` table to prevent name duplicate/typo mismatches.

---

## 4. Proposed Optimization: Unified Students Table

Implementing a relational `students` table requires coordinated changes across the database, student-facing pages, and teacher dashboards. Below is the blueprint of what must be modified if you choose to transition from text-based names to UUID-based relations.

### A. Database Schema Migrations
For each table containing submissions (e.g., `homework_submissions`, `project_progress_notes`, `final_project_definitions`, `caio_final_exam_results`):
1. Add a `student_id` column referencing `public.students(id)`.
2. Run an update query to map existing text names to the newly generated UUIDs:
   ```sql
   UPDATE public.homework_submissions h
   SET student_id = s.id
   FROM public.students s
   WHERE s.first_name || ' ' || s.last_name = h.student_name;
   ```
3. Drop the old `student_name` text column and set `student_id` to `NOT NULL`.

### B. Student-Facing Pages (`pages/aijr/homework.html`, etc.)
Instead of immediately proceeding with a raw text name, the page must resolve the name to a `student_id` using a query:
1. **Lookup / Auto-Register:**
   ```javascript
   const parts = name.split(/\s+/);
   const firstName = parts[0];
   const lastName = parts.slice(1).join(' ');

   // Find existing student in the cohort
   let { data: student } = await db
     .from('students')
     .select('id')
     .eq('first_name', firstName)
     .eq('last_name', lastName)
     .eq('cohort', validatedCohort)
     .maybeSingle();

   // If not found, register them
   if (!student) {
     const { data: newStudent } = await db
       .from('students')
       .insert([{ first_name: firstName, last_name: lastName, cohort: validatedCohort }])
       .select('id')
       .single();
     student = newStudent;
   }
   
   validatedStudentId = student.id;
   ```
2. **Payload Change:** Replace `student_name: studentName` with `student_id: validatedStudentId` in the submission payload.

### C. Teacher Dashboards (`pages/teacher/teacher_dashboard.html`, `ai_progress_view.html`)
The dashboards must join the `students` table to display names:
* **Query Change:**
  ```javascript
  // Before
  const { data } = await db.from('homework_submissions').select('*');
  // Access: submission.student_name

  // After
  const { data } = await db
    .from('homework_submissions')
    .select('*, students(first_name, last_name)');
  // Access: `${submission.students.first_name} ${submission.students.last_name}`
  ```

---

## 5. Student Signup Process Design

To support the relational `students` table, we need a clean, secure method for students to register. Below are the design options, along with the recommended implementation.

### Option 1: Access-Code-Driven Auto-Registration (Recommended)
This approach embeds signup directly into the existing homework access flow, minimizing friction.

* **The Flow:**
  1. **Access Gate:** The student enters their **Access Code** (which is already linked to a `cohort` in the database).
  2. **Identity Gate:** The student enters their **First Name**, **Last Name**, and **Email**.
  3. **Verification & Creation:**
     - The system queries `public.students` by `email` and `cohort`.
     - If the student exists, it retrieves their `student_id`.
     - If the student does not exist, it inserts a new record:
       ```javascript
       const { data: student } = await db
         .from('students')
         .insert([{ first_name, last_name, email, cohort: validatedCohort }])
         .select('id')
         .single();
       ```
  4. **Authorization:** The student is authorized, and their `student_id` is tied to their homework submission.
* **Subsequent Access Flow:**
  - For future homework assignments (e.g., Class 11), the student enters the new access code, name, and email.
  - The query checks for `email` + `cohort`. It finds the existing record and retrieves the same `student_id` without creating a duplicate.
* **Security & Impersonation Prevention:**
  - **Local Storage Cache (Recommended):** On successful registration, the system stores the `student_id`, `name`, and `email` in the browser's `localStorage`. For subsequent homework, the Identity Gate is skipped entirely—they only need to enter the new Access Code.
  - **Verification Safeguard:** If a student accesses the portal from a new device and enters an email that already exists in the system, you can either:
    1. *Trust-based:* Allow them to proceed (simplest, best for junior groups).
    2. *Verification-based:* Send a quick 6-digit Supabase OTP email only if the email already exists in the database to verify ownership.
* **Pros:** Zero-friction (no separate signup page or password management); secure because registration requires a teacher-generated access code.

### Option 2: Teacher-Uploaded Roster (Pre-Registration)
The teacher manages the student list directly, and students simply identify themselves.

* **The Flow:**
  1. The teacher uploads a CSV or pastes a list of names/emails into a **Roster Manager** in the Instructor Portal.
  2. The database is pre-populated with student records.
  3. When starting homework, students enter their email. The system verifies it against the roster and logs them in.
* **Pros:** Eliminates duplicate accounts, name typos, and fake registrations.
* **Cons:** Teachers must manually manage rosters.

### Option 3: Supabase Passwordless OTP (Email Verification)
Ensures student identity and email ownership using Supabase Auth.

* **The Flow:**
  1. The student enters their email on a signup page.
  2. Supabase sends a 6-digit One-Time Password (OTP) to their email.
  3. After verification, the student enters their name and an access code to join their cohort.
* **Pros:** Highly secure; prevents students from submitting work under someone else's email.
* **Cons:** Higher friction (waiting for email delivery, spam folder issues).

