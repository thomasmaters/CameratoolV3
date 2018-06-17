EffectCameraRoll = Effect:subclass("EffectCameraRoll")
EffectCameraRollDefault = 
{

}

function EffectCameraRoll:init(o)
	self.super.init(o)
	for k,v in pairs(EffectCameraRollDefault) do
		self[k] = v
	end
end

function EffectCameraRoll:preDraw()
end

function EffectCameraRoll:postDraw()
end

function EffectCameraRoll:drawInWorld()
end