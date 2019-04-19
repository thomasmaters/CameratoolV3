--- @type Button
-- @extends #Gui

--- @return #Button 
Button = Gui:subclass("Button")

function Button:init(aPosition, aSize, aButtonText, aParent, aBorderSize, aPrimaryColor, aSecondaryColor, aOnClickHandleFunction)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Button.gui.class:init") end
	---PERTTYFUNCTION---

	if aParent then
		aPosition.x = aParent.super.GuiPosition.x + aPosition.x + 2 * ( aParent.RectangleBorderSize or Constants.RECTANGLE_BORDER_SIZE )
		aPosition.y = aParent.super.GuiPosition.y + aPosition.y + 2 * ( aParent.RectangleBorderSize or Constants.RECTANGLE_BORDER_SIZE )
		aSize.x = aSize.x - 4 * ( aParent.RectangleBorderSize or Constants.RECTANGLE_BORDER_SIZE )
		aSize.y = aSize.y - 4 * ( aParent.RectangleBorderSize or Constants.RECTANGLE_BORDER_SIZE )
	end
	
	--- @field [parent=#Button] #Coordinate3D Size
	self.Size = aSize or Coordinate2D()
	--- @field [parent=#Button] #function ClickHandleFunction
	self.ClickHandleFunction = aOnClickHandleFunction or nil

  --- @field [parent=#Button] #Rectangle ButtonRectangle
	self.ButtonRectangle = Rectangle(aPosition, aSize, nil, aBorderSize, aPrimaryColor, aSecondaryColor)
	--- @field [parent=#Button] #Text ButtonText
	self.ButtonText = Text(aPosition, aButtonText, nil, aSize, "default", 1.2)
	
	self.super:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)
	
	GlobalInterface:addButtonClickBind(self)
end

--- @function [parent=#Button] hover
function Button:hover()
	
end

--- @function [parent=#Button] clicked
function Button:clicked()
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Button.gui.class:clicked") end
	---PERTTYFUNCTION---
	
	if not self.ClickHandleFunction then return end
	if(type(self.ClickHandleFunction) == "function") then
		self.ClickHandleFunction(self)
	end
end

--- @function [parent=#Button] setPosition
--@param #Coordinate2D aNewPosition 
function Button:setPosition(aNewPosition)
	self.super.GuiPosition = aNewPosition
	self.ButtonRectangle:setPosition(aNewPosition)
	self.ButtonText:setPosition(aNewPosition)
end

--- @function [parent=#Button] setValue
--@param #string aValue 
function Button:setValue(aValue)
	self.ButtonText:setValue(aValue)
end

function Button:getPosition()
	return self.super.GuiPosition
end

function Button:destructor()
  self.ButtonRectangle:destructor()
  self.ButtonText:destructor()
  GlobalInterface:removeInterfaceElement(self)
end