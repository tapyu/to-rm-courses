using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings
Σ=sum

## algorithm parameters and hyperparameters
Nᵣ = 20 # number of realizations
Nₑ = 100 # number of epochs
c = 3 # number of perceptrons (neurons) of the single layer
α = 0.001 # learning step
σₓ = .1 # signal standard deviation
N = 150 # number of instances
Nₐ = 2 # number of attributes
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset

## generate dummy data
𝐗⚫ = [σₓ*randn(50)'.+1.5; σₓ*randn(50)'.+1]
𝐗△ = [σₓ*randn(50)'.+1; σₓ*randn(50)'.+2]
𝐗⭐ = [σₓ*randn(50)'.+2; σₓ*randn(50)'.+2]

𝐗 = [fill(-1,N)'; [𝐗⚫ 𝐗△ 𝐗⭐]]
𝐃 = [repeat([1,0,0],1,50) repeat([0,1,0],1,50) repeat([0,0,1],1,50)]

## useful functions
function shuffle_dataset(𝐗, 𝐃)
    shuffle_indices = Random.shuffle(1:size(𝐗,2))
    return 𝐗[:, shuffle_indices], 𝐃[:, shuffle_indices]
end

function train(𝐗ₜᵣₙ, 𝐃ₜᵣₙ, 𝐖)
    φ = uₙ -> uₙ>0 ? 1 : 0 # McCulloch and Pitts's activation function (step function)
    𝐄ₜᵣₙ = rand(size(𝐃ₜᵣₙ,1),size(𝐃ₜᵣₙ,2)) # matrix with all errors (TODO, do it better)
    for (n, (𝐱ₙ, 𝐝ₙ)) ∈ enumerate(zip(eachcol(𝐗ₜᵣₙ), eachcol(𝐃ₜᵣₙ)))
        𝛍ₙ = 𝐖*𝐱ₙ
        𝐲ₙ = map(φ, 𝛍ₙ) # for the training phase, you do not pass yₙ to a harder decisor (the McCulloch and Pitts's activation function) (??? TODO)
        𝐲ₙ = 𝛍ₙ
        𝐞ₙ = 𝐝ₙ - 𝐲ₙ
        𝐖 += α*𝐞ₙ*𝐱ₙ'
        𝐄ₜᵣₙ[:,n] = 𝐞ₙ
    end
    𝐞²ₜᵣₙ = Σ(eachcol(𝐄ₜᵣₙ.^2))/size(𝐄ₜᵣₙ,2)  # MSE (Mean squared error), that is, the the estimative of second moment of the error signal for this epoch
    return 𝐖, 𝐞²ₜᵣₙ
end

function test(𝐗ₜₛₜ, 𝐃ₜₛₜ, 𝐖)
    φ = uₙ -> uₙ>0 ? 1 : 0 # McCulloch and Pitts's activation function (step function)
    𝐄ₜₛₜ = rand(size(𝐃ₜᵣₙ,1),size(𝐃ₜᵣₙ,2)) # vector of errors
    for (n, (𝐱ₙ, 𝐝ₙ)) ∈ enumerate(zip(eachcol(𝐗ₜₛₜ), eachcol(𝐃ₜₛₜ)))
        𝛍ₙ = 𝐖*𝐱ₙ
        # yₙ = map(φ, 𝛍ₙ) # theoretically, you need to pass 𝛍ₙ through the activation function, but, in order to solve ambiguous instances (see Ajalmar's handwritings), we pick the class with the highest activation function input
        𝐲ₙ = 𝛍ₙ.==maximum(𝛍ₙ) # choose the highest activation function input as the selected class
        𝐞ₙ = 𝐝ₙ - 𝐲ₙ
        𝐖 += α*𝐞ₙ*𝐱ₙ'
        𝐄ₜₛₜ[:,n] = 𝐞ₙ
    end
    𝐞²ₜₛₜ = Σ(eachcol(𝐄ₜₛₜ.^2))/size(𝐄ₜₛₜ,2) # MSE (Mean squared error), that is, the the estimative of second moment of the error signal for this epoch
    return 𝐞²ₜₛₜ # MSE
end

## init
MSEₜₛₜ = rand(c,0)
for nᵣ ∈ 1:Nᵣ
    # initialize!
    𝐖 = rand(c, Nₐ+1) # [𝐰₁ᵀ; 𝐰₂ᵀ; ...; 𝐰ᵀ_c]
    MSEₜᵣₙ = rand(c,0)

    # prepare the data!
    global 𝐗, 𝐃 = shuffle_dataset(𝐗, 𝐃)
    # hould-out
    global 𝐗ₜᵣₙ = 𝐗[:,1:(N*Nₜᵣₙ)÷100]
    global 𝐃ₜᵣₙ = 𝐃[:,1:(N*Nₜᵣₙ)÷100]
    global 𝐗ₜₛₜ = 𝐗[:,size(𝐃ₜᵣₙ,2)+1:end]
    global 𝐃ₜₛₜ = 𝐃[:,size(𝐃ₜᵣₙ,2)+1:end]

    # train and test!
    for nₑ ∈ 1:Nₑ # for each epoch
        𝐖, MSEₜᵣₙne = train(𝐗ₜᵣₙ, 𝐃ₜᵣₙ, 𝐖)
        MSEₜᵣₙ = [MSEₜᵣₙ MSEₜᵣₙne]
    end
    global MSEₜₛₜ = [MSEₜₛₜ test(𝐗ₜₛₜ, 𝐃ₜₛₜ, 𝐖)]
    
    # make plots!
    if nᵣ==1
        # plot training MSE x epochs
        local fig = plot(MSEₜᵣₙ', ylims=(0,2), label=["circle" "triangle" "star"], xlabel="Epochs", ylabel="MSE", linewidth=2)
        savefig(fig, "figs/trab3 (single layer perceptron)/dummy data - training dataset evolution.png")

        # plot decision surface for the 1th realization
        local φ = uₙ -> uₙ≥0 ? 1 : 0 # activation function of the simple Perceptron
        local x₁_range = floor(minimum(𝐗[2,:])):.1:ceil(maximum(𝐗[2,:]))
        local x₂_range = floor(minimum(𝐗[3,:])):.1:ceil(maximum(𝐗[3,:]))
        global y(x₁, x₂) = findfirst(a -> a==maximum(𝐖*[-1, x₁, x₂]), 𝐖*[-1, x₁, x₂]) # predict

        fig = contour(x₁_range, x₂_range, y, xlabel = L"x_1", ylabel = L"x_2", fill=true, levels=2)
        # train circe label
        scatter!(𝐗ₜᵣₙ[2,𝐃ₜᵣₙ[1,:].==1], 𝐗ₜᵣₙ[3,𝐃ₜᵣₙ[1,:].==1], markershape = :hexagon, markersize = 8, markeralpha = 0.6, markercolor = :white, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "circe class [train]")
            
        # test circle label
        scatter!(𝐗ₜₛₜ[2,𝐃ₜₛₜ[1,:].==1], 𝐗ₜₛₜ[3,𝐃ₜₛₜ[1,:].==1], markershape = :dtriangle, markersize = 8, markeralpha = 0.6, markercolor = :white, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "circle class [test]")

        # train triangle label
        scatter!(𝐗ₜᵣₙ[2,𝐃ₜᵣₙ[2,:].==1], 𝐗ₜᵣₙ[3,𝐃ₜᵣₙ[2,:].==1], markershape = :hexagon, markersize = 8, markeralpha = 0.6, markercolor = :cyan, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "triangle class [train]")

        # test triangle label
        scatter!(𝐗ₜₛₜ[2,𝐃ₜₛₜ[2,:].==1], 𝐗ₜₛₜ[3,𝐃ₜₛₜ[2,:].==1], markershape = :dtriangle, markersize = 8, markeralpha = 0.6, markercolor = :cyan, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "triangle class [test]")

        # train star label
        scatter!(𝐗ₜᵣₙ[2,𝐃ₜᵣₙ[3,:].==1], 𝐗ₜᵣₙ[3,𝐃ₜᵣₙ[3,:].==1], markershape = :hexagon, markersize = 8, markeralpha = 0.6, markercolor = :green, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "star class [train]")

        # test star label
        scatter!(𝐗ₜₛₜ[2,𝐃ₜₛₜ[3,:].==1], 𝐗ₜₛₜ[3,𝐃ₜₛₜ[3,:].==1], markershape = :dtriangle, markersize = 8, markeralpha = 0.6, markercolor = :green, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "star class [test]")

        title!("Decision surface")
        savefig(fig, "figs/trab3 (single layer perceptron)/dummy data - decision surface.png")
    end
end

M̄S̄Ē = Σ(eachcol(MSEₜₛₜ))/size(MSEₜₛₜ,2) # accuracy
𝔼MSE² = Σ(eachcol(MSEₜₛₜ.^2))/size(MSEₜₛₜ,2)
σₘₛₑ = sqrt.(𝔼MSE² .- M̄S̄Ē.^2) # standard deviation

println("\n\nAccuracy for circle = $(M̄S̄Ē[1])\nAccuracy for star =$(M̄S̄Ē[2])\nAccuracy for triangle = $(M̄S̄Ē[3])")
println("Standard deviation for circle = $(σₘₛₑ[1])\nStandard deviation for star =$(σₘₛₑ[2])\nStandard deviation for triangle = $(σₘₛₑ[3])")