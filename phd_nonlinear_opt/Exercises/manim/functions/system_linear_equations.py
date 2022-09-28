from manim import *
import numpy as np

# phi = The polar angle i.e the angle between Z_AXIS and Camera through ORIGIN in radians.
# theta = The azimuthal angle i.e the angle that spins the camera around the Z_AXIS.
# gamma = The rotation of the camera about the vector from the ORIGIN to the Camera.
# see https://www.geogebra.org/m/hqPfxIpp

class SystemOfLinearEquations(ThreeDScene):
    def construct(self):
        # initialize and add 3D axis, x1, x2, and x3
        ax = ThreeDAxes()
        self.set_camera_orientation(theta=20 * DEGREES, phi=20 * DEGREES, zoom=0.6) #phi=30 * DEGREES , theta=30 * DEGREES, 
        x_axis_text = ax.get_x_axis_label(MathTex("x"))
        y_axis_text = ax.get_y_axis_label(MathTex("y"))
        z_axis_text = ax.get_z_axis_label(MathTex("z"))
        self.add(ax, x_axis_text, y_axis_text, z_axis_text)
        self.wait()
        
        sphere = Surface(
            lambda u, theta: np.array([ # u -> angle from xy plane to the point
                1.5 * np.cos(u) * np.cos(theta), # x axis
                1.5 * np.cos(u) * np.sin(theta), # y axis
                1.5 * np.sin(u) # z axis
            ]), v_range=[0, TAU], u_range=[-PI / 2, PI / 2],
            checkerboard_colors=[RED_D, RED_E], resolution=(8, 8)
        )