Text = Gui:subclass("Text")
TextDefault = 	{
					Text = "",
					TextScale = 1,
					Font = "default",
					TextVerticalAlign = "center",
					TextHorizontalAlign = "center",
					Clip=true
				}


function Text:init(aPosition, aText, aParent, aSize, aFont, aTextScale, aHorizontalTextAlgin, aVerticalTextAlgin, aPrimaryColor, aSecondaryColor, aTextClipping)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Text.Gui.class:init") end
	---PERTTYFUNCTION---
	if aParent then
		aPosition.x = aParent.super.GuiPosition.x + aPosition.x + 2 * ( aParent.RectangleBorderSize or Constants.RECTANGLE_BORDER_SIZE )
		aPosition.y = aParent.super.GuiPosition.y + aPosition.y + 2 * ( aParent.RectangleBorderSize or Constants.RECTANGLE_BORDER_SIZE )
		aSize.x = aSize.x - 4 * ( aParent.RectangleBorderSize or Constants.RECTANGLE_BORDER_SIZE )
		aSize.y = aSize.y - 4 * ( aParent.RectangleBorderSize or Constants.RECTANGLE_BORDER_SIZE )
	end
	
	self.Size = aSize or Coordinate2D()
	self.Text = aText or ""
	self.Font = aFont or "default"
	self.TextScale = aTextScale or 1
	self.TextVerticalAlign = aVerticalTextAlgin or "center"
	self.TextHorizontalAlign = aHorizontalTextAlgin or "center"
	self.bClipText = abClipText or true
	
	self.super:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)
	GlobalInterface:addGuiElementToRenderStack(self)
end

function Text:draw()
	dxDrawText(	self.Text,
				self.super.GuiPosition.x,
				self.super.GuiPosition.y,
				self.super.GuiPosition.x + (self.Size.x or 0),
				self.super.GuiPosition.y + (self.Size.y or dxGetFontHeight(self.TextScale,self.Font)),
				tocolor(0,0,0),
				self.TextScale,
				self.Font,
				self.TextHorizontalAlign,
				self.TextVerticalAlign,
				self.bClipText)
end

function Text:getTextWidth(aText)
	if not aText then aText = self.Text end
	return dxGetTextWidth(self.Text,self.TextScale,self.Font)
end

function Text:setText(aText)
	if aText == nil then return end 
	self.Text = aText
end

function Text:setPosition(aNewPosition)
	self.super.GuiPosition = aNewPosition
end

function Text:getPosition()
	return self.super.GuiPosition
end