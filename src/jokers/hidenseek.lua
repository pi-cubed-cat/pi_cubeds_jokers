--Code below from Vanilla Remade mod
local function reset_hidenseek_rank()
	G.GAME.current_round.picubed_hidenseek_possible_ranks = {}
    G.GAME.current_round.picubed_hidenseek_searched_ranks = {}
    G.GAME.current_round.picubed_hidenseek_card = { rank = 'None', id = 'None' }
    local valid_hidenseek_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(playing_card) then
            G.GAME.current_round.picubed_hidenseek_possible_ranks[playing_card.base.value] = true
            valid_hidenseek_cards[#valid_hidenseek_cards + 1] = playing_card
        end
    end
    local hidenseek_card = pseudorandom_element(valid_hidenseek_cards, pseudoseed('picubed_hidenseek' .. G.GAME.round_resets.ante))
    if hidenseek_card then
        G.GAME.current_round.picubed_hidenseek_card.rank = hidenseek_card.base.value
        G.GAME.current_round.picubed_hidenseek_card.id = hidenseek_card.base.id
    end
end

function picubed_get_unsearched_ranks()
    if not G.GAME.current_round.picubed_hidenseek_possible_ranks then return {} end
    local searched_ranks = G.GAME.current_round.picubed_hidenseek_searched_ranks
    local unsearched_ranks = {}
    for k,v in pairs(G.GAME.current_round.picubed_hidenseek_possible_ranks) do
        if not searched_ranks[k] then
            unsearched_ranks[k] = true
        end
    end

    local loc_unsearched_ranks = {}
    for k,v in pairs(SMODS.Rank.obj_buffer) do
        if unsearched_ranks[v] then
            table.insert(loc_unsearched_ranks, localize(v, 'ranks'))
        end
    end
    return loc_unsearched_ranks
end

SMODS.Joker { --Hide n' Seek
    key = 'hidenseek',
    loc_txt = {
        name = "Hide n' Seek",
        text = {
            "One {C:attention}secret rank{} will give",
            "{C:money}$#1#{} and create a {C:planet}Planet{} card",
            "when played and scoring,",
            "rank changes after it is {C:attention}found{}",
            "{C:inactive}(Must have room)",
        }
    },
    pronouns = 'he_they',
    rarity = 1,
    config = { extra = { money = 6 } },
    atlas = 'PiCubedsJokers',
    pos = { x = 9, y = 13 },
    cost = 4,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
		local unsearched_ranks = picubed_get_unsearched_ranks()
        if #unsearched_ranks > 0 and next(SMODS.find_card('j_picubed_hidenseek')) then
            main_end = {
                {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                    {n=G.UIT.C, config={align = "m", colour = G.C.RED, r = 0.05, padding = 0.05}, nodes={
                        {n=G.UIT.T, config={text = table.concat(unsearched_ranks or {}, ", "), colour = G.C.UI.TEXT_LIGHT, scale = 0.25, shadow = false}},
                    }}
                }}
            }
		else
            main_end = nil
		end
        return { vars = { card.ability.extra.money }, main_end = main_end }
	end,
    calculate = function(self, card, context)
        if (context.setting_blind or context.end_of_round) and not context.blueprint and not context.joker_retrigger then
            local secret_card_remaining = false
            for k,v in ipairs(G.playing_cards) do
                if not SMODS.has_no_rank(v) and v.base.value == G.GAME.current_round.picubed_hidenseek_card.rank then
                    secret_card_remaining = true
                    break
                end
            end
            if not secret_card_remaining then
                reset_hidenseek_rank()
                return {
                    message = localize('k_reset')
                }
            end
        end
        if context.before then
            local has_secret_rank = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == G.GAME.current_round.picubed_hidenseek_card.id then
                    has_secret_rank = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            context.scoring_hand[i]:juice_up()
                            return true
                        end
                    }))
                elseif not SMODS.has_no_rank(context.scoring_hand[i]) then
                    G.GAME.current_round.picubed_hidenseek_searched_ranks[context.scoring_hand[i].base.value] = true
                end
            end
            
            if has_secret_rank then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card({ set = 'Planet' })
                            G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
                end
                reset_hidenseek_rank()
                return {
                    dollars = card.ability.extra.money,
                    card = card,
                    func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                    end
                }
            end
        end
    end
}

function SMODS.current_mod.reset_game_globals(run_start)
    if run_start then reset_hidenseek_rank() end
end