---
layout: default
title: Home
---

<section class="hero">
  <h1>Hi, I'm Kev.</h1>
  <p>I build apps and teach people how to create incredible digital experiences. Welcome to my portfolio.</p>
  <div class="mt-40">
    <a href="/contact" class="button primary">Get in Touch</a>
  </div>
</section>

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
