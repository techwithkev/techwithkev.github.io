---
layout: default
title: Contact
---

<section class="py-20 max-w-7xl mx-auto px-6">
  <div class="grid grid-cols-1 lg:grid-cols-2 gap-20 items-start">

    <div>
      <span class="text-[#006a6a] font-headline font-bold uppercase tracking-widest text-sm mb-4 block">Get in Touch</span>
      <h1 class="font-headline font-black text-5xl text-primary tracking-tight mb-6 leading-[1.1]">Let's talk about your goals.</h1>
      <p class="text-on-surface-variant text-lg leading-relaxed mb-12">Have a question about tutoring, courses, or pricing? Send a message and I'll get back to you within 24 hours.</p>

      <div class="space-y-8">
        <div class="flex items-start gap-4">
          <div class="w-12 h-12 bg-surface-container-high rounded-lg flex items-center justify-center flex-shrink-0">
            <span class="material-symbols-outlined text-primary">schedule</span>
          </div>
          <div>
            <p class="font-bold text-primary font-headline">Response Time</p>
            <p class="text-on-surface-variant text-sm">Within 24 hours on weekdays</p>
          </div>
        </div>
        <div class="flex items-start gap-4">
          <div class="w-12 h-12 bg-surface-container-high rounded-lg flex items-center justify-center flex-shrink-0">
            <span class="material-symbols-outlined text-primary">videocam</span>
          </div>
          <div>
            <p class="font-bold text-primary font-headline">Sessions</p>
            <p class="text-on-surface-variant text-sm">Online via video call, or in-person (Singapore)</p>
          </div>
        </div>
        <div class="flex items-start gap-4">
          <div class="w-12 h-12 bg-surface-container-high rounded-lg flex items-center justify-center flex-shrink-0">
            <span class="material-symbols-outlined text-primary">terminal</span>
          </div>
          <div>
            <p class="font-bold text-primary font-headline">Subjects</p>
            <p class="text-on-surface-variant text-sm">Secondary Math (E-Math, A-Math) and Python programming</p>
          </div>
        </div>
      </div>
    </div>

    <div class="bg-surface-container-lowest p-10 rounded-xl shadow-sm border border-outline-variant/20">
      <h2 class="font-headline font-bold text-2xl text-primary mb-8">Send a Message</h2>
      <form action="https://formspree.io/f/YOUR_FORM_ID" method="POST" class="space-y-6">
        <div>
          <label for="name" class="block text-sm font-bold text-primary mb-2 font-headline">Your Name</label>
          <input type="text" name="name" id="name" placeholder="e.g. Mrs. Tan" required
            class="w-full px-4 py-3 border border-outline-variant rounded-lg text-sm font-body focus:outline-none focus:border-[#006a6a] focus:ring-1 focus:ring-[#006a6a] bg-white transition-colors">
        </div>
        <div>
          <label for="email" class="block text-sm font-bold text-primary mb-2 font-headline">Email Address</label>
          <input type="email" name="email" id="email" placeholder="your@email.com" required
            class="w-full px-4 py-3 border border-outline-variant rounded-lg text-sm font-body focus:outline-none focus:border-[#006a6a] focus:ring-1 focus:ring-[#006a6a] bg-white transition-colors">
        </div>
        <div>
          <label for="subject" class="block text-sm font-bold text-primary mb-2 font-headline">Subject</label>
          <select name="subject" id="subject" class="w-full px-4 py-3 border border-outline-variant rounded-lg text-sm font-body focus:outline-none focus:border-[#006a6a] focus:ring-1 focus:ring-[#006a6a] bg-white transition-colors text-on-surface-variant">
            <option value="">Select a topic...</option>
            <option value="1-on-1 tutoring">1-on-1 tutoring inquiry</option>
            <option value="python-course">Python Fundamentals course</option>
            <option value="math-intensive">O-Level Math Intensive</option>
            <option value="assessment">Free assessment question</option>
            <option value="other">Other</option>
          </select>
        </div>
        <div>
          <label for="message" class="block text-sm font-bold text-primary mb-2 font-headline">Message</label>
          <textarea name="message" id="message" placeholder="How can I help you?" required rows="5"
            class="w-full px-4 py-3 border border-outline-variant rounded-lg text-sm font-body focus:outline-none focus:border-[#006a6a] focus:ring-1 focus:ring-[#006a6a] bg-white transition-colors resize-y"></textarea>
        </div>
        <button type="submit" class="w-full py-4 architect-gradient text-white font-bold font-headline rounded-lg hover:brightness-110 active:scale-[0.98] transition-all">Send Message</button>
      </form>
    </div>

  </div>
</section>
