local E, L, V, P, G, _ = unpack(ElvUI);
local addon = E:GetModule("AddOnSkins");

if(not addon:CheckAddOn("BugSack")) then return; end

function addon:BugSack()
	local S = E:GetModule("Skins");
	local function BugSack_OpenSack()
		if(BugSackFrame.isSkinned) then return; end
		BugSackFrame:StripTextures();
		BugSackFrame:SetTemplate("Transparent");
		
		for _, child in pairs({BugSackFrame:GetChildren()}) do
			if(child:IsObjectType("Button") and child:GetScript("OnClick") == BugSack.CloseSack) then
				S:HandleCloseButton(child);
			end
		end
		
		S:HandleButton(BugSackNextButton);
		S:HandleButton(BugSackPrevButton);
		if(BugSack.Serialize) then
			S:HandleButton(BugSackSendButton);
			BugSackSendButton:SetPoint("LEFT", BugSackPrevButton, "RIGHT", E.PixelMode and 1 or 3, 0);
			BugSackSendButton:SetPoint("RIGHT", BugSackNextButton, "LEFT", -(E.PixelMode and 1 or 3), 0);
		end
		
		S:HandleScrollBar(BugSackFrameScrollScrollBar);
		S:HandleTab(BugSackTabAll);
		BugSackTabAll:SetPoint("TOPLEFT", BugSackFrame, "BOTTOMLEFT", 0, 2);
		S:HandleTab(BugSackTabSession);
		S:HandleTab(BugSackTabLast);
		
		BugSackFrame.isSkinned = true;
	end
	hooksecurefunc(BugSack, "OpenSack", BugSack_OpenStack);
end

addon:RegisterSkin("BugSack", addon.BugSack);