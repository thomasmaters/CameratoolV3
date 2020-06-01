--- @type Button
-- @extends #Gui

--- @return #Button
Button = Gui:subclass("Button")

function Button:init(aPosition, aSize, aButtonText, aParent, aBorderSize, aPrimaryColor, aSecondaryColor, addToRenderStackFlag)
    ---PERTTYFUNCTION---
    if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Button.gui.class:init") end
    ---PERTTYFUNCTION---

    self.super:init(aPosition, aParent, aPrimaryColor or GlobalConstants.GUI_TERTIARY_COLOR, aSecondaryColor)

    --- @field [parent=#Button] #Coordinate3D Size
    self.Size = Coordinate2D(aSize)
    if aParent then
        local borderSize = ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE )
        self.super:setRelativePosition(self.super:getRelativePosition() + Coordinate2D(borderSize, borderSize))
        self.Size = self.Size - Coordinate2D(2 * borderSize, 2 * borderSize)
    end
    --- @field [parent=#Button] #Rectangle ButtonRectangle
    self.ButtonRectangle = Rectangle(Coordinate2D(), self.Size, self, aBorderSize, self.PrimaryColor, self.SecondaryColor, addToRenderStackFlag)
    --- @field [parent=#Button] #Text ButtonText
    self.ButtonText = Text(Coordinate2D(), aButtonText, self, self.Size, "default", 1.2, nil, nil, nil, nil, nil, addToRenderStackFlag)
    GlobalInterface:addButtonClickBind(self)
end

function Button:draw()
    self.ButtonRectangle:draw()
    self.ButtonText:draw()
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
    GlobalInterface:removeGuiElementFromRenderStack(self)
end
