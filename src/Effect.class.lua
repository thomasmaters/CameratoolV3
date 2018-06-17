Effect = newclass("Effect")

function Effect:init(aEffectTypeObject)
	self.EffectTypeObject = aEffectTypeObject or nil
end

function Effect:getEffectStartValue()
  return EffectTypeObject.getEffectStartValue
end

--Virtual function, please override in a derived class
function Effect:preDraw()
end

--Virtual function, please override in a derived class
function Effect:postDraw()
end

--Virtual function, please override in a derived class
function Effect:drawInWorld()
end