function input_fuzzification(xₙ)
    sets = rand(4)
    # VERY LOW fuzzy set (1th set) → ~N(30, 300)
    x̄ₙ, σ²ₓ = 30, 300
    sets[1] = ℯ^(-((max(xₙ, x̄ₙ)-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)

    # LOW fuzzy set (2th set) → ~N(70, 300)
    x̄ₙ, σ²ₓ = 70, 300
    sets[2] = ℯ^(-((xₙ-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)

    # MEDIUM fuzzy set (3th set) → ~N(127, 600)
    x̄ₙ, σ²ₓ = 127, 600
    sets[3] = ℯ^(-((xₙ-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)

    # HIGH fuzzy set (4th set) → ~N(202, 600)
    x̄ₙ, σ²ₓ = 202, 600
    sets[4] = ℯ^(-((min(xₙ, x̄ₙ)-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)
return sets
end