function train(𝐗, 𝐃, 𝔚, φ, φʼ)
    L = length(𝔚) # number of layers
    for (𝐱₍ₙ₎, 𝐝₍ₙ₎) ∈ zip(eachcol(𝐗), eachcol(𝐃)) # n-th instance
        𝐲₍ₙ₎ = rand(L)  # output of the l-th layer at the instant n
        𝐲ʼ₍ₙ₎ = rand(L) # diff of the output of the l-th layer at the instant n
        𝛅₍ₙ₎ = rand(L) # all local gradients of all layers
        # forward phase
        for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚 # l-th layer
            𝐯⁽ˡ⁾₍ₙ₎ = l==1 ? 𝐖⁽ˡ⁾₍ₙ₎*𝐱₍ₙ₎ : 𝐖⁽ˡ⁾₍ₙ₎*𝐲₍ₙ₎[l-1] # induced local field
            𝐲₍ₙ₎[l] = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
            𝐲ʼ₍ₙ₎[l] = map(φʼ, 𝐲₍ₙ₎[l])
        end
        # backward phase
        for l ∈ L:-1:1 # hidden layers
            𝛅₍ₙ₎[l] = l==L ? 𝐲ʼ₍ₙ₎[L] .* (𝐝₍ₙ₎ - 𝐲₍ₙ₎[L]) : 𝐲ʼ₍ₙ₎[l] .* 𝔚[l+1]*𝛅₍ₙ₎[l+1] # vector of local gradients of the l-th layer
            𝔚[l] = l==1 ? 𝔚[l]+η*𝛅₍ₙ₎[l]*𝐱₍ₙ₎' : 𝔚[l]+η*𝛅₍ₙ₎[l]*𝐲₍ₙ₎[l-1]' # learning equation
        end
    end
    return 𝔚
end