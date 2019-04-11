---@type Rectangle
--@extends #Gui 
Rectangle = Gui:subclass("Rectangle")

function Rectangle:init(aPosition, aSize, aParent, aBorderSize, aPrimaryColor, aSecondaryColor, addToRenderStackFlag)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Rectangle.Gui.class:init") end
	---PERTTYFUNCTION---
	if not aPosition then aPosition = Coordinate2D() end
	
	if aParent then
		aPosition = aPosition + aParent:getPosition() + Coordinate2D(2 * ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE ),2 * ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE ))		
		aSize = aSize - Coordinate2D(4 * (aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE ),4 * ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE ))
	end
	
	self.Size = aSize or Coordinate2D()
	self.RectangleBorderSize = aBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE
	
	self.super:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)
	if addToRenderStackFlag == nil or addToRenderStackFlag == true then
		GlobalInterface:addGuiElementToRenderStack(self)
	end
end

function Rectangle:draw()
	dxDrawRectangle(
		self.super.GuiPosition.x,
		self.super.GuiPosition.y,
		self.Size.x,
		self.Size.y,
		tocolor(getColorFromString(self.super.PrimaryColor)),
		false
	)
	if self.RectangleBorderSize and self.RectangleBorderSize ~= 0 then
		dxDrawLine(	self.super.GuiPosition.x,
				self.super.GuiPosition.y,
				self.super.GuiPosition.x,
				self.super.GuiPosition.y + self.Size.y,
				tocolor(getColorFromString(self.super.SecondaryColor)),
				self.RectangleBorderSize)
		dxDrawLine(	self.super.GuiPosition.x,
				self.super.GuiPosition.y,
				self.super.GuiPosition.x + self.Size.x,
				self.super.GuiPosition.y,
				tocolor(getColorFromString(self.super.SecondaryColor)),
				self.RectangleBorderSize)
		dxDrawLine(	self.super.GuiPosition.x  + self.Size.x,
				self.super.GuiPosition.y,
				self.super.GuiPosition.x + self.Size.x,
				self.super.GuiPosition.y + self.Size.y,
				tocolor(getColorFromString(self.super.SecondaryColor)),
				self.RectangleBorderSize)
		dxDrawLine(	self.super.GuiPosition.x,
				self.super.GuiPosition.y + self.Size.y,
				self.super.GuiPosition.x + self.Size.x,
				self.super.GuiPosition.y + self.Size.y,
				tocolor(getColorFromString(self.super.SecondaryColor)),
				self.RectangleBorderSize)
		--[[dxDrawRectangle(
			self.super.GuiPosition.x + self.RectangleBorderSize,
			self.super.GuiPosition.y + self.RectangleBorderSize,
			self.Size.x - 2*self.RectangleBorderSize,
			self.Size.y - 2*self.RectangleBorderSize,
			tocolor(getColorFromString(self.super.SecondaryColor)),
			false
		)]]
	end
end

function Rectangle:setPosition(aNewPosition)
	self.super.GuiPosition = aNewPosition
end

function Rectangle:getPosition()
	return self.super.GuiPosition
end