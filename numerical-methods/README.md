# Numerical methods

Bibliography: Chapra, S., 2011. Applied Numerical Methods with MATLAB for Engineers and Scientists. McGraw Hill.

## Useful resouces
- Packages:
- **ODE-based problems** (see Part II on Chapra)
  - [`DifferentialEquations.jl`][1]: Numerically solving differential equations written in `julia`. See [all ODE solvers][8]; [recommendation for each situation][9]
    - Runge-Kutta Methods
    - Midpoint
    - Heun
    - Forward Euler method
    - Multistep Methods
  - [Wiki: Explicit vs. implicit methods][17]
  - [Wiki: Numerical methods for ordinary differential equations][18]
  - [Wiki: Runge–Kutta methods][19]
- **Linear system problems** (see Part III on Chapra)
  - [`IterativeSolvers.jl`][2]: Iterative algorithms for solving linear systems, eigensystems, and singular value problems. Iterative mathods constranst with the direct methods (e.g., Gauss elimination), which requires a finite number of steps to solve a linear system. Examples:
    - Gauss-Seidel method
    - Jacobi iteration method
- **Numerical integration** (see part V on Chapra) 
  - [`NumericalIntegration.jl`][3]: Simple (maybe not so reliable) numerical integration methods
    - Trapezoidal (default)
    - TrapezoidalEven
    - TrapezoidalFast
    - TrapezoidalEvenFast
    - SimpsonEven
    - SimpsonEvenFast
    - RombergEven
  - [`Integrals.jl`][4]: A more reliable numerical integration methods (maybe not all methods are exposed in Chapra)
    - Gauss–Kronrod quadrature formula (a variant of Gaussian quadrature, see Chapra)
    - H-Adaptive Integration (Adaptive quadrature? If so, it is on Chapra). It uses [`HCubature.jl`][5], which is a `julia` code for the [adaptive multidimensional integration][6]
    - Monte Carlo integration (apparently it doesn't have on Chapra)
    - Gauss-Legendre quadrature (it has on Chapra)
    - `integral()` in matlab uses adaptive quadrature (see Chapra)
- **Numerical differentiation (finite differences)** (see part V on Chapra)
  - [FiniteDifferences.jl][10] and [FiniteDiff.jl][11] are similar libraries: both calculate approximate derivatives numerically.
    - Backward, forward, and central numerical differentiations.
    - A nice and quick [JuliaDiff tutorial][14] I saw on internet
- [**Automatic differentiation (auto-differentiation, autodiff, or AD)**][13] (it is not on Chapra, but it is more powerful than finite differences)
  - Automatic Differentiation is a more advanced technique that computes derivatives of a function accurately and efficiently by breaking down the function's operations into elementary operations and applying the chain rule of calculus.
  - [ForwardDiff.jl][14]: implements methods to take derivatives, gradients, Jacobians, Hessians, and higher-order derivatives of native Julia functions (or any callable object, really) using forward mode automatic differentiation (AD).
- **Root-finding functions**
  - [`Roots.jl`][7]:
    - Bisection-like algorithms
      - See this [tutorial][16]
    - Newton's method
      - See this [tutorial][15]
    - Chebyshev (it does not have on Chapra)
    - Schroder (it does not have on Chapra)
    - QuadraticInverse (it does not have on Chapra)
    
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
[13]: https://en.wikipedia.org/wiki/Automatic_differentiation#Difference_from_other_differentiation_methods
[14]: https://juliadiff.org/ForwardDiff.jl/stable/
[15]: https://www.matecdev.com/posts/julia-newton-raphson.html
[16]: https://www.matecdev.com/posts/julia-bisection.html
[17]: https://en.wikipedia.org/wiki/Explicit_and_implicit_methods
[18]: https://en.wikipedia.org/wiki/Numerical_methods_for_ordinary_differential_equations
[19]: https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods