# Revision G — ChatGPT-first companion intelligence (decision record)

**Decision date:** 2026-10-18
**Status:** Target architecture, not yet implemented or hardware verified.

## Product requirement
LilRobbsGirlfriend's natural-language conversational AI and recognizable speaking personality must be powered by an OpenAI GPT model through the OpenAI API (the ChatGPT family). Do **not** replace user-facing conversation with SmolLM, Qwen, or other local third-party LLMs simply to fit on the robot. Specialized non-conversational functions may use open models, cloud services, small deterministic classifiers, or conventional software.

"ChatGPT" in this design means a separately integrated OpenAI API model and configured companion persona. It does **not** mean running the ChatGPT consumer app on the Pi, sharing a personal ChatGPT subscription or chat history, or automatically inheriting ChatGPT Memory. API billing is separate. The user's own long-term companion memory, if implemented, requires explicit design, access controls, and consent.

## Target Rev G hardware
- Four wheels; two independently driven geared motor/wheel assemblies and two passive, low-scrub front wheel assemblies. Validate stable true in-place rotation and friction on target floors. Front wheel support geometry, driven axle position and wheel sizes are subject to physical testing.
- Raspberry Pi 5 **1GB** running Raspberry Pi OS Lite, with **32GB microSD**; no separate 128GB USB recording drive in the first version.
- Dedicated ESP32 motor controller, independent communication watchdog, bounded velocity/acceleration commands, fail-safe stop, independent physical power-cut E-stop.
- Pi camera, microphones, speaker, minimum obstacle/cliff sensing, regulated power and a smaller battery *only if measured average/peak consumption, current limiting and thermal tests support it*.
- Original four-motor Revision F / Revision C baseline remains available for future upgrades. Motor interfaces and electronics tray remain modular.
- The preliminary ~$456.70 *priced-components-only* estimate from chat is a nonbinding research target, **not** a final bill of materials: motor fit, power, brackets, omni-wheel mounts, protection, fuses, harness, fasteners, body revision, filament and shipping are still unpriced/unverified.

## AI responsibility split

**Conversation — OpenAI only (online)**
- A GPT model accessible via the OpenAI Responses API creates all normal conversational answers, personality, contextual reasoning and explanation of tool/sensor observations.
- For speech, begin with a modular cost-aware chain: local wake word / endpoint detection -> speech-to-text (on device, phone, or selected specialist service) -> GPT conversational model -> text-to-speech (on device or service). GPT remains the conversational model even if speech I/O is not from OpenAI.
- Evaluate GPT-Live or Realtime speech-to-speech later when low latency, interruptibility and natural turn-taking justify costs. A continuously open session can incur substantial charges; only start a paid session when engaging and close it promptly.
- Provide a user-visible cue when network/ChatGPT connection is unavailable. Offline fallbacks may speak short predefined operational status statements, but must not impersonate live ChatGPT conversation.

**Other cognition — interchangeable specialists**
- Lightweight local wake-word detection, audio gating and optional speech recognition.
- Vision model / image-processing service for object detection, person tracking and spatial observations. Label uncertain outputs as uncertain. Do not treat visual recognition as the sole safety sensor.
- Navigation planner with maps, localization and obstacle/cliff sensor fusion. Use validated trajectories and motion limits.
- Local cached preferences and explicitly approved summaries, with consent and retention/deletion controls. Only share necessary context with remote GPT.
- ESP32 executes only bounded, schema-validated motor control requests from local navigation/teleoperation, never raw PWM from any LLM.

## Security and cost constraints
- Never embed a permanent OpenAI API secret in the mobile app, firmware, printed QR, or device filesystem. Route GPT calls through an authenticated backend with per-device credentials and server-held API secrets, rate limits and spend caps.
- Do not send continuous camera feed or an always-on microphone stream to cloud services by default. Process locally when practical; wake/interaction triggers remote work.
- Treat external model/sensor outputs as untrusted data; validate parameters, permissions and actions. Safety-critical motion/stop logic remains deterministic, local and independent of the chat connection.
- 1GB Pi RAM is reserved for audio/camera streams and coordination, not simultaneous full on-device ASR+vision+LLM. Benchmark memory, frame rates and response latency; Pi form factor permits later board swap.
- Preserve a predictable offline control mode with functioning manual drive/stop independent of OpenAI availability.

## Implementation checklist (future work, not completed here)
1. Document target wheel, total mass, current and battery measurements; revise CAD and mechanical mounts.
2. Prototype secure cloud relay to OpenAI Responses with companion persona, conversation ID, adjustable cost caps, and separate opt-in memory store.
3. Add wake word and speech I/O chain. Measure turn-taking delay on 1GB Pi; replace components based on evidence.
4. Integrate read-only sensor observations into GPT tool/function inputs. Add bounded action request validation with opt-in confirmations and local navigation control.
5. Prove connectivity-loss behavior, manual control, watchdog and independent E-stop, then test slow indoor movement with obstacle/cliff detection.
6. Compare operating cost and latency of text GPT + separate speech vs GPT-Live/Realtime without changing the requirement that GPT is the conversational intelligence.

References:
- OpenAI text / Responses API: https://developers.openai.com/api/docs/guides/text
- OpenAI audio workflow: https://developers.openai.com/api/docs/guides/audio
- OpenAI API pricing: https://developers.openai.com/api/docs/pricing
