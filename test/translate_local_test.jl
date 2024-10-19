@testset "local-to-local z translation" begin

expansion_order = 10
r = 0.3741657386773943
original_weights_test = ComplexF64[0.12778297701763344 + 4.529689653984122e-19im, -0.0010092849391504111 - 0.015176846608464346im, -0.017685197828786147 + 7.047314121155779e-19im, 0.0010092849391504092 - 0.015176846608464353im, -0.005383769165537648 + 0.000719239595046931im, 0.00041905590449608474 + 0.006301438762504462im, 0.0030847388658922733 + 8.131516293641283e-20im, -0.000419055904496085 + 0.006301438762504466im, -0.005383769165537655 - 0.0007192395950469293im, 0.0006397388331607851 + 0.0031687601749523318im, 0.0037255753964874115 - 0.0004977147452868291im, -0.0001890886727333038 - 0.0028433694167896177im, 0.00022268366436581746 - 1.3552527156068805e-20im, 0.00018908867273330373 - 0.0028433694167896185im, 0.0037255753964874063 + 0.0004977147452868292im, -0.0006397388331607825 + 0.0031687601749523244im, 0.002599115901068822 - 0.0007070723374102296im, -0.0006197801567081069 - 0.003069900766338801im, -0.002712315617244372 + 0.0003623492319236964im, 7.14743465702898e-5 + 0.001074776253758707im, -0.001140883558324761 + 1.5246593050577406e-19im, -7.147434657028956e-5 + 0.0010747762537587071im, -0.0027123156172443688 - 0.0003623492319236965im, 0.0006197801567081078 - 0.0030699007663388066im, 0.002599115901068864 + 0.0007070723374102277im, -0.0009405746194001323 - 0.0027280217426479438im, -0.0032374650990602445 + 0.0008807309745197885im, 0.0006227714572026438 + 0.003084717676949012im, 0.001888678612257407 - 0.00025231616357242713im, 5.487690902719242e-6 + 8.25192229024604e-5im, 0.0013023579050440363 - 4.62479989200848e-19im, -5.487690902719119e-6 + 8.251922290245873e-5im, 0.0018886786122574086 + 0.0002523161635724277im, -0.0006227714572026441 + 0.0030847176769490084im, -0.0032374650990602254 - 0.000880730974519789im, 0.0009405746194001184 - 0.0027280217426479394im, -0.0034823741609510475 + 0.0014658566388596195im, 0.0014319335499793418 + 0.004153148775007806im, 0.004149223042211617 - 0.001128768438639731im, -0.0006176575166733444 - 0.0030593884040623696im, -0.0009772719377920938 + 0.00013055753988609167im, -6.551698914121909e-5 - 0.0009851935656309445im, -0.001032259167258115 + 2.303929616531697e-19im, 6.55169891412192e-5 - 0.000985193565630944im, -0.0009772719377920912 - 0.00013055753988609097im, 0.0006176575166733438 - 0.0030593884040623683im, 0.004149223042211625 + 0.0011287684386397316im, -0.0014319335499793492 + 0.004153148775007807im, -0.0034823741609511724 - 0.0014658566388596058im, 0.0026208800417802693 + 0.0052263309867212615im, 0.006265501655366155 - 0.0026373745493930008im, -0.002231564178564571 - 0.006472382768143173im, -0.00530762678958307 + 0.0014439035545548715im, 0.000550963030801775 + 0.0027290395303358746im, -0.0002556821920589737 + 3.415792677000772e-5im, 0.00011147791363720699 + 0.0016763199196706442im, 0.00029487824344568537 + 6.098637220230962e-19im, -0.00011147791363720721 + 0.0016763199196706447im, -0.0002556821920589697 - 3.4157926770007266e-5im, -0.0005509630308017772 + 0.002729039530335873im, -0.005307626789583076 - 0.0014439035545548678im, 0.002231564178564569 - 0.006472382768143163im, 0.006265501655366137 + 0.0026373745493930125im, -0.0026208800417802645 + 0.005226330986721325im, 0.009000501322035573 - 0.005288466054274077im, -0.005440959094594392 - 0.010849892471560794im, -0.011498630370706897 + 0.004840182330126911im, 0.0034875264952595408 + 0.010115160813608325im, 0.006455862608574734 - 0.0017562705882766692im, -0.0003205016247614424 - 0.0015875214822021492im, 0.001996270950737139 - 0.0002666900685568866im, -0.00012663226789561634 - 0.001904204784520339im, 0.0010733551237127564 + 5.404070203482436e-19im, 0.000126632267895617 - 0.001904204784520338im, 0.0019962709507371362 + 0.00026669006855688617im, 0.0003205016247614459 - 0.0015875214822021425im, 0.006455862608574739 + 0.001756270588276669im, -0.0034875264952595408 + 0.010115160813608328im, -0.01149863037070687 - 0.004840182330126909im, 0.005440959094594379 - 0.010849892471560752im, 0.009000501322035203 + 0.005288466054274138im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im]

translated_weights_test = ComplexF64[0.13461314440279862 + 1.952465349074102e-19im, -0.0011799325812469452 - 0.017742913951352295im, -0.01881272546341661 + 6.716367202382708e-19im, 0.0011799325812469432 - 0.0177429139513523im, -0.006984877973336121 + 0.0009331382195095377im, 0.0004947009002106113 + 0.007438929803503707im, 0.0029093291971084415 + 1.0124930938295555e-19im, -0.0004947009002106115 + 0.007438929803503712im, -0.006984877973336126 - 0.0009331382195095361im, 0.0009210953554006108 + 0.004562377929412007im, 0.00488083977488072 - 0.0006520511877200239im, -0.00021477700848889156 - 0.003229650888589692im, 0.000749915651209332 - 1.0452007839326191e-19im, 0.0002147770084888914 - 0.003229650888589693im, 0.004880839774880714 + 0.000652051187720024im, -0.0009210953554006085 + 0.004562377929412001im, 0.004152520737680924 - 0.0011296658203543033im, -0.0009011078695996445 - 0.004463376070847926im, -0.0034835409509801755 + 0.000465380309612021im, 6.375817335365399e-5 + 0.0009587465697080577im, -0.0017021372787464465 + 3.367545011032849e-19im, -6.37581733536538e-5 + 0.0009587465697080585im, -0.003483540950980173 - 0.0004653803096120213im, 0.0009011078695996456 - 0.004463376070847931im, 0.00415252073768096 + 0.0011296658203543016im, -0.001663012554667251 - 0.004823365270068046im, -0.005217859206231301 + 0.0014194838798908581im, 0.0008952433006352723 + 0.004434328676300843im, 0.0022190140240920145 - 0.00029644692036492085im, 3.891092480327646e-5 + 0.0005851120199324291im, 0.001699864432611912 - 5.107127231545465e-19im, -3.89109248032764e-5 + 0.0005851120199324273im, 0.002219014024092015 + 0.00029644692036492117im, -0.0008952433006352724 + 0.004434328676300839im, -0.0052178592062312856 - 0.0014194838798908588im, 0.0016630125546672398 - 0.004823365270068042im, -0.006631614341965045 + 0.0027914845984110953im, 0.0025110352639261353 + 0.007282953911405517im, 0.006587065523160125 - 0.0017919666198880366im, -0.0008462441198105274 - 0.004191627999564452im, -0.0007418654549820928 + 9.910850918552132e-5im, -0.00011609246379619257 - 0.001745709381550565im, -0.0010674576443769693 + 4.003134303422991e-20im, 0.0001160924637961928 - 0.0017457093815505648im, -0.0007418654549820918 - 9.910850918552083e-5im, 0.0008462441198105279 - 0.004191627999564449im, 0.0065870655231601355 + 0.0017919666198880357im, -0.002511035263926142 + 0.007282953911405515im, -0.006631614341965161 - 0.002791484598411086im, 0.004656700520522666 + 0.009285989017913105im, 0.01056789518180002 - 0.004448404946278208im, -0.003536477105820341 - 0.010257129385807563im, -0.0077231893913202055 + 0.002101039836534793im, 0.0006708837579779451 + 0.0033230356783902734im, -0.0010026183869417593 + 0.00013394421326952012im, 0.00015885936969476397 + 0.0023888081094637255im, -0.00010673446928146404 + 4.0766193006804603e-19im, -0.0001588593696947644 + 0.0023888081094637255im, -0.0010026183869417545 - 0.0001339442132695195im, -0.0006708837579779486 + 0.0033230356783902695im, -0.0077231893913202124 - 0.002101039836534789im, 0.003536477105820339 - 0.010257129385807556im, 0.010567895181799992 + 0.0044484049462782185im, -0.004656700520522656 + 0.009285989017913152im, 0.009000501322035573 - 0.005288466054274077im, -0.005440959094594392 - 0.010849892471560794im, -0.011498630370706897 + 0.004840182330126911im, 0.0034875264952595408 + 0.010115160813608325im, 0.006455862608574734 - 0.0017562705882766692im, -0.0003205016247614424 - 0.0015875214822021492im, 0.001996270950737139 - 0.0002666900685568866im, -0.00012663226789561634 - 0.001904204784520339im, 0.0010733551237127564 + 5.404070203482436e-19im, 0.000126632267895617 - 0.001904204784520338im, 0.0019962709507371362 + 0.00026669006855688617im, 0.0003205016247614459 - 0.0015875214822021425im, 0.006455862608574739 + 0.001756270588276669im, -0.0034875264952595408 + 0.010115160813608328im, -0.01149863037070687 - 0.004840182330126909im, 0.005440959094594379 - 0.010849892471560752im, 0.009000501322035203 + 0.005288466054274138im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im]

original_weights = initialize_expansion(expansion_order)
z_translated_weights = initialize_expansion(expansion_order)

i = 1
i_compressed = 1
for n in 0:expansion_order
    for m in -n:n
        if m >= 0
            original_weights[1,1,i_compressed] = real(original_weights_test[i])
            original_weights[2,1,i_compressed] = imag(original_weights_test[i])
            i_compressed += 1
        end
        i += 1
    end
end

FastMultipole.translate_local_z!(z_translated_weights, original_weights, r, expansion_order, Val(false))

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

@testset "local-to-local: point-and-shoot" begin

#--- l2l ---#

x = SVector{3}(0.1,0.2,-0.3)
xs = x + SVector{3}(-0.2,0.07,-0.1)
bodies = zeros(5,1)
bodies .= [xs[1], xs[2], xs[3], 0.0, 0.7]
masses = Gravitational(bodies)
expansion_order = 10
box = SVector{3}(0.0,0.0,0.0)
source_box = SVector{6}(0.0 for _ in 1:6)
source_branch = Branch(1:1, 0, 1:0, 0, 1, SVector{3}([2.5, -4.3999999999999995, 0.8]), 0.0, 0.0, source_box, box, expansion_order)
target_branch = Branch(1:1, 0, 1:0, 0, 1, SVector{3}([2.4, -4.199999999999999, 0.5]), 0.0, 0.0, source_box, box, expansion_order)

source_weights_test = ComplexF64[0.12778297701763344 + 4.529689653984122e-19im, 0.01988565068340494 + 0.011071240208005997im, 0.005109803172606758 + 3.2526065174565133e-19im, -0.019885650683404945 + 0.011071240208006im, 0.006406175925111939 + 0.010337471580447111im, 0.002385570364972926 + 0.0013281548027035902im, -0.0036451747879949242 - 3.049318610115481e-20im, -0.0023855703649729256 + 0.0013281548027035898im, 0.006406175925111935 - 0.010337471580447108im, 0.0005064190184181157 + 0.0108187987474021im, 0.0012808552115572672 + 0.002066881133029694im, -0.0015110027367938065 - 0.0008412434953346443im, -0.00140992377229235 - 7.115076756936123e-20im, 0.0015110027367938065 - 0.0008412434953346439im, 0.0012808552115572695 - 0.002066881133029696im, -0.0005064190184181154 + 0.010818798747402106im, -0.00600979378232354 + 0.012092524633138818im, 0.00014175533778046622 + 0.0030283652269413376im, -0.0007088462454376961 - 0.0011438458938830946im, -0.001058918726541237 - 0.0005895478906568543im, 0.0006985665458948552 - 1.1779382795000135e-19im, 0.001058918726541237 - 0.0005895478906568545im, -0.0007088462454376964 + 0.0011438458938830957im, -0.00014175533778046644 + 0.0030283652269413363im, -0.006009793782323535 - 0.012092524633138793im, -0.017846596319110775 + 0.012250354186902287im, -0.0021628838222466995 + 0.00435201787134357im, -6.711258877263314e-5 - 0.001433749642424643im, -0.000767299139505339 - 0.0012381696520475816im, 0.00037417963078447444 + 0.00020832271843066228im, 0.0010031457155584922 + 1.2180317237904588e-19im, -0.0003741796307844752 + 0.00020832271843066233im, -0.0007672991395053396 + 0.001238169652047583im, 6.711258877263316e-5 - 0.0014337496424246432im, -0.0021628838222466987 - 0.004352017871343578im, 0.017846596319110775 + 0.012250354186902285im, -0.0422254692979453 + 0.0039617607195511755im, -0.007850172482929591 + 0.005388558288009481im, 0.000851017065931367 - 0.0017123618690188128im, -0.00010510135582031117 - 0.0022453119320058495im, 0.0001585337136231433 + 0.0002558216546230435im, 0.0010114739907600583 + 0.0005631332487366796im, -0.00014071294694094805 + 5.1777706484880617e-20im, -0.0010114739907600577 + 0.00056313324873668im, 0.000158533713623143 - 0.0002558216546230434im, 0.00010510135582031068 - 0.002245311932005849im, 0.0008510170659313671 + 0.0017123618690188147im, 0.007850172482929582 + 0.005388558288009473im, -0.042225469297945226 - 0.0039617607195511365im, -0.08988721063334315 - 0.03954501582849908im, -0.0219507296948253 + 0.0020595118239022173im, 0.0024609342549554544 - 0.0016892459109781428im, 0.00188389208320225 - 0.003790649516221961im, 5.746722439507631e-6 + 0.0001227763044802724im, 0.0009006229151328835 + 0.0014533104799389531im, 8.939703828641429e-5 + 4.977129351573298e-5im, -0.0012765669625816212 - 3.0557917426951705e-20im, -8.939703828641551e-5 + 4.9771293515732507e-5im, 0.0009006229151328834 - 0.0014533104799389518im, -5.7467224395056585e-6 + 0.00012277630448027281im, 0.001883892083202249 + 0.0037906495162219546im, -0.0024609342549554553 - 0.001689245910978146im, -0.021950729694825304 - 0.002059511823902216im, 0.08988721063334319 - 0.039545015828499064im, -0.15843120086296467 - 0.20912900046970154im, -0.053916337687050585 - 0.02371993084526941im, 0.0051257565765804244 - 0.00048091195635664084im, 0.007754397654929301 - 0.005322819104358317im, 0.00019415738394774093 - 0.00039067517018100925im, 0.00014354105250680534 + 0.003066505906362175im, 0.00030248360848619154 + 0.0004881087272936323im, -0.0015642563554373414 - 0.0008708921388456051im, -0.0005359500072129925 - 3.8273545140644316e-19im, 0.0015642563554373434 - 0.0008708921388456052im, 0.0003024836084861944 - 0.00048810872729363445im, -0.00014354105250680534 + 0.003066505906362176im, 0.0001941573839477417 + 0.0003906751701810133im, -0.007754397654929301 - 0.005322819104358313im, 0.005125756576580412 + 0.0004809119563566352im, 0.0539163376870506 - 0.023719930845269428im, -0.15843120086296497 + 0.20912900046970165im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im]

translated_weights_test = ComplexF64[0.13461314440279862 + 1.9524653490741017e-19im, 0.022252245870682204 + 0.01244532766560858im, 0.004480317929523328 + 1.6263032587282567e-19im, -0.022252245870682193 + 0.01244532766560858im, 0.00758342609110143 + 0.012343660966904242im, 0.002221858296636837 + 0.0012426500507872356im, -0.004530777257739682 - 3.5236570605778894e-19im, -0.002221858296636834 + 0.001242650050787233im, 0.007583426091101415 - 0.012343660966904224im, 0.000561882925238131 + 0.013707914931637111im, 0.0012619906674759653 + 0.0020541633828984928im, -0.002098994385188894 - 0.0011739344818844876im, -0.0014167313141975764 + 1.6601845766184287e-19im, 0.002098994385188896 - 0.0011739344818844873im, 0.0012619906674759694 - 0.0020541633828984993im, -0.0005618829252381299 + 0.013707914931637127im, -0.008221287450149573 + 0.016225916231728095im, 0.00013089207035379098 + 0.003193970671112981im, -0.001108309031650121 - 0.001804008988426478im, -0.0011464731610814386 - 0.0006412092488342131im, 0.0011780676919288427 - 1.4738373282224826e-19im, 0.0011464731610814406 - 0.0006412092488342157im, -0.0011083090316501257 + 0.001804008988426484im, -0.00013089207035379513 + 0.0031939706711129863im, -0.008221287450149556 - 0.016225916231728033im, -0.025725111011118018 + 0.01729700422929872im, -0.0024673427304220397 + 0.004868764430261571im, -0.00010643987355253296 - 0.002591826549161654im, -0.0008938657431078131 - 0.0014550875094979892im, 0.0008210525866812173 + 0.0004591631749931705im, 0.0011938589676145606 - 3.9641141931501256e-19im, -0.0008210525866812204 + 0.0004591631749931709im, -0.0008938657431078154 + 0.0014550875094979934im, 0.00010643987355253425 - 0.0025918265491616625im, -0.0024673427304220427 - 0.004868764430261585im, 0.025725111011118056 + 0.01729700422929875im, -0.06386347254250567 + 0.005297665211147122im, -0.009530599347333232 + 0.006407494145601602im, 0.0017996818761755258 - 0.003561028145214491im, -0.00011808717822313273 - 0.002876072167262429im, 0.0005197466843168432 + 0.0008445387473581388im, 0.0013364051523488676 + 0.000747371278587796im, -0.000631077305096026 - 4.840793293558326e-19im, -0.0013364051523488696 + 0.0007473712785877967im, 0.0005197466843168406 - 0.0008445387473581359im, 0.00011808717822313063 - 0.0028760721672624243im, 0.0017996818761755239 + 0.0035610281452144914im, 0.009530599347333243 + 0.006407494145601611im, -0.06386347254250549 - 0.005297665211147058im, -0.1328983033047168 - 0.05986053171909518im, -0.028032213753530464 + 0.002383624064510066im, 0.00523683411437066 - 0.0035611110189296335im, 0.0025904092987290264 - 0.005141681503720106im, 4.284809359333424e-5 + 0.0009300176370197479im, 0.001271928426848982 + 0.0020645186677943485im, -0.0002716310704101797 - 0.00015101215547224102im, -0.001837292449717549 - 1.1744111813680874e-18im, 0.0002716310704101757 - 0.00015101215547223956im, 0.0012719284268489853 - 0.0020645186677943545im, -4.284809359332714e-5 + 0.0009300176370197561im, 0.002590409298729017 + 0.0051416815037200895im, -0.005236834114370651 - 0.003561111018929635im, -0.02803221375353053 - 0.002383624064510045im, 0.13289830330471694 - 0.05986053171909513im, -0.158431200862967 - 0.20912900046970162im, -0.05391633768704997 - 0.023719930845269504im, 0.005125756576580497 - 0.0004809119563566985im, 0.0077543976549292295 - 0.005322819104358208im, 0.00019415738394774033 - 0.0003906751701810075im, 0.00014354105250679697 + 0.003066505906362142im, 0.0003024836084861841 + 0.0004881087272936205im, -0.001564256355437323 - 0.0008708921388455957im, -0.0005359500072129798 - 2.5035117547284914e-19im, 0.0015642563554373252 - 0.0008708921388455959im, 0.0003024836084861885 - 0.0004881087272936251im, -0.00014354105250679873 + 0.0030665059063621457im, 0.00019415738394773732 + 0.0003906751701810142im, -0.007754397654929212 - 0.005322819104358191im, 0.005125756576580445 + 0.000480911956356678im, 0.053916337687049905 - 0.023719930845269493im, -0.15843120086296728 + 0.20912900046970181im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im]

i, i_compressed = 1, 1
for n in 0:expansion_order
    for m in -n:n
        if m >= 0
            source_branch.local_expansion[1,1,i_compressed] = real(source_weights_test[i])
            source_branch.local_expansion[2,1,i_compressed] = imag(source_weights_test[i])
            i_compressed += 1
        end
        i += 1
    end
end

# preallocate containers
Hs_π2 = [1.0]
FastMultipole.update_Hs_π2!(Hs_π2, Val(expansion_order))
Ts = zeros(FastMultipole.length_Ts(expansion_order))
eimϕs = zeros(2, expansion_order+1)
weights_tmp_1 = initialize_expansion(expansion_order, eltype(Ts))
weights_tmp_2 = initialize_expansion(expansion_order, eltype(Ts))

# normalization
ηs_mag = zeros(FastMultipole.length_ηs(expansion_order))
FastMultipole.update_ηs_mag!(ηs_mag, 0, expansion_order)

# transform
lamb_helmholtz = Val(false)
FastMultipole.local_to_local!(target_branch, source_branch, weights_tmp_1, weights_tmp_2, Ts, eimϕs, ηs_mag, Hs_π2, Val(expansion_order), lamb_helmholtz)

i = 1
i_compressed = 1
for n in 0:expansion_order
    for m in -n:n
        if m >= 0
            @test isapprox(target_branch.local_expansion[1,1,i_compressed], real(translated_weights_test[i]); atol=1e-12)
            @test isapprox(target_branch.local_expansion[2,1,i_compressed], imag(translated_weights_test[i]); atol=1e-12)
            i_compressed += 1
        end
        i += 1
    end
end

end
