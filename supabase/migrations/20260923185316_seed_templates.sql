-- Restores the Lead Interview template (as seeded in 20260801085418, with its banners served from this site)
-- and adds the AICSSYC delegate invitation, which uses an uploaded email design (layout_html, see src/lib/email-skin.ts).

INSERT INTO public.email_templates (key, label, description, subject, body_md, header_tagline, event_dates, sign_off, secondary_cta_label, secondary_cta_url, logo_urls, header_image_url, footer_image_url)
VALUES (
  'lead_interview',
  'Lead Interview Invitation',
  'Invite prospective leads for their domain interview panel',
  'Invitation to Lead Interviews — {{domain}} | IEEE Computer Society SRMIST',
  E'We are delighted to inform you that your application for the position of **Lead — {{domain}}** at IEEE Computer Society SRMIST has been shortlisted for the interview round.\n\n**Interview details**\n\n- **Domain:** {{domain}}\n- **Date:** 2 August 2026\n- **Time:** 8:00 PM onwards\n- **Duration:** 15 minutes per candidate\n- **Panel:** All acting heads, along with Ushnish Ghosal and Shloka Nangare\n\nPlease join the WhatsApp group below — your exact interview slot, joining link and any further updates will be shared there. Kindly join at the earliest so you do not miss any announcement.\n\nWe request you to be available a few minutes before your slot and to be prepared to speak about your interest in the **{{domain}}** domain, your relevant experience, and your ideas for the chapter.\n\nWe look forward to speaking with you.',
  'Lead Interviews 2026 — IEEE Computer Society SRMIST',
  '2 August 2026 · 8:00 PM onwards',
  E'Warm regards,\n\n**IEEE Computer Society SRMIST**\nRecruitment Panel',
  'Join WhatsApp Group',
  'https://chat.whatsapp.com/B9ns6VVTaZLEavaHhdyxT2',
  '{}',
  'https://sponsorconnect.vercel.app/__l5e/assets-v1/4985a4d4-5e57-4bf9-a3ac-c8d5b02e4815/ieee-header-banner.png',
  'https://sponsorconnect.vercel.app/__l5e/assets-v1/a575afbf-dca8-4091-bcb4-b5add537cd10/ieee-footer-banner.png'
)
ON CONFLICT (key) DO NOTHING;

-- The body asks recipients to join the WhatsApp group "below"; the Composer only shows cta_buttons, so add it as one.
UPDATE public.email_templates
SET cta_buttons = $tpl$[{"label":"Join WhatsApp Group","url":"https://chat.whatsapp.com/B9ns6VVTaZLEavaHhdyxT2","style":"filled"}]$tpl$::jsonb
WHERE key = $tpl$lead_interview$tpl$ AND cta_buttons IS NULL;

INSERT INTO public.email_templates (key, label, description, subject, body_md, header_tagline, event_dates, sign_off, cta_buttons, logo_urls, layout_html)
VALUES (
  $tpl$aicssyc_invitation$tpl$,
  $tpl$AICSSYC Invitation$tpl$,
  $tpl$Delegate invitation for AICSSYC 2026 (uploaded design)$tpl$,
  $tpl$We're Delighted to Invite You | AICSSYC 2026$tpl$,
  $tpl$On behalf of the **IEEE Computer Society SRMIST Student Branch Chapter**, we have the distinct pleasure of cordially inviting you as an honored delegate to attend **AICSSYC 2026**.

AICSSYC 2026 is India's premier congress bringing together over 300 student delegates, young professionals, distinguished researchers, and industry pioneers. Across four days, the summit will convene distinguished keynote sessions, hands-on masterclasses, the flagship *Battle of Chapters* showdown, and high-level executive panels.

<table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: #f8fafc; border-radius: 8px; border: 1px solid #e2e8f0; border-left: 4px solid #00629B; margin-bottom: 28px;"> <tbody><tr> <td style="padding: 18px 20px;"> <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%"> <tbody><tr> <td style="padding: 5px 0; font-size: 14px; color: #0f172a;"> <strong style="color: #00629B;">📅 Dates:</strong> 8th – 11th October 2026 </td> </tr> <tr> <td style="padding: 5px 0; font-size: 14px; color: #0f172a;"> <strong style="color: #00629B;">📍 Venue:</strong> Hippocrates Hall, SRMIST Kattankulathur, Chennai </td> </tr> <tr> <td style="padding: 5px 0; font-size: 14px; color: #0f172a;"> <strong style="color: #00629B;">⚡ Theme:</strong> Where Agents Meet Humans </td> </tr> </tbody></table> </td> </tr> </tbody></table>$tpl$,
  $tpl$We're Delighted to Invite You$tpl$,
  $tpl$For All India Computer Society Student & Young Professional Congress 2026$tpl$,
  $tpl$Warm regards,
**Organizing Committee, AICSSYC 2026**
IEEE Computer Society SRMIST Student Branch Chapter$tpl$,
  $tpl$[{"label":"Confirm Attendance & Passes →","url":"https://aicssyc.ieeecssrm.in","style":"filled"}]$tpl$::jsonb,
  ARRAY[]::text[],
  $tpl$<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en"><head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>We're Delighted to Invite You | AICSSYC 2026</title>
  <!--[if mso]>
  <style type="text/css">
    body, table, td, h1, h2, p, a { font-family: Arial, Helvetica, sans-serif !important; }
  </style>
  <![endif]-->
  <style type="text/css">
    body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
    img { -ms-interpolation-mode: bicubic; border: 0; outline: none; text-decoration: none; }
    body { margin: 0; padding: 0; width: 100% !important; background-color: #eef2f6; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; }
    @media screen and (max-width: 600px) {
      .email-container { width: 100% !important; max-width: 100% !important; border-radius: 0 !important; }
      .mobile-padding { padding-left: 20px !important; padding-right: 20px !important; }
      .header-logo-left { display: block !important; width: 100% !important; text-align: center !important; margin-bottom: 12px; }
      .header-logo-right { display: block !important; width: 100% !important; text-align: center !important; }
      .header-logo-right img { margin: 0 auto !important; }
      .footer-col { display: block !important; width: 100% !important; text-align: center !important; padding: 10px 0 !important; }
      .footer-col img { margin: 0 auto !important; }
    }
  </style>
</head>
<body style="margin: 0; padding: 0; background-color: #eef2f6;"><!--sc-meta:eyJ2IjoxLCJncmVldGluZyI6eyJ0YWciOiJwIiwic3R5bGUiOiJtYXJnaW46IDAgMCAxNnB4IDA7IGNvbG9yOiAjMGYxNzJhOyIsImJvbGROYW1lIjp0cnVlfSwicGFyYWdyYXBoU3R5bGUiOiJtYXJnaW46IDAgMCAxNnB4IDA7IGNvbG9yOiAjMzM0MTU1OyIsImN0YUh0bWwiOiI8dGFibGUgcm9sZT1cInByZXNlbnRhdGlvblwiIGJvcmRlcj1cIjBcIiBjZWxscGFkZGluZz1cIjBcIiBjZWxsc3BhY2luZz1cIjBcIiB3aWR0aD1cIjEwMCVcIj5cbiAgICAgICAgICAgICAgICA8dGJvZHk+PHRyPlxuICAgICAgICAgICAgICAgICAgPHRkIGFsaWduPVwiY2VudGVyXCIgc3R5bGU9XCJwYWRkaW5nOiA2cHggMCAxNnB4IDA7XCI+XG4gICAgICAgICAgICAgICAgICAgIDx0YWJsZSByb2xlPVwicHJlc2VudGF0aW9uXCIgYm9yZGVyPVwiMFwiIGNlbGxwYWRkaW5nPVwiMFwiIGNlbGxzcGFjaW5nPVwiMFwiPlxuICAgICAgICAgICAgICAgICAgICAgIDx0Ym9keT48dHI+XG4gICAgICAgICAgICAgICAgICAgICAgICA8dGQgYWxpZ249XCJjZW50ZXJcIiBiZ2NvbG9yPVwiIzAwNjI5QlwiIHN0eWxlPVwiYm9yZGVyLXJhZGl1czogNnB4OyBiYWNrZ3JvdW5kLWNvbG9yOiAjMDA2MjlCO1wiPlxuICAgICAgICAgICAgICAgICAgICAgICAgICA8YSBocmVmPVwie3tzY191cmx9fVwiIHRhcmdldD1cIl9ibGFua1wiIHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBwYWRkaW5nOiAxNHB4IDM0cHg7IGZvbnQtZmFtaWx5OiAtYXBwbGUtc3lzdGVtLCBCbGlua01hY1N5c3RlbUZvbnQsICdTZWdvZSBVSScsIFJvYm90bywgSGVsdmV0aWNhLCBBcmlhbCwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxNHB4OyBmb250LXdlaWdodDogNzAwOyBjb2xvcjogI2ZmZmZmZjsgdGV4dC1kZWNvcmF0aW9uOiBub25lOyBib3JkZXItcmFkaXVzOiA2cHg7IGxldHRlci1zcGFjaW5nOiAwLjNweDtcIj57e3NjX2xhYmVsfX08L2E+XG4gICAgICAgICAgICAgICAgICAgICAgICA8L3RkPlxuICAgICAgICAgICAgICAgICAgICAgIDwvdHI+XG4gICAgICAgICAgICAgICAgICAgIDwvdGJvZHk+PC90YWJsZT5cbiAgICAgICAgICAgICAgICAgIDwvdGQ+XG4gICAgICAgICAgICAgICAgPC90cj5cbiAgICAgICAgICAgICAgPC90Ym9keT48L3RhYmxlPiIsInNpZ25PZmZTdHlsZSI6Im1hcmdpbjogMjJweCAwIDAgMDsgY29sb3I6ICM0NzU1Njk7IGZvbnQtc2l6ZTogMTRweDsgbGluZS1oZWlnaHQ6IDIycHg7IiwidGFnbGluZSI6eyJ0ZXh0IjoiV2UncmUgRGVsaWdodGVkIHRvIEludml0ZSBZb3UiLCJodG1sIjoiV2UncmUgRGVsaWdodGVkIHRvIEludml0ZSBZb3UifSwiZGF0ZXMiOnsidGV4dCI6IkZvciBBbGwgSW5kaWEgQ29tcHV0ZXIgU29jaWV0eSBTdHVkZW50ICYgWW91bmcgUHJvZmVzc2lvbmFsIENvbmdyZXNzIDIwMjYiLCJodG1sIjoiRm9yIEFsbCBJbmRpYSBDb21wdXRlciBTb2NpZXR5IFN0dWRlbnQgJmFtcDsgWW91bmcgUHJvZmVzc2lvbmFsIENvbmdyZXNzIFxuICAgICAgICAgICAgICAgIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZC1jb2xvcjogI2ZlZjA4YTsgY29sb3I6ICM4NTRkMGU7IHBhZGRpbmc6IDJweCA4cHg7IGJvcmRlci1yYWRpdXM6IDRweDsgZm9udC13ZWlnaHQ6IDcwMDsgd2hpdGUtc3BhY2U6IG5vd3JhcDtcIj4yMDI2PC9zcGFuPiJ9fQ==-->

  <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#eef2f6">
    <tbody><tr>
      <td align="center" style="padding: 24px 10px;">

        <!-- 600px Container Card -->
        <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="600" class="email-container" style="max-width: 600px; width: 100%; background-color: #ffffff; border-radius: 10px; overflow: hidden; border: 1px solid #dbe2ea; box-shadow: 0 4px 18px rgba(0,0,0,0.06);">

          <!-- Flush Top Geometric Accent Strip -->
          <tbody><tr>
            <td style="padding: 0; line-height: 0; font-size: 0; background-color: #ffffff;">
              <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
                <tbody><tr>
                  <td width="130" valign="top" style="padding: 0; line-height: 0;">
                    <img src="https://sponsorconnect.vercel.app/email/aicssyc-accent.png" width="130" height="65" alt="" style="display: block; border: 0;">
                  </td>
                  <td valign="top" style="padding-top: 0; padding-right: 0; line-height: 0; font-size: 0;">
                    <div style="height: 12px; background-color: #00A3E0; line-height: 12px; font-size: 0;">&nbsp;</div>
                  </td>
                </tr>
              </tbody></table>
            </td>
          </tr>

          <!-- Top Logo Header: AICSSYC on Left, SRM IST on Right -->
          <tr>
            <td style="padding: 20px 36px 14px 36px;" class="mobile-padding">
              <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
                <tbody><tr>
                  <td align="left" valign="middle" class="header-logo-left">
                    <a href="https://aicssyc.ieeecssrm.in" target="_blank" style="text-decoration: none; display: inline-block;">
                      <img src="https://aicssyc.ieeecssrm.in/aicssyc%20logo%20email.png" alt="AICSSYC 2026" width="150" style="display: block; width: 150px; max-width: 100%; height: auto;">
                    </a>
                  </td>
                  <td align="right" valign="middle" class="header-logo-right">
                    <a href="https://www.srmist.edu.in" target="_blank" style="text-decoration: none; display: inline-block;">
                      <img src="https://aicssyc.ieeecssrm.in/srm%20email%20logo.png" alt="SRM Institute of Science and Technology" width="100" style="display: block; width: 100px; max-width: 100%; height: auto; margin-left: auto;">
                    </a>
                  </td>
                </tr>
              </tbody></table>
            </td>
          </tr>

          <!-- Subtle Divider -->
          <tr>
            <td style="padding: 0 36px;" class="mobile-padding">
              <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
                <tbody><tr>
                  <td style="border-top: 1px solid #eef2f6; font-size: 0; line-height: 0;">&nbsp;</td>
                </tr>
              </tbody></table>
            </td>
          </tr>

          <!-- Primary Heading -->
          <tr>
            <td align="center" style="padding: 30px 36px 14px 36px;" class="mobile-padding">
              <h1 style="margin: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; font-size: 32px; line-height: 40px; font-weight: 800; color: #000000; letter-spacing: -0.5px;"><!--sc:tagline--></h1>
              <p style="margin: 10px 0 0 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; font-size: 14px; line-height: 22px; font-weight: 600; color: #334155;"><!--sc:dates--></p>
            </td>
          </tr>

          <!-- Letter Body -->
          <tr>
            <td style="padding: 14px 36px 24px 36px; color: #1e293b; font-size: 15px; line-height: 26px;" class="mobile-padding">
              <!--sc:greeting-->
              <!--sc:body-->
              

              <!-- Event Details Snapshot Box -->
              

              <!-- Call to Action Button -->
              <!--sc:cta-->

              <!--sc:signoff-->
            </td>
          </tr>

          <!-- Primary Footer Logos Row (IEEE | SRM | IEEE CS) -->
          <tr>
            <td style="padding: 24px 36px; border-top: 1px solid #e2e8f0; background-color: #ffffff;" class="mobile-padding">
              <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
                <tbody><tr>
                  <td align="left" valign="middle" width="33%" class="footer-col">
                    <a href="https://www.ieee.org" target="_blank" style="text-decoration: none;">
                      <img src="https://aicssyc.ieeecssrm.in/ieee%20logo%20email.png" alt="IEEE" width="90" style="display: block; width: 90px; max-width: 100%; height: auto;">
                    </a>
                  </td>
                  <td align="center" valign="middle" width="34%" class="footer-col">
                    <a href="https://www.srmist.edu.in" target="_blank" style="text-decoration: none;">
                      <img src="https://aicssyc.ieeecssrm.in/srm%20email%20logo.png" alt="SRM Institute of Science and Technology" width="85" style="display: block; width: 85px; max-width: 100%; height: auto; margin: 0 auto;">
                    </a>
                  </td>
                  <td align="right" valign="middle" width="33%" class="footer-col">
                    <a href="https://www.computer.org" target="_blank" style="text-decoration: none;">
                      <img src="https://aicssyc.ieeecssrm.in/ieecs%20logo%20email.png" alt="IEEE Computer Society" width="115" style="display: block; width: 115px; max-width: 100%; height: auto; margin-left: auto;">
                    </a>
                  </td>
                </tr>
              </tbody></table>
            </td>
          </tr>

          <!-- Clean Contained Legal Footer -->
          <tr>
            <td bgcolor="#f8fafc" align="center" style="padding: 22px 24px; color: #64748b; font-size: 11px; line-height: 18px; border-top: 1px solid #edf2f7;">
              <p style="margin: 0 0 6px 0;">
                © 2026 IEEE Computer Society SRMIST Student Branch Chapter. All rights reserved.
              </p>
              <p style="margin: 0;">
                SRM Nagar, Kattankulathur, Chengalpattu District, Tamil Nadu 603203<br>
                <a href="mailto:support@aicssyc.ieeecssrm.in" style="color: #00629B; text-decoration: none;">support@aicssyc.ieeecssrm.in</a> • 
                <a href="https://aicssyc.ieeecssrm.in" style="color: #00629B; text-decoration: none;">aicssyc.ieeecssrm.in</a>
              </p>
            </td>
          </tr>

        </tbody></table>

      </td>
    </tr>
  </tbody></table>


</body></html>$tpl$
)
ON CONFLICT (key) DO NOTHING;
