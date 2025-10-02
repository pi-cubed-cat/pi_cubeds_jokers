SMODS.Joker { --It Says "Joker" on the Ceiling
		key = 'itsaysjokerontheceiling',
		loc_txt = {
				name = 'It Says "Joker" on the Ceiling',
				text = {
						"Round {C:chips}Chips{} to the next #1#,", 
						"Round {C:mult}Mult{} to the next #2#"
				}
		},
		pronouns = 'he_him',
		rarity = 1,
		atlas = 'PiCubedsJokers',
		pos = { x = 0, y = 0 },
		cost = 5,
		discovered = true,
		blueprint_compat = true,
		loc_vars = function(self, info_queue, card)
				return { vars = { card.ability.extra.chips_ceil, card.ability.extra.mult_ceil } }
		end,
		config = { extra = { chips = 0, mult = 0, chips_ceil = 100, mult_ceil = 10 } },
		calculate = function(self, card, context)
				local mult_ceil = 0
				local chips_ceil = 0
				if context.joker_main then
						if mult < to_big(1e+308) then
								mult_ceil = math.ceil(to_number(mult) / card.ability.extra.mult_ceil) * card.ability.extra.mult_ceil
								card.ability.extra.mult = mult_ceil - to_number(mult)
						end 
						if hand_chips < to_big(1e+308) then
								chips_ceil = math.ceil(to_number(hand_chips) / card.ability.extra.chips_ceil) * card.ability.extra.chips_ceil
								card.ability.extra.chips = chips_ceil - to_number(hand_chips)
						end
						return {
								colour = G.C.PURPLE,
								message = localize("k_picubeds_gullible"),
								remove_default_message = true,
								chips = card.ability.extra.chips,
								mult = card.ability.extra.mult
						}
				end
		end
		}