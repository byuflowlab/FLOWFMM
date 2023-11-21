include("../test/gravitational.jl")
using BenchmarkTools
using Random
using WriteVTK

function generate_gravitational(seed, n_bodies; radius_factor=0.1)
    Random.seed!(123)
    bodies = rand(8,n_bodies)
    # bodies[1:3,3] .=  0.811770914672987, 0.15526131946379113, 0.30656077208169424
    # bodies[1:3,3] .=   0.7427186184997012, 0.2351893322824516, 0.3380666354208596
    bodies[4,:] ./= (n_bodies^(1/3)*2)
    bodies[4,:] .*= radius_factor
    system = Gravitational(bodies)
end

function bm_fmm()
    expansion_order, n_per_branch, theta = 5, 100, 0.4
    n_bodies = 5000
    system = generate_gravitational(123, n_bodies)
    # tree = fmm.Tree(system; expansion_order, n_per_branch, shrink_recenter=true)
    fmm.fmm!(system; expansion_order=expansion_order, n_per_branch=n_per_branch, theta=theta, nearfield=true, farfield=true, unsort_bodies=true, shrink_recenter=false)
    return nothing
end

function bm_direct()    
    n_bodies = 5000
    system2 = generate_gravitational(123, n_bodies)
    fmm.direct!(system2, 1:n_bodies, system2, 1:n_bodies)
    return sum(system2.potential)
end

function bm_fmm_accuracy(expansion_order, n_per_branch, theta, n_bodies, shrink_recenter)
    system = (generate_gravitational(123, n_bodies),)
    println("Create tree")
    @time tree = fmm.Tree(system; expansion_order, n_per_branch, shrink_recenter=shrink_recenter)
    println("Run fmm")
    @time fmm.fmm!(tree, system; theta=theta, reset_tree=true, nearfield=true, farfield=true, unsort_bodies=true)
    println("BEGIN DIRECT")
    system2 = generate_gravitational(123, n_bodies)
    @time fmm.direct!(system2, 1:n_bodies, system2, 1:n_bodies)
    phi = system[1].potential[1,:]
    phi2 = system2.potential[1,:]
    return maximum(abs.(phi2 - phi)), system, tree, system2
end

function bm_fmm_accuracy_dual_tree(expansion_order, n_per_branch, theta, n_bodies, shrink_recenter)
    system = (generate_gravitational(123, n_bodies),)
    println("Create trees")
    @time source_tree = fmm.Tree(system; expansion_order, n_per_branch, shrink_recenter=shrink_recenter)
    @time target_tree = fmm.Tree(system; expansion_order, n_per_branch, shrink_recenter=shrink_recenter)
    println("Run fmm")
    @time fmm.fmm!(target_tree, system, source_tree, system; theta=theta, nearfield=true, farfield=true)
    println("BEGIN DIRECT")
    system2 = generate_gravitational(123, n_bodies)
    @time fmm.direct!(system2, 1:n_bodies, system2, 1:n_bodies)
    phi = system[1].potential[1,:]
    phi2 = system2.potential[1,:]
    return maximum(abs.(phi2 - phi)), system, source_tree, target_tree, system2
end

function visualize_tree(name, system, tree; probe_indices=[])
    #####
    ##### branches
    #####
    branches = tree.branches
    n_branches = length(branches)
    branch_locations = Array{Float64,4}(undef,3,n_branches,1,1)
    branch_radii = Array{Float64,3}(undef,n_branches,1,1)
    for (i,branch) in enumerate(branches)
        branch_locations[:,i,1,1] .= branch.center
        branch_radii[i,1,1] = branch.radius
    end
    vtk_grid(name*"_branches", branch_locations) do vtk
        vtk["radius"] = branch_radii
    end

    #####
    ##### bodies
    #####
    n_bodies = length(system)
    body_locations = Array{Float64,4}(undef,3,n_bodies,1,1)
    body_radii = Array{Float64,3}(undef,n_bodies,1,1)
    scalar_strength = Array{Float64,3}(undef,n_bodies,1,1)
    vector_strength = Array{Float64,4}(undef,3,n_bodies,1,1)
    for i in 1:n_bodies
        body_locations[:,i,1,1] .= system[i,fmm.POSITION]
        body_radii[i,1,1] = system[i,fmm.RADIUS]
        scalar_strength[i,1,1] = system[i,fmm.SCALAR_STRENGTH]
        vector_strength[:,i,1,1] .= system[i,fmm.VECTOR_STRENGTH]
    end
    vtk_grid(name*"_bodies", body_locations) do vtk
        vtk["radius"] = body_radii
        vtk["scalar strength"] = scalar_strength
        vtk["vector strength"] = vector_strength
    end
    
    #####
    ##### probes
    #####
    n_probes = length(probe_indices)
    if n_probes > 0
        body_locations = Array{Float64,4}(undef,3,n_probes,1,1)
        body_radii = Array{Float64,3}(undef,n_probes,1,1)
        scalar_strength = Array{Float64,3}(undef,n_probes,1,1)
        vector_strength = Array{Float64,4}(undef,3,n_probes,1,1)
        for (i_probe,i_body) in enumerate(probe_indices)
            body_locations[:,i_probe,1,1] .= system[i_body,fmm.POSITION]
            body_radii[i_probe,1,1] = system[i_body,fmm.RADIUS]
            scalar_strength[i_probe,1,1] = system[i_body,fmm.SCALAR_STRENGTH]
            vector_strength[:,i_probe,1,1] .= system[i_body,fmm.VECTOR_STRENGTH]
        end
        vtk_grid(name*"_probes", body_locations) do vtk
            vtk["radius"] = body_radii
            vtk["scalar strength"] = scalar_strength
            vtk["vector strength"] = vector_strength
            vtk["index"] = probe_indices
        end
    end

    return nothing
end
# println("generate bodies")
# @time generate_gravitational(123, 5000)
# @time generate_gravitational(123, 5000)


expansion_order = 4
n_per_branch = 50
theta = 0.5
n_bodies = 10000
shrink_recenter = false
farfield=nearfield=true

expansion_order, n_per_branch, theta = 8, 30, 0.3
n_bodies = 850000
shrink_recenter, ndivisions = false, 15
println("create system...")
sys = generate_gravitational(123, n_bodies)
println("create tree...")
tree = fmm.Tree(sys; n_per_branch=n_per_branch, expansion_order=expansion_order, ndivisions=ndivisions)
println("done.")
# err, system, tree, system2 = bm_fmm_accuracy(expansion_order, n_per_branch, theta, n_bodies, shrink_recenter)
# @show err

using BenchmarkTools

#####
##### translate multipoles
#####
tm_st = []
tm_mt = []
mt_tm_fun(this_index) = fmm.translate_multipoles_multi_thread!(tree.branches, expansion_order, this_index)
st_tm_fun(this_index) = fmm.translate_multipoles_single_thread!(tree.branches, expansion_order, this_index)
for i in 1:6
    levels_index = tree.levels_index[i]
    this_index = [levels_index]
    t_mt = @belapsed mt_tm_fun($this_index)
    t_st = @belapsed st_tm_fun($this_index)
    push!(tm_mt, t_mt)
    push!(tm_st, t_st)
end
tm_speedup = tm_st ./ tm_mt
tm_summary = hcat([length(this_index) for this_index in tree.levels_index[1:6]], tm_st, tm_mt, tm_speedup)
println("n m2m translations | 1 thread, workstation | 72 threads, workstation | speedup")
println("--- | --- | --- | ---")
println(round.(tm_summary, digits=5))

#####
##### b2m
#####
b2m_st = []
b2m_mt = []
mt_b2m_fun(this_index) = fmm.body_2_multipole_multi_thread!(tree.branches, sys, expansion_order, this_index) 
st_b2m_fun(this_index) = fmm.body_2_multipole_single_thread!(tree.branches, sys, expansion_order, this_index) 
for i in [1, 10, 100, 1000, 10000]
    this_index = tree.leaf_index[1:i]
    t_mt = @belapsed mt_b2m_fun($this_index)
    t_st = @belapsed st_b2m_fun($this_index)
    push!(b2m_mt,t_mt)
    push!(b2m_st,t_st)
end
b2m_speedup = b2m_st ./ b2m_mt
b2m_summary = hcat([1, 10, 100, 1000, 10000], b2m_st, b2m_mt, b2m_speedup)
println("n leaves (b2m) | 1 thread, workstation | 72 threads, workstation | speedup")
println("--- | --- | --- | ---")
println(round.(b2m_summary, digits=5))

#####
##### m2l
#####
m2l_list, direct_list = fmm.build_interaction_lists(tree.branches, theta, farfield, nearfield)
m2l_st = []
m2l_mt = []
mt_m2l_fun(this_index) = fmm.horizontal_pass_multi_thread!(tree.branches, tree.branches, this_index, expansion_order)
st_m2l_fun(this_index) = fmm.horizontal_pass_single_thread!(tree.branches, tree.branches, this_index, expansion_order)
for i in [1, 10, 100, 1000, 10000, 100000, 1000000]
    this_index = m2l_list[1:i]
    println("i passes: $i")
    t_mt = @belapsed mt_m2l_fun($this_index)
    t_st = @belapsed st_m2l_fun($this_index)
    push!(m2l_mt, t_mt)
    push!(m2l_st, t_st)
end
m2l_speedup = m2l_st ./ m2l_mt
m2l_summary = hcat([1, 10, 100, 1000, 10000, 100000, 1000000], m2l_st, m2l_mt, m2l_speedup)
println("n m2l transformations | 1 thread, workstation | 72 threads, workstation | speedup")
println("--- | --- | --- | ---")
println(round.(m2l_summary, digits=5))

#####
##### direct
#####
direct_mt = []
direct_st = []
mt_direct_fun(this_index) = fmm.nearfield_multi_thread!(sys, tree.branches, sys, tree.branches, this_index)
st_direct_fun(this_index) = fmm.nearfield_single_thread!(sys, tree.branches, sys, tree.branches, this_index) 
for i in [1, 10, 100, 1000, 10000, 100000, 1000000]
    println("i passes: $i")
    this_index = direct_list[1:i]
    t_mt = @belapsed mt_direct_fun($this_index)
    t_st = @belapsed st_direct_fun($this_index)
    push!(direct_mt, t_mt)
    push!(direct_st, t_st)
end
direct_speedup = direct_st ./ direct_mt
direct_summary = hcat([1, 10, 100, 1000, 10000, 100000, 1000000], direct_st, direct_mt, direct_speedup)
println("n leaves | 1 thread, workstation | 72 threads, workstation | speedup")
println("--- | --- | --- | ---")
println(round.(direct_summary, digits=5))

#####
##### translate locals
#####
tl_mt = []
tl_st = []
mt_tl_fun(this_index) = fmm.translate_multipoles_multi_thread!(tree.branches, expansion_order, this_index) 
st_tl_fun(this_index) = fmm.translate_multipoles_single_thread!(tree.branches, expansion_order, this_index) 
for i in 1:6
    levels_index = tree.levels_index[i]
    this_index = [levels_index]
    t_mt = @belapsed mt_tl_fun($this_index)
    t_st = @belapsed st_tl_fun($this_index)
    push!(tl_mt, t_mt)
    push!(tl_st, t_st)
end
tl_speedup = tl_st ./ tl_mt
tl_summary = hcat([length(tree.levels_index[i]) for i in 1:6], tl_st, tl_mt, tl_speedup)
println("n l2l translations | 1 thread, workstation | 72 threads, workstation | speedup")
println("--- | --- | --- | ---")
println(round.(tl_summary, digits=5))

#####
##### l2b
#####
l2b_mt = []
l2b_st = []
mt_l2b_fun(this_index) = fmm.local_2_body_multi_thread!(tree.branches, sys, expansion_order, this_index) 
st_l2b_fun(this_index) = fmm.local_2_body_single_thread!(tree.branches, sys, expansion_order, this_index) 
for i in [1, 10, 100, 1000, 10000]
    println("i leaves: $i")
    this_index = tree.leaf_index[1:i]
    t_mt = @belapsed mt_l2b_fun($this_index)
    t_st = @belapsed st_l2b_fun($this_index)
    push!(l2b_mt, t_mt)
    push!(l2b_st, t_st)
end
l2b_speedup = l2b_st ./ l2b_mt
l2b_summary = hcat([1, 10, 100, 1000, 10000], l2b_st, l2b_mt, l2b_speedup)
println("n leaves | 1 thread, workstation | 72 threads, workstation | speedup")
println("--- | --- | --- | ---")
println(round.(l2b_summary, digits=5))

# sys = generate_gravitational(123, 500000)
# tree = fmm.Tree(sys; expansion_order=expansion_order, n_per_branch=n_per_branch)
# m2l_list, direct_list = fmm.build_interaction_lists(tree.branches, theta, true, true)
# fmm.horizontal_pass_multi_thread!(tree.branches, m2l_list, expansion_order)
# t = @elapsed fmm.horizontal_pass_multi_thread!(tree.branches, m2l_list, expansion_order)
# t_per_op = t / length(m2l_list)
# @show t_per_op

# fmm.horizontal_pass_single_thread!(tree.branches, m2l_list, expansion_order)
# t = @elapsed fmm.horizontal_pass_single_thread!(tree.branches, m2l_list, expansion_order)
# t_per_op = t / length(m2l_list)
# @show t_per_op

# fmm.fmm!(sys)





# nfp, nfe = fmm.get_nearfield_parameters(sys)
# params, errors, nearfield_params, nearfield_errors = fmm.estimate_tau(sys; expansion_orders = 1:9:20, epsilon=0.1, cost_file_read=false, cost_file_write=true)

# note: old_bodies[tree.index_list[1]] = systems[1].bodies
# println("Run FMM:")
# @time bm_fmm()
# @time bm_fmm()

# println("Run Direct:")
# @time bm_direct()
# @time bm_direct()
# @btime fmm.fmm!($tree, $systems, $options; unsort_bodies=true)
# println("Calculating accuracy:")
# expansion_order, n_per_branch, theta = 8, 300, 0.3
# n_bodies = 100000
# shrink_recenter, ndivisions = true, 10
# sys = generate_gravitational(123,n_bodies)
# function bmtree()# let sys=sys, expansion_order=expansion_order, n_per_branch=n_per_branch, ndivisions=ndivisions, shrink_recenter=shrink_recenter
#         return fmm.Tree(sys; expansion_order, n_per_branch, ndivisions=ndivisions, shrink_recenter=shrink_recenter)
#     # end
# end
# @time fmm.Tree(sys; expansion_order=expansion_order, n_per_branch=n_per_branch, ndivisions=ndivisions, shrink_recenter=shrink_recenter)
# fmm.unsort!(sys, tree)
# @time bmtree()
# fmm.unsort!(sys, tree)
# @time bmtree()
# @time bmtree()
# @time bmtree()

# println("done")

# sys_noshrinking = generate_gravitational(123,n_bodies)
# tree_noshrinking = fmm.Tree(sys_noshrinking; expansion_order, n_per_branch, ndivisions=5, shrink_recenter=false)

# println("done")
# run_bm_accuracy() = bm_fmm_accuracy(expansion_order, n_per_branch, theta, n_bodies, shrink_recenter)
# accuracy, system, tree, system2 = run_bm_accuracy()
# accuracy, system, tree, system2 = run_bm_accuracy()
# println("single tree accuracy: $accuracy")
# run_bm_accuracy_dual_tree() = bm_fmm_accuracy_dual_tree(expansion_order, n_per_branch, theta, n_bodies, shrink_recenter)
# accuracy, system, tree, system2 = run_bm_accuracy_dual_tree()
# accuracy, system, tree, system2 = run_bm_accuracy_dual_tree()
# println("dual tree accuracy: $accuracy")

# visualize tree
# visualize_tree("test_fmm", system, tree; probe_indices=[11])
# visualize_tree("test_direct", system2, tree)
# visualize_tree("test_shrinking", sys, tree)
# visualize_tree("test_noshrinking", sys_noshrinking, tree_noshrinking)

