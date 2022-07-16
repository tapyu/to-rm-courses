using FileIO, JLD2, Random, LinearAlgebra, Plots
Σ=sum

## load the data
𝐗, labels = FileIO.load("Dataset/Iris [uci]/iris.jld2", "𝐗", "𝐝") # 𝐗 ➡ [attributes X instances]
# PS choose only one!!!
# uncomment ↓ if you want to train for all attributes
# 𝐗 = [fill(-1, size(𝐗,2))'; 𝐗] # add the -1 input (bias)
# uncomment ↓ if you want to train for petal length and width (to plot the decision surface)
𝐗 = [fill(-1, size(𝐗,2))'; 𝐗[3:4,:]] # add the -1 input (bias)

## useful functions
function shuffle_dataset(𝐗, 𝐝)
    shuffle_indices = Random.shuffle(1:size(𝐗,2))
    return 𝐗[:, shuffle_indices], 𝐝[shuffle_indices]
end

function train(𝐗ₜᵣₙ, 𝐝ₜᵣₙ, 𝐰)
    𝐞ₜᵣₙ = rand(length(𝐝ₜᵣₙ)) # vector of errors
    φ = uₙ -> uₙ≥0 ? 1 : 0 # activation function of the simple Perceptron
    for (n, (𝐱ₙ, dₙ)) ∈ enumerate(zip(eachcol(𝐗ₜᵣₙ), 𝐝ₜᵣₙ))
        μₙ = dot(𝐱ₙ,𝐰) # inner product
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
    𝐞ₜₛₜ = rand(length(𝐝ₜₛₜ)) # vector of errors
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
Nₐ = size(𝐗, 1) # =5 (including bias) number of Attributes, that is, input vector size at each intance. They mean: sepal length, sepal width, petal length, petal width
N = size(𝐗, 2) # =150 number of instances(samples)
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
Nₑ = 100 # number of epochs
α = 0.01 # learning step

## init
all_𝛜̄ₜₛₜ, all_σ²ₑ, all_𝐰ₒₚₜ = rand(3), rand(3), rand(Nₐ,3)
for (i, desired_set) ∈ enumerate(("setosa", "virginica", "versicolor"))
    local 𝐝 = labels.==desired_set # dₙ ∈ {0,1}
    𝛜ₜₛₜ = rand(Nᵣ) # vector that stores the error test dataset for each realization (to compute the final statistics)
    for nᵣ ∈ 1:Nᵣ # for each realization
        𝛜ₜᵣₙ = rand(Nₑ) # vector that stores the error train dataset for each epoch (to see its evolution)
        global 𝐰 = ones(Nₐ) # initialize a new McCulloch-Pitts neuron (a new set of parameters)
        global 𝐗 # ?

        𝐗, 𝐝 = shuffle_dataset(𝐗, 𝐝)
        # hould-out
        𝐗ₜᵣₙ = 𝐗[:,1:(N*Nₜᵣₙ)÷100]
        𝐝ₜᵣₙ = 𝐝[1:(N*Nₜᵣₙ)÷100]
        global 𝐗ₜₛₜ = 𝐗[:,length(𝐝ₜᵣₙ)+1:end]
        global 𝐝ₜₛₜ = 𝐝[length(𝐝ₜᵣₙ)+1:end]
        for nₑ ∈ 1:Nₑ # for each epoch
            𝐰, 𝛜ₜᵣₙ[nₑ] = train(𝐗ₜᵣₙ, 𝐝ₜᵣₙ, 𝐰)
            𝐗ₜᵣₙ, 𝐝ₜᵣₙ = shuffle_dataset(𝐗ₜᵣₙ, 𝐝ₜᵣₙ)
        end
        𝛜ₜₛₜ[nᵣ] = test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝐰)
        if nᵣ == 1
            all_𝐰ₒₚₜ[:,i] = 𝐰 # save the optimum value reached during the 1th realization for setosa, versicolor, and virginica
            local p = plot(𝛜ₜᵣₙ)
            display(p)
        end
    end
    𝛜̄ₜₛₜ = sum(𝛜ₜₛₜ)/length(𝛜ₜₛₜ) # mean of the accuracy of all realizations
    𝔼𝛜² = Σ(𝛜ₜₛₜ.^2)/length(𝛜ₜₛₜ) # second moment of all realization accuracies
    σ²ₑ = 𝔼𝛜² - 𝛜̄ₜₛₜ^2 # variance of all realization accuracies
    
    # save the performance
    all_𝛜̄ₜₛₜ[i] = 𝛜̄ₜₛₜ
    all_σ²ₑ[i] = σ²ₑ

end

## plot setosa set decision surface
𝐝 = labels.=="setosa" # dₙ ∈ {0,1}
𝐗, labels = FileIO.load("Dataset/Iris [uci]/iris.jld2", "𝐗", "𝐝") # 𝐗 ➡ [attributes X instances]
𝐗_setosa = 𝐗[:, 𝐝.==1]
𝐗_not_setosa = 𝐗[:, 𝐝.!=1]

# surface decision
𝐰ₒₚₜ⁽ˢ⁾ = all_𝐰ₒₚₜ[:, 1] # optimum weights for the setosa dataset (only for the third and fourth attributes, that is, for petal length and petal width)
if length(𝐰ₒₚₜ⁽ˢ⁾) == 3 # plot the surface only if the learning procedure was taken with only two attributes, the petal length and petal width (equals to 3 because the bias)
    φ = uₙ -> uₙ≥0 ? 1 : 0 # activation function of the simple Perceptron
    x₃_range = floor(minimum(𝐗[3,:])):.1:ceil(maximum(𝐗[3,:]))
    x₄_range = floor(minimum(𝐗[4,:])):.1:ceil(maximum(𝐗[4,:]))
    y(x₃, x₄) = φ(dot([-1, x₃, x₄], 𝐰ₒₚₜ⁽ˢ⁾))
    p = surface(x₃_range, x₄_range, y, camera=(60,40,0), xlabel = "petal length", ylabel = "petal width", zlabel="decision surface")


    # scatter plot for the petal length and petal length width for the setosa class
    scatter!(𝐗_setosa[3,:], 𝐗_setosa[4,:], ones(length(𝐗_setosa[4,:])),
            markershape = :hexagon,
            markersize = 4,
            markeralpha = 0.6,
            markercolor = :green,
            markerstrokewidth = 3,
            markerstrokealpha = 0.2,
            markerstrokecolor = :black,
            xlabel = "petal length",
            ylabel = "petal width",
            camera = (60,40,0),
            label = "setosa set")

    scatter!(𝐗_not_setosa[3,:], 𝐗_not_setosa[4,:], zeros(length(𝐗_not_setosa[4,:])),
            markershape = :hexagon,
            markersize = 4,
            markeralpha = 0.6,
            markercolor = :red,
            markerstrokewidth = 3,
            markerstrokealpha = 0.2,
            markerstrokecolor = :black,
            xlabel = "petal length",
            ylabel = "petal width",
            label = "not setosa set")
            
    display(p)
end