---@type Interpolate
Interpolate = newclass("Interpolate")

function Interpolate:init(aFrom, aTo, aDuration, aEasingType, bLoop)
    ---PERTTYFUNCTION---
    if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Interpolate.class:init") end
    ---PERTTYFUNCTION---

    --- @field [parent=#Interpolate] #number From
    self.From = aFrom or 0
    --- @field [parent=#Interpolate] #number To
    self.To = aTo or 100
    --- @field [parent=#Interpolate] #number Duration
    self.Duration = aDuration or 1000
    --- @field [parent=#Interpolate] #boolean Paused
    self.bPaused = false
    --- @field [parent=#Interpolate] #GlobalEnums.EasingTypes EasingType
    self.EasingType = aEasingType or GlobalEnums.EasingTypes.Linear
    --- @field [parent=#Interpolate] #number CreateTime
    self.CreateTime = getTickCount()
    --- @field [parent=#Interpolate] #number CurrentTime
    self.CurrentTime = 0
    --- @field [parent=#Interpolate] #boolean bLoop
    self.bLoop = bLoop or false
    
    self.bLastFramePlayed = false
end

function Interpolate:restart()
    self.CreateTime = getTickCount()
end

function Interpolate:getCurrentProgressValue()
    local Progress = (self:getCurrentTime()) / self.Duration

    if Progress >= 1 then
        if self.bLoop then
            self:restart()
        end
        return self.To
    end

    local Value,_,_  = interpolateBetween (
        self.From	, 0, 0,
        self.To		, 0, 0,
        Progress	, self.EasingType)
    return Value
end

function Interpolate:getCurrentTime()
    if not self.bPaused then
        self.CurrentTime = getTickCount() - self.CreateTime
    else
        self.CreateTime = getTickCount() - self.CurrentTime
    end
    return self.CurrentTime
end

function Interpolate:pause()
    self.bPaused = true
end

function Interpolate:resume()
    self.bPaused = false
end
