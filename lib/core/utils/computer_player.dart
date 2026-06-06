import 'dart:math';

class ComputerPlayer {
  ComputerPlayer._();

  static const List<String> _wordBank = [
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
    'four','free','from','fuel','full','fund','fuse','fuzz','frog','frost',
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
    'vain','vale','vane','vary','vast','veil','vein','vent','verb','vest',
    'view','vine','void','volt','vote','vow','valve','value','video','vigor',
    'viral','virus','visit','vital','vivid','voice','voter',
    // W
    'wade','wage','wake','walk','wall','wand','want','ward','warm','warn',
    'warp','wart','wash','wave','weak','weal','wean','wear','weed','week',
    'well','went','west','what','when','whip','whom','wide','wild','will',
    'wilt','wind','wine','wing','wink','wire','wise','wish','with','wolf',
    'wood','word','wore','work','worm','worn','wrap','wren','wrist','write',
    'wake','watch','water','weigh','whale','wheat','wheel','where','which','while',
    'white','whole','whose','wider','width','witch','woman','women','world','worry',
    'worth','would','wound','wrath','wrong',
    // Y
    'yard','yarn','yawn','year','yell','your','youth','yield',
    // Z
    'zeal','zero','zinc','zone','zoom','zebra',
  ];

  static String generateWord(String startLetter, List<String> usedWords) {
    final letter = startLetter.toLowerCase().trim();
    if (letter.isEmpty) {
      // যদি কোনো letter না থাকে random একটা দাও
      final rand = Random();
      final available = _wordBank
          .where((w) => !usedWords.any((u) => u.toLowerCase() == w))
          .toList();
      if (available.isEmpty) return '';
      return available[rand.nextInt(available.length)];
    }

    final filtered = _wordBank
        .where((w) =>
    w.startsWith(letter) &&
        !usedWords.any((u) => u.toLowerCase() == w))
        .toList();

    if (filtered.isEmpty) return '';
    final rand = Random();
    return filtered[rand.nextInt(filtered.length)];
  }
}