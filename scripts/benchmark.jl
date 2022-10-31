import Statistics as S
import FLOWFMM as fmm
import PyPlot as plt


scripts_dir = @__DIR__
include(joinpath(scripts_dir, "..", "test", "gravitational.jl"))

function benchmark_fmm(ns_fmm, is_direct; expansion_order = 2, n_per_branch=50, theta=4)
    times_fmm = zeros(length(ns_fmm))
    times_direct = zeros(length(ns_fmm)) .* NaN
    # max_errs = zeros(length(orders))
    # min_errs = zeros(length(orders))
    mean_errs = zeros(length(ns_fmm)) .* NaN

    # dummy run to reduce influence of compile time on @elapsed measurement
    i, n = 1, 5
    ms = rand(n)
    xs = rand(n,3)
    masses = [Mass(xs[i,:],[ms[i]],zeros(1),zeros(3)) for i in 1:length(ms)]
    @elapsed fmm.fmm!(masses, derivatives, expansion_order, n_per_branch, theta)
    @elapsed fmm.direct!(masses; reflex=false)

    println("\nBegin Benchmark Test:")
    for (i,n) in enumerate(ns_fmm)
        println("\tn = $n elements...")
        potentials_fmm = zeros(n)
        potentials_direct = zeros(n) .* NaN
        ms = rand(n)
        xs = rand(n,3)
        masses = [Mass(xs[i,:],[ms[i]],zeros(1),zeros(3)) for i in 1:length(ms)]

        # fmm
        # println("\t\tBuilding Tree...")
        println("\t\tComputing FMM...")
        times_fmm[i] = @elapsed tree = fmm.fmm!(masses, expansion_order, n_per_branch, theta, P2M!, P2P!)
        println("\t\tFMM time: $(times_fmm[i]) seconds")
        for ii in 1:n
            potentials_fmm[ii] = masses[ii].potential[1]
        end

        # direct method
        if i in is_direct
            for m in masses; m.potential .*= 0; end
            println("\t\tComputing direct...")
            times_direct[i] = @elapsed fmm.direct!(masses; reflex=false)
            for ii in 1:n
                potentials_direct[ii] = masses[ii].potential[1]
            end
            println("\t\tdirect time: $(times_direct[i]) seconds")
        end

        # mean error
        @show potentials_direct-potentials_fmm
        mean_errs[i] = abs(S.mean(abs.(potentials_direct .- potentials_fmm)) / S.mean(potentials_direct))
    end
    println("Done.\n")

    return times_fmm, times_direct, mean_errs
end


# ns = [10^i for i in 1:6]
ns = [10, 100, 1000]#, 10000, 50000, 100000, 1000000, 5000000]
is_direct = 1:5
times_fmm, times_direct, mean_errs = benchmark_fmm(ns, is_direct)

fig = plt.figure("benchmark_fmm")
fig.clear()
fig.add_subplot(111,xlabel="elements",ylabel="time, seconds")
ax = fig.get_axes()[1]
ax.plot(ns, times_fmm, label="fmm")
ax.plot(ns, times_direct, label="direct")
ax.set_xscale("log")
ax.set_yscale("log")
ax.legend()

fig = plt.figure("error")
fig.clear()
fig.add_subplot(111,xlabel="elements", ylabel="mean error")
ax = fig.get_axes()[1]
ax.plot(ns, mean_errs)