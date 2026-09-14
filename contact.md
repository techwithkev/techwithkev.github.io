---
layout: default
title: Contact
description: "Questions about Introduction to AI, AI Olympiads Junior, or anything else — send a message and get a reply within 24 hours."
---

<section class="px-6 md:px-12 py-14 md:py-20">
  <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 lg:gap-16 items-start max-w-[1100px]">

    <div>
      <div class="inline-flex px-[14px] py-[7px] rounded-full bg-[#1E4FD9] text-white text-xs font-bold tracking-[.03em] mb-5">GET IN TOUCH</div>
      <h1 class="text-[32px] md:text-[40px] leading-[1.24] font-bold mb-5">Let&rsquo;s talk about your goals.</h1>
      <p class="text-[16px] md:text-[17px] leading-[1.6] text-[#57607A] mb-10 max-w-[480px]">Have a question about Introduction to AI, AI Olympiads Junior, or anything else? Send a message and I&rsquo;ll get back to you within 24 hours.</p>

      <div class="flex flex-col gap-6">
        <div>
          <p class="font-bold text-sm mb-1">Response time</p>
          <p class="text-sm text-[#57607A]">Within 24 hours on weekdays</p>
        </div>
        <div>
          <p class="font-bold text-sm mb-1">Format</p>
          <p class="text-sm text-[#57607A]">Both courses run online</p>
        </div>
        <div>
          <p class="font-bold text-sm mb-1">Subjects</p>
          <p class="text-sm text-[#57607A]">Introduction to AI and AI Olympiads Junior</p>
        </div>
      </div>
    </div>

    <div class="bg-white rounded-[20px] p-8 shadow-[0_8px_24px_rgba(19,23,34,.06)]">
      <h2 class="font-bold text-xl mb-6">Send a message</h2>
      <form action="https://formspree.io/f/YOUR_FORM_ID" method="POST" class="flex flex-col gap-5">
        <div>
          <label for="name" class="block text-sm font-bold mb-2">Your name</label>
          <input type="text" name="name" id="name" placeholder="e.g. Mrs. Tan" required
            class="w-full px-4 py-3 border border-[#c7cede] rounded-xl text-sm focus:outline-none focus:border-[#1E4FD9] focus:ring-1 focus:ring-[#1E4FD9] bg-white transition-colors">
        </div>
        <div>
          <label for="email" class="block text-sm font-bold mb-2">Email address</label>
          <input type="email" name="email" id="email" placeholder="your@email.com" required
            class="w-full px-4 py-3 border border-[#c7cede] rounded-xl text-sm focus:outline-none focus:border-[#1E4FD9] focus:ring-1 focus:ring-[#1E4FD9] bg-white transition-colors">
        </div>
        <div>
          <label for="subject" class="block text-sm font-bold mb-2">Subject</label>
          <select name="subject" id="subject" class="w-full px-4 py-3 border border-[#c7cede] rounded-xl text-sm focus:outline-none focus:border-[#1E4FD9] focus:ring-1 focus:ring-[#1E4FD9] bg-white transition-colors text-[#57607A]">
            <option value="">Select a topic&hellip;</option>
            <option value="introai">Introduction to AI</option>
            <option value="aijr">AI Olympiads Junior</option>
            <option value="general">General inquiry</option>
          </select>
        </div>
        <div>
          <label for="message" class="block text-sm font-bold mb-2">Message</label>
          <textarea name="message" id="message" placeholder="How can I help you?" required rows="5"
            class="w-full px-4 py-3 border border-[#c7cede] rounded-xl text-sm focus:outline-none focus:border-[#1E4FD9] focus:ring-1 focus:ring-[#1E4FD9] bg-white transition-colors resize-y"></textarea>
        </div>
        <button type="submit" class="w-full min-h-11 py-[15px] bg-[#1E4FD9] text-white font-bold rounded-full hover:brightness-110 transition">Send message</button>
      </form>
    </div>

  </div>
</section>
