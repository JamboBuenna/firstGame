-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local gg = require("golemgravity")
local PS = require("classes.ParticleSugar").instance()
require "healthBar"
require "mapScreen"

local xGrav, yGrav=0, 0

local scene = storyboard.newScene()


 

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

cameraPositionX = 0
cameraPositionY = 0

local shipPositionX = 500
local shipPositionY = 450

cannonState = 0

cannonReady = 10


shipRadianAngle = 0

cameraUpdate = 0



--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5

local hiddenJetStream = true

local healthBar = HealthBar:new()
healthBar.x, healthBar.y = 50, 50
healthBar:setHealth(100, 100)

local mapScreen = MapScreen:new()
mapScreen.x, mapScreen.y = screenW - 50, 120
--mapScreen:setPosition(100, 100)

local turnLeftState = false
local turnRightState = false
local goForwardState = false
local shootState = false

_m=math.random

local function buildLoadingScreen ()
    loadingText = display.newText( "Building galaxy", 0, 0, "Helvetica", 30 )
    loadingText:setTextColor(255, 255, 255)
    loadingText:setReferencePoint( display.CenterReferencePoint )
    loadingText.x = display.contentWidth * 0.5
    loadingText.y = 200
end

local bullets = {}
local n = 0
 
local function fireShot()
    
     
    local shipHorizontalAngle = shipRadianAngle + 1.5
    
    if shipHorizontalAngle > 6 then
        shipHorizontalAngle = shipHorizontalAngle - 6
    end

    
    local forwardDistance = 35
    local horizontalDistance = 45
    local bulletSpeed = 500
    
    local bulletForwardX =  math.sin(shipRadianAngle) * forwardDistance 
    local bulletForwardY = (math.cos(shipRadianAngle)* forwardDistance) * -1
    
    local bulletHorizontalX =  math.sin(shipHorizontalAngle) * horizontalDistance  
    local bulletHorizontalY = (math.cos(shipHorizontalAngle)* horizontalDistance) * -1  
    
    --Start left shot
        n = n + 1
        
        local shotLeft
        local shotRight
        
        bullets[n] = display.newImage( "shotOne.png", 20, 20)
        bullets[n + 1] = display.newImage( "shotOne.png", 20, 20)
        
        shotLeft = bullets[n]
        shotRight = bullets[n + 1]
        
        --Settings for shot left
        
        shotLeft.height, shotLeft.width = 20, 10
        shotLeft.rotation = ship.rotation
        
       -- bricks[n].x, bricks[n].y = 20, 40
        physics.addBody( shotLeft, { density=3.0, friction=0.5, bounce=0.05 } )
 
        -- remove the "isBullet" setting below to see the brick pass through cans without colliding!
        shotLeft.isBullet = true
        
    local startPositionX = ship.x + bulletForwardX - bulletHorizontalX 
    local startPositionY = (ship.y) + bulletForwardY - bulletHorizontalY  
        
        shotLeft.x, shotLeft.y = startPositionX, startPositionY
        
        --Settings for shot right
        
        shotRight.height, shotRight.width = 20, 10
        shotRight.rotation = ship.rotation
        
       -- bricks[n].x, bricks[n].y = 20, 40
        physics.addBody( shotRight, { density=3.0, friction=0.5, bounce=0.05 } )
 
        -- remove the "isBullet" setting below to see the brick pass through cans without colliding!
        shotRight.isBullet = true
        
    local shotRightPositionX = ship.x + bulletForwardX + bulletHorizontalX 
    local shotRightPositionY = (ship.y) + bulletForwardY + bulletHorizontalY  
        
        shotRight.x, shotRight.y = shotRightPositionX, shotRightPositionY
        
        
    --Calculate velocity    
    velocityY =  (math.cos(shipRadianAngle)* bulletSpeed) * -1
    velocityX =  math.sin(shipRadianAngle) * bulletSpeed 
    
    --print(shipRadianAngle)
    
        --bullets[n].angularVelocity = 100
        
        shotLeft:applyForce(velocityX, velocityY, shotLeft.x, shotLeft.y)
        shotRight:applyForce(velocityX, velocityY, shotRight.x, shotRight.y )
        
        backgroundGroup:insert(shotLeft)
        backgroundGroup:insert(shotRight)
        
        n = n + 1 
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
   
    shipRadianAngle = positionAngle * 0.0174532925
        
    --Update position 


    flameGroup.y = ship.y + math.cos(shipRadianAngle)* jetLength
    flameGroup.x = ship.x - math.sin(shipRadianAngle) * jetLength 

    flameGroup.rotation  = shipRadianAngle * 57.2957795131
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

if
    cannonState < cannonReady then
    cannonState = cannonState + 1
end


if shootState == true then
    
    if cannonState == cannonReady then
        
        fireShot()
        cannonState = 0
    end
    
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

local function onShootButtonTouch( self, event )
    if event.phase == "began" then

        -- specify the global touch focus
        shootState = true
        
        display.getCurrentStage():setFocus( self )
        self.isFocus = true

    elseif self.isFocus then
        if event.phase == "moved" then

            -- do something here; or not

        elseif event.phase == "ended" or event.phase == "cancelled" then
        
            shootState = false
            
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
--ship = display.newImageRect( "ship2.png", 130, 196 )
ship = display.newImageRect( "ship2.png", 93, 140 )
physics.addBody( ship, { density=0.4, friction=0.3, bounce=0.3 } )

--asteroidSmall = display.newImageRect( "AsteroidSmall.png", 300, 260)
--physics.addBody(asteroidSmall, { density = 0.4, friction = 0.3, bounce = 0.3, radius = 90 })

asteroidSmall = display.newImageRect( "AsteroidSmall.png", 150, 130)
physics.addBody(asteroidSmall, { density = 0.4, friction = 0.3, bounce = 0.3, radius = 90 })

asteroidSmall.x, asteroidSmall.y = -300, 50
asteroidSmall:applyLinearImpulse( 30, -30, asteroidSmall.x, asteroidSmall.y )

planetEarth = display.newImageRect( "planetEarth.png", 1500, 1500 )
physics.addBody(planetEarth, { density = 4.0, friction = 0.3, bounce = 0.3, radius = 665 })

local myField = gg.newForceField(
    {
    magnitude=0.01,
    effect="in",
    radius=1000
    }
)
myField.x, myField.y = 500,1000
myField:activate()


planetEarth.x, planetEarth.y = 500, 1220

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

--Lets play with particles

----------- particle begin -------------
	Runtime:addEventListener('enterFrame', PS )
	
	local dustEm = PS:newEmitter{
		name="pointLoopEm",
		x=0,y=0,
		rotation=0,
		visible=true,
		loop=false, 
		autoDestroy=false
	}
    dustEm:setParentGroup(group)
	dustEm.x = 160
	dustEm.y = 160
	

    PS:newParticleType{
		name="starPt",prop={
			scaleStart = 1,
			scaleVariation = 0,
			velocityStart = 30,
			velocityVariation = 100,			
			rotationStart = 0,
			rotationChange = 8,
			rotationVariation = 360,
			directionVariation = 30,
			killOutsideScreen = false,
			lifeTime = 5000,
			alphaStart = 1,
			bounceX = true,
			colorStart = {255,0,0},
			colorChange = {0,3,0},
			shape = {
				type = 'rect',
				width = 20,
				height = 8,
			}
		}
	}

    PS:attachParticleType("pointLoopEm", "starPt", 500, 300, 0)

	----------- particle end -------------


--End playing with particles


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

       	local caption1 = display.newText(group, "test particles",100,420,native.systemFont, 24)
	caption1:addEventListener('touch',function(event)
		if event.phase ~= 'ended' then return end
		
		dustEm.rotation = math.random(360)
		PS:startEmitter('pointLoopEm',true)
	end)
       
--flameTrail.rotation = -5
flameTrail.x, flameTrail.y = 0.5, 28
       
leftFlameTrail.x, leftFlameTrail.y = -45, 20
leftFlameTrail.rotation = -5
rightFlameTrail.x, rightFlameTrail.y = 45, 20
rightFlameTrail.rotation = -5
       

	--ADD THE CONTROLS GUI CODE
	
	local leftButton = display.newImageRect( "movementButton.png", 120, 120 )
	leftButton:setReferencePoint( display.CenterReferencePoint )
	leftButton.x = -50
	leftButton.y = 700
	
	local rightButton = display.newImageRect( "movementButton.png", 120, 120 )
	rightButton:setReferencePoint( display.CenterReferencePoint )
	rightButton.rotation = 180
	rightButton.x = 130
	rightButton.y = 700
	
	
	local forwardButton = display.newImageRect( "movementButton.png", 120, 120 )
	forwardButton:setReferencePoint( display.CenterReferencePoint )
	forwardButton.rotation = 90
	forwardButton.x = 40	forwardButton.y = 600
        
        local shootButton = display.newImageRect( "shootButton.png", 120, 120)
	shootButton:setReferencePoint( display.CenterReferencePoint )
	shootButton.x,shootButton.y = 1050, 700
	
        
	-- add functions onto buttons
	
		-- begin detecting touches
	leftButton.touch = onLeftButtonTouch
	leftButton:addEventListener( "touch", leftButton )
	
	rightButton.touch = onRightButtonTouch
	rightButton:addEventListener( "touch", rightButton )
	
	forwardButton.touch = onForwardButtonTouch
	forwardButton:addEventListener( "touch", forwardButton )
        
        shootButton.touch = onShootButtonTouch
	shootButton:addEventListener( "touch", shootButton )

	--Position the ship in the middle of the screen
	--ship.x, ship.y = halfW, halfH
        ship.x, ship.y = shipPositionX, shipPositionY
        local flameY = halfH + 45
        
        local flameX = halfW + 7
        
        flameGroup.x, flameGroup.y = flameX, flameY      
        
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