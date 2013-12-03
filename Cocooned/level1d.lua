-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget");
local myData = require("lvl1Data")
require("ballVariables")

display.setStatusBar(display.HiddenStatusBar )

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()
-- Set view mode to show bounding boxes 
--physics.setDrawMode("hybrid")


--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

local bhtimer

local ballTable = { 
	[1] = display.newImage("ball.png") }

-- add new walls
-- temp wall image from: http://protextura.com/wood-plank-cartoon-11130
local walls = {
	[1] = display.newImage("ground1.png"),
	[2] = display.newImage("ground1.png"),
	[3] = display.newImage("ground2.png"),
	[4] = display.newImage("ground2.png") 
} 

	-- Left wall
	walls[1].x = -40
	walls[1].y = 180
	walls[1].rotation = 90
	
	-- Right wall
	walls[2].x = 520
	walls[2].y = 180
	walls[2].rotation = 90
	
	-- Top wall
	walls[3].x = 250
	walls[3].y = 5
	
	-- Bottom wall
	walls[4].x = 250
	walls[4].y = 315
	
-- Draw Menu Button
local menu = display.newImage("floor.png")
	menu.x = 245
	menu.y = 10


local lines = {
	-- newRect(left, top, width, height)
	-- Rectangles for inital pane on 
	-- left and right side
	[1] = display.newRect(70, 180, 20, 575) ,
	[2] = display.newRect(410, 180, 20, 575) 
} 
	
	for count = 1, #lines do
		lines[count]:setFillColor(0, 0, 0)
	end
	
-- Draw crates
local blackholes = {
	[1] = display.newImage("blackhole2.png"),
	[2] = display.newImage("blackhole2.png"),
	[3] = display.newImage("blackhole2.png"),
	[4] = display.newImage("blackhole2.png"),
	[5] = display.newImage("blackhole2.png"),
	[6] = display.newImage("blackhole2.png"),
	[7] = display.newImage("blackhole2.png"),
	[8] = display.newImage("blackhole2.png"),
	[9] = display.newImage("blackhole2.png"),
	[10] = display.newImage("blackhole2.png"),
	
	[11] = display.newImage("blackhole2.png"),
	[12] = display.newImage("blackhole2.png"),
	[13] = display.newImage("blackhole2.png"),
	[14] = display.newImage("blackhole2.png"),
	[15] = display.newImage("blackhole2.png"),
	[16] = display.newImage("blackhole2.png"),
	[17] = display.newImage("blackhole2.png"),
	[18] = display.newImage("blackhole2.png"),
	[19] = display.newImage("blackhole2.png"),
	[20] = display.newImage("blackhole2.png"),
	
}

	blackholes[1].x = 180
	blackholes[1].y = 70
	blackholes[2].x = 240
	blackholes[2].y = 70
	blackholes[3].x = 180
	blackholes[3].y = 130
	blackholes[4].x = 240
	blackholes[4].y = 130
	blackholes[5].x = 120
	blackholes[5].y = 70
	blackholes[6].x = 300
	blackholes[6].y = 70
	blackholes[7].x = 120
	blackholes[7].y = 130
	blackholes[8].x = 300
	blackholes[8].y = 130
	blackholes[9].x = 360
	blackholes[9].y = 70
	blackholes[10].x = 360
	blackholes[10].y = 130
	
	blackholes[11].x = 180
	blackholes[11].y = 190
	blackholes[12].x = 240
	blackholes[12].y = 190
	blackholes[13].x = 180
	blackholes[13].y = 250
	blackholes[14].x = 240
	blackholes[14].y = 250
	blackholes[15].x = 120
	blackholes[15].y = 190
	blackholes[16].x = 300
	blackholes[16].y = 190
	blackholes[17].x = 120
	blackholes[17].y = 250
	blackholes[18].x = 300
	blackholes[18].y = 250
	blackholes[19].x = 360
	blackholes[19].y = 190
	blackholes[20].x = 360
	blackholes[20].y = 250

	
local function saveBallLocation()
	ballVariables.setBall1(ballTable[1].x, ballTable[1].y)
	--ballVariables.setBall2(ballTable[2].x, ballTable[2].y)
end
	
-- distance function
local function distance(x1, x2, y1, y2)
	local dist
	dist = math.sqrt( ((x2-x1)^2) + ((y2-y1)^2) )
	return dist
end

-- MENU FUNCTION
local menuBool = false
local function menuCheck(event)
	if event.phase == "ended" then
		local dist
		dist = distance(event.x, menu.x, event.y, menu.y)
		if dist < 20 and menuBool == false then
			local options =
			{
				effect = "slideDown",
				time = 400
			}
			physics.pause()
			storyboard.showOverlay("overlay_scene", options)
			menuBool = true
		elseif dist < 20 and menuBool == true then
			print("hide")
			storyboard.hideOverlay("slideUp", 400)
			physics.start()
			menuBool = false
		end
	end
end

local counter = 0
local tapTime = 0
local miniMap = false

-- ball movement control
local function moveBall(event)
	
	local x 
	local y
	local eventTime = event.time
	local tap = 0
		
	--find distance from start touch to end touch
	local dx = event.x - event.xStart
	local dy = event.y - event.yStart

	--checking if touch was a tap touch and not a swipe
	if dx < 5 then
		if dx > -5 then
			if dy < 5 then
				if dy > -5 then
					--print(dx, dy)
					tap = 1
				end
			end
		end
	end

	if event.phase == "ended" then
		if(eventTime - tapTime) < 300 then
			if menuBool == false then
				if miniMap == false then 
					physics.pause()
					storyboard.showOverlay("miniMapLevel1", "fade", 300)
					miniMap = true
				elseif miniMap == true then
					storyboard.hideOverlay("fade", 300)
					physics.start()
					miniMap = false
				end
				print("double tap")
			end
		end
			tapTime = eventTime
	end
		
	if tap == 1 then
		if event.phase == "ended" then
			for count = 1, #ballTable do
		
			-- send mouse/ball position values to distance function
			dist = distance(event.x, ballTable[count].x, event.y, ballTable[count].y, "Mouse to Ball Distance: ")
		
			-- if it is taking too many tries to move the ball, increase the distance <= *value*
			if dist <= 100 then
					x = event.x - ballTable[count].x;
					y = event.y - ballTable[count].y;
					--print (x, y)
						if x < 0 then
						if x > -30 then
							if y > 0 then
								ballTable[count]:applyLinearImpulse(0,-0.05, ballTable[count].x, ballTable[count].y)
							elseif y < 0 then
								ballTable[count]:applyLinearImpulse(0,0.05, ballTable[count].x, ballTable[count].y)
							end
						elseif y >0 then
							if y < 30 then
								ballTable[count]:applyLinearImpulse(0.05, 0, ballTable[count].x, ballTable[count].y)
							else
								ballTable[count]:applyLinearImpulse( 0.05, -0.05 ,ballTable[count].x, ballTable[count].y)
							end
						elseif y < 0 then
							if y > -30 then
								ballTable[count]:applyLinearImpulse(0.05, 0, ballTable[count].x, ballTable[count].y)
							else
								ballTable[count]:applyLinearImpulse( 0.05, 0.05, ballTable[count].x, ballTable[count].y)
							end
						end
					elseif x > 0 then
						if x < 30 then
							if y > 0 then
								ballTable[count]:applyLinearImpulse(0,-0.05, ballTable[count].x, ballTable[count].y)
							elseif y < 0 then
								ballTable[count]:applyLinearImpulse(0,0.05, ballTable[count].x, ballTable[count].y)
							end
						elseif y < 0 then
							if y > -30 then
								ballTable[count]:applyLinearImpulse(-0.05, 0, ballTable[count].x, ballTable[count].y)
							else
								ballTable[count]:applyLinearImpulse( -0.05, 0.05, ballTable[count].x, ballTable[count].y)
							end
						elseif y > 0 then
							if y < 30 then
								ballTable[count]:applyLinearImpulse(-0.05, 0, ballTable[count].x, ballTable[count].y)
							else
								ballTable[count]:applyLinearImpulse( -0.05, -0.05, ballTable[count].x, ballTable[count].y)
							end
						end
					end
				end
			end
		end
	elseif tap == 0 then
		local swipeLength = math.abs(event.x - event.xStart)
		local swipeLengthy = math.abs(event.y - event.yStart)
		--print(event.phase, swipeLength)
		local t = event.target
		local phase = event.phase
		if "began" == phase then
			return true
		elseif "moved" == phase then
		elseif "ended" == phase or "cancelled" == phase then
			local current = storyboard.getCurrentSceneName()
			if current == "level1d" and menuBool == false then
				if event.xStart < event.x and swipeLength > 50 then 
					print( "Swiped Right" )
					saveBallLocation()
					Runtime:removeEventListener("enterFrame", frame)
					storyboard.gotoScene( "level1", "fade", 500 )
				end
			end
		end	
	end
end

local function gameOver(event)
	print("GAMEOVER")
	print("GAMEOVER")
	print("GAMEOVER")
	print("GAMEOVER")
	print("GAMEOVER")
	storyboard.gotoScene( "select", "fade", 500)
	ballVariables.setBall1(25, 25)
end

-- Collision Detection for every frame during game time
local function frame(event)
	local distBH
	
	-- You spin me right round, baby; Right round like a record, baby; Right round round round [BLACKHOLES]
	-- send ball position values and blackholes values to distance function
	for count = 1, #blackholes do
		blackholes[count]:rotate(-24)
		distBH = distance(ballTable[1].x, blackholes[count].x, ballTable[1].y, blackholes[count].y)
		
		if distBH <= 50 then
			--print("DETECTING PULL")
			ballTable[1].hasJoint = true
			ballTable[1]:applyTorque(0.5)
			ballTable[1].rotation = ballTable[1].rotation + 5
			ballTable[1].touchJoint = physics.newJoint("touch", ballTable[1], blackholes[count].x, blackholes[count].y)
			ballTable[1].touchJoint.frequency = 0.5
			ballTable[1].touchJoint.dampingRatio = 0.0
			ballTable[1].touchJoint:setTarget( blackholes[count].x, blackholes[count].y)
		end
		
		if distBH <= 50 and counter == 0 then
			-- Player has 4 seconds to get out of blackhole
			bhtimer = timer.performWithDelay( 4000, gameOver, 0 )
			counter = counter + 1
		end
	end	
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	print("Create C")
	local group = self.view

	-- create a grey rectangle as the backdrop
	-- temp wood background from http://wallpaperstock.net/wood-floor-wallpapers_w6855.html
	local background = display.newImageRect( "background2_d.jpg", screenW+100, screenH)

	background.anchorX = 0.0
	background.anchorY = 0.0
	background.x, background.y = -50, 0
	
	-- all display objects must be inserted into group
	group:insert( background )
	
	for count = 1, #blackholes do
		group:insert(blackholes[count])
	end
	
	group:insert( ballTable[1] )
	
	
	for count = 1, #lines do
		group:insert(lines[count])
	end
	for count = 1, #walls do
		group:insert(walls[count])
	end
	group:insert( menu )

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	counter = 0
	
	print("Enter D")
	
	physics.start()
	
	physics.addBody(ballTable[1], {radius = 15, bounce = .25 })

	ballTable[1]:setLinearVelocity(0,0)
	ballTable[1].angularVelocity = 0
	
	physics.setGravity(0, 0)
	
	Runtime:addEventListener("touch", moveBall)
	Runtime:addEventListener("touch", menuCheck)
	Runtime:addEventListener("enterFrame", frame)
	
end

function scene:willEnterScene( event )

	ballTable[1].x = ballVariables.getBall1x()
	ballTable[1].y = ballVariables.getBall1y()
	--ballTable[2].x = ballVariables.getBall2x()
	--ballTable[2].y = ballVariables.getBall2y()

	-- apply physics to walls
	for count = 1, #walls do
		physics.addBody(walls[count], "static", { bounce = 0.01 } )
	end
	
	-- apply physics to lines
	for count = 1, #lines do
		physics.addBody(lines[count], "static", { bounce = 0.01 } )
	end
	
	print("Entering D")
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	Runtime:removeEventListener("touch", moveBall)
	Runtime:removeEventListener("touch", menuCheck)
	Runtime:removeEventListener("enterFrame", frame)

	-- add physics to the balls
	physics.removeBody(ballTable[1])
	--physics.removeBody(ballTable[2])

	for count = 1, #lines do
		physics.removeBody(lines[count])
	end
	
	for count = 1, #walls do
		physics.removeBody(walls[count])
	end

	if bhtimer then
		timer.cancel(bhtimer)
	end
	
	--physics.pause()

	print("Exit D")
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	print("destroyed D")
	--package.loaded[physics] = nil
	--physics = nil
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "willEnterScene", scene)

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene