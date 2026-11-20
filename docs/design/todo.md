# TODO: Access Code Usage Improvements

This document outlines planned improvements to the access code tracking system. These changes will address potential race conditions, prevent double-submission abuse, and add teacher convenience features.

---

## 1. Implement Atomic Increments (Fix Race Conditions)

### Problem
The current implementation in `homework.html` reads `uses_count` in one client-side request and writes `uses_count + 1` in a second request. If two students submit the same code at the same millisecond, both will read the same count, causing the database to record only one increment instead of two.

### Solution
Replace the client-side update with a Supabase PostgreSQL function (RPC) that increments the database row atomically.

#### SQL Setup (Run in Supabase SQL Editor)
```sql
CREATE OR REPLACE FUNCTION increment_code_uses(code_id uuid)
RETURNS void AS $$
  UPDATE public.access_codes
  SET uses_count = uses_count + 1
  WHERE id = code_id;
$$ LANGUAGE sql;
```

#### Frontend Update (`pages/aijr/homework.html`)
Replace the current update logic:
```javascript
// Remove this:
// const { error: updateErr } = await db.from('access_codes').update({ uses_count: data.uses_count + 1 }).eq('id', data.id);

// Add this:
const { error: updateErr } = await db.rpc('increment_code_uses', { code_id: data.id });
```

---

## 2. Implement Double-Submission Protection

### Problem
Currently, a student can refresh the homework page and reuse the same access code, consuming multiple slots from the code's `max_uses`.

### Solution
Track which students have used each code by keeping an array of identifiers (e.g., email or student UUID) in the `access_codes` table.

#### SQL Schema Adjustment
```sql
ALTER TABLE public.access_codes ADD COLUMN used_by_students jsonb DEFAULT '[]'::jsonb;
```

#### SQL RPC Update
```sql
CREATE OR REPLACE FUNCTION use_access_code(code_id uuid, student_email text)
RETURNS boolean AS $$
DECLARE already_used boolean;
BEGIN
  -- Check if student has already used this code
  SELECT (used_by_students @> to_jsonb(student_email))
  INTO already_used 
  FROM public.access_codes 
  WHERE id = code_id;
  
  IF already_used THEN 
    RETURN false; 
  END IF;
  
  -- Increment and append student to the tracking array
  UPDATE public.access_codes
  SET uses_count = uses_count + 1,
      used_by_students = used_by_students || to_jsonb(student_email)
  WHERE id = code_id;
  
  RETURN true;
END;
$$ LANGUAGE plpgsql;
```

---

## 3. Add "Reset Usage" Button in Teacher Portal

### Problem
There is currently no way for a teacher to clear or reset the usage counts on an active code (e.g., if a student wasted a usage slot by accident) without manually increasing `max_uses`.

### Solution
Add a **Reset** button to each row in the Active Codes table.

#### Frontend Update (`pages/teacher/Generate_Access_Codes_with_login.html`)
1. **Add JavaScript function:**
   ```javascript
   async function resetCodeUsage(id) {
     if (!confirm('Are you sure you want to reset the usage count to 0 for this code?')) return;
     
     const { error } = await db
       .from('access_codes')
       .update({ uses_count: 0 })
       .eq('id', id);

     if (error) {
       alert(`Reset failed: ${error.message}`);
       return;
     }
     loadActiveCodes();
   }
   ```
2. **Add Button to Actions column:**
   ```html
   <button class="tbl-action-btn toggle-btn" onclick="resetCodeUsage('${c.id}')">Reset</button>
   ```
