using DSP, Plots
include("zplane.jl")

N = 200

𝐰ₒ = [1, 1.6]

𝐱 = randn(N)

# Output filter - both are equivalent
# H = PolynomialRatio(𝐰ₒ, [1])
# 𝐲 = filt(H, 𝐱)
𝐲 = [NaN; rand(N-1)]
for n ∈ 2:N
    𝐲[n] = 𝐰ₒ[1]𝐱[n] + 𝐰ₒ[2]𝐱[n-1]
end

plot([𝐱 𝐲], label=["Input" "Output"])
# plot(PolynomialRatio(𝐰ₒ, [1]))