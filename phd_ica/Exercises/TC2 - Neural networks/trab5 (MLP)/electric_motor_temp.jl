using CSV, DataFrames, Random, DataStructures, Plots
Σ=sum
⊙ = .* # Hadamard product

df = CSV.read("../Datasets/Electric Motor Temperature [kaggle]/measures_v2.csv", DataFrame)

## load the dataset!
# motor_speed ➡ Motor speed (in rpm)
# torque ➡ Motor torque (in Nm)
𝐃 = [df.torque df.motor_speed]'

# u_q               ➡ Voltage q-component measurement in dq-coordinates (in V)
# u_d               ➡ Voltage d-component measurement in dq-coordinates
# i_q               ➡ Current q-component measurement in dq-coordinates
# i_d               ➡ Current d-component measurement in dq-coordinates
# coolant           ➡ Coolant temperature (in °C)
# stator_winding    ➡ Stator winding temperature (in °C) measured with thermocouples
# stator_tooth      ➡ Stator tooth temperature (in °C) measured with thermocouples
# pm                ➡ Permanent magnet temperature (in °C) measured with thermocouples and transmitted wirelessly via a thermography unit.
# stator_yoke       ➡ Stator yoke temperature (in °C) measured with thermocouples
# ambient           ➡ Ambient temperature (in °C)
𝐗 = [df.u_q df.u_d df.i_q df.i_d df.coolant df.stator_winding df.stator_tooth df.pm df.stator_yoke df.ambient]'

## algorithm parameters and hyperparameters
N = 1_330_816 # number of instances (wtf...)
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
Nₐ = 10 # number of number of attributes
Nᵣ = 20 # number of realizations
Nₑ = 100 # number of epochs
m₂ = 2 # number of perceptrons (neurons) of the output layer ➡ number of variables for regression
η = 0.1 # learning step

## Standardize dataset (Preprocessing)
𝛍ₓ = Σ(𝐗, dims=2)/N # mean vector
𝔼μ² = Σ(𝐗.^2, dims=2)/N # vector of the second moment of 𝐗
σμ = sqrt.(𝔼μ² - 𝛍ₓ.^2) # vector of the standard deviation
𝐗 = (𝐗 .- 𝛍ₓ)./σμ # zero mean and unit variance
𝐗 = [fill(-1, size(𝐗,2))'; 𝐗] # add the -1 input (bias)

function one_hot_encoding(label)
    return 1:6 .== label
end

function shuffle_dataset(𝐗, 𝐃)
    shuffle_indices = Random.shuffle(1:size(𝐗,2))
    return ndims(𝐃)==1 ? (𝐗[:, shuffle_indices], 𝐃[shuffle_indices]) : 𝐗[:, shuffle_indices], 𝐃[:, shuffle_indices]
end

function train(𝐗, 𝐃, 𝔚, φ, φʼ)
    L = length(𝔚) # number of layers
    N = size(𝐃, 2) # number of samples for the training dataset
    𝐄 = rand(size(𝐃)...) # matrix with all errors
    for (n, (𝐱₍ₙ₎, 𝐝₍ₙ₎)) ∈ enumerate(zip(eachcol(𝐗), eachcol(𝐃))) # n-th instance
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
                𝐞₍ₙ₎ = 𝐝₍ₙ₎ - 𝔶₍ₙ₎[L]
                𝐄[:, n] = 𝐞₍ₙ₎
                𝔡₍ₙ₎[L] = 𝔶ʼ₍ₙ₎[L] ⊙ 𝐞₍ₙ₎
            else # hidden layers
                𝔡₍ₙ₎[l] = 𝔶ʼ₍ₙ₎[l] ⊙ 𝔚[l+1][:,2:end]'*𝔡₍ₙ₎[l+1] # vector of local gradients of the l-th layer
            end
            𝔚[l] = l==1 ? 𝔚[l]+η*𝔡₍ₙ₎[l]*𝐱₍ₙ₎' : 𝔚[l]+η*𝔡₍ₙ₎[l]*[-1; 𝔶₍ₙ₎[l-1]]' # learning equation
        end
    end

    RMSE = sqrt.(Σ(𝐄.^2, dims=2)./N)
    return 𝔚, RMSE # trained neural network synaptic weights and its RMSE
end

function test(𝐗, 𝐃, 𝔚, φ)
    L = length(𝔚) # number of layers
    N = size(𝐃, 2) # number of samples for the training dataset
    𝐄 = rand(size(𝐃)...) # matrix with all errors
    for (n, (𝐱₍ₙ₎, 𝐝₍ₙ₎)) ∈ enumerate(zip(eachcol(𝐗), eachcol(𝐃))) # n-th instance
        # initialize the output and the vetor of gradients of each layer!
        𝔶₍ₙ₎ = OrderedDict([(l, rand(size(𝐖⁽ˡ⁾₍ₙ₎, 1))) for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚])  # output of the l-th layer at the instant n
        # forward phase!
        for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚 # l-th layer
            𝐯⁽ˡ⁾₍ₙ₎ = l==1 ? 𝐖⁽ˡ⁾₍ₙ₎*𝐱₍ₙ₎ : 𝐖⁽ˡ⁾₍ₙ₎*[-1; 𝔶₍ₙ₎[l-1]] # induced local field
            𝔶₍ₙ₎[l] = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
            l==L && (𝐄[:, n] = 𝐝₍ₙ₎ - 𝔶₍ₙ₎[L])
        end
    end
    RMSE = sqrt.(Σ(𝐄.^2, dims=2)./N)
    return RMSE # RMSE of the test dataset
end

## init
𝚳ₜₛₜ = rand(2, Nᵣ) # vector of RMSE's for test dataset
for nᵣ ∈ 1:Nᵣ
    println("Init realization $(nᵣ)")
    # prepare the data!
    global 𝐗, 𝐃 = shuffle_dataset(𝐗, 𝐃)
    # hould-out
    𝐗ₜᵣₙ = 𝐗[:,1:(N*Nₜᵣₙ)÷100]
    𝐃ₜᵣₙ = 𝐃[:,1:(N*Nₜᵣₙ)÷100]
    𝐗ₜₛₜ = 𝐗[:,size(𝐃ₜᵣₙ, 2)+1:end]
    𝐃ₜₛₜ = 𝐃[:,size(𝐃ₜᵣₙ, 2)+1:end]
    # print("𝐗ₜᵣₙ: $(size(𝐗ₜᵣₙ))\n𝐗ₜₛₜ: $(size(𝐗ₜₛₜ))")
    
    # grid search with k-fold cross validation! (that is not possible for a dataset with 1 million instances!)
    # (m₁, (φ, φʼ, a)) = grid_search_cross_validation(𝐗ₜᵣₙ, 𝐃ₜᵣₙ, 10, (33:38, ((v₍ₙ₎ -> 1/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> y₍ₙ₎*(1-y₍ₙ₎), 1), (v₍ₙ₎ -> (1-ℯ^(-v₍ₙ₎))/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> .5(1-y₍ₙ₎^2), 2))))
    (m₁, (φ, φʼ, a)) = (12, (v₍ₙ₎ -> 1/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> y₍ₙ₎*(1-y₍ₙ₎), 1))
    # println("For the realization $(nᵣ)")
    # println("best m₁: $(m₁)")
    # println("best φ: $(a==1 ? "logistic" : "Hyperbolic")")
    
    # initialize!
    𝔚 = OrderedDict(1 => rand(m₁, Nₐ+1), 2 => rand(m₂, m₁+1)) # 1 => first (hidden) layer 2 => second (output) layer 
    𝚳ₜᵣₙ = rand(2, Nₑ) # vector of accuracies for train dataset (to see its evolution during training phase)
    
    # train!
    for nₑ ∈ 1:Nₑ # for each epoch
        𝔚, 𝚳ₜᵣₙ[:, nₑ] = train(𝐗ₜᵣₙ, 𝐃ₜᵣₙ, 𝔚, φ, φʼ)
        𝐗ₜᵣₙ, 𝐃ₜᵣₙ = shuffle_dataset(𝐗ₜᵣₙ, 𝐃ₜᵣₙ)
    end
    # test!
    global 𝚳ₜₛₜ[:, nᵣ] = test(𝐗ₜₛₜ, 𝐃ₜₛₜ, 𝔚, φ) # accuracy for this realization
    
    # plot training dataset accuracy evolution
    local fig = plot(𝚳ₜᵣₙ', ylims=(0,2), xlabel="Epochs", ylabel="Accuracy", linewidth=2)
    savefig(fig, "figs/electric-motor-temp - training dataset RMSE evolution for realization $(nᵣ).png")
end

# analyze the accuracy statistics of each independent realization
𝔼𝚳ₜₛₜ = Σ(𝚳ₜₛₜ, 2)./Nᵣ # mean vector of torque and speed motor
𝔼𝚳ₜₛₜ² = Σ(𝚳ₜₛₜ.^2)./Nᵣ # second moment of both features
σ𝚳ₜₛₜ = sqrt.(𝔼𝚳ₜₛₜ² .- 𝔼𝚳ₜₛₜ.^2) # standard deviation vector of torque and speed motor

println("* Mean RMSE ➡ for the torque: $(𝔼𝚳ₜₛₜ[1])\n➡ for the speed motor: $(𝔼𝚳ₜₛₜ[2])")
println("* Standard deviation ➡ for the torque: $(σ𝚳ₜₛₜ[1])\n➡ for the speed motor: $(σ𝚳ₜₛₜ[2])")