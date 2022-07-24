using LinearAlgebra, DSP
Σ = sum

# system parameters
Nₒ = 3 # channel order
δ = 15 # desired signal delay
Nₜᵣₙ = 500 # number of samples for the training phase
𝐬 = rand([1/√2+1/√2im, 1/√2-1/√2im, -1/√2+1/√2im, -1/√2-1/√2im], Nₜᵣₙ+Nₒ+δ) # constellation for 4QAM
σₛ² = Σ((abs.(𝐬)).^2)/Nₜᵣₙ # signal power -> 𝔼[‖𝐬‖²]

# channel
𝐱 = Vector{ComplexF64}(undef, Nₜᵣₙ+Nₒ+δ)
for n ∈ 1+Nₒ:Nₜᵣₙ+Nₒ+δ
    𝐱[n] = 0.5𝐬[n] + 1.2𝐬[n-1] + 1.5𝐬[n-2] - 𝐬[n-3]
end
# cut off the noncomputed part
𝐱 = 𝐱[1+Nₒ:end]
𝐬 = 𝐬[1+Nₒ:end]

# noise
𝐯 = randn(Nₜᵣₙ+δ)
𝐱 += 𝐯

# equalizer (normalized LMS)
M = 16
𝐰₍ₙ₎ = zeros(M) # filter coefficients (initializing)
μ = 0.4
γ = 10 # Normalized LMS hyperparameter
𝐲 = Vector{ComplexF64}(undef, Nₜᵣₙ+δ) # output signal
for n ∈ 1+δ:Nₜᵣₙ+δ
    𝐱₍ₙ₎ = 𝐱[n:-1:n-δ] # input vector at the instant n -> [x[n], x[n-1], x[n-2], ..., x[n-15]]
    𝐲[n] = 𝐰₍ₙ₎ ⋅ 𝐱₍ₙ₎ # y(n)
    d₍ₙ₎ = 𝐬[n-δ] # d(n) = s[n-δ]
    e₍ₙ₎ = d₍ₙ₎ - 𝐲[n]
    𝐠̂₍ₙ₎ = -2e₍ₙ₎*𝐱₍ₙ₎ # stochastic gradient
    global 𝐰₍ₙ₎ -= μ*𝐠̂₍ₙ₎/(𝐱₍ₙ₎⋅𝐱₍ₙ₎ + γ)
end