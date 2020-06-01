---@type GuiCoordinate3D
---@extends #Gui
GuiCoordinate3D = Gui:subclass("GuiCoordinate3D")

function GuiCoordinate3D:init(aPosition, aSize, aParent, aCoordinate3D, addToRenderStackFlag)
    self.super:init(aPosition, aParent, nil, nil, addToRenderStackFlag)

    ---@field [parent=#GuiCoordinate3D] #Coordinate2D Size Size of the gui element.
    self.Size = aSize or Coordinate2D()

    if aParent then
        local borderSize = ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE )
        self.super:setRelativePosition(self.super:getRelativePosition() + Coordinate2D(borderSize, borderSize))
        self.Size = self.Size - Coordinate2D(2 * borderSize, 2 * borderSize)
    end

    local inputSizeX = (self.Size.x - 4) / 3 - 20
    local inputSizeY = math.floor(self.Size.y / 5 * 2.5)

    self.TextX = Text(Coordinate2D(0, 0),"X",self.super,Coordinate2D(20, inputSizeY),"default", 1.4, "center", nil, nil, nil, nil, false)
    self.TextY = Text(Coordinate2D(inputSizeX + 20, 0),"Y",self.super,Coordinate2D(20, inputSizeY), "default", 1.4, "center", nil, nil, nil, nil, false)
    self.TextZ = Text(Coordinate2D(2*inputSizeX + 40, 0),"Z",self.super,Coordinate2D(20, inputSizeY), "default", 1.4, "center", nil, nil, nil, nil, false)

    ---@field [parent=#GuiCoordinate3D] #InputBox InputX InputBox for x coordinate.
    self.InputX = InputBox(Coordinate2D(20,0),
        Coordinate2D((self.Size.x % 2 == 0) and math.floor(inputSizeX) or math.ceil(inputSizeX), inputSizeY),
        self.super,
        "x", nil, nil, nil, false
    )
    ---@field [parent=#GuiCoordinate3D] #InputBox InputY InputBox for y coordinate.
    self.InputY = InputBox(Coordinate2D(inputSizeX + 42,0),
        Coordinate2D((self.Size.x % 2 == 0) and math.ceil(inputSizeX) or math.floor(inputSizeX), inputSizeY),
        self.super,
        "y", nil, nil, nil, false
    )
    ---@field [parent=#GuiCoordinate3D] #InputBox InputZ InputBox for z coordinate.
    self.InputZ = InputBox(Coordinate2D(2*inputSizeX + 64,0),
        Coordinate2D((self.Size.x % 2 == 0) and math.floor(inputSizeX) or math.ceil(inputSizeX), inputSizeY),
        self.super,
        "z", nil, nil, nil, false
    )

    if not (aCoordinate3D == nil) then
        self.InputX:setValue(aCoordinate3D.x)
        self.InputY:setValue(aCoordinate3D.y)
        self.InputZ:setValue(aCoordinate3D.z)
    end

    self.InputX:addUpdateHandler(function() self:callUpdateHandlers() end)
    self.InputY:addUpdateHandler(function() self:callUpdateHandlers() end)
    self.InputZ:addUpdateHandler(function() self:callUpdateHandlers() end)
    
    if(addToRenderStackFlag == nil or addToRenderStackFlag == true) then
        GlobalInterface:addGuiElementToRenderStack(self)
    end
end

function GuiCoordinate3D:enableGui()
    self.super:enableGui()
    if not GlobalInterface:isGuiElementInRenderStack(self) then
        GlobalInterface:addGuiElementToRenderStack(self)    
    end
end

function GuiCoordinate3D:disableGui()
    self.super:disableGui()
    self.InputX.super:disableGui()
    self.InputY.super:disableGui()
    self.InputZ.super:disableGui()
    self.TextX.super:disableGui()
    self.TextY.super:disableGui()
    self.TextZ.super:disableGui()
    GlobalInterface:removeGuiElementFromRenderStack(self)
end


function GuiCoordinate3D:getValue()
    return Coordinate3D(self.InputX:getValue(), self.InputY:getValue(), self.InputZ:getValue());
end

function GuiCoordinate3D:setValue(aValueX, aValueY, aValueZ, bCascadeUpdate)
    if(Coordinate3D:made(aValueX)) then
        self.InputX:setValue(aValueX.x)
        self.InputY:setValue(aValueX.y)
        self.InputZ:setValue(aValueX.z)
        bCascadeUpdate = aValueY
    elseif(type(aValueX) == "table") then
        self.InputX:setValue(aValueX[1])
        self.InputY:setValue(aValueX[2])
        self.InputZ:setValue(aValueX[3])
        bCascadeUpdate = aValueY
    else
        self.InputX:setValue(aValueX)
        self.InputY:setValue(aValueY)
        self.InputZ:setValue(aValueZ)
    end

    if(bCascadeUpdate == nil or bCascadeUpdate) then
        self:callUpdateHandlers()
    end
end

function GuiCoordinate3D:draw()
    self.InputX:draw()
    self.InputY:draw()
    self.InputZ:draw()
    self.TextX:draw()
    self.TextY:draw()
    self.TextZ:draw()
end

function GuiCoordinate3D:destructor()
    self.super:destructor()
    self.TextX:destructor()
    self.TextY:destructor()
    self.TextZ:destructor()
    self.InputX:destructor()
    self.InputY:destructor()
    self.InputZ:destructor()
    GlobalInterface:removeGuiElementFromRenderStack(self)
end
