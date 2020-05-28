---@type GuiCoordinate3D
---@extends #Gui
GuiCoordinate3D = Gui:subclass("GuiCoordinate3D")

function GuiCoordinate3D:init(aPosition, aSize, aParent, aCoordinate3D, addToRenderStackFlag)
    self.super:init(aPosition, aParent, nil, nil)

    ---@field [parent=#GuiCoordinate3D] #Coordinate2D Size Size of the gui element.
    self.Size = aSize or Coordinate2D()

    if aParent then
        local borderSize = ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE )
        self.super:setRelativePosition(self.super:getRelativePosition() + Coordinate2D(borderSize, borderSize))
        self.Size = self.Size - Coordinate2D(2 * borderSize, 2 * borderSize)
    end

    local inputSizeX = (self.Size.x - 4) / 3
    local inputSizeY = math.floor(self.Size.y / 5 * 2.5)
    local inputStartY = math.floor(self.Size.y / 3)

    ---@field [parent=#GuiCoordinate3D] #Text InfoText Small text description of what the user can change.
    self.InfoText = Text(Coordinate2D(),"Position",self.super,Coordinate2D(self.Size.x, 20))

    ---@field [parent=#GuiCoordinate3D] #InputBox InputX InputBox for x coordinate.
    self.InputX = InputBox(Coordinate2D(0,inputStartY),
        Coordinate2D((self.Size.x % 2 == 0) and math.floor(inputSizeX) or math.ceil(inputSizeX), inputSizeY),
        self.super,
        "x", nil, nil, nil, addToRenderStackFlag
    )
    ---@field [parent=#GuiCoordinate3D] #InputBox InputY InputBox for y coordinate.
    self.InputY = InputBox(Coordinate2D(inputSizeX + 2,inputStartY),
        Coordinate2D((self.Size.x % 2 == 0) and math.ceil(inputSizeX) or math.floor(inputSizeX), inputSizeY),
        self.super,
        "y", nil, nil, nil, addToRenderStackFlag
    )
    ---@field [parent=#GuiCoordinate3D] #InputBox InputZ InputBox for z coordinate.
    self.InputZ = InputBox(Coordinate2D(2*inputSizeX + 4,inputStartY),
        Coordinate2D((self.Size.x % 2 == 0) and math.floor(inputSizeX) or math.ceil(inputSizeX), inputSizeY),
        self.super,
        "z", nil, nil, nil, addToRenderStackFlag
    )

    if not (aCoordinate3D == nil) then
        self.InputX:setValue(aCoordinate3D.x)
        self.InputY:setValue(aCoordinate3D.y)
        self.InputZ:setValue(aCoordinate3D.z)
    end

    self.InputX:addUpdateHandler(function() self:callUpdateHandlers() end)
    self.InputY:addUpdateHandler(function() self:callUpdateHandlers() end)
    self.InputZ:addUpdateHandler(function() self:callUpdateHandlers() end)
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
end

function GuiCoordinate3D:destructor()
    self.super:destructor()
    self.InfoText:destructor()
    self.InputX:destructor()
    self.InputY:destructor()
    self.InputZ:destructor()
end
