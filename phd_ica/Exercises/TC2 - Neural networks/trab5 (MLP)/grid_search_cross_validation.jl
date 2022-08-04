using Random

function grid_search_cross_validation(𝐗, 𝐃, K, hyperparameters)
    # 𝐗 ➡ the dataset without the test instances [attributes X instances]
    # K ➡ number of folds
    # hyperparameters ➡ vector of vector of all hyperparameters

    𝐗 = 𝐗[shuffle(1:end), :] # shuffle dataset
    𝐗 = [fill(-1, size(𝐗,2))'; 𝐗] # add the -1 input (bias)

    𝓧 = reshape(𝐗, size(𝐗,1), K, :) # split the dataset into K folds

    e_best = Inf # mean accuracy of the best set of hyperparameters (begin as Inf)
    best_set_of_hyperparameter = Any
    for set_of_hyperparameter ∈ Iterators.product(hyperparameters...)
        m₁ = set_of_hyperparameter[1] # number of neurons of the hidden layer (hyperparameter)
        m₂ = size(𝐃, 1) # number of neurons on the output layer = number of outputs
        φ = set_of_hyperparameter[2] # activation function

        𝐞 = rand(K) # the accuracy for each fold
        for k ∈ 1:K

            𝔚 = Dict(1 => rand(m₁, size(𝐗,1)), 2 => rand(m₂, m₁+1)) # 1 => first layer (hidden layer) 2 => second layer (output layer)
            𝐗ₜᵣₙ = 𝓧[:,:,1:end.!=k] # train dataset
            𝐗ₜᵣₙ = reshape(𝐗ₜᵣₙ, size(𝐗ₜᵣₙ, 1), :)

            𝐗ᵥₐₗ = 𝓧[:,:,k] # validation dataset

            for _ ∈ 1:Nₑ
                𝐗ₜᵣₙ = 𝐗ₜᵣₙ[shuffle(1:end), :] # shuffle dataset
                𝔚 = train(𝐗ₜᵣₙ, 𝔚, φ)
            end
            𝐞[k] = test(𝐗ᵥₐₗ, 𝔚, φ)
        end

        e_set = sum(𝐞)/length(𝐞) # mean accuracy for this set of hyperparameters

        if e_set < e_best
            global e_best = e_set
            global best_set_of_hyperparameter = set_of_hyperparameter
        end

    end

    return best_set_of_hyperparameter
    
end