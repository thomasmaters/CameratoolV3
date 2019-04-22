--- @type Gui
-- @extends #UpdateHandler 
Gui = UpdateHandler:subclass("Gui")
Gui:virtual("getValue")
Gui:virtual("setValue")

function Gui:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Gui.class:init") end
	---PERTTYFUNCTION---
  self.super:init()

	---@field [parent=#Gui] #Coordinate2D GuiPosition Position of the gui element on screen.
	self.GuiPosition = Coordinate2D(aPosition)
	---@field [parent=#Gui] #Gui parent Relative parent of the gui element.
	self.parent = aParent or nil
	---@field [parent=#Gui] #string SecondaryColor Secondary gui color.
	self.SecondaryColor = aSecondaryColor or GlobalConstants.GUI_SECONDARY_COLOR
	---@field [parent=#Gui] #string PrimaryColor Primary gui color.
	self.PrimaryColor = aPrimaryColor or GlobalConstants.GUI_PRIMARY_COLOR
	---@field [parent=#Gui] #string ID GuiID
	self.ID = string.random(10)
end

function Gui:getPosition()
	return self.GuiPosition
end

function Gui:destructor()
  self:clearUpdateHandlers()
end