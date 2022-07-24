using LinearAlgebra, DSP, Plots
Σ = sum

# system parameters
Nₒ = 3 # channel order
δ = 15 # desired signal delay
Nₜᵣₙ = 500 # number of samples for the training phase
μ = 0.4
γ = 10 # Normalized LMS hyperparameter
M = 16

### TRAIN ###
𝐬 = rand([1+im, 1-im, -1+im, -1-im], Nₜᵣₙ+Nₒ+δ) # constellation for 4-QAM
Pₛ = Σ(abs2.(𝐬))/Nₜᵣₙ # signal power -> 𝔼[‖𝐬‖²]

# channel
𝐱 = Vector{ComplexF64}(undef, Nₜᵣₙ+Nₒ+δ)
for n ∈ 1+Nₒ:Nₜᵣₙ+Nₒ+δ
    𝐱[n] = 0.5𝐬[n] + 1.2𝐬[n-1] + 1.5𝐬[n-2] - 𝐬[n-3]
end
# cut off the noncomputed part
𝐱 = 𝐱[1+Nₒ:end]
𝐬 = 𝐬[1+Nₒ:end]

# noise
σ²ₙ = Pₛ*1e-3 # SNR = 30 dB = 10 log(Pₛ/σ²ₙ)
𝐯 = √(σ²ₙ)*randn(Nₜᵣₙ+δ)
𝐱 += 𝐯

# equalizer (normalized LMS)
𝐰₍ₙ₎ = zeros(M) # filter coefficients (initializing)
𝐞1 = Vector{ComplexF64}(undef, Nₜᵣₙ)
for n ∈ 1+δ:Nₜᵣₙ+δ
    𝐱₍ₙ₎ = 𝐱[n:-1:n-δ] # input vector at the instant n -> [x[n], x[n-1], x[n-2], ..., x[n-15]]
    y₍ₙ₎ = 𝐰₍ₙ₎ ⋅ 𝐱₍ₙ₎ # y(n)
    d₍ₙ₎ = 𝐬[n-δ] # d(n) = s[n-δ]
    e₍ₙ₎ = d₍ₙ₎ - y₍ₙ₎
    𝐞1[n-δ] = e₍ₙ₎
    𝐠̂₍ₙ₎ = -2e₍ₙ₎'*𝐱₍ₙ₎ # stochastic gradient
    global 𝐰₍ₙ₎ -= μ*𝐠̂₍ₙ₎/(𝐱₍ₙ₎⋅𝐱₍ₙ₎ + γ)
end

# DECISION-DIRECTED MODE ###
N = 5e3 # number of samples for the decision-directed mode
𝐬 = rand([i[1]+i[2]*im for i in Iterators.product(-3:2:3, -3:2:3)], Nₜᵣₙ+Nₒ+δ) # constellation for 16-QAM
Pₛ = Σ(abs2.(𝐬))/Nₜᵣₙ # signal power -> 𝔼[‖𝐬‖²]

# channel
𝐱 = Vector{ComplexF64}(undef, Nₜᵣₙ+Nₒ+δ)
for n ∈ 1+Nₒ:Nₜᵣₙ+Nₒ+δ
    𝐱[n] = 0.5𝐬[n] + 1.2𝐬[n-1] + 1.5𝐬[n-2] - 𝐬[n-3]
end
# cut off the noncomputed part
𝐱 = 𝐱[1+Nₒ:end]
𝐬 = 𝐬[1+Nₒ:end]

# noise
σ²ₙ = Pₛ*1e-3 # SNR = 30 dB = 10 log(Pₛ/σ²ₙ)
𝐯 = √(σ²ₙ)*randn(Nₜᵣₙ+δ)
𝐱 += 𝐯

# equalizer in decision-directed mode
function hard_decisor(x)
    if x > 2
        return 3
    elseif x > 0
        return 1
    elseif x > -2
        return -1
    else
        return -3
    end
end

𝐲 = Vector{ComplexF64}(undef, Nₜᵣₙ+δ) # output signal
for n ∈ 1+δ:Nₜᵣₙ+δ
    𝐱₍ₙ₎ = 𝐱[n:-1:n-δ] # input vector at the instant n -> [x[n], x[n-1], x[n-2], ..., x[n-15]]
    y₍ₙ₎ = 𝐰₍ₙ₎ ⋅ 𝐱₍ₙ₎ # y(n)
    # decisor
    𝐲[n] = hard_decisor(real(y₍ₙ₎)) + hard_decisor(imag(y₍ₙ₎))*im
end

# ignoring the noncomputed part
𝐲 = 𝐲[1+δ:end]
𝐬 = 𝐬[1:end-δ]

# plot([real(𝐲) real(𝐬); imag(𝐲) imag(𝐬)], layout=(2,1), size=(1200,800))

plot([real(𝐲[end-150:end]) real(𝐬[end-150:end])], size=(1200,800), line=:stem, marker=:xcross)

# plot(abs.(𝐞1))