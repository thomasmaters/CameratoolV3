---@type Slider
--@extends #Gui 
Slider = Gui:subclass("Slider")

function Slider:init(aPosition, aSize, aSelectorSize, aMinimalValue, aMaximalValue, aParent, aPrimaryColor, aSecondaryColor)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Slider.gui.class:init") end
	---PERTTYFUNCTION---

	if aParent then
		aPosition.x = aParent.super.GuiPosition.x + aPosition.x + 2 * ( aParent.RectangleBorderSize or Constants.RECTANGLE_BORDER_SIZE )
		aPosition.y = aParent.super.GuiPosition.y + aPosition.y + 2 * ( aParent.RectangleBorderSize or Constants.RECTANGLE_BORDER_SIZE )
		aSize.x = aSize.x - 4 * ( aParent.RectangleBorderSize or Constants.RECTANGLE_BORDER_SIZE )
		aSize.y = aSize.y - 4 * ( aParent.RectangleBorderSize or Constants.RECTANGLE_BORDER_SIZE )
	end
	
	local SliderRectanglePos = aPosition + Coordinate2D(0,aSize.y / 2) + Coordinate2D(0,-aSelectorSize.y / 2)
	local VisualRectanglePos = aPosition + Coordinate2D(0,aSelectorSize.y / 2 - aSelectorSize.y * 0.125 - 2.5)
	local VisualRectangleSize= Coordinate2D(aSize.x,aSelectorSize.y*0.25)
	
	self.SelectableRectangle = Rectangle(aPosition, aSize, nil, 1, "#FFFFFF00", "#FFFFFF00",false)
	self.VisiualRectangle = Rectangle(VisualRectanglePos, VisualRectangleSize, nil, 1, aPrimaryColor, aSecondaryColor,false)
	self.SliderRectangle = Rectangle(SliderRectanglePos, aSelectorSize, nil, 1, aPrimaryColor, aSecondaryColor,false)
	
	self.MinimalValue = aMinimalValue or 0
	self.MaximalValue = aMaximalValue or 100
	self.Size = aSize or Coordinate2D()
	self.SelectorSize = aSelectorSize or Coordinate2D()
	self.super:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)
	
	GlobalInterface:addGuiElementToRenderStack(self)
	GlobalInterface:addButtonClickBind(self)
end

function Slider:clicked()
	
	function moveSliderSelector()		
		if GlobalMouse:isMousePressed("mouse1") then
			local previousSliderValue = self:getCurrentValue()		
			
			local MousePosition = GlobalMouse:getPosition()
			
			if(MousePosition.x > self.super.GuiPosition.x + self.SliderRectangle.Size.x/2 and MousePosition.x < self.super.GuiPosition.x + self.Size.x - self.SliderRectangle.Size.x/2) then
				self.SliderRectangle.super.GuiPosition.x = MousePosition.x - self.SliderRectangle.Size.x/2			
			elseif(MousePosition.x < self.GuiPosition.x) then
				self.SliderRectangle.super.GuiPosition.x = self.super.GuiPosition.x
			elseif(MousePosition.x > self.super.GuiPosition.x + self.Size.x - self.SliderRectangle.Size.x) then
				self.SliderRectangle.super.GuiPosition.x = self.super.GuiPosition.x + self.Size.x - self.SliderRectangle.Size.x
			end
			
			local currentSliderValue = self:getCurrentValue()
			if(currentSliderValue ~= previousSliderValue)then --trigger an event when we moved the slider
				triggerEvent("onSliderDrag",getRootElement(),self.ID,currentSliderValue)
			end
		else
			removeEventHandler("onClientRender",getRootElement(), moveSliderSelector)
		end
	end
	addEventHandler("onClientRender",getRootElement(), moveSliderSelector)
end

function Slider:getCurrentValue()
	local totalSliderPixelSize = self.Size.x - self.SliderRectangle.Size.x
	local totalValueSpan = math.abs(self.MaximalValue - self.MinimalValue)
	local relativeSliderPosition = self.SliderRectangle.super.GuiPosition.x - self.super.GuiPosition.x
	return totalValueSpan / totalSliderPixelSize * relativeSliderPosition
end

function Slider:increaseSliderMaximalValue(aIncreaseValue)
	self.MaximalValue = self.MaximalValue + aIncreaseValue
	triggerEvent("onSliderDrag",getRootElement(),self.ID,self:getCurrentValue())
end

function Slider:draw()
	self.SelectableRectangle:draw()
	self.VisiualRectangle:draw()
	self.SliderRectangle:draw()
end

function Slider:getPosition()
	return self.super.GuiPosition
end

function Slider:setPosition(aNewPosition)
	local SliderRectanglePos = aNewPosition + Coordinate2D(0,self.Size.y / 2) + Coordinate2D(0,-self.SelectorSize.y / 2)
	local VisualRectanglePos = aNewPosition + Coordinate2D(0,self.SelectorSize.y / 2 - self.SelectorSize.y * 0.125 - 2.5)
	
	self.super.GuiPosition = aNewPosition
	self.SelectableRectangle:setPosition(aNewPosition)
	self.VisiualRectangle:setPosition(VisualRectanglePos)
	self.SliderRectangle:setPosition(SliderRectanglePos)
end