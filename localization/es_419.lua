return {
    descriptions = {
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
                  "{C:attention}+#2# etiqueta{} por cada ciega omitida"
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
                  "crea 3 cartas de {C:purple}Tarot{} {C:dark_edition}Negativas {C:purple}Tarot{}"
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
        },
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
            config_picubeds_newspectrals = "Nuevas cartas espectrales (Requiere reinicio)",
            config_picubeds_preorderhook = "Beneficios de preventa' hook (desactivar para mejor compatibilidad, Requiere reinicio)",
            config_picubeds_customsfx = "Efectos de sonidos personalizados (Requiere reinicio)"
        }
    }
}