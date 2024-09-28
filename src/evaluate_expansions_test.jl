@testset "evaluate local expansion" begin

expansion_order = 10
x_target = SVector{3}([2.3, -4.1, 0.4])
xs = SVector{3}(0.1, 0.2, -0.3) + SVector{3}(-0.2, 0.07, -0.1)
mass = 0.7

local_weights_test = ComplexF64[0.13461314440045802 + 3.3705354655561485e-19im, 0.0222522458743801 + 0.012445327670248668im, 0.0044803179613703715 + 5.421010862427522e-19im, -0.022252245874380096 + 0.012445327670248666im, 0.007583425831984462 + 0.012343660455715708im, 0.0022218588801219174 + 0.0012426503802692856im, -0.004530776926944227 - 3.3881317890172014e-19im, -0.0022218588801219143 + 0.001242650380269284im, 0.00758342583198445 - 0.01234366045571569im, 0.0005618826003584149 + 0.013707888235259051im, 0.00126199254856226 + 0.0020541649413347894im, -0.0020989823761077323 - 0.0011739275068934224im, -0.0014167340980899452 + 1.0503208545953324e-19im, 0.002098982376107733 - 0.0011739275068934213im, 0.001261992548562265 - 0.002054164941334797im, -0.0005618826003584148 + 0.013707888235259065im, -0.008221132494823721 + 0.016225528877303053im, 0.0001309073866515384 + 0.0031936671135580166im, -0.0011081955754144032 - 0.0018038274715850458im, -0.0011463531702035823 - 0.0006411371440477935im, 0.0011779050882213705 - 2.541098841762901e-19im, 0.0011463531702035838 - 0.0006411371440477957im, -0.001108195575414408 + 0.001803827471585051im, -0.00013090738665154204 + 0.003193667113558019im, -0.008221132494823704 - 0.016225528877302997im, -0.025731932310300767 + 0.01729899289785846im, -0.0024626357659961596 + 0.004860325321913653im, -0.00010624160293646597 - 0.0025919440358925824im, -0.0008919964886097034 - 0.001451920433973297im, 0.0008209906162577367 + 0.0004591673873272759im, 0.0011911197485335514 - 3.5490680489955184e-19im, -0.0008209906162577411 + 0.00045916738732727704im, -0.0008919964886097046 + 0.0014519204339732991im, 0.00010624160293646779 - 0.0025919440358925907im, -0.0024626357659961635 - 0.004860325321913665im, 0.025731932310300815 + 0.017298992897858485im, -0.06438304103678125 + 0.005287703322304604im, -0.009423549333291578 + 0.006334909811777632im, 0.0018349588463839283 - 0.0036216669716206294im, -0.0001163463828190473 - 0.002839643689217267im, 0.0005342892910283834 + 0.0008696492948884198im, 0.001318547592663896 + 0.0007374538375610547im, -0.0006532637711022114 - 5.666650417131269e-19im, -0.0013185475926638978 + 0.0007374538375610551im, 0.0005342892910283803 - 0.0008696492948884159im, 0.00011634638281904435 - 0.002839643689217261im, 0.0018349588463839276 + 0.0036216669716206316im, 0.009423549333291583 + 0.006334909811777639im, -0.06438304103678112 - 0.005287703322304543im, -0.1445767313788903 - 0.06592392726829037im, -0.0279399057148588 + 0.0022916584569457887im, 0.006377137865683914 - 0.004290203023177704im, 0.002625495837073222 - 0.005180974568629023im, 5.601710088846004e-5 + 0.0013543600468385389im, 0.0012922334503294407 + 0.0021035283532226294im, -0.0004893806569793459 - 0.00027358591333853747im, -0.0018768309672893872 - 1.3222184306639628e-18im, 0.0004893806569793409 - 0.0002735859133385352im, 0.0012922334503294433 - 0.002103528353222636im, -5.601710088845241e-5 + 0.0013543600468385497im, 0.0026254958370732135 + 0.005180974568629007im, -0.006377137865683899 - 0.004290203023177702im, -0.027939905714858847 - 0.002291658456945764im, 0.14457673137889043 - 0.06592392726829031im, -0.26343687913376973 - 0.3579749966180197im, -0.07308071548173992 - 0.03330405578969736im, 0.016288863148509924 - 0.0013794365921490684im, 0.011685494843937744 - 0.007864104118944146im, -0.0008264228564544784 + 0.0016462191707537533im, 0.00020417790751703864 + 0.004935396035520356im, -0.00018729373003396166 - 0.00030182459925506003im, -0.0026156760601436222 - 0.0014624148896038823im, 0.000156850928562298 + 1.0598499752519433e-19im, 0.0026156760601436244 - 0.0014624148896038834im, -0.00018729373003396072 + 0.0003018245992550565im, -0.0002041779075170435 + 0.004935396035520369im, -0.0008264228564544821 - 0.0016462191707537323im, -0.01168549484393772 - 0.007864104118944134im, 0.016288863148509844 + 0.0013794365921490337im, 0.07308071548173986 - 0.033304055789697334im, -0.26343687913377006 + 0.3579749966180197im, -0.16550798999628585 - 1.266544062832267im, -0.14862414170934363 - 0.20056732830233107im, 0.02762650253506278 + 0.012282322562416348im, 0.0366358937246126 - 0.0031682116230846115im, -0.0002690789489010365 + 0.00021299425589269244im, -0.004780621512725416 + 0.00951131361229845im, 4.3552831305440236e-5 + 0.0011520197713298273im, -0.0027488866514098426 - 0.004457132665260594im, -0.0009682204251114654 - 0.0005420923960606529im, 0.0041528645919450225 + 7.248484446128675e-19im, 0.0009682204251114667 - 0.0005420923960606576im, -0.002748886651409862 + 0.004457132665260617im, -4.355283130543728e-5 + 0.00115201977132983im, -0.004780621512725414 - 0.009511313612298445im, 0.0002690789489011365 + 0.00021299425589272087im, 0.03663589372461249 + 0.003168211623084687im, -0.027626502535062585 + 0.012282322562416596im, -0.14862414170934277 + 0.20056732830233023im, 0.16550798999628677 - 1.266544062832265im, 0.9663711734836308 - 2.508759177188852im, -0.08441990368301572 - 0.5976486719026127im, 0.007922361746069749 + 0.010457501159778117im, 0.06378311778978495 + 0.02806078028983686im, 0.010522228941126713 - 0.0009872353870385142im, -0.012895443750939442 + 0.008851757750809895im, -0.0026097270576833725 + 0.005251126044978781im, -0.00027826022511419406 - 0.0059445656398531685im, -0.001988047464755638 - 0.0032080581515552846im, 0.003219591093161601 + 0.001792491815832394im, 0.0032383339651185215 - 1.9677634155901465e-18im, -0.0032195910931616116 + 0.0017924918158324084im, -0.0019880474647556187 + 0.0032080581515552663im, 0.00027826022511421775 - 0.005944565639853253im, -0.0026097270576833213 - 0.005251126044978764im, 0.01289544375093941 + 0.008851757750809885im, 0.01052222894112665 + 0.0009872353870385233im, -0.06378311778978506 + 0.028060780289836627im, 0.007922361746068087 - 0.010457501159777416im, 0.08441990368301507 - 0.5976486719026123im, 0.9663711734836365 + 2.508759177188878im]

branch = Branch(2:2, 0, 1:0, 0, 1, SVector{3}([2.4, -4.199999999999999, 0.5]), 0.0, expansion_order)
i_compressed, i = 1, 1
for n in 0:expansion_order
    for m in -n:n
        if m >= 0
            branch.local_expansion[1,1,i_compressed] = real(local_weights_test[i])
            branch.local_expansion[2,1,i_compressed] = imag(local_weights_test[i])
            i_compressed += 1
        end
        i += 1
    end
end

Δx = x_target - branch.center
harmonics = initialize_harmonics(expansion_order)
derivatives_switch = DerivativesSwitch(true,true,true)
lamb_helmholtz = Val(false)
velocity_n_m = zeros(2,3,size(harmonics,2))
u, velocity, gradient = evaluate_local(Δx, harmonics, velocity_n_m, branch.local_expansion, Val(expansion_order), lamb_helmholtz, derivatives_switch)


dx = x_target - xs
dx_norm = sqrt(dx'*dx)
ϕ_test = mass/dx_norm
v_test = -dx / dx_norm^3 * mass
g_test = SMatrix{3,3}(2*dx[1]^2 - dx[2]^2 - dx[3]^2, 3*dx[1]*dx[2], 3*dx[1]*dx[3], 3*dx[1]*dx[2], -dx[1]^2+2*dx[2]^2-dx[3]^2, 3*dx[2]*dx[3], 3*dx[1]*dx[3], 3*dx[2]*dx[3], -dx[1]^2 - dx[2]^2 + 2*dx[3]^2) / dx_norm^5 * mass
@test isapprox(u, ϕ_test; atol=1e-12)
@test isapprox(velocity, v_test; atol=1e-11)
@test isapprox(gradient, g_test; atol=1e-9)

end

