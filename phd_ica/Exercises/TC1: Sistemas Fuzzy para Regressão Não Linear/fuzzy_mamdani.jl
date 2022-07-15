using FileIO, Plots, LinearAlgebra, Statistics, LaTeXStrings
include("fuzzification_mamdani.jl")
include("inference_mamdani.jl")
Σ=sum

## Input and outputs
𝐱, 𝐲 = FileIO.load("TC1data.jld2", "x", "y") # 𝐱 -> Inputs; 𝐲 -> Outputs
𝐲_range = range(minimum(𝐲), maximum(𝐲), length(𝐲)) # Universo de discurso (?) da variavel de saida

all_μy_B = hcat(map(output_fuzzification, range(minimum(𝐲), maximum(𝐲), length(𝐲)), fill(3, length(𝐲)))...)' # input fuzzification (all domain, all fuzzy set)

# Mamdani fuzzy infer system
𝐲̂ = rand(length(𝐲))
for I ∈ (2,3)
    for (n, xₙ) ∈ enumerate(𝐱)
        μx_A = input_fuzzification(xₙ, I) # input fuzzification
        𝐲̂[n] = inference(μx_A, all_μy_B, I, 𝐲_range) # compute ŷₙ
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