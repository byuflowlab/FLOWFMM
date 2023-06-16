const BRANCH_TYPE = Float64

struct Branch{TF}
    n_branches::Int8          # number of child branches
    n_bodies::Vector{Int32}          # number of descendent bodies
    first_branch::Int32        # index of the first branch
    first_body::Vector{Int32}       # index of the first element
    center::Vector{TF}              # center of the branch
    radius::TF              # side lengths of the cube encapsulating the branch
    multipole_expansion::Vector{Vector{Complex{TF}}} # multipole expansion coefficients
    local_expansion::Vector{Vector{Complex{TF}}}     # local expansion coefficients
    lock::ReentrantLock
    child_lock::ReentrantLock
end

"""
bodies[index_list] is the same sort operation as performed by the tree
sorted_bodies[inverse_index_list] undoes the sort operation performed by the tree
"""
struct Tree{TF,VVI<:Vector{Vector{Int32}},VI<:Vector{Int32}}
    branches::Vector{Branch{TF}}        # a vector of `Branch` objects composing the tree
    expansion_order::Int16
    n_per_branch::Int32    # max number of bodies in a leaf
    index_list::VVI
    inverse_index_list::VVI
    leaf_index::VI
    cumulative_count::VI # starting with 0, a cumulative accounting of how many bodies are in leaf branches
end

Tree(branches, expansion_order::Int64, n_per_branch::Int64, index_list, inverse_index_list, leaf_index, leaf_count) = Tree(branches, Int16(expansion_order), Int32(n_per_branch), index_list, inverse_index_list, leaf_index, leaf_count)

"""
    Tree(elements; expansion_order=2, n_per_branch=1)

Constructs an octree of the provided element objects.

# Inputs

- `elements`- a struct containing the following members:

    * `bodies::Array{Float64,2}`- 3+4+mxN array containing element positions, strengths, and m other values that must be sorted into the octree
    * `potential::Array{Float64,2}`- 4+12+36xN array of the potential, Jacobian, and Hessian that are reset every iteration (and don't require sorting)
    * `velocity::Array{Float64,2}`- 3xN array of the velocity vectors at each element, reset every iteration, and calculated in post-processing
    * `direct!::Function`- function calculates the direct influence of the body at the specified location
    * `B2M!::Function`- function converts the body's influence into a multipole expansion
"""
function Tree(elements_tuple::Tuple, options::Options)
    # unpack options
    expansion_order = options.expansion_order
    n_per_branch = options.n_per_branch

    # initialize objects
    bodies_list = [elements.bodies for elements in elements_tuple]
    buffer_list = [similar(bodies) for bodies in bodies_list]
    index_list = [zeros(Int32,size(bodies)[2]) for bodies in bodies_list]
    inverse_index_list = [similar(index) for index in index_list]
    buffer_index_list = [similar(index) for index in index_list]
    branches = Vector{Branch{BRANCH_TYPE}}(undef,1)

    # update index lists
    for inverse_index in inverse_index_list
        inverse_index .= 1:length(inverse_index)
    end

    # recursively build branches
    i_start = ones(Int32,length(elements_tuple))
    i_end = [Int32(size(bodies)[2]) for bodies in bodies_list]
    i_branch = 1
    center, radius = center_radius(elements_tuple; scale_radius = 1.00001)
    level = 0
    branch!(branches, bodies_list, buffer_list, inverse_index_list, buffer_index_list, i_start, i_end, i_branch, center, radius, level, expansion_order, n_per_branch)

    # invert index
    for (i_type,inverse_index) in enumerate(inverse_index_list)
        buffer_index = buffer_index_list[i_type]
        for i_body in 1:length(inverse_index)
            buffer_index[inverse_index[i_body]] = i_body
        end
        index_list[i_type] .= inverse_index
        inverse_index .= buffer_index
    end

    # count leaves
    n_leaves = 0
    for branch in branches
        branch.n_branches == 0 && (n_leaves += 1)
    end

    # create leaf index and leaf count
    cumulative_count = Vector{Int32}(undef,n_leaves)
    cumulative_count[1] = 0
    leaf_index = zeros(Int32,n_leaves)
    i_leaf_index = 1
    for (i_branch, branch) in enumerate(branches)
        if branch.n_branches == 0
            leaf_index[i_leaf_index] = Int32(i_branch)
            i_leaf_index < n_leaves && (cumulative_count[i_leaf_index+1] = cumulative_count[i_leaf_index] + sum(branch.n_bodies))
            i_leaf_index += 1
        end
    end

    # assemble tree
    tree = Tree(branches, Int16(expansion_order), Int32(n_per_branch), index_list, inverse_index_list, leaf_index, cumulative_count)

    return tree
end

function branch!(branches, bodies_list, buffer_list, inverse_index_list, buffer_index_list, i_start, i_end, i_branch, center, radius, level, expansion_order, n_per_branch)
    n_branches = Int8(0)
    n_bodies = i_end - i_start .+ Int32(1)
    n_types = length(i_start)
    multipole_expansion = initialize_expansion(expansion_order)
    local_expansion = initialize_expansion(expansion_order)
    if prod(n_bodies .<= n_per_branch) # checks for all element structs => branch is a leaf; no new branches needed
        i_child = Int32(-1)
        branch = Branch(n_branches, n_bodies, i_child, i_start, center, radius, multipole_expansion, local_expansion, ReentrantLock(), ReentrantLock())
        branches[i_branch] = branch
        return nothing
    else # not a leaf; branch children
        # count elements in each octant
        octant_attendance = zeros(Int32, 8, n_types)
        for i_type in 1:n_types # loop over each type
            for i_body in i_start[i_type]:i_end[i_type] # loop over each body
                x = bodies_list[i_type][1:3,i_body]
                i_octant = get_octant(x, center)
                octant_attendance[i_octant, i_type] += Int32(1)
            end
        end

        # determine number of children
        for i_octant in 1:8
            n_branches += true in (octant_attendance[i_octant,:] .> 0) # check for elements of any type
        end

        # create branch
        i_child = Int32(length(branches) + 1)
        branches[i_branch] = Branch(n_branches, n_bodies, i_child, i_start, center, radius, multipole_expansion, local_expansion, ReentrantLock(), ReentrantLock())

        # sort bodies
        ## write offsets
        offsets = zeros(Int32,8,n_types)
        offsets[1,:] .= i_start
        for i=2:8
            offsets[i,:] .= offsets[i-1,:] + octant_attendance[i-1,:]
        end

        ## create counter
        counter = deepcopy(offsets)

        ## sort element indices into the buffer
        for i_type in 1:n_types
            for i_body in i_start[i_type]:i_end[i_type]
                x = bodies_list[i_type][1:3,i_body]
                i_octant = get_octant(x, center)
                buffer_list[i_type][:,counter[i_octant,i_type]] .= bodies_list[i_type][:,i_body]
                buffer_index_list[i_type][counter[i_octant,i_type]] = inverse_index_list[i_type][i_body]
                counter[i_octant,i_type] += 1 
            end
            # place sorted bodies
            bodies_list[i_type][:,i_start[i_type]:i_end[i_type]] .= buffer_list[i_type][:,i_start[i_type]:i_end[i_type]]
            
            # update index_list
            inverse_index_list[i_type] .= buffer_index_list[i_type]
        end

        # recursively build new branches
        prev_branches = length(branches)
        resize!(branches, prev_branches + n_branches)

        i_tape = 1
        for i_octant in Int8(0):Int8(7) # check each octant for members
            if true in (octant_attendance[i_octant+Int8(1),:] .> 0) # if octant is populated
                child_i_start = offsets[i_octant+Int8(1),:] # index of first member for all element types
                child_i_end = child_i_start + octant_attendance[i_octant+Int8(1),:] .- Int32(1) # if attendence is 0, the end index will be less than the start
                child_radius = radius / 2#(1 << (level + 1))
                child_center = deepcopy(center)
                for d in Int8(0):Int8(2)
                    child_center[d + Int8(1)] += child_radius * (((i_octant & Int8(1) << d) >> d) * Int8(2) - Int8(1))
                end
                branch!(branches, bodies_list, buffer_list, inverse_index_list, buffer_index_list, child_i_start, child_i_end, i_tape + prev_branches, child_center, child_radius, level + 1, expansion_order, n_per_branch)
                i_tape += 1
            end
        end
    end
end

"""
Undoes the sort operation performed by the tree.
"""
function unsort!(elements_tuple::Tuple, tree::Tree)
    n_types = length(elements_tuple)
    for (i_type, elements) in enumerate(elements_tuple)
        bodies = elements.bodies
        potential = elements.potential
        inverse_index = tree.inverse_index_list[i_type]
        bodies .= bodies[:,inverse_index]
        potential .= potential[:,inverse_index]
    end
end

"""
Performs the same sort operation as the tree. (Undoes `unsort!` operation.)
"""
function resort!(elements_tuple::Tuple, tree::Tree)
    n_types = length(elements_tuple)
    for (i_type, elements) in enumerate(elements_tuple)
        bodies = elements.bodies
        potential = elements.potential
        index = tree.index_list[i_type]
        bodies .= bodies[:,index]
        potential .= potential[:,index]
    end
end

function center_radius(elements_tuple::Tuple; scale_radius = 1.00001)
    x_min = deepcopy(elements_tuple[1].bodies[i_POSITION,1])
    x_max = deepcopy(elements_tuple[1].bodies[i_POSITION,1])
    for elements in elements_tuple
        for i in 1:size(elements.bodies)[2]
            x = elements.bodies[i_POSITION,i]
            for dim in 1:3
                if x[dim] < x_min[dim]
                    x_min[dim] = x[dim]
                elseif x[dim] > x_max[dim]
                    x_max[dim] = x[dim]
                end
            end
        end
    end
    center = (x_max + x_min) ./ 2
    # TODO: add element smoothing radius here? Note this method creates cubic cells
    radius = max(x_max-center...) * scale_radius # get half of the longest side length of the rectangle
    return center, radius
end

@inline function get_octant(x, center)
    i_octant = (UInt8((x[1] > center[1])) + UInt8(x[2] > center[2]) << 0b1 + UInt8(x[3] > center[3]) << 0b10) + 0b1
end

function n_terms(expansion_order, dimensions)
    n = 0
    for order in 0:expansion_order
        # leverage stars and bars theorem
        n += binomial(order + dimensions - 1, dimensions - 1)
    end
    return n
end

function initialize_expansion(expansion_order)
    return [zeros(Complex{Float64}, ((expansion_order+1) * (expansion_order+2)) >> 1) for _ in 1:4]
end

function change_expansion_order!(tree::Tree, new_order)
    old_n = length(tree.branches[1].multipole_expansion[1])
    new_n = n_terms(new_order, 3)
    old_order = tree.expansion_order
    for branch in tree.branches
        if  old_order < new_order
            for i in 1:new_n - old_n
                for dim in 1:4
                    push!(branch.multipole_expansion[dim],0.0)
                    push!(branch.local_expansion[dim],0.0)
                end
            end
        elseif old_order > new_order
            for i in 1:new_n - old_n
                for dim in 1:4
                    pop!(branch.multipole_expansion[dim])
                    pop!(branch.local_expansion[dim])
                end
            end
        end
    end
    tree.expansion_order = new_order
end

function reset_expansions!(tree)
    Threads.@threads for branch in tree.branches
        branch.multipole_expansion .*= 0
        branch.local_expansion .*= 0
    end
end
