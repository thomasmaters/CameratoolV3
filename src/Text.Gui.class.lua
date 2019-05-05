---@type Text
--@extends #Gui 
Text = Gui:subclass("Text")

---@function [parent=#Text] init
--@param #number aPosition description
--@param #string aText description
--@param #number aParent description
--@param #number aSize description
--@param #string aFont description
--@param #number aTextScale description
--@param #string aHorizontalTextAlgin description
--@param #string aVerticalTextAlgin description
--@param #string aPrimaryColor description
--@param #string aSecondaryColor description
--@param #boolean aTextClipping description
function Text:init(aPosition, aText, aParent, aSize, aFont, aTextScale, aHorizontalTextAlgin, aVerticalTextAlgin, aPrimaryColor, aSecondaryColor, abClipText, addToRenderStackFlag)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Text.Gui.class:init") end
	---PERTTYFUNCTION---

  self.super:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)
	 ---@field [parent=#Text] #Coordinate2D Size
  self.Size = Coordinate2D(aSize)
	---@field [parent=#Text] #string Text
	self.Text = aText or ""
	---@field [parent=#Text] #string Font
	self.Font = aFont or "default"
	---@field [parent=#Text] #number TextScale
	self.TextScale = aTextScale or 1
	---@field [parent=#Text] #string TextVerticalAlign
	self.TextVerticalAlign = aVerticalTextAlgin or "center"
	---@field [parent=#Text] #string TextHorizontalAlign
	self.TextHorizontalAlign = aHorizontalTextAlgin or "center"
	---@field [parent=#Text] #boolean bClipText
	self.bClipText = abClipText or true
	
  if aParent then
    local borderSize = ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE )
    self.super:setRelativePosition(self.super:getRelativePosition() + Coordinate2D(borderSize, borderSize))
    self.Size = self.Size - Coordinate2D(2 * borderSize, 2 * borderSize)
  end
	
	if(addToRenderStackFlag == nil or addToRenderStackFlag == true) then
	  GlobalInterface:addGuiElementToRenderStack(self)
  end
end

function Text:draw()
	dxDrawText(	self.Text,
				self.GuiPosition.x,
				self.GuiPosition.y,
				self.GuiPosition.x + (self.Size.x or 0),
				self.GuiPosition.y + (self.Size.y or dxGetFontHeight(self.TextScale,self.Font)),
				tocolor(0,0,0),
				self.TextScale,
				self.Font,
				self.TextHorizontalAlign,
				self.TextVerticalAlign,
				self.bClipText)
end

function Text:getTextWidth(aText)
	if not aText then aText = self.Text end
	return dxGetTextWidth(aText,self.TextScale,self.Font)
end

function Text:setValue(aText)
	if aText == nil then return end 
	self.Text = tostring(aText)
end

function Text:getValue()
  return self.Text or ""
end

function Text:destructor()
  self.super:destructor()
  GlobalInterface:removeInterfaceElement(self)
end