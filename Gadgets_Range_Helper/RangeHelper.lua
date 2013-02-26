
local toc, data = ...
local AddonId = toc.identifier

local playerFrame = WT.UnitFrame:Create("player")
local rangeHelperIndicators = {}
local haveTarget
local checkInterval = 10.0
local showBackstab = false
local showMelee = false
local showRange20 = false
local showRangeMax = false

-- rogue = A11C9B8E483EA5935 (swift shot) cleric = A034EC5ED761024EA (bolt of judgment) warrior = AFE1EF91321CEFDE0 (shock pulse) mage = A5EAE269BB440BDE8 (fireball)
local maxRangeAbilityId = nil

local function OnNameChange(rangeHelperIndicator, name)
	if not name then
		checkInterval = 10.0
		haveTarget = false
		if (showBackstab) then
			rangeHelperIndicator.imgBackstabGood:SetVisible(false)
			rangeHelperIndicator.imgBackstabBad:SetVisible(false)
		end
		if (showMelee) then
			rangeHelperIndicator.imgMeleeGood:SetVisible(false)
			rangeHelperIndicator.imgMeleeBad:SetVisible(false)
		end
		if (showRange20) then
			rangeHelperIndicator.imgRange20Good:SetVisible(false)
			rangeHelperIndicator.imgRange20Bad:SetVisible(false)
		end
		if (showRangeMax) then
			rangeHelperIndicator.imgRangeMaxGood:SetVisible(false)
			rangeHelperIndicator.imgRangeMaxBad:SetVisible(false)
		end
		rangeHelperIndicator.background:SetVisible(false)
	else
		checkInterval = 0.3
		haveTarget = true
		rangeHelperIndicator.background:SetVisible(true)
		if (showBackstab) then
			rangeHelperIndicator.imgBackstabGood:SetVisible(false)
		rangeHelperIndicator.imgBackstabBad:SetVisible(true)
		end
		if (showMelee) then
			rangeHelperIndicator.imgMeleeGood:SetVisible(false)
			rangeHelperIndicator.imgMeleeBad:SetVisible(true)
		end
		if (showRange20) then
			rangeHelperIndicator.imgRange20Good:SetVisible(false)
			rangeHelperIndicator.imgRange20Bad:SetVisible(true)
		end
		if (showRangeMax) then
			rangeHelperIndicator.imgRangeMaxGood:SetVisible(false)
			rangeHelperIndicator.imgRangeMaxBad:SetVisible(true)
		end
	end
end

local function Create(configuration)

	local ctrlHeight = 64
	local orbCount = 0

	local ctrl = WT.UnitFrame:Create("player.target")

	local ctrlBackground = UI.CreateFrame("Frame", "ctrlBackground", ctrl)
	ctrlBackground:SetAllPoints(ctrl)
	ctrlBackground:SetBackgroundColor(0,0,0,0.0)

	ctrl.background = ctrlBackground
	
	showBackstab = configuration.showBackstab
	showMelee = configuration.showMelee
	showRange20 = configuration.showRange20
	showRangeMax = configuration.showRangeMax
	
	if (showBackstab) then
		local imgBackstabBad = ctrl:CreateElement(
		{
			id="imgBackstabBad", type="Image", parent="frame", layer=0, alpha=1.0,
			attach = {
				{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT" },
			},
			texAddon=AddonId, texFile="img/RedBackstab.png",
			backgroundColor={r=0, g=0, b=0, a=0.4}
		});
		imgBackstabBad:SetVisible(false)

		local imgBackstabGood = ctrl:CreateElement(
		{
			id="imgBackstabGood", type="Image", parent="frame", layer=0, alpha=1.0,
			attach = {
				{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT" },
			},
			texAddon=AddonId, texFile="img/GreenBackstab.png",
			backgroundColor={r=0, g=0, b=0, a=0.4}
		});
		imgBackstabGood:SetVisible(false)
		ctrl.imgBackstabGood = imgBackstabGood
		ctrl.imgBackstabBad = imgBackstabBad
		orbCount = orbCount + 1
	end
		
	if (showMelee) then
		local imgMeleeBad = ctrl:CreateElement(
		{
			id="imgMeleeBad", type="Image", parent="frame", layer=0, alpha=1.0,
			attach = {
				{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=(orbCount*68), offsetY=0 },
			},
			texAddon=AddonId, texFile="img/RedMelee.png",
			backgroundColor={r=0, g=0, b=0, a=0.4}
		});
		imgMeleeBad:SetVisible(false)

		local imgMeleeGood = ctrl:CreateElement(
		{
			id="imgMeleeGood", type="Image", parent="frame", layer=0, alpha=1.0,
			attach = {
				{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=(orbCount*68), offsetY=0 },
			},
			texAddon=AddonId, texFile="img/GreenMelee.png",
			backgroundColor={r=0, g=0, b=0, a=0.4}
		});
		imgMeleeGood:SetVisible(false)
		ctrl.imgMeleeGood = imgMeleeGood
		ctrl.imgMeleeBad = imgMeleeBad	
		orbCount = orbCount + 1
	end

	if (showRange20) then
		local imgRange20Bad = ctrl:CreateElement(
		{
			id="imgRange20Bad", type="Image", parent="frame", layer=0, alpha=1.0,
			attach = {
				{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=(orbCount*68), offsetY=0 },
			},
			texAddon=AddonId, texFile="img/RedRange20.png",
			backgroundColor={r=0, g=0, b=0, a=0.4}
		});
		imgRange20Bad:SetVisible(false)

		local imgRange20Good = ctrl:CreateElement(
		{
			id="imgRange20Good", type="Image", parent="frame", layer=0, alpha=1.0,
			attach = {
				{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=(orbCount*68), offsetY=0 },
			},
			texAddon=AddonId, texFile="img/GreenRange20.png",
			backgroundColor={r=0, g=0, b=0, a=0.4}
		});
		imgRange20Good:SetVisible(false)
		ctrl.imgRange20Good = imgRange20Good
		ctrl.imgRange20Bad = imgRange20Bad
		orbCount = orbCount + 1
	end

	if (showRangeMax) then
		local imgRangeMaxBad = ctrl:CreateElement(
		{
			id="imgRangeMaxBad", type="Image", parent="frame", layer=0, alpha=1.0,
			attach = {
				{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=(orbCount*68), offsetY=0 },
			},
			texAddon=AddonId, texFile="img/RedRangeMax.png",
			backgroundColor={r=0, g=0, b=0, a=0.4}
		});
		imgRangeMaxBad:SetVisible(false)

		local imgRangeMaxGood = ctrl:CreateElement(
		{
			id="imgRangeMaxGood", type="Image", parent="frame", layer=0, alpha=1.0,
			attach = {
				{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=(orbCount*68), offsetY=0 },
			},
			texAddon=AddonId, texFile="img/GreenRangeMax.png",
			backgroundColor={r=0, g=0, b=0, a=0.4}
		});
		imgRangeMaxGood:SetVisible(false)
		ctrl.imgRangeMaxGood = imgRangeMaxGood
		ctrl.imgRangeMaxBad = imgRangeMaxBad
		orbCount = orbCount + 1
	end
	
	ctrl:SetWidth(math.max(orbCount * 66, 66))
	ctrl.hideWhenNoTarget = configuration.hideWhenNoTarget
	ctrl:SetHeight(ctrlHeight)
		
	ctrl:CreateBinding("name", ctrl, OnNameChange, nil)	
	table.insert(rangeHelperIndicators, ctrl)
			
	return ctrl
end

local function DetermineMaxRangeAbilityId()
	-- determine the ability to use for max range
	local calling = Inspect.Unit.Detail("player").calling
	
	if (calling == "rogue") then
		maxRangeAbilityId = "A11C9B8E483EA5935"
	elseif (calling == "cleric") then
		maxRangeAbilityId = "A034EC5ED761024EA"
	elseif (calling == "mage") then
		maxRangeAbilityId = "A5EAE269BB440BDE8"
	elseif (calling == "warrior") then
		maxRangeAbilityId = "AFE1EF91321CEFDE0"
	else
		print("Range Helper Error: Could not determine calling")
	end
end


local dialog = false

local function ConfigDialog(container)	
	dialog = WT.Dialog(container)
		:Label("Aids combat by showing indicators when in range and position.")
		:Checkbox("showBackstab", "Show position orb", true)
		:Checkbox("showMelee", "Show melee range orb", true)
		:Checkbox("showRange20", "Show 20 meter range orb", true)
		:Checkbox("showRangeMax", "Show max range orb", true)
end

local function GetConfiguration()
	return dialog:GetValues()
end

local function SetConfiguration(config)
	dialog:SetValues(config)
end


WT.Gadget.RegisterFactory("RangeHelper",
	{
		name="Range Helper",
		description="Combat range helper.",
		author="Zazen",
		version="1.0.0",
		iconTexAddon=AddonId,
		iconTexFile="img/RangeHelper.png",
		["Create"] = Create,
		["ConfigDialog"] = ConfigDialog,
		["GetConfiguration"] = GetConfiguration, 
		["SetConfiguration"] = SetConfiguration, 
	})

local SetBackstabImage = function (gadget)
  backstabDetail = Inspect.Ability.New.Detail("A791F862FDD91B766")
  if (backstabDetail.outOfRange) then
	  gadget.imgBackstabGood:SetVisible(false)
	  gadget.imgBackstabBad:SetVisible(true)
  else
	  gadget.imgBackstabGood:SetVisible(true)
	  gadget.imgBackstabBad:SetVisible(false)
  end
end

local SetMeleeImage = function (gadget)
	savageStrikeDetail = Inspect.Ability.New.Detail("A14CDB54E71B8D1E5")
	if (savageStrikeDetail.outOfRange) then
	  gadget.imgMeleeGood:SetVisible(false)
	  gadget.imgMeleeBad:SetVisible(true)		
	else
	  gadget.imgMeleeGood:SetVisible(true)
	  gadget.imgMeleeBad:SetVisible(false)
	end
end

local SetRange20Image = function(gadget)
	fierySpikeDetail = Inspect.Ability.New.Detail("A729E9B1CA2095153")
	if (fierySpikeDetail.outOfRange) then
	  gadget.imgRange20Good:SetVisible(false)
	  gadget.imgRange20Bad:SetVisible(true)		
	else
	  gadget.imgRange20Good:SetVisible(true)
	  gadget.imgRange20Bad:SetVisible(false)
	end
end

local SetRangeMaxImage = function(gadget)
	maxRangeAbilityDetail = Inspect.Ability.New.Detail(maxRangeAbilityId)
	if (maxRangeAbilityDetail.outOfRange) then
	  gadget.imgRangeMaxGood:SetVisible(false)
	  gadget.imgRangeMaxBad:SetVisible(true)		
	else
	  gadget.imgRangeMaxGood:SetVisible(true)
	  gadget.imgRangeMaxBad:SetVisible(false)
	end
end


local delta = 0
local function OnTick(frameDeltaTime, frameIndex)
	delta = delta + frameDeltaTime
	if (delta >= checkInterval) then
		delta = 0
		if (not maxRangeAbilityId) then
			DetermineMaxRangeAbilityId()
		end
		if (maxRangeAbilityId and haveTarget) then
			maxRangeAbilityDetail = Inspect.Ability.New.Detail(maxRangeAbilityId)
			for idx, gadget in ipairs(rangeHelperIndicators) do
				if (showBackstab) then SetBackstabImage(gadget) end
				if (showMelee) then SetMeleeImage(gadget) end
				if (showRange20) then SetRange20Image(gadget) end
				if (showRangeMax) then SetRangeMaxImage(gadget) end
			end
		end
	end
end

table.insert(WT.Event.Tick, { OnTick, AddonId, AddonId .. "_OnTick" })