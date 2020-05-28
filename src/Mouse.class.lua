---@type Mouse
Mouse = newclass("Mouse")

function Mouse:init()
    self.MousePosition = Coordinate2D()
    self.ObjectBeingHold = nil
    self.bMouseIsDragging = nil
    self.TimeSinceClick = 0

    addEventHandler( "onClientClick", getRootElement(), bind(GlobalInterface.onButtonClicked,GlobalInterface))
    addEventHandler( "onClientClick", getRootElement(),
        function(aPressedButton,aButtonState,_,_)
            if(aPressedButton == "left" and aButtonState == "down") then
                self.bMouseIsDragging = false
                self.TimeSinceClick = getTickCount()
            elseif(aPressedButton == "left" and aButtonState == "up") then
                self.bMouseIsDragging = nil
                self.TimeSinceClick = 0
                triggerEvent("mouseReleased", getRootElement())
            end
        end
    )
    addEventHandler( "onClientCursorMove", getRootElement(),
        function(_,_,CursorX,CursorY)
            self.MousePosition = Coordinate2D(CursorX,CursorY)
            if(self.bMouseIsDragging == false and (getTickCount() - self.TimeSinceClick) > 20) then
                self.bMouseIsDragging = true
                outputChatBox("dragging")
                triggerEvent("mouseIsDragging", getRootElement())
            end
        end
    )
end

function Mouse:getPosition()
    return self.MousePosition
end

function Mouse:isMousePressed(aKeyName)
    if not aKeyName or not (aKeyName == "mouse1" or aKeyName == "mouse2") then return false end

    return getKeyState(aKeyName)
end

function Mouse:isMouseDragging()
    return self.bMouseIsDragging or false
end

function Mouse:holdObject(aObject)
    ---PERTTYFUNCTION---
    if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Mouse.class:holdObject") end
    ---PERTTYFUNCTION---
    if not aObject then return false end
    if self.ObjectBeingHold then return false end
    self.ObjectBeingHold = aObject

    local function renderElementUnderMouse()
        if(self:isMousePressed("mouse1"))then
            self.ObjectBeingHold:draw()
            self.ObjectBeingHold:setPosition(self.MousePosition)
            if(PathCamPosition:made(self.ObjectBeingHold) or PathCamTarget:made(self.ObjectBeingHold) or StaticEffect:made(self.ObjectBeingHold) or DynamicEffect:made(self.ObjectBeingHold)) then
                triggerEvent("timeLineElementHold", getRootElement())
            end
        else
            if(PathCamPosition:made(self.ObjectBeingHold) or PathCamTarget:made(self.ObjectBeingHold) or StaticEffect:made(self.ObjectBeingHold) or DynamicEffect:made(self.ObjectBeingHold)) then
                triggerEvent("timeLineElementRelease", getRootElement())
            end

            removeEventHandler("onClientRender",getRootElement(),renderElementUnderMouse)
        end
    end
    addEventHandler("onClientRender",getRootElement(),renderElementUnderMouse)
    return true
end

function Mouse:releaseObject()
    ---PERTTYFUNCTION---
    if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Mouse.class:releaseObject") end
    ---PERTTYFUNCTION---
    if not self.ObjectBeingHold then return end

    self.ObjectBeingHold = nil
end

function Mouse:getObjectBeingHold()
    if not self.ObjectBeingHold then return nil end

    return self.ObjectBeingHold
end
