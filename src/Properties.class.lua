--- @type Properties
Properties = newclass("Properties")

function Properties:init()
	---@field [parent=#Properties] #table selectedElements Table of selected TimeLineElements.
	self.SelectedTimeLineElements = {}
	
	self.PropertyUiElementsSize = 0
	self.PropertiesUiElements = {}
	
	self.ParentWindow = Rectangle(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH + GlobalConstants.SCREEN_WIDTH * 0.6,GlobalConstants.SCREEN_HEIGHT - GlobalConstants.APP_HEIGHT ),Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,GlobalConstants.APP_HEIGHT),nil,2)
end

function Properties:onTimeLineElementSelect(aTimeLineElement)
  table.insert(self.SelectedTimeLineElements, #self.SelectedTimeLineElements + 1,aTimeLineElement)
  self:generatePropertyFields(aTimeLineElement)
  
  --self:validateMultiSelect()
end

function Properties:generatePropertyFields(aTimeLineElement)
  if(TimeLineElement:made(aTimeLineElement)) then
    table.insert(self.PropertiesUiElements,InputBox(self:getPropertyGuiPosition(30), Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,30), self.ParentWindow))
    aTimeLineElement:addUpdateHandler(function() self.PropertiesUiElements[1]:setValue(aTimeLineElement.StartTime, false) end)
    self.PropertiesUiElements[#self.PropertiesUiElements]:addUpdateHandler(function() aTimeLineElement.StartTime = self.PropertiesUiElements[1]:getValue() end)
    self.PropertiesUiElements[#self.PropertiesUiElements]:addUpdateHandler(function() aTimeLineElement:callUpdateHandlers() end)
    
    table.insert(self.PropertiesUiElements,InputBox(self:getPropertyGuiPosition(30), Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,30), self.ParentWindow))
    aTimeLineElement:addUpdateHandler(function() self.PropertiesUiElements[2]:setValue(aTimeLineElement.Duration, false) end)
    self.PropertiesUiElements[#self.PropertiesUiElements]:addUpdateHandler(function() aTimeLineElement:setDuration(self.PropertiesUiElements[2]:getValue()) end)
    self.PropertiesUiElements[#self.PropertiesUiElements]:addUpdateHandler(function() aTimeLineElement:callUpdateHandlers() end)
  end
  if(PathCamPosition:made(aTimeLineElement) ~= nil) then
    --TODO Do we need this explicit cast?
    aTimeLineElement = PathCamPosition:cast(aTimeLineElement)
    --Start point edit
    table.insert(self.PropertiesUiElements, GuiCoordinate3D(self:getPropertyGuiPosition(60),  Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,60, aTimeLineElement.StartPosition), self.ParentWindow,aTimeLineElement.StartPosition))
    self.PropertiesUiElements[#self.PropertiesUiElements]:addUpdateHandler(function() aTimeLineElement:callUpdateHandlers() end)
    
    --End point edit
    table.insert(self.PropertiesUiElements, GuiCoordinate3D(self:getPropertyGuiPosition(60),  Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,60, aTimeLineElement.EndPosition), self.ParentWindow,aTimeLineElement.EndPosition))
    self.PropertiesUiElements[#self.PropertiesUiElements]:addUpdateHandler(function() aTimeLineElement:callUpdateHandlers() end)
  end
end

function Properties:onTimeLineElementDeselect(aTimeLineElement)
  for key, val in ipairs(self.SelectedTimeLineElements) do
  	if(val == aTimeLineElement) then
      table.remove(self.SelectedTimeLineElements, key)
      self:clear()
      break
  	end
  end
  aTimeLineElement:clearUpdateHandlers()
  self:clear()
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
end

function Properties:clear()
	for k,v in ipairs(self.PropertiesUiElements) do
		--[[for ak,av in ipairs(v) do
			av:destructor()
			av = nil
		end]]
		v:destructor()
		v = nil
		self.PropertiesUiElements[k] = nil
	end
	self:resetPropertyUiElementHeight()
end

function Properties:resetPropertyUiElementHeight()
  self.PropertyUiElementsSize = 0
end

function Properties:getPropertyGuiPosition(addedHeight)
  local UiCoordinate = Coordinate2D(0,self.PropertyUiElementsSize)
  self.PropertyUiElementsSize = self.PropertyUiElementsSize + addedHeight
  return UiCoordinate
end