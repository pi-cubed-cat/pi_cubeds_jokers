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
	attributes = { 'mult', 'chips' },
	config = { extra = { chips_ceil = 100, mult_ceil = 10 } },
	demicoloncompat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_ceil, card.ability.extra.mult_ceil } }
	end,
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			local mult_ceil = 0
			local chips_ceil = 0
			local card_mult = 0
			local card_chips = 0
			if mult < to_big(1e+308) then
				local ret_mult = to_number(mult)
				if card.edition then
					ret_mult = ret_mult + (card.edition.mult or 0)  
				end
				mult_ceil = math.ceil(ret_mult / card.ability.extra.mult_ceil) * card.ability.extra.mult_ceil
				card_mult = mult_ceil - ret_mult
			end 
			if hand_chips < to_big(1e+308) then
				local ret_chips = to_number(hand_chips)
				if card.edition then
					ret_chips = ret_chips + (card.edition.chips or 0) 
				end
				chips_ceil = math.ceil(ret_chips / card.ability.extra.chips_ceil) * card.ability.extra.chips_ceil
				card_chips = chips_ceil - ret_chips
			end
			if card_mult > 0 or card_chips > 0 then
				return {
					colour = G.C.PURPLE,
					message = localize("k_picubeds_gullible"),
					remove_default_message = true,
					chips = card_chips,
					mult = card_mult,
				}
			end
		end
	end
}