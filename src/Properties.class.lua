--- @type Properties
Properties = newclass("Properties")
PropInteger = newclass("PropInteger")
PropFloat = newclass("PropFloat")
PropText = newclass("PropText")
PropCoordinate3D = newclass("PropCoordinate3D")

function PropInteger:init()
  self.propHandlerFunctions = {}
  self.setValue = self:setValue(aValue)
  self.inputGui = InputBox(
  Coordinate2D(0,0),   
  Coordinate2D(inputboxSize,100), 
  self.GuiElement, 
  tostring(coordinate.x), 
  nil, nil, GlobalEnums.InputBoxTypes.number, self.setValue)
end

function PropInteger:setValue(aValue)
  self.inputGui:setText(aValue)
end

function PropInteger:getValue()
  return tonumber(self.inputGui:getText())
end

function PropInteger:addUpdateHandler(aHandler)
  if(type(aHandler) == "function") then
    table.insert(self.propHandlerFunctions, aHandler)
  end
end

function Properties:init()
  ---@field [parent=#Properties] #string propertieObject 
	self.propertieObject = nil
	---@field [parent=#Properties] #table propertieUI 
	self.propertieUI = {}
	---@field [parent=#Properties] #table selectedElements Table of selected TimeLineElements.
	self.selectedElements = {}
	
  addEvent ( "onTimeLineElementSelect", true )
  addEvent ( "onTimeLineElementDeselect", true )
  addEventHandler ( "onTimeLineElementSelect", getRootElement(), bind(self.onTimeLineElementSelect,self))
	addEventHandler ( "onTimeLineElementDeselect", getRootElement(), bind(self.onTimeLineElementDeselect,self))
end

function Properties:onTimeLineElementSelect(aTimeLineElement)
  table.insert(self.selectedElements, #self.selectedElements + 1,aTimeLineElement)
  self:validateMultiSelect()
end

function Properties:onTimeLineElementDeselect(aTimeLineElement)
  for key, val in ipairs(self.selectedElements) do
  	if(val == aTimeLineElement) then
      table.remove(self.selectedElements, key)
      local removedElement = table.remove(self.propertieUI[1])
      removedElement:destructor()
      break
  	end
  end

  outputChatBox("deselected a timelineelement" .. #self.selectedElements)
end

--TODO Should we use multi select, or make it ourselfs easy and only edit the last selected?
function Properties:validateMultiSelect()
  local isTimeLineElement = 0
  local isPath = 0
  local isPathCamPosition = 0
  for k,v in ipairs(self.selectedElements) do
    if(TimeLineElement:made(v)) then
      isTimeLineElement = isTimeLineElement + 1
    end
    if(Path:made(v)) then
      isPath = isPath + 1
    end
    if(PathCamPosition:made(v)) then
      isPathCamPosition = isPathCamPosition + 1
    end
  end
  outputChatBox("Amount of selected items: " .. #self.selectedElements)
  outputChatBox("Amount of TimeLineElements: " .. isTimeLineElement)
  outputChatBox("Amount of Paths: " .. isPath)
  outputChatBox("Amount of PathCamPositions: " .. isPathCamPosition)
  if(isTimeLineElement == #self.selectedElements) then
    self:addNumber(self.selectedElements[1].StartTime, 0)
  end
end

function Properties:addInterfaceElement(aGuiElement)
	self.GuiElement = aGuiElement
end

function Properties:addObjectToProperties(aObject)
	self.propertieObject = aObject
	self:addProperty(aObject:getProperties())
end

function Properties:clear()
	for k,v in ipairs(self.propertieUI) do
		for ak,av in ipairs(v) do
			av:destructor()
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
	self.propertieUI[1] = {}
	table.insert(self.propertieUI[1], InputBox(Coordinate2D(500,500), 	Coordinate2D(500,30), self.GuiElement, aElement, nil, nil, GlobalEnums.InputBoxTypes.number, function(text) aElement = tonumber(text) end))
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