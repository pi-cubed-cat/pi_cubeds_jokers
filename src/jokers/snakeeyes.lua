SMODS.Joker { --Snake Eyes
    key = 'snakeeyes',
    loc_txt = {
        name = 'Snake Eyes',
        text = {
            "When this card is {C:attention}sold{}, Joker",
            "to the {C:attention}left{} has its listed ",
            "{E:1,C:green}probabilities {C:attention}guaranteed",
            "{C:inactive}(ex: {C:green}1 in 6 {C:inactive}-> {C:green}1 in 1{C:inactive})"
            
        }
    },
    pronouns = 'he_him',
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 2, y = 1 },
    cost = 6,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,
    pools = { ["Meme"] = true },
    calculate = function(self, card, context)
        if #G.jokers.cards ~= 1 and not context.blueprint and context.selling_self then
            local joker_left = joker_left or 0
            for i=1, #G.jokers.cards do -- determining which joker is left of card
                if G.jokers.cards[i] == card and i ~= 1 then
                    joker_left = G.jokers.cards[i - 1]
                end
            end
            
            if joker_left ~= 0 and type(joker_left.ability.extra) == 'table' then
                local odds_count = 0
                if joker_left.config.center.key == 'j_cavendish' then
                    check_for_unlock({type = 'picubed_snakeeyes_bananabreaker'})
                end
                for k, v in pairs(joker_left.ability.extra) do
                    if string.match(k, "odds") then
                        joker_left.ability.extra[k] = 1
                        odds_count = 1
                    end
                end
                if odds_count > 0 then
                    return {
                        message = localize("k_picubeds_snakeeyes"),
                        card = card
                    }
                end
            elseif joker_left ~= 0 and type(joker_left.ability.extra) == 'number' then --this may cause funny shit to happen
                joker_left.ability.extra = 1
                return {
                    message = localize("k_picubeds_snakeeyes"),
                    card = card
                }
            end
        end
    end
}