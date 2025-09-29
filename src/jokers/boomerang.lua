SMODS.Joker { --Boomerang
	key = 'boomerang',
	loc_txt = {
		name = 'Boomerang',
		text = {
			"Scoring cards are",
			"{C:attention}shuffled back{}",
			"into the deck",
		}
	},
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 9, y = 9 },
	cost = 4,
	discovered = true,
	blueprint_compat = false,
    perishable_compat = true,
	eternal_compat = true,
	calculate = function(self, card, context)
		if context.after and not context.blueprint then -- makeshift jankshit context.scoring_hand but "global"
			picubed_boomerang_scoring = {}
			for i=1,#context.full_hand do
				for k,v in ipairs(context.scoring_hand) do
					if context.full_hand[i] == v then
						picubed_boomerang_scoring[v] = true
					end
				end
			end
		end
	end
}

-- uses additional functionality from lovely/boomerang.toml