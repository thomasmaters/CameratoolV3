---@type GuiCoordinate2D
---@extends #Gui
GuiCoordinate2D = Gui:subclass("GuiCoordinate2D")

function GuiCoordinate2D:init(aPosition, aSize, aParent, addToRenderStackFlag)
    self.super:init(aPosition, aParent, nil, nil)
    ---@field [parent=#GuiCoordinate3D] #Coordinate2D Size Size of the gui element.
    self.Size = aSize or Coordinate2D()

    if aParent then
        local borderSize = ( aParent.RectangleBorderSize or GlobalConstants.RECTANGLE_BORDER_SIZE )
        self.super:setRelativePosition(self.super:getRelativePosition() + Coordinate2D(borderSize, borderSize))
        self.Size = self.Size - Coordinate2D(2 * borderSize, 2 * borderSize)
    end

    local inputSizeX = (self.Size.x - 2) / 2
    local inputSizeY = math.floor(self.Size.y / 3 * 2)
    local inputStartY = math.floor(self.Size.y / 3)

    ---@field [parent=#GuiCoordinate3D] #Text InfoText Small text description of what the user can change.
    self.InfoText = Text(Coordinate2D(),"Position",self.super,Coordinate2D(self.Size.x, 20))

    ---@field [parent=#GuiCoordinate2D] #InputBox InputX InputBox for x coordinate.
    self.InputX = InputBox(Coordinate2D(0,inputStartY),
        Coordinate2D((self.Size.x % 2 == 0) and math.floor(inputSizeX) or math.ceil(inputSizeX), inputSizeY),
        self.super,
        "x", nil, nil, nil, addToRenderStackFlag
    )

    ---@field [parent=#GuiCoordinate2D] #InputBox InputY InputBox for y coordinate.
    self.InputY = InputBox(Coordinate2D(inputSizeX + 2,inputStartY),
        Coordinate2D((self.Size.x % 2 == 0) and math.ceil(inputSizeX) or math.floor(inputSizeX), inputSizeY),
        self.super,
        "y", nil, nil, nil, addToRenderStackFlag
    )

    self.InputX:addUpdateHandler(self:callUpdateHandler())
    self.InputY:addUpdateHandler(self:callUpdateHandler())
end

function GuiCoordinate2D:getValue()
    return Coordinate2D(self.InputX:getValue(), self.InputY:getValue());
end

function GuiCoordinate2D:setValue(aValueX, aValueY)
    if(Coordinate2D:made(aValueX)) then
        self.InputX:setValue(aValueX.x)
        self.InputY:setValue(aValueX.y)
    elseif(type(aValueX) == "table") then
        self.InputX:setValue(aValueX[1])
        self.InputY:setValue(aValueX[2])
    else
        self.InputX:setValue(aValueX)
        self.InputY:setValue(aValueY)
    end
end

function GuiCoordinate2D:destructor()
    self.super:destructor()
    self.InputX:destructor()
    self.InputY:destructor()
end
