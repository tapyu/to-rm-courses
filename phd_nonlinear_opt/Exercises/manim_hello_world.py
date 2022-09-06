from ast import Add
from manim import *
from numpy import array, sin

class FixedInFrameMObjectTest(ThreeDScene):
    def construct(self):
        # initialize enunciate
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
        
        # initialize and play 3D axis, x1, and x2
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
        x1_text.next_to(x1, direction=array([0., .5, 1.]))
        self.add_fixed_in_frame_mobjects(x1_text)
        self.play(
            Create(x1),
            Write(x1_text)
        )
        self.wait()
        x2 = Dot3D(point=[-1,-1,-1], radius=0.08, color=YELLOW)
        x2_text = MathTex(r"\mathbf{x}_2")
        x2_text.next_to(x2, direction=array([0., .5, 1.]))
        self.add_fixed_in_frame_mobjects(x2_text)
        self.play(
            Create(x2),
            Write(x2_text)
        )
        self.wait()
        self.play(FadeOut(x1_text, x2_text))
        self.wait()

        # initialize and play y and theta
        theta = 0.3
        theta_text = Variable(theta, MathTex(r"\theta"))
        theta_text.to_corner(UL)
        self.add_fixed_in_frame_mobjects(theta_text, theta_text.label, theta_text.tracker, theta_text.value)
        y = Dot3D(point=theta*x1.get_center()+(1-theta)*x2.get_center(), radius=0.08, color=BLUE)
        y.add_updater(lambda x: x.move_to(theta_text.tracker.get_value()*x1.get_center()+(1-theta_text.tracker.get_value())*x2.get_center()))
        y_text = MathTex(r"\mathbf{y} = \theta\mathbf{x}_1+(1-\theta)\mathbf{x}_2")
        y_text.next_to(y, direction=LEFT)
        self.add_fixed_in_frame_mobjects(y_text)
        self.play(
            Create(y),
            Write(y_text),
            Write(theta_text)
        )
        self.wait()
        self.play(y_text.animate.to_corner(UL), theta_text.animate.shift(DOWN))
        # y_text.to_corner(UL)
        self.wait()
        # play y moving around and initialize and play the covex set
        for value in (0,1)*2:
            theta = value
            self.play(theta_text.tracker.animate.set_value(theta))
        line_segment_text = Tex(r"As you can notice, for $0 \leq \theta \leq 1$,\\$\mathbf{y}$ is between $\mathbf{x}_1$ and $\mathbf{x}_1$,\\this finite set is called line segment.")
        self.add_fixed_in_frame_mobjects(line_segment_text)
        line_segment_text.to_corner(DR)
        line_segment = Line3D(start=x1.get_center(), end=x2.get_center()).set_color(RED)
        self.play(theta_text.tracker.animate.set_value(0), Write(line_segment_text), Create(line_segment))
        for value in (1,0)*2:
            theta = value
            self.play(theta_text.tracker.animate.set_value(theta))
        self.play(FadeOut(line_segment_text, line_segment, x1, x2, y))

        # initialize and play plane
        plane = Surface(lambda x, y: (x, y, x+y),[-1,1], [-1,1])
        plane_text = Tex(r"consider the set, denoted by $C$.").to_corner(UL)
        affine_set_text = Tex(r"The infinite set for $\theta \in \mathbf{R}$\\is called \emph{affine} set.")

        self.play(Create(plane))
        self.move_camera(phi=45*DEGREES)
        start_tip_tracker = ValueTracker([1,1,2])
        end_tip_tracker = ValueTracker([-1,-1,-2])
        line_segment = Line3D(start=start_tip_tracker.get_value(), end=end_tip_tracker.get_value())
        line_segment.add_updater(lambda mobj: mobj.set_start(start_tip_tracker.get_value()))
        line_segment.add_updater(lambda mobj: mobj.set_start(end_tip_tracker.get_value()))
        self.play(Create(line_segment))
        self.wait()
        self.play(start_tip_tracker.animate.set_value([1,2,3]))
        self.play(end_tip_tracker.animate.set_value([2,2,6]))
        self.play(start_tip_tracker.animate.set_value([-6,2,-4]))
        self.wait()
        # self.add_fixed_in_frame_mobjects(affine_set_text)
        # affine_set_text.to_corner(DR)
        # self.play(theta_text.tracker.animate.set_value(1), Write(affine_set_text), FadeOut(line_segment))
        # for value in (-2,2)*2:
        #     theta = value
        #     self.play(theta_text.tracker.animate.set_value(theta))
        # self.play(FadeOut(y_text, theta_text, affine_set_text))
        # self.move_camera(phi=45*DEGREES, theta=-45*DEGREES, zoom=2)
        # theta = 0.5
        # subspace_text1 = Tex(r"When the affine set $S$ happens\\to contain the origin, it is\\also a subspace in $\mathbb{R}^3$, since")
        # subspace_text2 = Tex(r"$a\mathbf{v}+b\mathbf{w} \in S, \forall\:\:\mathbf{v}, \mathbf{w} \in S$; $a,b \in \mathbb{R}$")
        # subspace_text = VGroup(subspace_text1, subspace_text2).arrange(DOWN)
        # self.add_fixed_in_frame_mobjects(subspace_text)
        # subspace_text.to_corner(LEFT).shift(0.5*LEFT)
        # self.play(theta_text.tracker.animate.set_value(theta), Write(subspace_text))
        # self.wait()