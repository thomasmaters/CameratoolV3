--- @type Properties
Properties = newclass("Properties")

function Properties:init()
	---@field [parent=#Properties] #table selectedElements Table of selected TimeLineElements.
	self.SelectedTimeLineElements = {}
	self.PropertyUiElements = {}
	
	self.PropertyUiElementsSize = 0
	
	self.ParentWindow = Rectangle(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH + GlobalConstants.SCREEN_WIDTH * 0.6,GlobalConstants.SCREEN_HEIGHT - GlobalConstants.APP_HEIGHT ),Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,GlobalConstants.APP_HEIGHT),nil,2)
  --TODO intergrating a scrollable window, who owns the UI elements, the Properties class or the ScrollableWindow class?
  --[[self.ScrollWindow = ScrollableWindow(
    Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH + GlobalConstants.SCREEN_WIDTH * 0.6,GlobalConstants.SCREEN_HEIGHT - GlobalConstants.APP_HEIGHT ),
    Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,GlobalConstants.APP_HEIGHT),
    nil,
    Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,2 * GlobalConstants.APP_HEIGHT))]]
end

function Properties:onTimeLineElementSelect(aTimeLineElement)
  table.insert(self.SelectedTimeLineElements, #self.SelectedTimeLineElements + 1,aTimeLineElement)
  self:generatePropertyFields(aTimeLineElement)
  
  --self:validateMultiSelect()
end

function Properties:generatePropertyFields(aTimeLineElement)
  if(TimeLineElement:made(aTimeLineElement)) then
    local startTimeInput = InputBox(self:getPropertyGuiPosition(30), Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,30), self.ParentWindow, nil, nil, nil, nil, true)
    startTimeInput:setValue(aTimeLineElement.StartTime, false)
    aTimeLineElement:addUpdateHandler(function() startTimeInput:setValue(aTimeLineElement.StartTime, false) end)
    startTimeInput:addUpdateHandler(function() aTimeLineElement.StartTime = startTimeInput:getValue() end)
    startTimeInput:addUpdateHandler(function() aTimeLineElement:callUpdateHandlers() end)
    --self.ScrollWindow:addUIElement(startTimeInput)
    table.insert(self.PropertyUiElements, startTimeInput)
    
    local durationInput = InputBox(self:getPropertyGuiPosition(30), Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,30), self.ParentWindow, nil, nil, nil, nil, true)
    durationInput:setValue(aTimeLineElement.Duration, false)
    aTimeLineElement:addUpdateHandler(function() durationInput:setValue(aTimeLineElement.Duration, false) end)
    durationInput:addUpdateHandler(function() aTimeLineElement:setDuration(durationInput:getValue()) end)
    durationInput:addUpdateHandler(function() aTimeLineElement:callUpdateHandlers() end)
    table.insert(self.PropertyUiElements, durationInput)
    --self.ScrollWindow:addUIElement(durationInput)
  end
  if(PathCamPosition:made(aTimeLineElement) ~= nil) then
    --TODO Do we need this explicit cast?
    aTimeLineElement = PathCamPosition:cast(aTimeLineElement)
    local startPointEdit = GuiCoordinate3D(self:getPropertyGuiPosition(60),  Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,60), self.ParentWindow,aTimeLineElement.StartPosition)
    startPointEdit:addUpdateHandler(function() aTimeLineElement:callUpdateHandlers() end)
    table.insert(self.PropertyUiElements, startPointEdit)
    
    local endPointEdit = GuiCoordinate3D(self:getPropertyGuiPosition(60),  Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,60), self.ParentWindow,aTimeLineElement.EndPosition)
    endPointEdit:addUpdateHandler(function() aTimeLineElement:callUpdateHandlers() end)
    table.insert(self.PropertyUiElements, endPointEdit)
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
  for k,v in ipairs(self.PropertyUiElements) do
    v:destructor()
    v = nil
    self.PropertyUiElements[k] = nil
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