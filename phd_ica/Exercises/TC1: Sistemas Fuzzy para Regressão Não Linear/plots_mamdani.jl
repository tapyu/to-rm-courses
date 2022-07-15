## Input analisys and delimiters
𝐱, 𝐲 = FileIO.load("TC1data.jld2", "x", "y") # 𝐱 -> Inputs; 𝐲 -> Outputs

# save plot of the input and output fuzzy sets
all_μx_A = hcat(map(input_fuzzyfication, 𝐱, fill(3, length(𝐱)))...)'
all_μy_B = hcat(map(output_fuzzyfication, range(minimum(𝐲), maximum(𝐲), length(𝐲)), fill(3, length(𝐲)))...)'
px = plot(𝐱, all_μx_A, linewidth=2, label=["LOW fuzzy set "*L"(A_1)" "MEDIUM fuzzy set "*L"(A_2)" "HIGH fuzzy set "*L"(A_3)"], xlabel =L"x_n", ylabel=L"\mu_A (x_n)")
py = plot(range(minimum(𝐲), maximum(𝐲), length(𝐲)), all_μy_B, linewidth=2, label=["LOW fuzzy set "*L"(B_1)" "MEDIUM fuzzy set "*L"(B_2)" "HIGH fuzzy set "*L"(B_3)"], xlabel =L"y_n", ylabel=L"\mu_B (y_n)")
savefig(px, "figs/mamdani_fuzzy/input_fuzzysets.png")
savefig(py, "figs/mamdani_fuzzy/output_fuzzysets.png")