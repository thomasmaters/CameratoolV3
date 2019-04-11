---@type EffectCameraFade

--- @return #EffectCameraFade 
EffectCameraFade = Effect:subclass("EffectCameraFade")

function EffectCameraFade:init(o)
	self.super.init(o)
end

function EffectCameraFade:preDraw()
  Camera.fade(self.super.getEffectStartValue(),0)
end

function EffectCameraFade:postDraw()
end

function EffectCameraFade:drawInWorld()
end