// Uploaded email designs ("skins"): the uploaded HTML with its editable regions replaced by
// slot markers, e.g. <!--sc:body-->. The Composer's fields are rendered into those slots, so the
// email keeps the uploaded design. Runs in the browser (preview) and on the server (sending).
import { marked } from "marked";

export type SkinSlot = "tagline" | "dates" | "greeting" | "body" | "cta" | "signoff";

/** What each slot needs to be rendered in the original style; stored base64-encoded inside the layout. */
export type SkinMeta = {
  v: 1;
  /** Original text + HTML: while the field still equals `text`, the original HTML is kept (e.g. a highlighted "2026"). */
  tagline?: { text: string; html: string };
  dates?: { text: string; html: string };
  greeting?: {
    tag: string;
    style: string;
    boldName: boolean;
    /** The design's class (e.g. its dark-mode colour class). */
    className?: string;
    /** The original greeting's content, used when a recipient has no name (unless it was a placeholder). */
    fallbackHtml?: string;
  };
  /** Style / class of the design's body and sign-off paragraphs, applied to the rendered Markdown. */
  paragraphStyle?: string;
  paragraphClass?: string;
  signOffStyle?: string;
  signOffClass?: string;
  /** The design's button, with {{sc_url}} / {{sc_label}} placeholders (possibly several, e.g. an Outlook copy). */
  ctaHtml?: string;
};

export type SkinFields = {
  tagline: string;
  dates: string;
  recipientName?: string;
  /** Markdown */
  body: string;
  /** Markdown */
  signOff: string;
  ctaButtons: Array<{ label: string; url: string }>;
};

const META_RE = /<!--sc-meta:([A-Za-z0-9+/=]+)-->/;
const marker = (slot: SkinSlot) => `<!--sc:${slot}-->`;

export function makeSkin(html: string, meta: SkinMeta): string {
  const encoded = toBase64(JSON.stringify(meta));
  return html.replace(/<body([^>]*)>/i, `<body$1><!--sc-meta:${encoded}-->`);
}

export function isSkin(html: string | null | undefined): html is string {
  return Boolean(html && META_RE.test(html));
}

/** The slots a design actually has, so the Composer can hide fields that wouldn't show. */
export function skinSlots(layout: string): Set<SkinSlot> {
  return new Set(Array.from(layout.matchAll(/<!--sc:(\w+)-->/g), (m) => m[1] as SkinSlot));
}

export function renderSkin(layout: string, f: SkinFields): string {
  const meta = readMeta(layout);
  const keepOriginal = (value: string, original?: { text: string; html: string }) =>
    original && value.trim() === original.text ? original.html : escapeHtml(value);

  const name = f.recipientName?.trim();
  const g = meta.greeting;
  const greetingContent = !g
    ? ""
    : name
      ? `Dear ${g.boldName ? `<strong>${escapeHtml(name)}</strong>` : escapeHtml(name)},`
      : (g.fallbackHtml ?? "");
  const greeting = greetingContent
    ? `<${g!.tag} style="${escapeAttr(g!.style)}"${g!.className ? ` class="${escapeAttr(g!.className)}"` : ""}>${greetingContent}</${g!.tag}>`
    : "";

  const cta = meta.ctaHtml
    ? f.ctaButtons
        .filter((b) => b.label.trim() && b.url.trim())
        .map((b) =>
          meta.ctaHtml!
            // Functions, so a "$" in a URL or label isn't read as a replacement pattern.
            .replaceAll("{{sc_url}}", () => escapeAttr(b.url.trim()))
            .replaceAll("{{sc_label}}", () => escapeHtml(b.label.trim())),
        )
        .join("")
    : "";

  const slots: Record<SkinSlot, string> = {
    tagline: keepOriginal(f.tagline, meta.tagline),
    dates: keepOriginal(f.dates, meta.dates),
    greeting,
    body: renderMarkdown(f.body, meta.paragraphStyle, meta.paragraphClass),
    cta,
    signoff: renderMarkdown(f.signOff, meta.signOffStyle, meta.signOffClass),
  };

  return layout
    .replace(META_RE, "")
    .replace(/<!--sc:(\w+)-->/g, (m, slot: SkinSlot) => (slot in slots ? slots[slot] : m));
}

/** Markdown → HTML for a design: unlike the standard layout, inline styles in raw HTML (e.g. a styled box) are kept. */
function renderMarkdown(md: string, paragraphStyle?: string, paragraphClass?: string): string {
  if (!md.trim()) return "";
  const html = (marked.parse(md, { gfm: true, breaks: true, async: false }) as string)
    .replace(/<(script|iframe|object|embed|form)\b[\s\S]*?<\/\1>/gi, "")
    .replace(/\s+on[a-z]+\s*=\s*("[^"]*"|'[^']*'|[^\s>]+)/gi, "")
    .replace(/(href|src)\s*=\s*(["'])\s*javascript:[^"']*\2/gi, '$1="#"');
  // The class matters for designs with their own dark mode (e.g. `.dark-text { color: … !important }`).
  const attrs =
    (paragraphStyle ? ` style="${escapeAttr(paragraphStyle)}"` : "") +
    (paragraphClass ? ` class="${escapeAttr(paragraphClass)}"` : "");
  return attrs ? html.replace(/<p>/g, `<p${attrs}>`) : html;
}

function readMeta(layout: string): SkinMeta {
  const encoded = layout.match(META_RE)?.[1];
  if (!encoded) return { v: 1 };
  try {
    return JSON.parse(fromBase64(encoded)) as SkinMeta;
  } catch {
    return { v: 1 };
  }
}

function toBase64(value: string): string {
  let binary = "";
  for (const byte of new TextEncoder().encode(value)) binary += String.fromCharCode(byte);
  return btoa(binary);
}

function fromBase64(value: string): string {
  return new TextDecoder().decode(Uint8Array.from(atob(value), (c) => c.charCodeAt(0)));
}

function escapeHtml(s: string): string {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#39;");
}

function escapeAttr(s: string): string {
  return escapeHtml(s);
}
