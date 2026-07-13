# HáziPult vs. Resvano — Competitive Analysis

_Prepared 2026-07-13. Scope: `https://www.resvano.com/` vs. this repo (HáziPult)._

---

## Bottom line up front

**I could not read resvano.com's actual content from this session, so I cannot yet
give you an honest feature-by-feature "we're more advanced" verdict.** The site
returns **403 Forbidden** to every tool available here — the session's network
policy blocks the host, and independent fetch attempts (direct + a server-side
text proxy) were also refused by resvano's own server. It is not indexed by any
search engine and has no web-archive snapshot either. In short: it's locked down
and/or brand new, and its pages are invisible from here.

What I *can* do decisively, and did:

1. **Fingerprint resvano.com from its infrastructure** (DNS, hosting, email) — see below.
2. **Fully audit HáziPult** from the source in this repo — including three real bugs
   and one advertised-but-missing headline feature.
3. **Benchmark HáziPult against the known leaders** in the student/homework-organizer
   category (myHomework, MyStudyLife, School Planner), which *are* well documented.
4. **Tell you exactly what to send me** to finish the resvano-specific head-to-head
   in one pass.

If "more advanced" is judged on **infrastructure maturity**, the two look comparable —
both are small, recently-provisioned setups. If it's judged on **shipped product
depth**, I can't rank HáziPult against resvano without their page content, but I
*can* tell you HáziPult currently trails the category leaders on several concrete
features (reminders, recurring tasks, calendar view, edit-in-place). Details below.

---

## 1. What I could verify about resvano.com (infrastructure recon)

These are hard facts pulled from public DNS and network metadata — not guesses.

| Signal | Value | What it tells us |
|---|---|---|
| A record | `13.63.176.172` | Single **AWS EC2** instance, `eu-north-1` (Stockholm). Reverse DNS: `ec2-13-63-176-172.eu-north-1.compute.amazonaws.com` |
| Hosting shape | bare EC2, no CDN | **Not** behind Cloudflare/Vercel/managed hosting — a raw VM. A solo/early-stage setup, not a scaled platform. |
| `www` | CNAME → `resvano.com` | Same single box serves both. |
| Nameservers | `ns33/ns34.domaincontrol.com` | Domain registered/managed via **GoDaddy**. |
| SOA serial | `2026061000` | DNS zone last edited **~2026-06-10** — roughly one month old. Recent. |
| MX | `resvano-com.mail.protection.outlook.com` | Email runs on **Microsoft 365 (Outlook business)**. |
| TXT | `NETORGFT20781421.onmicrosoft.com` | M365 tenant provisioned through **GoDaddy's Microsoft 365 reseller** (the `NETORGFT` prefix is GoDaddy's signature). |
| SPF | `v=spf1 include:secureserver.net -all` | Sends mail only through GoDaddy servers. Locked-down, deliberate. |
| TXT | `google-site-verification=…` | Someone verified the domain in **Google Search Console / Workspace**. |
| HTTP behavior | **403 to all non-browser clients** | Actively filters bots (WAF or strict UA rules). Combined with zero indexing + no archive → very new or intentionally private. |

**Profile:** resvano.com is a **very new, small web presence** — a single EC2 box
with the classic "solo founder / small business just set this up" stack (GoDaddy
domain + GoDaddy-resold Microsoft 365 business email), DNS first meaningfully
edited about a month ago. It looks like a nascent commercial/startup site (business
email + Search Console verification suggest intent to be found and to sell), but the
product itself is not yet publicly discoverable.

**Important:** this is **not** "Resova" (`resova.com`), the established activity-booking
SaaS — different spelling, different infrastructure, unrelated company. Don't let
search engines conflate the two; they consistently "corrected" my queries to Resova.

### What remains unknown (blocked by the 403)
- What the product actually **is** (homework app? something unrelated?).
- Its **feature set, UI, pricing, target user, or tech stack** on the page.
- Whether it competes with HáziPult **at all**.

Because of that, everything below compares HáziPult against **the category** rather
than against resvano's (unseen) specifics.

---

## 2. HáziPult — honest self-audit (from the source in this repo)

### What's actually built and working
- **Clean, modern single-page web app.** Vanilla JS, no build step. Tailwind (CDN),
  Font Awesome, Google Fonts. The UI is genuinely nice — rounded "iOS-style" cards,
  indigo accent, stat tiles, hover transitions. Design punches above its weight.
- **Real cloud backend:** self-hosted **PocketBase** at `hazipult.chez-emil-ai.com`,
  so data syncs across phone/laptop/tablet.
- **Username + password auth** with persistent sessions.
- **Tasks (`assignments`):** subject, title/description, due date, priority
  (low/medium/high, color-coded badges), completed toggle, sorted by due date,
  scoped per user.
- **Photo attachment per task** — upload to PocketBase, thumbnail in the card,
  click to open full-size. (This is a genuinely nice touch many planners lack.)
- **Create and delete** tasks.
- **PWA:** installable to the home screen, offline app-shell caching via service
  worker, Apple mobile-web-app meta tags.
- **Hungarian UI**, purpose-built for one 13-year-old — focused, not bloated.

### Advertised but NOT built
- **The reward/"game-time" system ("Egyensúly rendszer" / Játékidő).** The README
  (lines 6–7) and the PWA manifest description both promise *earning game time by
  completing tasks* — a balance/reward mechanic. **There is no such code in
  `index.html`.** This is the single biggest gap between the pitch and the product,
  and it's also the most differentiating feature the concept has. Building it would
  matter more than anything else here.

### Real bugs I found in `index.html`
1. **"This week" stat is always 0.** In `updateStats()`, `weekCount` is declared but
   never incremented — the "EZEN A HÉTEN" tile can never show a real number.
2. **No way to edit a task.** `showAddModal()` always clears the form and `saveTask()`
   only *creates*. There's no edit path, even though the modal heading element
   (`modal-title-text`) was clearly set up for one. A typo in a due date means
   delete-and-recreate.
3. **`notes` and `completed_at` are dead schema.** Both exist in the PocketBase
   collection (per `NEXT-STEPS.md`) but `notes` has no field in the UI form and
   `completed_at` is never written when a task is checked off — so "completed date"
   data never gets captured.
4. **Unescaped HTML injection.** `renderTasks()` builds cards with `innerHTML` using
   raw `task.subject` / `task.title`. Low risk for a family app, but a value like
   `<img onerror=…>` would break rendering or run script. Escape user text before
   interpolating.

### Structural considerations
- **Single point of failure:** the whole app depends on a self-hosted PocketBase on
  a home server reached via tunnel. If the Mac Mini or tunnel is down, the app can't
  load data (the SW only caches the shell, not the data).
- **No self-service signup** — accounts must be created by hand in the PocketBase admin.

---

## 3. HáziPult vs. the category leaders (the honest benchmark)

Since resvano's features are unreadable, here's where HáziPult stands against the
**documented** state-of-the-art in homework/student organizers (myHomework,
MyStudyLife, School Planner, School Assistant):

| Capability | HáziPult | Category leaders |
|---|---|---|
| Cross-device cloud sync | ✅ (self-hosted PocketBase) | ✅ (vendor cloud) |
| Photo attachment on tasks | ✅ | ⚠️ Rare — **HáziPult wins here** |
| Priority + subject tagging | ✅ | ✅ |
| Clean, modern mobile UI | ✅ (strong) | ✅ |
| PWA / installable | ✅ | ✅ (native apps) |
| Reward / gamification | ❌ (promised, unbuilt) | ⚠️ Some (streaks/points) |
| Reminders / notifications | ❌ | ✅ |
| Recurring tasks | ❌ | ✅ |
| Calendar / timetable view | ❌ | ✅ |
| Edit a task in place | ❌ (bug/gap) | ✅ |
| Overdue highlighting / grouping | ❌ | ✅ |
| Class/timetable & exam tracking | ❌ | ✅ |
| Self-service signup | ❌ | ✅ |

**Where HáziPult already leads:** design polish for its size, photo attachments, and
being a focused single-child tool with data you fully own (self-hosted). **Where it
trails:** reminders, recurring tasks, a calendar view, edit-in-place, and the
gamification it already advertises.

---

## 4. So — "are we more advanced than them?"

Two honest answers depending on what you mean:

- **Infrastructure maturity:** roughly a tie. Both HáziPult (self-hosted PocketBase +
  `chez-emil-ai.com`) and resvano (single EC2 + GoDaddy/M365) are small, recently
  stood-up setups. Neither is a scaled platform.
- **Product depth:** **unknown vs. resvano specifically** — I can't see their app.
  Against the *category*, HáziPult is a polished but early tool that leads on a couple
  of nice touches (photos, ownership, design) and trails on several table-stakes
  features (reminders, recurring tasks, calendar, edit-in-place) — plus its
  headline reward feature isn't built yet.

I won't fake a winner I couldn't observe. Here's how to get the real one:

---

## 5. What I need from you to finish the resvano head-to-head

Any **one** of these unblocks a precise, feature-by-feature comparison:

1. **Fastest:** paste the resvano.com page text here, or drop in a screenshot /
   PDF of the homepage + features/pricing pages.
2. **Cleanest:** open the site yourself and tell me in a sentence what it is and its
   top 5 features — I'll do the rest.
3. **Infra route:** if you want me to fetch it directly, this session's **network
   egress policy is blocking `resvano.com`** (403 at the gateway). Add that host to
   the environment's allowlist (or run me in an environment with open egress) and
   I'll pull and analyze it live. Note resvano's server also 403s bots, so a browser
   grab may still be the surest capture.

---

## 6. Roadmap — what would make HáziPult decisively more advanced

Prioritized by impact vs. effort:

**Quick wins (hours):**
1. **Fix the "this week" stat** (compute `weekCount` against a 7-day window).
2. **Add edit-in-place** — reuse the modal, prefill fields, branch `saveTask()` on an
   editing id. (The heading element is already there for it.)
3. **Set `completed_at`** when a task is checked, and **escape user text** in
   `renderTasks()`.
4. **Add the `notes` field** to the modal — the schema already supports it.

**The differentiator (the reason this app exists):**
5. **Build the reward / "Egyensúly" game-time system** you already advertise —
   completing tasks earns game-time credit, with a visible balance. This is what would
   set HáziPult apart from *every* generic planner, resvano included.

**Table-stakes to match the category:**
6. **Reminders / due-date notifications** (Web Push via the existing service worker).
7. **Overdue highlighting + due-date grouping** (Today / This week / Later / Overdue).
8. **Recurring tasks** and a simple **calendar/week view**.

**Resilience:**
9. **Offline-tolerant data** (cache last-loaded tasks in the SW / IndexedDB so a home-server
   outage doesn't blank the app).

Ship #1–#5 and HáziPult stops being "a nice planner" and becomes a distinctive
kid-motivation tool — a much stronger position than a features checklist alone.
