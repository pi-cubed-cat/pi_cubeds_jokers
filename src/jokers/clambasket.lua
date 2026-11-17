SMODS.Sound({
	key = "clambasketopen",
	path = "clambasketopen.ogg",
})

SMODS.Sound({
	key = "clambasketclose",
	path = "clambasketclose.ogg",
})

SMODS.Joker { -- Clam Basket
	key = 'clambasket',
	pronouns = 'it_its',
	rarity = 2,
	atlas = 'PiCubedsJokers',
    pos = { x = 2, y = 14 },
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { xmult = 1.4, mult = 6, is_active = false, is_active_visual = false } },
    demicoloncompat = true,
	attributes = { 'xmult', 'mult', 'rank', 'ace', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight' },
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.xmult, card.ability.extra.mult,
            localize { type = 'variable', key = ((card.ability.extra.is_active and 'k_picubeds_pot_active') or 'k_picubeds_pot_inactive'), vars = { card.ability.extra.is_active } },
        } }
	end,
    update = function(self, card, dt)
		if card and card.ability and card.ability.extra and card.ability.extra.is_active_visual then
            card.children.center:set_sprite_pos({x = 3, y = 14})
        else
            card.children.center:set_sprite_pos({x = 2, y = 14})
        end
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card:get_id() == 8 then
            return {
                xmult = card.ability.extra.xmult,
                func = function()
                    if not card.ability.extra.is_active then
                        card.ability.extra.is_active = true
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.is_active_visual = true
                            return true end 
                        }))
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                            message = localize("k_active_ex"), 
                            sound = picubed_config.custom_sound_effects and "picubed_clambasketopen" or nil
                        })
                    end
                end
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.is_active then
                card.ability.extra.is_active = false
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.ability.extra.is_active_visual = false
                    return true end 
                }))
                return {
                    message = localize("k_reset"),
                    sound = picubed_config.custom_sound_effects and "picubed_clambasketclose" or nil
                }
            end
        end

        if context.individual and context.cardarea == G.play and card.ability.extra.is_active 
        and not SMODS.has_no_rank(context.other_card) then
            local card_id = context.other_card:get_id()
            if card_id == 14 or card_id == 2 or card_id == 3 or card_id == 4 
            or card_id == 5 or card_id == 6 or card_id == 7 then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end

        if context.forcetrigger then
			return {
				mult = card.ability.extra.mult,
                xmult = card.ability.extra.xmult
			}
		end
	end
}