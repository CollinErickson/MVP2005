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
stopifnot(Sys.Date() < "2026-11-11")
bbref_40man <- list(
  ARI=c("kellyme01","carrige01","morilju02","clarkta01","martiju01","ginkeke01","walstbl01","santade01","loaisjo01","pfaadbr01","rodried05","lawde01","cabrejo03","garcibr02","lawlajo01","tawati01","carroco02","barrojo01","perdoge01","waldsry01","morenga01","mccanja02","vargail01","arenano01","gurrilo01","nootbla01","keplema01","marteke01","troyto01","sorokmi01","burneco01","pukaj01","menacr01","saalfan01","thompry02","galleza01","nelsory01","burgoju01","jamesdr01","drakeko01","brattmi01","strowka01","locklty01","delcaad01","groovlu01","fernajo06"),
    ATL=c("perezma02","leedy01","salech01","holmegr01","kerrra01","medervi01","burkhbl01","mahlety01","iglesra01","dodddy01","elderbr01","suterbr01","smithaj01","fuentdi01","baldwdr01","hicklbr01","harrimi04","kimha01","murphse01","rileyau01","farmeky01","acunaro01","yastrmi01","olsonma02","thomala02","albieoz01","smithdo02","dubonma01","lopezre01","jimenjo02","wentzjo01","schwesp01","stridsp01","suarero01","vanasri01","munozro02","karinja01","waldrhu01","ubersty01","davitdu01","ritchjr01","murphow01","harriha01","keirsda01","jarviji01"),
    BAL=c("sandeca01","deleolu02","hoppeal01","youngbr01","bradiky01","walkejo03","suareal01","garciri01","rogertr01","bazsh01","canoye01","kittran01","wolfrgr01","bassich01","narvaca01","hollija01","basalsa01","mayoco01","encarch01","beavedy01","hendegu01","cowseco01","alonspe01","alexabl01","kjershe01","taverle01","pozoyo01","roberlu01","oneilty01","frankch02","bautife01","selbyco01","akinke01","eflinza01","helslry01","westbjo01","mountry01","zulueyo01","povicca01","gibsotr01","nunezan01","fosteca01","hiralya01","heuerco01","hindsre01","jacksje02"),
    BOS=c("oldswy01","paezje01","weissgr01","milleer01","gamboal01","benneja01","sandopa02","moranjo01","whitlga01","suarera01","bellobr01","tollepa01","grayso01","chapmar01","rafaece01","sogarni01","gaspemi01","abreuwi02","duranja01","rutscad01","anthoro01","jonesja08","wongco01","durbica01","monasan01","kineris01","whiteel04","storytr01","yoshima02","contrwi01","meadcu01","guerrta01","slateju01","kellyza01","crochga01","crawfku01","oviedjo01","houckta01","rivered01","casastr01","burgora01","samanty01","chengts01","gonzaro01","campbkr01","eatonna01","seiglan01"),
    CHC=c("boydma01","imanash01","rolisry01","zeferry01","palenda01","thorntr01","webbja01","peterda01","civalaa01","ferguty01","thielca01","reaco01","holmecl01","gausmke01","tayloty01","buschmi02","murrabj01","suzukse01","ariasga01","shawma01","crowape01","amayami01","happia01","hoernni01","ramirpe01","bregmal01","kellyca02","confomi01","swansda01","cabreed02","holloga01","hortoca01","martiri02","hodgepo01","millesh01","brownbe02","matonph01","steelju01","harvehu01","austity01","roberet01","kellyan02","murraja01","garrebr01","assadja01","wicksjo01","deanju01","alcanke01","trianja01"),
    CHW=c("hicksjo03","burkese01","taylogr02","richatr01","smithha10","davisty01","urquijo01","mcdouta01","hudsobr01","newcose01","schwety01","kayan01","castilu02","feddeer01","antonsa01","grichra01","meidrch01","montgbr01","montgco01","romodr01","doylebr02","acunajo01","murakmu01","phamth01","beninan01","vargami01","rogerja03","petertr01","bartjo01","teelky01","brazohu01","martida03","murphch01","berropr01","bushky01","leasujo01","vasilmi01","thorpdr01","murrata01","baldwbr01","sandlda01","schulno01","cannojo02","smithsh02","queroed01","perezju03","nishiri01"),
    CIN=c("johnspi01","abbotan01","garciju01","willibr02","meylu01","lowderh01","lodolni01","singebr01","burnsch01","santito01","burkebr01","paganem01","antonte01","mollsa01","rodrihe05","arroyed01","britoju02","delacel01","suareeu01","mclaima01","stewasa02","banfiwi01","friedtj01","trevijo01","stephty01","myersda01","bledajj01","johnsiv01","steersp01","toglimi01","hayeske01","greenhu01","ashcrgr01","dunnbl01","phillco01","francjo02","mccamza01","solesch01","maxweza01","aguiaju01","pettych02","marteno01"),
    CLE=c("yohocr01","grifffo01","sabroer01","gaddihu01","messipa01","herriti01","williga01","festama01","holdeco01","allenlo02","smithca06","bibeeta01","hernaca04","cantijo01","fryda01","halpipe01","schneda04","martian02","bazzatr01","genaoan01","delauch01","kwanst01","rocchbr01","bailepa01","adelljo01","lowena01","ramirjo01","hedgeau01","hoskirh01","ceccosl01","armstsh01","waltean01","espinda02","alemafr01","kayfucj01","ingleco01","watsoka01","manzaky01","perkibl01"),
    COL=c("gordota01","romanjo03","frassni01","suganto01","hergeji01","bernabr01","feltnry01","castabl01","adamsma02","hughega01","manfrma01","agnosza01","mejiaju01","hillja01","rittery01","goodmhu01","beckjo01","johnstr02","tovarez01","carrico01","amadoad01","veenza01","norbyco01","rumfitj01","moniami01","mccarja02","sullibr01","castrwi01","sullise01","freelky01","herrewe01","brownmc01","ohlpi01","dollach01","quintjo01","bryankr01","karroky01","adamsbl01","casteei01","criswje01","shooktj01","fulfobr01","thompst01","stevech02","freemty01"),
    DET=c("sommedr01","monteke01","jobeja01","diazyi01","valdefr01","holtoty01","meltotr01","briesbe01","kinlety01","finneky01","anderdr02","wagueja01","searsan01","janseke01","greenri03","valened01","keithco01","callabr01","dingldi01","malgebe01","leeha02","clarkma04","mcgonke01","peckjo01","mckinza01","torregl01","torkesp01","baezja01","carpeke01","vierlma01","flaheja01","hornba01","hurtebr01","vestwi01","smithbu03","olsonre01","verlaju01","perezwe01","sweentr01","meadopa01","hanifbr01","dejesen01","ryanri01","gipsosa01","maddety01","julksco01","jungja01"),
    HOU=c("imaita01","blancro01","wesneha01","tengka01","brownhu01","javiecr01","lambepe01","delosen01","sousabe01","abreubr01","haderjo01","blubaaj01","okertst01","peckoet01","smithca07","meyerja02","velazne01","diazya02","paredis01","altuvjo01","vazquch01","allenni02","walkech02","trammta01","penaje02","wadela01","varshda01","alvaryo01","burromi01","waltebr01","matthbr01","correca01","santaal01","ullolmi01","vanwelo01","kingbr02","alexaja01","dezenza01","loperjo01","priceco01","coleza01","delgara02","spenclu01"),
    KCR=c("kimbrcr01","thomaco02","cruzst01","hoffmno01","mcgeeea01","dobnara01","pearsna01","lynchda02","langeal01","cuasjo01","wachami01","lugose01","camerno01","gosean01","caglija01","colliis01","tolbety01","pasquvi01","lugoma01","loftini01","jenseca01","wittbo02","perezsa02","waterdr01","ravejo01","rojasjo01","mailelu01","isbelky01","garcima01","gonsoto01","waybe01","raganco01","avilalu02","marshal01","mearsni01","mcartja01","kolekst01","estevca01","seaboco01","indiajo01","massemi02","erceglu01","blackma01","spencmi01","bergery01","littllu01","duranca01"),
    LAA=c("murphlu01","fermijo02","farrimi01","urenawa01","natersa01","johnsry01","joycebe01","rodrigr01","weimabl01","detmere01","peralsa01","watsory01","kikucyu01","sauceta01","darnatr01","ballemo01","guzmade01","moorech03","fraziad01","netoza01","grissva01","mecklwa01","heinety01","parisky01","sirijo01","perazos02","troutmi01","lowejo01","campegu01","schanno01","klassge01","bachmsa01","kochaja01","stephro01","moncayo01","rendoan01","aldegsa01","martitr01","kerrybr01","danaca01","teodobr01","portelo01","alvarna01","riverse01"),
    LAD=c("halvose01","hurtky01","skubata01","dreyeja01","scottta01","lauerer01","phillev01","glasnty01","wroblju01","snellbl01","vesiaal01","henried01","stewabr01","yamamyo01","freemfr01","feduchu01","rushida01","callal02","freelal01","smithwi05","edmanto01","tuckeky01","rojasmi02","hernaen02","ohtansh01","muncyma01","hernate01","bettsmo01","pagesan01","sasakro01","kleinwi01","diazed04","cousija01","stonega01","treinbl01","caspabe01","millebo06","gratebr01","bubickr01","sheehem01","knackla01","gervapa01","thomaal01","alfonel02","wardry01","kimhy02"),
    MIA=c("alcansa01","gibsoca01","eknesjo01","perezeu02","fultoda01","gustory01","blalobr01","vodnivi01","zuberty01","fauchca01","junkja01","petermi01","phillty01","ralstja01","coningr01","navarbr01","marseja01","sernaja01","mackjo02","sanojja01","paulegr01","lopezot01","ruizes01","caissow01","ramirag01","hernahe01","stoweky01","jimenle01","edwarxa01","bendean01","fairbpe01","meyerma01","mazurad01","kempnwi01","snellro01","henriro01","nardian01","bidoibr01","brzykza01","whitejo04","montepa01","gonzawi02","delosde01","acostma02","drisclo01"),
    MIL=c("gassero01","drohash01","maydu01","halldl01","ashbyaa01","andergr01","romerjo01","uribeab01","harriky01","patrich01","megiltr01","misioja01","hendelo01","senzaan01","chourja01","sanchga02","ortizjo06","frelisa01","vaughan01","laralu01","prattco01","naylobo01","yelicch01","bauerja01","contrwi02","hamilda03","turanbr02","mitchga01","kuhnejo01","wilsobr02","priesqu01","zerpaan01","woodrbr01","fitzpbr01","zastrro01","gordoco01","koenija01","crowco01","sproabr01","stallga01","lockrbr01","queroje01","blackty01","baddoak01"),
    MIN=c("adamstr01","actonga01","bradlta01","gomezyo01","nanceto01","kremede01","fundeko01","prielco01","hoffmje02","oberba01","morrian01","minteaj01","matthze01","rogerta01","culpeka01","keasclu01","gonzaga03","leebr02","rossbe01","jeffery01","jenkiwa01","kreidry01","belljo02","caratvi01","jacksal02","larnatr01","clemeko01","lewisro02","martiau01","buxtoby01","ryanjo04","sandsco01","abelmi01","bandaan01","paredmi01","lopezpa01","festada01","orzeer01","anderja02","rojaske01","rayama01","graytr01","rodenal01","wallnma01"),
    NYM=c("rossdy01","nunezde01","sengako01","scottch01","lavenna01","warreau01","mcleano01","duartda01","yanje01","manaese01","pintajo01","devench02","thornza01","stockro01","bengeca01","ewingaj01","batybr01","alvarfr01","morabni01","youngja02","pachecr01","semiema01","lindofr01","torrelu01","sotoju01","bichebo01","morelch01","vientma01","perezci01","willide03","hagenju01","garrere01","megilty01","polanjo01","curryxz01","mcderch01","weiseja01","tongjo01","myersto01","wagamer01","mauriro01","rosssh01","sengeha01"),
    NYY=c("blackpa01","hillti01","gillu01","bednada01","yarbrry01","headrbr01","schlica01","rodriel03","friedma01","rodonca01","fulmemi01","schrejo01","colege01","warrewi01","wellsau01","ramoshe02","chishja01","garcilu04","cabaljo01","jonessp01","ricebe01","lombage02","grishtr01","sanchal04","rosaram01","bellico01","goldspa01","mcmahry01","cruzfe01","weathry01","castrke01","schmicl01","stantmi03","judgeaa01","chivian01","beckbr01","hannebr01","delosye01","escarjc01","dominja01","volpean01","schuema01","cabreos01"),
    ATH=c("turyu01","perkija01","sprinje01","bassobr01","ginnjt01","lopezja04","alvarel01","medinlu02","harriho03","roycrch01","suarejo01","blewesc01","morrika01","jumpga01","muncyma02","hernada04","stefami01","whiteto01","boltehe01","gelofza01","willial04","butlela01","waltodo01","heimjo01","mcneije01","clarkde02","servebr01","corteca01","soderty01","langesh01","kriskbr01","sternju01","leitema02","hoglugu01","severlu01","kurodjo01","rookebr01","wilsoja05","kurtzni01","romdr01","morallu01","rockjo01","juengha01","johnsse01","rashita01","estesjo01","barnema02","rodrijo10"),
    PHI=c("holmagr01","duranjh01","shugach01","sanchcr01","luzarje01","mayzati01","bowlajo01","mcfaral02","alvarjo03","kerkeor01","nolaaa01","paintan01","wheelza01","raleybr01","stottbr01","marchra01","marshbr02","crawfju01","harpebr03","bohmal01","schwaky01","turnetr01","sosaed01","stubbga01","realmjt01","arraelu01","delacbr01","hillde01","kiliaca01","kellebr01","banksta01","garciad02","rojasjo03","reyesfe01","hoffman01","cortene01","rangeal01","backhky01","lazarma01","thomaco03","rincoga01","misneka01","kempot01"),
    PIT=c("yateski01","jonesja09","montgma01","siskev01","eiserbr01","ashcrbr01","ramiryo01","mlodzca01","bachala01","dovalca01","skenepa01","chandbu01","sotogr01","weavelu01","gonzaja01","yorkeni01","cookbi01","gonzani01","horwisp01","valdees01","florera03","bethach01","davishe01","triolja01","reynobr01","manguja01","cruzon01","lowebr01","ohearry01","kellemi03","griffko01","rodrien01","murdono01","harrito03","kellyan01","dotelwi01","curtikh01","mattsis01","barcohu01","simonro01","garcijh01","brannja01","callity01"),
    SDP=c("morgada01","morejad01","matsuyu01","cannigr01","vasqura02","kingmi01","mizeca01","buehlwa01","hartky01","millema03","rodribr01","peralwa01","rayro02","britojh01","bowenja01","taylosa04","campulu01","haysau01","songsu01","harridu01","merrija01","tatisfe02","francty01","fermifr01","machama01","bogaexa01","croneja01","sheetga01","andujmi01","estraje01","adamja01","pivetni01","musgrjo01","giolilu01","hoeinbr01","rengilu01","laurera01","strathu01","searsjp01","jacobal01","huntbl01","wagnewi01","duranro02","workmga01","mccoyma01"),
    SFG=c("sanmare01","smithdy01","molinan01","walkery01","seymoca01","foleyja01","rouppla01","roxbybr01","tidwebl01","perdoce01","webblo01","marteyu02","harritr01","cavandr01","coxjo01","furmana01","whitcsh01","gilbedr01","eldribr01","mccragr01","kossch01","hilltu01","leeju01","basabos01","deverra01","kniznan01","brubajt01","bericvi01","adamewi01","mayerma01","rodrije02","winnke01","hentgsa01","whiseca01","wickro01","buttojo01","housead01","peguejo01","mcdontr01","birdsha01","rodrira02","gagema01","susacda01","chapmma01","baderha01","schmica01","becktr01","bivensp01","lonswse01","abnerph01"),
    SEA=c("vargaca01","anderka01","woobr01","millebr04","criswco01","ferrejo01","milneho01","kirbyge01","gilbelo01","munozan01","bazared01","ruckemi01","dominse01","speiega01","peredjh01","roddebr01","montela01","youngco01","wardta01","canzodo01","wisdopa01","naylojo01","rodriju01","roblevi01","crawfjp01","raleica01","arozara01","wilsowe01","hancoem01","davilni01","wilcoco01","evanslo01","brashma01","wilsowi03","raleylu01","emersco01","donovbr01","simpsjo02","taylotr01","macivwi01","blissry01","rivasle01"),
    STL=c("mcgremi01","fernary01","leahyky01","bruihju01","winquca01","obrieri01","mathequ01","liberma01","gracego01","soriage01","gastelu01","mautzbr01","stanery01","walkejo02","prietce01","uriasra01","saggeth01","baezjo02","bernale01","churcna01","scottvi01","torrebr01","fermijo01","pagespe02","gormano01","burleal01","herreiv01","wethejj01","winnma01","jordabl01","pereiev01","strzepe01","pallaan01","dobbihu01","rajcima01","svansma01","fittsri01","crookji01"),
    TBR=c("rodrima01","legumca01","seymoia01","wellsty01","cleavga01","mcclash01","rasmudr01","kellyke02","cookal01","peralfr01","matzst01","bakerbr01","martini01","booseca01","delucjo01","wallsta01","mesavi01","hicksli01","caminju01","palacri01","viladry01","piperke01","arandjo01","forteni01","mullice01","diazya01","simpsch01","mateojo01","willibe03","jaxgr01","sulseco01","pepiory01","ucetaed01","heasljo01","luxga01","fraleja01","grovemi01","boylejo01","biggehu01","scholje01","englema01","dunnol01","meltoja01","willica02"),
    TEX=c("peoplbe01","silsech01","ahlstro01","rockeku01","bradfco01","mackoad01","gorema01","montgjo01","latzja01","alexaty01","quantca01","junisja01","willitr01","degroja01","ohopplo01","diazel01","foscuju01","pederjo01","duranez01","langfwy01","freemco01","lopezni01","burgeja01","carteev01","nimmobr01","seageco01","cauleca01","janseda01","higasky01","jungjo01","graype02","eovalna01","winnco01","garciro04","cornijo01","baumlca01","leiteja01","beeksja02","helmami01","santowi01","teodoem01","collyga01","osunaal02"),
    TOR=c("scherma01","soriajo02","fishebr02","arrigsp01","littlbr02","varlalo01","ceasedy01","fluhama01","rogerty01","milessp01","sewalpa01","tiederi01","mantijo01","lorenmi01","batembr01","mcadoch01","keysse01","valenbr01","clemeer01","okamoka01","springe01","kirkal01","smithjo11","gimenan01","guerrvl02","lukesna01","strawmy01","sanchje02","uriaslu01","biebesh01","taillja01","yesavtr01","francbo01","garciyi01","blossja01","corbipa01","berrijo01","ponceco01","santaan02","clasejo01","bargead01","dallach01","leech02","kleinjo01","vaneycj01","pinanyo01","schneda03"),
    WSN=c("alvaran01","tolmaer01","lordbr02","perallu02","cavalca01","cosgrto01","beetecl01","simpsja01","dionwi01","kranima01","ribalor01","kentja01","irvinja01","waldrma01","crewsdy01","ruizke01","moralyo01","nunezna01","abramcj01","pinckan01","housebr01","ortizab01","vivasjo01","tenajo01","fordha01","lileda01","youngja03","chapaan01","woodja03","earlyco01","herzdj01","lovelri01","waldike01","parkemi01","grayjo03","poulipj01","milladr01","birdja01","schulpa01","henryco01","millswy01","cruzyo01","yeaned01","nicolky01","varlagu01","corneri01","palmqca01","kentza01")
)
stopifnot(length(bbref_40man) == 30)
stopifnot(!anyDuplicated(unlist(bbref_40man)))

# When redoing, use following:
'
    ARI=
    ATL=
    BAL=
    BOS=
    CHC=
    CHW=
    CIN=
    CLE=
    COL=
    DET=
    HOU=
    KCR=
    LAA=
    LAD=
    MIA=
    MIL=
    MIN=
    NYM=
    NYY=
    ATH=
    PHI=
    PIT=
    SDP=
    SFG=
    SEA=
    STL=
    TBR=
    TEX=
    TOR=
    WSN=
'

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