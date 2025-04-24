# Get the current 40 man rosters from BBref (since we already have bbref IDs)

# JavaScript code:
'
alltds = document.querySelectorAll("#div_the40man tr td");
bbrefids = [...alltds].filter(x => x.getAttribute("data-stat") == "player").map(x => x.getAttribute("data-append-csv")).filter(x => !x.includes("redirect"));
IDsJSON = JSON.stringify(bbrefids);
Rstring = IDsJSON.replace("[", "c(").replace("]", "),");
copy(Rstring);
Rstring;
'

# Iterate
# 1. Copy string above
# 2. Go to next team page
#        https://www.baseball-reference.com/teams/WSN/2024.shtml#the40man
#     3 teams had 40-man on other page
#       https://www.baseball-reference.com/teams/COL/2025-roster.shtml
# 3. Run JS in console
# 4. Paste in here

# Updated 3/28/25
# Update below once this list is updated
stopifnot(Sys.Date() < "2025-06-11")
bbref_40man <- list(
    ARI=c("kellyme01","galleza01","thompry02","nelsory01","burneco01","beeksja02","martiju01","pukaj01","jarvibr01","rodried05","mantijo01","millesh01","pfaadbr01","carroco02","thomaal01","perdoge01","morenga01","grichra01","gurrilo01","mccarja02","suareeu01","marteke01","hampsga01","herrejo04","naylojo01","smithpa04","alexabl01","graveke01","ginkeke01","montgjo01","walstbl01","jamesdr01","diazyi01","menacr01","nelsoky01","henryto01","delcaad01","barrojo01","lawlajo01","kessigr01"),
    ATL=c("iglesra01","suarejo01","delosen01","holmegr01","leedy01","hernada03","lopezre01","schwesp01","bummeaa01","smithaj01","nerishe01","johnspi01","salech01","ozunama01","baldwdr01","kelenja01","harrimi04","allenni02","rileyau01","delacbr01","albieoz01","profaju01","trompch01","whiteel04","arciaor01","olsonma02","alvarna01","murphse01","acunaro01","jimenjo02","stridsp01","william01","dodddy01","elderbr01","waldrhu01","danieda01","verdual01"),
    BAL=c("dominse01","kremede01","povicca01","canoye01","bautife01","sotogr01","bakerbr01","akinke01","eflinza01","perezci01","suareal01","mortoch02","laurera01","rutscad01","westbjo01","kjershe01","cowseco01","ohearry01","mullice01","oneilty01","mateojo01","mountry01","uriasra01","sanchga02","hollija01","hendegu01","mcderch01","kittran01","rodrigr01","rogertr01","bradiky01","wellsty01","gibsoky01","selbyco01","mayoco01","carlsdy01"),
    BOS=c("wilsoju10","kellyza01","crochga01","whitlga01","weissgr01","criswco01","slateju01","fittsri01","bernabr01","newcose01","chapmar01","buehlwa01","houckta01","campbkr01","abreuwi02","rafaece01","storytr01","casastr01","duranja01","bregmal01","refsnro01","hamilda03","narvaca01","gonzaro01","deverra01","wongco01","yoshima02","bellobr01","crawfku01","giolilu01","hendrli01","murphch01","penroza01","sandopa02","winckjo01","priesqu01","guerrlu01","sabolbl01","sogarni01","grissva01"),
    CHC=c("pressry01","brownbe02","boydma01","thielca01","taillja01","reaco01","pearsna01","kellebr01","steelju01","merryju01","morgael01","imanash01","hodgepo01","crowape01","turneju01","hoernni01","suzukse01","buschmi02","amayami01","happia01","tuckeky01","swansda01","kellyca02","bertijo01","shawma01","brujavi01","millety01","assadja01","brasiry01","littllu01","roberet01","neelyja01","holloga01","kiliaca01","palenda01","wicksjo01","alcanke01"),
    CHW=c("murfepe01","leasujo01","wilsobr02","burkese01","martida03","eiserbr01","cannojo02","clevimi01","ellarfr01","booseca01","perezma02","vaughan01","taylomi02","baldwbr01","leeko01","vargami01","amayaja01","roberlu01","sosale01","slateau01","jankotr01","thaisma01","beninan01","matonni01","rojasjo01","ramosbr01","tauchmi01","gilbety01","berropr01","thorpdr01","bushky01","scholje01","varlagu01","iriarja01","nastrni01","whiteow01","anderju01","shustja01","jonesgr02"),
    CIN=c("mollsa01","spierca01","ashcrgr01","greenhu01","lodolni01","gibauia01","singebr01","santito01","rogerta01","suterbr01","paganem01","martini01","barlosc01","steersp01","delacel01","mclaima01","hurtuja01","encarch01","friedtj01","espinsa01","candeje01","dunnbl01","luxga01","trevijo01","fraleja01","wynnsau01","haysau01","stephty01","lowderh01","abbotan01","diazal03","willibr02","aguiaju01","phillco01","zulueyo01","marteno01","hindsre01","bensowi01"),
    CLE=c("livelbe01","gaddihu01","ortizlu03","herriti01","bibeeta01","cantijo01","smithca06","allenlo02","williga01","mckentr01","junisja01","claseem01","sewalpa01","kwanst01","manzaky01","santaca01","hedgeau01","schneda04","noeljh01","rocchbr01","ramirjo01","ariasga01","rodrijo10","jonesno01","naylobo01","thomala02","meansjo01","stephtr01","sabroer01","biebesh01","ceccosl01","hentgsa01","fryda01","waltean01","martian02","brennwi02"),
    COL=c("hergeji01","alexasc02","feltnry01","halvose01","birdja01","perallu01","vodnivi01","kinlety01","senzaan01","marquge01","chivian01","freelky01","blalobr01","freemty01","doylebr02","tovarez01","beckjo01","goodmhu01","moniami01","farmeky01","bryankr01","martini02","stallja01","mcmahry01","bouchse01","toglimi01","estrath01","criswje01","gombeau01","gilbrlu01","hillja01","molinan01","gordota01","justiev01","romodr01","amadoad01"),
    DET=c("kahnlto01","skubata01","hanifbr01","hurtebr01","vestwi01","holtoty01","mizeca01","olsonre01","flaheja01","briesbe01","maedake01","brebbjo01","jobeja01","greenri03","keithco01","carpeke01","torkesp01","dingldi01","sweentr01","kreidry01","baezja01","margoma01","ibanean01","torregl01","mckinza01","rogerja03","perezwe01","vierlma01","cobbal01","maddety01","gipsosa01","langeal01","urquijo01","meadopa01","guentse01","hornba01","monteke01","foleyja01","mannima02","jungja01","malloju02"),
    HOU=c("abreubr01","wesneha01","blancro01","contrlu01","valdefr01","arrigsp01","brownhu01","haderjo01","kingbr02","montera01","scottta02","okertst01","walkech02","mccorch01","meyerja02","diazya02","paredis01","dezenza01","alvaryo01","smithca07","altuvjo01","penaje02","caratvi01","dubonma01","rodgebr02","trammta01","leonpe01","garcilu05","dubinsh01","mcculla02","ortka01","javiecr01","whitlfo01","francjp01","hernani01","sousabe01","salazce01","whitcsh01"),
    KCR=c("harvehu01","erceglu01","raganco01","longsa01","schrejo01","lynchda02","zerpaan01","bubickr01","stratch01","wachami01","estevca01","lugose01","lorenmi01","blancda02","melenmj01","wittbo02","garcima01","pasquvi01","massemi02","fermifr01","isbelky01","perezsa02","indiajo01","canhama01","renfrhu01","biggica01","mcartja01","wrighky01","marshal01","bowlajo01","cruzst01","loftini01","wiemejo01","gentrty01","waterdr01"),
    LAA=c("detmere01","zeferry01","anderia01","johnsry01","burkebr01","soriajo02","janseke01","joycebe01","kikucyu01","hendrky01","anderty01","kochaja01","parisky01","moncayo01","lopezni01","schanno01","ohopplo01","adelljo01","rengilu01","anderti01","solerjo01","wardta01","newmake01","troutmi01","darnatr01","netoza01","bachmsa01","stephro01","rendoan01","danaca01","aldegsa01","medervi01","silsech01","crousha01","petermi01","nodary01","campegu01","kavadni01","robinch04"),
    LAD=c("garcilu03","scottta01","yamamyo01","bandaan01","glasnty01","sasakro01","snellbl01","maydu01","treinbl01","dreyeja01","caspabe01","vesiaal01","yateski01","edmanto01","smithwi05","ohtansh01","pagesan01","confomi01","rojasmi02","freemfr01","hernaen02","muncyma01","barneau01","bettsmo01","hernate01","tayloch03","hurtky01","gonsoto01","henried01","phillev01","kopecmi01","stonega01","ryanri01","sheehem01","kershcl01","grovemi01","gratebr01","wroblju01","millebo06","knackla01","sauerma01","davisno01","outmaja01","feduchu01"),
    MIA=c("tinocje01","gillico01","venezan01","henriro01","bellova01","meyerma01","fauchca01","bendean01","bachala01","soriage01","quantca01","alcansa01","phillty01","myersda01","sanojja01","paulegr01","bridejo01","hillde01","forteni01","wagamer01","stoweky01","edwarxa01","coningr01","mervima01","lopezot01","sanchje02","norbyco01","weathry01","cronide01","cabreed02","garrebr01","perezeu02","nardian01","mazurad01","degeubr01"),
    MIL=c("civalaa01","hudsobr01","pegueel01","rodriel02","koenija01","megiltr01","peralfr01","cortene01","alexaty01","payamjo01","dunnol01","capravi01","mitchga01","colliis01","turanbr02","frelisa01","ortizjo06","contrwi02","hoskirh01","chourja01","bauerja01","haaseer01","yelicch01","perkibl01","mearsni01","myersto01","ashbyaa01","woodrbr01","halldl01","gassero01","andergr01","quintjo01","rodrica02","blackty01","monasan01","uribeab01"),
    MIN=c("couloda01","woodssi01","dobnara01","paddach01","sandsco01","duranjh01","alcaljo01","ryanjo04","jaxgr01","oberba01","lopezpa01","topaju01","varlalo01","castrwi01","jeffery01","keirsda01","vazquch01","wallnma01","miranjo01","gaspemi01","julieed01","baderha01","francty01","larnatr01","correca01","buxtoby01","leebr02","lewisro02","tonkimi01","stewabr01","fundeko01","festada01","matthze01","martiau01","camarja01"),
    NYM=c("stanery01","buttojo01","sengako01","kranima01","youngda02","garrere01","peterda01","megilty01","cannigr01","brazohu01","minteaj01","diazed04","holmecl01","tayloty01","batybr01","acunajo01","martest01","vientma01","lindofr01","sotoju01","sengeha01","nimmobr01","torrelu01","alonspe01","sirijo01","winkeje01","alvarfr01","mauriro01","mcneije01","montafr02","manaese01","blackpa01","scottch01","smithdr01","madrini01","nunezde01","hergeke01","zuberty01","warreau01","youngja02"),
    NYY=c("weavelu01","yarbrry01","willide03","leitema02","gomezyo01","friedma01","rodonca01","headrbr01","stromma01","hillti01","warrewi01","cruzfe01","carraca01","grishtr01","cabreos01","goldspa01","chishja01","wellsau01","perazos02","volpean01","dominja01","ricebe01","judgeaa01","reyespa01","bellico01","lemahdj01","stantmi03","loaisjo01","hamilia01","schmicl01","brubajt01","effrosc01","beetecl01","cousija01","colege01","gillu01","delosye01","shewmbr01","pereiev01"),
    OAK=c("spencmi01","otanemi01","bassobr01","bidoos01","searsjp01","estesjo01","waldike01","sternju01","harriho03","millema03","severlu01","ferguty01","sprinje01","leclejo01","mcfartj01","wilsoja05","soderty01","gelofza01","schuema01","harribr02","urshegi01","andujmi01","langesh01","bledajj01","peredjh01","uriaslu01","brownse01","rookebr01","butlela01","medinlu02","lopezja04","holmagr01","ginnjt01","ruizes01","hernada04","alexacj01"),
    PHI=c("wheelza01","kerkeor01","walketa01","sanchcr01","hernaca04","nolaaa01","romanjo03","rossjo01","ruizjo01","alvarjo03","strahma01","banksta01","luzarje01","bohmal01","schwaky01","clemeko01","marchra01","marshbr02","rojasjo03","stottbr01","harpebr03","sosaed01","turnetr01","keplema01","casteni01","realmjt01","wilsowe01","suarera01","johnsse01","sweetde01","lazarma01","mercami01","tylerky01","stubbga01","steveca01"),
    PIT=c("ferguca01","wentzjo01","lawreju01","mlodzca01","holdeco01","bednada01","falteba01","kellemi03","santade01","mayzati01","borucry01","heanean01","skenepa01","baeji01","phamth01","rodrien01","gonzani01","triolja01","suwinja01","reynobr01","kineris01","fraziad01","mccutan01","hayeske01","bartjo01","cruzon01","horwisp01","jonesja09","oviedjo01","moretda01","shugach01","strathu01","burromi01","nicolky01","cookbi01","valdeen01","yorkeni01","delayja01","davishe01","pegueli01"),
    SDP=c("estraje01","suarero01","ceasedy01","kingmi01","hartky01","pivetni01","peralwa01","morejad01","adamja01","matsuyu01","vasqura02","jacobal01","gourryu01","tatisfe02","lockrbr01","merrija01","machama01","maldoma01","heywaja01","diazel01","iglesjo01","sheetga01","bogaexa01","croneja01","arraelu01","britojh01","reynose01","hoeinbr01","waldrma01","darviyu01","cosgrto01","marinro01","kolekst01","campulu01","joeco01"),
    SFG=c("birdsha01","rayro02","bivensp01","trivilo01","rouppla01","rogerty01","milleer01","webblo01","dovalca01","hicksjo03","rodrira02","walkery01","verlaju01","schmica01","ramoshe02","bailepa01","matoslu02","leeju01","huffsa01","fitzgty01","wadela01","florewi01","yastrmi01","adamewi01","chapmma01","encarje01","murphto04","hjellse01","mcdontr01","harriky01","blackma01","becktr01","winnke01","luciama01","mecklwa01","mccragr01","wiselbr01","basabos01"),
    SEA=c("bazared01","santogr01","millebr04","woobr01","hancoem01","thorntr01","munozan01","snideco01","gilbelo01","speiega01","sauceta01","vargaca01","castilu02","blissry01","raleica01","raleylu01","rodriju01","mastrmi01","arozara01","mooredy01","solando01","roblevi01","tellero01","garvemi01","crawfjp01","polanjo01","taylotr01","kirbyge01","brashma01","kowarja01","boltoco01","legumca01","danneha01","kleinwi01","shentau01","locklty01","canzodo01","rivasle01"),
    STL=c("matzst01","mikolmi01","leahyky01","feddeer01","roycrch01","pallaan01","matonph01","helslry01","grayso01","kingjo01","liberma01","romerjo01","fernary01","donovbr01","arenano01","pagespe02","scottvi01","walkejo02","winnma01","burleal01","sianimi01","herreiv01","gormano01","bakerlu01","nootbla01","contrwi01","thompza02","gracego01","mcgremi01","loutory01","munozro01","obrieri01","saggeth01","helmami01","fermijo01"),
    TBR=c("litteza01","bazsh01","englema01","ucetaed01","bradlta01","fairbpe01","cleavga01","montgma01","rasmudr01","biggehu01","rodrima01","pepiory01","kellyke02","meadcu01","cabaljo01","delucjo01","wallsta01","caminju01","misneka01","morelch01","rortvbe01","lowejo01","arandjo01","lowebr01","janseda01","diazya01","kimha01","palacri01","mcclash01","faedoal01","sulseco01","orzeer01","boylejo01","wagueja01","drisclo01","monteco01"),
    TEX=c("degroja01","webbja01","garabge01","mahlety01","garciro04","jackslu01","rockeku01","milneho01","leiteja01","churcma01","martich02","eovalna01","armstsh01","duranez01","langfwy01","jungjo01","smithjo11","burgeja01","garciad02","taverle01","higasky01","heimjo01","seageco01","pillake01","pederjo01","semiema01","bradfco01","sborzjo01","grayjo02","roberda11","corbipa01","penniwa01","winnco01","latzja01","orneljo01","harridu01","foscuju01","carteev01"),
    TOR=c("scherma01","francbo01","lovelri01","littlbr02","hoffmje02","greench03","sandlni01","rodriya01","berrijo01","barneja01","bassich01","gausmke01","garciyi01","wagnewi01","rodenal01","schneda03","clemeer01","kirkal01","springe01","bichebo01","guerrvl02","heinety01","santaan02","strawmy01","lukesna01","gimenan01","varshda01","swanser01","burrry01","manoaal01","blossja01","tatedi01","lucasea01","walkejo03","clasejo01","martior01","bargead01","loperjo01","jimenle01","berrost01"),
    WSN=c("willitr01","ribalor01","parkemi01","ferrejo01","salazed01","gorema01","irvinja01","sorokmi01","lopezjo02","simslu01","finneky01","pocheco01","adamsri03","crewsdy01","abramcj01","belljo02","tenajo01","garcilu04","woodja03","callal02","youngja03","lowena01","rosaram01","ruizke01","dejonpa01","chapaan01","cavalca01","lawde01","brzykza01","thompma02","grayjo03","herzdj01","rutleja01","milladr01","nunezna01","bakerda02","lipsctr01","yepezju01")
)
stopifnot(length(bbref_40man) == 30)
stopifnot(!anyDuplicated(unlist(bbref_40man)))


# # # Read the HTML content of the website 
# webpage <- rvest::read_html("https://www.baseball-reference.com/teams/ARI/2024.shtml#all_the40man")
# webpage <- rvest::read_html("https://www.baseball-reference.com/teams/ARI/2024.shtml#the40man")
# # 
# webpagexml <- webpage %>% as.character() %>% xml2::read_html()
# webpagexml %>% selectr::querySelectorAll('#div_the40man tr td')
# # # Select the table using CSS selector 
# # table_nodes <- rvest::html_nodes(webpage, "table")
# # table_node <- table_nodes[[1]]
# # 
# # # Extract the table content 
# # table_content <- rvest::html_table(table_node)
# # 
# # # Print the table 
# # head(table_content)
# # 
# # 
# # table_node %>% rvest::html_nodes('td')
# # prows <- table_node %>% rvest::html_nodes('tr')
# # prows[[2]]