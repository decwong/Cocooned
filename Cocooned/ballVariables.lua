module("ballVariables", package.seeall)

local ball1x = 15
local ball1y = 15
local ball2x = 475
local ball2y = 300

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
