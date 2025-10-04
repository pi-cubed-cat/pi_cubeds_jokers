SMODS.Joker { --Super Wrathful Joker
    key = 'superwrathfuljoker',
    loc_txt = {
        name = 'Super Wrathful Joker',
        text = {
            "If played hand has {C:attention}#1#{} scoring",
            "cards or less, all scored",
            "{C:spades}Spade{} cards become {C:attention}Kings{}",
        }
    },
    pronouns = 'he_him',
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 6, y = 1 },
    cost = 9,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { max_cards = 4 } },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.max_cards } }
	end,
    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            if #context.scoring_hand <= card.ability.extra.max_cards then
                local has_spades = false
                for k, v in ipairs(context.scoring_hand) do
                    if not v.debuff then
                        if v:is_suit("Spades") then
                            has_spades = true
                            v:juice_up()
                            assert(SMODS.change_base(v, nil, 'King'))
                        end
                    end
                end
                if has_spades then
                    has_spades = false
                    if G.GAME.blind.config.blind.key == ("bl_pillar") then
                        for k, v in ipairs(context.scoring_hand) do
                            v.debuff = false
                        end
                    end
                    return {
                        message = localize("k_picubeds_spade"),
                        card = card,
                        colour = G.C.SUITS["Spades"]
                    }
                end
            end
        end
    end
}
