EffectCameraGoggle = Effect:subclass("EffectCameraGoggle")
EffectCameraGoggleDefault = 
{

}

function EffectCameraGoggle:init(o)
	self.super.init(o)
	for k,v in pairs(EffectCameraGoggleDefault) do
		self[k] = v
	end
end

function EffectCameraGoggle:preDraw()
  Camera.setGoggleEffect(self.super.getEffectStartValue() or "normal")
end

function EffectCameraGoggle:postDraw()
end

function EffectCameraGoggle:drawInWorld()
  Camera.setGoggleEffect(self.super.getEffectStartValue() or "normal")
end