---
layout: default
title: Home
---

<section class="hero">
  <h1>Hi, I'm Kev.</h1>
  <p>I help secondary students master coding and mathematics — through online courses, private tutoring, and free assessments.</p>
  <div class="mt-40" style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
    <a href="/contact" class="button primary">Book a Session</a>
    <a href="/pages/python_functions.html" class="button outline">Free Python Assessment</a>
  </div>
</section>

{% if site.apps.size > 0 %}
<section id="apps" class="apps-section">
  <div class="wrapper">
    <h2 class="center">My Apps</h2>
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
