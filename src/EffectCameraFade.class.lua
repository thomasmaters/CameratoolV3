EffectCameraFade = Effect:subclass("EffectCameraFade")
EffectCameraFadeDefault = 
{

}

function EffectCameraFade:init(o)
	self.super.init(o)
	for k,v in pairs(EffectCameraFadeDefault) do
		self[k] = v
	end
end

function EffectCameraFade:preDraw()
  Camera.fade(self.super.getEffectStartValue(),0)
end

function EffectCameraFade:postDraw()
end

function EffectCameraFade:drawInWorld()
end