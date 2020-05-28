---@type HandleInterfaceEvents
--@extends #Interface
HandleInterfaceEvents = Interface:subclass("HandleInterfaceEvents")

--- @function [parent=#HandleInterfaceEvents] init
function HandleInterfaceEvents:init(o)
    ---PERTTYFUNCTION---
    if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("HandleInterfaceEvents.class:init") end
    ---PERTTYFUNCTION---
    self.super:init()
    addEvent("onCT3ButtonClick")
    addEvent("onRequestHideInterface")
    addEventHandler("onCT3ButtonClick",getRootElement(),bind(self.onControlButtonsClick,self))
    addEventHandler("onRequestHideInterface",getRootElement(),bind(self.super.showInterface,Interface))
end

--- @function [parent=#HandleInterfaceEvents] onButtonClicked
function HandleInterfaceEvents:onButtonClicked( aPressedButton, aButtonState, aCursorX, aCursorY )
    if self:isInterfaceVisable() and aPressedButton == "left" and aButtonState == "down" and self.InterfaceClickBindendElements ~= nil then
        local MousePosition = Coordinate2D(aCursorX,aCursorY)
        for k, v in ipairs(self.super.InterfaceClickBindendElements) do
            local BindedElementsPosition = v:getPosition()
            if( MousePosition > BindedElementsPosition and MousePosition < BindedElementsPosition + v.Size) then
                v:clicked()
                triggerEvent("onCT3ButtonClick",getRootElement(),v.ID)
                break
            end
        end
    end
end

--- @function [parent=#HandleInterfaceEvents] onControlButtonsClick
function HandleInterfaceEvents:onControlButtonsClick(aID)
    if self.leftWindowButtonPlay.ID == aID then
        outputChatBox("play")
    elseif self.leftWindowButtonSync.ID == aID then
        triggerEvent("onCT3SyncButtonClick",getRootElement())
        outputChatBox("sync")
    elseif self.leftWindowButtonDelete.ID == aID then
        triggerEvent("onCT3DeleteButtonClick",getRootElement())
        outputChatBox("delete")
    end
end

--- @function [parent=#HandleInterfaceEvents] onDragAbleButtonClick
function HandleInterfaceEvents:onDragAbleButtonClick(aDragableObject)
    ---PERTTYFUNCTION---
    if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("HandleInterfaceEvents.class:onDragAbleButtonClick") end
    ---PERTTYFUNCTION---

    if not aDragableObject then return end--TODO using the function class():made().
    if(aDragableObject.super.PrimaryColor == GlobalConstants.CAM_PATH_COLOR) then
        GlobalMouse:holdObject(PathCamPosition(0, 2500, nil, false, false))
    elseif(aDragableObject.super.PrimaryColor == GlobalConstants.CAM_TARGET_PATH_COLOR) then
        GlobalMouse:holdObject(PathCamTarget(0, 2500, nil, false, false))
    elseif(aDragableObject.super.PrimaryColor == GlobalConstants.STATIC_EFFECT_COLOR) then
        GlobalMouse:holdObject(StaticEffect(0, 2500))
    elseif(aDragableObject.super.PrimaryColor == GlobalConstants.DYNAMIC_EFFECT_COLOR) then
        GlobalMouse:holdObject(DynamicEffect(0, 2500))
    end
end
