Gui = newclass("Gui")

function Gui:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Gui.class:init") end
	---PERTTYFUNCTION---
	self.GuiPosition = aPosition or Coordinate2D()
	self.parent = aParent or nil
	self.SecondaryColor = aSecondaryColor or GlobalConstants.GUI_SECONDARY_COLOR
	self.PrimaryColor = aPrimaryColor or GlobalConstants.GUI_PRIMARY_COLOR
	self.ID = string.random(10)
end

function Gui:getPosition()
	return self.GuiPosition
end