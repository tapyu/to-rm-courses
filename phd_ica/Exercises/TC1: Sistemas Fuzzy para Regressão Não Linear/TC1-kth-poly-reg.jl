using FileIO, Plots
Σ=sum

## Input analisys and delimiters

𝐱, 𝐲 = FileIO.load("TC1data.jld2", "x", "y") # 𝐱 -> Inputs; 𝐲 -> Outputs

𝐫 = rand(3) # vector with all coefficient of determination

for (i,K) ∈ enumerate(2:4)
    # the kth order plynomial regressors
    𝐇 = hcat(ones(length(𝐱)), map(xₙ -> xₙ.^(0:K), 𝐱)...) # observation matrix
    𝐇⁺ = pinv(𝐇) # the pseudoinverse (not the same Matlab's garbage pinv() function)
    𝛉 = 𝐇⁺*𝐲 # estimated coefficients
    𝐲̂ = 𝐇*𝛉 # regressor output
    𝛜 = 𝐲 - 𝐲̂ # residues

    # residues statistics
    𝛜̄ = Σ(𝛜)/length(𝛜) # must be approximetly zero
    𝔼𝛜² = Σ(𝛜.^2)/length(𝛜) # second moment
    σ̂²ₑ = 𝔼𝛜² - 𝛜̄^2 # σ̂²ₑ≈𝔼𝛜² (variance≈power)

    # coefficient of determination
    𝐲̄ = Σ(𝐲)/length(𝐲)
    R² = 1 - (Σ(𝛜.^2)/Σ((𝐲.-𝐲̄).^2))
    𝐫[i] = R²
end