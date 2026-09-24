-- AICSSYC delegate invitation (from Downloads/aicssyc_mail_template): an uploaded design with its own
-- light/dark versions of the header and logos, hosted in public/email/aicssyc-2026/.
INSERT INTO public.email_templates (key, label, description, subject, body_md, header_tagline, event_dates, sign_off, cta_buttons, logo_urls, layout_html)
VALUES (
  $tpl$aicssyc_delegate_invitation$tpl$,
  $tpl$AICSSYC Delegate Invitation$tpl$,
  $tpl$AICSSYC 2026 delegate invitation with theme, pillars and keynotes (uploaded design, has dark mode)$tpl$,
  $tpl$We're Delighted to Invite You | AICSSYC 2026$tpl$,
  $tpl$On behalf of the **IEEE Computer Society** and **SRM Institute of Science and Technology**, we have the distinct honour of inviting you to the premier flagship **All India Computer Society Student & Young Professional Congress (AICSSYC 2026)**, convening at **SRMIST, Chennai**.

<table border="0" cellpadding="0" cellspacing="0" width="100%" class="theme-card" style="background-color: #F8FAFC; border: 1px solid #E2E8F0; border-left: 4px solid #00629B; border-radius: 6px; margin: 10px 0 11px 0;"> <tbody><tr> <td class="theme-box-padding" style="padding: 13px 18px;"> <!-- Theme Title --> <div class="theme-label" style="font-size: 10.5px; text-transform: uppercase; letter-spacing: 1.5px; color: #00629B; font-weight: 700; margin-bottom: 2px;"> OFFICIAL CONGRESS THEME </div> <div class="theme-title dark-card-heading" style="font-size: 17.5px; font-weight: 800; color: #0F172A; font-style: italic; line-height: 1.3;"> “Where Agents Meet Humans” </div> <div class="theme-desc" style="font-size: 12px; color: #64748B; margin-top: 2px; margin-bottom: 8px;"> Where Human Ingenuity Meets Autonomous Intelligence </div> <!-- Divider --> <table border="0" cellpadding="0" cellspacing="0" width="100%"> <tbody><tr> <td class="card-divider" style="border-top: 1px solid #E2E8F0; height: 6px; font-size: 1px; line-height: 1px;">&nbsp;</td> </tr> </tbody></table> <!-- Event Details --> <table border="0" cellpadding="0" cellspacing="0" width="100%"> <tbody><tr> <td width="22" valign="top" style="font-size: 13px; line-height: 21px; padding-bottom: 3px;">📅</td> <td valign="top" class="event-detail-text" style="padding-left: 6px; padding-bottom: 3px; font-size: 13px; line-height: 21px; color: #1E293B;"> <strong>Dates:</strong> 8 – 11 October 2026 <span style="color: #64748B;">(4 Days of Convergence)</span> </td> </tr> <tr> <td width="22" valign="top" style="font-size: 13px; line-height: 21px; padding-bottom: 3px;">📍</td> <td valign="top" class="event-detail-text" style="padding-left: 6px; padding-bottom: 3px; font-size: 13px; line-height: 21px; color: #1E293B;"> <strong>Venue:</strong> Hippocrates Hall &amp; Dr. TP Ganesan Auditorium, SRMIST Chennai </td> </tr> <tr> <td width="22" valign="top" style="font-size: 13px; line-height: 21px;">🌐</td> <td valign="top" class="event-detail-text" style="padding-left: 6px; font-size: 13px; line-height: 21px; color: #1E293B;"> <strong>Convergence:</strong> 300+ Delegates • 20+ IEEE Sections • 6 Keynote Pillars </td> </tr> </tbody></table> </td> </tr> </tbody></table>

<table border="0" cellpadding="0" cellspacing="0" width="100%" class="pillars-card" style="background-color: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 6px; margin: 10px 0 11px 0;"> <tbody><tr> <td style="padding: 11px 16px;"> <div class="pillars-label" style="font-size: 10.5px; text-transform: uppercase; letter-spacing: 1.2px; color: #00629B; font-weight: 700; margin-bottom: 7px;"> CORE CONGRESS PILLARS &amp; TRACKS </div> <table border="0" cellpadding="0" cellspacing="0" width="100%"> <tbody><tr> <!-- Left Column (3 Pillars) --> <td class="pillar-col" width="50%" valign="top" style="padding-right: 10px;"> <table border="0" cellpadding="0" cellspacing="0" width="100%"> <tbody><tr> <td width="14" valign="top" class="pillar-bullet" style="font-size: 14px; line-height: 20px; color: #00629B; font-weight: bold;">•</td> <td valign="top" class="pillar-name" style="font-size: 12px; line-height: 20px; color: #1E293B; font-weight: 600;">Autonomous Agents &amp; AI</td> </tr> <tr> <td width="14" valign="top" class="pillar-bullet" style="font-size: 14px; line-height: 20px; color: #00629B; font-weight: bold;">•</td> <td valign="top" class="pillar-name" style="font-size: 12px; line-height: 20px; color: #1E293B; font-weight: 600;">Human-AI Collaboration</td> </tr> <tr> <td width="14" valign="top" class="pillar-bullet" style="font-size: 14px; line-height: 20px; color: #00629B; font-weight: bold;">•</td> <td valign="top" class="pillar-name" style="font-size: 12px; line-height: 20px; color: #1E293B; font-weight: 600;">Edge Silicon &amp; Quantum</td> </tr> </tbody></table> </td> <!-- Right Column (3 Pillars) --> <td class="pillar-col" width="50%" valign="top" style="padding-left: 10px;"> <table border="0" cellpadding="0" cellspacing="0" width="100%"> <tbody><tr> <td width="14" valign="top" class="pillar-bullet" style="font-size: 14px; line-height: 20px; color: #00629B; font-weight: bold;">•</td> <td valign="top" class="pillar-name" style="font-size: 12px; line-height: 20px; color: #1E293B; font-weight: 600;">Cybernetics &amp; Zero-Trust</td> </tr> <tr> <td width="14" valign="top" class="pillar-bullet" style="font-size: 14px; line-height: 20px; color: #00629B; font-weight: bold;">•</td> <td valign="top" class="pillar-name" style="font-size: 12px; line-height: 20px; color: #1E293B; font-weight: 600;">Intelligent Workflows</td> </tr> <tr> <td width="14" valign="top" class="pillar-bullet" style="font-size: 14px; line-height: 20px; color: #00629B; font-weight: bold;">•</td> <td valign="top" class="pillar-name" style="font-size: 12px; line-height: 20px; color: #1E293B; font-weight: 600;">National Research Showcase</td> </tr> </tbody></table> </td> </tr> </tbody></table> </td> </tr> </tbody></table>

<div class="luminaries-card" style="background-color: #F8FAFC; border-radius: 6px; padding: 10px 16px; border: 1px dashed #CBD5E1; margin: 10px 0 11px 0; font-size: 12px; line-height: 1.5; color: #475569;"> <strong class="luminaries-title" style="color: #0F172A;">🌟 Keynote Luminaries:</strong> Presided by <strong>Prof. Hironori Washizaki</strong> (2025 President, IEEE Computer Society), <strong>Eric Berkowitz</strong> (Director of Membership, IEEE CS), <strong>Andrew Seely</strong>, <strong>Biswarup Ray</strong> (Chair SYP IEEE CS), and senior scientists from <strong>ISRO</strong>. </div>$tpl$,
  $tpl$We're Delighted to Invite You$tpl$,
  $tpl$For All India Computer Society Student & Young Professional Congress 2026$tpl$,
  $tpl$We look forward to welcoming you to Chennai for this defining congress.

Warm regards,
**Organizing Committee — AICSSYC 2026**
IEEE Computer Society SRM IST Student Branch Chapter$tpl$,
  $tpl$[{"label":"Get Passes • Register Now →","url":"https://aicssyc-alpha.vercel.app/#tickets","style":"filled"}]$tpl$::jsonb,
  ARRAY[]::text[],
  $tpl$<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" lang="en"><head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="color-scheme" content="light dark">
  <meta name="supported-color-schemes" content="light dark">
  <meta name="x-apple-disable-message-reformatting">
  <!--[if !mso]><!-->
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <!--<![endif]-->
  <title>We're Delighted to Invite You | AICSSYC 2026</title>
  <!--[if mso]>
  <xml>
    <o:OfficeDocumentSettings>
      <o:AllowPNG/>
      <o:PixelsPerInch>96</o:PixelsPerInch>
    </o:OfficeDocumentSettings>
  </xml>
  <![endif]-->
  <style type="text/css">
    :root {
      color-scheme: light dark;
      supported-color-schemes: light dark;
    }
    @page {
      size: A4 portrait;
      margin: 4mm 4mm;
    }
    html, body {
      margin: 0 !important;
      padding: 0 !important;
      width: 100% !important;
      background-color: #FFFFFF;
      -webkit-text-size-adjust: 100%;
      -ms-text-size-adjust: 100%;
    }
    body, table, td, a {
      -webkit-text-size-adjust: 100%;
      -ms-text-size-adjust: 100%;
    }
    table, td {
      mso-table-lspace: 0pt;
      mso-table-rspace: 0pt;
      border-collapse: collapse !important;
    }
    img {
      -ms-interpolation-mode: bicubic;
      border: 0;
      height: auto;
      line-height: 100%;
      outline: none;
      text-decoration: none;
      max-width: 100% !important;
    }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      color: #1E293B;
      background-color: #FFFFFF;
    }

    /* Desktop typography */
    @media only screen and (min-width: 611px) {
      .desktop-nowrap {
        white-space: nowrap !important;
        word-break: keep-all !important;
      }
    }

    /* Mobile responsive typography and layout */
    @media only screen and (max-width: 610px) {
      .wrapper-table {
        width: 100% !important;
        max-width: 100% !important;
      }
      .content-padding {
        padding-left: 14px !important;
        padding-right: 14px !important;
        padding-top: 10px !important;
        padding-bottom: 12px !important;
      }
      .headline-text {
        font-size: 21px !important;
        line-height: 26px !important;
      }
      .subheadline-text {
        font-size: 12.5px !important;
        line-height: 17px !important;
        white-space: normal !important;
      }
      .year-badge {
        font-size: 11.5px !important;
        padding: 1px 5px !important;
      }
      .theme-box-padding {
        padding: 12px 14px !important;
      }
      .theme-title {
        font-size: 16px !important;
        line-height: 21px !important;
      }
      .cta-btn {
        width: 100% !important;
        max-width: 260px !important;
        box-sizing: border-box !important;
        line-height: 42px !important;
        font-size: 13.5px !important;
      }
      .pillar-col {
        display: block !important;
        width: 100% !important;
        box-sizing: border-box !important;
        padding-left: 0 !important;
        padding-right: 0 !important;
      }
      .footer-col {
        padding: 4px 2px !important;
      }
      .footer-logo-ieee {
        width: 85px !important;
        max-width: 85px !important;
      }
      .footer-logo-srm {
        width: 100px !important;
        max-width: 100px !important;
      }
      .footer-logo-cs {
        width: 90px !important;
        max-width: 90px !important;
      }
      .footer-text {
        font-size: 10px !important;
        line-height: 14px !important;
      }
    }

    /* ============================================================ */
    /* DARK MODE STYLES & IMAGE SWAPPING                            */
    /* ============================================================ */
    @media (prefers-color-scheme: dark) {
      /* Hide light assets, reveal dark assets */
      .light-img {
        display: none !important;
      }
      .dark-img-wrap {
        display: block !important;
        max-height: none !important;
        overflow: visible !important;
      }
      .dark-img {
        display: block !important;
        max-height: none !important;
        overflow: visible !important;
      }

      /* Background & Container Dark Palette */
      html, body, .email-bg {
        background-color: #0B0F17 !important;
        color: #E2E8F0 !important;
      }
      .wrapper-table {
        background-color: #0F172A !important;
      }
      .header-cell {
        background-color: #0B0F17 !important;
      }
      .dark-headline {
        color: #FFFFFF !important;
      }
      .dark-subheadline {
        color: #CBD5E1 !important;
      }
      .dark-salutation {
        color: #FFFFFF !important;
      }
      .dark-text {
        color: #CBD5E1 !important;
      }
      .dark-lead {
        color: #E2E8F0 !important;
      }
      
      /* Theme Card (Dark Mode) */
      .theme-card {
        background-color: #1E293B !important;
        border-color: #334155 !important;
        border-left-color: #00A3E0 !important;
      }
      .theme-label {
        color: #38BDF8 !important;
      }
      .theme-title {
        color: #FFFFFF !important;
      }
      .theme-desc {
        color: #94A3B8 !important;
      }
      .card-divider {
        border-top-color: #334155 !important;
      }
      .event-detail-text {
        color: #F1F5F9 !important;
      }

      /* Pillars Card (Dark Mode) */
      .pillars-card {
        background-color: #1E293B !important;
        border-color: #334155 !important;
      }
      .pillars-label {
        color: #38BDF8 !important;
      }
      .pillar-bullet {
        color: #38BDF8 !important;
      }
      .pillar-name {
        color: #F1F5F9 !important;
      }

      /* Luminaries Card (Dark Mode) */
      .luminaries-card {
        background-color: #1E293B !important;
        border-color: #475569 !important;
        color: #CBD5E1 !important;
      }
      .luminaries-title {
        color: #FFFFFF !important;
      }

      /* CTA Subtext & Dividers */
      .cta-note {
        color: #94A3B8 !important;
      }
      .section-divider {
        border-top-color: #334155 !important;
      }

      /* Footer (Dark Mode) */
      .footer-cell {
        background-color: #0B0F17 !important;
        border-top-color: #1E293B !important;
      }
      .footer-text {
        color: #94A3B8 !important;
      }
      .dark-link {
        color: #38BDF8 !important;
      }
    }

    /* Outlook Desktop/App Dark Mode Selectors */
    [data-ogsc] .light-img, [data-ogsb] .light-img {
      display: none !important;
    }
    [data-ogsc] .dark-img-wrap, [data-ogsb] .dark-img-wrap {
      display: block !important;
      max-height: none !important;
      overflow: visible !important;
    }
    [data-ogsc] .dark-img, [data-ogsb] .dark-img {
      display: block !important;
      max-height: none !important;
      overflow: visible !important;
    }
    [data-ogsc] html, [data-ogsc] body, [data-ogsb] body,
    [data-ogsc] .email-bg, [data-ogsb] .email-bg {
      background-color: #0B0F17 !important;
      color: #E2E8F0 !important;
    }
    [data-ogsc] .wrapper-table, [data-ogsb] .wrapper-table {
      background-color: #0F172A !important;
    }
    [data-ogsc] .dark-headline, [data-ogsb] .dark-headline {
      color: #FFFFFF !important;
    }
    [data-ogsc] .dark-subheadline, [data-ogsb] .dark-subheadline {
      color: #CBD5E1 !important;
    }
    [data-ogsc] .dark-text, [data-ogsb] .dark-text {
      color: #CBD5E1 !important;
    }
    [data-ogsc] .theme-card, [data-ogsb] .theme-card {
      background-color: #1E293B !important;
      border-color: #334155 !important;
      border-left-color: #00A3E0 !important;
    }
    [data-ogsc] .theme-label, [data-ogsb] .theme-label {
      color: #38BDF8 !important;
    }
    [data-ogsc] .theme-title, [data-ogsb] .theme-title {
      color: #FFFFFF !important;
    }
    [data-ogsc] .event-detail-text, [data-ogsb] .event-detail-text {
      color: #F1F5F9 !important;
    }
    [data-ogsc] .pillars-card, [data-ogsb] .pillars-card {
      background-color: #1E293B !important;
      border-color: #334155 !important;
    }
    [data-ogsc] .luminaries-card, [data-ogsb] .luminaries-card {
      background-color: #1E293B !important;
      border-color: #475569 !important;
      color: #CBD5E1 !important;
    }
    [data-ogsc] .footer-cell, [data-ogsb] .footer-cell {
      background-color: #0B0F17 !important;
      border-top-color: #1E293B !important;
    }
    [data-ogsc] .footer-text, [data-ogsb] .footer-text {
      color: #94A3B8 !important;
    }
    [data-ogsc] .dark-link, [data-ogsb] .dark-link {
      color: #38BDF8 !important;
    }

    /* Print styling: Strictly single page A4 fit without overflow */
    @media print {
      @page {
        size: A4 portrait;
        margin: 4mm 4mm;
      }
      html, body {
        width: 100% !important;
        height: auto !important;
        background-color: #FFFFFF !important;
        color: #1E293B !important;
      }
      .wrapper-table {
        max-width: 100% !important;
        width: 100% !important;
        page-break-inside: avoid !important;
        page-break-after: avoid !important;
        background-color: #FFFFFF !important;
      }
      .light-img {
        display: block !important;
      }
      .dark-img-wrap, .dark-img {
        display: none !important;
      }
    }
  </style>
</head>
<body class="email-bg" style="margin: 0; padding: 0; background-color: #FFFFFF; color: #1E293B;"><!--sc-meta:eyJ2IjoxLCJncmVldGluZyI6eyJ0YWciOiJwIiwic3R5bGUiOiJtYXJnaW46IDAgMCAxMHB4IDA7IGZvbnQtc2l6ZTogMTQuNXB4OyBsaW5lLWhlaWdodDogMS41OyBjb2xvcjogIzBGMTcyQTsiLCJib2xkTmFtZSI6dHJ1ZSwiY2xhc3NOYW1lIjoiZGFyay1zYWx1dGF0aW9uIiwiZmFsbGJhY2tIdG1sIjoiRGVhciA8c3Ryb25nPkVzdGVlbWVkIERlbGVnYXRlPC9zdHJvbmc+LCJ9LCJwYXJhZ3JhcGhTdHlsZSI6Im1hcmdpbjogMCAwIDEycHggMDsgZm9udC1zaXplOiAxMy41cHg7IGxpbmUtaGVpZ2h0OiAxLjU1OyBjb2xvcjogIzMzNDE1NTsiLCJwYXJhZ3JhcGhDbGFzcyI6ImRhcmstdGV4dCIsImN0YUh0bWwiOiI8dGFibGUgYm9yZGVyPVwiMFwiIGNlbGxwYWRkaW5nPVwiMFwiIGNlbGxzcGFjaW5nPVwiMFwiIHdpZHRoPVwiMTAwJVwiIHN0eWxlPVwibWFyZ2luOiAxMXB4IDAgOHB4IDA7XCI+XG4gICAgICAgICAgICAgICAgPHRib2R5Pjx0cj5cbiAgICAgICAgICAgICAgICAgIDx0ZCBhbGlnbj1cImNlbnRlclwiPlxuICAgICAgICAgICAgICAgICAgICA8IS0tW2lmIG1zb10+XG4gICAgICAgICAgICAgICAgICAgIDx2OnJvdW5kcmVjdCB4bWxuczp2PVwidXJuOnNjaGVtYXMtbWljcm9zb2Z0LWNvbTp2bWxcIiB4bWxuczp3PVwidXJuOnNjaGVtYXMtbWljcm9zb2Z0LWNvbTpvZmZpY2U6d29yZFwiIGhyZWY9XCJ7e3NjX3VybH19XCIgc3R5bGU9XCJoZWlnaHQ6NDBweDt2LXRleHQtYW5jaG9yOm1pZGRsZTt3aWR0aDoyMzVweDtcIiBhcmNzaXplPVwiMTIlXCIgc3Ryb2tlPVwiZlwiIGZpbGxjb2xvcj1cIiMwMDYyOUJcIj5cbiAgICAgICAgICAgICAgICAgICAgPHc6YW5jaG9ybG9jay8+XG4gICAgICAgICAgICAgICAgICAgIDxjZW50ZXIgc3R5bGU9XCJjb2xvcjojZmZmZmZmO2ZvbnQtZmFtaWx5OnNhbnMtc2VyaWY7Zm9udC1zaXplOjEzLjVweDtmb250LXdlaWdodDpib2xkO1wiPnt7c2NfbGFiZWx9fTwvY2VudGVyPlxuICAgICAgICAgICAgICAgICAgICA8L3Y6cm91bmRyZWN0PlxuICAgICAgICAgICAgICAgICAgICA8IVtlbmRpZl0tLT5cbiAgICAgICAgICAgICAgICAgICAgPCEtLVtpZiAhbXNvXT48IS0tIC0tPlxuICAgICAgICAgICAgICAgICAgICA8YSBocmVmPVwie3tzY191cmx9fVwiIHRhcmdldD1cIl9ibGFua1wiIGNsYXNzPVwiY3RhLWJ0blwiIHN0eWxlPVwiYmFja2dyb3VuZC1jb2xvcjogIzAwNjI5QjsgY29sb3I6ICNGRkZGRkY7IGRpc3BsYXk6IGlubGluZS1ibG9jazsgZm9udC1mYW1pbHk6IC1hcHBsZS1zeXN0ZW0sIEJsaW5rTWFjU3lzdGVtRm9udCwgJ1NlZ29lIFVJJywgUm9ib3RvLCBIZWx2ZXRpY2EsIEFyaWFsLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEzLjVweDsgZm9udC13ZWlnaHQ6IDcwMDsgbGluZS1oZWlnaHQ6IDQwcHg7IHRleHQtYWxpZ246IGNlbnRlcjsgdGV4dC1kZWNvcmF0aW9uOiBub25lOyB3aWR0aDogMjM1cHg7IC13ZWJraXQtdGV4dC1zaXplLWFkanVzdDogbm9uZTsgYm9yZGVyLXJhZGl1czogNnB4OyBib3gtc2hhZG93OiAwIDNweCA4cHggcmdiYSgwLCA5OCwgMTU1LCAwLjI1KTtcIj57e3NjX2xhYmVsfX08L2E+XG4gICAgICAgICAgICAgICAgICAgIDwhLS08IVtlbmRpZl0tLT5cbiAgICAgICAgICAgICAgICAgIDwvdGQ+XG4gICAgICAgICAgICAgICAgPC90cj5cbiAgICAgICAgICAgICAgICA8dHI+XG4gICAgICAgICAgICAgICAgICA8dGQgYWxpZ249XCJjZW50ZXJcIiBjbGFzcz1cImN0YS1ub3RlXCIgc3R5bGU9XCJwYWRkaW5nLXRvcDogM3B4OyBmb250LXNpemU6IDExcHg7IGNvbG9yOiAjNjQ3NDhCO1wiPlxuICAgICAgICAgICAgICAgICAgICBTdWJzaWRpc2VkIHBhc3NlcyBhdmFpbGFibGUgZm9yIHZlcmlmaWVkIElFRUUgJmFtcDsgSUVFRSBDb21wdXRlciBTb2NpZXR5IG1lbWJlcnMuXG4gICAgICAgICAgICAgICAgICA8L3RkPlxuICAgICAgICAgICAgICAgIDwvdHI+XG4gICAgICAgICAgICAgIDwvdGJvZHk+PC90YWJsZT4iLCJzaWduT2ZmU3R5bGUiOiJtYXJnaW46IDAgMCAxMHB4IDA7IiwidGFnbGluZSI6eyJ0ZXh0IjoiV2UncmUgRGVsaWdodGVkIHRvIEludml0ZSBZb3UiLCJodG1sIjoiV2UncmUgRGVsaWdodGVkIHRvIEludml0ZSBZb3UifSwiZGF0ZXMiOnsidGV4dCI6IkZvciBBbGwgSW5kaWEgQ29tcHV0ZXIgU29jaWV0eSBTdHVkZW50ICYgWW91bmcgUHJvZmVzc2lvbmFsIENvbmdyZXNzIDIwMjYiLCJodG1sIjoiRm9yIEFsbCBJbmRpYSBDb21wdXRlciBTb2NpZXR5IFN0dWRlbnQgJmFtcDsgWW91bmcgUHJvZmVzc2lvbmFsIENvbmdyZXNzJm5ic3A7PHNwYW4gY2xhc3M9XCJ5ZWFyLWJhZGdlXCIgc3R5bGU9XCJkaXNwbGF5OiBpbmxpbmUtYmxvY2s7IGJhY2tncm91bmQtY29sb3I6ICNGRUYwOEE7IGNvbG9yOiAjODU0RDBFOyBmb250LXdlaWdodDogNzAwOyBwYWRkaW5nOiAycHggN3B4OyBib3JkZXItcmFkaXVzOiA0cHg7IGZvbnQtc2l6ZTogMTNweDsgdmVydGljYWwtYWxpZ246IG1pZGRsZTtcIj4yMDI2PC9zcGFuPiJ9fQ==-->
  
  <!-- Outer Full Width Wrapper Table -->
  <table border="0" cellpadding="0" cellspacing="0" width="100%" class="email-bg" style="background-color: #FFFFFF; table-layout: fixed; width: 100%;">
    <tbody><tr>
      <td align="center" style="padding: 0; margin: 0;">
        
        <!-- Main Email Container (610px width, calibrated for A4 and mobile) -->
        <!--[if (gte mso 9)|(IE)]>
        <table align="center" border="0" cellspacing="0" cellpadding="0" width="610">
        <tr>
        <td align="center" valign="top" width="610">
        <![endif]-->
        <table border="0" cellpadding="0" cellspacing="0" width="100%" class="wrapper-table" style="max-width: 610px; width: 100%; background-color: #FFFFFF; margin: 0 auto; table-layout: fixed;">
          
          <!-- ============================================================= -->
          <!-- 1. ADAPTIVE HEADER (Light & Dark Mode)                         -->
          <!-- ============================================================= -->
          <tbody><tr>
            <td align="center" class="header-cell" style="padding: 0; line-height: 0; font-size: 0; background-color: #FFFFFF;">
              <a href="https://aicssyc-alpha.vercel.app/" target="_blank" style="text-decoration: none; display: block;">
                <!-- Light Header Graphic -->
                <img src="https://sponsorconnect.vercel.app/email/aicssyc-2026/exact_header_master.png" width="610" alt="AICSSYC 2026 Header" class="light-img" style="display: block; width: 100%; max-width: 610px; height: auto; border: 0; outline: none;">
                
                <!-- Dark Header Graphic -->
                <!--[if !mso]><!-->
                <div class="dark-img-wrap" style="display: none; max-height: 0px; overflow: hidden; mso-hide: all;">
                  <img src="https://sponsorconnect.vercel.app/email/aicssyc-2026/exact_header_master_white.png" width="610" alt="AICSSYC 2026 Header" class="dark-img" style="display: none; width: 100%; max-width: 610px; height: auto; border: 0; outline: none;">
                </div>
                <!--<![endif]-->
              </a>
            </td>
          </tr>

          <!-- ============================================================= -->
          <!-- 2. HEADLINE & SUBTITLE (Single-line on desktop, fluid on mobile) -->
          <!-- ============================================================= -->
          <tr>
            <td align="center" style="padding: 16px 14px 8px 14px; text-align: center;">
              <h1 class="headline-text dark-headline" style="margin: 0 0 5px 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; font-size: 24px; line-height: 1.25; font-weight: 800; color: #000000; letter-spacing: -0.3px;"><!--sc:tagline--></h1>
              <p class="subheadline-text dark-subheadline desktop-nowrap" style="margin: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; font-size: 13.5px; line-height: 1.45; font-weight: 500; color: #222222; text-align: center;"><!--sc:dates--></p>
            </td>
          </tr>

          <!-- ============================================================= -->
          <!-- 3. INVITATION BODY (Generous, prestigious content)            -->
          <!-- ============================================================= -->
          <tr>
            <td class="content-padding" style="padding: 8px 24px 14px 24px; font-size: 13.5px; line-height: 1.55; color: #334155;">
              
              <!-- Salutation -->
              <!--sc:greeting-->

              <!-- Opening Paragraph -->
              <!--sc:body-->

              <!-- Official Congress Theme Card -->
              

              <!-- Core Congress Pillars Grid -->
              

              <!-- Featured Luminaries Box -->
              

              <!-- Call To Action (Bulletproof Button) -->
              <!--sc:cta-->

              <!-- Closing and Valediction -->
              <table border="0" cellpadding="0" cellspacing="0" width="100%" class="section-divider" style="margin-top: 8px; border-top: 1px solid #F1F5F9; padding-top: 8px;">
                <tbody><tr>
                  <td class="dark-text" style="font-size: 12.5px; line-height: 18px; color: #334155;"><!--sc:signoff--></td>
                </tr>
              </tbody></table>

            </td>
          </tr>

          <!-- ============================================================= -->
          <!-- 4. ADAPTIVE FOOTER (IEEE, SRM IST, IEEE CS)                    -->
          <!-- ============================================================= -->
          <tr>
            <td align="center" class="footer-cell" style="padding: 12px 14px 18px 14px; background-color: #FFFFFF; border-top: 1px solid #F1F5F9;">
              <table border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;">
                <tbody><tr>
                  <!-- Left: IEEE Logo (Black in Light, White in Dark) -->
                  <td class="footer-col" width="33%" align="center" valign="middle" style="padding: 4px;">
                    <!-- Light Logo -->
                    <img src="https://sponsorconnect.vercel.app/email/aicssyc-2026/ieee_logo_web.png" width="110" alt="IEEE" class="footer-logo-ieee light-img" style="display: block; width: 110px; max-width: 110px; height: auto; margin: 0 auto; border: 0;">
                    <!-- Dark Logo -->
                    <!--[if !mso]><!-->
                    <div class="dark-img-wrap" style="display: none; max-height: 0px; overflow: hidden; mso-hide: all;">
                      <img src="https://sponsorconnect.vercel.app/email/aicssyc-2026/ieee_logo_web_white.png" width="110" alt="IEEE" class="footer-logo-ieee dark-img" style="display: none; width: 110px; max-width: 110px; height: auto; margin: 0 auto; border: 0;">
                    </div>
                    <!--<![endif]-->
                  </td>

                  <!-- Center: SRM Institute of Science & Technology Logo (Adaptive) -->
                  <td class="footer-col" width="34%" align="center" valign="middle" style="padding: 4px;">
                    <!-- Light Logo -->
                    <img src="https://sponsorconnect.vercel.app/email/aicssyc-2026/srm_logo_web.png" width="130" alt="SRM Institute of Science &amp; Technology" class="footer-logo-srm light-img" style="display: block; width: 130px; max-width: 130px; height: auto; margin: 0 auto; border: 0;">
                    <!-- Dark Logo -->
                    <!--[if !mso]><!-->
                    <div class="dark-img-wrap" style="display: none; max-height: 0px; overflow: hidden; mso-hide: all;">
                      <img src="https://sponsorconnect.vercel.app/email/aicssyc-2026/srm_logo_web_white.png" width="130" alt="SRM Institute of Science &amp; Technology" class="footer-logo-srm dark-img" style="display: none; width: 130px; max-width: 130px; height: auto; margin: 0 auto; border: 0;">
                    </div>
                    <!--<![endif]-->
                  </td>

                  <!-- Right: IEEE Computer Society Logo (Black in Light, White in Dark) -->
                  <td class="footer-col" width="33%" align="center" valign="middle" style="padding: 4px;">
                    <!-- Light Logo -->
                    <img src="https://sponsorconnect.vercel.app/email/aicssyc-2026/ieee_cs_logo_web.png" width="120" alt="IEEE Computer Society" class="footer-logo-cs light-img" style="display: block; width: 120px; max-width: 120px; height: auto; margin: 0 auto; border: 0;">
                    <!-- Dark Logo -->
                    <!--[if !mso]><!-->
                    <div class="dark-img-wrap" style="display: none; max-height: 0px; overflow: hidden; mso-hide: all;">
                      <img src="https://sponsorconnect.vercel.app/email/aicssyc-2026/ieee_cs_logo_web_white.png" width="120" alt="IEEE Computer Society" class="footer-logo-cs dark-img" style="display: none; width: 120px; max-width: 120px; height: auto; margin: 0 auto; border: 0;">
                    </div>
                    <!--<![endif]-->
                  </td>
                </tr>
              </tbody></table>
              
              <!-- Bottom metadata text -->
              <p class="footer-text" style="margin: 8px 0 0 0; font-size: 11px; line-height: 15px; color: #64748B; text-align: center;">
                SRM Institute of Science and Technology, Kattankulathur – 603 203, Tamil Nadu, India<br>
                Official Inquiries: <a href="mailto:ieeecomputersocietysrmist@gmail.com" class="dark-link" style="color: #00629B; text-decoration: underline;">ieeecomputersocietysrmist@gmail.com</a> • <a href="https://aicssyc-alpha.vercel.app/" class="dark-link" style="color: #00629B; text-decoration: underline;" target="_blank">aicssyc.ieeecssrm.in</a>
              </p>
            </td>
          </tr>

        </tbody></table>
        <!--[if (gte mso 9)|(IE)]>
        </td>
        </tr>
        </table>
        <![endif]-->

      </td>
    </tr>
  </tbody></table>



</body></html>$tpl$
)
ON CONFLICT (key) DO NOTHING;
