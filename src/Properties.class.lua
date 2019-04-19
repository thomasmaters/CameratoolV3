--- @type Properties
Properties = newclass("Properties")

function Properties:init()
	---@field [parent=#Properties] #table selectedElements Table of selected TimeLineElements.
	self.SelectedTimeLineElements = {}
	
	self.PropertiesUiElements = {}
end

function Properties:onTimeLineElementSelect(aTimeLineElement)
  table.insert(self.SelectedTimeLineElements, #self.SelectedTimeLineElements + 1,aTimeLineElement)
  self:validateMultiSelect()
end

function Properties:generatePropertyFields()
end

function Properties:onTimeLineElementDeselect(aTimeLineElement)
  for key, val in ipairs(self.SelectedTimeLineElements) do
  	if(val == aTimeLineElement) then
      table.remove(self.SelectedTimeLineElements, key)
      local removedElement = table.remove(self.propertieUI[1])
      removedElement:destructor()
      break
  	end
  end

  outputChatBox("deselected a timelineelement" .. #self.SelectedTimeLineElements)
end

--TODO Should we use multi select, or make it ourselfs easy and only edit the last selected?
function Properties:validateMultiSelect()
  local isTimeLineElement = 0
  local isPath = 0
  local isPathCamPosition = 0
  for k,v in ipairs(self.SelectedTimeLineElements) do
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
  outputChatBox("Amount of selected items: " .. #self.SelectedTimeLineElements)
  outputChatBox("Amount of TimeLineElements: " .. isTimeLineElement)
  outputChatBox("Amount of Paths: " .. isPath)
  outputChatBox("Amount of PathCamPositions: " .. isPathCamPosition)
  if(isTimeLineElement == #self.SelectedTimeLineElements) then
    self:addNumber(self.SelectedTimeLineElements[1].StartTime, 0)
  end
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
	table.insert(self.propertieUI[aRow + 1],InputBox(Coordinate2D(0,0), 				Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.x), nil, nil, GlobalEnums.InputBoxTypes.number))
	table.insert(self.propertieUI[aRow + 1],InputBox(Coordinate2D(inputboxSize,0), 		Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.y), nil, nil, GlobalEnums.InputBoxTypes.number))
	table.insert(self.propertieUI[aRow + 1],InputBox(Coordinate2D(inputboxSize * 2,0), 	Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.z), nil, nil, GlobalEnums.InputBoxTypes.number))
end

function Properties:addCoordinate2Dbox(aElement, aRow)
	local coordinate = aElement.get()
	local inputboxSize = self.GuiElement.Size.x / 3
	
	self.propertieUI[aRow + 1] = {}
	table.insert(self.propertieUI[aRow + 1], InputBox(Coordinate2D(0,0), 	Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.x), nil, nil, GlobalEnums.InputBoxTypes.number))
	table.insert(self.propertieUI[aRow + 1], InputBox(Coordinate2D(self.GuiElement.Size.x / 2,0), Coordinate2D(inputboxSize,100), self.GuiElement, tostring(coordinate.y), nil, nil, GlobalEnums.InputBoxTypes.number))
end

function Properties:addNumber(aElement, aRow)
	self.propertieUI[1] = {}
	table.insert(self.propertieUI[1], InputBox(Coordinate2D(500,500), 	Coordinate2D(500,30), self.GuiElement, aElement, nil, nil, GlobalEnums.InputBoxTypes.number))
end