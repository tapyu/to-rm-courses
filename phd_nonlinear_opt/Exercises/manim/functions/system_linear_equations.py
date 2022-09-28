from manim import *

class SystemOfLinearEquations(ThreeDScene):
    def construct(self):
        # initialize and add 3D axis, x1, x2, and x3
        ax = ThreeDAxes()
        self.set_camera_orientation(phi=75*DEGREES, theta=-45*DEGREES, zoom=0.8)
        e1_axis_text = ax.get_x_axis_label(MathTex("e_1"))
        e2_axis_text = ax.get_y_axis_label(MathTex("e_2"))
        e3_axis_text = ax.get_z_axis_label(MathTex("e_3"))
        self.add(ax, e1_axis_text, e2_axis_text, e3_axis_text)

        