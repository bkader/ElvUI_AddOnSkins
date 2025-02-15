local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

if not AS:IsAddonLODorEnabled("Skada") then return end

-- Skada r301
-- https://www.curseforge.com/wow/addons/skada/files/458800

S:AddCallbackForAddon("Skada", "Skada", function()
	if not E.private.addOnSkins.Skada then return end

	if Skada.revisited then
		local function AddDisplayOptions(_, _, options)
			options.windowoptions = nil
			options.titleoptions.args.texture = nil
			options.titleoptions.args.bordertexture = nil
			options.titleoptions.args.thickness = nil
			options.titleoptions.args.margin = nil
			options.titleoptions.args.color = nil
		end
		if Skada.displays.bar then
			hooksecurefunc(Skada.displays.bar, "AddDisplayOptions", AddDisplayOptions)
		end
		if Skada.displays.legacy then
			hooksecurefunc(Skada.displays.legacy, "AddDisplayOptions", AddDisplayOptions)
		end
		AS:SkinLibrary("LibUIDropDownMenu")
	end

	local function ApplySettings(_, win)
		local skada = win.bargroup

		if win.db.enabletitle then
			skada.button:SetBackdrop(nil)

			if not skada.button.backdrop then
				skada.button:CreateBackdrop()
			end

			if skada.button.backdrop then
				skada.button.backdrop:SetFrameLevel(skada.button:GetFrameLevel())
				skada.button.backdrop:SetTemplate(E.db.addOnSkins.skadaTitleTemplate, E.db.addOnSkins.skadaTitleTemplate == "Default" and E.db.addOnSkins.skadaTitleTemplateGloss or false)

				skada.button.backdrop:ClearAllPoints()
				skada.button.backdrop:Point("TOPLEFT", skada.button, -E.Border, win.db.reversegrowth and 0 or E.Border)
				skada.button.backdrop:Point("BOTTOMRIGHT", skada.button, E.Border, win.db.reversegrowth and -E.Border or E.Border)
			end
		end

		local bgrame = skada.bgframe
		if Skada.revisited and not bgrame then
			skada:SetBackdrop(nil) -- remove default backdrop

			if not skada.backdrop then
				skada:CreateBackdrop(E.db.addOnSkins.skadaTemplate, E.db.addOnSkins.skadaTemplate == "Default" and E.db.addOnSkins.skadaTemplateGloss or false)
			else
				skada.backdrop:SetTemplate(E.db.addOnSkins.skadaTemplate, E.db.addOnSkins.skadaTemplate == "Default" and E.db.addOnSkins.skadaTemplateGloss or false)
			end
		elseif bgframe and win.db.enablebackground then
			bgrame:SetTemplate(E.db.addOnSkins.skadaTemplate, E.db.addOnSkins.skadaTemplate == "Default" and E.db.addOnSkins.skadaTemplateGloss or false)

			if bgrame then
				bgrame:ClearAllPoints()
				if win.db.reversegrowth then
					bgrame:SetPoint("LEFT", skada.button, "LEFT", -E.Border, 0)
					bgrame:SetPoint("RIGHT", skada.button, "RIGHT", E.Border, 0)
					bgrame:SetPoint("BOTTOM", skada.button, "TOP", 0, win.db.enabletitle and E.Spacing or -win.db.barheight - E.Border)
				else
					bgrame:SetPoint("LEFT", skada.button, "LEFT", -E.Border, 0)
					bgrame:SetPoint("RIGHT", skada.button, "RIGHT", E.Border, 0)
					bgrame:SetPoint("TOP", skada.button, "BOTTOM", 0, win.db.enabletitle and -E.Spacing or win.db.barheight + E.Border)
				end
			end
		end
	end

	if Skada.displays.bar then
		hooksecurefunc(Skada.displays.bar, "ApplySettings", ApplySettings)
	end
	if Skada.displays.legacy then
		hooksecurefunc(Skada.displays.legacy, "ApplySettings", ApplySettings)
	end

	local EMB = E:GetModule("EmbedSystem")
	hooksecurefunc(Skada, "CreateWindow", function()
		if EMB:CheckEmbed("Skada") then
			EMB:EmbedSkada()
		end
	end)

	hooksecurefunc(Skada, "DeleteWindow", function()
		if EMB:CheckEmbed("Skada") then
			EMB:EmbedSkada()
		end
	end)

	if Skada.revisited then
		hooksecurefunc(Skada, "UpdateDisplay", function()
			if EMB:CheckEmbed("Skada") then
				EMB:EmbedSkada()
			end
		end)
	end

	hooksecurefunc(Skada, "SetTooltipPosition", function(self, tt, frame)
		local profile = self.data and self.db or self.db.profile
		if profile.tooltippos == "default" then
			if not E:HasMoverBeenMoved("ElvTooltipMover") then
				if ElvUI_ContainerFrame and ElvUI_ContainerFrame:IsShown() then
					tt:Point("BOTTOMRIGHT", ElvUI_ContainerFrame, "TOPRIGHT", 0, 18)
				elseif RightChatPanel:IsShown() and RightChatPanel:GetAlpha() == 1 then
					tt:Point("BOTTOMRIGHT", RightChatPanel, "TOPRIGHT", 0, 18)
				else
					tt:Point("BOTTOMRIGHT", RightChatPanel, "BOTTOMRIGHT", 0, 18)
				end
			else
				local point = E:GetScreenQuadrant(ElvTooltipMover)

				if point == "TOPLEFT" then
					tt:SetPoint("TOPLEFT", ElvTooltipMover)
				elseif point == "TOPRIGHT" then
					tt:SetPoint("TOPRIGHT", ElvTooltipMover)
				elseif point == "BOTTOMLEFT" or point == "LEFT" then
					tt:SetPoint("BOTTOMLEFT", ElvTooltipMover)
				else
					tt:SetPoint("BOTTOMRIGHT", ElvTooltipMover)
				end
			end
		end
	end)
end)