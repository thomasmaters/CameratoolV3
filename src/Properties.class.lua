--- @type Properties
Properties = newclass("Properties")

function Properties:init()
    ---@field [parent=#Properties] #table selectedElements Table of selected TimeLineElements.
    self.SelectedTimeLineElements = {}
    ---@field [parent=#Properties] #table<#Gui> PropertyUiElements Ui elements in de current properties selection.
    self.PropertyUiElements = {}

    ---@field [parent=#Properties] #number The combined height of the UI elements.
    self.PropertyUiElementsSize = 0
    ---@field [parent=#Properties] #number The amount of tabs in the Property window.
    self.AmountOfTabs   = 0
    self.CurrentTab     = 1
    self.TabsBar 		= Rectangle(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH + GlobalConstants.SCREEN_WIDTH * 0.6,GlobalConstants.SCREEN_HEIGHT - GlobalConstants.APP_HEIGHT),Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,20),nil,1)
    self.ParentWindow 	= Rectangle(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH + GlobalConstants.SCREEN_WIDTH * 0.6,GlobalConstants.SCREEN_HEIGHT - GlobalConstants.APP_HEIGHT + 20 ),Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,GlobalConstants.APP_HEIGHT - 20),nil,1)

    self.NextTabButton 	= Button(Coordinate2D(), Coordinate2D(100,20), "1", self.TabsBar)
    self:addTab()
end

function Properties:onTimeLineElementSelect(aTimeLineElement)
    table.insert(self.SelectedTimeLineElements, #self.SelectedTimeLineElements + 1,aTimeLineElement)
    self:generatePropertyFields(aTimeLineElement)

    --self:validateMultiSelect()
end

function Properties:draw()
    outputChatBox("This shoud not be called")
end

--- @function [parent=#Properties] generatePropertyFields
function Properties:generatePropertyFields(aTimeLineElement)
    if self:hasItemSelected() then
        self:clear()
    end

    outputChatBox("isTimeLineElement: " ..tostring(TimeLineElement:trycast(aTimeLineElement) ~= nil))
    outputChatBox("IsPathCamPosition: " ..tostring(PathCamPosition:trycast(aTimeLineElement) ~= nil))
    outputChatBox("IsPathCamTarget: " ..tostring(PathCamTarget:trycast(aTimeLineElement) ~= nil))

    if(TimeLineElement:trycast(aTimeLineElement)) then
        local startTimeInput = InputBox(self:getPropertyGuiPosition(30), Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,30), self.ParentWindow, nil, nil, nil, nil, true)
        startTimeInput:setValue(aTimeLineElement.StartTime, false)
        aTimeLineElement:addUpdateHandler(function() startTimeInput:setValue(aTimeLineElement.StartTime, false) end)
        startTimeInput:addUpdateHandler(function() aTimeLineElement:setStartTime(startTimeInput:getValue()) end)
        startTimeInput:addUpdateHandler(function() aTimeLineElement:callUpdateHandlers() end)
        self:addToUiElements(startTimeInput)

        local durationInput = InputBox(self:getPropertyGuiPosition(30), Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,30), self.ParentWindow, nil, nil, nil, nil, true)
        durationInput:setValue(aTimeLineElement.Duration, false)
        aTimeLineElement:addUpdateHandler(function() durationInput:setValue(aTimeLineElement.Duration, false) end)
        durationInput:addUpdateHandler(function() aTimeLineElement:setDuration(durationInput:getValue()) end)
        durationInput:addUpdateHandler(function() aTimeLineElement:callUpdateHandlers() end)
        self:addToUiElements(durationInput)
    end

    -- Edit Path Start and End Position.
    if(Path:trycast(aTimeLineElement) ~= nil) then
        aTimeLineElement = Path:cast(aTimeLineElement)
        local startPointEdit = GuiCoordinate3D(self:getPropertyGuiPosition(60), Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,60), self.ParentWindow, aTimeLineElement.StartPosition)
        startPointEdit:addUpdateHandler(function() aTimeLineElement:setStartPosition(startPointEdit:getValue()) end)
        startPointEdit:addUpdateHandler(function() aTimeLineElement:callUpdateHandlers() end)
        self:addToUiElements(startPointEdit)

        local endPointEdit = GuiCoordinate3D(self:getPropertyGuiPosition(60), Coordinate2D(GlobalConstants.RIGHT_WINDOW_WIDTH,60), self.ParentWindow, aTimeLineElement.EndPosition)
        endPointEdit:addUpdateHandler(function() aTimeLineElement:setEndPosition(endPointEdit:getValue()) end)
        endPointEdit:addUpdateHandler(function() aTimeLineElement:callUpdateHandlers() end)
        self:addToUiElements(endPointEdit)
    end
end

function Properties:onTimeLineElementDeselect(aTimeLineElement)
    if not self:hasItemSelected() then return end

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
    for i=1,self.AmountOfTabs do
        for k,v in ipairs(self.PropertyUiElements[i]) do
            v:destructor()
            v = nil
            self.PropertyUiElements[i][k] = nil
        end
    end
    self:resetPropertyUiElementHeight()
    self.CurrentTab = 1
end

function Properties:resetPropertyUiElementHeight()
    self.PropertyUiElementsSize = 0
end

function Properties:hasItemSelected()
    if #self.PropertyUiElements > 0 then
        return true
    end
    return false
end

function Properties:addToUiElements(aGuiElement)
    table.insert(self.PropertyUiElements[self.AmountOfTabs], aGuiElement)
end

function Properties:addTab()
    self.AmountOfTabs = self.AmountOfTabs + 1
    self.PropertyUiElements[self.AmountOfTabs] = {}
    self:resetPropertyUiElementHeight()
end

function Properties:getPropertyGuiPosition(addedHeight)
    local UiCoordinate = Coordinate2D(0,self.PropertyUiElementsSize)
    self.PropertyUiElementsSize = self.PropertyUiElementsSize + addedHeight
    if self.PropertyUiElementsSize > self.ParentWindow.Size.x then
        self:addTab()
    end
    return UiCoordinate
end
