"""Offline deterministic example parser; replaceable with a validated NLU adapter."""
import re

def parse(text: str) -> dict:
    phrase = text.lower().strip()
    if re.search(r"\b(stop|halt|freeze)\b", phrase):
        return {"action": "stop"}
    if "standby" in phrase:
        return {"action": "standby"}
    if "sentry" in phrase:
        return {"action": "sentry"}
    action = "follow" if "follow" in phrase else "watch" if any(w in phrase for w in ("watch", "keep an eye on")) else None
    if action:
        match = re.search(r"\b(cat|dog|me|person)\b", phrase)
        if not match:
            return {"action": "clarify", "question": "Who or what should I track?"}
        distance = 0.9 if "closely" in phrase or "close" in phrase else 3.0 if "distance" in phrase or "far" in phrase else 1.8
        return {"action": action, "target": match.group(1), "distance_m": distance}
    return {"action": "clarify", "question": "What would you like me to do?"}
