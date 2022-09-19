using Plots

M = 10 # number of lamps
N = 15 # number of patches

#                                                     _
# |                                              *  | |
# |                        *                        | |
# |                                  *              |15m
# |       *                                         | |
# |                *                                | |
# |  *                                              | -
# |                                                 | |
# |                                                 |30m
# |                                                 | |
# |_________________________________________________| _
# |-----------------------30m-----------------------|

lamp_pos = [[30rand(), 20+15rand()] for _ in 1:M] # [width x height]
patch_angles = [(2π/4)*rand() - π/4 for _ in 1:N] # from -45 to 45

# plot lamps!
fig = scatter([tuple(i...) for i ∈ lamp_pos],
        markershape = :star,
        markersize = 4,
        markeralpha = 0.6,
        markercolor = :green,
        markerstrokewidth = 3,
        markerstrokealpha = 0.2,
        markerstrokecolor = :black,
        xlims = (0, 30),
        ylims = (0, 35+2),
        xlabel = "Height",
        ylabel = "Width",
        label = "lamps")

final_points = [rand(2) for _ ∈ 1:N]
middle_points = [rand(2) for _ ∈ 1:N]
# plot the patches!
for n in 1:N
    init_point = n==1 ? [0,0] : final_points[n-1]
    # prevent the patch from getting under the floor
    if init_point[2]+2tan(patch_angles[n]) < 0
        patch_angles[n] = -patch_angles[n]
    end
    final_points[n] = init_point + [2, 2tan(patch_angles[n])]
    middle_points[n] = init_point + [1, tan(patch_angles[n])]
    plot!([init_point[1], final_points[n][1]], [init_point[2], final_points[n][2]], label="", color=:black)

    for m ∈ 1:M
        plot!([middle_points[n][1], lamp_pos[m][1]], [middle_points[n][2], lamp_pos[m][2]], label="", color=:black)
    end
end

display(fig)