SMODS.Joker { --Chicken Joker!
	key = 'chickenjoker',
	loc_txt = {
		name = 'Chicken Joker!',
		text = {
			"If scoring hand contains",
			"a {C:attention}Stone{} card or a {C:attention}Steel{}",
			"card, {C:attention}fill{} empty Joker",
			"slots with {C:dark_edition}Editioned{} {C:attention}Popcorn{}"
		}
	},
	pronouns = 'it_its',
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 7, y = 8 },
	cost = 5,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	loc_vars = function(self, info_queue, card)
		picubed_stonelike_infoqueue(info_queue)
		info_queue[#info_queue+1] = G.P_CENTERS.m_steel
		info_queue[#info_queue+1] = G.P_CENTERS.j_popcorn
		return { vars = { card.ability.max_highlighted } }
	end,
	in_pool = function(self, args)
		for kk, vv in pairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(vv, 'm_steel') or picubed_is_stonelike(vv) then
                return true
            end
		end
		return false
	end,
	calculate = function(self, card, context)
		if context.final_scoring_step and not context.blueprint and not context.joker_retrigger then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				func = function()
					for k,v in ipairs(G.jokers.cards) do
						if v.picubed_chickenjoker_created then
							v:flip()
							v.picubed_chickenjoker_created = nil
						end
					end
					return true;
				end
			}))
		end
		if context.before and context.main_eval and not context.blueprint then
			local has_flint_or_steel = false
			for kk, vv in ipairs(context.scoring_hand) do
				if picubed_is_stonelike(vv) or SMODS.has_enhancement(vv, 'm_steel') then
					has_flint_or_steel = true
				end
			end
			if has_flint_or_steel then
				local joker_limit_buffer = 0
				for i=1, (G.jokers.config.card_limit) do
					if (#G.jokers.cards - joker_limit_buffer) < G.jokers.config.card_limit then
						local polled_edition = poll_edition('iamsteve'..G.GAME.round_resets.ante, 1, false, true)
						if polled_edition ~= 'e_negative' then joker_limit_buffer = joker_limit_buffer - 1 end
						G.E_MANAGER:add_event(Event({
							trigger = 'before',
							delay = 0.25,
							func = (function()
								local mpcard = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_popcorn', 'chi')
								mpcard.picubed_chickenjoker_created = true
								mpcard:set_edition(polled_edition, false, true)
								mpcard:add_to_deck()
								G.jokers:emplace(mpcard)
								mpcard:start_materialize()
								card:juice_up()
								mpcard:flip()
								return true
						end)}))
					end
				end
			end
		end
	end
}