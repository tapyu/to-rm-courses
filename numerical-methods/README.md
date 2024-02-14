# Numerical methods

Main bibliography:
- Chapra, S., 2011. Applied Numerical Methods with MATLAB for Engineers and Scientists. McGraw Hill.

Other sources:
- Dahlquist, G. and Björck, Å., 2003. Numerical methods. Courier Corporation.: A alternative material for Chapra. Basically, it seems to the same contents as Chapra (and in the same depth level).
- Kreyszig, E., Stroud, K. and Stephenson, G., 2008. Advanced engineering mathematics: For analytical solution of ODEs (Part A, chap 1-6) and PDE (chapter 12).
- Goodfellow, I., Bengio, Y. and Courville, A., 2016. Deep learning. MIT press: Only the part about automatic differentiation (sec 6.5.9).

## Numerical methods summary

- [Root-finding problems][30]: How to find the roots of a function?
- [ODE- and PDE-based problems][31]: Given a ODE/PDE, how to solve it. The solutions to ordinary differential equations (ODEs) can be broadly categorized into two main types: analytical solutions and numerical solutions.
  - **Analytical/closed-form solution**: Exact mathematical expressions that represent the solution to the differential equation. Examples include $x(t) = \cos(t)$ for $x + x' = 0$. Analytical solutions often involve systematic methods and techniques such as separation of variables, integrating factors, variation of parameters, Laplace transforms, and others. For a more in-depth solution review, see Erwin Kreyszig, part A and C.
  - **Numerical solution**: Provide an approximation to the solution by discretizing the domain and using iterative methods. Examples include Euler's method, Runge-Kutta methods, and finite difference methods. The algorithms shown here falls in this approach.
  The key factor that determines which solution one should follow is the problem complexity. If the problem is simple and fall into certain class of ODE problems (e.g., separable ODEs, exact ODEs, linear ODEs, homogeneous and inhomogeneous ODEs, etc), we may solve it analytically. However, **differential equations such as those used to solve real-life problems may not necessarily be directly solvable, i.e. do not have closed form solutions. Instead, solutions can be approximated using numerical methods.**
- [Linear systems problems][32]: Direct and iterative methods to solve linear systems. This topic overlaps with the Linear Algebra contents, but focuses more on the numerical approach to solve Linear system of equations, rather than the theoterical aspects of Linear Algebra. See the [Linear Algebra][33] directory for more info.
  - Direct methods (see section 5.3 on Dahlquist):
    - LU decomposition;
    - Gaussian Elimination;
    - Inverse matrices;
    - Cholesky Decomposition
  - Iterative methods (see section 5.6 on Dahlquist):
    - Gauss-Seidel method;
    - Jacobi method;
    - Successive overrelaxation (SOR) method.

![image](./assets/direct-vs-iterative.png)


- Curve fitting

## Packages
- **Root-finding functions** (see Part II on Chapra, chapter 6 and 7)
  - [`Roots.jl`][7]:
    - Bisection-like algorithms (the most classic bracket method, see section 5.4)
      - See this [tutorial][16]
    - Newton's method
      - See this [tutorial][15]
    - Chebyshev (it does not have on Chapra)
    - Schroder (it does not have on Chapra)
    - QuadraticInverse (it does not have on Chapra)
- **ODE-based problems** (see Part VI on Chapra)
  - [`DifferentialEquations.jl`][1]: Numerically solving differential equations written in `julia`. See [all ODE solvers][8]; [recommendation for each situation][9]
    - Runge-Kutta Methods (see 22.4 on Chapra and [wiki][19])
    - Midpoint (see section 22.3.2 on Chapra)
    - Heun (see section 22.3.1 on Chapra)
    - Forward Euler method (see section 22.2 on Chapra)
    - Multistep Methods (see section 23.2 on Chapra)
- **Linear system problems** (see Part III on Chapra)
  - [`IterativeSolvers.jl`][2]: Iterative algorithms for solving linear systems, eigensystems, and singular value problems. Iterative methods constranst with the direct methods (e.g., Gauss elimination), which requires a finite number of steps to solve a linear system. Examples:
    - Gauss-Seidel method (an interative method for solving linear systems, see chapter 12 on Chapra)
    - Jacobi iteration method (see section 12.1 on Chapra)
- **Numerical integration** (see part V on Chapra) 
  - [`NumericalIntegration.jl`][3]: Simple (maybe not so reliable) numerical integration methods
    - Trapezoidal (default) (See section 19.3 on Chapra)
    - TrapezoidalEven
    - TrapezoidalFast
    - TrapezoidalEvenFast
    - SimpsonEven (See section 19.4 on Chapra)
    - SimpsonEvenFast
    - RombergEven (see 20.2 on Chapra)
  - [`Integrals.jl`][4]: A more reliable numerical integration methods (maybe not all methods are exposed in Chapra)
    - Gauss–Kronrod quadrature formula (a variant of Gaussian quadrature, see [wiki][27])
    - H-Adaptive Integration (Adaptive quadrature? If so, see section 20.4 on Chapra). It uses [`HCubature.jl`][5], which is a `julia` code for the [adaptive multidimensional integration][6]
    - Monte Carlo integration (apparently it doesn't have on Chapra)
    - Gauss-Legendre quadrature (see section 20.3 on Chapra)
    - `integral()` in matlab uses adaptive quadrature (see section 20.4 on Chapra)
- **Numerical differentiation (finite differences)** (see part V on Chapra)
  - [FiniteDifferences.jl][10] and [FiniteDiff.jl][11] are similar libraries: both calculate approximate derivatives numerically.
    - Backward, forward, and central numerical differentiations (see section 4.3 on Chapra, for high-order numerical differentiation, see chap 21).
- **Automatic differentiation (auto-differentiation, autodiff, or AD)** (see [wiki][13])
  - Automatic Differentiation is a more advanced technique that computes derivatives of a function accurately and efficiently by breaking down the function's operations into elementary operations and applying the chain rule of calculus.
  - [ForwardDiff.jl][14]: implements methods to take derivatives, gradients, Jacobians, Hessians, and higher-order derivatives of native Julia functions (or any callable object, really) using forward mode automatic differentiation (AD).
  - [ReverseDiff.jl][22]: A similar package to `ForwardDiff.jl` (see the differences in the `README.md`).
- **Curve fitting**
  - [`Interpolations.jl`](https://github.com/JuliaMath/Interpolations.jl)
  - [`DataInterpolations.jl`](https://github.com/SciML/DataInterpolations.jl)
    - Linear interpolation
    - Quadratic interpolation
    - Lagrange interpolation
    - Quadratic spline
    - Cubic spline

---

## Other resources:
- [Awesome STEM academy]
- [Direct vs. iterative methods][20] for solution of linear systems:
  - [advantages and disavantages][21]
  - [wiki: a nice example][28]
- [Wiki: Ordinary and partial differential equations: Explicit vs. implicit methods][17]
- [Wiki: key performance indicators in numerical analysis][18]
- [Wiki: Automatic vs. numerical vs. symbolic differentiation][29]
- A Hands-on Introduction to Automatic Differentiation towards deep learning - Part [1][23] and Part [2][24]
- `./nootebook/` contains a series of `.ipynb` with tutorials for the `DifferentialEquations.jl` package, which was found in [SciMLTutorials.jl][25] (this repo is deprecated, but the notebooks still useful). See his video tutorial on [Youtube][26]

    
[1]: https://docs.sciml.ai/DiffEqDocs/latest/
[2]: https://iterativesolvers.julialinearalgebra.org/dev/
[3]: https://github.com/dextorious/NumericalIntegration.jl
[4]: https://docs.sciml.ai/Integrals/stable/
[5]: https://github.com/JuliaMath/HCubature.jl
[6]: https://github.com/stevengj/cubature
[7]: https://juliamath.github.io/Roots.jl/stable/
[8]: https://docs.sciml.ai/DiffEqDocs/stable/solvers/ode_solve/
[9]: https://docs.sciml.ai/DiffEqDocs/stable/#Solver-Algorithms
[10]: https://github.com/JuliaDiff/FiniteDifferences.jl
[11]: https://github.com/JuliaDiff/FiniteDiff.jl
[12]: https://juliadiff.org/
[13]: https://en.wikipedia.org/wiki/Automatic_differentiation
[14]: https://juliadiff.org/ForwardDiff.jl/stable/
[15]: https://www.matecdev.com/posts/julia-newton-raphson.html
[16]: https://www.matecdev.com/posts/julia-bisection.html
[17]: https://en.wikipedia.org/wiki/Explicit_and_implicit_methods
[18]: https://en.wikipedia.org/wiki/Numerical_methods_for_ordinary_differential_equations#Analysis
[19]: https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods
[20]: https://www.linkedin.com/advice/0/how-do-you-compare-combine-direct-iterative
[21]: http://www.decom.ufop.br/moreira/site_media/uploads/arquivos/01_selas_new.pdf
[22]: https://github.com/JuliaDiff/ReverseDiff.jl
[23]: https://mostafa-samir.github.io/auto-diff-pt1/
[24]: https://mostafa-samir.github.io/auto-diff-pt2/
[25]: https://github.com/SciML/SciMLTutorials.jl
[26]: https://www.youtube.com/watch?v=KPEqYtEd-zY&ab_channel=TheJuliaProgrammingLanguage
[27]: https://en.wikipedia.org/wiki/Gauss%E2%80%93Kronrod_quadrature_formula
[28]: https://en.wikipedia.org/wiki/Numerical_analysis#Direct_and_iterative_methods
[29]: https://en.wikipedia.org/wiki/Automatic_differentiation#Difference_from_other_differentiation_methods
[30]: https://en.wikipedia.org/wiki/Root-finding_algorithms
[31]: https://en.wikipedia.org/wiki/Differential_equation#:~:text=An%20ordinary%20differential%20equation%20(ODE,%2C%20therefore%2C%20depends%20on%20x.
[32]: https://en.wikipedia.org/wiki/Numerical_linear_algebra
[33]: https://github.com/tapyu/courses/tree/main/linear-algebra
[Awesome STEM academy]: https://github.com/tapyu/awesome-stem-academy/tree/main#numerical-methods
