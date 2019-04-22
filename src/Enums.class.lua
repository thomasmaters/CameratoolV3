---@type Enums

---@return #Enums 
Enums = newclass("Enums")

--- @function [parent=#Enums] init
function Enums:init()
  ---PERTTYFUNCTION---
  if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("Enums.class:init") end
  ---PERTTYFUNCTION---

  ---@field [parent=#Enums] #table EasingTypes 
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
  
  ---@field [parent=#Enums] #table GoggleEffects 
  self.GoggleEffects = 
  {
  normal = "normal", 
  nightvision = "nightvision", 
  thermalvision = "thermalvision"
  }
  
  ---@field [parent=#Enums] #table InputBoxTypes 
  self.InputBoxTypes =
  {
  none = "none",
  number = "number",
  signedNumber = "signedNumber"
  }
end

--- @function [parent=#Enums] test
function Enums:test()
  outputChatBox("enumstest")
end