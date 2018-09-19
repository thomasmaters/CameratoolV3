Enums = newclass("Enums")

function Enums:init(o)
  ---PERTTYFUNCTION---
  if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Enums.class:init") end
  ---PERTTYFUNCTION---
  self.EasingTypes = 
  {
  Linear = "Linear", 
  InQuad = "InQuad", 
  OutQuad = "OutQuad", 
  InOutQuad = "InOutQuad", 
  OutInQuad = "OutInQuad", 
  InElastic = "InElastic", 
  OutElastic = "OutElastic", 
  InOutElastic = "InOutElastic", 
  OutInElastic = "OutInElastic", 
  InBack = "InBack", 
  OutBack = "OutBack", 
  InOutBack = "InOutBack", 
  OutInBack = "OutInBack", 
  InBounce = "InBounce", 
  OutBounce = "OutBounce", 
  InOutBounce = "InOutBounce", 
  OutInBounce = "OutInBounce", 
  SineCurve = "SineCurve", 
  CosineCurve = "CosineCurve"
  }
  
  self.GoggleEffects = 
  {
  normal = "normal", 
  nightvision = "nightvision", 
  thermalvision = "thermalvision"
  }
  
  self.InputBoxTypes =
  {
  none = "none",
  number = "number"
  }
end

function Enums:test()
  outputChatBox("enumstest")
end