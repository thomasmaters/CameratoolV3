---@type StaticEffect
--@extends #TimeLineElement 
StaticEffect = TimeLineElement:subclass("StaticEffect")

function StaticEffect:init(aStartTime, aDuration, aToSetValue, aEffectObject)
	self.EffectValue = aToSetValue or 0
	self.EffectObject = aEffectObject or nil
	self.EffectRectangle = Rectangle(Coordinate2D(0,0),Coordinate2D(100,30),nil,nil,GlobalConstants.STATIC_EFFECT_COLOR,nil,false)
	
	self.super:init(aStartTime, aDuration or 1000, false)
end

function StaticEffect:getEffectStartValue()
  return self.EffectValue
end

function StaticEffect:draw()
	self.EffectRectangle:draw()
end

function StaticEffect:setSelected()
  self.super:setSelected()
	self:updateSelectedColor()
end

function StaticEffect:updateSelectedColor()
	if(self.bSelected) then 
		self.EffectRectangle.PrimaryColor = GlobalConstants.STATIC_EFFECT_COLOR_SELECTED
	else
		self.EffectRectangle.PrimaryColor = GlobalConstants.STATIC_EFFECT_COLOR
	end
end

function StaticEffect:setPosition(aNewPosition)
	if not aNewPosition then return end
	self.EffectRectangle:setPosition(aNewPosition)
end

function StaticEffect:getPosition()
	return self.EffectRectangle:getPosition()
end

function StaticEffect:getSize()
	return self.EffectRectangle.Size
end

function StaticEffect:setSize(aNewSize)
	if not aNewSize then return end
	self.EffectRectangle.Size = aNewSize
end

function StaticEffect:getTimeSpan()
	return self.StartTime,-1
end