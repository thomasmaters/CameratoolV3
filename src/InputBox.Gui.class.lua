---@type InputBox
--@extends #Gui 
InputBox = Gui:subclass("InputBox")

function InputBox:init(aPosition, aSize, aParent, aDefaultText, aPrimaryColor, aSecondaryColor, aInputType, addToRenderStackFlag)
  ---PERTTYFUNCTION---
  if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("InputBox.Gui.class:init") end
  ---PERTTYFUNCTION---
  if not aPosition then aPosition = Coordinate2D() end
    
  self.super:init(aPosition, aParent, aPrimaryColor, aSecondaryColor)
  
  ---@field [parent=#InputBox] #Cooridinate2D Size Size of the inputbox.
  self.Size = aSize or Coordinate2D()
  ---@field [parent=#InputBox] #string DefaultText Text to show when not selected and the current text has no value.
  self.DefaultText = aDefaultText or "Unknown"
  ---@field [parent=#InputBox] #string CurrentText Texttual value of the inputbox.
  self.CurrentText = ""
  ---@field [parent=#InputBox] #number CharacterLimit Amount of characters this input box will accept.
  self.CharacterLimit = 10
  ---@field [parent=#InputBox] #Enums InputType Type of inputbox.
  self.InputType = aInputType or GlobalEnums.InputBoxTypes.signedNumber
  
  self.LastTickBackspace = 0
  self.CursorPosition = 0
  self.bCursorShowing = false
  self.LastCursorTick = 0
  
  ---@field [parent=#InputBox] #boolean bFocus Boolean that indicates if the inputbox is selected.
  self.bFocus = false
  ---@field [parent=#InputBox] #boolean bShowDefault Boolean indicating if the default text has to be shown.
  self.bShowDefault = false
  
  if aParent then
    local borderSize = ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE )
    self.super:setRelativePosition(self.super:getRelativePosition() + Coordinate2D(borderSize, borderSize))
    self.Size = self.Size - Coordinate2D(2 * borderSize, 2 * borderSize)
  end
  
  ---@field [parent=#InputBox] #Button ClickableArea Button thats enables input on the inputbox.
  self.ClickableAera = Button(Coordinate2D(), self.Size, self.CurrentText, self.super, 0, GlobalConstants.CAM_TARGET_PATH_COLOR, aSecondaryColor, addToRenderStackFlag)
  self.ClickableAera:addUpdateHandler(function() self:setFocus() end)
  
  ---@field [parent=#InputBox] #Text InputText Visualizer for the inputted text.
  self.InputText = Text(Coordinate2D(), self.DefaultText, self.super, self.Size, "default", 1.4, "left", nil, nil, nil, nil,addToRenderStackFlag)
  
  addEvent("mouseReleased", true)
  addEventHandler("mouseReleased", getRootElement(), bind(self.removeFocus,self))
  addEventHandler("onClientKey", getRootElement(), function(button, state) self:handleSpecialKey(button,state) end)
  addEventHandler("onClientCharacter", getRootElement(), function(...) self:handleChar(...) end)
  
  if(addToRenderStackFlag == nil or addToRenderStackFlag == true) then
    GlobalInterface:addGuiElementToRenderStack(self)
  end
end

function InputBox:getValue()
  if(self.InputType == GlobalEnums.InputBoxTypes.number or self.InputType == GlobalEnums.InputBoxTypes.signedNumber) then
    return tonumber(self.CurrentText)
  end
	return self.CurrentText or ""
end

function InputBox:setValue(aValue, bCascadeUpdate)
  self.InputText:setValue(tostring(aValue or self.CurrentText))
  if self:validateType(aValue) then
    self.CurrentText = tostring(aValue)
  end
  if(bCascadeUpdate == nil or bCascadeUpdate) then
    self:callUpdateHandlers()
  end
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
  self.ClickableAera:draw()
  self.InputText:draw()
	if self.bFocus then
	  self:drawCursor()
    local backspaceKeyState = getKeyState("backspace")
    
		if string.len(self.CurrentText) > 0 and backspaceKeyState and self.LastTickBackspace == 0 then
			self.LastTickBackspace = getTickCount() + 500
		elseif string.len(self.CurrentText) > 0 and backspaceKeyState and self.LastTickBackspace - getTickCount() <= 0 then
			if getKeyState("lctrl") then
				self.CurrentText = ""
				self:setValue()
			else
				self:removeCharacter()
			end
		elseif self.LastTickBackspace ~= 0 and not backspaceKeyState then
			self.LastTickBackspace = 0
		end
	end
end

function InputBox:drawCursor()
  if(self.bCursorShowing) then
    local cutText = string.sub(self.CurrentText, 1, self.CursorPosition)
    local textWidth = self.InputText:getTextWidth(cutText)
    dxDrawLine(self.InputText.GuiPosition.x + textWidth,
      self.InputText.GuiPosition.y,
      self.InputText.GuiPosition.x + textWidth,
      self.InputText.GuiPosition.y + self.InputText.Size.y)
  end
  if(getTickCount() > self.LastCursorTick) then
    self.LastCursorTick = getTickCount() + 500
    self.bCursorShowing = not self.bCursorShowing
  end
end

function InputBox:removeCharacter()
	self.CurrentText = self.CurrentText:sub(1, self.CursorPosition - 1).. self.CurrentText:sub(self.CursorPosition + 1, self.CurrentText:len())
	self.CursorPosition = self.CursorPosition - 1
	self:setValue()
end

function InputBox:handleChar(character)
	if self.bFocus and string.len(self.CurrentText) < self.CharacterLimit then
		local newCurrentText = self.CurrentText:sub(1,self.CursorPosition) ..character.. self.CurrentText:sub(self.CursorPosition + 1,self.CurrentText:len())
		if self:validateType(newCurrentText) then
			self.CurrentText = newCurrentText
			self.CursorPosition = self.CursorPosition + 1
			self:setValue()
		end
	end
end

function InputBox:validateType(newCurrentText)
  if self.InputType == GlobalEnums.InputBoxTypes.signedNumber then
  --TODO Make constants of limits.
    return (tonumber(newCurrentText) ~= nil) and tonumber(newCurrentText) <= 10000000 and tonumber(newCurrentText) >= -10000000
	elseif self.InputType == GlobalEnums.InputBoxTypes.number then
		return (tonumber(newCurrentText) ~= nil) and tonumber(newCurrentText) >= 0 and tonumber(newCurrentText) <= 10000000
	else
		return true
	end
end

function InputBox:enableDefaultText()
	if not self.bFocus and string.len(self.CurrentText) == 0 then
		self.bShowDefault = true
		self.InputText:setValue(self.DefaultText)
	end
end

function InputBox:handleSpecialKey(button, state)
	if not self.bFocus then return end
	if state then
		if button == "backspace" and string.len(self.CurrentText) > 0 then
			self:removeCharacter()
		elseif button == "backspace" and string.len(self.CurrentText) == 0 then
			self:enableDefaultText()
			self:setValue()
		elseif button == "enter" then
			self:enableDefaultText()
			self:setValue()			
		elseif button == "escape" then
			self:removeFocus()
			self:enableDefaultText()
	  elseif button == "arrow_l" and self.CursorPosition >= 1 then
      outputChatBox(tostring(self.CursorPosition))
      self.CursorPosition = self.CursorPosition - 1
    elseif button == "arrow_r" and self.CursorPosition < string.len(self.CurrentText) then
      self.CursorPosition = self.CursorPosition + 1
    end
	end
end

function InputBox:setFocus()
	outputChatBox("setfocus")
	self.CursorPosition = self.CurrentText:len()
	self.bShowDefault = false
	self.bFocus = true
	self:setCursorBasedOnClickLocation()
end

function InputBox:setCursorBasedOnClickLocation()
  local mouseToInputBoxOffset = GlobalMouse:getPosition().x - self.InputText.GuiPosition.x

  if(mouseToInputBoxOffset < self.InputText:getTextWidth()) then
    if(mouseToInputBoxOffset <= 6) then
      self.CursorPosition = 0
      return
    end
    local distance = GlobalConstants.SCREEN_WIDTH
    for stringIndex=1, self.CurrentText:len() do
      local tempString = self.CurrentText:sub(1,stringIndex)
      
      if(math.abs(mouseToInputBoxOffset - self.InputText:getTextWidth(tempString)) <= distance) then
        self.CursorPosition = stringIndex
        distance = math.abs(mouseToInputBoxOffset - self.InputText:getTextWidth(tempString))
      end
    end
  end
end

function InputBox:destructor()
  self.super:destructor()
  self.ClickableAera:destructor()
  self.InputText:destructor()
  GlobalInterface:removeInterfaceElement(self)
end