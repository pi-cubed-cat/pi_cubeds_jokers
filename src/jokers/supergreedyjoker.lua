local function list_valid_joker_tags()
	local valid_tags = {}
	for k,v in pairs(G.P_TAGS) do
		local tag = G.P_TAGS[k]
		if tag.attributes and tag.attributes.joker and (tag.attributes.editions or tag.attributes.rarity) 
		and k ~= 'tag_top_up' then
			valid_tags[#valid_tags+1] = k
		end
	end
	
	return valid_tags
end

local function create_random_joker_tag(obj, other_card)
	local valid_tags = list_valid_joker_tags()
	if #valid_tags > 0 and (#G.GAME.tags + (G.GAME.tag_count_buffer or 0)) < (G.GAME.dollars + (G.GAME.dollar_buffer or 0)) then
		G.GAME.tag_count_buffer = (G.GAME.tag_count_buffer or 0) + 1
		return {
			message = localize("k_picubeds_diamond"),
			message_card = obj,
			no_juice = true,
			colour = G.C.SUITS["Diamonds"],
			func = function()
				G.E_MANAGER:add_event(Event({
					func = function()
						add_tag({ key = pseudorandom_element(valid_tags, 'picubed_supergreedyjoker') })
						play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
						play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
						if other_card then other_card:juice_up() end
						G.GAME.tag_count_buffer = 0
						return true
					end
				}))
			end,
		}
	else
		return {}
	end
end

SMODS.Joker { --Super Greedy Joker
	key = 'supergreedyjoker',
	pronouns = 'they_them',
	rarity = 3,
	atlas = 'PiCubedsJokers',
	pos = { x = 6, y = 3 },
	cost = 9,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	attributes = { 'tag', 'generation', 'suit', 'diamonds' },
	demicoloncompat = true,
	loc_vars = function(self, info_queue, card)
        local valid_tags = list_valid_joker_tags()
		for i=1,#valid_tags do
			info_queue[#info_queue + 1] = { key = valid_tags[i], set = 'Tag' }
		end
    end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card:is_suit("Diamonds") then
			return create_random_joker_tag(context.blueprint_card or card, context.other_card)
		end
		if context.forcetrigger then
			return create_random_joker_tag(card)
		end
	end
}
