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

# Updated 8/24/25
# Update below once this list is updated
stopifnot(Sys.Date() < "2025-11-11")
bbref_40man <- list(
    ARI=c("beeksja02","morilju02","woodfja01","galleza01","nelsory01","backhky01","pfaadbr01","saalfan01","burgoju01","crismna01","curtijo02","rodried05","jarvibr01","alexabl01","morenga01","perdoge01","thomaal01","gurrilo01","mccarja02","delcaad01","locklty01","carroco02","smithpa04","marteke01","vargail01","mccanja02","desclan01","thompry02","henryto01","burneco01","martiju01","menacr01","montech01","ginkeke01","pukaj01","walstbl01","hoffman01","diazyi01","garcibr02","jamesdr01","varlagu01","nelsoky01","kellyca01","lawlajo01","barrojo01","tawati01","kaiseco01","englitr01"),
    ATL=c("johnspi01","waldrhu01","elderbr01","feddeer01","bummeaa01","quantca01","dodddy01","wentzjo01","iglesra01","coxau01","stridsp01","kinlety01","leedy01","acunaro01","ozunama01","murphse01","allenni02","harrimi04","baldwdr01","alvarna01","brujavi01","albieoz01","whiteel04","profaju01","olsonma02","fraleja01","rileyau01","willilu01","salech01","smithaj01","lopezre01","schwesp01","jimenjo02","holmegr01","hernada03","dunnida01","wilesna01","strathu01","suerowa01","fuentdi01","seaboco01","orneljo01","kelenja01"),
    BAL=c("akinke01","povicca01","canoye01","suganto01","ennsdi01","bowmama01","kremede01","wolfrgr01","hiralya01","rogertr01","strowka01","martico02","garciri01","cowseco01","johnsda07","vazqulu01","jacksje02","hendegu01","beavedy01","mayoco01","basalsa01","hollija01","machivi01","carlsdy01","mountry01","jacksal02","rutscad01","oneilty01","westbjo01","youngbr01","selbyco01","blewesc01","poteeco01","eflinza01","bautife01","bradiky01","rodrigr01","wellsty01","suareal01","mateojo01","sanchga02","walkejo03","rodriel02","espadjo01","mcderch01","kjershe01","nodary01","handlma01"),
    BOS=c("wilsoju10","bellobr01","crochga01","whitlga01","fittsri01","weissgr01","maydu01","hicksjo03","bernabr01","buehlwa01","chapmar01","matzst01","giolilu01","garcijh01","duranja01","rafaece01","eatonna01","storytr01","bregmal01","yoshima02","hamilda03","narvaca01","lowena01","gonzaro01","anthoro01","wongco01","refsnro01","mayerma01","abreuwi02","dobbihu01","slateju01","guerrlu01","hendrli01","crawfku01","winckjo01","sandopa02","houckta01","casastr01","criswco01","kellyza01","harriky01","murphch01","moranjo01","campbis01","sogarni01","grissva01","campbkr01"),
    CHC=c("brownbe02","palenda01","wicksjo01","hortoca01","imanash01","kellebr01","reaco01","taillja01","thielca01","rogerta01","boydma01","kittran01","pomerdr01","castrwi01","buschmi02","suzukse01","crowape01","happia01","caissow01","tuckeky01","hoernni01","shawma01","mcguire01","swansda01","kellyca02","turneju01","amayami01","brasiry01","sorokmi01","morgael01","steelju01","littllu01","roberet01","neelyja01","cosgrto01","hodgepo01","holloga01","assadja01","pearsna01","alcanke01","ballemo01"),
    CHW=c("gilbety01","leasujo01","vasilmi01","gomezyo01","smithsh02","gonzawi02","eiserbr01","martida03","civalaa01","taylogr02","alexaty01","wilsost02","perezma02","leeko01","meidrch01","teelky01","baldwbr01","montgco01","meadcu01","vargami01","queroed01","roberlu01","sosale01","taylomi02","beninan01","tauchmi01","whiteow01","pegueel01","altavda01","berropr01","castrmi01","thorpdr01","bushky01","hudsobr01","cannojo02","ellarfr01","iriarja01","booseca01","burkese01","roberwi02","ramosbr01","elkoti01"),
    CIN=c("santito01","greenhu01","ashcrgr01","abbotan01","singebr01","paganem01","litteza01","phillco01","maxweza01","suterbr01","martini01","barlosc01","mollsa01","delacel01","haysau01","marteno01","mclaima01","banfiwi01","friedtj01","espinsa01","steersp01","bensowi01","trevijo01","luxga01","andujmi01","hayeske01","stephty01","burnsch01","lodolni01","lowderh01","willibr02","gibauia01","aguiaju01","mileywa01","spierca01","callity01","pettych02","zulueyo01","lasorjo01","meylu01","richaly01","joeco01","encarch01","dunnbl01","hindsre01","viladry01"),
    CLE=c("bibeeta01","messipa01","gaddihu01","herriti01","sabroer01","ceccosl01","smithca06","allenlo02","festama01","williga01","enrigni01","junisja01","allarko01","ariasga01","fryda01","kwanst01","schneda04","ramirjo01","rocchbr01","santaca01","martian02","hedgeau01","kayfucj01","manzaky01","naylobo01","jonesno01","thomala02","livelbe01","waltean01","meansjo01","hentgsa01","brennwi02","nikhado01","cantijo01","kentza01","krookma01","noeljh01","nunezdo01","rodrijo10","wilsowi03"),
    COL=c("perallu01","dollach01","gordota01","molinan01","chivian01","vodnivi01","hillja01","mejiaju01","gilbrlu01","hergeji01","freelky01","anderni01","senzaan01","farmeky01","rittery01","beckjo01","fulfobr01","karroky01","doylebr02","arciaor01","bernawa01","tovarez01","freemty01","fernaya01","goodmhu01","moniami01","halvose01","marquge01","darnedu01","agnosza01","criswje01","bryankr01","estrath01","palmqca01","blalobr01","rolisry01","feltnry01","crimbl01","romodr01","amadoad01","veenza01","toglimi01","schunaa01"),
    DET=c("sommedr01","skubata01","hanifbr01","mortoch02","paddach01","holtoty01","meltotr01","mizeca01","vestwi01","flaheja01","finneky01","montera01","kahnlto01","carpeke01","torkesp01","greenri03","keithco01","dingldi01","sweentr01","perezwe01","rogerja03","baezja01","ibanean01","torregl01","jonesja08","mckinza01","vierlma01","meadopa01","cobbal01","jobeja01","sewalpa01","olsonre01","maddety01","guentse01","urquijo01","foleyja01","langeal01","hurtebr01","smithdy01","heuerco01","gipsosa01","briesbe01","hornba01","leech02","monteke01","jungja01","malloju02"),
    HOU=c("kimbrcr01","blubaaj01","kingbr02","brownhu01","arrigsp01","ortka01","alexaja01","javiecr01","valdefr01","delosen01","okertst01","mcculla02","abreubr01","diazya02","altuvjo01","smithca07","matthbr01","meltoja01","walkech02","uriasra01","mccorch01","caratvi01","correca01","sanchje02","penaje02","dubonma01","meyerja02","trammta01","sousabe01","haderjo01","wesneha01","garcilu05","blancro01","waltebr01","paredis01","dezenza01","alvaryo01","rodgebr02","leonpe01","vanwelo01","hernani01","gordoco01","coronke01","whitcsh01","salazce01","davidlo01"),
    KCR=c("camerno01","erceglu01","longsa01","clarkta01","lynchda02","schrejo01","zerpaan01","bowlajo01","wachami01","estevca01","lugose01","bergery01","lorenmi01","pasquvi01","loftini01","wittbo02","garcima01","ravejo01","tolbety01","grichra01","perezsa02","isbelky01","indiajo01","mailelu01","yastrmi01","fraziad01","caglija01","massemi02","falteba01","cruzst01","harvehu01","marshal01","raganco01","bubickr01","mcartja01","wrighky01","avilalu02","kolekst01","blancda02","waterdr01","melenmj01"),
    LAA=c("garcilu03","fermijo02","medervi01","detmere01","zeferry01","burkebr01","fulmeca01","chafian01","stephro01","kikucyu01","janseke01","hendrky01","anderty01","troutmi01","moorech03","schanno01","kavadni01","netoza01","darnatr01","ohopplo01","perazos02","teodobr01","wardta01","rengilu01","adelljo01","moncayo01","campegu01","tayloch03","solerjo01","joycebe01","strichu01","rendoan01","kochaja01","silsech01","aldegsa01","bachmsa01","johnsry01","danaca01","lugoma01","parisky01","stevech02"),
    LAD=c("yateski01","kershcl01","scottta01","dreyeja01","caspabe01","wroblju01","bandaan01","glasnty01","vesiaal01","treinbl01","henried01","sheehem01","yamamyo01","deanju01","pagesan01","rushida01","freelal01","kennebu01","callal02","smithwi05","freemfr01","rojasmi02","ohtansh01","bettsmo01","confomi01","hernate01","kimhy02","edmanto01","hernaen02","muncyma01","stewabr01","ryanri01","stonega01","phillev01","sasakro01","kopecmi01","grovemi01","gratebr01","gonsoto01","hurtky01","snellbl01","knackla01","kleinwi01","diazal03","gervapa01","millebo06","sauerma01","ruizes01"),
    MIA=c("alcansa01","gibsoca01","perezeu02","gustory01","simpsjo02","henriro01","bellova01","zuberty01","fauchca01","junkja01","bachala01","phillty01","cabreed02","edwarxa01","marseja01","sanojja01","hillde01","acostma02","hicksli01","johnstr02","wiemejo01","ramirag01","hernahe01","lopezot01","myersda01","wagamer01","stoweky01","norbyco01","paulegr01","bendean01","tinocje01","weathry01","garrebr01","meyerma01","nardian01","coningr01","petermi01","soriage01","cronide01","tarnofr01","mazurad01","mesavi01"),
    MIL=c("millesh01","ashbyaa01","andergr01","uribeab01","priesqu01","koenija01","mearsni01","megiltr01","peralfr01","rodrica02","misioja01","woodrbr01","quintjo01","frelisa01","vaughan01","colliis01","seiglan01","durbica01","yelicch01","janseda01","monasan01","contrwi02","perkibl01","lockrbr01","turanbr02","bauerja01","chourja01","hoskirh01","ortizjo06","hendelo01","zastrro01","halldl01","thomaco02","montgjo01","gassero01","mitchga01","yohocr01","mcgeeea01","patrich01","myersto01","dunnol01","berrost01","blackty01"),
    MIN=c("tonkimi01","fundeko01","sandsco01","ryanjo04","cabrege01","oberba01","hatchto01","abelmi01","ohlpi01","topaju01","matthze01","kriskbr01","ramirer02","leebr02","keasclu01","outmaja01","gaspemi01","fitzgry01","jeffery01","wallnma01","lewisro02","buxtoby01","larnatr01","clemeko01","julieed01","martiau01","vazquch01","woodssi01","misiean01","festada01","lopezpa01","rodenal01","bradlta01","davisno01","adamstr01","keirsda01","mccusca01","peredjh01","miranjo01"),
    NYM=c("raleybr01","sotogr01","rogerty01","manaese01","brazohu01","peterda01","garrere01","diazed04","helslry01","sengako01","holmecl01","mcleano01","stanery01","sotoju01","vientma01","sengeha01","mauriro01","batybr01","martest01","mullice01","mcneije01","alonspe01","tayloty01","lindofr01","nimmobr01","torrelu01","alvarfr01","montafr02","cannigr01","megilty01","smithdr01","minteaj01","scottch01","youngda02","kranima01","nunezde01","sirijo01","winkeje01","madrini01","garzaju01","devench02","hagenju01","warreau01","waddebr01","adcocty01","hergeke01","carrial01","pintajo01","youngja02","acunajo01"),
    NYY=c("hillti01","warrewi01","schlica01","bednada01","dovalca01","gillu01","delosye01","leitema02","willide03","blackpa01","friedma01","weavelu01","rodonca01","chishja01","judgeaa01","wellsau01","grishtr01","goldspa01","cabaljo01","volpean01","rosaram01","dominja01","stantmi03","mcmahry01","ricebe01","bellico01","slateau01","headrbr01","cruzfe01","loaisjo01","yarbrry01","cousija01","colege01","schmicl01","cabreos01","effrosc01","sandrja01","birdja01","winanal01","hamilia01","shewmbr01","vivasjo01","escarjc01"),
    ATH=c("nunezed03","morallu01","sternju01","estesjo01","lopezja04","kellymi03","bidoos01","ginnjt01","alvarel01","harriho03","sprinje01","ferguty01","newcose01","rookebr01","hernada04","thomaco03","macivwi01","soderty01","corteca01","harribr02","butlela01","kurtzni01","wilsoja05","uriaslu01","langesh01","bledajj01","clarkde02","muncyma02","bowdebe01","severlu01","perkija01","leclejo01","holmagr01","hoglugu01","medinlu02","wynnsau01","waldike01","maldoan01","spencmi01","otanemi01","bassobr01","gelofza01","schuema01"),
    PHI=c("rossjo01","sanchcr01","duranjh01","suarera01","banksta01","strahma01","alvarjo03","romanjo03","nolaaa01","luzarje01","walketa01","kerkeor01","roberda08","marchra01","harpebr03","bohmal01","marshbr02","stottbr01","baderha01","schwaky01","wilsowe01","sosaed01","turnetr01","keplema01","realmjt01","casteni01","wheelza01","rangeal01","johnsse01","lazarma01","hoffmno01","mercami01","mannima02","roberda11","hicklbr01","rojasjo03","stubbga01","kempot01"),
    PIT=c("ramiryo01","heanean01","oviedjo01","santade01","holdeco01","kellemi03","burromi01","chandbu01","mlodzca01","nicolky01","ashcrbr01","mattsis01","skenepa01","pegueli01","canaral01","phamth01","davishe01","gonzani01","simonro01","horwisp01","triolja01","suwinja01","reynobr01","mccutan01","bartjo01","kineris01","lawreju01","mayzati01","jonesja09","valdeen01","rodrien01","cruzon01","harrito03","darremi01","siskev01","sandeca01","moretda01","shugach01","chengts01","baeji01","yorkeni01","cookbi01"),
    SDP=c("estraje01","suarero01","ceasedy01","morgada01","searsjp01","cortene01","matsuyu01","millema03","darviyu01","pivetni01","peralwa01","adamja01","morejad01","tatisfe02","fermifr01","johnsbr03","sheetga01","laurera01","ohearry01","arraelu01","croneja01","bogaexa01","machama01","iglesjo01","diazel01","merrija01","kingmi01","britojh01","musgrjo01","reynose01","hoeinbr01","waldrma01","marinro01","cruzom01","vasqura02","jacobal01","hartky01","rodribr01","mccoyma01","campulu01","ornelti01"),
    SFG=c("verlaju01","buttojo01","walkery01","peguejo01","rodrira02","lucchjo01","becktr01","gagema01","webblo01","whiseca01","seymoca01","bivensp01","rayro02","kossch01","gilbedr01","matoslu02","leeju01","bailepa01","schmica01","florewi01","smithdo02","adamewi01","deverra01","chapmma01","kniznan01","ramoshe02","encarje01","rouppla01","milleer01","murphto04","mcdontr01","winnke01","tengka01","tidwebl01","blackma01","birdsha01","fitzgty01","mecklwa01","mccragr01","wiselbr01","luciama01"),
    SEA=c("vargaca01","brashma01","laosa01","gilbelo01","munozan01","kirbyge01","bazared01","ferguca01","speiega01","sauceta01","millebr04","castilu02","woobr01","rodriju01","suareeu01","raleylu01","canzodo01","arozara01","youngco01","raleica01","solando01","polanjo01","naylojo01","crawfjp01","garvemi01","roblevi01","evanslo01","santogr01","thorntr01","blissry01","kowarja01","taylotr01","jacqujo01","castabl01","hancoem01","diazjh01","legumca01","mastrmi01","thomarh01","rivasle01","taylosa04","willibe03"),
    STL=c("mikolmi01","obrieri01","venezan01","svansma01","alcaljo01","fernary01","leahyky01","granian01","mcgremi01","romerjo01","grayso01","liberma01","pallaan01","burleal01","walkejo02","pagespe02","winnma01","saggeth01","herreiv01","gormano01","fermijo01","nootbla01","pozoyo01","hampsga01","contrwi01","churcna01","donovbr01","scottvi01","arenano01","kingjo01","thompza02","roycrch01","munozro01","gracego01","sianimi01"),
    TBR=c("bakerbr01","seymoia01","pepiory01","montgma01","ucetaed01","englema01","bazsh01","fairbpe01","cleavga01","housead01","rasmudr01","jaxgr01","forteni01","simpsch01","willica02","caminju01","diazya01","pereiev01","feduchu01","seymobo01","manguja01","lowebr01","graytr01","morelch01","lowejo01","wallsta01","kimha01","arandjo01","delucjo01","mcclash01","biggehu01","faedoal01","rodrima01","palacri01","faircst01","gerbejo01","orzeer01","sulseco01","kellyke02","boylejo01","rockjo01","petertr01","misneka01"),
    TEX=c("curvelu01","matonph01","webbja01","latzja01","garciro04","degroja01","leiteja01","milneho01","corbipa01","eovalna01","couloda01","armstsh01","kellyme01","freemco01","osunaal02","langfwy01","helmami01","duranez01","jungjo01","smithjo11","garciad02","tellero01","higasky01","heimjo01","pederjo01","seageco01","haggesa01","burgeja01","carteev01","semiema01","martich02","grayjo02","winnco01","sborzjo01","bradfco01","mahlety01","rockeku01","boushca01","churcma01","foscuju01"),
    TOR=c("scherma01","fluhama01","gausmke01","bassich01","varlalo01","berrijo01","dominse01","rodriya01","lauerer01","hoffmje02","nanceto01","littlbr02","biebesh01","bichebo01","springe01","kirkal01","clemeer01","schneda03","bargead01","guerrvl02","lukesna01","strawmy01","francty01","varshda01","heinety01","gimenan01","garciyi01","sandlni01","manoaal01","francbo01","burrry01","santaan02","fishebr02","estrala01","bruihju01","pinaro01","schulpa01","lucasea01","blossja01","martior01","clasejo01","jimenle01","loperjo01"),
    WSN=c("ferrejo01","ogasash01","lordbr02","beetecl01","ribalor01","parkemi01","cavalca01","poulipj01","rutleja01","henryco01","gorema01","irvinja01","pilkiko01","dejonpa01","crewsdy01","milladr01","abramcj01","adamsri03","hassero02","housebr01","belljo02","woodja03","garcilu04","chapaan01","lileda01","youngja03","herzdj01","willitr01","grayjo03","lawde01","ruizke01","laraan01","brzykza01","salazed01","ederja01","loutory01","thompma02","nunezna01","tenajo01","bakerda02","lipsctr01")
)
stopifnot(length(bbref_40man) == 30)
stopifnot(!anyDuplicated(unlist(bbref_40man)))

if (anyDuplicated(unlist(bbref_40man))) {
  unlist(bbref_40man)[duplicated(unlist(bbref_40man))]
}

bbref_40man_df <- NULL
for (iii in 1:length(bbref_40man)) {
  bbref_40man_df <- bind_rows(
    bbref_40man_df,
    tibble::tibble(bbref_org_abbr=names(bbref_40man)[iii],
                   bbref_id=bbref_40man[[iii]],
                   on40manroster=TRUE)
  )
}

org_map <- readr::read_csv("./data/org_map.csv")
bbref_40man_df <- left_join(
  bbref_40man_df,
  org_map %>% select(
    org_id_from_bbref=org_id,
    bbref_org_abbr,
    team_name_from_bbref=`Team Name`),
  c('bbref_org_abbr')
)

stopifnot(nrow(bbref_40man_df) > 35*30)
stopifnot(nrow(bbref_40man_df) < 50*30)

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