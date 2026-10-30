# Lil Robb's Girlfriend — accessible companion robot project

**Status:** Revision G design and engineering research only. No robot is assembled, safety-validated or connected to a working GPT service.

**Public showcase (once GitHub Pages is enabled):** https://matthagersenior.github.io/lilrobbsgirlfriend/

## What this repository contains

- [Current design decision](docs/CURRENT_BUILD_DECISION.md)
- [Revision G mechanical design](docs/REV_G_MECHANICAL_DESIGN.md)
- [Revision G conversational architecture](docs/REV_G_CHATGPT_COMPANION_ARCHITECTURE.md)
- [Parametric Revision G OpenSCAD model](cad/robot_revG.scad)
- [Revision F assembly research](docs/REV_F_EASY_ASSEMBLY.md)

The project explores an affordable, compact, friendly rover designed for accessible one-handed use, possible phone controls, online GPT-based conversation, and modular printed mechanics. **Every operating feature is a design goal rather than an implemented claim.**

## Public website

The mobile-friendly, self-contained landing page is [index.html](index.html). It has no tracking or third-party scripts. GitHub Pages can serve it at the URL above.

To publish using the included GitHub Actions workflow: open **Settings → Pages** for this repository and select **GitHub Actions** under **Build and deployment → Source**. The workflow deploys the root `index.html` after changes to `main`, or on manual dispatch. Wait for the `Publish public project site` check to succeed before announcing the public link.

The page is a static showcase, **not** an app capable of controlling real motors or camera streams. Never expose API keys, video feeds or hardware controls on a public static site.

## Safety and engineering honesty

Revision G's approx. $456.70 figure is a priced-parts research estimate, **not** a finished-build cost. Brackets, hardware, wiring, protection and shipping are not fully priced. Before powered use, the design needs independent E-stop, watchdog, obstacle/cliff detection, electrical and mechanical validation.

## Contribution guidance

If proposing a change, reference the source design decision, retain safety boundaries, and distinguish documented plans from physically tested results.