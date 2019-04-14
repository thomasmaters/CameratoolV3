---@type InputBox
--@extends #Gui 
InputBox = Gui:subclass("InputBox")

function InputBox:init(aPosition, aSize, aParent, aDefaultText, aPrimaryColor, aSecondaryColor, aInputType, aCallback)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("InputBox.Gui.class:init") end
	---PERTTYFUNCTION---
	if not aPosition then aPosition = Coordinate2D() end
		
	self.super:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)
	
	self.Size = aSize or Coordinate2D()
	self.DefaultText = aDefaultText or ""
	self.CurrentText = ""
	self.ClickableAera = Button(Coordinate2D() + aPosition, aSize,self.CurrentText, aParent, 0, aPrimaryColor, aSecondaryColor, bind(self.setFocus,self))
	self.InputText = Text(Coordinate2D() + aPosition, self.DefaultText, aParent, aSize, "default", 1.4, "left")
	self.CharacterLimit = 10
	self.InputType = aInputType or GlobalEnums.InputBoxTypes.number
	self.Callback = aCallback or nil
	
	self.LastTickBackspace = 0
	
	self.bFocus = false
	self.bShowDefault = false
	
	addEvent("mouseReleased", true)
	addEventHandler("mouseReleased", getRootElement(), bind(self.removeFocus,self))
	addEventHandler( "onClientKey", getRootElement(), function(button, state) self:handleSpecialKey(button,state) end)
	addEventHandler("onClientCharacter", getRootElement(), function(...) self:handleChar(...) end)
	
	GlobalInterface:addGuiElementToRenderStack(self)
end

function InputBox:getText()
	return self.CurrentText or ""
end

function InputBox:setText(aValue)
  self.InputText:setText(tostring(aValue)) 
end

function InputBox:removeFocus()
  if not self.bFocus then return end
  
	local mousePosition = GlobalMouse:getPosition()
	if mousePosition.x <= self.ClickableAera.GuiPosition.x or mousePosition.x >= self.ClickableAera.GuiPosition.x + self.Size.x or
		mousePosition.y <= self.ClickableAera.GuiPosition.y or mousePosition.y >= self.ClickableAera.GuiPosition.y + self.Size.y then
		self.bFocus = false
		self:enableDefaultText()
	end
end

function InputBox:draw()
	if self.bFocus then
    local backspaceKeyState = getKeyState("backspace")
    
		if string.len(self.CurrentText) > 0 and backspaceKeyState and self.LastTickBackspace == 0 then
			self.LastTickBackspace = getTickCount() + 500
		elseif string.len(self.CurrentText) > 0 and backspaceKeyState and self.LastTickBackspace - getTickCount() <= 0 then
			if getKeyState("lctrl") then
				self.CurrentText = ""
				self:updateText()
			else
				self:removeCharacter()
			end
		elseif self.LastTickBackspace ~= 0 and not backspaceKeyState then
			self.LastTickBackspace = 0
		end
	end
end

function InputBox:removeCharacter()
	self.CurrentText = string.sub(self.CurrentText, 1, -2)
	self:updateText()
end

function InputBox:updateText()
	self.InputText:setText(self.CurrentText)
	if self.Callback ~= nil then
		self.Callback(self.CurrentText)
	end
end

function InputBox:handleChar(character)
	if self.bFocus and string.len(self.CurrentText) < self.CharacterLimit then
		local newCurrentText = self.CurrentText.. "" ..character
		if self:validateType(newCurrentText) then
			self.CurrentText =  newCurrentText
			self:updateText()
		end
	end
end

function InputBox:validateType(newCurrentText)
	if self.InputType == GlobalEnums.InputBoxTypes.number then
		return (tonumber(newCurrentText) ~= nil)
	else
		return true
	end
end

function InputBox:enableDefaultText()
	if not self.bFocus and string.len(self.CurrentText) == 0 then
		self.bShowDefault = true
		self.InputText:setText(self.DefaultText)
	end
end

function InputBox:handleSpecialKey(button, state)
	if not self.bFocus then return end

	if state then
		if button == "backspace" and string.len(self.CurrentText) > 0 then
			self:removeCharacter()
		elseif button == "backspace" and string.len(self.CurrentText) == 0 then
			self:enableDefaultText()
			self:updateText()
		elseif button == "enter" then
			self:enableDefaultText()
			self:updateText()			
		elseif button == "escape" then
			self:removeFocus()
			self:enableDefaultText()
		end
	end
end

function InputBox:setFocus()
	outputChatBox("setfocus")
	self.bShowDefault = false
	self.bFocus = true
end

function InputBox:destructor()
  self.ClickableAera:destructor()
  self.InputText:destructor()
  GlobalInterface:removeInterfaceElement(self)
end