SMODS.Joker { --Advanced Skipping
    key = 'advancedskipping',
    loc_txt = {
        name = 'Advanced Skipping',
        text = {
            "Receive {C:attention}#1#{} additional random {C:attention}tags",
            "when blind is {C:attention}skipped{},",
            "{C:attention}+#2# tag{} after each skip",
            "{C:inactive}(Capped at current {}{C:attention}Ante{}{C:inactive}){}"
        }
    },
    pronouns = 'he_him',
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 8, y = 1 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { add_tags = 1, add_tags_mod = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.add_tags, card.ability.extra.add_tags_mod} }
    end,
    calculate = function(self, card, context)
        if context.skip_blind and not context.blueprint then
            --code below taken from Ortalab's Recycled Enhancement
            local tag_pool = get_current_pool('Tag')
            for i=1,card.ability.extra.add_tags do         
                local selected_tag = pseudorandom_element(tag_pool, pseudoseed('advancedskipping'..G.GAME.round_resets.ante))
                local it = 1
                while selected_tag == 'UNAVAILABLE' do
                    it = it + 1
                    selected_tag = pseudorandom_element(tag_pool, pseudoseed('advancedskipping'..it..G.GAME.round_resets.ante))
                end
                if selected_tag ~= 'tag_orbital' then
                    add_tag(Tag(selected_tag))
                else --i can't be assed dealing with orbital tag rn
                    add_tag(Tag('tag_meteor'))
                end
            end
            card:juice_up()
            if G.GAME.round_resets.ante > card.ability.extra.add_tags then
                card.ability.extra.add_tags = card.ability.extra.add_tags + card.ability.extra.add_tags_mod
                return {
                    message = localize('k_upgrade_ex'),
                    card = card
                }
            end
        end
    end
}