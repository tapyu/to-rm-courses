from manim import *

config.format = "gif"

class FixedInFrameMObjectTest(ThreeDScene):
    def construct(self):
        axes = ThreeDAxes()
        self.set_camera_orientation(phi=75 * DEGREES, theta=-45 * DEGREES)
        self.play(Create(axes))
        self.wait()
        text3d = Variable(0.3, MathTex("x"))
        text3d.to_corner(UL)
        # def numbers_updater(m):
        #     m.set_value(theta.get_value())
        #     self.add_fixed_in_frame_mobjects(m)
        self.add_fixed_in_frame_mobjects(text3d)
        self.play(Write(text3d))
        self.wait()
        self.play(text3d.tracker.animate.set_value(1))
        self.wait()