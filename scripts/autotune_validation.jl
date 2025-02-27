# autotuning validation
# for FMM paper 20250226

using FastMultipole
using DelimitedFiles
include("../test/gravitational.jl")

function validate_tuning!(systems::Tuple, leaf_size_range, mac_range, name::String; expansion_order=10, fmm_args...)
    # preallocate
    benchmarks = zeros(length(mac_range), length(leaf_size_range))
    optargs, _ = fmm!(systems)
    source_buffers = optargs.source_buffers
    target_buffers = optargs.target_buffers
    source_small_buffers = optargs.source_small_buffers
    target_small_buffers = optargs.target_small_buffers

    # perform benchmarks
    for (i_ls, leaf_size) in enumerate(leaf_size_range)
        leaf_size_source = SVector{1}(leaf_size)
        source_tree = Tree(systems, false; leaf_size=leaf_size_source, expansion_order, buffers=source_buffers, small_buffers=source_small_buffers)
        target_tree = Tree(systems, true; leaf_size=leaf_size_source, expansion_order, buffers=target_buffers, small_buffers=target_small_buffers)

        for (i_mac, mac) in enumerate(mac_range)
            reset!(systems[1])
            t1 = @elapsed fmm!(systems, target_tree, systems, source_tree;
                              leaf_size_source, multipole_threshold=mac,
                              scalar_potential=false, velocity=true,
                              velocity_gradient=false)

            reset!(systems[1])
            t2 = @elapsed fmm!(systems, target_tree, systems, source_tree;
                              leaf_size_source, multipole_threshold=mac,
                              scalar_potential=false, velocity=true,
                              velocity_gradient=false)

            benchmarks[i_mac, i_ls] = min(t1, t2)

        end
    end

    # save results
    writedlm(name*".csv", benchmarks, ',')
end

#------- point masses -------#

vmean = 1.0
systems = (generate_gravitational(123, n_bodies; strength_factor = vmean / n_bodies), )
direct!(systems)
vs = [


validate_tuning!

#------- point masses -------#
