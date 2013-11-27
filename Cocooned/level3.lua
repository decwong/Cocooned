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
--

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

doorOpen = false
switchOpen = false  

-- make a crate (off-screen), position it, and rotate slightly
local ballTable = { 
		[1] = display.newImage("ball.png")
	}
		--[2] = display.newImage("ball.png") }

		
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
	-- Rectangles for inital pane on 
	-- left and right side
	[1] = display.newRect(70, 180, 20, 575) ,
	[2] = display.newRect(410, 180, 20, 575) ,
	[3] = display.newRect(305, 55, 25, 75) ,
	[4] = display.newRect(170, 265, 25, 75)
}

local star1 = display.newImage("star.png")
star1.x = 125; star1.y = 260

local star2 = display.newImage("star.png")
star2.x = 350; star2.y = 50
		
-- distance function
local function distance(x1, x2, y1, y2)
	local dist
	dist = math.sqrt( ((x2-x1)^2) + ((y2-y1)^2) )
	return dist
end

local function saveBallLocation()
	ballVariables.setBall1(ballTable[1].x, ballTable[1].y)
	--ballVariables.setBall2(ballTable[2].x, ballTable[2].y)
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
			for count = 1, #ballTable, 1 do
		
			-- send mouse/ball position values to distance function
			dist = distance(event.x, ballTable[count].x, event.y, ballTable[count].y)
			
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
			if current == "level3" then
				if event.xStart > event.x and swipeLength > 50 then 
					print("Swiped Left")
					saveBallLocation()
					Runtime:removeEventListener("enterFrame", frame)
					storyboard.gotoScene( "level3d", "fade", 500 )
				elseif event.xStart < event.x and swipeLength > 50 then 
					print( "Swiped Right" )
					saveBallLocation()
					Runtime:removeEventListener("enterFrame", frame)
					storyboard.gotoScene( "level3b", "fade", 500 )
				elseif event.yStart > event.y and swipeLengthy > 50 then
					print( "Swiped Down" )
					saveBallLocation()
					Runtime:removeEventListener("enterFrame", frame)
					storyboard.gotoScene( "level3c", "fade", 500 )
				elseif event.yStart < event.y and swipeLengthy > 50 then
					print( "Swiped Up" )
					--ballTable[1]:setLinearVelocity(0,0)
					--ballTable[1].angularVelocity = 0
					--ballTable[2]:setLinearVelocity(0,0)
					--ballTable[2].angularVelocity = 0
					saveBallLocation()
					Runtime:removeEventListener("enterFrame", frame)
					storyboard.gotoScene( "level3a", "fade", 500 )
				end	
			end
		end	
	end
end


-- accelerometer movement
local function onAccelerate( event )
	local xGrav=1
	local yGrav=1
	if event.yInstant > 0.1 then
		xGrav = -1
	elseif event.yInstant < -0.1 then
		xGrav = 1
	elseif event.yGravity > 0.1 then
		xGrav = -1
	elseif event.yGravity < -0.1 then
		xGrav = 1
		else
			xGrav = 0
	end
	if event.xInstant > 0.1 then
		yGrav = -1
	elseif event.xInstant < -0.1 then
		yGrav = 1
	elseif event.xGravity > 0.1 then
		yGrav = -1
	elseif event.xGravity < -0.1 then
		yGrav = 1
		else
			yGrav = 0
	end
	physics.setGravity(12*xGrav, 16*yGrav)
end

function distanceFrom(x1, x2, y1, y2)
	return math.sqrt((x2-x1)^2+(y2-y1)^2)
end

-- Collision Detection for every frame during game time
local function frame(event)
	-- send both ball position values to distance function
	--distance(ballTable[1].x, ballTable[2].x, ballTable[1].y, ballTable[2].y)
	
	-- When less than distance of 35 pixels, do something
	-- 			Used print as testing. Works successfully!
	--if dist <= 35 then
	--	print("Distance =", dist)
	--end


	--commented out because ballTable[2] giving error
	--[[
	if distanceFrom(ballTable[1], star1) < 30 or distanceFrom(ballTable[2], star1) < 30 then
		star1Check = true
	end
	if distanceFrom(ballTable[1], star2) < 30 or distanceFrom(ballTable[2], star2) < 30 then
		star2Check = true
	end 
	]]

	
	if star1Check and star2Check then
		storyboard.gotoScene("select", "fade", 500)
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	print("Create MAIN")
	local group = self.view

	-- create a grey rectangle as the backdrop
	-- temp wood background from http://wallpaperstock.net/wood-floor-wallpapers_w6855.html
	local background = display.newImageRect( "background2.jpg", screenW+100, screenH)

	background.anchorX = 0.0
	background.anchorY = 0.0
	background.x, background.y = -50, 0
	
		accelerometerON = true
	if accelerometerON == true then
		Runtime:addEventListener( "accelerometer", onAccelerate )
	end

	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( ballTable[1] )
	--group:insert( ballTable[2] )
	group:insert( star1)
	group:insert( star2)
	
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

	print("Enter MAIN")

	physics.start()
	physics.addBody(ballTable[1], {radius = 15, bounce = .25 })
	--physics.addBody(ballTable[2], {radius = 15, bounce = .8 })

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
	--ballTable[2].x = ballVariables.getBall2x()
	--ballTable[2].y = ballVariables.getBall2y()

	print("Entering MAIN")
end

function scene:overlayBegan( event )
	print( "Showing overlay: " .. event.sceneName)
end

function scene:overlayEnded( event )
	print( "Overlay removed: " .. event.sceneName)
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	Runtime:removeEventListener("touch", moveBall)
	Runtime:removeEventListener("touch", menuCheck)
	Runtime:removeEventListener("enterFrame", frame)

	physics.removeBody(ballTable[1])
	--physics.removeBody(ballTable[2])

	--print(ballVariables.getBall1x(), ballVariables.getBall1y(), ballVariables.getBall2x(), ballVariables.getBall2y())

	for count = 1, #lines do
		physics.removeBody(lines[count])
	end
	
	for count = 1, #walls do
		physics.removeBody(walls[count])
	end

	menuBool = false
	
	--physics.pause()
	
	print("Exit MAIN")
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	print("destroyed MAIN")
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

scene:addEventListener( "willEnterScene", scene)

-- "overlay" events is dispatched whenever scene is paused
scene:addEventListener( "overlayBegan" ) 

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

scene:addEventListener( "overlayEnded" )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene