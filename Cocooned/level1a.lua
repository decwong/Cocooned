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

-- make a crate (off-screen), position it, and rotate slightly
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


-- Draw Blackholes
local blackholes = {
	[1] = display.newImage("blackhole2.png"),
	[2] = display.newImage("blackhole2.png")
}
		
	blackholes[1].x = 115
	blackholes[1].y = 50
		
	blackholes[2].x = 365
	blackholes[2].y = 275

local crates = {
	[1] = display.newImage("crate.png"),
	[2] = display.newImage("crate.png")
}	
	crates[1].x = 15
	crates[1].y = 265
	crates[2].x = 460
	crates[2].y = 55
	

-- Draw Treasure Chests
local chests = {
	[1] = display.newImage("chest.png")
}
	
	chests[1].x = 245
	chests[1].y = 150
	
-- Draw gem
--		Temp art from:	http://sweetclipart.com/colorful-neon-gemstones-886	
local gems = {
	[1] = display.newImage("star2.png")
}
	gems[1].x = chests[1].x
	gems[1].y = chests[1].y
	gems[1].alpha = 0

-- Draw Menu Button
local menu = display.newImage("floor.png")
	menu.x = 245
	menu.y = 10

	
-- Draw lines
local lines = {
	-- newRect(left, top, width, height)
	-- Rectangles for pane on 
	-- left and right side
	[1] = display.newRect(70, 120, 20, 220) ,
	[2] = display.newRect(410, 200, 20, 220)
	
}

	for count = 1, #lines do
		lines[count]:setFillColor(0, 0, 0)
	end
		
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
			if current == "level1a" and menuBool == false then
				if event.yStart > event.y and swipeLengthy > 50 then
					print( "Swiped Up" )
					--ballTable[1]:setLinearVelocity(0,0)
					--ballTable[1].angularVelocity = 0
					--ballTable[2]:setLinearVelocity(0,0)
					--ballTable[2].angularVelocity = 0
					saveBallLocation()
					Runtime:removeEventListener("enterFrame", frame)
					storyboard.gotoScene( "level1", "fade", 500)
				end	
			end
		end	
	end
end

local function gameOver(event)
	print("GAMEOVER")
	print("GAMEOVER")
	storyboard.gotoScene( "select", "fade", 500)
	storyboard.removeScene("level1")
	storyboard.removeScene("level1a")
	storyboard.removeScene("level1b")
	storyboard.removeScene("level1c")
	storyboard.removeScene("level1d")
	ballVariables.setBall1(25, 25)
end

-- Collision Detection for every frame during game time
local function frame(event)
	local dist
	local distChest
	local distGem
	
	-- send ball position values and blackholes values to distance function
	for count = 1, #blackholes do
		blackholes[count]:rotate(-24)
		dist = distance(ballTable[1].x, blackholes[count].x, ballTable[1].y, blackholes[count].y)
		
		if dist <= 50 then
			--print("DETECTING PULL")
			ballTable[1].hasJoint = true
			ballTable[1]:applyTorque(0.5)
			ballTable[1].rotation = ballTable[1].rotation + 5
			ballTable[1].touchJoint = physics.newJoint("touch", ballTable[1], blackholes[count].x, blackholes[count].y)
			ballTable[1].touchJoint.frequency = 0.3
			ballTable[1].touchJoint.dampingRatio = 0.0
			ballTable[1].touchJoint:setTarget( blackholes[count].x, blackholes[count].y)
		end
		
		if dist <= 50 and counter == 0 then
			-- Player has 4 seconds to get out of blackhole
			bhtimer = timer.performWithDelay( 4000, gameOver, 0 )
			counter = counter + 1
		end
	end
	
	for count = 1, #chests do
		distChest = distance(ballTable[1].x, chests[count].x, ballTable[1].y, chests[count].y)
		
		if distChest <= 50 and myData.inventory == 1 then
			print("inventory =", myData.inventory)
			chests[1]:removeSelf()
			chests[1] = nil
			gems[1].alpha = 1
		--else
		--	physics.addBody(chests[1], {radius = 15, bounce = .25 })
		end
	end
	
	for count = 1, #gems do
		distGem = distance(ballTable[1].x, gems[count].x, ballTable[1].y, gems[count].y)
		
		if distGem <= 35 then
			gems[1]:removeSelf()
			gems[1] = nil
			myData.inventoryGem2 = 1
			myData.inventory = 0
		end
	end
	
	if gems[1] then
		gems[1]:rotate(5)
	end
	
	if myData.inventoryGem1 and myData.inventoryGem2 then
		print("GAMEOVER")
		print("GAMEOVER")
		storyboard.gotoScene( "select", "fade", 500)
		ballVariables.setBall1(25, 25)
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

	--group:insert( ballTable[2] )
	

	for count = 1, #blackholes do
		group:insert(blackholes[count])
	end
	
	for count = 1, #crates do
		crates[count]:scale(0.8, 0.8)
		group:insert(crates[count])
	end
	
	for count = 1, #chests do
		group:insert(chests[count])
	end
	
	group:insert( ballTable[1] )
	
	for count = 1, #lines do
		group:insert(lines[count])
	end
	for count = 1, #walls do
		group:insert(walls[count])
	end
	
	group:insert( menu )
	group:insert( gems[1])


end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	counter = 0
	
	print("Enter A")

	physics.start()
	physics.addBody(ballTable[1], {radius = 15, bounce = .25 })
	--physics.addBody(ballTable[2], {radius = 15, bounce = .25 })

	ballTable[1]:setLinearVelocity(0,0)
	ballTable[1].angularVelocity = 0
	--ballTable[2]:setLinearVelocity(0,0)
	--ballTable[2].angularVelocity = 0

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

	-- apply physics to walls
	for count = 1, #walls do
		physics.addBody(walls[count], "static", { bounce = 0.01 } )
	end
	
	for count = 1, #crates do
		physics.addBody(crates[count], "static", { bounce = 0.01 } )
	end
	
	for count = 1, #lines do 
		physics.addBody(lines[count], "static", { bounce = 0.01 } )
	end

	if chests[1] then
		physics.addBody(chests[1], "static", { bounce = .25 })
	end
	
	print("Entering A")
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

	for count = 1, #chests do
		physics.removeBody(chests[count])
	end
	
	for count = 1, #blackholes do
		physics.removeBody(blackholes[count])
	end
	
	for count = 1, #crates do
		physics.removeBody(crates[count])
	end
	
	for count = 1, #lines do
		physics.removeBody(lines[count])
	end

	for count = 1, #walls do
		physics.removeBody(walls[count])
	end
		
	menuBool = false
	
	physics.pause()
	
	if bhtimer then
		timer.cancel(bhtimer)
	end
	
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