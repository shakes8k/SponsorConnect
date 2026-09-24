// Turns an uploaded HTML email into the Composer's fields (subject, tagline, body, buttons, …).
// Where possible the file's own design is kept as a "skin" (see email-skin.ts) with the fields
// rendered into it; otherwise the fields go into the standard layout. Browser-only: uses DOMParser.
import { makeSkin, type SkinMeta } from "./email-skin";

export type ImportedEmail = {
  subject?: string;
  headerTagline: string;
  eventDates: string;
  /** Markdown */
  body: string;
  /** Markdown */
  signOff: string;
  ctaButtons: Array<{ label: string; url: string; style?: "filled" | "outline" }>;
  socialLinks: Array<{ platform: string; url: string }>;
  showAicssycLogo: boolean;
  headerImageUrl?: string;
  footerImageUrl?: string;
  logoUrls?: string[];
  /** The file's own design with slots for the fields; when set, it replaces the standard layout. */
  layoutHtml?: string;
  /** Human-readable notes about what was dropped or guessed. */
  notes: string[];
};

const MAX_LAYOUT_CHARS = 1_000_000;

const SOCIAL_PLATFORMS: Array<[RegExp, string]> = [
  [/linkedin\.com/i, "LinkedIn"],
  [/instagram\.com/i, "Instagram"],
  [/(twitter\.com|\/\/(www\.)?x\.com)/i, "X"],
  [/(youtube\.com|youtu\.be)/i, "YouTube"],
  [/(facebook\.com|fb\.com)/i, "Facebook"],
];

// Images the layout adds by itself (identified by file name, since the host differs per deployment).
const DEFAULT_HEADER_LOGOS = ["ieee-cs-logo.jpeg", "srm-logo.png"];
const DEFAULT_FOOTER_IMAGE = "ieee-cs-footer.png";

const GREETING = /^(dear|hi|hello|hey)\b[^\n]{0,60}[,!:]$/i;
const SIGN_OFF_START = /^(warm(est)?\s+regards|kind\s+regards|best\s+regards|best\s+wishes|regards|sincerely|yours\s+(truly|sincerely|faithfully)|thanks|thank\s+you|many\s+thanks|cheers|best)\b/i;
const BOILERPLATE = /unsubscribe|©|&copy;|all rights reserved|view (this email )?in (your )?browser/i;

const clean = (s: string | null | undefined) => (s ?? "").replace(/\s+/g, " ").trim();
/** Markdown line → plain text, for pattern checks. */
const plain = (md: string) => md.replace(/\\([\\`*_[\]])/g, "$1").replace(/[*_]+/g, "").trim();
const isHttp = (url: string | null | undefined): url is string => /^https?:\/\//i.test(url ?? "");
const fileName = (url: string) => url.split(/[?#]/)[0].split("/").pop() ?? "";

export function importEmailHtml(html: string): ImportedEmail {
  const doc = new DOMParser().parseFromString(html, "text/html");
  const subject = clean(doc.title) || undefined;
  doc.querySelectorAll("script, style, noscript, template, title, meta, link").forEach((n) => n.remove());
  // Hidden preheader text
  doc.querySelectorAll<HTMLElement>("[style]").forEach((el) => {
    if (/display\s*:\s*none|max-height\s*:\s*0|mso-hide\s*:\s*all/i.test(el.getAttribute("style") ?? "")) el.remove();
  });

  // This app's own layout puts the tagline (not the subject) in <title>.
  if (doc.querySelector(".md-body")) return { subject: undefined, ...importOwnLayout(doc) };

  const skin = importAsSkin(html);
  if (skin) return { subject, ...skin };

  const generic = importGenericEmail(doc);
  generic.notes.unshift("Couldn't keep this file's design (its structure is unusual), so the text was put into the standard layout.");
  return { subject, ...generic };
}

/** HTML produced by this app's own layout (e.g. via "Copy HTML"): every field maps back exactly. */
function importOwnLayout(doc: Document): Omit<ImportedEmail, "subject"> {
  const notes: string[] = [];
  const [bodyEl, signOffEl] = Array.from(doc.querySelectorAll<HTMLElement>(".md-body"));

  const h1 = doc.querySelector("h1");
  const datesEl = h1?.nextElementSibling?.tagName === "P" ? h1.nextElementSibling : null;

  const images = Array.from(doc.querySelectorAll<HTMLImageElement>("img"));
  const bodyStart = bodyEl ? images.filter((img) => precedes(img, bodyEl)) : [];
  const banner = bodyStart.find((img) => img.getAttribute("width") === "600");
  const headerLogos = bodyStart.filter((img) => img !== banner).map((img) => img.getAttribute("src") ?? "").filter(isHttp);
  const logosAreDefault =
    headerLogos.length === DEFAULT_HEADER_LOGOS.length && headerLogos.every((src, i) => fileName(src) === DEFAULT_HEADER_LOGOS[i]);

  const footerImg = images.find((img) => img.closest('a[href*="ieeecssrm"]') && img.getAttribute("width") === "600");
  const footerSrc = footerImg?.getAttribute("src");

  const ctaButtons = Array.from(doc.querySelectorAll<HTMLAnchorElement>('a[target="_blank"]'))
    .filter((a) => /display\s*:\s*block/i.test(a.getAttribute("style") ?? "") && clean(a.textContent))
    .map((a) => ({
      label: clean(a.textContent),
      url: a.getAttribute("href") ?? "",
      style: (/background\s*:\s*#fff(fff)?\b/i.test(a.getAttribute("style") ?? "") ? "outline" : "filled") as "filled" | "outline",
    }));

  const socialLinks = Array.from(doc.querySelectorAll<HTMLImageElement>('a > img[src*="icons8.com"]')).map((img) => ({
    platform: img.getAttribute("alt") || "Website",
    url: img.parentElement?.getAttribute("href") ?? "",
  }));

  return {
    headerTagline: clean(h1?.textContent),
    eventDates: clean(datesEl?.textContent),
    body: bodyEl ? toMarkdown(bodyEl) : "",
    signOff: signOffEl ? toMarkdown(signOffEl) : "",
    ctaButtons,
    socialLinks,
    showAicssycLogo: Boolean(doc.querySelector('img[alt="AICSSYC Logo"]')),
    headerImageUrl: isHttp(banner?.getAttribute("src")) ? banner!.getAttribute("src")! : undefined,
    footerImageUrl: isHttp(footerSrc) && fileName(footerSrc) !== DEFAULT_FOOTER_IMAGE ? footerSrc : undefined,
    logoUrls: banner || logosAreDefault || headerLogos.length === 0 ? undefined : headerLogos.slice(0, 6),
    notes,
  };
}

/** Any other email HTML: pull out the recognisable pieces, convert the rest of the text to Markdown. */
function importGenericEmail(doc: Document): Omit<ImportedEmail, "subject"> {
  const notes: string[] = [];
  const root = doc.body;

  // Social links (usually icon-only)
  const socialLinks: ImportedEmail["socialLinks"] = [];
  root.querySelectorAll<HTMLAnchorElement>("a[href]").forEach((a) => {
    const href = a.getAttribute("href") ?? "";
    const platform = SOCIAL_PLATFORMS.find(([re]) => re.test(href))?.[1];
    if (!platform || BOILERPLATE.test(clean(a.textContent))) return;
    if (!socialLinks.some((s) => s.platform === platform)) socialLinks.push({ platform, url: href });
    // Icon links go; a link written into a sentence stays in the text.
    if (clean(a.textContent).length <= 15) a.remove();
  });

  // Button-styled links
  const ctaButtons: ImportedEmail["ctaButtons"] = [];
  root.querySelectorAll<HTMLAnchorElement>("a[href]").forEach((a) => {
    const href = a.getAttribute("href") ?? "";
    const label = clean(a.textContent);
    if (!isHttp(href) || !label || !looksLikeButton(a)) return;
    ctaButtons.push({ label, url: href, style: isOutlineButton(a) ? "outline" : "filled" });
    a.remove();
  });

  // Wide images at the very top / bottom become the header / footer banners
  // ("bottom" = after the last real text; footer boilerplate like "© … Unsubscribe" doesn't count).
  const textNodes = Array.from(walkText(root)).filter(
    (t) => clean(t.textContent) && !BOILERPLATE.test(clean(t.parentElement?.closest("p, td, div")?.textContent)),
  );
  const firstText = textNodes[0];
  const lastText = textNodes.at(-1);
  const images = Array.from(root.querySelectorAll<HTMLImageElement>("img"));
  let headerImageUrl: string | undefined;
  let footerImageUrl: string | undefined;
  const logoUrls: string[] = [];
  let lightLogos = 0;
  for (const img of images) {
    const src = img.getAttribute("src");
    if (!isHttp(src)) {
      notes.push(`Skipped an image with a local or embedded path (${(src ?? "").slice(0, 40)}…).`);
      img.remove();
      continue;
    }
    const beforeText = !firstText || precedes(img, firstText);
    const afterText = lastText ? precedes(lastText, img) : false;
    if (beforeText && isWide(img) && !headerImageUrl) {
      headerImageUrl = src;
      img.remove();
    } else if (beforeText && !isWide(img)) {
      // The layout's header is dark: logos drawn for a light background would be invisible there.
      if (isLightColor(backgroundBehind(img))) lightLogos++;
      else if (logoUrls.length < 6) logoUrls.push(src);
      img.remove();
    } else if (afterText && isWide(img)) {
      footerImageUrl = src;
      img.remove();
    }
  }

  // First heading (before any paragraph text) is the tagline; a short date-like line after it is the dates.
  let headerTagline = "";
  let eventDates = "";
  const heading = root.querySelector("h1") ?? root.querySelector("h2");
  if (heading && clean(heading.textContent) && (!firstParagraphBefore(root, heading))) {
    headerTagline = clean(heading.textContent);
    const next = nextTextBlock(heading);
    if (next && clean(next.textContent).length <= 60 && looksLikeDate(clean(next.textContent))) {
      eventDates = clean(next.textContent);
      next.remove();
    }
    heading.remove();
  }

  if (lightLogos > 0) {
    notes.push(
      `Kept the layout's own header logos: the file's ${lightLogos} logo(s) are made for a light background and wouldn't show on the dark header.`,
    );
  }

  const blocks = toMarkdownBlocks(root);

  // The layout greets each recipient by name, so drop a hard-coded greeting line (usually in the first few paragraphs).
  const greetIdx = blocks.slice(0, 4).findIndex((b) => GREETING.test(plain(b.split("\n")[0])));
  if (greetIdx >= 0) {
    const lines = blocks[greetIdx].split("\n");
    notes.push(`Removed the greeting "${plain(lines[0])}" — the layout adds "Dear <name>," for each recipient.`);
    const rest = lines.slice(1).join("\n").trim();
    if (rest) blocks[greetIdx] = rest;
    else blocks.splice(greetIdx, 1);
  }

  // Everything from the last short "Regards," / "Thanks," line onwards is the sign-off (minus footer boilerplate).
  let signOffBlocks: string[] = [];
  const signIdx = findLastIndex(blocks, (b) => {
    const line = plain(b.split("\n")[0]);
    return line.length <= 40 && SIGN_OFF_START.test(line);
  });
  if (signIdx >= 0) signOffBlocks = blocks.splice(signIdx);
  const trimBoilerplate = (list: string[]) => list.filter((b) => !BOILERPLATE.test(b));

  return {
    headerTagline,
    eventDates,
    body: trimBoilerplate(blocks).join("\n\n"),
    signOff: trimBoilerplate(signOffBlocks).join("\n\n"),
    ctaButtons: ctaButtons.slice(0, 4),
    socialLinks,
    showAicssycLogo: false,
    headerImageUrl,
    footerImageUrl,
    logoUrls: logoUrls.length ? logoUrls : undefined,
    notes,
  };
}

/**
 * Keeps the file's design: finds the heading, subtitle, greeting, body, button(s) and sign-off,
 * swaps them for slot markers and returns their content as fields. Returns null when the
 * structure is too unusual to split reliably (the caller then uses the standard layout).
 */
function importAsSkin(html: string): Omit<ImportedEmail, "subject"> | null {
  const doc = new DOMParser().parseFromString(html, "text/html");
  // Drop anything active. <style>, comments (Outlook conditionals) and the hidden preheader stay.
  doc.querySelectorAll("script, noscript, iframe, object, embed, form").forEach((n) => n.remove());
  doc.querySelectorAll("*").forEach((el) => {
    for (const attr of Array.from(el.attributes)) {
      const js = /^(href|src)$/i.test(attr.name) && /^\s*javascript:/i.test(attr.value);
      if (/^on/i.test(attr.name) || js) el.removeAttribute(attr.name);
    }
  });
  const root = doc.body;
  const notes: string[] = [];

  const heading = root.querySelector<HTMLElement>("h1") ?? root.querySelector<HTMLElement>("h2");
  const subtitle = heading ? subtitleAfter(heading) : null;
  const start = subtitle ?? heading;

  // Text blocks in document order: the nearest block element around each piece of text.
  const blocks: HTMLElement[] = [];
  for (const text of walkText(root)) {
    if (!clean(text.textContent)) continue;
    const block = text.parentElement?.closest<HTMLElement>("p, li, h1, h2, h3, h4, h5, h6, td, th, div, blockquote");
    if (block && !blocks.includes(block)) blocks.push(block);
  }
  const linesOf = (el: Element) => {
    const copy = el.cloneNode(true) as Element;
    copy.querySelectorAll("br").forEach((br) => br.replaceWith("\n"));
    return (copy.textContent ?? "").split("\n").map(clean).filter(Boolean);
  };
  const firstLine = (el: Element) => linesOf(el)[0] ?? "";
  const afterStart = (el: Element) => !start || (precedes(start, el) && !start.contains(el));

  // The last block with a short "Warm regards," / "Thanks," line — it may follow a closing sentence in the same block.
  const signOff = [...blocks].reverse().find(
    (b) => afterStart(b) && linesOf(b).some((line) => line.length <= 40 && SIGN_OFF_START.test(line)),
  );
  const buttons = Array.from(root.querySelectorAll<HTMLAnchorElement>("a[href]")).filter(
    (a) =>
      isHttp(a.getAttribute("href")) &&
      clean(a.textContent) &&
      looksLikeButton(a) &&
      afterStart(a) &&
      (!signOff || precedes(a, signOff)),
  );
  // The editable region runs from after the heading/subtitle to the sign-off (or, without one, the last button).
  const end = signOff ?? buttons.at(-1);
  if (!end) return null;
  const inRegion = (el: Element) => afterStart(el) && (el === end || end.contains(el) || precedes(el, end));

  const regionBlocks = blocks.filter(
    (b) => inRegion(b) && b !== signOff && !buttons.some((a) => b.contains(a) || a.contains(b)) && !BOILERPLATE.test(clean(b.textContent)),
  );
  const greeting = regionBlocks.find((b, i) => i < 3 && GREETING.test(firstLine(b)));
  const bodyBlocks = regionBlocks.filter((b) => b !== greeting && !greeting?.contains(b));
  if (bodyBlocks.length === 0) return null;

  const items: Element[] = [...bodyBlocks, ...buttons, ...(greeting ? [greeting] : []), ...(signOff ? [signOff] : [])];
  const container = commonAncestor(items);
  if (!container || container === root || container === doc.documentElement) return null;

  type Role = "greeting" | "body" | "cta" | "signoff";
  const kids = Array.from(container.children) as HTMLElement[];
  const rolesOf = (kid: Element) => {
    const roles = new Set<Role>();
    if (greeting && kid.contains(greeting)) roles.add("greeting");
    if (signOff && kid.contains(signOff)) roles.add("signoff");
    if (buttons.some((a) => kid.contains(a))) roles.add("cta");
    // Text next to a button (e.g. a note under it) belongs to the button block.
    else if (bodyBlocks.some((b) => kid.contains(b))) roles.add("body");
    return roles;
  };
  const roles = kids.map(rolesOf);
  if (roles.some((r) => r.size > 1)) return null; // e.g. a paragraph and the button in one cell
  const first = roles.findIndex((r) => r.size > 0);
  const last = findLastIndex(roles, (r) => r.size > 0);

  const meta: SkinMeta = { v: 1 };
  const bodyParts: string[] = [];
  let signOffMd = "";
  const placed = new Set<Role>();
  const slotFor = (kid: Element, slot: Role) => {
    const comment = doc.createComment(`sc:${slot}`);
    // Inside table structure a slot needs its own row/cell, or the rendered HTML would end up outside the table.
    const wrap = /^(TBODY|THEAD|TFOOT|TABLE)$/.test(container.tagName) ? "tr" : container.tagName === "TR" ? "td" : null;
    if (!wrap) return comment;
    const cellSource = wrap === "td" ? kid : kid.querySelector("td, th");
    const cell = doc.createElement("td");
    for (const attr of Array.from(cellSource?.attributes ?? [])) cell.setAttribute(attr.name, attr.value);
    cell.appendChild(comment);
    if (wrap === "td") return cell;
    const row = doc.createElement("tr");
    row.appendChild(cell);
    return row;
  };

  for (let i = first; i <= last; i++) {
    const kid = kids[i];
    const role: Role = roles[i].values().next().value ?? "body"; // spacers inside the region go with the body
    if (role === "greeting") {
      const text = clean(greeting!.textContent);
      meta.greeting = {
        tag: greeting!.tagName.toLowerCase(),
        style: greeting!.getAttribute("style") ?? "",
        boldName: Boolean(greeting!.querySelector("strong, b")),
        className: greeting!.getAttribute("class") ?? undefined,
        // "Dear Esteemed Delegate," is a fine fallback; "Dear [Recipient Name]," is a placeholder, not one.
        fallbackHtml: /[[\]{}<>]/.test(text) ? undefined : greeting!.innerHTML.trim(),
      };
    } else if (role === "signoff" && signOff!.tagName !== "P") {
      // A sign-off cell / div: fill it in place, so its wrapper (e.g. a divider above it) stays.
      // Its paragraphs inherit the cell's colours (and dark-mode class).
      signOffMd = toMarkdown(signOff!);
      meta.signOffStyle = "margin: 0 0 10px 0;";
      signOff!.replaceChildren(doc.createComment("sc:signoff"));
      placed.add(role);
      continue;
    } else if (role === "signoff") {
      signOffMd = toMarkdown(kid);
      meta.signOffStyle = signOff!.getAttribute("style") ?? undefined;
      meta.signOffClass = signOff!.getAttribute("class") ?? undefined;
    } else if (role === "cta" && !placed.has("cta")) {
      const template = kid.cloneNode(true) as HTMLElement;
      const button = Array.from(template.querySelectorAll<HTMLAnchorElement>("a[href]")).find((a) => looksLikeButton(a));
      if (button) {
        const href = button.getAttribute("href")!;
        button.setAttribute("href", "{{sc_url}}");
        button.textContent = "{{sc_label}}";
        // Outlook's copy of the button (VML in a conditional comment) has the link and label baked in too.
        meta.ctaHtml = template.outerHTML
          .split(href)
          .join("{{sc_url}}")
          .replace(/(<center\b[^>]*>)[\s\S]*?(<\/center>)/g, "$1{{sc_label}}$2");
      }
    } else if (role === "body") {
      bodyParts.push(...kidToMarkdown(kid));
      const paragraph = kid.tagName === "P" ? kid : kid.querySelector("p");
      if (paragraph && meta.paragraphStyle === undefined) {
        meta.paragraphStyle = paragraph.getAttribute("style") ?? undefined;
        meta.paragraphClass = paragraph.getAttribute("class") ?? undefined;
      }
    }
    if (placed.has(role)) kid.remove();
    else kid.replaceWith(slotFor(kid, role));
    placed.add(role);
  }

  // Heading / subtitle keep their element (and style); only their content becomes a slot.
  // (isConnected: skip them if they sat inside a region that was just swapped out.)
  let headerTagline = "";
  let eventDates = "";
  if (heading?.isConnected) {
    headerTagline = clean(heading.textContent);
    meta.tagline = { text: headerTagline, html: heading.innerHTML.trim() };
    heading.replaceChildren(doc.createComment("sc:tagline"));
  }
  if (subtitle?.isConnected && meta.tagline) {
    eventDates = clean(subtitle.textContent);
    meta.dates = { text: eventDates, html: subtitle.innerHTML.trim() };
    subtitle.replaceChildren(doc.createComment("sc:dates"));
  }

  if (greeting) {
    notes.push(
      meta.greeting?.fallbackHtml
        ? `The greeting is now filled in for each recipient ("Dear <name>,"); recipients without a name get "${clean(greeting.textContent)}".`
        : 'The greeting is now filled in for each recipient ("Dear <name>,") and left out when there is no name.',
    );
  }
  if (root.querySelector("svg")) {
    notes.push("This design contains an SVG graphic. Gmail doesn't display SVGs, so it will be missing there — use a PNG image instead.");
  }
  const localImages = Array.from(root.querySelectorAll("img")).filter((img) => !isHttp(img.getAttribute("src"))).length;
  if (localImages) notes.push(`${localImages} image(s) use local or embedded paths and won't show in the email.`);

  const layoutHtml = makeSkin(`<!DOCTYPE html>\n${doc.documentElement.outerHTML}`, meta);
  if (layoutHtml.length > MAX_LAYOUT_CHARS) return null;

  return {
    headerTagline,
    eventDates,
    body: bodyParts.join("\n\n"),
    signOff: signOffMd,
    ctaButtons: buttons.map((a) => ({
      label: clean(a.textContent),
      url: a.getAttribute("href")!,
      style: isOutlineButton(a) ? ("outline" as const) : ("filled" as const),
    })),
    socialLinks: [],
    showAicssycLogo: false,
    layoutHtml,
    notes,
  };
}

/** A body chunk as Markdown; a styled box (background/border) is kept as raw HTML so it keeps its look. */
function kidToMarkdown(kid: HTMLElement): string[] {
  const styled = /background|border/i.test(kid.getAttribute("style") ?? "") || kid.hasAttribute("bgcolor");
  if (styled && /^(TABLE|DIV)$/.test(kid.tagName)) return [kid.outerHTML.replace(/\s*\n\s*/g, " ").trim()];
  return toMarkdownBlocks(kid);
}

/** The short line right under the heading (e.g. "For All India … Congress 2026"), if there is one. */
function subtitleAfter(heading: Element): HTMLElement | null {
  const next = nextTextBlock(heading) as HTMLElement | null;
  if (!next || /^H[1-6]$/.test(next.tagName) || next.querySelector("a, img, table")) return null;
  const text = clean(next.textContent);
  return text.length <= 120 && (looksLikeDate(text) || !/[.!?]$/.test(text)) ? next : null;
}

function commonAncestor(nodes: Node[]): Element | null {
  let candidate: Element | null = nodes[0]?.parentElement ?? null;
  while (candidate && !nodes.every((n) => candidate!.contains(n) && candidate !== n)) candidate = candidate.parentElement;
  return candidate;
}

// ── helpers ──────────────────────────────────────────────────────────────

function precedes(a: Node, b: Node): boolean {
  return Boolean(a.compareDocumentPosition(b) & Node.DOCUMENT_POSITION_FOLLOWING);
}

function* walkText(root: Node): Generator<Text> {
  const walker = root.ownerDocument!.createTreeWalker(root, NodeFilter.SHOW_TEXT);
  for (let n = walker.nextNode(); n; n = walker.nextNode()) yield n as Text;
}

function firstParagraphBefore(root: HTMLElement, el: Element): boolean {
  const p = Array.from(root.querySelectorAll("p")).find((x) => clean(x.textContent));
  return Boolean(p && precedes(p, el));
}

function nextTextBlock(el: Element): Element | null {
  for (let n = el.nextElementSibling; n; n = n.nextElementSibling) if (clean(n.textContent)) return n;
  return null;
}

function looksLikeDate(s: string): boolean {
  return /\b(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\b|\b20\d\d\b|\d{1,2}(st|nd|rd|th)\b|\d{1,2}[/-]\d{1,2}/i.test(s);
}

function styleOf(el: Element | null): string {
  return (el?.getAttribute("style") ?? "").toLowerCase();
}

function hasFill(style: string, el: Element | null): boolean {
  const bg = style.match(/background(-color)?\s*:\s*([^;]+)/)?.[2]?.trim() ?? el?.getAttribute("bgcolor") ?? "";
  return Boolean(bg) && !/^(none|transparent|#fff(fff)?|white|rgba?\(255,\s*255,\s*255)/i.test(bg);
}

function looksLikeButton(a: HTMLAnchorElement): boolean {
  const style = styleOf(a);
  if (/\b(btn|button|cta)\b/i.test(a.className) || a.getAttribute("role") === "button") return true;
  if (hasFill(style, a) && /padding/.test(style)) return true;
  if (/border\s*:\s*[1-9]/.test(style) && /padding/.test(style) && /display\s*:\s*(inline-)?block/.test(style)) return true;
  // Classic "bulletproof" button: a filled table cell containing just this link.
  const cell = a.closest("td");
  return Boolean(cell && hasFill(styleOf(cell), cell) && clean(cell.textContent) === clean(a.textContent));
}

function isOutlineButton(a: HTMLAnchorElement): boolean {
  const style = styleOf(a);
  return !hasFill(style, a) && /border\s*:\s*[1-9]/.test(style);
}

/** The background colour an element sits on (emails default to white). */
function backgroundBehind(el: Element): string {
  for (let n = el.parentElement; n; n = n.parentElement) {
    const bg = styleOf(n).match(/background(-color)?\s*:\s*([^;]+)/)?.[2]?.trim() ?? n.getAttribute("bgcolor");
    if (bg && !/^(none|transparent|inherit|initial)\b/i.test(bg)) return bg;
  }
  return "#ffffff";
}

/** Unknown colours count as light, so we'd rather keep the layout's own logos than show invisible ones. */
function isLightColor(color: string): boolean {
  const hex = color.match(/#([0-9a-f]{6}|[0-9a-f]{3})\b/i)?.[1];
  const rgb = color.match(/rgba?\(\s*(\d+)[\s,]+(\d+)[\s,]+(\d+)/i);
  let r: number, g: number, b: number;
  if (hex) {
    const full = hex.length === 3 ? hex.replace(/./g, "$&$&") : hex;
    [r, g, b] = [0, 2, 4].map((i) => parseInt(full.slice(i, i + 2), 16));
  } else if (rgb) {
    [r, g, b] = [rgb[1], rgb[2], rgb[3]].map(Number);
  } else {
    return !/\b(black|navy|maroon|purple|green|teal)\b/i.test(color);
  }
  return (0.299 * r + 0.587 * g + 0.114 * b) / 255 > 0.6;
}

/** Width in px from the width attribute or an inline style; 0 if unknown. */
function imageWidth(img: HTMLImageElement): number {
  return Number(img.getAttribute("width")) || Number(styleOf(img).match(/(?:^|;)\s*width\s*:\s*(\d+)px/)?.[1]) || 0;
}

function isWide(img: HTMLImageElement): boolean {
  return imageWidth(img) >= 400 || /(?:^|;)\s*width\s*:\s*100%/.test(styleOf(img));
}

function findLastIndex<T>(list: T[], pred: (x: T) => boolean): number {
  for (let i = list.length - 1; i >= 0; i--) if (pred(list[i])) return i;
  return -1;
}

// ── HTML → Markdown ─────────────────────────────────────────────────────

const BLOCK_TAGS = new Set([
  "ADDRESS", "ARTICLE", "ASIDE", "BLOCKQUOTE", "BODY", "CENTER", "DIV", "FOOTER", "HEADER", "MAIN",
  "P", "SECTION", "TABLE", "TBODY", "THEAD", "TFOOT", "TR", "TD", "TH", "H1", "H2", "H3", "H4", "H5", "H6",
  "UL", "OL", "LI", "PRE", "HR",
]);

function toMarkdown(el: Element): string {
  return toMarkdownBlocks(el).join("\n\n");
}

function toMarkdownBlocks(root: Element): string[] {
  const blocks: string[] = [];
  let current = "";
  const flush = () => {
    const text = current
      .split("\n")
      .map((line) => line.replace(/[ \t]+/g, " ").trim())
      .join("\n")
      .trim();
    // A blank line (e.g. <br><br>) starts a new paragraph.
    for (const part of text.split(/\n{2,}/)) if (part.trim()) blocks.push(part.trim());
    current = "";
  };

  const walk = (node: Node) => {
    if (node.nodeType === Node.TEXT_NODE) {
      current += escapeMarkdown((node.textContent ?? "").replace(/\s+/g, " "));
      return;
    }
    if (node.nodeType !== Node.ELEMENT_NODE) return;
    const el = node as Element;
    const tag = el.tagName;

    if (tag === "BR") {
      current += "\n";
    } else if (/^H[1-6]$/.test(tag)) {
      flush();
      const text = inlineMarkdown(el).trim();
      if (text) blocks.push(`### ${text}`);
    } else if (tag === "UL" || tag === "OL") {
      flush();
      const items = Array.from(el.children)
        .filter((c) => c.tagName === "LI")
        .map((li, i) => `${tag === "OL" ? `${i + 1}.` : "-"} ${inlineMarkdown(li).replace(/\s*\n\s*/g, " ").trim()}`)
        .filter((line) => line.replace(/^(-|\d+\.)\s*/, ""));
      if (items.length) blocks.push(items.join("\n"));
    } else if (tag === "BLOCKQUOTE") {
      flush();
      const inner = toMarkdownBlocks(el).join("\n\n");
      if (inner) blocks.push(inner.split("\n").map((l) => `> ${l}`).join("\n"));
    } else if (tag === "HR") {
      flush();
    } else if (BLOCK_TAGS.has(tag)) {
      flush();
      el.childNodes.forEach(walk);
      flush();
    } else {
      current += inlineMarkdown(el);
    }
  };

  root.childNodes.forEach(walk);
  flush();
  return blocks;
}

function inlineMarkdown(node: Node): string {
  if (node.nodeType === Node.TEXT_NODE) return escapeMarkdown((node.textContent ?? "").replace(/\s+/g, " "));
  if (node.nodeType !== Node.ELEMENT_NODE) return "";
  const el = node as Element;
  const inner = () => Array.from(el.childNodes).map(inlineMarkdown).join("");

  switch (el.tagName) {
    case "BR":
      return "\n";
    case "IMG": {
      const src = el.getAttribute("src");
      if (!isHttp(src)) return "";
      // A raw <img> (the Markdown renderer lets it through) keeps the original size; ![](…) can't,
      // and a full-resolution logo would stretch the whole email.
      const width = Math.min(560, imageWidth(el as HTMLImageElement) || 200);
      const alt = (el.getAttribute("alt") ?? "").replace(/[&<>"]/g, (c) => `&#${c.charCodeAt(0)};`);
      return `<img src="${src.replace(/"/g, "%22")}" alt="${alt}" width="${width}">`;
    }
    case "A": {
      const href = el.getAttribute("href") ?? "";
      const text = inner().trim();
      // Empty once its image moved to a layout field (e.g. a linked logo) — drop it.
      if (!text || !/^(https?:|mailto:|tel:)/i.test(href)) return text;
      return `[${text}](${href})`;
    }
    case "STRONG":
    case "B":
      return wrap(inner(), "**");
    case "EM":
    case "I":
      return wrap(inner(), "*");
    default: {
      const style = styleOf(el);
      let text = inner();
      if (/font-weight\s*:\s*(bold|[6-9]00)/.test(style)) text = wrap(text, "**");
      if (/font-style\s*:\s*italic/.test(style)) text = wrap(text, "*");
      return BLOCK_TAGS.has(el.tagName) ? ` ${text} ` : text;
    }
  }
}

/** Wraps text in a Markdown marker, keeping surrounding spaces outside it (`**a**` must hug the text). */
function wrap(text: string, marker: string): string {
  const match = text.match(/^(\s*)([\s\S]*?)(\s*)$/)!;
  if (!match[2]) return text;
  // Already fully wrapped (e.g. <b><strong>x</strong></b>)
  if (match[2].startsWith(marker) && match[2].endsWith(marker)) return text;
  return `${match[1]}${marker}${match[2]}${marker}${match[3]}`;
}

function escapeMarkdown(text: string): string {
  return text.replace(/([\\`*_[\]])/g, "\\$1");
}
