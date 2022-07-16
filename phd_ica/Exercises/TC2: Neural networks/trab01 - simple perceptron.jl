using FileIO, JLD2, Random, LinearAlgebra, Plots
Σ=sum

## load the data
𝐗 = FileIO.load("Dataset/Iris [uci]/iris.jld2", "𝐗") # 𝐗 ➡ [attributes X instances]

## useful functions
function shuffle_dataset(𝐗, 𝐝)
    shuffle_indices = Random.shuffle(1:size(𝐗,2))
    return 𝐗[:, shuffle_indices], 𝐝[shuffle_indices]
end

function train(𝐗ₜᵣₙ, 𝐝ₜᵣₙ, 𝐰)
    𝐞ₜᵣₙ = rand(N) # vector of errors
    φ = uₙ -> uₙ≥0 ? 1 : 0 # activation function of the simple Perceptron
    for (n, (𝐱ₙ, dₙ)) ∈ enumerate(zip(eachcol(𝐗ₜᵣₙ), 𝐝ₜᵣₙ))
        μₙ = 𝐱ₙ⋅𝐰 # inner product
        yₙ = φ(μₙ) # for the training phase, you do not pass yₙ to a harder decisor (the McCulloch and Pitts's activation function) since you are in intended to classify yₙ. Rather, you are interested in updating 𝐰
        eₙ = dₙ - yₙ
        𝐰 += α*eₙ*𝐱ₙ
        𝐞ₜᵣₙ[n] = eₙ
    end
    ϵₜᵣₙ = sum(𝐞ₜᵣₙ)/length(𝐞ₜᵣₙ) # the accuracy for this epoch
    return 𝐰, ϵₜᵣₙ
end

function test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝐰)
    φ = uₙ -> uₙ>0 ? 1 : 0 # activation function of the simple Perceptron
    𝐞ₜₛₜ = rand(N) # vector of errors
    for (n, (𝐱ₙ, dₙ)) ∈ enumerate(zip(eachcol(𝐗ₜₛₜ), 𝐝ₜₛₜ))
        μₙ = 𝐱ₙ⋅𝐰 # inner product
        yₙ = φ(μₙ) # for the simple Perceptron, yₙ ∈ {0,1}. Therefore, it is not necessary to pass yₙ to a harder decisor since φ(⋅) already does this job
        𝐞ₜₛₜ[n] = dₙ - yₙ
    end
    ϵₜₛₜ = sum(𝐞ₜₛₜ)/length(𝐞ₜₛₜ) # the accuracy for this realization
    return ϵₜₛₜ
end

## algorithm hyperparameters
Nᵣ = 20 # number of realizations
Nₐ = size(𝐗, 1) # =4 number of Attributes, that is, input vector size at each intance. They mean: sepal length, sepal width, petal length, petal width
N = size(𝐗, 2) # =150 number of instances(samples)
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
Nₑ = 100 # number of epochs
α = 0.01 # learning step

## init
all_𝛜̄ₜₛₜ, all_σ²ₑ = rand(3), rand(3)
for (i, desired_set) ∈ enumerate(("setosa", "virginica", "versicolor"))
    𝐝 = FileIO.load("Dataset/Iris [uci]/iris.jld2", "𝐝")
    𝐝 = 𝐝.==desired_set # dₙ ∈ {0,1}
    𝛜ₜₛₜ = rand(Nᵣ) # vector that stores the error test dataset for each realization (to compute the final statistics)
    for nᵣ ∈ 1:Nᵣ # for each realization
        𝛜ₜᵣₙ = rand(Nₑ) # vector that stores the error train dataset for each epoch (to see its evolution)
        global 𝐰 = rand(Nₐ) # initialize a new McCulloch-Pitts neuron (a new set of parameters)
        global 𝐗 # ?

        𝐗, 𝐝 = shuffle_dataset(𝐗, 𝐝)
        # hould-out
        global 𝐗ₜₛₜ = 𝐗[:,((N*Nₜᵣₙ)÷100+1):end]
        global 𝐝ₜₛₜ = 𝐝[((N*Nₜᵣₙ)÷100+1):end]
        𝐗ₜᵣₙ = 𝐗[:,1:(N*Nₜᵣₙ)÷100]
        𝐝ₜᵣₙ = 𝐝[1:(N*Nₜᵣₙ)÷100]
        for nₑ ∈ 1:Nₑ # for each epoch
            𝐰, 𝛜ₜᵣₙ[nₑ] = train(𝐗ₜᵣₙ, 𝐝ₜᵣₙ, 𝐰)
            𝐗ₜᵣₙ, 𝐝ₜᵣₙ = shuffle_dataset(𝐗ₜᵣₙ, 𝐝ₜᵣₙ)
        end
        𝛜ₜₛₜ[nᵣ] = test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝐰)
    end
    𝛜̄ₜₛₜ = sum(𝛜ₜₛₜ)/length(𝛜ₜₛₜ) # mean of the accuracy of all realizations
    𝔼𝛜² = Σ(𝛜ₜₛₜ.^2)/length(𝛜ₜₛₜ) # second moment of all realization accuracies
    σ²ₑ = 𝔼𝛜² - 𝛜̄ₜₛₜ^2 # variance of all realization accuracies
    
    # save the performance
    all_𝛜̄ₜₛₜ[i] = 𝛜̄ₜₛₜ
    all_σ²ₑ[i] = σ²ₑ

end

# versicolor set
𝐗ₜₛₜ_versicolor = 𝐗ₜₛₜ[1:2, 𝐝ₜₛₜ.==1]
𝐗ₜₛₜ_not_versicolor = 𝐗ₜₛₜ[1:2, 𝐝ₜₛₜ.!=1]
# filter(x -> x==1, )

p = scatter(𝐗ₜₛₜ_versicolor[1,:], 𝐗ₜₛₜ_versicolor[2,:],
        markershape = :hexagon,
        markersize = 4,
        markeralpha = 0.6,
        markercolor = :green,
        markerstrokewidth = 3,
        markerstrokealpha = 0.2,
        markerstrokecolor = :black,
        xlabel = "sepal length",
        ylabel = "sepal width",
        label = "Versicolor set")

scatter!(𝐗ₜₛₜ_not_versicolor[1,:], 𝐗ₜₛₜ_not_versicolor[2,:],
        markershape = :hexagon,
        markersize = 4,
        markeralpha = 0.6,
        markercolor = :red,
        markerstrokewidth = 3,
        markerstrokealpha = 0.2,
        markerstrokecolor = :black,
        xlabel = "sepal length",
        ylabel = "sepal width",
        label = "not Versicolor set")

display(p)