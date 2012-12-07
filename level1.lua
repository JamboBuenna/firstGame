-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local gg = require("golemgravity")
local xGrav, yGrav=0, 0

local scene = storyboard.newScene()
 

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

cameraPositionX = 0
cameraPositionY = 0

local shipPositionX = 500
local shipPositionY = 450

cameraUpdate = 0



--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5

local hiddenJetStream = true



local turnLeftState = false
local turnRightState = false
local goForwardState = false

_m=math.random

local function buildLoadingScreen ()
    loadingText = display.newText( "Building galaxy", 0, 0, "Helvetica", 30 )
    loadingText:setTextColor(255, 255, 255)
    loadingText:setReferencePoint( display.CenterReferencePoint )
    loadingText.x = display.contentWidth * 0.5
    loadingText.y = 200
end


local function buildStarsFunction ()
    
    maxstars = 10000
    
    
    	percentageLoaded = 0
        
        --displayGroup:insert(waitingText)
    
        stars = {}
        circles= {}

        for f=1, maxstars do
            
            
             local xStar =  math.random (-10000,10000)
             local yStar =  math.random (-10000, 10000)
             
             circles[f] = display.newCircle(0, 0, 2)
             
             circles[f].x, circles[f].y = xStar - 150, yStar - 150 
             backgroundGroup:insert(circles[f])
             
             --myCircle:setFillColor(128,128,128)
             
    
            
            --stars[f]= display.newImage("arrow.png")
            
            if f < 4000 then
                stars[f] = display.newImageRect( "starImage.png", 70, 70 ) 
            else
                stars[f] = display.newImageRect( "starImage.png", 35, 35 ) 
            end
            
            
            
            
            stars[f].x, stars[f].y = xStar, yStar
            
            --stars[f].x, stars[f].y = 0, 0
            
            backgroundGroup:insert(stars[f])
            
            loadingText.isVisible = false
        end
    
   
    
end

local function updateJetGroup ()
        
    local jetLength = 50
    local positionAngle
    
    positionAngle = ship.rotation
    
        
    -- Start making position Angle give me the direction the object is pointing not amount of rotations
    while positionAngle > 360 do

    positionAngle = positionAngle - 360

    end


    while positionAngle < 0 do

    positionAngle = positionAngle + 360

    end

    --End changes to position angle
   
    local radianAngle = positionAngle * 0.0174532925
        
    --Update position 


    flameGroup.y = ship.y + math.cos(radianAngle)* jetLength
    flameGroup.x = ship.x - math.sin(radianAngle) * jetLength 

    flameGroup.rotation  = radianAngle * 57.2957795131
end

local function updateJetTrail (jetState)
    
    if jetState == true then
        
        flameTrail.isVisible = true
    else
            flameTrail.isVisible = false          
    end
end

local function buildWallpaper ()
    
    
    
end

local function goForwardFunction()
    
    
    local multiplyY = 1
    local multiplyX = 1
    local positionAngle
    local moveY = 0
    local moveX = 0
    
    positionAngle = ship.rotation
    
        
        -- Start making position Angle give me the direction the object is pointing not amount of rotations
        while positionAngle > 360 do
        
        positionAngle = positionAngle - 360
        
        end
        
        
        while positionAngle < 0 do
        
        positionAngle = positionAngle + 360
        
        end
        
        --End changes to position angle
   
    local radianAngle = positionAngle * 0.0174532925

    speed = 1

    moveY = math.cos(radianAngle)* speed
    moveX = math.sin(radianAngle) * speed 

    moveY =moveY * -1
    
  ship:applyLinearImpulse( moveX, moveY, ship.x, ship.y )
  
   
   updateJetTrail(true)
   
end


local function updateShipLogic()
    
localToMoveX = ship.x - shipPositionX
localToMoveY = ship.y - shipPositionY



ship.x = shipPositionX
ship.y = shipPositionY

cameraPositionX = cameraPositionX - localToMoveX
displayGroup.x = cameraPositionX

cameraPositionY = cameraPositionY - localToMoveY
displayGroup.y = cameraPositionY

shipPositionX = shipPositionX + localToMoveX
shipPositionY = shipPositionY + localToMoveY

ship.x = shipPositionX
ship.y = shipPositionY

--displayGroup.x = displayGroup.x - localToMoveX
--displayGroup.y = displayGroup.y - localToMoveY

--ship.x = ship.x - (localToMoveX * 2)
--ship.y = ship.y - (localToMoveY * 2)


   --ship.x = shipPositionX + localToMoveX
   --ship.y =shipPositionY  + localToMoveY
   
    
    --print("x")
    --print(displayGroup.x)
    
    --print("y")
    --print(displayGroup.y)
end

local function asteroidsLogic(movedObject)
    --This checks that the ship is not off the screen and if it is fires the appropriate function calls
    
    --Left side
    if movedObject.x < 0 then
        
        movedObject.x = screenW
    end
    
    --Right side
     if movedObject.x > screenW then --If  x is greater than the width of the screen
        movedObject.x = 0
    end
    
    
    --Top side
     if movedObject.y < 0 then
        movedObject.y = screenH
    end
    
    
    --Bottom side
     if movedObject.y > screenH then -- If y is greated than the height of the screen
       movedObject.y = 0
    end
end



local function controlLoop()
    
    updateJetGroup()
  
  if turnLeftState == true then
      
      ship.angularVelocity = ship.angularVelocity - 10
      rightFlameTrail.isVisible = true
      
  else
      
      rightFlameTrail.isVisible = false
      
    end
        
    if turnRightState == true then
    
        ship.angularVelocity = ship.angularVelocity + 10
        leftFlameTrail.isVisible = true
    
    else
        
        leftFlameTrail.isVisible = false
    
    end
    
if goForwardState == true then

goForwardFunction()

else
    updateJetTrail(false)
end

local spinFriction = 2

-- A bit of friction for the spin 

if ship.angularVelocity > 0 then
    ship.angularVelocity = ship.angularVelocity - spinFriction    
end

if ship.angularVelocity < 0 then
    ship.angularVelocity = ship.angularVelocity + spinFriction   
end

end




-----------------------------------------------------------------------------------------
-- BEGINNING OF IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

timer.performWithDelay( 60, controlLoop, 0 )
timer.performWithDelay(15, updateShipLogic, 0)

-----------------------------------------------------------------------------------------
--
-- START THE CONTROL BUTTON LISTENERS NOW
--
-----------------------------------------------------------------------------------------

local function onLeftButtonTouch( self, event )
    if event.phase == "began" then

        -- specify the global touch focus
                
                turnLeftState = true
                
                
        display.getCurrentStage():setFocus( self )
        self.isFocus = true
		

    elseif self.isFocus then
        if event.phase == "moved" then

            -- do something here; or not
            
        elseif event.phase == "ended" or event.phase == "cancelled" then
            
		turnLeftState = false
            -- reset global touch focus
            display.getCurrentStage():setFocus(nil)
            self.isFocus = nil
        end
    end

    return true
end

local function onRightButtonTouch( self, event )
    if event.phase == "began" then

        -- specify the global touch focus
		
		turnRightState = true
        display.getCurrentStage():setFocus( self )
        self.isFocus = true

    elseif self.isFocus then
        if event.phase == "moved" then

            -- do something here; or not

        elseif event.phase == "ended" or event.phase == "cancelled" then

		turnRightState = false
            -- reset global touch focus
            display.getCurrentStage():setFocus( nil )
            self.isFocus = nil
        end
    end

    return true
end

local function onForwardButtonTouch( self, event )
    if event.phase == "began" then

        -- specify the global touch focus
        goForwardState = true
        
        display.getCurrentStage():setFocus( self )
        self.isFocus = true

    elseif self.isFocus then
        if event.phase == "moved" then

            -- do something here; or not

        elseif event.phase == "ended" or event.phase == "cancelled" then
        
            goForwardState = false
            
            -- reset global touch focus
            display.getCurrentStage():setFocus( nil )
            self.isFocus = nil
        end
    end

    return true
end


local function buildBackground(x, y)
        
        local plusThreeK = x + 3000
        local plusFiveK = y + 5000
        
    local background = display.newImageRect( "largeWallpaper.jpg", 5000, 3000 )
    background:setReferencePoint( display.TopLeftReferencePoint )
    background.x, background.y = x, y

    local secondBackground = display.newImageRect( "largeWallpaper.jpg", 5000, 3000 )
    secondBackground:setReferencePoint( display.BottomLeftReferencePoint )
    secondBackground.x, secondBackground.y = x, plusThreeK
    secondBackground.yScale = -1

    local thirdBackground = display.newImageRect( "largeWallpaper.jpg", 5000, 3000 )
    thirdBackground:setReferencePoint( display.TopRightReferencePoint )
    thirdBackground.x, thirdBackground.y = plusFiveK, y
    thirdBackground.xScale = -1

    local fourthBackground = display.newImageRect( "largeWallpaper.jpg", 5000, 3000 )
    fourthBackground:setReferencePoint( display.BottomRightReferencePoint )
    fourthBackground.x, fourthBackground.y = plusFiveK, plusThreeK
    fourthBackground.xScale = -1
    fourthBackground.yScale = -1
    
    backgroundGroup:insert( background)
    backgroundGroup: insert(secondBackground)
    backgroundGroup: insert(thirdBackground)
    backgroundGroup: insert(fourthBackground)
        
    end
    
local function buildBackgrounds()
    --Build a group for the background
    backgroundGroup = display.newGroup()
    
    buildBackground(-3000, -3000)
  --  buildBackground(-3000, 3000)
    
    --buildBackground(0, 6000)
    --buildBackground(10000, 0)
    --buildBackground(10000, 6000)
    
    displayGroup:insert(backgroundGroup)
end


-----------------------------------------------------------------------------------------
--
-- END THE CONTROL BUTTON LISTENERS NOW
--
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
    
    --Declare objects
ship = display.newImageRect( "transparentShip1.png", 83, 83 )
physics.addBody( ship, { density=0.4, friction=0.3, bounce=0.3 } )

asteroidSmall = display.newImageRect( "AsteroidSmall.png", 300, 260)
physics.addBody(asteroidSmall, { density = 0.4, friction = 0.3, bounce = 0.3, radius = 90 })

planetEarth = display.newImageRect( "planetEarth.png", 1000, 1000 )
physics.addBody(planetEarth, { density = 4.0, friction = 0.3, bounce = 0.3, radius = 440 })

local myField = gg.newForceField(
    {
    magnitude=0.01,
    effect="in",
    radius=1000
    }
)
myField.x, myField.y = 2000,550
myField:activate()

--gg.setGravityBounds(planetEarth, {
--    direction="horizontal",
--    gravity={
--        sideA = {-0.1, 0},
--        sideB = {0.1, 0}}
--    }
--)


planetEarth.x, planetEarth.y = 2000, 550

--physics.addBody( asteroidSmall, { density=0.4, friction=0.3, bounce=0.3 } )
flameTrail = display.newImageRect( "transparentStraightTrail1.png", 10.25, 38 )
flameTrail.isVisible = false  

leftFlameTrail = display.newImageRect( "transparentStraightTrail1.png", 5,19)
leftFlameTrail.isVisible = false  



rightFlameTrail = display.newImageRect( "transparentStraightTrail1.png", 5, 19)
rightFlameTrail.isVisible = false  

    
    --Declare groups

local group = self.view
      
displayGroup = display.newGroup()

flameGroup = display.newGroup()

--All background item inserts


--displayGroup: insert(backgroundGroup)

buildBackgrounds()
displayGroup:insert(planetEarth)
displayGroup: insert(asteroidSmall)

--Inserts into ship
displayGroup: insert(ship)

flameGroup: insert(flameTrail)
flameGroup: insert(leftFlameTrail)
flameGroup: insert(rightFlameTrail)

displayGroup: insert(flameGroup)


group:insert( displayGroup)
       
       
flameTrail.rotation = -5
flameTrail.x, flameTrail.y = 8, 5
       
leftFlameTrail.x, leftFlameTrail.y = -30, 0
leftFlameTrail.rotation = -5
rightFlameTrail.x, rightFlameTrail.y = 30, -25
rightFlameTrail.rotation = -5
       
       --asteroidSmall.x, asteroid.y = 100, 150

        
       

	--ADD THE CONTROLS GUI CODE
	
	local leftButton = display.newImageRect( "movementButton.png", 90, 90 )
	leftButton:setReferencePoint( display.CenterReferencePoint )
	leftButton.x = 50
	leftButton.y = 700
	
	local rightButton = display.newImageRect( "movementButton.png", 90, 90 )
	rightButton:setReferencePoint( display.CenterReferencePoint )
	rightButton.rotation = 180
	rightButton.x = 180
	rightButton.y = 700
	
	
	local forwardButton = display.newImageRect( "movementButton.png", 90, 90 )
	forwardButton:setReferencePoint( display.CenterReferencePoint )
	forwardButton.rotation = 90
	forwardButton.x = 115
	forwardButton.y = 620
	
	-- add functions onto buttons
	
		-- begin detecting touches
	leftButton.touch = onLeftButtonTouch
	leftButton:addEventListener( "touch", leftButton )
	
	rightButton.touch = onRightButtonTouch
	rightButton:addEventListener( "touch", rightButton )
	
	forwardButton.touch = onForwardButtonTouch
	forwardButton:addEventListener( "touch", forwardButton )

	--Position the ship in the middle of the screen
	--ship.x, ship.y = halfW, halfH
        ship.x, ship.y = shipPositionX, shipPositionY
        local flameY = halfH + 45
        
        local flameX = halfW + 7
        
        flameGroup.x, flameGroup.y = flameX, flameY
	
	-- add physics to the ship
	--physics.addBody( ship, { density=0.4, friction=0.3, bounce=0.3 } )
	
	-- create a grass object and add physics (with custom shape)
	--local grass = display.newImageRect( "grass.png", screenW, 82 )
	--grass:setReferencePoint( display.BottomLeftReferencePoint )
	--grass.x, grass.y = 0, display.contentHeight
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	--local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	--physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
        
        
        buildLoadingScreen()
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	--Here I have set the gravity to 0 0  to simulate the effects of being in space.
	physics.setGravity(0, 0)
	physics.start()
        
        buildStarsFunction()
	
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