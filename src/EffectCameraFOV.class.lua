EffectCameraFOV = Effect:subclass("EffectCameraFOV")
EffectCameraFOVDefault = 
{

}

function EffectCameraFOV:init(o)
	self.super.init(o)
	for k,v in pairs(EffectCameraFOVDefault) do
		self[k] = v
	end
end

function EffectCameraFOV:preDraw()
end

function EffectCameraFOV:postDraw()
end

function EffectCameraFOV:drawInWorld()
end