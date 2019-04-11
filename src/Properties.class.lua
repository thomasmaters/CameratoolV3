---@type Properties
Properties = newclass("Properties")
--Maybe make the properties so that it has slots and every slot can fit a guiElement.
function Properties:init(aInterfaceArea)
	self.propertieObject = nil
	
	self.GuiElement = aInterfaceArea or nil
	self.propertieUI = {}
	
	GlobalInterface:addGuiElementToRenderStack(self)
end

function Properties:addInterfaceElement(aGuiElement)
	self.GuiElement = aGuiElement
end

function Properties:addObjectToProperties(aObject)
	self.propertieObject = aObject
	self:addProperty(aObject:getProperties())
end

function Properties:draw()

end

function Properties:clear()
	for k,v in ipairs(self.propertieUI) do
		for ak,av in ipairs(v) do
			av:destroy()
			av = nil
		end
		v = nil
	end
end

function Properties:addCoordinate3Dbox(aElement, aRow)
	local coordinate = aElement.get()
	local inputboxSize = self.GuiElement.Size / 4
	
	self.propertieUI[aRow + 1] = {}
	table.insert(self.propertieUI[aRow + 1],InputBox(Coordinate2D(0,0), 				Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.x), nil, nil, GlobalEnums.InputBoxTypes.number, function(text) aElement.setX(tonumber(text)) end))
	table.insert(self.propertieUI[aRow + 1],InputBox(Coordinate2D(inputboxSize,0), 		Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.y), nil, nil, GlobalEnums.InputBoxTypes.number))
	table.insert(self.propertieUI[aRow + 1],InputBox(Coordinate2D(inputboxSize * 2,0), 	Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.z), nil, nil, GlobalEnums.InputBoxTypes.number))
end

function Properties:addCoordinate2Dbox(aElement, aRow)
	local coordinate = aElement.get()
	local inputboxSize = self.GuiElement.Size.x / 3
	
	self.propertieUI[aRow + 1] = {}
	table.insert(self.propertieUI[aRow + 1], InputBox(Coordinate2D(0,0), 	Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.x), nil, nil, GlobalEnums.InputBoxTypes.number, function(text) aElement.get().x = tonumber(text) or 0 end))
	table.insert(self.propertieUI[aRow + 1], InputBox(Coordinate2D(self.GuiElement.Size.x / 2,0), Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.y), nil, nil, GlobalEnums.InputBoxTypes.number))
end

function Properties:addNumber(aElement, aRow)
	self.propertieUI[aRow + 1] = {}
	table.insert(self.propertieUI[aRow + 1], InputBox(Coordinate2D(0,0), 	Coordinate2D(100,30), self.GuiElement, tostring(aElement.get()), nil, nil, GlobalEnums.InputBoxTypes.number, function(text) aElement.set(tonumber(text)) end))
end

--2d table with every element having a 'set', 'get' element.
function Properties:addProperty(aObjectProperties)
	outputChatBox("setting properties")
	self:clear()
	
	for k,v in ipairs(aObjectProperties) do
		local element = v.get()
		if Coordinate3D:made(element) then 
			self:addCoordinate3Dbox(v, #self.propertieUI)
		end
		if Coordinate2D:made(element) then 
			self:addCoordinate2Dbox(v, #self.propertieUI)
		end
		if type(element) == "number" then
			self:addNumber(v, #self.propertieUI)
		end
	end
end