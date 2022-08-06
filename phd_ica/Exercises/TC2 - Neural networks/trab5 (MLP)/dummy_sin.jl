using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings, DataStructures
include("grid_search_cross_validation.jl")
Σ=sum
⊙ = .* # Hadamard product

N = 500
𝐱 = 1:N
𝐝 = x₍ₙ₎ -> 3sin(x₍ₙ₎)+1

function one_hot_encoding(label)
    return ["setosa", "virginica", "versicolor"].==label
end

function shuffle_dataset(𝐱, 𝐝)
    shuffle_indices = Random.shuffle(1:size(𝐗,2))
    return 𝐗[:, shuffle_indices], 𝐝[shuffle_indices]
end

function train(𝐱, 𝐝, 𝔚, φ, φʼ)
    L = length(𝔚) # number of layers
    for (x₍ₙ₎, d₍ₙ₎) ∈ zip(𝐱, 𝐝) # n-th instance
        # initialize the output and the vetor of gradients of each layer!
        𝔶₍ₙ₎ = OrderedDict([(l, rand(size(𝐖⁽ˡ⁾₍ₙ₎, 1))) for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚])  # output of the l-th layer at the instant n
        𝔶ʼ₍ₙ₎ = OrderedDict(𝔶₍ₙ₎) # diff of the output of the l-th layer at the instant n
        𝔡₍ₙ₎ = OrderedDict(𝔶₍ₙ₎) # all local gradients of all layers
        # forward phase!
        for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚 # l-th layer
            𝐯⁽ˡ⁾₍ₙ₎ = l==1 ? 𝐖⁽ˡ⁾₍ₙ₎*[-1; x₍ₙ₎] : 𝐖⁽ˡ⁾₍ₙ₎*[-1; 𝔶₍ₙ₎[l-1]] # induced local field
            𝔶₍ₙ₎[l] = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
            𝔶ʼ₍ₙ₎[l] = map(φʼ, 𝔶₍ₙ₎[l])
        end
        # backward phase!
        for l ∈ L:-1:1
            if l==L # output layer
                e₍ₙ₎ = [d₍ₙ₎] - 𝔶₍ₙ₎[L]
                y₍ₙ₎ = 𝔶₍ₙ₎[L][1]>.5 ? 1 : 0 # predicted value → get the result of the step function
                Nₑ = d₍ₙ₎==y₍ₙ₎ ? Nₑ : Nₑ+1 # count error if it occurs
                𝔡₍ₙ₎[L] = 𝔶ʼ₍ₙ₎[L] ⊙ e₍ₙ₎
            else # hidden layers
                𝔡₍ₙ₎[l] = 𝔶ʼ₍ₙ₎[l] ⊙ 𝔚[l+1][:,2:end]'*𝔡₍ₙ₎[l+1] # vector of local gradients of the l-th layer
            end
            𝔚[l] = l==1 ? 𝔚[l]+η*𝔡₍ₙ₎[l]*x₍ₙ₎' : 𝔚[l]+η*𝔡₍ₙ₎[l]*[-1; 𝔶₍ₙ₎[l-1]]' # learning equation
        end
    end
    return 𝔚 # trained neural network synaptic weights
end

function test(𝐱, 𝐝, 𝔚, φ, is_confusion_matrix=false)
    L = length(𝔚) # number of layers
    Nₑ = 0 # number of errors ➡ misclassification
    𝐲 = rand(length(𝐝))
    for (n, (x₍ₙ₎, d₍ₙ₎)) ∈ enumerate(zip(𝐱, 𝐝)) # n-th instance
        # initialize the output and the vetor of gradients of each layer!
        𝔶₍ₙ₎ = OrderedDict([(l, rand(size(𝐖⁽ˡ⁾₍ₙ₎, 1))) for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚])  # output of the l-th layer at the instant n
        # forward phase!
        for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚 # l-th layer
            𝐯⁽ˡ⁾₍ₙ₎ = l==1 ? 𝐖⁽ˡ⁾₍ₙ₎*[-1; x₍ₙ₎] : 𝐖⁽ˡ⁾₍ₙ₎*[-1; 𝔶₍ₙ₎[l-1]] # induced local field
            𝔶₍ₙ₎[l] = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
            if l==L # output layer
                𝐲[n] = 𝔶₍ₙ₎[L][1]>.5 ? 1 : 0 # predicted value → get the result of the step function
                Nₑ = d₍ₙ₎==𝐲[n] ? Nₑ : Nₑ+1 # count error if it occurs
            end
        end
    end
    
    if is_confusion_matrix
        return Int.(𝐲)
    else
        return (length(𝐝)-Nₑ)/length(𝐝)
    end
end

## algorithm parameters and hyperparameters
N = 200 # number of instances
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
Nₐ = 1 # number of number of attributes (only x(n))
Nᵣ = 20 # number of realizations
Nₑ = 100 # number of epochs
m₂ = 1 # regression problem
η = 2 # learning step


## init
𝛍ₜₛₜ = fill(NaN, Nᵣ) # vector of accuracies for test dataset
for nᵣ ∈ 1:Nᵣ
    # prepare the data!
    global 𝐱, 𝐝 = shuffle_dataset(𝐱, 𝐝)
    # hould-out
    𝐱ₜᵣₙ = 𝐱[:,1:(N*Nₜᵣₙ)÷100]
    𝐝ₜᵣₙ = 𝐝[1:(N*Nₜᵣₙ)÷100]
    𝐱ₜₛₜ = 𝐱[:,length(𝐝ₜᵣₙ)+1:end]
    𝐝ₜₛₜ = 𝐝[length(𝐝ₜᵣₙ)+1:end]

    # grid search with k-fold cross validation!
    (m₁, (φ, φʼ, a)) = grid_search_cross_validation(𝐱ₜᵣₙ, 𝐝ₜᵣₙ, 10, (1:3, ((v₍ₙ₎ -> 1/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> y₍ₙ₎*(1-y₍ₙ₎), 1), (v₍ₙ₎ -> (1-ℯ^(-v₍ₙ₎))/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> .5(1-y₍ₙ₎^2), 2), (v₍ₙ₎ -> v₍ₙ₎>0 ? 1 : 0, y₍ₙ₎ -> 1, 3))))
    println("For the realization $(nᵣ)")
    println("best m₁: $(m₁)")
    println("best φ: $(a==1 ? "logistic" : (a==2 ? "Hyperbolic" : "Mcculloch and pitts"))")
    
    # initialize!
    𝔚 = OrderedDict(1 => rand(m₁, Nₐ+1), 2 => rand(m₂, m₁+1)) # 1 => first layer (hidden layer) 2 => second layer 
    𝛍ₜᵣₙ = fill(NaN, Nₑ) # vector of accuracies for train dataset (to see its evolution during training phase)

    # train!
    for nₑ ∈ 1:Nₑ # for each epoch
        𝔚, 𝛍ₜᵣₙ[nₑ] = train(𝐱ₜᵣₙ, 𝐝ₜᵣₙ, 𝔚, φ, φʼ)
        𝐱ₜᵣₙ, 𝐝ₜᵣₙ = shuffle_dataset(𝐱ₜᵣₙ, 𝐝ₜᵣₙ)
    end
    # test!
    global 𝛍ₜₛₜ[nᵣ] = test(𝐱ₜₛₜ, 𝐝ₜₛₜ, 𝔚, φ) # accuracy for this realization
end