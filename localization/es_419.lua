return {
    descriptions = {
        --[[Back = {
            b_picubed_wonderfuldeck = {
                name = "Wonderful Deck",
                text = {
                    "Start with a",
                    "{C:attention,T:j_picubed_talkingflower}Talking Flower{}",
                },
            },
            b_picubed_myepicdeck = {
                name = "my epic deck by pi_cubed",
                text = {
                    "{C:tarot}pi_cubed's Jokers{}' {C:attention}Jokers{} are",
                    "{C:attention}3x{} more likely to appear",
                },
            },
            b_picubed_rejuvinationdeck = {
                name = "Rejuvenation Deck",
                text = {
                    "Start with {C:attention}#1#{} Joker slots,",
                    "{C:attention}+#2#{} slot after Boss Blind",
                    "is defeated",
                },
            },
            b_picubed_covetousdeck = {
                name = "Covetous Deck",
                text = {
                    "Start with a {C:attention,T:j_picubed_shoppingtrolley}#1#{},",
                    "{C:attention,T:j_picubed_preorderbonus}#2#{}, and {C:attention,T:v_seed_money}#3#{}",
                },
            },
            b_picubed_collectorsdeck = {
                name = "Collector's Deck",
                text = {
                    "Start with a {C:attention,T:j_picubed_shoppingtrolley}#1#{},",
                    "{C:attention,T:j_picubed_preorderbonus}#2#{}, and {C:attention,T:v_seed_money}#3#{}",
                },
            },
        },]]
        Joker = {
            j_picubed_itsaysjokerontheceiling = {
                name = 'Dice "Comodín" en el techo',
                text = {
                  "Redondea las {C:chips}fichas{} al próximo #1#,", 
                  "Redondea el {C:mult}multi{} al próximo #2#"
                }
            },
            j_picubed_d2 = {
                name = 'D2',
                text = {
                  "{C:green}#2# en #3#{} probabilidades", 
                  "de otorgar {C:mult}+#1#{} multi"
                }
            },
            j_picubed_wordsearch = {
                name = 'Sopa de letras',
                text = {
                  "Este comodín gana {C:mult}+#2#{} multi",
                  "por cada {C:attention}#1#{} que anota",
                  "{s:0.8}La categororía cambia en cada ronda",
                  "{C:inactive}(Actual {C:mult}+#3#{C:inactive} multi)"
                }
            },
            j_picubed_moltenjoker = {
                name = 'Comodín fundido',
                text = {
                  "Reactiva todas las cartas de {C:attention}oro{}, {C:attention}acero{},", 
                  "y {C:attention}piedra{}"
                }
            },
            j_picubed_chisel = {
                name = 'Cincel',
                text = {
                  "Si la {C:attention}primera{} carta jugada",
                  "es una carta de {C:attention}piedra{}, {C:attention}remueve{}", 
                  "su mejora y este comodín",
                  "obtiene {C:chips}+#1# {C:attention}fichas{} {C:attention}extra{}"
                }
            },
            j_picubed_upgradedjoker = {
                name = 'Comodín mejorado',
                text = {
                  "Cada {C:attention}carta mejorada{} jugada",
                  "otorga {C:chips}+#1#{} fichas y",
                  "{C:mult}+#2#{} multi cuando anota"
                }
            },
            j_picubed_jokinhood = {
                name = "Modín' Hood",
                text = {
                  "Las cartas {C:attention}numéricas{} otorgan {C:money}$#1#{}",
                  "cuando anotan, las cartas de {C:attention}figura{} otorgan",
                  "{C:money}$#2#{} cuando anotan"
                }
            },
            j_picubed_prime7 = {
                name = "7 prime",
                text = {
                  "Si la mano jugada es un solo {C:attention}7{},",
                  "se vuelve {C:dark_edition}Negativo{}"
                }
            },
            j_picubed_landslide = {
                name = 'Desprendimiento de tierras',
                text = {
                  "Una carta aleatoria que tienes en tu mano",
                  "se convierte en carta de {C:attention}piedra{}",
                  "si las {C:chips}fichas{} superan el {C:mult}multi",
                  "luego de anotar"
                }
            },
            j_picubed_runnerup = {
                name = 'Subcampeón',
                text = {
                  "{X:mult,C:white}X#1#{} multi en la {C:attention}segunda{}",
                  "mano de la ronda"
                }
            },
            j_picubed_oooshiny = {
                name = 'Ooo! Brillante!',
                text = {
                  "Las cartas {C:dark_edition}policroma{}",
                  "otorgan {C:money}$#1#{} cuando anotan"
                }
            },
            j_picubed_oooshiny = {
                name = 'Ooo! Brillante!',
                text = {
                  "Las cartas {C:dark_edition}policroma{}",
                  "otorgan {C:money}$#1#{} cuando anotan"
                }
            },
            j_picubed_oooshiny = {
                name = 'Ooo! Brillante!',
                text = {
                  "Las cartas {C:dark_edition}policroma{}",
                  "otorgan {C:money}$#1#{} cuando anotan"
                }
            },
            j_picubed_stonemason = {
                name = 'Albañil',
                text = {
                  "Las cartas de {C:attention}piedra{} ganan {X:mult,C:white}X#1#{} multi",
                  "cuando anotan, las cartas de piedra tienen",
                  "{C:green}#2# en #3#{} probabilidades de ser {C:attention}destruidas",
                  "luego de puntuar"
                }
            },
            j_picubed_snakeeyes = {
                name = 'Ojos de serpientes',
                text = {
                  "Cuando esta carta se {C:attention}vende{}, el comodín",
                  "de la {C:attention}izquierda{} tiene sus",
                  "{E:1,C:green}probabilidades {C:attention}garantizadas",
                  "{C:inactive}(ej: {C:green}1 en 6 {C:inactive}-> {C:green}1 en 1{C:inactive})"
                  
                }
            },
            j_picubed_789 = {
                name = '7 8 9',
                text = {
                  "Si la mano jugada tiene un {C:attention}7 {}y {C:attention}9{}",
                  "que anotan, {C:attention}destruye{} cada {C:attention}9{} jugado,",
                  "y este comodín gana {X:mult,C:white}X#1#{} multi por cada 9 jugado",
                  "{C:inactive}(Actual {X:mult,C:white}X#2#{} {C:inactive}multi)"
                }
            },
            j_picubed_hiddengem = {
                name = 'Gema escondida',
                text = {
                  "Las cartas {C:attention}descartas{} tienen {C:green}#1# en #2#{}",
                  "probabilidades de ser {C:attention}destruidas{} y",
                  "crear una carta {C:spectral}espectral{}",
                  "{C:inactive}(Debe haber espacio)"
                }
            },
            j_picubed_ambigram = { --needs updating!
                name = 'Ambigrama',
                --[[text = {
                  "Cada {C:attention}6{} no mejorado jugado",
                  "se convierte en {C:attention}9{},",
                   "Cada {C:attention}9{} no mejorado jugado",
                  "se convierte en {C:attention}6{},",
                }]]
            },
            j_picubed_superwrathfuljoker = {
                name = 'Comodín super vengativo',
                text = {
                  "Todas las cartas de {C:spades}espadas{}",
                  "se convierten en {C:attention}Reyes{} cuando anotan"
                }
            },
            j_picubed_acecomedian = {
                name = 'Comediante de as',
                text = {
                  "Reactiva cada",
                  "{C:attention}As{}, {C:attention}10{}, {C:attention}9{}, y {C:attention}8{} jugados"
                }
            },
             j_picubed_advancedskipping = {
                name = 'Salto avanzado',
                text = {
                  "Recibe {C:attention}#1#{} {C:attention}etiqueta{} adicional aleatoria",
                  "cuando se {C:attention}omite{} una ciega,",
                  "{C:attention}+#2# etiqueta{} por cada ciega omitida",
                  "{C:inactive}(Capped at current {}{C:attention}Ante{}{C:inactive}){}" --needs updating!
                }
            },
            j_picubed_echolocation = {
                name = 'Ecolocalización',
                text = {
                  "{C:attention}+#3#{} tamaño de mano,",
                  "{C:green}#1# en #2#{} cartas de juego",
                  "se sacan {C:attention}boca abajo"
                }
            },
            j_picubed_shoppingtrolley = {
                name = 'Carrito de supermercado',
                text = {
                  "{C:green}#1# en #2#{} probabilidades de",
                  "obtener {C:attention}+#3#{} de tamaño de mano",
                  "en {C:attention}paquetes potenciadores"
                }
            },
            j_picubed_extrapockets = {
                name = 'Bolsillos extras',
                text = {
                  "{C:attention}+#1#{} de tamaño de mano",
                  "por cada {C:attention}consumible{} que tienes",
                }
            },
            j_picubed_peartree = {
                name = 'Peral',
                text = {
                  "{C:mult}+#1#{} Multi si tienes",
                  "{C:attention}un par en tu mano{}"
                }
            },
            j_picubed_spectraljoker = {
                name = 'Comodín espectral',
                text = {
                  "Después de derrotar a la {C:attention}ciega jefe{}",
                  "crea una",
                  "{C:attention}Etiqueta etérea{} gratis"
                }
            },
            j_picubed_siphon = {
                name = 'Sifón',
                text = {
                  "Este comodín obtiene {C:chips}+#1#{} fichas",
                  "cuando se {C:attention}vende{} otro comodín",
                  --"or {C:attention}destroyed",
                  "{C:inactive}(Actual {C:chips}+#2#{C:inactive} fichas)"
                }
            },
            j_picubed_inkjetprinter = {
                name = 'Impresora de tinta',
                text = {
                  "Los {C:attention}consumibles{} tienen {C:green}#1# en #2#",
                  "probabilidades de ser {C:attention}reobtenidos{} al usarse,",
                  "Esta carta tiene {C:green}#1# en #3#{} probabilidades de",
                  "ser {C:attention}destruidas{} luego de activarse",
                  "{C:inactive}(Debe haber espacio){}"
                }
            },
            j_picubed_blackjoker = { --needs updating!
                name = 'Comodín negro',
                --[[text = {
                  "Si la {C:attention}suma de categoría{} de todas las",
                  "{C:attention}cartas anotadas{} esta ronda es {C:attention}#2# o menos{},",
                  "recibes la mitad de la suma como {C:money}${}",
                  "al final de la ronda",
                  "{C:inactive}(Actual{} {C:attention}#1#{C:inactive})"
                }]]
            },
            j_picubed_bisexualflag_spectrums = {
                name = 'Bandera bisexual',
                text = {
                  "Si la {C:attention}mano jugada{} tiene",
                  "una {C:attention}Escalera{} y {C:attention}los cuatro{}",
                  "{C:attention}palos predeterminados{}, o una {C:attention}Escalera espectro{},",
                  "crea #1# cartas de {C:purple}Tarot{} {C:dark_edition}Negativas {C:purple}Tarot{}"
                }
            },
            j_picubed_bisexualflag = {
                name = 'Bandera bisexual',
                text = {
                  "Si la {C:attention}mano jugada{} tiene",
                  "una {C:attention}Escalera{} y {C:attention}todos los cuatro{}",
                  "crea 3 cartas de {C:purple}Tarot{} {C:dark_edition}Negativas {C:purple}Tarot{}"
                }
            },
            j_picubed_tradein = {
                name = 'Intercambio',
                text = {
                  "Gana {C:money}$#1#{} cuando una",
                  "carta de juego es",
                  "{C:attention}destruida"
                }
            },
            j_picubed_apartmentcomplex = {
                name = 'Complejo de departamentos',
                text = {
                  "Este comodín gana {X:mult,C:white}X#1#{} multi",
                  "si la {C:attention}mano jugada{} es un",
                  "{C:attention}Full de color{}",
                  "{C:inactive}(Actual {X:mult,C:white}X#2#{} {C:inactive}multi)"
                }
            },
            j_picubed_incompletesurvey = {
                name = 'Encuesta incompleta',
                text = {
                  "Gana {C:money}$#1#{} al principio de la ronda,",
                  "la {C:attention}última carta{} robada en la mano",
                  "se saca {C:attention}boca abajo{}"
                }
            },
            j_picubed_allin = {
                name = 'A todo o nada',
                text = {
                  "Todas las cartas {C:attention}boca abajo{} y",
                  "comodines se reactivan",
                  "{C:attention}#1#{} veces adicionales",
                  "{C:inactive}(Excepto A todo o nada)"
                }
            },
            j_picubed_gottheworm = {
                name = 'Atrapé al gusano',
                text = {
                  "{C:attention}Omitirse{} una ciega",
                  "otorga {C:money}$#1#{}"
                }
            },
            j_picubed_extralimb = {
                name = 'Miembro adicional',
                text = {
                  "{C:attention}+#1#{} ranuras de consumibles,",
                  "{C:mult}+#2#{} multi por cada",
                  "consumible que tienes",
                  "{C:inactive}(Actual {C:mult}+#3# {C:inactive}multi)"
                }
            },
            j_picubed_perfectscore = {
                name = 'Puntaje perfecto',
                text = {
                  "{C:chips}+#1# {}Fichas si la",
                  "mano puntuada tiene un {C:attention}10{}"
                }
            },
            j_picubed_explosher = {
                name = 'Derramatic XP',
                text = {
                  "Luego de puntuar,",
                  "convierte {C:attention}#1# {} cartas aleatorias que se", 
                  "encuentren en tu mano a {C:attention}palos aleatorios"
                }
            },
            j_picubed_rhythmicjoker = {
                name = 'Comodín con ritmo',
                text = {
                  "{C:mult}+#1#{} multi si las",
                  "manos restantes son de un número {C:attention}par"
                }
            },
            j_picubed_goldenpancakes = {
                name = 'Panqueques dorados',
                text = {
                  "Gana {C:money}$#1#{} despúes de jugar",
                  "una mano, {C:green}#2# en #3#{} probabilidades",
                  "de que esta carta se {C:attention}destruya",
                  "al final de la ronda"
                }
            },
            j_picubed_preorderbonus = {
                name = 'Beneficios de preventa',
                text = {
                  "Los paquetes potenciadores",
                  "cuestan un {C:attention}#1#% menos{}"
                }
            },
              j_picubed_preorderbonus_hookless = {
                name = 'Beneficios de preventa',
                text = {
                  "Después de abrir un",
                  "paquete potenciador, reembolsa",
                  "{C:attention}#1#%{} del costo"
                }
            },
             j_picubed_waterbottle = {
                name = 'Botella de agua',
                text = {
                  "{C:chips}+#1#{} fichas por cada",
                  "consumible usado en esta {C:attention}apuesta inicial{}",
                  "{C:inactive}(Actual {C:chips}+#2# {C:inactive}fichas)"
                }
            },
            j_picubed_currencyexchange = {
                name = 'Cambio de divisas',
                text = {
                  "Las cartas que se encuentran en tu mano",
                  "otorgan {C:mult}+#1#{} multi"
                }
            },
            j_picubed_arrogantjoker = {
                name = 'Comodín arrogante',
                text = {
                  "{X:mult,C:white}X#1#{} Multi si este comodín",
                  "se encuentra a la {C:attention}izquierda de todo {}"
                }
            },
            j_picubed_fusionmagic = {
                name = 'Fusión mágica',
                text = {
                  "Después de {C:attention}vender #1#{} {C:inactive}[#2#]{} cartas de {C:tarot}tarot{},",
                  "crea una carta {C:spectral}espectral {}",
                  "{C:inactive}(Debe haber espacio)"
                }
            },
            j_picubed_supergreedyjoker = {
                name = 'Comodín super codicioso',
                text = {
                  "Crea un comodín aleatorio con {C:attention}Edición{}",
                  "cuando una carta de {C:diamonds}Diamante {}anota",
                  "{C:inactive}(Debe haber espacio?)"
                }
            },
            j_picubed_pi = {
                name = 'Pi',
                text = {
                  "Las cartas con {C:attention}edición{}",
                  "otorgan {X:mult,C:white}X#1#{} multi"
                }
            },
            --[[j_picubed_onbeat = {
                name = 'On-beat',
                text = {
                  "Retrigger the {C:attention}1st{}, {C:attention}3rd{},",
                  "and {C:attention}5th{} cards played",
                  "{s:0.8}After hand is played,",
                  "{s:0.8}becomes {s:0.8,C:attention}Off-beat{}"
                }
            },
            j_picubed_offbeat = {
                name = 'Off-beat',
                text = {
                  "Retrigger the {C:attention}2nd{}",
                  "and {C:attention}4th{} cards played",
                  "{s:0.8}After hand is played,",
                  "{s:0.8}becomes {s:0.8,C:attention}On-beat{}"
                }
            },
            j_picubed_polyrhythm = {
                name = 'Polyrhythm',
                text = {
                  "Receive {C:money}$#1#{} every {C:attention}#2#{} {C:inactive}[#4#]{}",
                  "hands played, create a {C:tarot}Tarot{}",
                  "card every {C:attention}#3#{} {C:inactive}[#5#]{} discards",
                  "{C:inactive}(Must have room){}"
                }
            },
            j_picubed_pot = {
                name = 'Pot',
                text = {
                  "{C:green}#1# in #2#{} chance for {X:mult,C:white}X#3#{} Mult,",
                  "gives a {C:attention}cue{} if this Joker",
                  "will activate for played hand",
                  "{C:inactive}Currently #4#{}"
                }
            },
            j_picubed_supergluttonousjoker = {
                name = 'Super Gluttonous Joker',
                text = {
                  "When a {C:clubs}Club{} card is",
                  "drawn to hand, draw an",
                  "{C:attention}additional{} card to hand"
                }
            },
            j_picubed_mountjoker = {
                name = 'Mount Joker',
                text = {
                  "If played hand has at",
                  "least 4 {C:attention}Stone{} cards,",
                  "poker hand is your",
                  "{C:attention}most played poker hand{}"
                }
            },
            j_picubed_oxplow = {
                name = 'Ox Plow',
                text = {
                  "Earn {C:money}$#1#{} if played",
                  "hand is {C:attention}not{} your {C:attention}most{}",
                  "{C:attention}played poker hand{}"
                }
            },
            j_picubed_offthehook = {
                name = 'Off the Hook',
                text = {
                  "After play, all",
                  "{C:attention}unenhanced{} cards held",
                  "in hand are discarded",
                  "{C:chips}+#1#{} Hand"
                }
            },
            j_picubed_eyepatch = {
                name = 'Eye Patch',
                text = {
                  "This Joker gains {X:mult,C:white}X#2#{} Mult",
                  "if {C:attention}poker hand{} has {C:attention}not{}",
                  "been played this {C:attention}Ante{}, resets",
                  "when {C:attention}Boss Blind{} is defeated",
                  "{C:inactive}(Currently {X:mult,C:white}X#1#{} {C:inactive}Mult){}",
                  "{s:0.8}#3#{}"
                }
            },
            j_picubed_timidjoker = {
                name = 'Timid Joker',
                text = {
                  "{C:mult}+#1#{} Mult if this Joker",
                  "is the {C:attention}right-most{} Joker"
                }
            },
            j_picubed_rushedjoker = {
                name = 'Rushed Joker',
                text = {
                  "{C:attention}First{} card played",
                  "gives {C:mult}+#1#{} Mult",
                  "when scored"
                }
            },
            j_picubed_tyredumpyard = {
                name = 'Tyre Dumpyard',
                text = {
                  "When {C:attention}Boss Blind{} is selected,",
                  "fill all Consumable slots",
                  "with {C:attention}The Wheel of Fortune{}",
                  "{C:inactive}(Must have room){}"
                }
            },
            j_picubed_acorntree = {
                name = 'Acorn Tree',
                text = {
                  "When {C:attention}Blind{} is selected, all",
                  "Jokers are {C:attention}flipped and{}",
                  "{C:attention}shuffled{}, and earn {C:money}$#1#{} for",
                  "every other Joker affected"
                }
            },
            j_picubed_forgery = {
                name = 'Forgery',
                text = {
                  "When {C:attention}Blind{} is selected,",
                  "{C:attention}destroy{} 1 random card in",
                  "{C:attention}deck{}, and add half its",
                  "{C:chips}Chips{} to this Joker as {C:mult}Mult",
                  "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
                }
            },
            j_picubed_yawningcat = {
                name = 'Yawning Cat',
                text = {
                  "If {C:attention}played hand{} contains",
                  "at least {C:attention}#1#{} scoring",
                  "cards, {C:attention}retrigger{} playing",
                  "cards {C:attention}#2# additional times{}"
                }
            },
            j_picubed_weemini = {
                name = 'Wee Mini',
                text = {
                  "If played hand or cards held",
                  "in hand contain a {C:attention}2{},",
                  "played hand contains a",
                  "{C:attention}Two Pair{} and apply {C:attention}Splash{}"
                }
            },
            j_picubed_lowballdraw = {
                name = 'Lowball Draw',
                text = {
                  "If scoring hand",
                  "contains a {C:attention}2{}",
                  "and a {C:attention}7{}, earn {C:money}$#1#{}"
                }
            },
            j_picubed_chickenjoker = {
                name = 'Chicken Joker!',
                text = {
                  "If scoring hand contains",
                  "a {C:attention}Stone{} card or a {C:attention}Steel{}",
                  "card, {C:attention}fill{} empty Joker",
                  "slots with {C:dark_edition}Editioned{} {C:attention}Popcorn{}"
                }
            },
            j_picubed_shrapnel = {
                name = 'Shrapnel',
                text = {
                  "When a {C:attention}Consumable card{} is",
                  "used, all playing cards in hand",
                  "receive a {C:attention}permanent{} {C:mult}+#1#{} Mult",
                }
            },
            j_picubed_victimcard = {
                name = 'Victim Card',
                text = {
                  "This Joker gains {X:mult,C:white}X#1#{} Mult if",
                  "played hand does {C:attention}not beat{} the",
                  "blind, this Joker is {C:attention}destroyed{}",
                  "after reaching {X:mult,C:white}X#2#{} Mult",
                  "{C:inactive}(Currently{} {X:mult,C:white}X#3#{} {C:inactive}Mult){}",
                }
            },
            j_picubed_translucentjoker = {
                name = 'Translucent Joker',
                text = {
                  "After {C:attention}#1#{} rounds,",
                  "sell this card to",
                  "create an {C:attention}Invisible Joker{}",
                  "{C:inactive}(Currently {}{C:attention}#2#{}{C:inactive}/#1# rounds){}",
                }
            },
            j_picubed_cyclone = {
                name = 'Cyclone',
                text = {
                  "Scored cards with a {C:attention}Seal{}",
                  "create the {C:planet}Planet{} card of",
                  "played {C:attention}poker hand{}",
                }
            },
            j_picubed_missingfinger = {
                name = 'Missing Finger',
                text = {
                  "{X:mult,C:white}X#1#{} Mult, {C:attention}#2#{} playing",
                  "card {C:attention}selection limit{}",
                  --"for {C:blue}playing{} and {C:red}discarding{}",
                }
            },
            j_picubed_roundabout = {
                name = 'Round-a-bout',
                text = {
                  "Allows {C:attention}Straights{} to",
                  "be made with both",
                  "{C:attention}high and low ranks{}",
                  "{C:inactive}(ex:{} {C:attention}3 2 A K Q{}{C:inactive}){}",
                }
            },
            j_picubed_hypemoments = {
                name = 'Hype Moments',
                text = {
                  "When {C:attention}Boss Blind{} is selected,",
                  "create an {C:attention}Aura{}",
                  "{C:inactive}(Must have room){}",
                }
            },
            j_picubed_panicfire = {
                name = 'Panic Fire',
                text = {
                  "After Blind is selected, if a card",
                  "is {C:attention}sold{} before play or discard,",
                  "{X:mult,C:white}X#1#{} Mult for {C:attention}this round{}",
                  "{C:inactive}(Currently #2#){}",
                }
            },
            j_picubed_nightvision = {
                name = 'Night Vision',
                text = {
                  "After Play, {C:attention}flip{} all cards in hand,",
                  "earn {C:money}$#1#{} per card flipped",
                  "{C:attention}face up{} by this Joker",
                }
            },
            j_picubed_talkingflower = {
                name = 'Talking Flower',
                text = {
                  "{C:dark_edition}+#1#{} Joker Slot,",
                  "{C:mult}+#2#{} Mult"
                }
            },
            j_picubed_superlustyjoker = {
                name = 'Super Lusty Joker',
                text = {
                  "{C:attention}Retrigger{} played {C:hearts}Heart{} cards,",
                  "{C:green}#2# in #3#{} chance to retrigger",
                  "them {C:attention}#1#{} additional time",
                }
            },
            j_picubed_laserprinter = {
                name = 'Laser Printer',
                text = {
                  "{C:attention}Consumables{} have a {C:green}#1# in #2#{} chance",
                  "to be {C:attention}recreated{} on use and a",
                  "{C:green}#1# in #4#{} chance to be made {C:dark_edition}Negative{},",
                  "this card has a {C:green}#1# in #3#{} ",
                  "chance to be {C:attention}disabled{} for",
                  "this Ante after activating",
                  "{C:inactive}(Must have room){}"
                },
                unlock = {
                  "Allow an",
                  "{C:attention}Inkjet Printer{}",
                  "to destroy itself",
                },
            },]]
        },
        Spectral = {
            c_picubed_commander = {
                name = 'Comandante',
                text = {
                  "{C:attention}Destruye{} #1# consumible aleatorio",
                  "si las ranuras no tienen",
                  "espacio, agrega {C:dark_edition}Negativo{}",
                  "al resto"
                }
            },
            --[[c_picubed_rupture = {
                name = 'Rupture',
                text = {
                  "{C:attention}Destroy{} left-most Joker,",
                  "create {C:attention}#1#{} random",
                  "{C:spectral}Spectral{} cards"
                }
            },
            c_picubed_extinction = {
                name = 'Extinction',
                text = {
                  "{C:attention}Destroy{} all cards of",
                  "a {C:attention}random rank{}",
                  "from your deck"
                }
            },]]
        },
        --[[Partner = {
            pnr_picubed_roof = {
                name = "Roof",
                text = {
                  "{C:green}#2# in #3#{} chance to",
                  "round {C:money}${} to the next {C:money}$#1#{},", 
                  "before end of round"
                },
            },
            pnr_picubed_refine = {
                name = "Refine",
                text = {
                  "{C:attention}Enhanced{} cards gain",
                  "{C:mult}+#1#{} when scored", 
                },
            },
            pnr_picubed_copy = {
                name = "Copy",
                text = {
                  "{C:attention}Consumables{} have a {C:green}#1# in #2#",
                  "chance to be {C:attention}recreated{} on use,",
                  "this card has a {C:green}#1# in #3#{} chance to",
                  "be {C:attention}disabled{} for this Ante",
                  "after activating",
                  "{C:inactive}(Must have room){}"
                }
            },
            pnr_picubed_polymelia = {
                name = "Polymelia",
                text = {
                  "{C:attention}+#1#{} Consumable Slots,",
                  "held Consumables give",
                  "{C:chips}+#2#{} Chips",
                }
            },
        },]]
        Mod = {
            picubedsjokers = {
                name = "pi_cubed's Jokers",
                text = {
                    "Una colección vanilla-friendly de comodines.",
                    "Siguemé en bluesky en @picubed.bsky.social!",
                    "Thanks franderman123 for Español (México) localization!"
                }
            },
        },
    },
    misc = {
        --[[quips = {
            tf_bye1 = {
              "Bye...",
            },
            tf_bye2 = {
              "Bye-bye!",
            },
            tf_bye3 = {
              "So long!",
            },
            tf_hi1 = {
              "Hey!",
            },
            tf_hi2 = {
              "Heya!",
            },
            tf_hi3 = {
              "Hey there!",
            },
            tf_hi4 = {
              "Heyyyyy!",
            },
            tf_hi5 = {
              "Hiiiii!",
            },
            tf_onward = {
              "Onward and upward!",
            },
            tf_shop_high1 = {
              "What'cha gonna pick?",
            },
            tf_shop_high2 = {
              "What'll it be?",
            },
            tf_shop_high3 = {
              "Why not take both?",
            },
            tf_shop_low1 = {
              "Tough choice!",
            },
            tf_shop_low2 = {
              "What'cha gonna go with?",
            },
            tf_shop_low3 = {
              "Don't spend it all",
              "in one place!",
            },
            tf_wee1 = {
              "Weee!",
            },
            tf_wee2 = {
              "Weeeee...",
            },
        },]]
        --[[v_dictionary = {
            k_picubeds_pot_active = "Active!",
            k_picubeds_pot_inactive = "Inactive",
        },]]
        dictionary = {
            k_picubeds_gullible = "¡Crédulo!",
            k_picubeds_chisel = "¡Cincelado!",
            k_picubeds_prime = "¡Prime!",
            k_picubeds_tumble = "¡Caido!",
            k_picubeds_snakeeyes = "¡Ojos de serpiente!",
            k_picubeds_print = "¡Impreso!",
            k_picubeds_error = "¡Error!",
            k_picubeds_pride = "¡Orgullo!",
            k_picubeds_slosh = "¡Pegado!",
            --[[k_picubeds_swap = "Swap!",
            k_picubeds_pot_ready = "Ready?",
            k_picubeds_pot_hit = "Hit!",
            k_picubeds_pot_miss = "Miss...",
            k_picubeds_club = "Club!",
            k_picubeds_spade = "Spade!",
            k_picubeds_diamond = "Diamond!",
            k_picubeds_offthehook = "Hooked!",
            k_picubeds_victimcard = "Revoked!",
            k_picubeds_panicfire_ready = "Ready!",
            k_picubeds_fixed = "Fixed!",
            k_picubeds_active = "Active!",
            k_picubeds_inactive = "Inactive",]]
            config_picubeds_newspectrals = "Nuevas cartas espectrales (Requiere reinicio)",
            config_picubeds_preorderhook = "Beneficios de preventa' hook (desactivar para mejor compatibilidad, Requiere reinicio)",
            config_picubeds_customsfx = "Efectos de sonidos personalizados (Requiere reinicio)"
        }
    }
}