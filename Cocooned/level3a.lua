-----------------------------------------------------------------------------------------
--
-- level3.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget");
require("ballVariables")

local font = "Helvetica" or system.nativeFont;
display.setStatusBar(display.HiddenStatusBar )

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()
-- Set view mode to show bounding boxes 
--physics.setDrawMode("hybrid")

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-- Boolean to see if switch is pressed
local secondBall = false 

-- Check to see if second ball has been created
local secondBallActive = false 

-- Check to see if the switch has appeared
local switchAlive = false

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

local ballTable = { 
	[1] = display.newImage("ball.png"),
	[2] = display.newImage("ball.png")
}
ballTable[2].alpha = 0

ballTable[2].alpha = 0

local switch = display.newImage("switch.png")
	print("initialize switch")
	switch.x = 130; switch.y = 40
	print("showing switch")
	switch.alpha = 0

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

-- Draw lines
local lines = {
	-- newRect(left, top, width, height)
	-- Rectangles for top area of the screen
	[1] = display.newRect(200, 75, 250, 25) ,
	[2] = display.newRect(90, 40, 25, 50) ,
	[3] = display.newRect(250, 150, 50, 50)
}

-- Get the distance from the switch to another object 
local switchDist

local function switchDistance(x1, x2, y1, y2, detectString)
	return math.sqrt( ((x2-x1)^2) + ((y2-y1)^2) )
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

local tapTime = 0
local miniMap = false

local function saveBallLocation()
	ballVariables.setBall1(ballTable[1].x, ballTable[1].y)

	ballVariables.setBall2(ballTable[2].x, ballTable[2].y)
	ballVariables.setBall2Visible(secondBallActive)
end

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
					storyboard.showOverlay("miniMapLevel3", "fade", 300)
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
		local ballCount = 1
		if secondBallActive == true then
			ballCount = 2
		end
			for count = 1, ballCount, 1 do
		
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
			if current == "level3a" then
				if event.yStart > event.y and swipeLengthy > 50 then
					print( "Swiped Up" )
					saveBallLocation()
					Runtime:removeEventListener("enterFrame", frame)
					storyboard.gotoScene( "level3", "fade", 100 )
				end	
			end
		end	
	end
end

local function getSwitch()
	local switch = display.newImage("switch.png")
	print("initialize switch")
	switch.x = 130; switch.y = 40
	print("showing switch")
end

-- Collision Detection for every frame during game time
local function frame(event)

	-- send both ball position values to distance function
	--distance(ballTable[1].x, ballTable[2].x, ballTable[1].y, ballTable[2].y)

	-- Check to see if the ball has collided with the switch
		switchDist = switchDistance(ballTable[1].x, switch.x, ballTable[1].y, switch.y)
		-- If they collide, set this flag to true
		if (switchDist <= 35) then
			print("switch pressed")
			secondBall = true 
			-- Check to make sure we aren't creating multiple balls
			if (secondBallActive == false) then 
				-- Display new ball
				--[[
				local ballTable = {
					[2] = display.newImage("ball.png")
				}
				ballTable[2].x = 100
				ballTable[2].y = 100
				-- Add ball physics and set flag to prevent additional balls from spawning
				physics.addBody(ballTable[2], {radius = 15, bounce = .8 })
				secondBallActive = true
				self.view.insert(ballTable[2])
				]]
				ballTable[2].x = 100
				ballTable[2].y = 100
				ballTable[2].alpha = 1.0
				physics.addBody(ballTable[2], {radius = 15, bounce = .25 })
				secondBallActive = true
			end
		end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	print("Create A")
	local group = self.view

	-- create a grey rectangle as the backdrop
	-- temp wood background from http://wallpaperstock.net/wood-floor-wallpapers_w6855.html
	local background = display.newImageRect( "background2_a.jpg", screenW+100, screenH)

	background.anchorX = 0.0
	background.anchorY = 0.0
	background.x, background.y = -50, 0
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( ballTable[1] )
	group:insert( ballTable[2] )

	--group:insert(switch)

	-- If the switch is pressed, add 
	-- a second ball to the pane
	if (secondBall == true) then
		group:insert(ballTable[2])
	end
	
	for count = 1, #lines do
		group:insert(lines[count])
	end
	for count = 1, #walls do
		group:insert(walls[count])
	end
	group:insert( menu )

	if switchOpenA == true then 
		print("showing switch")
		group:insert( switch)
		switch.alpha = 1
	end

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	print("Enter A")

	physics.start()
	physics.addBody(ballTable[1], {radius = 15, bounce = .25 })

	if(ballVariables.isBall2Visible() == true) then
		physics.addBody(ballTable[2], {radius = 15, bounce = .8 })
		ballTable[2].alpha = 1
	else
		ballTable[2].alpha = 0
	end

	-- apply physics to walls
	for count = 1, #walls do
		physics.addBody(walls[count], "static", { bounce = 0.01 } )
	end
	
	for count = 1, #lines do 
		physics.addBody(lines[count], "static", { bounce = 0.01 } )
	end

	Runtime:addEventListener("touch", moveBall)
	Runtime:addEventListener("touch", menuCheck)
	Runtime:addEventListener("enterFrame", frame)

	physics.setGravity(0, 0)
	
end

function scene:willEnterScene( event )

	ballTable[1].x = ballVariables.getBall1x()
	ballTable[1].y = ballVariables.getBall1y()
	ballTable[2].x = ballVariables.getBall2x()
	ballTable[2].y = ballVariables.getBall2y()

	print("before creating switch")
	print(switchOpenA)

	--[[if switchOpenA then 
		switch.alpha = 1
	elseif switchOpenA == false then
		switch.alpha = 0
	end 
	]]
end

--rectangle-based collision detection
local function hasCollided( ballTable, switch )
   if ( crate == nil ) then  --make sure the first object exists
      return false
   end
   if ( switch == nil ) then  --make sure the other object exists
      return false
   end

   if ballTable[1].contentBounds.xMin <= switch.contentBounds.xMin and ballTable[1].contentBounds.xMax >= switch.contentBounds.xMin then
   	return true
   end
   if ballTable[1].contentBounds.xMin >= switch.contentBounds.xMin and ballTable[1].contentBounds.xMin <= switch.contentBounds.xMax then
   	return true
   end
   if ballTable[1].contentBounds.yMin <= switch.contentBounds.yMin and ballTable[1].contentBounds.yMax >= switch.contentBounds.yMin then
   	return true
   end
   if ballTable[1].contentBounds.yMin >= switch.contentBounds.yMin and ballTable[1].contentBounds.yMin <= switch.contentBounds.yMax then
   	return true
   end

   --return (left or right) and (up or down)
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	Runtime:removeEventListener("touch", moveBall)
	Runtime:removeEventListener("touch", menuCheck)
	Runtime:removeEventListener("enterFrame", frame)

	physics.removeBody(ballTable[1])
	if(ballVariables.isBall2Visible() == true) then
		physics.removeBody(ballTable[2])
	end
	-- If the switch is pressed, add 
	-- the second ball's physics to the pane
	if (secondBall == true) then
		physics.removeBody(ballTable[2])
	end

	for count = 1, #lines do
		physics.removeBody(lines[count])
	end

	for count = 1, #walls do
		physics.removeBody(walls[count])
	end
	
	menuBool = false
		
	print("Exit A")
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	print("destroyed A")
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