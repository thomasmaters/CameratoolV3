Properties = newclass("Properties")
--Maybe make the properties so that it has slots and every slot can fit a guiElement.
function Properties:init(aInterfaceArea)
	self.propertieInstance = nil
	self.propertieUI = {}
	
	self.GuiElement = aInterfaceArea or nil
	
	GlobalInterface:addGuiElementToRenderStack(self)
end

function Properties:addInterfaceElement(aGuiElement)
	self.GuiElement = aGuiElement
end

function Properties:draw()
	if self.propertieInstance == nil then return end
	if self.propertieUI == nil then return end
end

function Properties:clear()
	self.propertieInstance = nil
end

function Properties:addCoordinate3Dbox(aElement, aRow)
	local coordinate = aElement.get()
	local inputboxSize = self.GuiElement.Size / 4
	InputBox(Coordinate2D(0,0), 				Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.x), nil, nil, GlobalEnums.InputBoxTypes.number)
	InputBox(Coordinate2D(inputboxSize,0), 		Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.y), nil, nil, GlobalEnums.InputBoxTypes.number)
	InputBox(Coordinate2D(inputboxSize * 2,0), 	Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.z), nil, nil, GlobalEnums.InputBoxTypes.number)
end

function Properties:addCoordinate2Dbox(aElement, aRow)
	local coordinate = aElement.get()
	local inputboxSize = self.GuiElement.Size.x / 3
	InputBox(Coordinate2D(0,0), 	Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.x), nil, nil, GlobalEnums.InputBoxTypes.number)
	InputBox(Coordinate2D(self.GuiElement.Size.x / 2,0), Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.y), nil, nil, GlobalEnums.InputBoxTypes.number)
end

--2d table with every element having a 'set', 'get' element.
function Properties:addProperty(aPropertyElement)
	outputChatBox("setting properties")
	self:clear()
	self.propertieInstance = aPropertyElement
	
	for k,v in ipairs(self.propertieInstance) do
		local element = v.get()
		if Coordinate3D:made(element) then 
			self:addCoordinate3Dbox(v, #self.propertieUI)
		end
		if Coordinate2D:made(element) then 
			self:addCoordinate2Dbox(v, #self.propertieUI)
		end
	end
end

