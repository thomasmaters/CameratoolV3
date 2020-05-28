---@type Coordinate2D
Coordinate2D = newclass("Coordinate2D")

function Coordinate2D:init(x,y)
    --Copy constructor
    if(Coordinate2D:made(x)) then
        self.x = x.x or 0
        self.y = x.y or 0
    else --Default constructor
        self.x = x or 0
        self.y = y or 0
    end
end

function Coordinate2D:setX(aX)
    self.x = aX
end

function Coordinate2D:setY(aY)
    self.y = aY
end

function Coordinate2D:__add(aOtherCoordinate)
    return Coordinate2D(self.x + aOtherCoordinate.x, self.y + aOtherCoordinate.y)
end

function Coordinate2D:__sub(aOtherCoordinate)
    return Coordinate2D(self.x - aOtherCoordinate.x, self.y - aOtherCoordinate.y)
end

function Coordinate2D:__lt(aOtherCoordinate)
    return (self.x < aOtherCoordinate.x and self.y < aOtherCoordinate.y)
end

function Coordinate2D:__le(aOtherCoordinate)
    return (self.x <= aOtherCoordinate.x and self.y <= aOtherCoordinate.y)
end

function Coordinate2D:__tostring()
    return "Coordinate2D ".. self.x .."  "..self.y
end
