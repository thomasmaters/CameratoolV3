---@type DynamicEffect
--@extends #TimeLineElement
DynamicEffect = TimeLineElement:subclass("DynamicEffect")

function DynamicEffect:init(aStartTime, aDuration, aAnimationType, aStartValue, aEndValue, aEffectObject)
	self.EffectAnimationType = aAnimationType or GlobalEnums.EasingTypes.Linear
	self.EffectAnimationStartValue = aStartValue or 0
	self.EffectAnimationEndValue =  aEndValue or 0
	self.EffectObject = aEffectObject or nil
	self.EffectRectangle = Rectangle(Coordinate2D(0,0),Coordinate2D(100,30),nil,nil,GlobalConstants.DYNAMIC_EFFECT_COLOR,nil,false)
	
	self.super:init(nil, aStartTime, aDuration or 1000, false)
end

function DynamicEffect:getEffectStartValue()
  return self.EffectAnimationStartValue
end

function DynamicEffect:draw()
	self.EffectRectangle:draw()
end

function DynamicEffect:setSelected()
  self.super:setSelected()
  self:updateSelectedColor()
end

function DynamicEffect:updateSelectedColor()
	if(self.bSelected) then 
		self.EffectRectangle.PrimaryColor = GlobalConstants.DYNAMIC_EFFECT_COLOR_SELECTED
	else
		self.EffectRectangle.PrimaryColor = GlobalConstants.DYNAMIC_EFFECT_COLOR
	end
end

function DynamicEffect:setPosition(aNewPosition)
	if not aNewPosition then return end
	self.EffectRectangle:setPosition(aNewPosition)
end

function DynamicEffect:getPosition()
	return self.EffectRectangle:getPosition()
end

function DynamicEffect:getSize()
	return self.EffectRectangle.Size
end

function DynamicEffect:setSize(aNewSize)
	if not aNewSize then return end
	self.EffectRectangle.Size = aNewSize
end