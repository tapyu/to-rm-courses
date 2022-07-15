using FileIO, Plots, LinearAlgebra, Statistics, LaTeXStrings
include("fuzzification_mamdani.jl")
include("inference_mamdani.jl")
Σ=sum

## Input and outputs
𝐱, 𝐲 = FileIO.load("TC1data.jld2", "x", "y") # 𝐱 -> Inputs; 𝐲 -> Outputs

# Mamdani fuzzy infer system
𝐲̂ = rand(length(𝐲))
for (K, 𝐲_range_max) ∈ zip((2,3), (190,150))
    𝐲_range = range(0, 𝐲_range_max, length(𝐲)) # Universo de discurso (?) da variavel de saida
    all_μx_A = hcat(map(input_fuzzification, range(minimum(𝐱), maximum(𝐱), length(𝐱)), fill(K, length(𝐱)))...)' # input fuzzification (all domain, all fuzzy set)
    for (k, μx_A_k) ∈ enumerate(eachcol(all_μx_A)) # for each set
        all_μx_A[:,k]/=maximum(μx_A_k) # normalize it to unity
    end

    all_μy_B = hcat(map(output_fuzzification, 𝐲_range, fill(K, length(𝐲)))...)' # output fuzzification (all domain, all fuzzy set)
    all_μy_B/=maximum(all_μy_B) # normalize it to unity

    for (n, (μx_A, xₙ)) ∈ enumerate(zip(eachrow(all_μx_A), 𝐱)) # for each input sample (already fuzzified)
        𝐲̂[n] = inference(μx_A, all_μy_B, K, 𝐲_range, xₙ) # compute ŷₙ
    end
end

# plot the result
p = scatter(𝐱, 𝐲,
        markershape = :hexagon,
        markersize = 4,
        markeralpha = 0.6,
        markercolor = :green,
        markerstrokewidth = 3,
        markerstrokealpha = 0.2,
        markerstrokecolor = :black,
        xlabel = "Inputs",
        ylabel = "Outputs",
        label = "Data")
plot!(𝐱, 𝐲̂, linewidth=2, label=L"\hat{y}_n")