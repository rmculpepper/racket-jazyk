#lang jazyk

#:definitions
(require "language/cz.rkt")

;; ============================================================
#:section "Prelude"

#:translate noun-phrase
"maskulinum animatum"		"masculine animate"
"maskulinum inanimatum"		"masculine inanimate"
feminum				feminine
neutrum				neuter
"imperfektní sloveso"		"imperfective verb"
"perfektní sloveso"		"perfective verb"
sloveso				verb
nominativ			nominative
genitiv				genitive
dativ				dative
akuzativ			accusative
vokativ				vocative
lokál				locative
instrumentál			instrumental

#:translate adjective
kolokviální			colloquial
;;singulár			singular
;;plurál			plural

#:translate imperative-phrase
čtete		read
doplňte		"fill in"
najděte		find
napište		write
odpovídejte	answer
opakujte	repeat
oznaťe		"mark, note"
počítejte	count
poslouchejte	listen
používejte	use
procvičujte	practice
přeložte	translate
"ptejte se"	ask
řekněte		say
seřaďte		"put in order"
spojte		connect
tvořte		make
změňte		change


;; ============================================================
#:section "Lekce 1"

#:translate adjective
dobrý			good
energický		energetic
optimistický		optimistic
moderní			modern
kvalitní		quality
aktivní			active
inteligentní		intelligent
formální		formal
informální		informal
zajímavý		interesting
hezký			pretty
špatný			bad
první			first
druhý			second
dlouhý			long

#:translate adverb
tady			here
pak			then
hezky			nicely
taky			also
takže			so
určitě			certainly
dobře			well
špatně			badly

#:translate conjunction
a			and
nebo			or
ale			but

#:translate inanimate-noun
den			day
otázka			question
substantiva		nouns
adjektiva		adjectives
verba			verbs
supermarket		supermarket
kontakt			contact
mítink			meeting
koncert			concert
problém			problem
film			film
program			program
škola			school
univerzita		university
restaurace		restaurant
konference		conference
policie			police
kino			cinema
auto			"auto, car"
metro			"metro, subway"
víno			wine
rádio			radio
espresso		espresso
centrum			center
dialogy			dialogues
čislo			number
přiklad			example
pan			Mr.
paní			Ms.

#:translate animate-noun
student			student
profesor		professor
doktor			doctor
manažer			manager
prezident		president
politik			politician
kamarád			friend
učitel			teacher
vědec			scientist
lékař			doctor
sportovec		athlete
úředník			clerk
dělník			laborer
číšník			waiter
prodavač		"shop assistant"
policista		policeman
uklízeč			cleaner
hasič			firefighter
herec			actor
zpěvák			singer

učitelka		teacher
vědkyně			scientist
lékařka			doctor
sportovkyně		athlete
úřednice		clerk
dělnice			laborer
servírka		waitress
prodavačka		"shop assistant"
policistka		policewoman
uklízečka		cleaner
hasička			firefighter
herečka			actress
zpěvačka		singer
studentka		student
profesorka		professor
doktorka		doctor
manažerka		manager
prezidentka		president
politička		politician
kamarádka		friend

#:translate pronoun
kdo			who

#:translate regular-verb
znamenat			mean
studovat			study
telefonovat			telephone
plánovat			plan
organizovat			organize
komunikovat			communicate
kontrolovat			"check, inspect"
dělat				do
rozumět				understand
pracovat			work
mluvit				speak

#:translate irregular-verb
[#:irr být jsem jsi je jsme jste jsou byl]	be
[#:a mít m měl]			have
[#:i jíst j jedl]		eat
[#:i spát sp spal]		sleep ;; ??
[#:i stát stoj stál]		stand ;; ??
;; FIXME
;; ? /  řekne	  		say

#:translate preposition
v/ve				"in, at"
z				from
na				"in, at" ;; FIXME

#:translate prepositional-phrase
"v České republice"		"in the Czech Republic"
"ve škole"			"at school"
"z Ameriky"			"from America"
"z Austrálie"			"from Australia"
"na univerzitě"			"at the university"
"z Bulharska"			"from Bulgaria"
"z Německa"			"from Germany"
"z Polska"			"from Poland"

#:translate phrase
"Seznamujeme se."		"We introduce ourselves." ;; ??
"Dobrý den." 			"Good day."
"Těší mě." 			"Nice to meet you."
"Co znamená ...?" 		"What does ... mean?"
"Jak se řekne ...?"		"How do you say ...?"
"Jak se to píše?"		"How is that written?"
"Ještě jednou, prosím."		"Once more, please."
"Mám otazku."  			"I have a question."
"Mluvite anglicky?"		"Do you speak English?"
"Mluvite německy?"		"Do you speak German?"
"Mluvite rusky?"		"Do you speak Russian?"
"Jaká česká slova znáte?"	"What Czech words do you know?"
"Co je to?" 	  		"What is that?"
"Studuju češtinu."		"I study Czech (ie, the Czech language)."
"Odkud jste?"			"Where are you from?"
"To je zajímavé."		"That is interesting."
"Co děláte?"			"What do you do?"
"Mějte se hezky."		"Have a nice day." ;; "Have a good one?"
"Na shledanou."			"Goodbye."
"Co asi ... říkaji?"		"What do ... talk about?" ; ???
"Promiňte."			"Sorry."
"To nic."			"It's nothing. (No harm.)"
"Není zač."			"No problem. (You're welcome.) (De nada.)"
"Kdo je to?"			"Who is that?"
"To je jedno."			"It's all the same."
"To je náhoda."			"That's a coincidence."
"Můžeme si tykat?"		"Can we be informal?"
"Určitě."  			"Certainly."
"Jak se máte?"			"How are you?"
"Ujde to."			"Not bad. (response to 'How are you?')"
"Kolik je ...?"			"How much is ...?" ;; but not "How much does it cost?"
"Například: ..."		"For example: ..."

#:translate pronoun
já                      I
ty                      "you (singular informal)"
on                      he
ona                     she
to                      "it, that"
my                      we
vy                      "you (plural, singular formal)"
oni                     they

#|
----------------------------------------
Vocative

Marina	-> Marino!
Tom	-> Tome!

pan	-> pane
paní	-> paní

----------------------------------------
Symbols

@	zavinác
.	tečka
-	pomlčka
_	podtržítko
/	lomítko ; ??
|#


;; ============================================================
#:section "Lekce 2"

#:translate adjective
nějaký			some ; ???
národní			national
mezinárodní		international
ekologický		ecological
starý			old
velký			big
sympatický		likeable
historický		historic
český			Czech

#:translate adverb
kde			where
blízko			near
daleko			far
teď			now
tam			there
odtud			"from here"
asi			approximately
pěšky			"on foot"
už			already ; ???
nahlas			aloud
někde			somewhere
fajn			okay
docela			quite
někdy			sometimes
často			often
moc			very
jenom			only
doma			"at home"

;; directions with "jít, jet" etc
rovně			"straight ahead"
doleva			left
doprava			right
nahoru			up
dolu			down
zpátky			back
doprostřed		"in the middle"

;; directions with "být"
vlevo			left
vpravo			right
nahoře			up
dole			down
uprostřed		"in the middle"
vzadu			"at the back"

#:translate conjunction
protože			because
že			that

#:translate inanimate-noun
nádraží			"train station"		; n
náměstí			"town square"		; n
nemocnice		hospital
letiště			airport			; n
zastávka		station
stanice			station
divadlo			theater
obchod			"shop, store"
vlak			train
[#:f kancelář]		office			; f
počítač			computer
[#:f tramvaj]		tram			; f
[#:n muzeum]		muzeum 			; n
kavárna			cafe			; f
parkoviště		"parking lot"		; n
[#:n kuře]		chicken	 		; n
kolo			bicycle
ulice			street
obrázek			picture
dům			home
firma			firm
organizace		organization
všechno			everything
park			park
diskotéka		disco
hluk			noise
město			city
řeka			river
hrad			castle
most			bridge
knedlík			dumpling
pivo			beer
adresa			address
pravda			truth
jmeno			"given name"
přímení			surname			; ?
země			country
klub			club
práce			work

#:translate animate-noun
[#:m kolega]		colleague 		; m
[#:m turista]		tourist			; m
recepční		receptionist		; m/f, FIXME

#:translate regular-verb
hledat			seek
bydlet			"live (reside)"
vidět                   see
musit                           must

#:translate irregular-verb
[#:i vědět v věděl]	know ;; ??
[#:e moct můž mohl]	"can, be able"
[#:e jít jd šel]	"walk" ;; FIXME: šel/šla !
[#:e jet jed jel]	"go (by vehicle)"

#:translate noun-phrase
"Pražský hrad"		"Prague castle"
"jenom jeden problém"	"only one problem"
"číslo domu" 		"house number"

#:translate preposition
jako			as

#:translate prepositional-phrase
"na výlet"			"on a trip"
"v Praze"			"in Prague"
"ve firmě"			"at the firm"
"jako asistentka"		"as an assistent"
"v centru"			"in the center"
"v restauraci"			"at the restaurant"
"z Evropy"			"from Europe"
"z Afriky"			"from Africa"
"z Asie"			"from Asia"

#:translate verb-phrase
"jet autem"		"go by car"
"jet autobusem"		"go by bus"
"jet metrem"		"go by metro (subway)"
"jmenovat se"		"be called"

#:translate phrase
"od místa, kde jste teď"	"from the place, where you are now"
"Kde je tady nějaký ...?"	"Where around here is some ...?"
"Prosím vás, nevíte, ...?"	"Please, do you know ...?"
"Ja se mám dobře."   		"I am doing well."
"To není tak často."		"It isn't so often."
"Učím se česky."		"I am learning Czech."
"Jsem rád(a), že ..."		"I am glad that ..."
"Líbí se mi ..." 		"I like ..."
"Chutná mi ..."			"I like (to eat or drink) ..."

#|
----------------------------------------
Directions

Musíte jít { rovně, doprava, doleva, nahoru, dolu, zpátky }.
To je { ..., vpravo, vlevo, nahoře, ... }.

----------------------------------------
Nominative Singular

           this         one
Ma	   ten		jeden
Mi	   ten		jeden
F	   ta		jedna
N	   to		jedno

----------------------------------------
Numbers

1	jeden/jedna/jedno <NOM-SG>
2-4	{dva, tři, čtyři} <NOM-PL>
5+	<NUM> <GEN-PL>
|#

;; ============================================================
#:section "Lekce 3"

#:translate adjective
typický			typical
hovězí			beef
kuřecí			chicken
česnekový		garlic
bramborový		potato
vepřový			pork
čokoládový		chocolate
vanilkový		vanilla
dušený			stewed
grilovaný		grilled
pečený			"baked, roasted"
americký		American
smažený			fried
zeleninový		vegetable
okurkový		cucumber
černý			black
zelený			green
ovocný			fruity
pomerančový		orange
světlý			"light (in color)"
červený			red
bílý			white
zvědavý			curious
spokojený		satisfied
výborný			excellent
zdravý			healthy
;;nějaký			somewhat ; (?? not adverb! ??)
nemocný			sick
hodný			"good (kind?)"

#:translate adverb
dneska			today
jak			how
zvlášť			separately
dohromady		together
jednou			once
dvakrát			twice
třikrát			"three times"
možná			maybe
později			later
bohužel			unfortunately
nějak			somehow
vůbec			"at all"
trochu			"a little"

#:translate inanimate-noun
jídlo			food
pití			drink
polevka			soup
maso			meat
palačinka		pancake
losos			salmon
zmrzlina		"ice cream"
česnek			garlic
brambor			potato
hranolka		"French fry"
zelí			cabbage
omáčka			sauce
rýže			rice
ovoce			fruit
šlehačka		"whipped cream"
káva			coffee
čaj			tea
pomeranč		orange
džus			juice
voda			water
kapr			carp
salát			salad
sýr			cheese
oběd			lunch
kuchař			cook			; m
něco			anything
cena			price
dort	    		cake
cukr			sugar
mléko			milk
peníze			money
čas			time
nálada			mood
[#:n spropitné]		tip

#:translate animate-noun
vegeterián		vegeterian
vegeteriánka		vegeterian

#:translate conjunction
když			when

#:translate regular-verb
myslit			think
říkat			say

#:translate irregular-verb
[#:e čist čt četl]	read
[#:e pít pij pil]	drink
[#:irr chtít chci chseš chce chceme chcete chtějí chtěl]	want
[#:e pozvat pozv pozval] invite
;; FIXME:
;; chtěl/chtěla	  	"would like" -- conditional? (p29)
;; ?, pomoct		help

#:translate noun-phrase
"jídelní listek"	menu
"<NUM> korun"		"<NUM> (of) crowns"

#:translate verb-phrase
"mít čas"		"have time"
"mít depresi"		"be depressed"
"mít dietu"		"be on a diet"
"mít <adj> náladu"	"be in a <adj> mood"
"mít dovolenou"		"be on holiday"
"mít hlad"		"be hungry"
"mít lekci"		"have a lesson"
"mít moc práce"		"have a lot of work"
"mít nápad"		"have an idea"
"mít pravdu"		"be right"
"mít problémy"		"have problems"
"mít peníze"		"have money"
"mít rande"		"have a date"
"mít rýmu"		"have a cold"
"mít smůlu"		"be unlucky"
"mít strach"		"be scared"
"mít štěstí"		"be lucky"
"mít vztek"		"be angry"
"mít žízeň"		"be thirsty"

#:translate preposition
s/se			with

#:translate prepositional-phrase
"se šlehačkou"		"with whipped cream"
"s ovocem"		"with fruit"
"na obědě"		"at lunch"
"na kávu"		"to coffee"

#:translate phrase
"Jaké(*) ... znáte?"		"What ... do you know (of)?"
"Dám si ..." 			"I will have ... (only ordering food)."
"Kolik stojí ...?"		"How much does ... cost?"
"Co si dáte k pití?"		"What will you have to drink?"
"Co si dáte k jídlu?"		"What will you have to eat?"
"Dobrou chuť!"			"Bon appetit!"
"Dáte si ještě něco?"		"Will you have anything else?"
"Zaplatím."    			"I will pay."
"Pojďte dál."			"Come in."
"To je škoda."			"That's too bad."
"Odskočím si."			"I need the bathroom."
"To je mi líto."		"I'm sorry." ; ???
"Jsem v pohodě."		"I'm good."

#|
----------------------------------------
Number of times

1	jednou
2+	<NUM>krát

----------------------------------------
Accusative singular

	adj		-í adj		1st decl	2nd	3rd
Ma	dobrého		kvalitního	lososa
Mi	dobrý		kvalitní	sýr
F	dobrou		kvalitní	polévku		rýži
N	dobré		kvalitní	pivo			zelí, kuře

That is, only Ma and F change.
|#

;; ============================================================
#:section "Lekce 4"

#:translate adjective
jazykový			language
vdaná				"married (f)"
ženatý				"married (m)"
svobodný			single  ; m??
malý				small
německý				German
fantastický			fantastic
hubený				thin
tlustý				fat
chudý				poor
bohatý				rich
krásný				pretty
ošklivý				ugly
škaredý				ugly
veselý				happy
smutný				sad
mladý				young
zdravý				healthy
nový				new
vysoký				tall
drahý				expensive
levný				cheap
zlý				evil
pesimistický			pessimistic
elegantní			elegant
nervozní			nervous
pasivní				passive
jaký				"what ... like"

#:translate adverb
prostě				just

#:translate conjunction
i				"and even"

#:translate inanimate-noun
jazyk				language
byt				apartment
skupina				group
sleva				discount

#:translate animate-noun
rodina				family
tatínek				father
maminka				mother
syn				son
dcera				daughter
přitel				boyfriend
přitelkyně			girlfriend
bratr				brother
sestra				sister
manžel				husband
manželka			wife
švagr				brother-in-law
[#:f švagrová]			sister-in-law
babička				grandmother
vnuk				grandson
vnučka				granddaughter
bratranec			cousin
synovec				nephew
tchán				father-in-law
tchyně				mother-in-law
zeť				son-in-law
snacha				daughter-in-law
strýc				uncle ;; ???
[#:m strejda]			uncle ;; ???
teta				aunt
neteř  				niece
sestřenice			cousin
matka				mother
otec				father
pes				dog
kočka				cat

#:translate regular-verb
učit				teach

#:translate verb-phrase
"učit se"			learn

#:translate prepositional-phrase
"na fotografii"			"in the photo"
"jako automechanik"		"as an automechanic"
"z Německa"			"from Germany"
"v jazykové škole"		"at a language school"

#:translate phrase
"Je mi <NUM> let."		"I am <NUM> years old. (I have <NUM> years.)"
"Kolik vám je?"			"How old are you?"
"Učím češtinu."			"I teach Czech (the Czech language)."
;;"Je v domácnosti."		_
"Je prostě fantastický!"	"He's just great!"
"ještě nemít"			"to not have yet"
"datum narození"		"date of birth"
"Kolik to stojí?"		"How much is it? (How much does it cost?)"
"Jak to?"                       "How come?"

#|
----------------------------------------
Comparative adjectives

mladý	    -> mladší	-> nejmladší
starý	    -> starší	-> nejstarší

----------------------------------------
Possessive pronouns

	1s	2s	1p	2p	3s M	3s F	3p
M	můj	tvůj	náš	váš	jeho	její	jejich
F	moje	tvoje	náše	váše	jeho	její	jejich
N	moje	tvoje	náše	váše	jeho	její	jejich

----------------------------------------
Possessive adjectives

	   M			F			N		Plural
Petr ->	   Petrův tatinek	Petrova maminka		Petrovo auto	Petrovi rodiče
Eva  ->	   Evin tatinet		Evina maminka		Evino auto	Evini rodiče

----------------------------------------
Accusative singular (revised)

	adj		-í adj		1st decl	2nd			3rd
Ma	hezkého		moderního	bratra		přítele			kolegu
Mi	hezký		moderní		dům
F	hezkou		moderní		sestru		přítelkyně, neteř
N	hezké		moderní		auto

That is, only Ma and F change.

----------------------------------------
Counting thousands

1000		tisíc
2000-4000	{dva, tři, čtyři} tisíce
5000+		... tisíc
|#

;; ============================================================
#:section "Lekce 6"

#:translate adjective
ospalý			sleepy
unavený			tired
každý			"each, every"
hlavní			main
teplý			warm
pravidelný		regular ;; eg, wrt verbs
společný                "common, shared, united"

#:translate adverb
kdy			when
třeba			perhaps
zítra			tomorrow
dlouho			"long, for a long time"
přitom			"while doing so"
naopak	   		"on the contrary, conversely"
brzy			"soon, early"
strašně			terribly
hlavně			mainly
většinou		"mostly, generally"
zase			again
proto			therefore
potom			"then, after that"
;; rád, ráda, rádi		gladly ; more complicated ...
odkdy                   "since when"
dokdy                   "until when"

;; -- frequency
vždycky			always
pořád			always
často			often
většinou		mainly
obvykle			usually
někdy			sometimes
nikdy			never ; (w/ "ne")
malokdy			seldom
denně                   daily

#:translate conjunction
až			"not until" ;; FIXME?
když			when
proto			"and therefore"

#:translate inanimate-noun
učebnice		textbook
strana			page
půl			half
ráno			morning
dopoledne		"morning (before noon)"
poledne			midday
odpoledne		afternoon
večer			evening
noc			night
tenis			tennis
hudba			music
svatba			wedding
přednáška		lecture
seminář			seminar
fotbal			football
teplo			heat
večeře			dinner
měsíc			month
týden			week
rok                     year
navštěva                visit

#:translate regular-verb
začínat			"start, begin" ; ???
končit			end
nakupovat		shop
vařit			cook
uklízet			clean
vstávat			"get up"
večeřet			dine
tancovat		dance
snídat			"eat breakfast"
poslouchat		listen
obědvat			"eat lunch"
cvičit			exercise
vypadat                 look ;; like?
umět                    "know how to"

#:translate irregular-verb
[#:e plavat plav plaval]	swim
[#:e hrat hraj hral]		play
[#:e psát piš psal]		write
;; FIXME:
;; ?, žít			"live, reside"
;; zapomnět			forget ?
[#:e přijít přijd přišel]       come ;; FIXME: šel/šla
[#:e zvat zv zval]              invite

#:translate verb-phrase
"jde spát"			"go to sleep" ;; FIXME: inf
"poslouchat hudbu"		"listen to music"
"hrat tenis"			"play tennis"
"dívat se na televizi"		"watch television"
"cvičit aerobik"		"do aerobics"
"žít spolu"			"live together"
"omlouvat se"                   "apologize"

#:translate prepositional-phrase
"v jednu (hodinu)"			"at one o'clock"
"ve {dvě, tři, čtyři} (hodiny)"		"at {two,three,four} o'clock"
"v {pět, ...} (hodin)"			"at {five, ...} o'clock"
"na tenis"    				"to tennis"
"v supermarketu"			"at the supermarket"
"v kanceláři"				"at the office"
"s kamarády"				"with friends"
"v klubu"				"at the club"
"o víkendu"				"on the weekend"
"na straně <NUM>"			"on page <NUM>"
"na počítači"				"on the computer"
"po svatbě"                             "after the wedding"
"ve všední den"                         "on a weekday"
"o víkendu"                             "on the weekend"

#:translate phrase
"Kdy je to?"				"When is it?"
"Kolik je hodin?"			"What time (o'clock) is it?"
"Kdy se sejdeme?"			"When do we meet?"
"Tom neví, kolik je hodin."		"Tom doesn't know what time it is."
"4 až 9 je ráno."   			"4 to 9 is the morning."
"Hodí se ti to?"			"That works for you?"
"ve všední den"				"everyday, on an ordinary day"
"třikrat za tyden"			"three times per week"
otevřeno                                open
zavřeno                                 closed
"Zvu tě na party."                      "I invite you to the party."
"Třeba ...?"                            "How about ...?"
"To přece umí každý!"                   "Everyone can do it!"
"už od sedmi hodin"                     "already at 7 o'clock"

;; TODO: p48

#|
----------------------------------------
Time

"půl pět"	= "half towards 5" = 4.5

morning		= ráno		"in the morning"	= ráno
		= dopoledne	    			= dopoledne
midday		= poledne	"at midday"		= "v poledne"
afternoon	= odpoledne	"in the afternoon"	= odpoledne
evening		= večer		"in the evening"	= večer
night		= noc		"at night"		= v noci
|#



;; ============================================================

;; ============================================================
#:section "Notes circa 2018-10"

#:translate adjective
důležitý                        important
užitečný                        useful
podobný                         similar
stejný                          same
kompletní                       complete
studený                         cold
chladný                         frigid

#:translate adverb
méně                            less
včas                            "on time"
vlastně                         actually

#:translate conjunction
jestli                          "if, whether"

#:translate inanimate-noun
možnost                         possibility ;; pl w/ -í
hruška                          pear
jablko                          apple
jahoda                          strawberry
žánr                            genre
chyba                           mistake

#:translate regular-verb
řídit                           "drive, manage, control"
kompletovat                     complete
pršet                           rain
odpočivat                       "relax, repose"

#:translate phrase ;; adverb-phrase
"jedenkrat za týden"            "once per week"
"jednou za týden"               "once per week"

#:translate noun-phrase
"něco jiného"                   "something else"

#:translate verb-phrase
"řídit auto"                    "drive a car"
"procházet se"                  "wander, walk around"

#:translate phrase
"To je mi líto."                "I'm sorry. (sympathy, not apology)"
"Prší."                         "It is raining."
"ani ... ani ..."               "neither ... nor ..."
"Ja to zkusím."                 "I will try it."


;; ============================================================
#:section "Notes up to 2018-07"

#:translate adverb
skoro                           almost

#:translate inanimate-noun
vtip                            joke


;; ============================================================
#:section "Notes circa 2019-01"

#:translate adjective
klidný                          quiet
známý                           known
uznámý                          recognized

#:translate phrase ;; adjective-phrase/irregular-adjective ??
několik                         several

#:translate adverb
letadlem                        "by airplane"
víc                             more
všude                           everywhere

#:translate inanimate-noun
teplo                           heat
lekce                           lesson
sníh                            snow
barva                           color
místo                           place
cesta                           "way, route"
letadlo                         airplane
Vánoce                          Christmas
instrukce                       instructions

#:translate animate-noun
člověk                          "person, human"
lidí                            people ;; pl of lidé
populace                        population
krava                           cow

#:translate regular-verb
letět                           fly   ;; vs létat?
startovat                       start ;; ???

#:translate prepositional-phrase
"v zimě"                        "in winter"
"v menza"                       "in the canteen"
"za dva měsíce"                 "in two months"
"za pět měsíců"                 "in five months"
"na Vánoce"                     "at Christmas"

#:translate phrase
"ten den"                       "(on) that day"
"ten čas"                       "(at) that time"


;; ============================================================
#:section "Notes circa 2019-02"

#:translate adjective
špinavý                         dirty
menší                           smaller

#:translate inanimate-noun
počasi                          weather
hora                            mountain
sporák                          stove
pohled                          postcard
dané                            tax

#:translate animate-noun
čarodějnice                     witch

#:translate regular-verb
posilat                         send
fungovat                        "work, function"
uživat                          "use, enjoy"
použivat                        use   ;; ou is not dipthong

#:translate prepositional-phrase
"na horak"                      "in the mountains"
"v létě"                        "in the summer"
"ve kterem patře"               "on which floor"

#:translate phrase
"To by bylo <ADJ>."             "That would be <ADJ>."
;; "<NUM> let/roku zpět/zpátky"    "<NUM> years ago/back"
"tři roky zpět"                 "three years ago"
"pět let zpět"                  "five years ago"
"většinou roku"                 "most of the year" ;; ???


;; ============================================================
#:section "Notes up to 2019-03, misc"

#:translate adjective
žadný                           "not any, none"
zakázaný                        forbidden

#:translate adverb
méně                            less
nakonec                         eventually

#:translate inanimate-noun
místnost                        room
květiny                         flowers
kousek                          piece
vrah                            murderer
nábytek                         furniture
budova                          building

#:translate regular-verb
navidět                         see ;; ??

#:translate phrase ;; adverb-phrase
"ještě ne"                      "not yet"

#:translate phrase
"To je mi líto."                "I'm sorry. (sympathy, not apology)"


;; ============================================================
#:section "Notes up to 2019-03, minulý čas worksheet"

#:translate adjective
chytrý                          smart
celý                            "whole, entire"
horký                           hot

#:translate adverb
nakonec                         eventually
spolu                           together
venku                           outdoors

#:translate inanimate-noun
noviny                          news
rodiče                          parents
hry                             games

#:translate regular-verb
připravovat                     "prepare, cook"
ležet                           "lie, rest"
fotografovat                    "photograph, take photographs"

#:translate noun-phrase
"celá rodina"                   "the whole family"
"horké kakao"                   "hot cocoa"
"počítačové hry"                "computer games"

#:translate verb-phrase
"mít těžký týden"               "have a hard week"
"dívat se"                      "watch"

#:translate prepositional-phrase
"na internetu"                  "on the internet"
"na stole"                      "on the table"
"na gauči"                      "on the couch"
"v garaži"                      "in the garage" ;; ? in/into?
