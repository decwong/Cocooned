module("ballVariables", package.seeall)

local ball1x = 25
local ball1y = 25
local ball2x = 475
local ball2y = 300
local ballColor = "white"

local ball2Visible = "false"


function setBall1( x, y )
	ball1x = x
	ball1y = y
end

function setBall2( x, y )
	ball2x = x
	ball2y = y
end

function getBall1x()
	return ball1x
end

function getBall1y()
	return ball1y
end

function getBall2x()
	return ball2x
end

function getBall2y()
	return ball2y
end

function isBall2Visible()
	return ball2Visible
end

function setBall2Visible(bool)
	ball2Visible = bool
end

--for magnetism only
local repelled = false;
local magnetized1 = true;
local magnetized2 = true;
function setRepelled(bool)
	repelled = bool
end
function getRepelled()
	return repelled
end
function setMagnetized1(bool)
	magnetized1 = bool
end
function getMagnetized1()
	return magnetized1
end
function setMagnetized2(bool)
	magnetized2 = bool
end
function getMagnetized2()
	return magnetized2
end
--color
function getBallColor() 
	return ballColor
end

function setBallColor( string ) 
	ballColor = string
end

function resetBall()
	ball1x = 15
	ball1y = 45
	ball2x = 475
	ball2y = 300
end
