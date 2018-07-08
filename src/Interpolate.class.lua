Interpolate = newclass("Interpolate")

function Interpolate:init(aFrom,aTo,aTime,aEasingType)
	---PERTTYFUNCTION---
	if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Interpolate.class:init") end
	---PERTTYFUNCTION---
	
	self.From = aFrom or 0
	self.To = aTo or 100
	self.Time = aTime or 1000
	self.EasingType = aEasingType or GlobalEnums.EasingTypes.Linear
	self.CreateTime = getTickCount()
end

function Interpolate:getCurrentProgressValue()
	local Progress = (getTickCount() - 
	self.CreateTime) / 
	self.Time
	
	if Progress >= 1 then return self.To end
	
	local Value,_,_  = interpolateBetween ( 
			self.From	, 0, 0,
			self.To		, 0, 0, 
			Progress	, self.EasingType)
	return Value
end
