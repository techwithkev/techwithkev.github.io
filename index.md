---
layout: default
title: Home
---

<div class="wrapper">
  <section class="hero">
    <span class="hero-label">1-on-1 tutoring · Singapore</span>
    <h1>Secondary Math<br>and Python.</h1>
    <span class="hero-italic">Taught by someone who knows your syllabus.</span>
    <p>Most students don't need more content — they need someone to find the specific gap and close it before the next exam. That's what I do.</p>
    <div class="hero-actions">
      <a href="/pages/book.html" class="button primary">Book a session</a>
      <a href="/pages/python_functions.html" class="button outline">Free Python assessment</a>
    </div>
  </section>
</div>

<section class="proof-section">
  <div class="wrapper">
    <div class="proof-grid">
      <div class="proof-item">
        <span class="proof-number">1-on-1</span>
        <span class="proof-label">Every session is just you and me</span>
      </div>
      <div class="proof-item">
        <span class="proof-number">60 min</span>
        <span class="proof-label">Focused, no filler — straight to your problem</span>
      </div>
      <div class="proof-item">
        <span class="proof-number">Free</span>
        <span class="proof-label">Diagnostic assessments before you commit</span>
      </div>
    </div>
  </div>
</section>

<section class="services-section">
  <div class="wrapper">
    <span class="section-label">What I teach</span>
    <h2>Two subjects. One tutor.</h2>
    <div class="services-grid">
      <div class="service-card">
        <span class="service-icon">Secondary Math</span>
        <h3>Algebra to A-Math</h3>
        <p>Sequences, surds, differentiation, trigonometry — wherever you're stuck, we start there. Mapped to the Singapore O-Level and IP syllabus.</p>
      </div>
      <div class="service-card">
        <span class="service-icon">Python</span>
        <h3>From print() to functions</h3>
        <p>Secondary computing and beginner Python. Variables, loops, functions, and thinking like a programmer. No assumptions about what you already know.</p>
      </div>
      <div class="service-card">
        <span class="service-icon">How it works</span>
        <h3>Sessions via video call</h3>
        <p>Book a 60-minute slot. I diagnose what's missing, explain it the right way, and send you practice problems that actually match your exam format.</p>
      </div>
    </div>
  </div>
</section>

<section class="assessment-section">
  <div class="wrapper">
    <div class="assessment-card">
      <span class="assessment-label">Free diagnostic</span>
      <h2>Find your gaps before your exam does.</h2>
      <p>The Python Functions assessment takes 15 minutes. You get a score, a breakdown of exactly what to review, and a direct link to book if you want help.</p>
      <div class="assessment-actions">
        <a href="/pages/python_functions.html" class="button primary">Take the Python assessment</a>
        <a href="/pages/g9_math_prerequisite_assessment.html" class="button ghost">G9 Math assessment</a>
      </div>
    </div>
  </div>
</section>

{% if site.apps.size > 0 %}
<section class="apps-section">
  <div class="wrapper">
    <span class="section-label">Apps</span>
    <h2>Things I've built</h2>
    <div class="app-grid">
      {% for app in site.apps %}
      <a href="{{ app.url | relative_url }}" class="app-card">
        <img src="{{ app.icon_url }}" alt="{{ app.title }} Icon" class="app-card-icon">
        <h3>{{ app.title }}</h3>
        <p>{{ app.tagline }}</p>
      </a>
      {% endfor %}
    </div>
  </div>
</section>
{% endif %}
