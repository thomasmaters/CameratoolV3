---@type Slider
--@extends #Gui
Slider = Gui:subclass("Slider")

function Slider:init(aPosition, aSize, aSelectorSize, aMinimalValue, aMaximalValue, aParent, aPrimaryColor, aSecondaryColor)
    ---PERTTYFUNCTION---
    if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Slider.gui.class:init") end
    ---PERTTYFUNCTION---
    self.super:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)

    ---@field [parent=#Slider] #number MinimalValue Minimal value of the slider.
    self.MinimalValue = aMinimalValue or 0
    ---@field [parent=#Slider] #number MaximalValue Max value of the slider.
    self.MaximalValue = aMaximalValue or 100
    ---@field [parent=#Slider] #Coordinate2D Size Size of the slider.
    self.Size = aSize or Coordinate2D()
    ---@field [parent=#Slider] #Coordinate2D SelectorSize Size of the selector.
    self.SelectorSize = aSelectorSize or Coordinate2D()

    if aParent then
        local borderSize = ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE )
        self.super:setRelativePosition(self.super:getRelativePosition() + Coordinate2D(borderSize, borderSize))
        self.Size = self.Size - Coordinate2D(2 * borderSize, 2 * borderSize)
    end

    local SliderRectanglePos = Coordinate2D(0,aSize.y / 2) + Coordinate2D(0,-aSelectorSize.y / 2)
    local VisualRectanglePos = Coordinate2D(0,aSelectorSize.y / 2 - aSelectorSize.y * 0.125)
    local VisualRectangleSize= Coordinate2D(aSize.x,aSelectorSize.y*0.25)

    self.VisiualRectangle = Rectangle(VisualRectanglePos, VisualRectangleSize, self.super, 1, aPrimaryColor, aSecondaryColor)
    self.SliderRectangle = Rectangle(SliderRectanglePos, aSelectorSize, self.super, 1, aPrimaryColor, aSecondaryColor)

    GlobalInterface:addButtonClickBind(self)
end

function Slider:clicked()

    local function moveSliderSelector()
        if GlobalMouse:isMousePressed("mouse1") then
            local previousSliderValue = self:getValue()

            local MousePosition = GlobalMouse:getPosition()

            if(MousePosition.x > self.GuiPosition.x + self.SliderRectangle.Size.x/2 and MousePosition.x < self.GuiPosition.x + self.Size.x - self.SliderRectangle.Size.x/2) then
                self.SliderRectangle.GuiPosition.x = MousePosition.x - self.SliderRectangle.Size.x/2
            elseif(MousePosition.x < self.GuiPosition.x) then
                self.SliderRectangle.GuiPosition.x = self.GuiPosition.x
            elseif(MousePosition.x > self.GuiPosition.x + self.Size.x - self.SliderRectangle.Size.x) then
                self.SliderRectangle.GuiPosition.x = self.GuiPosition.x + self.Size.x - self.SliderRectangle.Size.x
            end

            local currentSliderValue = self:getValue()
            if(currentSliderValue ~= previousSliderValue)then --trigger an event when we moved the slider
                triggerEvent("onSliderDrag",getRootElement(),self.ID,currentSliderValue)
            end
        else
            removeEventHandler("onClientRender",getRootElement(), moveSliderSelector)
        end
    end
    addEventHandler("onClientRender",getRootElement(), moveSliderSelector)
end

function Slider:getValue()
    local totalSliderPixelSize = self.Size.x - self.SliderRectangle.Size.x
    local totalValueSpan = math.abs(self.MaximalValue - self.MinimalValue)
    local relativeSliderPosition = self.SliderRectangle.GuiPosition.x - self.GuiPosition.x
    return totalValueSpan / totalSliderPixelSize * relativeSliderPosition
end

function Slider:increaseSliderMaximalValue(aIncreaseValue)
    self.MaximalValue = self.MaximalValue + aIncreaseValue
    triggerEvent("onSliderDrag",getRootElement(),self.ID,self:getValue())
end

function Slider:getPosition()
    return self.super:getPosition()
end

function Slider:setPosition(aNewPosition)
    local SliderRectanglePos = aNewPosition + Coordinate2D(0,self.Size.y / 2) + Coordinate2D(0,-self.SelectorSize.y / 2)
    local VisualRectanglePos = aNewPosition + Coordinate2D(0,self.SelectorSize.y / 2 - self.SelectorSize.y * 0.125 - 2.5)

    self.super.GuiPosition = aNewPosition
    self.VisiualRectangle:setPosition(VisualRectanglePos)
    self.SliderRectangle:setPosition(SliderRectanglePos)
end

function Slider:destructor()
    self.super:destructor()
    self.VisiualRectangle:destructor()
    self.SliderRectangle:destructor()
    GlobalInterface:removeInterfaceElement(self)
end
