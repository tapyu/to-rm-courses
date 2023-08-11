# Numerical methods

Bibliography: Chapra, S., 2011. Applied Numerical Methods with MATLAB for Engineers and Scientists. McGraw Hill.

## Useful resouces
- Packages:
  - [`DifferentialEquations.jl`][1]: Numerically solving differential equations written in `julia`
    - Runge-Kutta Methods
    - Midpoint
    - Heun
    - Runge-Kutta Methods
  - [`IterativeSolvers.jl`][2]: Iterative algorithms for solving linear systems, eigensystems, and singular value problems. Examples:
    - Gauss-Seidel method
    - Jacobi iteration method
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
    - `integral()` in matlab uses adaptive quadrature (see Chapra)
  - [`Roots.jl`][7]: Root finding functions for Julia
    - Bisection-like algorithms
    - Newton's method
    - Chebyshev (it does not have on Chapra)
    - Schroder (it does not have on Chapra)
    - QuadraticInverse (it does not have on Chapra)
    
[1]: https://docs.sciml.ai/DiffEqDocs/latest/
[2]: https://iterativesolvers.julialinearalgebra.org/dev/
[3]: https://github.com/dextorious/NumericalIntegration.jl
[4]: https://docs.sciml.ai/Overview/stable/
[5]: https://github.com/JuliaMath/HCubature.jl
[6]: https://github.com/stevengj/cubature
[7]: https://juliamath.github.io/Roots.jl/stable/
