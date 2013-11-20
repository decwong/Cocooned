-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

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

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- create a grey rectangle as the backdrop
	-- temp wood background from http://wallpaperstock.net/wood-floor-wallpapers_w6855.html
	local background = display.newImageRect( "background2.jpg", screenW+100, screenH)
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = -50, 0
	
	-- make a crate (off-screen), position it, and rotate slightly
	local ballTable = { 
		[1] = display.newImage("ball.png"), 
		[2] = display.newImage("ball.png") }
	
	ballTable[1].x = 260
	ballTable[1].y = 180
	ballTable[2].x = 160
	ballTable[2].y = 180
	
	-- add physics to the crate
	physics.addBody(ballTable[1])
	physics.addBody(ballTable[2])
	
	-- add new walls
	-- temp wall image from: http://protextura.com/wood-plank-cartoon-11130
	local walls = {
		[1] = display.newImage("ground1.png"),
		[2] = display.newImage("ground1.png"),
		[3] = display.newImage("ground2.png"),
		[4] = display.newImage("ground2.png"), 
		[5] = display.newImage("ground1.png"), 
		[6] = display.newImage("ground1.png") }
	
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

	-- Middle wall
	walls[5].x = 350
	walls[5].y = 100

	walls[6].x = 350
	walls[6].y = 250
	
	-- apply physics to wall
	for count = 1, 6, 1 do
		physics.addBody(walls[count], "static", { bounce = 0.01 } )
	end
			
	-- ball movement control
	function moveBall(event)
		local x 
		local y
		
		-- setup distance formula [ball vs mouse pointer]
		local x1
		local x2
		local y1
		local y2
		local distance
			
		
		for count = 1, 2, 1 do
		
			-- more distance formula setup
			x2 = ballTable[count].x
			x1 = event.x
			y2 = ballTable[count].y
			y1 = event.y
			distance = math.sqrt( ((x2-x1)^2) + ((y2-y1)^2) )
			print("Mouse to Ball Distance:", distance)
		
			-- if it is taking too many tries to move the ball, increase the distance <= *value*
			if distance <= 100 then
				if event.phase == "ended" then
					x = event.x - ballTable[count].x;
					y = event.y - ballTable[count].y;
					print (x, y)

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
	end
		
	-- Collision Detection for every frame during game time
	local function frame(event)
		-- Establish variables
		local x1, x2
		local y1, y2
		local distance
			
		-- Assign variables ball values for distance formula
		x1 = ballTable[1].x
		x2 = ballTable[2].x
		y1 = ballTable[1].y
		y2 = ballTable[2].y
		
		-- Distance formula
		distance = math.sqrt( ((x2-x1)^2) + ((y2-y1)^2))
		
		-- When less than distance of 35 pixels, do something
		-- 			Used print as testing. Works successfully!
		if distance <= 35 then
			print("Distance =", distance)
		end
	end
	
	-- Real time event listeners/activators
	Runtime:addEventListener("touch", moveBall)
	Runtime:addEventListener("enterFrame", frame)
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( ballTable[1] )
	group:insert( ballTable[2] )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
	
	physics.setGravity(0, 0)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene