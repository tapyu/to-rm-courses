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
    Nₑ = 0 # number of errors - misclassification
    for (𝐱ₙ, 𝐝ₙ) ∈ zip(eachcol(𝐗ₜₛₜ), eachcol(𝐃ₜₛₜ))
        𝛍ₙ = 𝐖*𝐱ₙ
        𝐲ₙ = map(φ, 𝛍ₙ) # for the training phase, you do not pass yₙ to a harder decisor (the McCulloch and Pitts's activation function) (??? TODO)
        𝐞ₙ = 𝐝ₙ - 𝐲ₙ
        𝐖 += α*𝐞ₙ*𝐱ₙ'

        # this part is optional: only if it is interested in seeing the dataset evolution
        i = findfirst(x->x==maximum(𝛍ₙ), 𝛍ₙ)
        Nₑ = 𝐝ₙ[i]==1 ? Nₑ : Nₑ+1
    end
    accuracy = (size(𝐃,2)-Nₑ)/size(𝐃,2)
    return 𝐖, accuracy
end

function test(𝐗ₜₛₜ, 𝐃ₜₛₜ, 𝐖)
    φ = uₙ -> uₙ>0 ? 1 : 0 # McCulloch and Pitts's activation function (step function)
    Nₑ = 0 # number of errors - misclassification
    for (𝐱ₙ, 𝐝ₙ) ∈ zip(eachcol(𝐗ₜₛₜ), eachcol(𝐃ₜₛₜ))
        𝛍ₙ = 𝐖*𝐱ₙ
        # yₙ = map(φ, 𝛍ₙ) # theoretically, you need to pass 𝛍ₙ through the activation function, but, in order to solve ambiguous instances (see Ajalmar's handwritings), we pick the class with the highest activation function input
        i = findfirst(x->x==maximum(𝛍ₙ), 𝛍ₙ) # predicted value → choose the highest activation function input as the selected class
        Nₑ = 𝐝ₙ[i]==1 ? Nₑ : Nₑ+1
    end
    accuracy = (size(𝐃,2)-Nₑ)/size(𝐃,2)
    return accuracy
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
accₜₛₜ = rand(Nᵣ) # vector of accuracies for test dataset
for nᵣ ∈ 1:Nᵣ
    # initialize!
    𝐖 = rand(c, Nₐ+1) # [𝐰₁ᵀ; 𝐰₂ᵀ; ...; 𝐰ᵀ_c]
    accₜᵣₙ = rand(Nₑ) # vector of accuracies for train dataset (to see its evolution during training phase)

    # prepare the data!
    global 𝐗, 𝐃 = shuffle_dataset(𝐗, 𝐃)
    # hould-out
    global 𝐗ₜᵣₙ = 𝐗[:,1:(N*Nₜᵣₙ)÷100]
    global 𝐃ₜᵣₙ = 𝐃[:,1:(N*Nₜᵣₙ)÷100]
    global 𝐗ₜₛₜ = 𝐗[:,size(𝐃ₜᵣₙ, 2)+1:end]
    global 𝐃ₜₛₜ = 𝐃[:,size(𝐃ₜᵣₙ, 2)+1:end]

    # train!
    for nₑ ∈ 1:Nₑ # for each epoch
        𝐖, accₜᵣₙ[nₑ] = train(𝐗ₜᵣₙ, 𝐃ₜᵣₙ, 𝐖)
        𝐗ₜᵣₙ, 𝐃ₜᵣₙ = shuffle_dataset(𝐗ₜᵣₙ, 𝐃ₜᵣₙ)
    end
    # test!
    global accₜₛₜ[nᵣ] = test(𝐗ₜₛₜ, 𝐃ₜₛₜ, 𝐖) # taxa de acerto TODO: ver como é isso em inglês

    # plot training dataset accuracy evolution
    local fig = plot(accₜᵣₙ, ylims=(0,2), label=["Disk Hernia" "Spondylolisthesis" "Normal"], xlabel="Epochs", ylabel="Hit rate", linewidth=2)
    println("\n\n$(accₜᵣₙ)\n\n")
    display(fig)
    savefig(fig, "figs/trab3 (single layer perceptron)/column - training dataset evolution for realization $(nᵣ).png")
end

display(plot(accₜₛₜ))

āc̄c̄ = Σ(accₜₛₜ)/Nᵣ # accuracy
𝔼acc² = Σ(accₜₛₜ.^2)/Nᵣ
σacc = sqrt.(𝔼acc² .- āc̄c̄.^2) # standard deviation

println("Accuracy: $(āc̄c̄)")
println("Standard deviation: $(σacc)")