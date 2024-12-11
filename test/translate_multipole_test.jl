@testset "multipole-to-multipole z translation" begin

expansion_order = 10
r = 0.2638181191654584

original_weights = initialize_expansion(expansion_order)
vec(original_weights) .= vec([0.7 0.0; 0.0 0.0;;; -0.05306686305052319 0.0; 0.0 0.0;;; 0.07356663645974308 0.0; 0.024681511531797543 0.0;;; -0.00659025862068966 0.0; 0.0 0.0;;; -0.00557707231728116 0.0; -0.0018711005604825806 0.0;;; 0.0034306235632183893 0.0; 0.0025939082659095806 0.0;;; 0.0006012668738872938 0.0; 0.0 0.0;;; -0.00024060306691568048 0.0; -8.072201824688345e-5 0.0;;; -0.00026007490115315443 0.0; -0.00019664367816091976 0.0;;; 8.969421891811595e-5 0.0; 0.00013118956259282094 0.0;;; 2.67073310887066e-6 0.0; 0.0 0.0;;; 2.8924118015615912e-5 0.0; 9.704004243012407e-6 0.0;;; -4.193970166413464e-6 0.0; -3.1710777009391004e-6 0.0;;; -6.7997011882161365e-6 0.0; -9.945455073958955e-6 0.0;;; 1.2001947477512361e-6 0.0; 4.237487056122078e-6 0.0;;; -1.3932704466677216e-6 0.0; 0.0 0.0;;; -2.718948824260198e-7 0.0; -9.122038194184309e-8 0.0;;; 8.161718377855182e-7 0.0; 6.171108072400593e-7 0.0;;; -1.7803529229221492e-8 0.0; -2.6039997230170803e-8 0.0;;; -9.098652901838843e-8 0.0; -3.2124306469370694e-7 0.0;;; -4.655227129374754e-9 0.0; 9.753151150503562e-8 0.0;;; 2.82009975582671e-8 0.0; 2.481541837659083e-24 0.0;;; -3.8891394365382955e-8 0.0; -1.3048012587093883e-8 0.0;;; -1.4073848083069977e-8 0.0; -1.0641293106954326e-8 0.0;;; 1.4375929554751338e-8 0.0; 2.1026683022623636e-8 0.0;;; 4.991844476710053e-10 0.0; 1.7624536681123476e-9 0.0;;; 3.5291185791944553e-10 0.0; -7.3938448059260725e-9 0.0;;; -6.546891732831977e-10 0.0; 1.6809921924246207e-9 0.0;;; 9.93830410681501e-10 0.0; 6.462348535570529e-26 0.0;;; 1.1094909587453457e-9 0.0; 3.7223278391534667e-10 0.0;;; -6.875037819511618e-10 0.0; -5.198243730286225e-10 0.0;;; -3.2976148841065995e-10 0.0; -4.823194398297435e-10 0.0;;; 1.3646062012108493e-10 0.0; 4.817969021418713e-10 0.0;;; -3.843014848133845e-12 0.0; 8.051487853507097e-11 0.0;;; 4.9631858141828156e-11 0.0; -1.2743568923485148e-10 0.0;;; -1.829647114025402e-11 0.0; 2.1940045537068627e-11 0.0;;; -4.184947032701808e-11 0.0; 0.0 0.0;;; 1.3864812109040202e-11 0.0; 4.651626558225804e-12 0.0;;; 2.5907452797265855e-11 0.0; 1.9588729197803936e-11 0.0;;; -7.531840431603017e-12 0.0; -1.1016304770355222e-11 0.0;;; -3.8037712476286606e-12 0.0; -1.3429846661532513e-11 0.0;;; -3.8473815238603275e-13 0.0; 8.060636461556301e-12 0.0;;; -7.320102221968134e-13 0.0; 1.879523166874753e-12 0.0;;; 1.3870518975824416e-12 0.0; -1.6632705597683745e-12 0.0;;; -3.370577371076018e-13 0.0; 2.0758406973149227e-13 0.0;;; -7.741813097290868e-15 0.0; 1.8932661725304283e-29 0.0;;; -9.847445177961088e-13 0.0; -3.3038051406848236e-13 0.0;;; 5.656228381291999e-14 0.0; 4.276697014912757e-14 0.0;;; 3.8625959245159264e-13 0.0; 5.649553292533447e-13 0.0;;; -3.983868345945093e-14 0.0; -1.4065709403300842e-13 0.0;;; 1.262177186082802e-14 0.0; -2.644383299131543e-13 0.0;;; -3.9586636278448776e-14 0.0; 1.0164338929680191e-13 0.0;;; -2.447218735092076e-14 0.0; 2.9345598982177417e-14 0.0;;; 2.55522811074405e-14 0.0; -1.5736907714159062e-14 0.0;;; -4.749157559148237e-15 0.0; 1.1035186297567927e-15 0.0;;; 2.3086871223426327e-14 0.0; 0.0 0.0;;; 6.6387304112083176e-15 0.0; 2.2272854800205096e-15 0.0;;; -1.5664486419769365e-14 0.0; -1.1843981147074518e-14 0.0;;; -1.5699448227709196e-15 0.0; -2.296250272073904e-15 0.0;;; 3.1691682699358898e-15 0.0; 1.1189275363592607e-14 0.0;;; 3.9225300173694655e-17 0.0; -8.21807982480209e-16 0.0;;; 1.518865766816751e-15 0.0; -3.899868211591085e-15 0.0;;; -8.019558079784348e-16 0.0; 9.616579509178086e-16 0.0;;; -5.083523731721492e-16 0.0; 3.130794604695545e-16 0.0;;; 3.6003270542382312e-16 0.0; -8.365753142714921e-17 0.0;;; -5.380229363282785e-17 0.0; -5.147747600081278e-18 0.0])

translated_weights_test = ComplexF64[0.6999999999999998 + 0.0im, -0.07356663645974308 + 0.024681511531797526im, -0.23773954646634407 + 0.0im, 0.07356663645974311 + 0.024681511531797526im, 0.0034306235632183884 - 0.0025939082659095793im, 0.024985283981419623 - 0.008382530510961977im, 0.031769741379310344 - 3.2526065174565133e-18im, -0.024985283981419634 - 0.00838253051096198im, 0.0034306235632183893 + 0.0025939082659095797im, -8.969421891811593e-5 + 0.0001311895625928208im, -0.0011651355571661334 + 0.0008809636781609209im, -0.003790848611078241 + 0.0012718248136956213im, -0.001649033453770145 + 9.123066424449642e-19im, 0.0037908486110782426 + 0.0012718248136956217im, -0.0011651355571661334 - 0.0008809636781609212im, 8.969421891811597e-5 + 0.0001311895625928209im, 1.2001947477512393e-6 - 4.237487056122075e-6im, 3.0462661323208368e-5 - 4.455563873133615e-5im, 0.00018380420109795435 - 0.00013897509527090591im, 0.0003268178053506392 - 0.00010964695165821003im, -8.160736267657003e-5 - 1.2918638159900676e-19im, -0.00032681780535063934 - 0.0001096469516582101im, 0.00018380420109795432 + 0.000138975095270906im, -3.0462661323208398e-5 - 4.455563873133616e-5im, 1.2001947477512431e-6 + 4.237487056122076e-6im, 4.6552271293746276e-9 + 9.753151150503568e-8im, -4.076196500023822e-7 + 1.4391689298278087e-6im, -4.8974396674835295e-6 + 7.163148032856419e-6im, -1.7626693010955588e-5 + 1.3327613437970693e-5im, -1.5640561537203722e-5 + 5.247388198256508e-6im, 2.082845021262926e-5 + 1.2657933764900136e-20im, 1.564056153720373e-5 + 5.247388198256506e-6im, -1.762669301095558e-5 - 1.33276134379707e-5im, 4.897439667483536e-6 + 7.1631480328564204e-6im, -4.0761965000238307e-7 - 1.4391689298278087e-6im, -4.655227129374675e-9 + 9.753151150503563e-8im, -6.546891732831972e-10 - 1.6809921924246199e-9im, -1.5810451234790784e-9 - 3.3124424730548866e-8im, 6.626985662443882e-8 - 2.3397674434360217e-7im, 4.920471157653198e-7 - 7.196834608843871e-7im, 1.1129967976320182e-6 - 8.415413524998282e-7im, 1.3343305238960281e-7 - 4.476661676763041e-8im, -1.7885762526354506e-6 - 9.402456715970773e-22im, -1.3343305238960255e-7 - 4.476661676762987e-8im, 1.112996797632017e-6 + 8.415413524998286e-7im, -4.920471157653208e-7 - 7.196834608843872e-7im, 6.62698566244389e-8 + 2.3397674434360215e-7im, 1.5810451234790789e-9 - 3.312442473054885e-8im, -6.54689173283195e-10 + 1.680992192424621e-9im, 1.8296471140253962e-11 + 2.1940045537068756e-11im, 2.2235072447538981e-10 + 5.709118877721357e-10im, 2.589494615378672e-10 + 5.4252417090110276e-9im, -6.834508695234381e-9 + 2.4130368996592393e-8im, -3.41709849334582e-8 + 4.997954852451299e-8im, -4.4766028581788737e-8 + 3.3847774152554036e-8im, 4.132799367099985e-8 - 1.3865488507620207e-8im, 9.12362376268825e-8 + 5.145360382091641e-23im, -4.1327993670999886e-8 - 1.3865488507620273e-8im, -4.476602858178862e-8 - 3.384777415255406e-8im, 3.417098493345827e-8 + 4.997954852451299e-8im, -6.834508695234388e-9 - 2.4130368996592387e-8im, -2.5894946153786565e-10 + 5.425241709011027e-9im, 2.2235072447538948e-10 - 5.70911887772136e-10im, -1.8296471140254004e-11 + 2.194004553706873e-11im, -3.370577371076028e-13 - 2.075840697314912e-13im, -6.213992501169337e-12 - 7.451452107762362e-12im, -3.660897691811594e-11 - 9.399789531174407e-11im, -2.7156797332862082e-11 - 5.689611737302538e-10im, 4.982595527552224e-10 - 1.7591881728739676e-9im, 1.6934465331286442e-9 - 2.4768877262680044e-9im, 7.494821127304962e-10 - 5.666864380594377e-10im, -3.690346781366762e-9 + 1.2381065796106947e-9im, -2.6652314917340937e-9 - 1.7122479529825967e-24im, 3.690346781366768e-9 + 1.2381065796107e-9im, 7.494821127304879e-10 + 5.666864380594379e-10im, -1.6934465331286496e-9 - 2.4768877262680044e-9im, 4.982595527552231e-10 + 1.7591881728739668e-9im, 2.7156797332861807e-11 - 5.689611737302538e-10im, -3.660897691811593e-11 + 9.399789531174414e-11im, 6.213992501169346e-12 - 7.451452107762357e-12im, -3.370577371076029e-13 + 2.0758406973149166e-13im, 0.0 + 0.0im, 8.89219382538933e-14 + 5.476443884527337e-14im, 1.0026466184859188e-12 + 1.202314495431364e-12im, 3.92384507283478e-12 + 1.0074938155218149e-11im, 2.051859758789314e-12 + 4.2988446773800896e-11im, -2.69218827528287e-11 + 9.505218207736519e-11im, -5.733988460753649e-11 + 8.38671039395858e-11im, 3.938169472147141e-11 - 2.977665767785949e-11im, 1.8037034156400178e-10 - 6.051401667306483e-11im, 4.696859634967631e-12 - 1.0307637820901324e-26im, -1.803703415640022e-10 - 6.051401667306518e-11im, 3.9381694721471925e-11 + 2.9776657677859476e-11im, 5.733988460753679e-11 + 8.386710393958585e-11im, -2.6921882752828766e-11 - 9.505218207736512e-11im, -2.051859758789288e-12 + 4.298844677380091e-11im, 3.923845072834781e-12 - 1.0074938155218155e-11im, -1.00264661848592e-12 + 1.2023144954313637e-12im, 8.892193825389332e-14 - 5.476443884527349e-14im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, -1.1729609251344577e-14 - 7.223925626655894e-15im, -1.0426191703747706e-13 - 1.2502472143666966e-13im, -3.095043066696304e-13 - 7.946890589687405e-13im, -1.1918086597379006e-13 - 2.4969544294746488e-12im, 1.0817780393108883e-12 - 3.819397183470382e-12im, 9.287348591267403e-13 - 1.3583965767601614e-12im, -3.904643992538374e-12 + 2.952317017894489e-12im, -5.4225549875502765e-12 + 1.8192601958941995e-12im, 4.056590985799263e-12 + 6.1035295151198015e-27im, 5.422554987550302e-12 + 1.8192601958942218e-12im, -3.9046439925384024e-12 - 2.9523170178944902e-12im, -9.287348591267546e-13 - 1.3583965767601628e-12im, 1.081778039310893e-12 + 3.8193971834703776e-12im, 1.1918086597378847e-13 - 2.496954429474649e-12im, -3.0950430666963064e-13 + 7.946890589687411e-13im, 1.0426191703747713e-13 - 1.2502472143666966e-13im, -1.172960925134458e-14 + 7.22392562665591e-15im, 0.0 + 0.0im, 0.0 + 0.0im]

z_translated_weights = zero(original_weights)

FastMultipole.translate_multipole_z!(z_translated_weights, original_weights, r, expansion_order, Val(false))

i = 1
i_compressed = 1
for n in 0:expansion_order
    for m in -n:n
        if m >= 0
            @test isapprox(z_translated_weights[1,1,i_compressed], real(translated_weights_test[i]); atol=1e-12)
            @test isapprox(z_translated_weights[2,1,i_compressed], imag(translated_weights_test[i]); atol=1e-12)
        end
    end
end

end

@testset "multipole-to-multipole: point-and-shoot" begin

#--- m2m ---#

x = SVector{3}(0.1,0.2,-0.3)
xs = x + SVector{3}(-0.2,0.07,-0.1)
bodies = zeros(5,1)
bodies[:,1] .= [xs[1], xs[2], xs[3], 0.0, 0.7]
masses = Gravitational(bodies)
expansion_order = 7
box = SVector{3}(0.0,0.0,0.0)

branch = Branch(1:1, 0, 1:0, 0, 1, x, x, 0.0, 0.0, box, box, expansion_order)

body_to_multipole!(Point{Source}, masses, branch, 1:1, branch.harmonics, Val(expansion_order))

# translate multipole

translated_weights_test = -ComplexF64[0.6999999999999997 + 0.0im, -0.04549999999999994 + 0.105im, -0.16800000000000004 + 1.3877787807814457e-17im, 0.04549999999999993 + 0.10500000000000002im, -0.006396250000000003 - 0.0068249999999999995im, 0.01092 - 0.025200000000000018im, 0.0014525000000000215 - 3.0357660829594124e-18im, -0.010919999999999996 - 0.025200000000000007im, -0.0063962500000000104 + 0.0068249999999999995im, 0.0004798354166666664 - 0.0001719375000000007im, 0.0015351000000000026 + 0.0016380000000000001im, -0.000702406250000003 + 0.0016209375000000048im, 0.002877000000000001 + 2.032879073410321e-18im, 0.0007024062500000036 + 0.0016209375000000043im, 0.001535100000000001 - 0.0016380000000000006im, -0.0004798354166666666 - 0.00017193750000000076im, -1.349669270833318e-6 + 2.0787812499999992e-5im, -0.00011516050000000012 + 4.126500000000017e-5im, -0.0001272320729166672 - 0.00013576062500000074im, -4.1086500000000305e-5 + 9.481499999999968e-5im, -0.0003170185156250007 + 2.574980159653073e-19im, 4.1086499999999845e-5 + 9.481499999999992e-5im, -0.00012723207291666732 + 0.00013576062500000053im, 0.00011516049999999991 + 4.126500000000027e-5im, -1.3496692708333037e-6 - 2.0787812499999968e-5im, -6.060886744791653e-7 - 3.107316406250009e-7im, 3.239206249999994e-7 - 4.98907500000001e-6im, 1.0613359622395868e-5 - 3.803042578125006e-6im, 1.0617775000000123e-6 + 1.132950000000023e-6im, 8.512194505208339e-6 - 1.964352578125005e-5im, 8.45973975000003e-6 - 9.64161721991809e-21im, -8.512194505208354e-6 - 1.964352578125004e-5im, 1.0617775000000106e-6 - 1.1329500000000054e-6im, -1.0613359622395861e-5 - 3.803042578125013e-6im, 3.239206249999995e-7 + 4.9890750000000036e-6im, 6.06088674479168e-7 - 3.107316406249974e-7im, 1.4334251655815852e-8 - 1.1785957421874978e-8im, 1.4546128187499996e-7 + 7.457559375000016e-8im, -3.165649274739579e-8 + 4.875781421875007e-7im, -3.3612470937500034e-7 + 1.2044221875000208e-7im, 5.664557310872386e-7 + 6.04426087890626e-7im, -4.4895612124999916e-7 + 1.036052587500002e-6im, 8.282175800086791e-7 - 1.1861769984010417e-21im, 4.489561212499999e-7 + 1.0360525875000016e-6im, 5.664557310872376e-7 - 6.044260878906239e-7im, 3.3612470937500145e-7 + 1.204422187500026e-7im, -3.165649274739551e-8 - 4.875781421875012e-7im, -1.4546128187499993e-7 + 7.457559374999993e-8im, 1.4334251655815931e-8 + 1.178595742187497e-8im, 1.1945246509331642e-10 + 4.1660356868489276e-10im, -3.440220397395825e-9 + 2.828629781250016e-9im, -1.4755733854090766e-8 - 7.565020734049499e-9im, 1.3782822593751201e-9 - 2.1228514125000105e-8im, -1.7429714115852795e-8 + 6.245519540039174e-9im, -4.3155650660937844e-8 - 4.604843709375021e-8im, 1.0147962359218857e-11 - 2.3418374674631308e-11im, -8.113604160208373e-8 + 6.839749690047848e-23im, -1.0147962359091342e-11 - 2.3418374674686984e-11im, -4.315565066093774e-8 + 4.604843709375028e-8im, 1.742971411585284e-8 + 6.245519540039171e-9im, 1.3782822593750914e-9 + 2.1228514125000174e-8im, 1.4755733854090784e-8 - 7.565020734049517e-9im, -3.440220397395837e-9 - 2.8286297812500145e-9im, -1.194524650933184e-10 + 4.1660356868489757e-10im, -8.78186819172502e-12 - 1.1451702750650238e-12im, -2.8668591622395816e-11 - 9.998485648437495e-11im, 3.581003226158312e-10 - 2.944384720214828e-10im, 7.485195129817691e-10 + 3.8375357617187463e-10im, 5.118269233269813e-12 - 7.883236541341276e-11im, 2.146172463804682e-9 - 7.690293696093718e-10im, 1.0363062435920712e-9 + 1.1057713679915315e-9im, 1.1716944330338503e-9 - 2.7039102300781144e-9im, 2.4351243415011286e-9 + 3.764318021969833e-25im, -1.1716944330338516e-9 - 2.7039102300781165e-9im, 1.036306243592071e-9 - 1.1057713679915313e-9im, -2.1461724638046818e-9 - 7.690293696093704e-10im, 5.118269233270907e-12 + 7.883236541340829e-11im, -7.485195129817695e-10 + 3.8375357617187644e-10im, 3.5810032261583064e-10 + 2.9443847202148324e-10im, 2.8668591622396013e-11 - 9.9984856484375e-11im, -8.781868191725032e-12 + 1.1451702750650357e-12im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im]

# preallocate containers
Hs_π2 = [1.0]
FastMultipole.update_Hs_π2!(Hs_π2, Val(expansion_order))
Ts = zeros(FastMultipole.length_Ts(expansion_order))
eimϕs = zeros(2, expansion_order+1)
weights_tmp_1 = initialize_expansion(expansion_order, eltype(Ts))
weights_tmp_2 = initialize_expansion(expansion_order, eltype(Ts))
translated_weights = initialize_expansion(expansion_order, eltype(Ts))

# normalization
ζs_mag = zeros(FastMultipole.length_ζs(expansion_order))
FastMultipole.update_ζs_mag!(ζs_mag, 0, expansion_order)

# next multipole branch
box = SVector{3}(0.0,0.0,0.0)

branch_2 = Branch(2:2, 0, 1:0, 0, 1, x + SVector{3}(0.1, 0.2, 0.14), x + SVector{3}(0.1, 0.2, 0.14), 0.0, 0.0, box, box, expansion_order)
expansion_switch = Val(false)

FastMultipole.multipole_to_multipole!(branch_2, branch, weights_tmp_1, weights_tmp_2, Ts, eimϕs, ζs_mag, Hs_π2, Val(expansion_order), expansion_switch)

i = 1
i_compressed = 1
for n in 0:expansion_order
    for m in -n:n
        if m >= 0
            @test isapprox(branch_2.multipole_expansion[1,1,i_compressed], real(translated_weights_test[i]); atol=1e-12)
            @test isapprox(branch_2.multipole_expansion[2,1,i_compressed], imag(translated_weights_test[i]); atol=1e-12)
            i_compressed += 1
        end
        i += 1
    end
end

end
