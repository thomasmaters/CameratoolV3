Coordinate2D = newclass("Coordinate2D")

function Coordinate2D:init(x,y)
	self.x = x or 0
	self.y = y or 0
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