from manim import *

class ConeSet(Scene):
    def construct(self):
        ax = Axes(x_range=[0, 10, 1], y_range=[0, 10, 1])
        x_axis = ax.get_x_axis_label(MathTex("x"))
        y_axis = ax.get_y_axis_label(MathTex("y"))
        self.play(Create(ax), FadeIn(x_axis, y_axis))
        self.wait(2)