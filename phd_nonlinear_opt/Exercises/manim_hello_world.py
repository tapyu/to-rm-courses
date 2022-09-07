from ast import Add
from gzip import WRITE
from manim import *
from numpy import array, sin

class SegmentLine(ThreeDScene):
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
        self.wait()
        # play y moving around and initialize and play the covex set
        self.begin_ambient_camera_rotation(rate=PI/10, about="theta")
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
        self.stop_ambient_camera_rotation()
        self.play(FadeOut(line_segment_text, line_segment, x1, x2, y))
        self.move_camera(phi=45*DEGREES, theta=-45*DEGREES)

class Convex(ThreeDScene):
    def construct(self):
        # initialize and add 3D axis, x1, and x2
        ax = ThreeDAxes()
        self.set_camera_orientation(phi=75*DEGREES, theta=-45*DEGREES, zoom=0.8)
        e1_axis_text = ax.get_x_axis_label(MathTex("e_1"))
        e2_axis_text = ax.get_y_axis_label(MathTex("e_2"))
        e3_axis_text = ax.get_z_axis_label(MathTex("e_3"))
        self.add(ax, e1_axis_text, e2_axis_text, e3_axis_text)
        
        # initialize and play plane
        convex_set = Surface(lambda x, y: (x, y, x+y),[-10,10], [-10,10])
        convex_set_text = Tex(r"consider the following set, denoted by $C$.").to_corner(UL)
        self.add_fixed_in_frame_mobjects(convex_set_text)
        self.play(Create(convex_set), Write(convex_set_text))

        # move line segment around on the plane
        x1 = Dot3D(point=[1,1,2], radius=0.08, color=YELLOW)
        x2 = Dot3D(point=[-1,-1,-2], radius=0.08, color=YELLOW)
        # line_segment = always_redraw(lambda : Line3D(start=x1.get_center(), end=x2.get_center()))
        line_segment = Line3D(start=x1.get_center(), end=x2.get_center())
        line_segment = line_segment.add_updater(lambda mob: mob.become(Line3D(start=x1.get_center(), end=x2.get_center())))
        self.play(Create(line_segment), FadeOut(convex_set_text))
        self.wait()
        self.play(x1.animate.move_to([1,2,3]))
        self.play(x2.animate.move_to([2,2,6]))
        self.play(x2.animate.move_to([0.3,0.5,0.8]))
        self.play(x2.animate.move_to([0,1.3,1.3]))
        self.play(x1.animate.move_to([-3,1,-2]))
        self.wait()
        # say what is convex set
        convex_conclusion_text = Tex(r"The line segment between $\mathbf{x}_1,\mathbf{x}_2 \in C$, i.e.,\\ $\{\mathbf{y} \in \mathbb{R}^3 \mid \mathbf{y} = \theta \mathbf{x}_1+(1-\theta) \mathbf{x}_2, 0\leq \theta \leq 1 \}$, also belongs to $C$.\\When this happen, we say that $C$ is a \emph{Convex set}").to_edge(DOWN)
        self.add_fixed_in_frame_mobjects(convex_conclusion_text)
        self.play(Write(convex_conclusion_text), FadeOut(ax, convex_set, line_segment, x1, x2, e1_axis_text, e2_axis_text, e3_axis_text))
        self.wait(3)
    
class Affine():
    def construct(self):
        # initialize and add 3D axis, x1, and x2
        ax = ThreeDAxes()
        self.set_camera_orientation(phi=75*DEGREES, theta=-45*DEGREES, zoom=0.8)
        e1_axis_text = ax.get_x_axis_label(MathTex("e_1"))
        e2_axis_text = ax.get_y_axis_label(MathTex("e_2"))
        e3_axis_text = ax.get_z_axis_label(MathTex("e_3"))
        self.add(ax, e1_axis_text)
        # say what is affine set
        affine_conclusion_text = Tex(r"The \emph{Affine set} almost has the same definition,\\but the line is infinite instead of a segment,\\ that is, $L = \{\mathbf{y} \in \mathbb{R}^3 \mid \mathbf{y} = \theta \mathbf{x}_1+(1-\theta) \mathbf{x}_2, \forall\: \theta \in \mathbb{R}\}$.\\When $L \subset C$ for any $\mathbf{x}_1,\mathbf{x}_2 \in C$, we say that $C$ is an \emph{Affine set}.").to_edge(DOWN)
        self.add_fixed_in_frame_mobjects(affine_conclusion_text)
        self.play(ReplacementTransform(convex_conclusion_text, affine_conclusion_text))
        self.wait(3)
        self.play(FadeOut(affine_conclusion_text), FadeIn(ax, convex_set, line_segment, x1, x2, e1_axis_text, e2_axis_text, e3_axis_text))
        self.wait()
        # show that c is a convex set
        c_is_convex_text = Text("Our plane is a convex set as any\nline segment whose tips\nbelongs to it is also inside the plane.\n").to_corner(UL)
        self.add_fixed_in_frame_mobjects(c_is_convex_text)
        self.play(Write(c_is_convex_text))
        # show that c is not an affine set
        c_isnt_affine_text = Text("But is not an affine\nset since it\nis a bounded sheet :(").to_corner(UL)
        self.add_fixed_in_frame_mobjects(c_isnt_affine_text)
        self.play(ReplacementTransform(c_is_convex_text, c_isnt_affine_text), x1.animate.move_to([10,10,20]), x2.animate.move_to([10,10,-20]))
        # # stretch c to make it an affine set
        # transforming_c_to_affine_text = Text("However, if we stretch out\nthis sheet to infinity,\n we get an affine set :)").to_corner(UL)
        # self.add_fixed_in_frame_mobjects(transforming_c_to_affine_text)
        # affine_set = Surface(lambda x, y: (x, y, x+y),[-20,20], [-20,20])
        # self.play(ReplacementTransform(c_isnt_affine_text, transforming_c_to_affine_text), Transform(convex_set, affine_set))
        # self.wait()
        # self.play(x1.animate.move_to([0,0,0]))
        # subspace_conclusion_text = Tex(r"When the affine set\\happens to include\\the origin. It is\\also a subspace in $\mathbb{R}$").to_corner(UL)
        # self.wait(3)
