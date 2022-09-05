from manim import *

class FixedInFrameMObjectTest(ThreeDScene):
    def construct(self):
        text3d = DecimalNumber(0, num_decimal_places=3, include_sign=True, unit=None, fill_opacity = 1)
        tracker = ValueTracker(0)
        def numbers_updater(m):
            m.set_value(tracker.get_value())
            self.add_fixed_in_frame_mobjects(m)
        text3d.add_updater(numbers_updater)
        self.add_fixed_in_frame_mobjects(text3d)
        text3d.to_corner(UL)
        axes = ThreeDAxes()
        self.set_camera_orientation(phi=75 * DEGREES, theta=-45 * DEGREES)
        self.wait()
        self.play(Create(axes))
        self.wait()
        self.play(tracker.animate.set_value(1))
        self.wait()