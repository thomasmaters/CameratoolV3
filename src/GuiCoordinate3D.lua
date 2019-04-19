---@type GuiCoordinate3D
---@extends #Gui
GuiCoordinate3D = Gui:subclass("GuiCoordinate3D")

function GuiCoordinate3D:init(aPosition, aSize, aParent)
  self.super:init(aPosition, aParent, nil, nil)
  ---@field [parent=#GuiCoordinate3D] #Coordinate2D Size Size of the gui element.
  self.Size = aSize or Coordinate2D()
  
  ---@field [parent=#GuiCoordinate3D] #Text InfoText Small text description of what the user can change.
  self.InfoText = Text(aPosition,"Position",aParent,Coordinate2D(self.Size.x, 20))
  
  local inputSizeX = math.floor((self.Size.x - 6) / 3)
  local inputSize = Coordinate2D(inputSizeX, self.Size.y)
  
  ---@field [parent=#GuiCoordinate3D] #InputBox InputX InputBox for x coordinate.
  self.InputX = InputBox(aPosition, inputSize, aParent)
  ---@field [parent=#GuiCoordinate3D] #InputBox InputY InputBox for y coordinate.
  self.InputY = InputBox(aPosition, inputSize, aParent)
  ---@field [parent=#GuiCoordinate3D] #InputBox InputZ InputBox for z coordinate.
  self.InputZ = InputBox(aPosition, inputSize, aParent)
  
  self.InputX:addUpdateHandler(self:callUpdateHandler())
  self.InputY:addUpdateHandler(self:callUpdateHandler())
  self.InputZ:addUpdateHandler(self:callUpdateHandler())
end

function GuiCoordinate3D:getValue()
  return Coordinate3D(self.InputX:getValue(), self.InputY:getValue(), self.InputZ:getValue());
end

function GuiCoordinate3D:setValue(aValueX, aValueY, aValueZ)
  if(Coordinate3D:made(aValueX)) then
    self.InputX:setValue(aValueX.x)
    self.InputY:setValue(aValueX.y)
    self.InputZ:setValue(aValueX.z)
  elseif(type(aValueX) == "table") then
    self.InputX:setValue(aValueX[1])
    self.InputY:setValue(aValueX[2])
    self.InputZ:setValue(aValueX[3])    
  else
    self.InputX:setValue(aValueX)
    self.InputY:setValue(aValueY)
    self.InputZ:setValue(aValueZ)
  end
end

function GuiCoordinate3D:destructor()
  self.InputX:destructor()
  self.InputY:destructor()
  self.InputZ:destructor()
end