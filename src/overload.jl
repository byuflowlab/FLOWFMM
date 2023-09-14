#####
##### functions that should be overloaded for use in the FMM
#####

# Base.getindex(sys, i, ::Position) =
# Base.getindex(sys, i, ::Radius) =
# Base.getindex(sys, i, ::Potential) =
# Base.getindex(sys, i, ::ScalarPotential) =
# Base.getindex(sys, i, ::Velocity) =
# Base.getindex(sys, i, ::VelocityGradient) =
# Base.getindex(sys, i) =
function Base.setindex!(sys, val, i)
    @warn "setindex! not overloaded for type $(typeof(sys)); octree will have errors"
    return nothing
end
function Base.setindex!(sys, val, i, ::ScalarPotential)
    # @warn "setindex! (ScalarPotential) not overloaded for type $(typeof(sys))"
    return nothing
end
function Base.setindex!(sys, val, i, ::Potential)
    # @warn "setindex! (Potential) not overloaded for type $(typeof(sys))"
    return nothing
end
function Base.setindex!(sys, val, i, ::Velocity)
    # @warn "setindex! (Velocity) not overloaded for type $(typeof(sys))"
    return nothing
end
function Base.setindex!(sys, val, i, ::VelocityGradient)
    # @warn "setindex! (VelocityGradient) not overloaded for type $(typeof(sys))"
    return nothing
end
# Base.length(system) = 
# Base.eltype(::SystemType) = 

function B2M!(branch, system, bodies_index, harmonics, expansion_order)
    @warn "B2M! function not overloaded for type $(typeof(system)); interaction ignored"
    return nothing
end

function direct!(target_system, target_index, source_system, source_index)
    @warn "direct! function not overloaded for type $(typeof(source_system)); interaction ignored"
    return nothing
end

# overload for SortWrapper
Base.length(sys::SortWrapper) = length(sys.system)
Base.setindex!(sys::SortWrapper,val,i) = setindex!(sys.system,val,sys.index[i])
Base.setindex!(sys::SortWrapper,val,i,parameter::ScalarPotential) = setindex!(sys.system,val,sys.index[i],parameter::ScalarPotential)
Base.setindex!(sys::SortWrapper,val,i,parameter::Potential) = setindex!(sys.system,val,sys.index[i],parameter::Potential)
Base.setindex!(sys::SortWrapper,val,i,parameter::Velocity) = setindex!(sys.system,val,sys.index[i],parameter::Velocity)
Base.setindex!(sys::SortWrapper,val,i,parameter::VelocityGradient) = setindex!(sys.system,val,sys.index[i],parameter::VelocityGradient)
Base.getindex(sys::SortWrapper, i) = getindex(sys.system, sys.index[i])
Base.getindex(sys::SortWrapper, i, parameter) = getindex(sys.system, sys.index[i], parameter)
B2M!(branch, system::SortWrapper, bodies_index, harmonics, expansion_order) =
    B2M!(branch, system.system, system.index[bodies_index], harmonics, expansion_order)
direct!(target_system, target_index, source_system::SortWrapper, source_index) =
    direct!(target_system, target_index, source_system.system, source_system.index[source_index])