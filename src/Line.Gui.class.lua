---@type Line
--@extends #Gui
Line = Gui:subclass("line")

function Line:init(aLineStartPosition, aLineEndPosition, aParent, aLineThickness, bLineHoverEnabled, bLineSelectEnabled, aPrimaryColor, aSecondaryColor, addToRenderStackFlag)
    self.LineEndPosition = aLineEndPosition or Coordinate2D()
    self.LineThickness = aLineThickness or 2
    self.bLineHoverEnabled = bLineHoverEnabled or false
    self.bLineSelectEnabled = bLineSelectEnabled or false

    self.super:init(aLineStartPosition,aParent,aPrimaryColor,aSecondaryColor)
    if(addToRenderStackFlag == nil or addToRenderStackFlag == true) then
        GlobalInterface:addGuiElementToRenderStack(self)
    end
end

function Line:draw()
    dxDrawLine(	self.super.GuiPosition.x,
        self.super.GuiPosition.y,
        self.LineEndPosition.x,
        self.LineEndPosition.y,
        self.super.primaryColor,
        self.LineThickness)
end

function Line:getPosition()
    return self.super.GuiPosition
end

function Line:destructor()
    self.super:destructor()
    GlobalInterface:removeGuiElementFromRenderStack(self)
end
