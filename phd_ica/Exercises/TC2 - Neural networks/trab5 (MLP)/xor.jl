using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings, DataStructures
Σ=sum
⊙ = .* # Hadamard product

function one_hot_encoding(label)
    return ["setosa", "virginica", "versicolor"].==label
end

function shuffle_dataset(𝐗, 𝐝)
    shuffle_indices = Random.shuffle(1:size(𝐗,2))
    return 𝐗[:, shuffle_indices], 𝐝[shuffle_indices]
end

function train(𝐗, 𝐝, 𝔚, φ, φʼ)
    L = length(𝔚) # number of layers
    Nₑ = 0 # number of errors ➡ misclassifications
    for (𝐱₍ₙ₎, d₍ₙ₎) ∈ zip(eachcol(𝐗), 𝐝) # n-th instance
        # initialize the output and the vetor of gradients of each layer!
        𝔶₍ₙ₎ = OrderedDict([(l, rand(size(𝐖⁽ˡ⁾₍ₙ₎, 1))) for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚])  # output of the l-th layer at the instant n
        𝔶ʼ₍ₙ₎ = OrderedDict(𝔶₍ₙ₎) # diff of the output of the l-th layer at the instant n
        𝔡₍ₙ₎ = OrderedDict(𝔶₍ₙ₎) # all local gradients of all layers
        # forward phase!
        for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚 # l-th layer
            𝐯⁽ˡ⁾₍ₙ₎ = l==1 ? 𝐖⁽ˡ⁾₍ₙ₎*𝐱₍ₙ₎ : 𝐖⁽ˡ⁾₍ₙ₎*[-1; 𝔶₍ₙ₎[l-1]] # induced local field
            𝔶₍ₙ₎[l] = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
            𝔶ʼ₍ₙ₎[l] = map(φʼ, 𝔶₍ₙ₎[l])
        end
        # backward phase!
        for l ∈ L:-1:1
            if l==L # output layer
                e₍ₙ₎ = [d₍ₙ₎] - 𝔶₍ₙ₎[L]
                d̂₍ₙ₎ = 𝔶₍ₙ₎[L][1]>.5 ? 1 : 0 # predicted value → get the result of the step function
                Nₑ = d₍ₙ₎==d̂₍ₙ₎ ? Nₑ : Nₑ+1 # count error if it occurs
                𝔡₍ₙ₎[L] = 𝔶ʼ₍ₙ₎[L] ⊙ e₍ₙ₎
            else # hidden layers
                𝔡₍ₙ₎[l] = 𝔶ʼ₍ₙ₎[l] ⊙ 𝔚[l+1][:,2:end]'*𝔡₍ₙ₎[l+1] # vector of local gradients of the l-th layer
            end
            𝔚[l] = l==1 ? 𝔚[l]+η*𝔡₍ₙ₎[l]*𝐱₍ₙ₎' : 𝔚[l]+η*𝔡₍ₙ₎[l]*[-1; 𝔶₍ₙ₎[l-1]]' # learning equation
        end
    end
    return 𝔚, (size(𝐝,2)-Nₑ)/size(𝐝,2) # trained neural network synaptic weights and its accuracy
end

function test(𝐗, 𝐝, 𝔚, φ)
    L = length(𝔚) # number of layers
    Nₑ = 0 # number of errors ➡ misclassification
    for (𝐱₍ₙ₎, d₍ₙ₎) ∈ zip(eachcol(𝐗), eachcol(𝐝)) # n-th instance
        # initialize the output and the vetor of gradients of each layer!
        𝔶₍ₙ₎ = OrderedDict([(l, rand(size(𝐖⁽ˡ⁾₍ₙ₎, 1))) for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚])  # output of the l-th layer at the instant n
        # forward phase!
        for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚 # l-th layer
            𝐯⁽ˡ⁾₍ₙ₎ = l==1 ? 𝐖⁽ˡ⁾₍ₙ₎*𝐱₍ₙ₎ : 𝐖⁽ˡ⁾₍ₙ₎*[-1; 𝔶₍ₙ₎[l-1]] # induced local field
            𝔶₍ₙ₎[l] = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
            if l==L # output layer
                d̂₍ₙ₎ = 𝔶₍ₙ₎[L][1]>.5 ? 1 : 0 # predicted value → get the result of the step function
                Nₑ = d₍ₙ₎==d̂₍ₙ₎ ? Nₑ : Nₑ+1 # count error if it occurs
            end
        end
    end
    return (length(𝐝)-Nₑ)/length(𝐝)
end

## algorithm parameters and hyperparameters
K = 2 # number of classes (1 and 0)
N = 200 # number of instances
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
Nₐ = 2 # number of number of attributes (x₁ and x₂)
Nᵣ = 20 # number of realizations
Nₑ = 100 # number of epochs
m₂ = 1 # number of perceptrons (neurons) of the output layer (only one since it is enough to classify 0 or 1)
m₁ = 2 # number of perceptrons on the hidden layer (a hyperparameter that will the replaced by the kfcv)
η = 0.1 # learning step

𝐗 = [fill(-1, N)'; fill(0, 100)' fill(1, 100)'; fill(1, 50)' fill(0, 100)' fill(1, 50)']
𝐝 = map(x -> x[2] ⊻ x[3], eachcol(𝐗))

## init
𝛍ₜₛₜ = fill(NaN, Nᵣ) # vector of accuracies for test dataset
for nᵣ ∈ 1:Nᵣ
    # initialize!
    𝔚 = OrderedDict(1 => rand(m₁, Nₐ+1), 2 => rand(m₂, m₁+1)) # 1 => first layer (hidden layer) 2 => second layer 
    𝛍ₜᵣₙ = fill(NaN, Nₑ) # vector of accuracies for train dataset (to see its evolution during training phase)

    # prepare the data!
    global 𝐗, 𝐝 = shuffle_dataset(𝐗, 𝐝)
    # hould-out
    𝐗ₜᵣₙ = 𝐗[:,1:(N*Nₜᵣₙ)÷100]
    𝐝ₜᵣₙ = 𝐝[1:(N*Nₜᵣₙ)÷100]
    𝐗ₜₛₜ = 𝐗[:,size(𝐝ₜᵣₙ, 2)+1:end]
    𝐝ₜₛₜ = 𝐝[size(𝐝ₜᵣₙ, 2)+1:end]

    # train!
    for nₑ ∈ 1:Nₑ # for each epoch
        𝔚, 𝛍ₜᵣₙ[nₑ] = train(𝐗ₜᵣₙ, 𝐝ₜᵣₙ, 𝔚, u₍ₙ₎ -> 1/(1+ℯ^(-u₍ₙ₎)), y₍ₙ₎ -> y₍ₙ₎*(1-y₍ₙ₎))
        𝐗ₜᵣₙ, 𝐝ₜᵣₙ = shuffle_dataset(𝐗ₜᵣₙ, 𝐝ₜᵣₙ)
    end
    # test!
    global 𝛍ₜₛₜ[nᵣ] = test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝔚, u₍ₙ₎ -> 1/(1+ℯ^(-u₍ₙ₎))) # accuracy for this realization
    
    # plot training dataset accuracy evolution
    local fig = plot(𝛍ₜᵣₙ, xlabel="Epochs", ylabel="Accuracy", linewidth=2)
    savefig(fig, "trab5 (MLP)/figs/xor - training dataset accuracy evolution for realization $(nᵣ).png")
    
    if nᵣ == 1 # make heatmap plot!
        ## predictor of the class (basically it is what is done on test(), but only with the attributes as inputs)
        y = function predict(x₁, x₂)
            φ = u₍ₙ₎ -> 1/(1+ℯ^(-u₍ₙ₎)) # logistic function
            𝔶₍ₙ₎ = OrderedDict([(l, rand(size(𝐖⁽ˡ⁾₍ₙ₎, 1))) for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚])
            L = length(𝔚)
            𝐱₍ₙ₎ = [-1, x₁, x₂]
            for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚 # l-th layer
                𝐯⁽ˡ⁾₍ₙ₎ = l==1 ? 𝐖⁽ˡ⁾₍ₙ₎*𝐱₍ₙ₎ : 𝐖⁽ˡ⁾₍ₙ₎*[-1; 𝔶₍ₙ₎[l-1]] # induced local field
                𝔶₍ₙ₎[l] = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
                if l==L # output layer
                    return 𝔶₍ₙ₎[L][1]>.5 ? 1 : 0
                end
            end
        end
        
        # plot heatmap for the 1th realization
        x₁_range = -1:.1:2
        x₂_range = -1:.1:2
        
        fig = contour(x₁_range, x₂_range, y, xlabel = L"x_1", ylabel = L"x_2", fill=true, levels=1)
        
        # train 0 label
        scatter!(𝐗ₜᵣₙ[2, 𝐝ₜᵣₙ.==0], 𝐗ₜᵣₙ[3, 𝐝ₜᵣₙ.==0], markershape = :hexagon, markersize = 8, markeralpha = 0.6, markercolor = :green, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "0 label [train]")
        
        # test 0 label
        scatter!(𝐗ₜₛₜ[2, 𝐝ₜₛₜ.==0], 𝐗ₜₛₜ[3, 𝐝ₜₛₜ.==0], markershape = :dtriangle, markersize = 8, markeralpha = 0.6, markercolor = :green, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "0 label [test]")
        
        # train 1 label
        scatter!(𝐗ₜᵣₙ[2, 𝐝ₜᵣₙ.==1], 𝐗ₜᵣₙ[3, 𝐝ₜᵣₙ.==1], markershape = :hexagon, markersize = 8, markeralpha = 0.6, markercolor = :white, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "1 label [train]")
            
        # test 1 label
        scatter!(𝐗ₜₛₜ[2, 𝐝ₜₛₜ.==1], 𝐗ₜₛₜ[3, 𝐝ₜₛₜ.==1], markershape = :dtriangle, markersize = 8, markeralpha = 0.6, markercolor = :white, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "1 label [test]")
        
        title!("Heatmap")
        savefig(fig, "trab5 (MLP)/figs/XOR problem - heatmap.png")
    end
end

# analyze the accuracy statistics of each independent realization
μ̄ₜₛₜ = Σ(𝛍ₜₛₜ)/Nᵣ # mean
𝔼μ² = Σ(𝛍ₜₛₜ.^2)/Nᵣ
σμ = sqrt(𝔼μ² - μ̄ₜₛₜ^2) # standard deviation

println("Mean: $(μ̄ₜₛₜ)")
println("Standard deviation: $(σμ)")