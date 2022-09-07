from manim import *

class Test(ThreeDScene):
    def construct(self):
        axes = ThreeDAxes()
        self.set_camera_orientation(phi=75*DEGREES, theta=-45*DEGREES)
        self.play(Create(axes))
        self.wait()
        convex_set = Surface(lambda x, y: (x, y, x+y),[-10,10], [-10,10])
        self.play(Create(convex_set))
        c_is_convex_text = Text("Our plane is a convex set as any\nline segment whose tips\nbelongs to it is also inside it.\n").to_corner(UL)
        self.add_fixed_in_frame_mobjects(c_is_convex_text)
        self.play(Write(c_is_convex_text))
        self.move_camera(zoom=0.5)
        c_isnt_affine_text = Text("But is not an affine set since it is a bounded sheet :(")
        self.play(ReplacementTransform(c_is_convex_text, c_isnt_affine_text))
        affine_set = Surface(lambda x, y: (x, y, x+y),[-20,20], [-20,20])
        transforming_c_to_affine_text = Text("However, if we stretch out this sheet to infinity,\n we get an affine set :)")
        self.add_fixed_in_frame_mobjects(transforming_c_to_affine_text)
        self.play(ReplacementTransform(c_isnt_affine_text, transforming_c_to_affine_text), Transform(convex_set, affine_set))
        self.move_camera(zoom=2.5)
        
        