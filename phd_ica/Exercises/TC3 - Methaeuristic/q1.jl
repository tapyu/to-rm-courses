using FileIO, Plots, LinearAlgebra, Statistics
Σ=sum
⊙ = .* # Hadamard

𝐱, 𝐲 = FileIO.load("TC1 - Sistemas Fuzzy para Regressão Não Linear/TC1data.jld2", "x", "y") # 𝐱 -> Inputs; 𝐲 -> Outputs

# the kth order plynomial regressors
𝐇 = vcat(map(xₙ -> xₙ.^(0:6)', 𝐱)...) # observation matrix
𝐇⁺ = pinv(𝐇) # the pseudoinverse (not the same Matlab's garbage pinv() function)
𝛉ₒ = 𝐇⁺*𝐲 # estimated coefficients (optimum values)
𝐲̂ = 𝐇*𝛉ₒ # regressor output

I = 30 # number of particles
J = 𝐲̂ᵢ -> Σ((𝐲̂-𝐲̂ᵢ).^2) # cost function
cₚ = cg = .1 # accelerator coefficients
k = 6 # order of the polynomial regression
Nᵢ = 100 # number of iterations

# initialize!
𝐗 = rand(k+1, I) # matrix of all solutions [position of the ith particle X I particles]
𝐕 = rand(k+1, I) # their velocities
𝐏 = rand(k+1, I) # their positions for their best solutions
𝐠 = rand(k+1) # the position for the best global solution
𝐣ₚ = fill(Inf, I) # cost function of the best solution for each particle
Jg = Inf # cost function of the global solution
𝐣g = fill(NaN, Nᵢ)

for (nᵢ, w) ∈ enumerate(range(.9,.4, length=Nᵢ)) # inertia parameter
    for i ∈ 1:I
        𝐫ₚ, 𝐫g = (rand(k+1) for _ ∈ 1:2)
        𝐕[:,i] = w*𝐕[:,i] + cₚ*𝐫ₚ⊙(𝐏[:,i] - 𝐗[:,i]) + cg*𝐫g⊙(𝐠 - 𝐗[:,i]) # update velocity
        𝐗[:,i] += 𝐕[:,i]
        𝐲̂ᵢ = map(x₍ₙ₎ -> Σ(𝐗[:,i] ⊙ x₍ₙ₎.^(0:k)), 𝐱)
        J(𝐲̂ᵢ)<𝐣ₚ[i] && (𝐣ₚ[i]=J(𝐲̂ᵢ); 𝐏[:,i]=𝐗[:,i]) # update position of the individual best solution
        J(𝐲̂ᵢ)<Jg && (global Jg=J(𝐲̂ᵢ); global 𝐠=𝐗[:,i]; global 𝐣g[nᵢ]=J(𝐲̂ᵢ)) # update position of global best solution
    end
end

# println("The optimum result: 𝛉ₒ=$(𝛉ₒ')")
# println("Heuristic result: 𝐠=$(𝐠')")

𝐲̂ₒ = map(x₍ₙ₎ -> Σ(𝐠 ⊙ x₍ₙ₎.^(0:k)), 𝐱) # heuristic solution

fig = plot([𝐲̂ 𝐲̂ₒ], label=["Least Square Polynomial solution" "Heuristic solution"], layout=(2,1))
savefig(fig, "./TC3 - Methaeuristic/figs/methaeuristic_regression_result.png")