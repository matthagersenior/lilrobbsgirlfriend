"""Deterministic, hardware-independent behavior core."""
from dataclasses import dataclass
from enum import Enum

class Mode(str, Enum):
    STANDBY = "standby"
    MANUAL = "manual"
    FOLLOW = "follow"
    WATCH = "watch"
    SENTRY = "sentry"
    STOPPED = "stopped"

@dataclass
class Robot:
    mode: Mode = Mode.STANDBY
    target: str | None = None
    distance_m: float = 1.8
    linear: float = 0.0
    angular: float = 0.0

    def command(self, action: str, *, target: str | None = None,
                distance_m: float | None = None, linear: float = 0,
                angular: float = 0) -> dict:
        if action in {"stop", "emergency_stop"}:
            self.mode, self.target = Mode.STOPPED, None
            self.linear = self.angular = 0
        elif action == "standby":
            self.mode, self.target = Mode.STANDBY, None
            self.linear = self.angular = 0
        elif action in {"follow", "watch"}:
            if not target:
                raise ValueError("target required")
            if distance_m is not None and not 0.5 <= distance_m <= 5.0:
                raise ValueError("distance out of bounds")
            self.mode = Mode(action)
            self.target = target
            self.distance_m = distance_m if distance_m is not None else self.distance_m
            self.linear = self.angular = 0  # tracking/navigation is NOT implemented
        elif action == "sentry":
            self.mode, self.target = Mode.SENTRY, None
            self.linear = self.angular = 0
        elif action == "drive":
            if not -1 <= linear <= 1 or not -1 <= angular <= 1:
                raise ValueError("normalized drive values required")
            self.mode, self.target = Mode.MANUAL, None
            self.linear, self.angular = linear, angular
        elif action == "controller_disconnected" or action == "target_lost":
            self.mode, self.target = Mode.STOPPED, None
            self.linear = self.angular = 0
        else:
            raise ValueError(f"unsupported action: {action}")
        return self.status()

    def status(self) -> dict:
        return {"mode": self.mode.value, "target": self.target,
                "distance_m": self.distance_m,
                "linear": self.linear, "angular": self.angular}
