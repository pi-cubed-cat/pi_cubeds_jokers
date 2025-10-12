SMODS.Joker { --Laser Printer
	 key = 'laserprinter',
	loc_txt = {
		name = 'Laser Printer',
		text = {
			"{C:attention}Consumables{} have a {C:green}#1# in #2#{} chance",
			"to be {C:attention}recreated{} on use and a",
			"{C:green}#5# in #6#{} chance to be made {C:dark_edition}Negative{},",
			"this card has a {C:green}#3# in #4#{} ",
			"chance to be {C:attention}disabled{} for",
			"this Ante after activating",
			"{C:inactive}(Must have room){}"
		}
	},
	pronouns = 'it_its',
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 1, y = 8 },
	--soul_pos = { x = 1, y = 7 },
	soul_pos = { x = 10, y = 7 }, --no soul
	cost = 6,
	unlocked = false,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = false,
	config = { extra = { copy_odds = 2, destroy_odds = 4, copied = {}, negative_odds = 2, is_disabled = false } },
	loc_vars = function(self, info_queue, card)
		local numerator_copy, denominator_copy = SMODS.get_probability_vars(card, 1, card.ability.extra.copy_odds, 'picubed_laserprinter_copy')
		local numerator_destroy, denominator_destroy = SMODS.get_probability_vars(card, 1, card.ability.extra.destroy_odds, 'picubed_laserprinter_destroy')
		local numerator_neg, denominator_neg = SMODS.get_probability_vars(card, 1, card.ability.extra.negative_odds, 'picubed_laserprinter_neg')
		return { vars = { numerator_copy, denominator_copy, numerator_destroy, denominator_destroy, numerator_neg, denominator_neg } }
	end,
	in_pool = function(self, args)
			return G.GAME.pool_flags.picubed_printer_error and #SMODS.find_card('j_picubed_inkjetprinter') < 1
	end,
	locked_loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.j_picubed_inkjetprinter
		return { vars = { card.ability.max_highlighted } }
	end,
	check_for_unlock = function(self, args)
			if G.GAME.pool_flags.picubed_printer_error then return true end
			return false
	end,
	update = function(self, card, dt)
		if not card.ability.extra.is_disabled then
			card.children.floating_sprite:set_sprite_pos({ x = 10, y = 7 }) -- no soul
		else
			card.children.floating_sprite:set_sprite_pos({ x = 1, y = 7 })
		end
	end,
	calculate = function(self, card, context)
		if context.end_of_round and G.GAME.blind.boss and context.cardarea == G.jokers and card.ability.extra.is_disabled then
			card.ability.extra.is_disabled = false
			card.children.floating_sprite:set_sprite_pos({ x = 10, y = 7 })
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize("k_picubeds_fixed") })
		end
		if context.using_consumeable and not context.blueprint and not card.ability.extra.is_disabled then
			G.E_MANAGER:add_event(Event({
                func = function()
                  	if SMODS.pseudorandom_probability(card, 'picubed_laserprinter_copy', 1, card.ability.extra.copy_odds) then
						local has_activated = false
						local has_destroyed = false
						local is_negative = false

						if SMODS.pseudorandom_probability(card, 'picubed_laserprinter_neg', 1, card.ability.extra.negative_odds) then
							is_negative = true
						end

                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            func = function()
                                if is_negative then
									card_eval_status_text(card, 'extra', nil, nil, nil,
										{ message = localize("k_picubeds_print") })
									local copied_card = copy_card(context.consumeable, nil)
									copied_card:add_to_deck()
									if context.consumeable.edition then
										if not copied_card.edition == 'e_negative' then
											copied_card:set_edition("e_negative", false, true)
										end
									else
										copied_card:set_edition("e_negative", false, true)
									end
									G.consumeables:emplace(copied_card)
									has_activated = true
									
								elseif #G.consumeables.cards < G.consumeables.config.card_limit then
									card_eval_status_text(card, 'extra', nil, nil, nil,
										{ message = localize("k_picubeds_print") })
									local copied_card = copy_card(context.consumeable, nil)
									copied_card:add_to_deck()
									G.consumeables:emplace(copied_card)
									has_activated = true
								end
								return true
                            end
                        }))

                        if SMODS.pseudorandom_probability(card, 'picubed_inkjetprinter_destroy', 1, card.ability.extra.destroy_odds) then
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    if has_activated then
                                        card_eval_status_text(card, 'extra', nil, nil, nil,
                                            { message = localize("k_picubeds_error"), sound = 'tarot1', colour = G.C.RED })
                                        has_destroyed = true
										G.E_MANAGER:add_event(Event({
											trigger = 'after',
											func = function()
												card.ability.extra.is_disabled = true
												card.children.floating_sprite:set_sprite_pos({ x = 1, y = 7 })
												return true;
											end
										}))
                                    end
                                    return true
                                end
                            }))
                        end
                    end

                    return true
                end
            }))
		end

	end
}