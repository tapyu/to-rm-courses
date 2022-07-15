function input_fuzzification(xₙ, I)
    sets = rand(I)
    if I == 2
        # SMALL fuzzy set (1th set) → ~N(75, 2000)
        x̄ₙ, σ²ₓ = 75, 2000
        sets[1] = ℯ^(-((xₙ-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)

        # LARGE fuzzy set (2th set) → ~N(175, 2000)
        x̄ₙ, σ²ₓ = 175, 2000
        sets[2] = ℯ^(-((xₙ-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)

    elseif I == 3
        # SMALL fuzzy set (1th set) → ~N(50, 1200)
        x̄ₙ, σ²ₓ = 50, 1200
        sets[1] = ℯ^(-((xₙ-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)

        # MEDIUM fuzzy set (2th set) → ~N(125, 1200)
        x̄ₙ, σ²ₓ = 125, 1200
        sets[2] = ℯ^(-((xₙ-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)

        # LARGE fuzzy set (3th set) → ~N(200, 1200)
        x̄ₙ, σ²ₓ = 200, 1200
        sets[3] = ℯ^(-((xₙ-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)
    end
    return sets
end

function output_fuzzification(yₙ, I)
    sets = rand(I)
    if I == 2
        # SMALL fuzzy set (1th set) → ~N(40, 600)
        ȳₙ, σ²y = 40, 600
        sets[1] = ℯ^(-((yₙ-ȳₙ)^2)/(2*σ²y))/√(2*π*σ²y)
        
        # LARGE fuzzy set (2th set) → ~N(100, 600)
        ȳₙ, σ²y = 100, 600
        sets[2] = ℯ^(-((yₙ-ȳₙ)^2)/(2*σ²y))/√(2*π*σ²y)
    elseif I == 3
        # SMALL fuzzy set (1th set) → ~N(30, 400)
        ȳₙ, σ²y = 30, 400
        sets[1] = ℯ^(-((yₙ-ȳₙ)^2)/(2*σ²y))/√(2*π*σ²y)

        # MEDIUM fuzzy set (2th set) → ~N(70, 400)
        ȳₙ, σ²y = 70, 400
        sets[2] = ℯ^(-((yₙ-ȳₙ)^2)/(2*σ²y))/√(2*π*σ²y)
        
        # LARGE fuzzy set (3th set) → ~N(110, 400)
        ȳₙ, σ²y = 110, 400
        sets[3] = ℯ^(-((yₙ-ȳₙ)^2)/(2*σ²y))/√(2*π*σ²y)
    end
    return sets
end