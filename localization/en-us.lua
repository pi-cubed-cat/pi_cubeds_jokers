return {
    descriptions = {
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
                  "If this Joker is the {C:attention}left-most{},",
                  "played {C:attention}6s{} become {C:attention}9s{}",
                  "If this Joker is the {C:attention}right-most{},",
                  "played {C:attention}9s{} become {C:attention}6s{}"
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
                  --"or {C:attention}destroyed",
                  "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
                }
            },
            j_picubed_inkjetprinter = {
                name = 'Inkjet Printer',
                text = {
                  "{C:attention}Consumables{} have a {C:green}#1# in #2#",
                  "chance to be {C:attention}recreated{} on use,",
                  "this card has a {C:green}#1# in #3#{} chance to",
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
            j_picubed_bisexualflag_spectrums = {
                name = 'Bisexual Flag',
                text = {
                  "If {C:attention}played hand{} contains either",
                  "a {C:attention}Straight{} and {C:attention}all four default{}",
                  "{C:attention}suits{}, or a {C:attention}Straight Spectrum{},",
                  "create 3 {C:dark_edition}Negative {C:purple}Tarot{} cards",
                }
            },
            j_picubed_bisexualflag = {
                name = 'Bisexual Flag',
                text = {
                  "If {C:attention}played hand{} contains a",
                  "{C:attention}Straight{} and {C:attention}all four suits{},",
                  "create 3 {C:dark_edition}Negative {C:purple}Tarot{} cards",
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
                  "This Joker gains {X:mult,C:white}X#1#{} Mult",
                  "if {C:attention}played hand{} is a",
                  "{C:attention}Flush House{}",
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
                  "{C:attention}#1#{} additional times",
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
                  "Earn {C:money}$#1#{} after hand is",
                  "played, {C:green}#2# in #3#{} chance",
                  "to be {C:attention}destroyed",
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
            j_picubed_preorderbonus_hookless = {
                name = 'Preorder Bonus',
                text = {
                  "After opening a",
                  "Booster Pack, refund",
                  "{C:attention}#1#%{} of the cost"
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
        },
        Mod = {
            picubedsjokers = {
                name = "pi_cubed's Jokers",
                text = {
                    "A collection of vanilla-friendly Jokers made by yours truly.",
                    "Follow me on bluesky at @picubed.bsky.social!",
                    "Thanks franderman123 for Español (México) localization!"
                }
            },
        },
    },
    misc = {
        v_dictionary = {
            k_picubeds_pot_active = "Active!",
            k_picubeds_pot_inactive = "Inactive",
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
            config_picubeds_newspectrals = "New Spectral Cards (restart required)",
            config_picubeds_preorderhook = "Preorder Bonus' hook (disable for better compatibility, restart required)",
            config_picubeds_customsfx = "Custom Sound Effects (restart required)"
        }
    }
}