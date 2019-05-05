--- @type Gui
-- @extends #UpdateHandler 
Gui = UpdateHandler:subclass("Gui")
Gui:virtual("getValue")
Gui:virtual("setValue")

---@function [parent=#Gui] init
--@param #Coordinate2D aPosition Relative position from its parent or its absolute position if no parent.
--@param #Gui aParent Parent Gui element.
--@param #string aPrimaryColor Primary gui element color.
--@param #string aSecondaryColor Secondary gui element color.
function Gui:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Gui.class:init") end
	---PERTTYFUNCTION---
  self.super:init()

	---@field [parent=#Gui] #Coordinate2D GuiPosition Position of the gui element on screen.
	self.GuiPosition = Coordinate2D(aPosition)
	if aParent then self.GuiPosition = self.GuiPosition + aParent:getPosition() end
	---@field [parent=#Gui] #Coordinate2D RelativePosition Position relative to the parent.
	self.RelativePosition = Coordinate2D(aPosition)
	---@field [parent=#Gui] #Gui parent Relative parent of the gui element.
	self.parent = aParent or nil
	---@field [parent=#Gui] #string SecondaryColor Secondary gui color.
	self.SecondaryColor = aSecondaryColor or GlobalConstants.GUI_SECONDARY_COLOR
	---@field [parent=#Gui] #string PrimaryColor Primary gui color.
	self.PrimaryColor = aPrimaryColor or GlobalConstants.GUI_PRIMARY_COLOR
	---@field [parent=#Gui] #string ID GuiID
	self.ID = string.random(10)
end

---@function [parent=#Gui] setPosition
--@param #Coordinate2D aNewPosition New absolute position on the screen. 
function Gui:setPosition(aNewPosition)
  local coordinateDifference = self.GuiPosition - aNewPosition
  self.GuiPosition = aNewPosition
  self.RelativePosition = self.RelativePosition + coordinateDifference
end

---@function [parent=#Gui] setRelativePosition
--@param #Coordinate2D aNewPosition Sets the relative position to its parent.
function Gui:setRelativePosition(aNewPosition)
  local coordinateDifference = aNewPosition - self.RelativePosition
  self.GuiPosition = self.GuiPosition + coordinateDifference 
  self.RelativePosition = aNewPosition
end

---@function [parent=#Gui] getPosition
--Gets the absolute position on screen.
function Gui:getPosition()
	return self.GuiPosition
end

---@function [parent=#Gui] getRelativePosition
--Gets the relative position from its parent (if any).
function Gui:getRelativePosition()
  return self.RelativePosition;
end

function Gui:destructor()
  self:clearUpdateHandlers()
end