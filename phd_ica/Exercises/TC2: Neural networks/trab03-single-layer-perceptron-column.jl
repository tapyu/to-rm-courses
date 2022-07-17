using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings
Σ=sum

### Vertebral column ###

## parameters and hyperparameters
N = 310 # number of instances
Nₐ = 6 # number of number of attributes, that is, input vector size at each intance n
c = 3 # number of perceptrons (neurons) of the single layer
Nᵣ = 20 # number of realizations
Nₑ = 100 # number of epochs
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
α = 0.001 # learning step

## load the data
𝐗, labels = FileIO.load("Dataset/Vertebral column [uci]/dataset_3classes.jld2", "𝐗", "𝐝")

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

function one_hot_encoding(label)
    return ["DH", "SL", "NO"].==label
end

𝐗 = [fill(-1, size(𝐗,2))'; 𝐗] # add the -1 input (bias)
𝐃 = rand(c,0)
for label ∈ labels
    global 𝐃 = [𝐃 one_hot_encoding(label)]
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
    global 𝐗ₜₛₜ = 𝐗[:,size(𝐃ₜᵣₙ, 2)+1:end]
    global 𝐃ₜₛₜ = 𝐃[:,size(𝐃ₜᵣₙ, 2)+1:end]

    # train and test!
    for nₑ ∈ 1:Nₑ # for each epoch
        𝐖, MSEₜᵣₙne = train(𝐗ₜᵣₙ, 𝐃ₜᵣₙ, 𝐖)
        MSEₜᵣₙ = [MSEₜᵣₙ MSEₜᵣₙne]
        𝐗ₜᵣₙ, 𝐃ₜᵣₙ = shuffle_dataset(𝐗ₜᵣₙ, 𝐃ₜᵣₙ)
    end
    local fig = plot(MSEₜᵣₙ', ylims=(0,2), label=["Disk Hernia" "Spondylolisthesis" "Normal"], xlabel="Epochs", ylabel="MSE", linewidth=2)
    savefig(fig, "figs/trab3 (single layer perceptron)/column - training dataset evolution for realization $(nᵣ).png")
    global MSEₜₛₜ = [MSEₜₛₜ test(𝐗ₜₛₜ, 𝐃ₜₛₜ, 𝐖)]
end

M̄S̄Ē = Σ(eachcol(MSEₜₛₜ))/size(MSEₜₛₜ,2) # accuracy
𝔼MSE² = Σ(eachcol(MSEₜₛₜ.^2))/size(MSEₜₛₜ,2)
σₘₛₑ = sqrt.(𝔼MSE² .- M̄S̄Ē.^2) # standard deviation

println("\n\nAccuracy for Disk Hernia = $(M̄S̄Ē[1])\nAccuracy for Spondylolisthesis =$(M̄S̄Ē[2])\nAccuracy for Normal = $(M̄S̄Ē[3])")
println("Standard deviation for Disk Hernia = $(σₘₛₑ[1])\nStandard deviation for Spondylolisthesis =$(σₘₛₑ[2])\nStandard deviation for Normal = $(σₘₛₑ[3])")