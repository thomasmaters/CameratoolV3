--- @type Button
-- @extends #Gui

--- @return #Button 
Button = Gui:subclass("Button")

function Button:init(aPosition, aSize, aButtonText, aParent, aBorderSize, aPrimaryColor, aSecondaryColor, addToRenderStackFlag)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Button.gui.class:init") end
	---PERTTYFUNCTION---
	
	self.super:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)
	
	--- @field [parent=#Button] #Coordinate3D Size
	self.Size = Coordinate2D(aSize)
  if aParent then
    outputChatBox(tostring(aParent.GuiPosition) .." ".. tostring(self.GuiPosition) .." ".. tostring(aParent.RectangleBorderSize) .." ".. tostring(GlobalConstants.RECTANGLE_BORDER_SIZE))
    self.GuiPosition.x = aParent.GuiPosition.x + self.GuiPosition.x + 2 * ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE )
    self.GuiPosition.y = aParent.GuiPosition.y + self.GuiPosition.y + 2 * ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE )
    self.Size.x = self.Size.x - 4 * ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE )
    self.Size.y = self.Size.y - 4 * ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE )
  end
  --- @field [parent=#Button] #Rectangle ButtonRectangle
	self.ButtonRectangle = Rectangle(self.GuiPosition, self.Size, nil, aBorderSize, aPrimaryColor, aSecondaryColor)
	--- @field [parent=#Button] #Text ButtonText
	self.ButtonText = Text(self.GuiPosition, aButtonText, nil, self.Size, "default", 1.2)
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
	
  self:callUpdateHandlers()
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
  self.super:destructor()
  self.ButtonRectangle:destructor()
  self.ButtonText:destructor()
  GlobalInterface:removeInterfaceElement(self)
end