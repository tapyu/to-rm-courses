from manim import *
from numpy import array, sin

class FixedInFrameMObjectTest(ThreeDScene):
    def construct(self):
        # create enunciate
        title = Tex(r"Consider the following vectors")
        math_expression = MathTex(r"\mathbf{x}_1, \mathbf{x}_2, \mathbf{y} \in \mathbb{R}^3")
        consideration = Tex(r"Where $(e_1, e_2, e_3)$ is the tuple of the canonical vector basis in $\mathbb{R}^3$,\\ $\mathbf{y} = \theta\mathbf{x}_1+(1-\theta)\mathbf{x}_2$, for $\theta \in \mathbb{R}$, and $\mathbf{x}_1 \neq \mathbf{x}_2$.")
        VGroup(title, math_expression, consideration).arrange(DOWN)
        # play enunciate
        self.play(Write(title))
        self.wait(.2)
        self.play(Write(math_expression))
        self.wait()
        self.play(Write(consideration))
        self.wait(3)
        self.play(FadeOut(title, math_expression, consideration))
        # create and play 3D axis, x1, and x2
        ax = ThreeDAxes()
        self.origin_point = array([0,0,0])
        self.set_camera_orientation(phi=75 * DEGREES, theta=-45 * DEGREES)
        e1_axis_text = ax.get_x_axis_label(MathTex("e_1"))
        e2_axis_text = ax.get_y_axis_label(MathTex("e_2"))
        e3_axis_text = ax.get_z_axis_label(MathTex("e_3"))
        self.add(ax, e1_axis_text, e2_axis_text, e3_axis_text)
        self.play(
            Create(ax, run_time=3, lag_ratio=0.1),
            Create(e1_axis_text, run_time=3, lag_ratio=0.1),
            Create(e2_axis_text, run_time=3, lag_ratio=0.1),
            Create(e3_axis_text, run_time=3, lag_ratio=0.1)
        )
        self.wait()
        x1 = Dot3D(point=[1,1,1], radius=0.08, color=YELLOW)
        x1_text = MathTex(r"\mathbf{x}_1")
        self.add_fixed_in_frame_mobjects(x1_text)
        x1_text.next_to(x1, direction=array([0., .5, 1.]))
        self.play(
            Create(x1),
            Write(x1_text)
        )
        self.wait()
        x2 = Dot3D(point=[-1,-1,-1], radius=0.08, color=YELLOW)
        x2_text = MathTex(r"\mathbf{x}_2")
        self.add_fixed_in_frame_mobjects(x2_text)
        x2_text.next_to(x2, direction=array([0., .5, 1.]))
        self.play(
            Create(x2),
            Write(x2_text)
        )
        self.wait()
        self.play(FadeOut(x1_text, x2_text))
        self.wait()
        # create and play affine set
        # affine_set = Line3D(start=1.7*x1.get_center(), end=1.7*x2.get_center())
        affine_set = ParametricFunction(
            lambda t: array([
                1*t + (1-t)*-1,
                1*t + (1-t)*-1,
                1*t + (1-t)*-1
            ]), t_range = [-1.2, 2]
        ).set_shade_in_3d(True)
        self.play(Create(affine_set))
        self.wait(2)
        # create and play y and theta
        theta =  ValueTracker(0.3) # it is also the tracker
        y = always_redraw(lambda : Dot3D(point=theta.get_value()*x1.get_center()+(1-theta.get_value())*x2.get_center(), radius=0.08, color=BLUE))
        y_text = MathTex(r"\mathbf{y} = \theta\mathbf{x}_1+(1-\theta)\mathbf{x}_2")
        theta_text = DecimalNumber().set_value(theta.get_value())
        theta_text.add_updater(lambda x: x.set_value(theta.get_value()))
        # theta_text.rotate(PI/2, axis=RIGHT)
        theta_text.to_edge(UP + RIGHT)
        self.add_fixed_in_frame_mobjects(y_text, theta_text)
        y_text.next_to(y, direction=array([0., .5, 1.]))
        self.play(
            Create(y),
            Write(y_text),
            Write(MathTex(f"\\theta = {theta_text.get_value()}"))
        )
        self.wait()
        self.play(FadeOut(y_text))
        self.wait()
        # play y moving around
        # theta.add_updater(lambda mobject, dt: mobject.increment_value(dt))
        self.play(
            theta.animate.set_value(1)
        )
        self.wait()
        # theta.add_updater(lambda mobject, dt: mobject.increment_value(dt))
        self.wait()
        