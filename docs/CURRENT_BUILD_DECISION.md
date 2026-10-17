# Current build decision — Raspberry Pi 5 2GB

Decision confirmed 2026-10-17: **Raspberry Pi 5 with 2 GB RAM** is the selected compute board for the LilRobbsGirlfriend cost-optimized build. The earlier 1GB option in `docs/REV_E_1GB_PI_PLAN.md` is an archived alternative, **not** the current recommendation.

- Raspberry Pi 5 2GB quoted allowance: **$77.50**. Supplier listing: https://www.pishop.us/product/raspberry-pi-5-2gb/ (verify stock/tax/shipping at checkout).
- Preserve the revision C best-case baseline on `baseline/rev-c-best-case`. It remains unchanged.
- Continue revising hardware around Revision D lower-cost parts rather than cutting RAM.
- Original medium build component subtotal: **$732.63**.
- D1 less expensive controller and deferred extra storage: **$691.68** (retains premium motors).
- D2 candidate less expensive motors, awaiting proof: **$611.40**.
- D3 candidate less expensive motors and wheels, awaiting fit/performance proof: **$579.54**.
- These are component subtotal candidates, NOT all-in quotes. Tax, shipping, power protection, wiring, and approved mechanical hardware remain missing.
- Maintain 4-wheel zero-turn, 3 sizes of purchasable wheels, common printable body with replaceable mounting interfaces, ESP32 safety/watchdog, Pi camera and voice, one-handed lift goal, and initial PLA printing.
- Do not buy 4 cheap motors until single-motor measurements establish electrical and mechanical compatibility; do not imply that a Pi with 2GB alone can reliably run simultaneous full vision, speech and remote sentry.
