using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings
Σ=sum

## load the data
𝐗, labels = FileIO.load("Dataset/Iris [uci]/iris.jld2", "𝐗", "𝐝") # 𝐗 ➡ [attributes X instances]
# PS choose only one!!!
# uncomment ↓ if you want to train for all attributes
𝐗 = [fill(-1, size(𝐗,2))'; 𝐗] # add the -1 input (bias)
# uncomment ↓ if you want to train for petal length and width (to plot the decision surface)
# 𝐗 = [fill(-1, size(𝐗,2))'; 𝐗[3:4,:]] # add the -1 input (bias)

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
        yₙ = φ(μₙ) # for the training phase, you do not pass yₙ to a harder decisor (the McCulloch and Pitts's activation function) since you are in intended to classify yₙ. Rather, you are interested in updating 𝐰 (???)
        eₙ = dₙ - yₙ
        𝐰 += α*eₙ*𝐱ₙ
        𝐞ₜᵣₙ[n] = eₙ
    end
    ϵₜᵣₙ = sum(𝐞ₜᵣₙ)/length(𝐞ₜᵣₙ) # the accuracy for this epoch
    return 𝐰, ϵₜᵣₙ
end

function test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝐰, is_confusion_matrix=false)
    φ = uₙ -> uₙ>0 ? 1 : 0 # activation function of the simple Perceptron
    𝐞ₜₛₜ = rand(length(𝐝ₜₛₜ)) # vector of errors
    for (n, (𝐱ₙ, dₙ)) ∈ enumerate(zip(eachcol(𝐗ₜₛₜ), 𝐝ₜₛₜ))
        μₙ = 𝐱ₙ⋅𝐰 # inner product
        yₙ = φ(μₙ) # for the simple Perceptron, yₙ ∈ {0,1}. Therefore, it is not necessary to pass yₙ to a harder decisor since φ(⋅) already does this job
        𝐞ₜₛₜ[n] = dₙ - yₙ
    end
    if !is_confusion_matrix # return the accuracy for this realization
        ϵₜₛₜ = sum(𝐞ₜₛₜ)/length(𝐞ₜₛₜ)
        return ϵₜₛₜ
    else
        return Int.(𝐞ₜₛₜ) # return the errors over the instances to plot the confusion matrix
    end
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
for (i, desired_label) ∈ enumerate(("setosa", "virginica", "versicolor"))
    local 𝐝 = labels.==desired_label # dₙ ∈ {0,1}
    𝛜ₜₛₜ = rand(Nᵣ) # vector that stores the error test dataset for each realization (to compute the final statistics)
    for nᵣ ∈ 1:Nᵣ # for each realization
        # initializing!
        𝛜ₜᵣₙ = rand(Nₑ) # vector that stores the error train dataset for each epoch (to see its evolution)
        global 𝐰 = ones(Nₐ) # initialize a new McCulloch-Pitts neuron (a new set of parameters)
        global 𝐗 # ?

        # prepare the data!
        𝐗, 𝐝 = shuffle_dataset(𝐗, 𝐝)
        # hould-out
        global 𝐗ₜᵣₙ = 𝐗[:,1:(N*Nₜᵣₙ)÷100]
        global 𝐝ₜᵣₙ = 𝐝[1:(N*Nₜᵣₙ)÷100]
        global 𝐗ₜₛₜ = 𝐗[:,length(𝐝ₜᵣₙ)+1:end]
        global 𝐝ₜₛₜ = 𝐝[length(𝐝ₜᵣₙ)+1:end]

        # train and test!
        for nₑ ∈ 1:Nₑ # for each epoch
            𝐰, 𝛜ₜᵣₙ[nₑ] = train(𝐗ₜᵣₙ, 𝐝ₜᵣₙ, 𝐰)
            𝐗ₜᵣₙ, 𝐝ₜᵣₙ = shuffle_dataset(𝐗ₜᵣₙ, 𝐝ₜᵣₙ)
        end
        𝛜ₜₛₜ[nᵣ] = test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝐰)
        
        # make plots!
        if nᵣ == 1
            all_𝐰ₒₚₜ[:,i] = 𝐰 # save the optimum value reached during the 1th realization for setosa, versicolor, and virginica
            # if all attributes was taken into account, compute the accuracyxepochs for all classes
            if length(𝐰) != 3
                local p = plot(𝛜ₜᵣₙ, label="", xlabel=L"Epochs", ylabel=L"\epsilon_n", linewidth=2, title="Training accuracy for $(desired_label) class by epochs")
                display(p)
                savefig(p, "figs/trab1 (simple perceptron)/epsilon_n-by-epochs-for$(desired_label).png")
                # for the setosa class, compute the confusion matrix
                if desired_label == "setosa"
                    𝐂 = zeros(2,2) # confusion matrix
                    𝐞ₜₛₜ = test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝐰, true)
                    for n ∈ 1:length(𝐞ₜₛₜ)
                        # predicted x true label
                        𝐂[𝐝ₜₛₜ[n]-𝐞ₜₛₜ[n]+1, 𝐝ₜₛₜ[n]+1] += 1
                    end
                    h = heatmap(𝐂, xlabel="Predicted labels", ylabel="True labels", xticks=(1:2, ("setosa", "not setosa")), yticks=(1:2, ("setosa", "not setosa")), title="Confusion matrix for the setosa class")
                    savefig(h, "figs/trab1 (simple perceptron)/setosa-heatmap.png")
                    display(h) # TODO: put the number onto each heatmap square
                end
            end
            # decision surface
            if length(𝐰) == 3 # plot the surface only if the learning procedure was taken with only two attributes, the petal length and petal width (equals to 3 because the bias)
                φ = uₙ -> uₙ≥0 ? 1 : 0 # activation function of the simple Perceptron
                x₃_range = floor(minimum(𝐗[2,:])):.1:ceil(maximum(𝐗[2,:]))
                x₄_range = floor(minimum(𝐗[3,:])):.1:ceil(maximum(𝐗[3,:]))
                y(x₃, x₄) = φ(dot([-1, x₃, x₄], 𝐰))
                p = surface(x₃_range, x₄_range, y, camera=(60,40,0), xlabel = "petal length", ylabel = "petal width", zlabel="decision surface")


                # scatter plot for the petal length and petal length width for the setosa class
                # train and desired label 
                scatter!(𝐗ₜᵣₙ[2,𝐝ₜᵣₙ.==1], 𝐗ₜᵣₙ[3,𝐝ₜᵣₙ.==1], ones(length(filter(x->x==1, 𝐝ₜᵣₙ))),
                        markershape = :hexagon,
                        markersize = 4,
                        markeralpha = 0.6,
                        markercolor = :green,
                        markerstrokewidth = 3,
                        markerstrokealpha = 0.2,
                        markerstrokecolor = :black,
                        xlabel = "petal\nlength",
                        ylabel = "petal width",
                        camera = (60,40,0),
                        label = "$(desired_label) train set")
                
                # test and desired label 
                scatter!(𝐗ₜₛₜ[2,𝐝ₜₛₜ.==1], 𝐗ₜₛₜ[3,𝐝ₜₛₜ.==1], ones(length(filter(x->x==1, 𝐝ₜₛₜ))),
                        markershape = :cross,
                        markersize = 4,
                        markeralpha = 0.6,
                        markercolor = :green,
                        markerstrokewidth = 3,
                        markerstrokealpha = 0.2,
                        markerstrokecolor = :black,
                        xlabel = "petal\nlength",
                        ylabel = "petal width",
                        camera = (60,40,0),
                        label = "$(desired_label) test set")

                # train and not desired label 
                scatter!(𝐗ₜᵣₙ[2,𝐝ₜᵣₙ.==0], 𝐗ₜᵣₙ[3,𝐝ₜᵣₙ.==0], zeros(length(filter(x->x==0, 𝐝ₜᵣₙ))),
                        markershape = :hexagon,
                        markersize = 4,
                        markeralpha = 0.6,
                        markercolor = :red,
                        markerstrokewidth = 3,
                        markerstrokealpha = 0.2,
                        markerstrokecolor = :black,
                        xlabel = "petal\nlength",
                        ylabel = "petal width",
                        camera = (60,40,0),
                        label = "not $(desired_label) train set")

                # test and not desired label 
                scatter!(𝐗ₜₛₜ[2,𝐝ₜₛₜ.==0], 𝐗ₜₛₜ[3,𝐝ₜₛₜ.==0], zeros(length(filter(x->x==0, 𝐝ₜₛₜ))),
                        markershape = :cross,
                        markersize = 4,
                        markeralpha = 0.6,
                        markercolor = :red,
                        markerstrokewidth = 3,
                        markerstrokealpha = 0.2,
                        markerstrokecolor = :black,
                        xlabel = "petal\nlength",
                        ylabel = "petal width",
                        camera = (60,40,0),
                        label = "not $(desired_label) test set")
                
                title!("Decision surface for the class $(desired_label)")
                display(p)
                savefig(p,"figs/trab1 (simple perceptron)/decision-surface-for-$(desired_label).png")
            end
        end
    end
    𝛜̄ₜₛₜ = sum(𝛜ₜₛₜ)/length(𝛜ₜₛₜ) # mean of the accuracy of all realizations
    𝔼𝛜² = Σ(𝛜ₜₛₜ.^2)/length(𝛜ₜₛₜ) # MSE (Mean squared erro), that is, the second moment of realization accuracies
    σ²ₑ = 𝔼𝛜² - 𝛜̄ₜₛₜ^2 # variance of all realization accuracies
    
    # save the performance
    all_𝛜̄ₜₛₜ[i] = 𝛜̄ₜₛₜ
    all_σ²ₑ[i] = σ²ₑ

end