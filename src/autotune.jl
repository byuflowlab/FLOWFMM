#------- choose max expansion order -------#

function get_max_expansion_order(ε_abs, multipole_threshold, max_expansion_order, target_systems, source_systems;
        target_buffers, source_buffers, target_small_buffers, source_small_buffers,
        shrink_recenter, lamb_helmholtz,
        scalar_potential, velocity, velocity_gradient,
    )

    leaf_size_source = default_leaf_size(source_systems)
    reached_max_expansion_order = false

    for expansion_order in 4:3:max_expansion_order

        t_fmm = @elapsed optargs, _, _, _, _, _, error_success = fmm!(target_systems, source_systems;
                                                     target_buffers, source_buffers, target_small_buffers, source_small_buffers,
                                                     expansion_order, ε_abs, multipole_threshold,
                                                     shrink_recenter, lamb_helmholtz,
                                                     scalar_potential, velocity, velocity_gradient,
                                                     update_target_systems=false, tune=true
                                                    )
        leaf_size_source = optargs.leaf_size_source

        if error_success
            return expansion_order, leaf_size_source, error_success, t_fmm
        end

        if expansion_order == max_expansion_order
            reached_max_expansion_order = true
        end

    end

    if !reached_max_expansion_order
        t_fmm = @elapsed optargs, _, _, _, _, _, error_success = fmm!(target_systems, source_systems;
                                                     target_buffers, source_buffers, target_small_buffers, source_small_buffers,
                                                     expansion_order=max_expansion_order, ε_abs, multipole_threshold,
                                                     shrink_recenter, lamb_helmholtz,
                                                     scalar_potential, velocity, velocity_gradient,
                                                     update_target_systems=false, tune=true
                                                    )
        leaf_size_source = optargs.leaf_size_source
    end

    return max_expansion_order, leaf_size_source, error_success, t_fmm
end

tune_fmm!(system; optargs...) = tune_fmm!(system, system; optargs...)

function tune_fmm!(target_systems, source_systems; optargs...)
    # promote arguments to Tuples
    target_systems = to_tuple(target_systems)
    source_systems = to_tuple(source_systems)

    return tune_fmm!(target_systems, source_systems; optargs...)
end

function tune_fmm!(target_systems::Tuple, source_systems::Tuple;
    expansion_order=5,
    ε_abs=nothing,
    shrink_recenter=true, lamb_helmholtz=true,
    max_expansion_order=20,
    multipole_thresholds=range(0.3, stop=0.9, step=0.1),
    leaf_size_source=default_leaf_size(source_systems),
    scalar_potential=false, velocity=true, velocity_gradient=false,
    verbose=true
)

    #--- predict maximum velocity ---#

    if verbose
        println("\n#======= Begin FastMultipole.autotune!() =======#")
        # println("\n\tpredicting max velocity...")
    end

    # reset!(target_systems)
    # fmm!(target_systems, source_systems;
    #      expansion_order=1, leaf_size_source=SVector{length(source_systems)}()
    #      lamb_helmholtz, ε_abs, tune=true,
    #      scalar_potential, velocity, velocity_gradient)

    # max_velocity = zero(eltype(target_systems[1]))
    # for system in target_systems
    #     for i in 1:get_n_bodies(system)
    #         max_velocity = max(max_velocity, norm(system[i, Velocity()]))
    #     end
    # end

    #--- preallocate buffers ---#

    optargs, _ = fmm!(target_systems, source_systems;
                      expansion_order=1, update_target_systems=false, tune=true,
                      shrink_recenter, lamb_helmholtz,
                      scalar_potential, velocity, velocity_gradient
                     )
    source_buffers = optargs.source_buffers
    target_buffers = optargs.target_buffers
    source_small_buffers = optargs.source_small_buffers
    target_small_buffers = optargs.target_small_buffers

    #--- loop over multipole_threshold ---#

    # preallocated storage for when we find the best case
    leaf_size_sources = Vector{SVector{length(source_systems),Int}}(undef, length(multipole_thresholds))
    expansion_orders = Vector{Int}(undef, length(multipole_thresholds))
    ts_fmm = @MVector zeros(length(multipole_thresholds))

    for (i_mt, multipole_threshold) in enumerate(multipole_thresholds)
        if verbose
            println("\n\ttuning multipole_threshold = $multipole_threshold...")
        end

        #--- determine max expansion_order ---#

        if !isnothing(ε_abs)
            # expansion_order = max_expansion_order
            expansion_order, leaf_size_source, error_success, t_fmm =
                get_max_expansion_order(ε_abs, multipole_threshold, max_expansion_order, target_systems, source_systems;
                                         target_buffers, source_buffers, target_small_buffers, source_small_buffers,
                                         shrink_recenter, lamb_helmholtz,
                                         scalar_potential, velocity, velocity_gradient,
                                        )

        else # fixed expansion order

            # get leaf size
            _ = @elapsed optargs, _, _, _, _, _, error_success =
                fmm!(target_systems, source_systems;
                    source_buffers, target_buffers,
                    source_small_buffers, target_small_buffers,
                    multipole_threshold, leaf_size_source,
                    expansion_order, ε_abs, lamb_helmholtz,
                    scalar_potential, velocity, velocity_gradient,
                    tune=true, update_target_systems=false
                )

                leaf_size_source = optargs.leaf_size_source

        end

        #--- tune expansion order and leaf size ---#

        if error_success
            # get expansion order now that leaf_size has been chosen
            _ = @elapsed optargs, _ =
                fmm!(target_systems, source_systems;
                    source_buffers, target_buffers,
                    source_small_buffers, target_small_buffers,
                    multipole_threshold, leaf_size_source,
                    expansion_order, ε_abs, lamb_helmholtz,
                    scalar_potential, velocity, velocity_gradient,
                    tune=true, update_target_systems=false
                )
                expansion_order = optargs.expansion_order

            #--- benchmark with tuned parameters ---#

            t_fmm = @elapsed _, _, _, m2l_list, direct_list, _, error_success = fmm!(target_systems, source_systems;
                    source_buffers, target_buffers,
                    source_small_buffers, target_small_buffers,
                    multipole_threshold, leaf_size_source,
                    expansion_order, ε_abs, lamb_helmholtz,
                    scalar_potential, velocity, velocity_gradient,
                    tune=true, update_target_systems=false
                )

            leaf_size_sources[i_mt] = leaf_size_source
            expansion_orders[i_mt] = expansion_order
            ts_fmm[i_mt] = t_fmm

        else

            leaf_size_sources[i_mt] = default_leaf_size(source_systems)
            expansion_orders[i_mt] = max_expansion_order
            ts_fmm[i_mt] = maxintfloat()
            if verbose
                println("\n\terror tolerance not reached for max_expansion_order=$max_expansion_order;")
                println("\tskipping this multipole_threshold\n")
            end

        end

        if verbose
            tuned_params = (leaf_size_source => leaf_size_source,
                    expansion_order => expansion_order,
                    multipole_threshold => multipole_threshold)
            println("\t\tparameters:          ", tuned_params)
            println("\t\tcost:                $t_fmm seconds")
            if error_success
                println("\t\tlength(m2l_list):    ", length(m2l_list))
                println("\t\tlength(direct_list): ", length(direct_list))
            end
        end

    end

    #--- compile tuned parameters ---#

    _, i = findmin(ts_fmm)
    leaf_size_source = leaf_size_sources[i]
    expansion_order = expansion_orders[i]
    multipole_threshold = multipole_thresholds[i]

    tuned_params = (
                    source_buffers = source_buffers,
                    target_buffers = target_buffers,
                    source_small_buffers = source_small_buffers,
                    target_small_buffers = target_small_buffers,
                    leaf_size_source = leaf_size_source,
                    expansion_order = expansion_order,
                    multipole_threshold = multipole_threshold,
                   )

    #--- return ---#

    if verbose
        println("\n\tfinished!")
        println("\n\tparameters: ")
        println("\t", tuned_params.leaf_size_source)
        println("\t", tuned_params.expansion_order)
        println("\t", tuned_params.multipole_threshold)
        println("\n#===============================================#\n")
    end


    return tuned_params
end

