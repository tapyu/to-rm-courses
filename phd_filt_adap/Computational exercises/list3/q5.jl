using LinearAlgebra, Plots, LaTeXStrings

Nₛ = 200 # number of samples
𝐱 = randn(Nₛ)
# 𝐱 = 2rand(Nₛ) .- 1 # ~ U(-1, 1)
μₘₐₓ = 1/12
N = 13 # 12 tapped delay plus the bias

# system output
𝐝ʼ = rand(Nₛ)
for n ∈ N:Nₛ
    𝐝ʼ[n] = 𝐝ʼ[n-1] + 𝐱[n] - 𝐱[n-12]
end

# reference signal (system output + noise)
𝐧 = √(1e-3)randn(Nₛ) # ~ N(0, 1e-3)
𝐝 = 𝐝ʼ + 𝐧

plots = Array{Plots.Plot{Plots.GRBackend}, 1}(undef,4) # or Vector{Plots.GRBackend}(undef,4)
for (j, i) ∈ enumerate((1, 2, 10, 50))
    μ = μₘₐₓ/i # step learning
    # the LMS algorithm
    𝐰₍ₙ₎ = rand(N) # initial coefficient vector
    𝐲 = [fill(NaN, N); rand(Nₛ-N)] # adaptive filter output
    for n ∈ N:Nₛ
        𝐱₍ₙ₎ = 𝐱[n:-1:n-12] # input signal
        𝐲[n] = 𝐱₍ₙ₎ ⋅ 𝐰₍ₙ₎ # adaptive filter output
        e₍ₙ₎ = 𝐝[n] - 𝐲[n] # signal error
        𝐰₍ₙ₎ += 2μ*e₍ₙ₎*𝐱₍ₙ₎
    end
    plots[j] = plot([𝐝 𝐲], label=[L"d(n)" L"y(n)"*" for "*L"\mu=\mu_{max}"*(i!=1 ? "/$(i)" : "")], xlabel="n")
end

fig = plot(plots..., layout=(4,1), size=(1200,800))

savefig(fig, "figs/q5_lms_algorithm.png")