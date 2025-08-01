return {
    descriptions = {
        Back = {
            b_picubed_wonderfuldeck = {
                name = "Wonderful Deck",
                text = {
                    "Start with a",
                    "{C:dark_edition,T:e_foil}Foil{} {C:attention,T:j_picubed_talkingflower}Talking Flower{}",
                },
            },
            b_picubed_myepicdeck = {
                name = "my epic deck by pi_cubed",
                text = {
                    "{C:tarot}pi_cubed's Jokers{}' {C:attention}Jokers{}",
                    "are {C:attention}3x{} more likely to appear,",
                    "Start with an extra {C:money}$#1#",
                },
            },
            b_picubed_rejuvinationdeck = {
                name = "Rejuvenation Deck",
                text = {
                    "Start with {C:attention}#1#{} Joker slots,",
                    "{C:attention}+#2#{} slot for every",
                    "other Boss Blind defeated",
                },
            },
            b_picubed_covetousdeck = {
                name = "Covetous Deck",
                text = {
                    "Start with a",
                    "{C:attention,T:j_picubed_shoppingtrolley}#1#{},",
                    "{C:attention,T:j_picubed_preorderbonus}#2#{},",
                    "and {C:attention,T:v_seed_money}#3#{}",
                },
            },
            b_picubed_collectorsdeck = {
                name = "Collector's Deck",
                text = {
                    "Start with a {C:attention,T:v_magic_trick}#1#{},",
                    "{C:attention,T:v_illusion}#2#{}, and {C:attention,T:v_overstock_norm}#3#{}",
                },
            },
        },
        Joker = {
            j_picubed_itsaysjokerontheceiling = {
                name = 'It Says "Joker" on the Ceiling',
                text = {
                  "Round {C:chips}Chips{} to the next #1#,", 
                  "Round {C:mult}Mult{} to the next #2#"
                }
            },
            j_picubed_d2 = {
                name = 'D2',
                text = {
                  "{C:green}#2# in #3#{} chance", 
                  "to give {C:mult}+#1#{} Mult"
                }
            },
            j_picubed_wordsearch = {
                name = 'Word Search',
                text = {
                  "This Joker gains {C:mult}+#2#{} Mult",
                  "per scoring {C:attention}#1#{} card",
                  "{s:0.8}Rank changes every round",
                  "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"
                }
            },
            j_picubed_moltenjoker = {
                name = 'Molten Joker',
                text = {
                  "Retrigger {C:attention}Gold{}, {C:attention}Steel{},", 
                  "and {C:attention}Stone{} cards"
                }
            },
            j_picubed_chisel = {
                name = 'Chisel',
                text = {
                  "If {C:attention}first{} played card",
                  "is a {C:attention}Stone{} card, {C:attention}remove{}", 
                  "the enhancement and add",
                  "{C:chips}+#1# {C:attention}bonus{} {C:attention}chips{} to the card"
                }
            },
            j_picubed_upgradedjoker = {
                name = 'Upgraded Joker',
                text = {
                  "Each played {C:attention}Enhanced card{}",
                  "gives {C:chips}+#1#{} Chips and",
                  "{C:mult}+#2#{} Mult when scored"
                }
            },
            j_picubed_jokinhood = {
                name = "Jokin' Hood",
                text = {
                  "{C:attention}Non-face cards{} give {C:money}$#1#{}",
                  "when scored, {C:attention}face cards{} give",
                  "{C:money}$#2#{} when scored"
                }
            },
            j_picubed_prime7 = {
                name = "Prime 7",
                text = {
                  "If hand is a single {C:attention}7{},",
                  "it becomes {C:dark_edition}Negative{}"
                }
            },
            j_picubed_landslide = {
                name = 'Landslide',
                text = {
                  "A random card held in hand",
                  "becomes a {C:attention}Stone Card{}",
                  "if {C:chips}Chips{} exceeds {C:mult}Mult",
                  "after scoring"
                }
            },
            j_picubed_runnerup = {
                name = 'Runner-up',
                text = {
                  "{X:mult,C:white}X#1#{} Mult on {C:attention}second{}",
                  "hand of round"
                }
            },
            j_picubed_oooshiny = {
                name = 'Ooo! Shiny!',
                text = {
                  "{C:dark_edition}Polychrome{} cards",
                  "give {C:money}$#1#{} when scored"
                }
            },
            j_picubed_stonemason = {
                name = 'Stonemason',
                text = {
                  "{C:attention}Stone{} cards gain {X:mult,C:white}X#1#{} Mult",
                  "when scored, Stone cards have a",
                  "{C:green}#2# in #3#{} chance to be {C:attention}destroyed",
                  "after scoring is finished"
                }
            },
            j_picubed_snakeeyes = {
                name = 'Snake Eyes',
                text = {
                  "When this card is {C:attention}sold{}, Joker",
                  "to the {C:attention}left{} has its listed ",
                  "{E:1,C:green}probabilities {C:attention}guaranteed",
                  "{C:inactive}(ex: {C:green}1 in 6 {C:inactive}-> {C:green}1 in 1{C:inactive})"
                  
                }
            },
            j_picubed_789 = {
                name = '7 8 9',
                text = {
                  "If played hand contains a {C:attention}scoring",
                  "{C:attention}7 {}and {C:attention}9{}, {C:attention}destroy{} all scored {C:attention}9s{},",
                  "and gain {X:mult,C:white}X#1#{} Mult per 9 scored",
                  "{C:inactive}(Currently {X:mult,C:white}X#2#{} {C:inactive}Mult)"
                }
            },
            j_picubed_hiddengem = {
                name = 'Hidden Gem',
                text = {
                  "{C:attention}Discarded{} cards have a {C:green}#1# in #2#{}",
                  "chance to be {C:attention}destroyed{} and",
                  "create a {C:spectral}Spectral{} card",
                  "{C:inactive}(Must have room)"
                }
            },
            j_picubed_ambigram = {
                name = 'Ambigram',
                text = {
                  "{C:attention}6s{} and {C:attention}9s{} can",
                  "{C:attention}swap ranks{} anytime"
                }
            },
            j_picubed_superwrathfuljoker = {
                name = 'Super Wrathful Joker',
                text = {
                  "All played {C:spades}Spade{} cards",
                  "become {C:attention}Kings{} when scored"
                }
            },
            j_picubed_acecomedian = {
                name = 'Ace Comedian',
                text = {
                  "Retrigger each played",
                  "{C:attention}Ace{}, {C:attention}10{}, {C:attention}9{}, and {C:attention}8{}"
                }
            },
            j_picubed_advancedskipping = {
                name = 'Advanced Skipping',
                text = {
                  "Receive {C:attention}#1#{} additional random {C:attention}tags",
                  "when blind is {C:attention}skipped{},",
                  "{C:attention}+#2# tag{} after each skip",
                  "{C:inactive}(Capped at current {}{C:attention}Ante{}{C:inactive}){}"
                }
            },
            j_picubed_echolocation = {
                name = 'Echolocation',
                text = {
                  "{C:attention}+#3#{} hand size,",
                  "{C:green}#1# in #2#{} playing cards",
                  "are drawn {C:attention}face down"
                }
            },
            j_picubed_shoppingtrolley = {
                name = 'Shopping Trolley',
                text = {
                  "{C:green}#1# in #2#{} chance for",
                  "{C:attention}+#3#{} hand size",
                  "in {C:attention}Booster Packs"
                }
            },
            j_picubed_extrapockets = {
                name = 'Extra Pockets',
                text = {
                  "{C:attention}+#1#{} hand size for",
                  "each held {C:attention}Consumable",
                }
            },
            j_picubed_peartree = {
                name = 'Pear Tree',
                text = {
                  "{C:mult}+#1#{} Mult if cards",
                  "{C:attention}held in hand{}",
                  "contain a {C:attention}Pair"
                }
            },
            j_picubed_spectraljoker = {
                name = 'Spectral Joker',
                text = {
                  "After {C:attention}Boss Blind{} is",
                  "defeated, create a",
                  "free {C:attention}Ethereal Tag{}"
                }
            },
            j_picubed_siphon = {
                name = 'Siphon',
                text = {
                  "This Joker gains {C:chips}+#1#{} Chips",
                  "when another Joker is {C:attention}sold",
                  --[["or {C:attention}destroyed",]]
                  "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
                }
            },
            j_picubed_inkjetprinter = {
                name = 'Inkjet Printer',
                text = {
                  "{C:attention}Consumables{} have a {C:green}#1# in #2#",
                  "chance to be {C:attention}recreated{} on use,",
                  "this card has a {C:green}#3# in #4#{} chance to",
                  "be {C:attention}destroyed{} after activating",
                  "{C:inactive}(Must have room){}"
                }
            },
            j_picubed_blackjoker = {
                name = 'Black Joker',
                text = {
                  "If the {C:attention}sum rank{} of",
                  "{C:attention}first{} played or discarded",
                  "cards is {C:attention}#2#{}, earn {C:money}$#3#{}",
                }
            },
            j_picubed_bisexualflag = {
                name = 'Bisexual Flag',
                text = {
                  "If {C:attention}played hand{} contains a",
                  "{C:attention}Straight{} and {C:attention}four suits{},",
                  "create #1# {C:dark_edition}Negative {C:purple}Tarot{} cards",
                }
            },
            j_picubed_tradein = {
                name = 'Trade-in',
                text = {
                  "Earn {C:money}$#1#{} when a",
                  "playing card is",
                  "{C:attention}destroyed"
                }
            },
            j_picubed_apartmentcomplex = {
                name = 'Apartment Complex',
                text = {
                  "This Joker gains {X:mult,C:white}X#1#{} Mult if",
                  "{C:attention}played hand{} is a {C:attention}Flush House{}",
                  "{C:inactive}(Currently {X:mult,C:white}X#2#{} {C:inactive}Mult)"
                }
            },
            j_picubed_incompletesurvey = {
                name = 'Incomplete Survey',
                text = {
                  "Earn {C:money}$#1#{} at start of round,",
                  "{C:attention}final card{} drawn to hand is",
                  "drawn {C:attention}face down{}"
                }
            },
            j_picubed_allin = {
                name = 'All In',
                text = {
                  "All {C:attention}face down{} cards and",
                  "Jokers are retriggered",
                  "{C:attention}#1#{} additional time(s)",
                  "{C:inactive}(except All In)"
                }
            },
            j_picubed_gottheworm = {
                name = 'Got the Worm',
                text = {
                  "{C:attention}Skipping{} a blind",
                  "also gives {C:money}$#1#{}"
                }
            },
            j_picubed_extralimb = {
                name = 'Extra Limb',
                text = {
                  "{C:attention}+#1#{} Consumable Slots,",
                  "{C:mult}+#2#{} Mult per held",
                  "Consumable",
                  "{C:inactive}(Currently {C:mult}+#3# {C:inactive}Mult)"
                }
            },
            j_picubed_perfectscore = {
                name = 'Perfect Score',
                text = {
                  "{C:chips}+#1# {}Chips if scoring",
                  "hand contains a {C:attention}10{}"
                }
            },
            j_picubed_explosher = {
                name = 'Explosher',
                text = {
                  "After scoring is complete,",
                  "give {C:attention}#1# {}random cards", 
                  "held in hand a {C:attention}random suit"
                }
            },
            j_picubed_rhythmicjoker = {
                name = 'Rhythmic Joker',
                text = {
                  "{C:mult}+#1#{} Mult if Hands",
                  "remaining is {C:attention}even"
                }
            },
            j_picubed_goldenpancakes = {
                name = 'Golden Pancakes',
                text = {
                  "Scoring cards earn {C:money}$#1#{}",
                  "{C:green}#2# in #3#{} chance this",
                  "card is {C:attention}destroyed",
                  "at end of round"
                }
            },
            j_picubed_preorderbonus = {
                name = 'Preorder Bonus',
                text = {
                  "Booster Packs",
                  "cost {C:attention}#1#% less{}"
                }
            },
            j_picubed_waterbottle = {
                name = 'Water Bottle',
                text = {
                  "{C:chips}+#1#{} Chips for each",
                  "Consumable used this {C:attention}Ante{}",
                  "{C:inactive}(Currently {C:chips}+#2# {C:inactive}Chips)"
                }
            },
            j_picubed_currencyexchange = {
                name = 'Currency Exchange',
                text = {
                  "Cards held in hand",
                  "give {C:mult}+#1#{} Mult"
                }
            },
            j_picubed_arrogantjoker = {
                name = 'Arrogant Joker',
                text = {
                  "{X:mult,C:white}X#1#{} Mult if this Joker",
                  "is the {C:attention}left-most {}Joker"
                }
            },
            j_picubed_fusionmagic = {
                name = 'Fusion Magic',
                text = {
                  "After {C:attention}selling #1#{} {C:inactive}[#2#]{} {C:tarot}Tarot{} cards,",
                  "create a {C:spectral}Spectral {}card",
                  "{C:inactive}(Must have room)"
                }
            },
            j_picubed_supergreedyjoker = {
                name = 'Super Greedy Joker',
                text = {
                  "Create a random {C:attention}Editioned {}Joker",
                  "when a {C:diamonds}Diamond {}card scores",
                  "{C:inactive}(Must have room?)"
                }
            },
            j_picubed_pi = {
                name = 'Pi',
                text = {
                  "Cards with an {C:attention}edition{}",
                  "have a {C:green}#2# in #3#{} chance to",
                  "give {X:mult,C:white}X#1#{} Mult"
                }
            },
            j_picubed_onbeat = {
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
                  "{C:attention}highest level poker hand{}"
                }
            },
            j_picubed_oxplow = {
                name = 'Ox Plow',
                text = {
                  "Earn {C:money}$#1#{} if {C:attention}most played{}",
                  "{C:attention}poker hand{} wasn't played",
                  "by end of round",
                  "{C:inactive}(Currently #2#){}",
                }
            },
            j_picubed_offthehook = {
                name = 'Off the Hook',
                text = {
                  "After play, all {C:attention}unenhanced{}",
                  "cards held in hand are",
                  "{C:attention}discarded{}, {C:chips}+#1#{} Hands",
                  "when Blind is selected"
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
                  "each other Joker affected"
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
                  "Earn {C:money}$#1#{} when a",
                  "{C:attention}2{} or {C:attention}7{} is drawn",
                  "to hand during Blind",
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
                  "Allows {C:attention}Straights{} to be",
                  "made with {C:attention}Wrap-around Straights{},",
                  "this Joker gains {C:mult}+#1#{} Mult per",
                  "played {C:attention}Wrap-around Straight{}",
                  "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
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
                  "{C:green}#5# in #6#{} chance to be made {C:dark_edition}Negative{},",
                  "this card has a {C:green}#3# in #4#{} ",
                  "chance to be {C:attention}disabled{} for",
                  "this Ante after activating",
                  "{C:inactive}(Must have room){}"
                },
                unlock = {
                  "Allow an",
                  "{C:attention}Inkjet Printer{}",
                  "to destroy itself",
                },
            },
        },
        Spectral = {
            c_picubed_commander = {
                name = 'Commander',
                text = {
                  "{C:attention}Destroy{} #1# random",
                  "Consumable if slots are",
                  "filled, add {C:dark_edition}Negative{}",
                  "to all others"
                }
            },
            c_picubed_rupture = {
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
            },
        },
        Partner = {
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
                  "{C:mult}+#1#{} Mult when scored", 
                },
            },
            pnr_picubed_copy = {
                name = "Copy",
                text = {
                  "{C:attention}Consumables{} have a {C:green}#1# in #2#",
                  "chance to be {C:attention}recreated{} on use,",
                  "this card has a {C:green}#3# in #4#{} chance to",
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
        },
        Mod = {
            picubedsjokers = {
                name = "pi_cubed's Jokers",
                text = {
                    "A collection of vanilla-friendly Jokers (and more) made by",
                    "yours truly. Follow me on bluesky at @picubed.bsky.social!",
                    "Thanks franderman123 for Español (México) localization!"
                }
            },
        },
        Other = {
            wraparound = {
                name = "Wrap-around Straight",
                text = {
                    "A non-standard Straight",
                    "containing both",
                    "{C:attention}high and low{} ranks",
                    "{C:inactive}(ex:{} {C:attention}3 2 A K Q{}{C:inactive}){}",
                }
            },
            onbeat_tooltip = {
                name = "On-beat",
                text = {
                    "Retrigger the {C:attention}1st{}, {C:attention}3rd{},",
                    "and {C:attention}5th{} cards played",
                    "{s:0.8}After hand is played,",
                    "{s:0.8}becomes {s:0.8,C:attention}Off-beat{}"
                }
            },
            offbeat_tooltip = {
                name = 'Off-beat',
                text = {
                    "Retrigger the {C:attention}2nd{}",
                    "and {C:attention}4th{} cards played",
                    "{s:0.8}After hand is played,",
                    "{s:0.8}becomes {s:0.8,C:attention}On-beat{}"
                }
            },
            invisiblejoker_tooltip = {
                name = "Invisible Joker",
                text = {
                    "After {C:attention}2{} rounds,",
                    "sell this card to",
                    "{C:attention}Duplicate{} a random Joker",
                    "{C:inactive}(Currently {C:attention}0{C:inactive}/2)",
                },
            },
        },
    },
    misc = {
        quips = {
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
        },
        v_dictionary = {
            k_picubeds_pot_active = "Active!",
            k_picubeds_pot_inactive = "Inactive",
            k_picubeds_pi = "pi",
        },
        challenge_names = {
            c_picubed_nostalgicrejuvinationdeck = "Nostalgic Rejuvination Deck",
        },
        v_text = {
            ch_c_picubed_slots_gain = { "{C:attention}+1{} Joker slot after Boss Blind is defeated" },
        },
        dictionary = {
            k_picubeds_gullible = "Gullible!",
            k_picubeds_chisel = "Chisel!",
            k_picubeds_prime = "Prime!",
            k_picubeds_tumble = "Tumble!",
            k_picubeds_snakeeyes = "Snake Eyes!",
            k_picubeds_print = "Print!",
            k_picubeds_error = "Error!",
            k_picubeds_pride = "Pride!",
            k_picubeds_slosh = "Slosh!",
            k_picubeds_swap = "Swap!",
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
            k_picubeds_inactive = "Inactive",
            k_picubeds_plusjokerslot = "+1 Joker Slot",
            config_picubeds_newspectrals = "New Spectral Cards (restart required)",
            config_picubeds_customsfx = "Custom Sound Effects (restart required)",
            config_picubeds_pokerhandchangers = "Hand type-affecting Jokers (restart required)",
        }
    }
}