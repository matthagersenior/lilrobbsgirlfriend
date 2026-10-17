import unittest
from core.robot import Robot
from core.intent import parse

class RobotTests(unittest.TestCase):
    def test_stop_clears_motion(self):
        robot = Robot()
        robot.command("drive", linear=0.8, angular=-0.4)
        self.assertEqual(robot.command("stop")["linear"], 0)
        self.assertEqual(robot.status()["angular"], 0)

    def test_disconnect_stops(self):
        robot = Robot()
        robot.command("drive", linear=1)
        self.assertEqual(robot.command("controller_disconnected")["mode"], "stopped")

    def test_follow_is_not_fake_movement(self):
        robot = Robot()
        self.assertEqual(robot.command("follow", target="cat", distance_m=3)["linear"], 0)

    def test_bounds(self):
        with self.assertRaises(ValueError):
            Robot().command("drive", linear=2)
        with self.assertRaises(ValueError):
            Robot().command("follow", target="cat", distance_m=0.1)

    def test_voice(self):
        self.assertEqual(parse("Follow the cat from a distance")["distance_m"], 3)
        self.assertEqual(parse("keep an eye on the cat")["action"], "watch")
        self.assertEqual(parse("stop right now")["action"], "stop")

if __name__ == "__main__":
    unittest.main()
