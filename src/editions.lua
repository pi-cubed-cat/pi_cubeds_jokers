SMODS.Shader({ key = 'evil', path = 'evil.fs' })

SMODS.Edition{
	key = "evil",
	order = 2,
    loc_txt = {
        name = "Evil",
        label = "Evil",
        text = {
            "does nothing",
        }
    },
	weight = 13, --evil
	shader = "evil",
	in_shop = true,
	extra_cost = 3,
	config = { x_chips = 1.5, trigger = nil },
	sound = {
		sound = "picubed_explo1",
		per = 1,
		vol = 0.4,
	},

	get_weight = function(self)
		return G.GAME.edition_rate * self.weight
	end,
	--[[loc_vars = function(self, info_queue)
		return { vars = { self.config.x_chips } }
	end,]]
	--[[calculate = function(self, card, context)
		if
			(
				context.edition -- for when on jonklers
				and context.cardarea == G.jokers -- checks if should trigger
				and card.config.trigger -- fixes double trigger
			) or (
				context.main_scoring -- for when on playing cards
				and context.cardarea == G.play
			)
		then
			return { x_chips = self.config.x_chips } -- updated value
		end
		if context.joker_main then
			card.config.trigger = true -- context.edition triggers twice, this makes it only trigger once (only for jonklers)
		end

		if context.after then
			card.config.trigger = nil
		end
	end,]]
}