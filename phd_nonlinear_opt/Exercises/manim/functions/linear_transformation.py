from asyncore import write
from manim import *
import numpy as np

# phi = The polar angle i.e the angle between Z_AXIS and Camera through ORIGIN in radians.
# theta = The azimuthal angle i.e the angle that spins the camera around the Z_AXIS.
# gamma = The rotation of the camera about the vector from the ORIGIN to the Camera.
# see https://www.geogebra.org/m/hqPfxIpp

class LinearTransformation(ThreeDScene):
    def construct(self):
        # enunciate
        enunciate = Tex(r"Consider the following transformation\\$\mathbf{b} = f(\mathbf{x}) = \mathbf{Ax}$").to_edge(UP)
        self.play(Write(enunciate))
        self.wait(2)
        self.play(FadeOut(enunciate))
        # initialize and add 3D axis, x1, x2, and x3
        ax = ThreeDAxes()
        self.set_camera_orientation(phi=75*DEGREES , theta=-30*DEGREES, zoom=0.8) 
        x_axis_text = ax.get_x_axis_label(MathTex("x"))
        y_axis_text = ax.get_y_axis_label(MathTex("y"))
        z_axis_text = ax.get_z_axis_label(MathTex("z"))
        self.add(ax, x_axis_text, y_axis_text, z_axis_text)
        self.wait()
        
        # initialize sphere and sets
        sphere = Surface(
            lambda u, theta: np.array([ # u -> angle from xy plane to the point
                1.5 * np.cos(u) * np.cos(theta), # x axis
                1.5 * np.cos(u) * np.sin(theta), # y axis
                1.5 * np.sin(u) # z axis
            ]), v_range=[0, TAU], u_range=[-PI / 2, PI / 2],
            checkerboard_colors=[RED_B, RED_E],
            resolution=(32, 32)) # resolution=(8, 8)
        domain_set = MathTex(r"D", r"= \left\{ \mathbf{x} \in \mathbb{R}^{3} \mid \mathbf{Ax} = \mathbf{b} \in C, \mathbf{A} \in \mathbb{R}^{3 \times 3} \right\}", font_size=30).to_corner(UR)
        domain_set[0].set_color(RED)
        codomain_set = MathTex(r"C", r" = \left\{ \mathbf{b} \in \mathbb{R}^{3} | \mathbf{b} = \mathbf{Ax},\: \forall\: \mathbf{x} \in D  \right\}", font_size=30).to_corner(UR)
        codomain_set[0].set_color(BLUE)

        # play sphere
        self.add_fixed_in_frame_mobjects(domain_set)
        self.play(Create(sphere), Write(domain_set), run_time=2)
        self.wait(2)

        # apply matrix
        A = [[1, 0.2, 0.4], [0.4, 1.2, 0.35], [0.2, 0.35, 1.3]]
        self.play(sphere.animate.apply_matrix(A).set_color([BLUE_B, BLUE_E]), ReplacementTransform(domain_set, codomain_set), run_time=2)
        # self.play(ApplyMatrix(A, sphere), run_time=2)
        self.add_fixed_in_frame_mobjects(codomain_set)

        # rotate ambient
        self.begin_ambient_camera_rotation(rate=PI/2, about="theta")
        self.wait(4)
        self.stop_ambient_camera_rotation()
        self.wait()

        # conclusion
        conclusion = Tex(r"If $D$ is convex, $C$ is also convex.").to_edge(DOWN)
        self.add_fixed_in_frame_mobjects(conclusion)
        self.play(FadeOut(codomain_set), Write(conclusion))
        self.wait(3)