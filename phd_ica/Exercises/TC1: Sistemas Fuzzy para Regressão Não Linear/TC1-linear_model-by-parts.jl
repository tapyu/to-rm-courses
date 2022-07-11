using FileIO, Plots

## Input analisys and delimiters

𝐱, 𝐲 = FileIO.load("TC1data.jld2", "x", "y") # x -> Inputs; y -> Outputs

delimiters = [1, 68, 110, 130, 145, 180, 250]
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
plot!(delimiters[2:end-1], linewidth = 2, seriestype = :vline, label = "Delimiters")

## simple Least-Squares (LS) by parts

function simple_LS_algorithm(x,y)
    # ŷ = âx+b̂
    x̄, ȳ = sum(x)/length(x), sum(y)/length(y)
    𝔼xy, 𝔼x² = sum(x.*y)/length(x), sum(x.^2)/length(x)
    σ̂ₓy = 𝔼xy - x̄*ȳ
    σ²ₓ = 𝔼x² - x̄^2
    â = σ̂ₓy/σ²ₓ
    b̂ = ȳ - â*x̄
    return â, b̂
end

for i ∈ 2:length(delimiters)
    𝐱ᵢ, 𝐲ᵢ = 𝐱[delimiters[i-1]:delimiters[i]], 𝐲[delimiters[i-1]:delimiters[i]]

    â, b̂ = simple_LS_algorithm(𝐱ᵢ, 𝐲ᵢ) # get the coefficients
    𝐲̂ᵢ = â*𝐱ᵢ .+ b̂
    global 𝛜ᵢ = 𝐲ᵢ - 𝐲̂ᵢ # residues

    # coefficient of determination
    𝐲̄ᵢ = sum(𝐲ᵢ)/length(𝐲ᵢ)
    R² = 1 - (sum(𝛜ᵢ.^2)/sum((𝐲ᵢ.-𝐲̄ᵢ).^2))

    # residues statistics
    𝛜̄ᵢ = sum(𝛜ᵢ)/length(𝛜ᵢ)
    𝔼ϵ² = sum(𝛜ᵢ.^2)/length(𝛜ᵢ)
    σ̂²ₑ = 𝔼ϵ² - 𝛜̄ᵢ^2

    # plot the curve of the linear regressors
    plot!([delimiters[i-1], delimiters[i]], [â*delimiters[i-1]+b̂, â*delimiters[i] + b̂], label="", color=:red, linewidth = 3)

    # plot the histogram of the residues along with the Gaussian distribution
end

display(p) # show the plot!
d = histogram(𝛜ᵢ) # show histogram!
display(d)