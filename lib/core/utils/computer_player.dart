import 'dart:math';

class ComputerPlayer {
  ComputerPlayer._();

  static const List<String> wordBank = [
    // A
    'apple','ant','angel','arrow','animal','anchor','army','art','air','able',
    'age','acid','acre','ache','arch','area','arm','ash','ask','ace',
    // B
    'ball','bird','blue','book','bear','boat','bone','bowl','box','boy',
    'bread','bridge','bring','brown','brush','burn','bus','busy','butter','bell',
    // C
    'cake','call','camp','card','care','cart','cash','cast','cat','cave',
    'chair','chest','chip','city','class','clay','clip','club','coal','coat',
    'cold','cook','cool','copy','cord','core','corn','cost','couch','count',
    // D
    'dark','dart','dash','date','dawn','deal','dear','deck','deep','deer',
    'desk','dew','dial','dice','dirt','dish','disk','dock','door','dose',
    'dove','down','draw','dream','dress','drift','drink','drive','drop','drum',
    // E
    'each','earl','earn','ease','east','edge','else','emit','even','ever',
    'evil','exam','exit','eyes','eagle','earth','eight','elect','enter','equal',
    // F
    'face','fact','fail','fair','fall','fame','farm','fast','fate','feed',
    'feel','feet','fell','felt','file','fill','film','find','fire','firm',
    'fish','fist','flag','flat','flew','flip','flow','foam','fold','folk',
    'fond','font','food','fool','foot','ford','fork','form','fort','foul',
    'four','free','from','fuel','full','fund','fuse','fuzz','frog','frost','for',
    // G
    'gain','game','gate','gave','gear','gift','girl','give','glad','glow',
    'glue','goal','goat','gold','golf','good','grab','gray','grew','grid',
    'grin','grip','grow','gulf','gust','gym','ghost','giant','glass','globe',
    // H
    'hack','half','hall','halt','hand','hang','hard','harm','harp','hash',
    'hate','have','hawk','head','heal','heap','hear','heat','heel','held',
    'help','hemp','herb','here','hero','hide','high','hill','hint','hire',
    'hole','holy','home','hood','hook','hope','horn','host','hour','hunt',
    'hurt','hush','hype','horse','house','heart','heavy','honey','human',
    // I
    'idea','idle','inch','iron','isle','item','icon','itch','ibis','igloo',
    // J
    'jack','jade','jail','join','joke','jump','just','jury','jade','jewel',
    // K
    'keen','keep','kick','kind','king','kiss','knot','know','kite','knife',
    // L
    'lack','lake','lamp','land','lane','last','late','lawn','lead','leaf',
    'lean','leap','left','lend','lens','less','lick','life','lift','like',
    'lime','line','link','lion','list','live','load','loan','lock','loft',
    'lone','long','look','loop','lord','lore','lose','loss','lost','love',
    'luck','lung','lure','lush','lava','laser','laugh','layer','learn','light',
    // M
    'made','mail','main','make','mall','malt','mane','many','mark','mars',
    'mask','mass','mast','mate','math','maze','meal','mean','meat','meet',
    'melt','memo','menu','mesh','mild','milk','mill','mind','mine','mint',
    'miss','mist','mock','mode','mole','mood','moon','more','moss','most',
    'move','much','mule','muse','must','myth','magic','major','march','match',
    'metal','model','money','month','motor','mount','mouse','mouth','music',
    // N
    'nail','name','navy','near','neck','need','nest','news','next','nice',
    'nine','node','nose','note','noun','null','numb','nurse','night','noble',
    // O
    'oath','obey','odds','okay','once','only','open','oral','orb','oval',
    'oven','over','owed','owls','oak','ocean','offer','order','organ','other',
    // P
    'pace','pack','page','paid','pain','pair','pale','palm','park','part',
    'pass','past','path','pave','peak','peel','peer','pest','pick','pile',
    'pill','pine','pink','pipe','plan','play','plot','plow','plug','plus',
    'poem','poet','pole','poll','pond','pool','poor','port','pose','post',
    'pour','pray','prep','prey','prod','pull','pump','pure','push','put',
    'pace','paint','paper','peace','phone','place','plant','plate','point','power',
    // R
    'race','rack','raid','rail','rain','rake','ramp','rang','rank','rare',
    'rash','rate','read','real','reap','reel','rely','rent','rest','rice',
    'rich','ride','ring','rink','riot','rise','risk','road','roam','roar',
    'rock','role','roll','roof','room','root','rope','rose','ruin','rule',
    'rush','rust','robe','robin','rocky','rough','round','route','river','robot',
    // S
    'safe','sage','sail','sake','salt','same','sand','sane','sang','sank',
    'save','scan','scar','seal','seam','seat','seed','seek','seem','seen',
    'self','sell','send','sent','shed','ship','shoe','shop','shot','show',
    'shut','sick','side','sigh','sign','silk','sing','sink','site','size',
    'skin','skip','slam','slap','slim','slip','slow','slum','snap','snow',
    'soap','sock','soft','soil','sold','sole','some','song','soon','sort',
    'soul','soup','span','spin','spot','stab','star','stay','stem','step',
    'stew','stop','stub','such','suit','sung','sunk','sure','surf','swan',
    'swap','swim','salt','scale','scene','score','sense','serve','shade','shake',
    'share','sheep','shelf','shift','shirt','short','shout','sight','skill','skull',
    'slate','sleep','slice','slide','slope','smart','smell','smile','smoke','snake',
    'solid','solve','sound','south','space','spare','spark','speak','speed','spend',
    'spill','spine','spoke','spoon','sport','spray','squad','stack','staff','stage',
    'stain','stair','stake','stale','stall','stamp','stand','stare','start','state',
    'steam','steel','steep','steer','stern','stick','stiff','still','stock','stone',
    'store','storm','story','stove','strap','straw','strip','stuck','study','stuff',
    'stump','super','sweep','sweet','swift','swing','sword','stone','spoke','smoke',
    // T
    'tack','tale','talk','tall','tank','tape','task','team','tear','tell',
    'term','test','text','than','that','them','then','they','thin','this',
    'thus','tick','tide','tile','till','time','tiny','tire','toad','toll',
    'tomb','tone','took','tool','tore','torn','toss','tour','town','toys',
    'trap','tree','trim','trio','trip','trot','true','tube','tuck','tune',
    'turn','tusk','twin','tale','taste','teach','teeth','thank','thick','thing',
    'think','third','thorn','those','three','threw','throw','thumb','tiger','timer',
    'tired','title','today','token','torch','total','touch','tough','tower','trace',
    'track','trade','trail','train','trait','trash','tread','treat','trend','trial',
    'trick','tried','troop','truck','truly','trunk','trust','truth','twice','twist',
    // U
    'ugly','undo','unit','upon','urge','used','user','ultra','under','unite',
    'until','upper','upset','urban','usage','utter',
    // V
    'vacancy','vacation','vaccine','vacuum','vagabond','vague','valley','vanish',
    'vanishing','vanilla','vantage','vapor','vaporize','variable','variation','variety','various',
    'vastness','vault','vaulted','vegetable','vegetarian','vehicle','velocity','velvet',
    'vendor','venture','venue','verbal','verdict','verge','verify','version',
    'vertical','vessel','veteran','viable','vibrate','vibration','vice','vicinity',
    'vicious','victory','viewer','viewing','viewpoint','vigil','vigilant','vigorous',
    'virality','virtual','virtue','visual','vision','visionary','visitor','visualize',
    'visualise','vocal','vocation','vocational','vodka','volatile','volatility','voting',
    'vowel','voyage','vulnerable','vulnerability','vulture','vortex','volley','volleyball',
    'volcanic','volcano','volume','volumetric','voiceless','vocalize','voicemail','vouch',
    'voucher','vouching','vaulting','vent','ventilate','ventilation','vented','venting',
    'ventral','venous','venal','vegan','veganism','vegetation','vegetative','vector',
    'vending','viper',
    // W
    'waddle','wader','wading','waffle','wagon','waiver','wakeful','walkable',
    'walkway','wallpaper','waltz','waltzed','waltzing','wander','wanderer','wandering',
    'wanton','warden','warehouse','warfare','warlike','warmth','warning','warpable',
    'warrior','wary','washer','washing','wassail','waste','wastage','watchful',
    'watchdog','waterway','waterfall','waterproof','waterline','watershed','watt','watts',
    'wax','waxed','waxing','waxy','weaken','weakness','wealthy','weapon',
    'weaponry','wearable','weary','weasel','weather','weave','weaver','weaving',
    'web','webinar','webcam','website','wedge','weeded','weeder','weekly',
    'weird','weirdly','welder','welding','welfare','welling','western','westerns',
    'wetland','wetness','whack','whacked','whaling','wharf','wheeze','wheeled',
    'wheeler','whiff','whimper','whipcord','whiplash','whirlwind','whisper','whistle',
    'whitener','whitening','wholesome','whopper','whorl','whosoever','wield','wiener',
    'wiggle','wiggly','wildcard','willing',

    //x
    'x-ray','x-rays','xenon','xenia','xenial','xenolith','xenograft','xenophobia',
    'xenophobic','xenogenesis','xerox','xeroxed','xeroxing','xeric','xerosis','xylem',
    'xylophone','xylophonist','xylitol','xanthic','xanthan','xanthate','xanthine','xiphoid',
    'x-axis','x-coordinate','x-intercept','x-linked','x-rated','x-factor','x-height','x-raying',
    'x-rayed','xenon-like','xeniality','xanthoma','xanthomas','xanthophyll','xiphoidal','xylotomy',
    'xylophonic','xylotomist','xiphoiditis','xerothermic','xerophyte','xerophytic','xanthocarpous','xerographic',
    'xerographically','xenophile',
    // Y
    'yard','yarn','yawn','year','yell','yellow','youth','yield','your','yours','yourself',
    'yesterday','yet','yes','yoga','yogurt','yolk','young','younger','youngest','yearly',
    'yearbook','yearn','yeast','yelp','yummy','yap','yacht','yam','yoke','yonder','yucca',
    'yip','yodel','yelling','yellowing','yielding','youthful','yearning','yesteryear','yeses',
    'yips','yodeling','yachts','yams','yogis','yoginis','yukata','yummier','yummiest','yardage',
    'yardstick','yawner','yawners','yawned','yawing','yelled','yeller','yellers','yesterday’s',
    'youths','youthfully','youthfulness','yoke','yoked','yoking','yokel','yokels','yonder',
    'yippee','yapping','yapped','yapper','yappers','yellowed','yellowish','yellowishness',
    'yearend','yearends','yearlong','yearlongs','yearling','yearlings','yearbooked','yearbooks',
    'yachted','yachting','yachtsman','yachtsmen','yarned','yarning','yawnering','yawnerish',
    'yodeler','yodelers','yodelled','yodelling','yogic','yogini','yoginis','yogurted','yummily',
    'yuppie','yuppies','youthquake','youthquakes','youthhood','youthhoods','yester',
    'yesternight','yesteryears','yieldless','yieldable','yawningly','yellowtail','yellowtails',
    'yowl','yowled','yowling','yucks','yucky','yuckier','yuckiest','yuckyish','yuppified','yuppifying',
    'yippeeish','yonderly','yare','yarest','yardwork','yardworks','yardman','yardmen','yardbird','yardbirds','yachtman','yachtmen','yarnball','yarnballs','yawnful','yawnfully','yearnful','yearnfully','yogin','yogins','yogism','yodels','yammer','yammers','yammered','yammering','yaps','yappy','yappier','yappiest','yapster','yapsters','yowl','yowls','yowled','yowling','youthsome','youthness','yummylicious','yummyness','yippeeing','yippeeers'


    // Z
    'zany','zap','zapped','zapper','zapping','zeal','zealous','zebra',
    'zebras','zero','zeroes','zeros','zeroed','zeroing','zest','zesty',
    'zigzag','zigzags','zigzagged','zigzagging','zinc','zip','zips','zipped',
    'zipper','zippers','zipping','zone','zones','zoned','zoning','zoo',
    'zoos','zoom','zooms','zoomed','zooming','zodiac','zombie','zombies',
    'zonal','zoning','zen','zenith','zephyr','zillion','zillions','zinger',
    'zingers','zinnia','zinnias','zircon','zither','zithers','zloty','zlotys',
    'zookeeper','zookeepers','zoology','zoologist','zoologists','zoological','zooplankton','zucchini',
    'zucchinis','zygote','zygotes','zebrafish','zeitgeist','zeppelin','zeppelins','zestful',
    'zestfully','zestiness','zippy','zippier','zippiest','zincs','zincs','zincing',
    'zoned','zoner','zoners','zonal','zonally','zombie-like','zoomer','zoomers',
    'zoomable','zoomed-in','zoonotic','zoonosis','zymurgy','zymology','zymotic','zymogen',
    'zorilla','zorillas','zebu','zebus'
  ];

  static String generateWord(String startLetter, List<String> usedWords) {
    final letter = startLetter.toLowerCase().trim();
    if (letter.isEmpty) {
      final rand = Random();
      final available = wordBank
          .where((w) => !usedWords.any((u) => u.toLowerCase() == w))
          .toList();
      if (available.isEmpty) return '';
      return available[rand.nextInt(available.length)];
    }

    final filtered = wordBank
        .where((w) =>
    w.startsWith(letter) &&
        !usedWords.any((u) => u.toLowerCase() == w))
        .toList();

    if (filtered.isEmpty) return '';
    final rand = Random();
    return filtered[rand.nextInt(filtered.length)];
  }
}
