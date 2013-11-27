-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget");
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

local ballTable = { 
	[1] = display.newImage("ball.png") } 
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
		
-- Draw Blackholes
local blackholes = {
	[1] = display.newImage("blackhole2.png"),
	[2] = display.newImage("blackhole2.png"),
	[3] = display.newImage("blackhole2.png")
}
		
	blackholes[1].x = 245
	blackholes[1].y = 150
	blackholes[2].x = 465
	blackholes[2].y = 270
	blackholes[3].x = 0
	blackholes[3].y = 270

-- Draw Treasure Chests
local chests = {
	[1] = display.newImage("chest2.png")
}
	chests[1].x = 130
	chests[1].y = 50
	chests[1].rotation = -90
	
-- Draw Keys
--     Temp art from: http://www.clker.com/cliparts/M/Q/n/y/v/q/jail-house-key-th.png
local keys = {
	[1] = display.newImage("key.png")
}
	keys[1]:scale(0.6, 0.6)
	keys[1].x = 465
	keys[1].y = 205
	
local boostPlat = {
	[1] = display.newImage("boost_platform.png")
}
	boostPlat[1]:scale(0.8, 0.8)
	boostPlat[1].x = 360
	boostPlat[1].y = 230 

local crates = {
	[1] = display.newImage("crate.png")
}
	crates[1]:scale(0.9, 0.9)
	crates[1].x = 25
	crates[1].y = 100
	
-- Draw gem
local gems = {
	[1] = display.newImage("star2.png")
}
	gems[1].x = chests[1].x
	gems[1].y = chests[1].y
	gems[1]:setFillColor(0, 1, 0)
	gems[1].alpha = 0

-- Draw lines
local lines = {
	-- newRect(left, top, width, height)
	-- Rectangles for inital pane on 
	-- left and right side
	
	-- vertical
	[1] = display.newRect(90, 50, 20, 100) ,
	[3] = display.newRect(155, 130, 20, 65),
	[4] = display.newRect(415, 180, 20, 350),
	
	--diagonal
	[6] = display.newRect(130, 200, 20, 100),
	
	--horizontal
	[2] = display.newRect(123, 100, 85, 20),
	[5] = display.newRect(10, 160, 120, 20),
	[7] = display.newRect(210, 240, 200, 20)
}

	lines[6].rotation = 35

	for count = 1, #lines do
		lines[count]:setFillColor(0, 0, 0)
	end

local xdirection,ydirection = 1,1
local xpos,ypos
local arrow = display.newImage("boost_arrow.png");
      arrow.x = 360
	  arrow.y = 275
	  
local animationLine = display.newRect(345, 150, 85, 20)
	  animationLine.alpha = 0
	
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

local function animate(event)
    local dist
	
    ypos = 5 + (ydirection * 0.00001);
 
	dist = distance(arrow.x, animationLine.x, arrow.y, animationLine.y)
	
	if dist < 50 then
		arrow.x = 360
		arrow.y = 275
	end
		
    arrow:translate( 0, -ypos/2)
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
				if current == "level1c" and menuBool == false then
					if event.yStart < event.y and swipeLengthy > 50 then
						print( "Swiped Up" )
						saveBallLocation()
						Runtime:removeEventListener("enterFrame", frame)
						storyboard.gotoScene( "level1", "fade", 500 )
					end	
				end
			end	
		end
	end

-- Collision Detection for every frame during game time
local function frame(event)
	local dist
	
	-- send ball position values and blackholes values to distance function
	for count = 1, #blackholes do
		blackholes[count]:rotate(-24)
		dist = distance(ballTable[1].x, blackholes[count].x, ballTable[1].y, blackholes[count].y)
		
		-- When less than distance of 35 pixels, do something
		-- 			Used print as testing. Works successfully!
		if dist <= 35 then
			print("GAMEOVER")
			print("GAMEOVER")
			print("GAMEOVER")
			print("GAMEOVER")
			print("GAMEOVER")
			storyboard.gotoScene( "select", "fade", 500)
		end
	end
	
	for count = 1, #chests do
		distChest = distance(ballTable[1].x, chests[count].x, ballTable[1].y, chests[count].y)
		
		if distChest <= 50 and inventory ~= 1 and inventory == 3 then
			print("inventory =", inventory)
			chests[1]:removeSelf()
			chests[1] = nil
			gems[1].alpha = 1
		--else
		--	physics.addBody(chests[1], {radius = 15, bounce = .25 })
		end
	end
	
		-- Ball vs Boost Platform
	for count = 1, #boostPlat do
		distBP = distance(ballTable[count].x, boostPlat[count].x, ballTable[count].y, boostPlat[count].y)
	end
	
	-- When less than distance of 35 pixels, do something
	-- 			Used print as testing. Works successfully!
	for count = 1, #ballTable do
		if distBP <= 55 then
			ballTable[count]:applyLinearImpulse(0, -0.05, ballTable[count].x, ballTable[count].y)
		end
	end
	
	--
	-- Ball vs Key
	for count = 1, #keys do
		distKey = distance(ballTable[1].x, keys[count].x, ballTable[1].y, keys[count].y)
		if distKey < 50 and inventory ~= 3 then
			print("DESTROY KEY")
			keys[1]:removeSelf()
			keys[1] = nil
			inventory = 1
			print(inventory)
		end
	end
	
	for count = 1, #gems do
		distGem = distance(ballTable[1].x, gems[count].x, ballTable[1].y, gems[count].y)
		
		if distGem <= 35 then
			gems[1]:removeSelf()
			gems[1] = nil
			inventory = 4
		end
	end
	
	if gems[1] then
		gems[1]:rotate(5)
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	print("Create C")
	local group = self.view

	-- create a grey rectangle as the backdrop
	-- temp wood background from http://wallpaperstock.net/wood-floor-wallpapers_w6855.html
	local background = display.newImageRect( "background2_c.jpg", screenW+100, screenH)
	--background:setReferencePoint( display.TopLeftReferencePoint )
	background.anchorX = 0.0
	background.anchorY = 0.0
	background.x, background.y = -50, 0

	-- all display objects must be inserted into group
	
	group:insert( background )
		
	for count = 1, #blackholes do
		group:insert(blackholes[count])
	end
	
	for count = 1, #boostPlat do
		group:insert(boostPlat[count])
	end
	
	for count = 1, #crates do
		group:insert(crates[count])
	end
	
	for count = 1, #chests do
		group:insert(chests[count])
	end
	
	group:insert( keys[1] )
	group:insert( arrow )
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

	print("Enter C")

	physics.start()
	physics.addBody(ballTable[1], {radius = 15, bounce = .25 })

	ballTable[1]:setLinearVelocity(0,0)
	ballTable[1].angularVelocity = 0
	
	physics.setGravity(0, 0)

	Runtime:addEventListener( "enterFrame", animate );
	Runtime:addEventListener("touch", moveBall)
	Runtime:addEventListener("touch", menuCheck)
	Runtime:addEventListener("enterFrame", frame)
	
end

function scene:willEnterScene( event )

	ballTable[1].x = ballVariables.getBall1x()
	ballTable[1].y = ballVariables.getBall1y()

	-- apply physics to wall
	for count = 1, #walls do
		physics.addBody(walls[count], "static", { bounce = 0.01 } )
	end
	
	for count = 1, #lines do 
		physics.addBody(lines[count], "static", { bounce = 0.01 } )
	end

	for count = 1, #crates do 
		physics.addBody(crates[count], "static", { bounce = 0.01 } )
	end
	
	for count = 1, #chests do 
		physics.addBody(chests[count], "static", { bounce = 0.01 } )
	end

	print("Entering C")
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	Runtime:removeEventListener( "enterFrame", animate );
	Runtime:removeEventListener("touch", moveBall)
	Runtime:removeEventListener("touch", menuCheck)
	Runtime:removeEventListener("enterFrame", frame)

	physics.removeBody(ballTable[1])

	for count = 1, #lines do 
		physics.removeBody(lines[count])
	end
	
	for count = 1, #walls do
		physics.removeBody(walls[count])
	end
	
	for count = 1, #crates do
		physics.removeBody(crates[count])
	end
	
	for count = 1, #chests do
		physics.removeBody(chests[count])
	end
	
	--physics.pause()
	
	print("Exit C")
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	print("destroyed C")
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