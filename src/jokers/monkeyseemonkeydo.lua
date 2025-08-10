SMODS.Sound({
	key = "monkey1",
	path = "monkey1.ogg",
})

SMODS.Sound({
	key = "monkey2",
	path = "monkey2.ogg",
})

local function reset_monkey_ranks()
	G.GAME.current_round.picubed_monkeysee = { rank = 'King', id = 13 }
	G.GAME.current_round.picubed_monkeydo = { rank = 'Ace', id = 14 }
    local valid_monkey_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(playing_card) then
            valid_monkey_cards[#valid_monkey_cards + 1] = playing_card
        end
    end
    local monkeysee_card = pseudorandom_element(valid_monkey_cards, pseudoseed('picubed_monkeysee' .. G.GAME.round_resets.ante))
    if monkeysee_card then
        local monkeysee_rank = monkeysee_card.base.id
		G.GAME.current_round.picubed_monkeysee.rank = monkeysee_card.base.value
        G.GAME.current_round.picubed_monkeysee.id = monkeysee_card.base.id
    end
	valid_monkey_cards = {}
	for _, playing_card in ipairs(G.playing_cards) do
		if not SMODS.has_no_rank(playing_card) and playing_card.base.id ~= monkeysee_rank then
            valid_monkey_cards[#valid_monkey_cards + 1] = playing_card
        end
    end
	local monkeydo_card = pseudorandom_element(valid_monkey_cards, pseudoseed('picubed_monkeydo' .. G.GAME.round_resets.ante))
	if monkeydo_card then
        G.GAME.current_round.picubed_monkeydo.rank = monkeydo_card.base.value
        G.GAME.current_round.picubed_monkeydo.id = monkeydo_card.base.id
    end
end

SMODS.Joker { --Monkey See, Monkey Do
	key = 'monkeyseemonkeydo',
	loc_txt = {
		name = 'Monkey See, Monkey Do',
		text = {
			"Each played {C:attention}#1#{} and {C:attention}#2#{}", 
			"gives {C:mult}+#3#{} Mult when scored",
            "{s:0.8}Ranks change every {}{s:0.8,C:attention}hand{}",
		}
	},
	config = { extra = { mult = 8 } },
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 4, y = 9 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { localize((G.GAME.current_round.picubed_monkeysee or {}).rank or 'King', 'ranks'), localize((G.GAME.current_round.picubed_monkeydo or {}).rank or 'Ace', 'ranks'), card.ability.extra.mult } }
    end,
	calculate = function(self, card, context)
        if not G.GAME.current_round.picubed_monkeysee then -- initialise on first play
			G.GAME.current_round.picubed_monkeysee = { rank = 'King', id = 13 }
			G.GAME.current_round.picubed_monkeydo = { rank = 'Ace', id = 14 }
		end
		if context.individual and context.cardarea == G.play then
			if not picubed_config.custom_sound_effects then
				if context.other_card:get_id() == G.GAME.current_round.picubed_monkeysee or context.other_card:get_id() == G.GAME.current_round.picubed_monkeydo then
					return {
						mult = card.ability.extra.mult
					}
				end
			else
				if context.other_card:get_id() == G.GAME.current_round.picubed_monkeysee.id then
					G.E_MANAGER:add_event(Event({func = function()
					play_sound("picubed_monkey1")
					return true end}))
					return {
						mult = card.ability.extra.mult,
					}
				end
				if context.other_card:get_id() == G.GAME.current_round.picubed_monkeydo.id then
					G.E_MANAGER:add_event(Event({func = function()
					play_sound("picubed_monkey2")
					return true end}))
					return {
						mult = card.ability.extra.mult,
					}
				end
			end
        end
		if context.after and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				func = (function()
					reset_monkey_ranks()
					return true
				end)
			}))
		end
	end
}

local startRef = Game.start_run
function Game:start_run(args)
	startRef(self, args)
	reset_monkey_ranks()
end