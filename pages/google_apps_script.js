// ============================================================
//  G9 Math Assessment — Google Apps Script
//  Paste this entire file into your Apps Script editor,
//  then deploy as a Web App (see setup instructions below).
// ============================================================

// The spreadsheet is automatically determined by the container
// (the sheet this script is bound to), so no ID needed.

function doPost(e) {
  try {
    const data = JSON.parse(e.postData.contents);
    appendRow(data);
    return ContentService
      .createTextOutput(JSON.stringify({ status: 'ok' }))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ status: 'error', message: err.message }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

// Also handle GET so you can test the endpoint in a browser
function doGet(e) {
  return ContentService
    .createTextOutput(JSON.stringify({ status: 'ok', message: 'G9 Assessment endpoint is live.' }))
    .setMimeType(ContentService.MimeType.JSON);
}

function appendRow(data) {
  const ss    = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName('Results') || ss.insertSheet('Results');

  // Write header row if the sheet is empty
  if (sheet.getLastRow() === 0) {
    sheet.appendRow([
      'Timestamp',
      'First Name',
      'Last Name',
      'Date Taken',
      'Total Correct',
      'Total Questions',
      'Percentage (%)',
      'Grade',
      // Section scores
      'A: Fractions & BEDMAS (score)',
      'A: Fractions & BEDMAS (%)',
      'B: Integers & Exponents (score)',
      'B: Integers & Exponents (%)',
      'C: Algebra & Equations (score)',
      'C: Algebra & Equations (%)',
      'D: Polynomials & Factoring (score)',
      'D: Polynomials & Factoring (%)',
      'E: Coordinate Geometry (score)',
      'E: Coordinate Geometry (%)',
      'F: Measurement (score)',
      'F: Measurement (%)',
      'G: Geometry & Similarity (score)',
      'G: Geometry & Similarity (%)',
      'H: Data & Statistics (score)',
      'H: Data & Statistics (%)',
      // Full question-by-question detail
      'Question Detail'
    ]);

    // Style the header row
    const headerRange = sheet.getRange(1, 1, 1, sheet.getLastColumn());
    headerRange.setBackground('#1a1a2e');
    headerRange.setFontColor('#ffffff');
    headerRange.setFontWeight('bold');
    sheet.setFrozenRows(1);

    // Set column widths
    sheet.setColumnWidth(1, 180);  // Timestamp
    sheet.setColumnWidth(2, 120);  // First Name
    sheet.setColumnWidth(3, 120);  // Last Name
    sheet.setColumnWidth(25, 600); // Question Detail
  }

  // Append the student's data row
  sheet.appendRow([
    data.timestamp,
    data.firstName,
    data.lastName,
    data.date,
    data.totalCorrect,
    data.totalQuestions,
    data.percentage,
    data.grade,
    data.secA_score, data.secA_pct,
    data.secB_score, data.secB_pct,
    data.secC_score, data.secC_pct,
    data.secD_score, data.secD_pct,
    data.secE_score, data.secE_pct,
    data.secF_score, data.secF_pct,
    data.secG_score, data.secG_pct,
    data.secH_score, data.secH_pct,
    data.questionDetail
  ]);

  // Colour-code the grade cell in the new row
  const newRow   = sheet.getLastRow();
  const gradeCol = 8; // column H = Grade
  const pctCol   = 7; // column G = Percentage
  const gradeCell = sheet.getRange(newRow, gradeCol);
  const pct = data.percentage;

  if      (pct >= 80) gradeCell.setBackground('#d8f3e5').setFontColor('#2d6a4f');
  else if (pct >= 65) gradeCell.setBackground('#daeef7').setFontColor('#1a5c7a');
  else if (pct >= 50) gradeCell.setBackground('#fef6d9').setFontColor('#a07000');
  else                gradeCell.setBackground('#fde8e8').setFontColor('#c8392b');

  // Colour-code each section % cell (columns J, L, N, P, R, T, V, X)
  const sectionPctCols = [10, 12, 14, 16, 18, 20, 22, 24];
  sectionPctCols.forEach(col => {
    const cell  = sheet.getRange(newRow, col);
    const value = cell.getValue();
    if      (value >= 75) cell.setBackground('#d8f3e5');
    else if (value >= 50) cell.setBackground('#fef6d9');
    else                  cell.setBackground('#fde8e8');
  });
}

// ============================================================
//  SETUP INSTRUCTIONS
// ============================================================
//
//  1. Open the Google Sheet where you want results stored.
//
//  2. Click Extensions → Apps Script.
//
//  3. Delete any existing code in the editor and paste
//     this entire file in its place.
//
//  4. Click Save (Ctrl+S / Cmd+S).
//
//  5. Click Deploy → New Deployment.
//
//  6. Click the gear icon next to "Type" and choose
//     "Web App".
//
//  7. Fill in:
//       Description:          G9 Math Assessment
//       Execute as:           Me  (your Google account)
//       Who has access:       Anyone
//
//  8. Click Deploy → Authorize access when prompted.
//     (Google will warn you the app is unverified — click
//      "Advanced" → "Go to … (unsafe)" to proceed.
//      This is normal for personal scripts.)
//
//  9. Copy the Web App URL that appears — it looks like:
//       https://script.google.com/macros/s/AKfy.../exec
//
// 10. Open index.html (the assessment file) in a text editor,
//     find this line near the top of the <script> section:
//
//       const APPS_SCRIPT_URL = 'YOUR_APPS_SCRIPT_URL_HERE';
//
//     Replace YOUR_APPS_SCRIPT_URL_HERE with the URL you copied.
//     Save the file and push it to GitHub.
//
// ============================================================
//  UPDATING THE SCRIPT LATER
// ============================================================
//  If you ever edit this script, you must create a NEW deployment
//  (Deploy → New Deployment) — re-deploying to an existing
//  deployment does NOT update the live URL in all cases.
//  Update the URL in index.html if it changes.
//
// ============================================================
