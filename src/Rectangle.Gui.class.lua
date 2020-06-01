---@type Rectangle
--@extends #Gui
Rectangle = Gui:subclass("Rectangle")

function Rectangle:init(aPosition, aSize, aParent, aBorderSize, aPrimaryColor, aSecondaryColor, addToRenderStackFlag)
    ---PERTTYFUNCTION---
    if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Rectangle.Gui.class:init") end
    ---PERTTYFUNCTION---
    self.super:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)

    ---@field [parent=#Rectangle] #Coordinate2D Size Size of the rectangle.
    self.Size = aSize or Coordinate2D()
    ---@field [parent=#Rectangle] #number RectangleBorderSize Border size of the rectangle.
    self.RectangleBorderSize = aBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE

    if aParent then
        local borderSize = ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE )
        self.super:setRelativePosition(self.super:getRelativePosition() + Coordinate2D(borderSize, borderSize))
        self.Size = self.Size - Coordinate2D(2 * borderSize, 2 * borderSize)
    end

    if addToRenderStackFlag == nil or addToRenderStackFlag == true then
        GlobalInterface:addGuiElementToRenderStack(self)
    end
end

function Rectangle:draw()
    dxDrawRectangle(
        self.GuiPosition.x,
        self.GuiPosition.y,
        self.Size.x,
        self.Size.y,
        tocolor(getColorFromString(self.PrimaryColor)),
        false
    )
    if self.RectangleBorderSize and self.RectangleBorderSize ~= 0 then
        dxDrawLine(	self.super.GuiPosition.x,
            self.GuiPosition.y,
            self.GuiPosition.x,
            self.GuiPosition.y + self.Size.y,
            tocolor(getColorFromString(self.SecondaryColor)),
            self.RectangleBorderSize)
        dxDrawLine(	self.super.GuiPosition.x,
            self.GuiPosition.y,
            self.GuiPosition.x + self.Size.x,
            self.GuiPosition.y,
            tocolor(getColorFromString(self.SecondaryColor)),
            self.RectangleBorderSize)
        dxDrawLine(	self.super.GuiPosition.x  + self.Size.x,
            self.GuiPosition.y,
            self.GuiPosition.x + self.Size.x,
            self.GuiPosition.y + self.Size.y,
            tocolor(getColorFromString(self.SecondaryColor)),
            self.RectangleBorderSize)
        dxDrawLine(	self.super.GuiPosition.x,
            self.GuiPosition.y + self.Size.y,
            self.GuiPosition.x + self.Size.x,
            self.GuiPosition.y + self.Size.y,
            tocolor(getColorFromString(self.SecondaryColor)),
            self.RectangleBorderSize)
    end
end

function Rectangle:destructor()
    GlobalInterface:removeGuiElementFromRenderStack(self)
end
