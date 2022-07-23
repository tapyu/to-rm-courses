using LinearAlgebra, DSP, Plots, LaTeXStrings
Σ = sum

Nₛ = 200 # number of samples
𝐱 = randn(Nₛ) # input vector
𝐡 = [1, 1.6] # filter coefficients
μₘₐₓ = 1/12
μ = μₘₐₓ # step learning

# filter output (desired signal) - both are equivalent
# H = PolynomialRatio(𝐰ₒ, [1])
# 𝐝 = filt(H, 𝐱)
𝐝 = rand(Nₛ)
for n ∈ 2:Nₛ
    𝐱₍ₙ₎ = [𝐱[n], 𝐱[n-1]] # input vector at the instant n
    𝐝[n] = 𝐡 ⋅ 𝐱₍ₙ₎ # d(n)
end

# Least-Mean Squares (LMS) algorithm
𝐰₍ₙ₎ = rand(2) # initial guess of the coefficient vector
𝐲 = rand(Nₛ) # output signal
for n ∈ 2:Nₛ
    𝐱₍ₙ₎ = [𝐱[n], 𝐱[n-1]] # input vector at the instant n
    𝐲[n] = 𝐰₍ₙ₎ ⋅ 𝐱₍ₙ₎ # y(n)
    e₍ₙ₎ = 𝐝[n] - 𝐲[n]
    𝐠̂₍ₙ₎ = -2e₍ₙ₎*𝐱₍ₙ₎ # stochastic gradient
    global 𝐰₍ₙ₎ -= μ*𝐠̂₍ₙ₎
end
p1 = plot([𝐲 𝐝], title="LMS algorithm", label=[L"\mathbf{w}(n) = \mathbf{w}(n) + 2\mu e(n)\mathbf{x}(n)" L"d(n)"])
e1 = plot(𝔼e², title="MSE of the LMS algorithm", label=L"\mathbb{E}[e^2(n)]")

display(p1)