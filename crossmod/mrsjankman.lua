SMODS.Joker { -- Mrs. Jankman (Cryptid & MoreFluff)
	key = 'mrsjankman_joker',
	loc_txt = {
		name = 'Mrs. Jankman',
		text = {
			"All Jokers with a", 
			"{C:attention}modded Edition{}",
			"give {X:chips,C:white}X#1#{} Chips",
			"{s:0.8,C:inactive,E:2}Heteronormative Jank!"
			
		}
	},
	pronouns = 'she_her',
	config = { extra = { x_chips = 27.41 } },
	rarity = 4,
	atlas = 'PiCubedsJokers',
	pos = { x = 2, y = 7 },
	soul_pos = { x = 3, y = 7 },
	cost = 20,
	discovered = true,
	blueprint_compat = true,
	pools = { ["Meme"] = true },
	in_pool = function(self, args)
		return (#find_joker("j_mf_jankman") > 0)
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_chips } }
	end,
	
	calculate = function(self, card, context)
		if context.other_joker and context.other_joker.edition then
			if context.other_joker.edition.key ~= 'e_polychrome' then
				if context.other_joker.edition.key ~= 'e_foil' then
					if context.other_joker.edition.key ~= 'e_holographic' then
						if context.other_joker.edition.key ~= 'e_negative' then
							if (not context.other_joker.debuff) then
								return {
									xchips = card.ability.extra.x_chips,
									card = card
								}
							end
						end
					end
				end
			end
		end
	end
}