-- can buy with full slots (from MoreFluff)
local old_g_funcs_check_for_buy_space = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
	if card.ability.name == "j_picubed_talkingflower" and card.ability.extra.slots >= 1 then
		return true
	end
	return old_g_funcs_check_for_buy_space(card)
end

-- can select with full slots (from MoreFluff)
local old_g_funcs_can_select_card = G.FUNCS.can_select_card
G.FUNCS.can_select_card = function(card)
  	if card.config.ref_table.ability.name == "j_picubed_talkingflower" and card.config.ref_table.ability.extra.slots >= 1 then
    	card.config.colour = G.C.GREEN
    	card.config.button = 'use_card'
  	else
    	old_g_funcs_can_select_card(card)
  	end
end

-- add speech bubble (from Partner)
function Card:add_tf_speech_bubble(input_key)
    if self.children.speech_bubble then self.children.speech_bubble:remove() end
    local align = nil
    if self.T.x+self.T.w/2 > G.ROOM.T.w/2 then align = "cl" end
    self.config.speech_bubble_align = {align = align or "cr", offset = {x=align and -0.1 or 0.1,y=0}, parent = self}
    self.children.speech_bubble = UIBox{
        definition = G.UIDEF.tf_speech_bubble(input_key),
        config = self.config.speech_bubble_align
    }
    self.children.speech_bubble:set_role{role_type = "Minor", xy_bond = "Strong", r_bond = "Weak", major = self}
    self.children.speech_bubble.states.visible = false
    local hold_time = (G.SETTINGS.GAMESPEED*4) or 4
    G.E_MANAGER:add_event(Event({trigger = "after", delay = hold_time, blockable = false, blocking = false, func = function()
        self:remove_tf_speech_bubble()
    return true end}))
end

function G.UIDEF.tf_speech_bubble(input_key)
    local text = {}
    localize{type = "quips", key = input_key, nodes=text}
    local row = {}
    for k, v in ipairs(text) do
        row[#row+1] = {n=G.UIT.R, config={align = "cl"}, nodes=v}
    end
    local t = {n=G.UIT.ROOT, config = {align = "cm", minh = 1, r = 0.3, padding = 0.07, minw = 1, colour = G.C.JOKER_GREY, shadow = true}, nodes={
        {n=G.UIT.C, config={align = "cm", minh = 1, r = 0.2, padding = 0.1, minw = 1, colour = G.C.WHITE}, nodes={
            {n=G.UIT.C, config={align = "cm", minh = 1, r = 0.2, padding = 0.03, minw = 1, colour = G.C.WHITE}, nodes=row}
        }}
    }}
    return t
end

function Card:tf_say_stuff(n, not_first)
    self.talking = true
    if not not_first then 
        G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.1, func = function()
            if self.children.speech_bubble then self.children.speech_bubble.states.visible = true end
            self:tf_say_stuff(n, true)
        return true end}))
    else
        if n <= 0 then self.talking = false; return end
        --play_sound("voice"..math.random(1, 11), G.SPEEDFACTOR*(math.random()*0.2+1), 0.5)
        self:juice_up()
        G.E_MANAGER:add_event(Event({trigger = "after", blockable = false, blocking = false, delay = 0.13*((G.SETTINGS.GAMESPEED*2) or 2), func = function()
            self:tf_say_stuff(n-1, true)
        return true end}))
    end
end

local Card_draw_ref = Card.draw
function Card:draw(layer)
		Card_draw_ref(self, layer)
		if self.children.speech_bubble then
				self.children.speech_bubble:draw()
		end
end

function Card:remove_tf_speech_bubble()
		if self.children.speech_bubble then self.children.speech_bubble:remove(); self.children.speech_bubble = nil end
end

function Card:tf_say(key, prob)
	prob = #SMODS.find_card('j_picubed_talkingflower')
	if pseudorandom(tostring(key)..G.GAME.round_resets.ante) < (1 / prob) then
		G.E_MANAGER:add_event(Event({ func = function() 
			self:add_tf_speech_bubble(key)
			self:tf_say_stuff(5)
			if picubed_config.custom_sound_effects then
				play_sound("picubed_"..key)
			end
		return true end }))
	end
end

SMODS.Sound({
	key = "tf_bye1",
	path = "tf_bye1.ogg",
})
SMODS.Sound({
	key = "tf_bye2",
	path = "tf_bye2.ogg",
})
SMODS.Sound({
	key = "tf_bye3",
	path = "tf_bye3.ogg",
})
SMODS.Sound({
	key = "tf_hi1",
	path = "tf_hi1.ogg",
})
SMODS.Sound({
	key = "tf_hi2",
	path = "tf_hi2.ogg",
})
SMODS.Sound({
	key = "tf_hi3",
	path = "tf_hi3.ogg",
})
SMODS.Sound({
	key = "tf_hi4",
	path = "tf_hi4.ogg",
})
SMODS.Sound({
	key = "tf_hi5",
	path = "tf_hi5.ogg",
})
SMODS.Sound({
	key = "tf_onward",
	path = "tf_onward.ogg",
})
SMODS.Sound({
	key = "tf_shop_high1",
	path = "tf_shop_high1.ogg",
})
SMODS.Sound({
	key = "tf_shop_high2",
	path = "tf_shop_high2.ogg",
})
SMODS.Sound({
	key = "tf_shop_high3",
	path = "tf_shop_high3.ogg",
})
SMODS.Sound({
	key = "tf_shop_low1",
	path = "tf_shop_low1.ogg",
})
SMODS.Sound({
	key = "tf_shop_low2",
	path = "tf_shop_low2.ogg",
})
SMODS.Sound({
	key = "tf_shop_low3",
	path = "tf_shop_low3.ogg",
})
SMODS.Sound({
	key = "tf_wee1",
	path = "tf_wee1.ogg",
})
SMODS.Sound({
	key = "tf_wee2",
	path = "tf_wee2.ogg",
})

SMODS.Joker { --Talking Flower
	key = 'talkingflower',
	loc_txt = {
		name = 'Talking Flower',
		text = {
			"{C:dark_edition}+#1#{} Joker Slot,",
			"{C:mult}+#2#{} Mult"
			
		}
	},
	pronouns = 'he_they',
	config = { extra = { slots = 1, mult = 4 } },
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 0, y = 7 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	pools = { ["Meme"] = true },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.slots, card.ability.extra.mult } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
		if G.GAME.round == 0 then
			card:tf_say("tf_onward")
			--print("Onward and Upward!")
		else
			local tfnum = pseudorandom_element({1,2,3,4,5}, pseudoseed("talkingflower"..G.GAME.round_resets.ante))
			card:tf_say("tf_hi"..tfnum)
			--print("Hiiii!")
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
		local tfnum = pseudorandom_element({1,2,3}, pseudoseed("talkingflower"..G.GAME.round_resets.ante))
		card:tf_say("tf_bye"..tfnum)
		--print("Later!")
	end,
	
	calculate = function(self, card, context)
		if context.card_added then
			if context.card.ability.name == 'Wee Joker' or context.card.ability.name == 'j_picubed_weemini' then
				local tfnum = pseudorandom_element({1,2}, pseudoseed("talkingflower"..G.GAME.round_resets.ante))
				card:tf_say("tf_wee"..tfnum)
				--print("Weeeee!")
			end
		end
		if context.starting_shop then
			if to_number(G.GAME.dollars) >= 15 then
				local tfnum = pseudorandom_element({1,2,3}, pseudoseed("talkingflower"..G.GAME.round_resets.ante))
				card:tf_say("tf_shop_high"..tfnum)
				--print("Why not take both?")
			else
				local tfnum = pseudorandom_element({1,2,3}, pseudoseed("talkingflower"..G.GAME.round_resets.ante))
				card:tf_say("tf_shop_low"..tfnum)
				--print("Tough choice...")
			end
		end
		if context.joker_main then
			return {
				mult = card.ability.extra.mult,
				card = card
			}
		end
	end
}