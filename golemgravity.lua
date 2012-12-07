--[[
Project: Golem Gravity
 
Author: CMP
 
Version: 1.1
 
Update History:
 
        Version 1.1:
         -Added 'setGravityBounds' and 'removeGravityBounds' functions
 
        Version 1.2:
         -Added force fields
 
If you happen to spot a problem, or have a suggestion, please tell at the Golem Gravity page @ Corona Labs.com
 
There are no restrictions on this code. You can use it in whatever you want, however you want.
 
 
golemgravity.lua:
--]]
 
local public = {}
 
local function setGravity(object, gravX, gravY, speed)
        local function applyGrav()
        object:applyForce(gravX, gravY, object.x, object.y)
        end
        if (object.gravTimer) then
        timer.cancel(object.gravTimer)
        end
        object.gravTimer=timer.performWithDelay(speed, applyGrav, 0)
end
 
local function removeGravity(object)
        if (object.gravTimer) then
        timer.cancel(object.gravTimer)
        end
end
 
local function setGravityBounds(obj, params)
local gravBounds={}
gravBounds.isTable=false
 
if (obj.x==nil) then
        gravBounds.isTable=true
else
        gravBounds.isTable=false
end
 
if (params) then
        if (params.splitPoint and type(params.splitPoint)=="number") then
                gravBounds.splitPoint=params.splitPoint
        else
                gravBounds.splitPoint=384
        end
        
        if (params.gravity and type(params.gravity)=="table") then
        if (params.gravity.sideA and type(params.gravity.sideA)=="table") then
                gravBounds.xGravityA=params.gravity.sideA[1]
                gravBounds.yGravityA=params.gravity.sideA[2]
        else
                gravBounds.xGravityA=0
                gravBounds.yGravityA=0
        end
        if (params.gravity.sideB and type(params.gravity.sideB)=="table") then
                gravBounds.xGravityB=params.gravity.sideB[1]
                gravBounds.yGravityB=params.gravity.sideB[2]
        else
                gravBounds.xGravityB=0
                gravBounds.yGravityB=0
        end
        end
        
        if (params.speed and type(params.speed)=="number") then
                gravBounds.speed=params.speed
        else
                gravBounds.speed=1
        end
        
        if (params.direction and type(params.direction)=="string") then
        if "horizontal"==params.direction then
                if (gravBounds.isTable) then
                for i=1, #obj do
                        local function checkForBounds()
                        if obj[i].x<=display.contentWidth-(display.contentWidth-gravBounds.splitPoint) then
                                obj[i]:applyLinearImpulse(gravBounds.xGravityA, gravBounds.yGravityA)
                        elseif obj[i].x>=display.contentWidth-gravBounds.splitPoint then
                                obj[i]:applyLinearImpulse(gravBounds.xGravityB, gravBounds.yGravityB)
                        end
                        end
                        obj[i].gravityTimer=timer.performWithDelay(gravBounds.speed, checkForBounds, 0)
                end
                elseif (not gravBounds.isTable) then
                local function checkForBounds()
                        if obj.x<=display.contentWidth-(display.contentWidth-gravBounds.splitPoint) then
                        obj:applyLinearImpulse(gravBounds.xGravityA, gravBounds.yGravityA)
                        elseif obj.x>=display.contentWidth-gravBounds.splitPoint then
                        obj:applyLinearImpulse(gravBounds.xGravityB, gravBounds.yGravityB)
                        end
                end
                obj.gravityTimer=timer.performWithDelay(gravBounds.speed, checkForBounds, 0)
                end
        
        elseif "vertical"==params.direction then
                if (gravBounds.isTable) then
                for i=1, #obj do
                        local function checkForBounds()
                        if obj[i].y<=display.contentHeight-(display.contentHeight-gravBounds.splitPoint) then
                                obj[i]:applyForce(gravBounds.xGravityA, gravBounds.yGravityA)
                        elseif obj[i].y>=display.contentHeight-gravBounds.splitPoint then
                                obj[i]:applyForce(gravBounds.xGravityB, gravBounds.yGravityB)
                        end
                        end
                        obj[i].gravityTimer=timer.performWithDelay(gravBounds.speed, checkForBounds, 0)
                end
                elseif (not gravBounds.isTable) then
                local function checkForBounds()
                        if obj.y<=display.contentHeight-(display.contentHeight-gravBounds.splitPoint) then
                        obj:applyForce(gravBounds.xGravityA, gravBounds.yGravityA)
                        elseif obj.y>=display.contentHeight-gravBounds.splitPoint then
                        obj:applyForce(gravBounds.xGravityB, gravBounds.yGravityB)
                        end
                end
                obj.gravityTimer=timer.performWithDelay(gravBounds.speed, checkForBounds, 0)
                end
        end
        end
end
return gravBounds
end
 
local function removeGravityBounds(obj)
isTable=false
 
if (obj.x==nil) then
        isTable=true
else
        isTable=false
end
 
if (isTable) then
for i=1, #obj do
        if obj[i].gravityTimer then
        timer.cancel(obj[i].gravityTimer)
        end
end
elseif (not isTable) then
        if obj.gravityTimer then
        timer.cancel(obj.gravityTimer)
        end
end
end
 
local function newForceField(params)
        if params then
                local ff={}
                ff.x, ff.y=0, 0
                
                if (params.radius and type(params.radius)=="number") then
                        ff.radius=params.radius
                else
                        ff.radius=150
                end
                
                if (params.magnitude and type(params.magnitude)=="number") then
                        ff.magnitude=params.magnitude
                else
                        ff.magnitude=1
                end
                
                if (params.time and type(params.time)=="number") then
                        ff.time=params.time
                else
                        ff.time=1
                end
                
                if (params.effect and type(params.effect)=="string") then
                        ff.effect=params.effect
                else
                        ff.effect="in"
                end
                
                local function inEffect()
                        
                        if forceField then
                                forceField:removeEventListener("collision", forceField)
                                display.remove(forceField)
                                forceField=nil
                        end
                        
                        forceField=display.newCircle( 0,0,ff.radius )
                        physics.addBody( forceField, "static", {radius=ff.radius} )
                        forceField.isSensor=true
                        forceField.isVisible=false
                        forceField.x, forceField.y=ff.x, ff.y
                        
                        local function onCircleCollision( self, event )
                                event.other:applyForce( (forceField.x*ff.magnitude-event.other.x*ff.magnitude), (forceField.y*ff.magnitude-event.other.y*ff.magnitude), event.other.x, event.other.y )
                        end
                        
                        forceField.collision=onCircleCollision
                        forceField:addEventListener( "collision", forceField )
                        
                end
                
                local function outEffect()
                        
                        if forceField then
                                forceField:removeEventListener("collision", forceField)
                                display.remove(forceField)
                                forceField=nil
                        end
                        
                        forceField=display.newCircle( 0,0,ff.radius )
                        physics.addBody( forceField, "static", {radius=ff.radius} )
                        forceField.isSensor=true
                        forceField.isVisible=false
                        forceField.x, forceField.y=ff.x, ff.y
                        
                        local function onCircleCollision( self, event )
                                event.other:applyForce( (event.other.x*ff.magnitude-forceField.x*ff.magnitude), (event.other.y*ff.magnitude-forceField.y*ff.magnitude), event.other.x, event.other.y )
                        end
                        
                        forceField.collision=onCircleCollision
                        forceField:addEventListener( "collision", forceField )
                        
                end
                
                function ff:activate()
                        if ff.gravTimer then
                                timer.cancel(ff.gravTimer)
                        end
                        
                        if "in"==ff.effect then
                                ff.gravTimer=timer.performWithDelay(ff.time, inEffect, 0)
                        else
                                ff.gravTimer=timer.performWithDelay(ff.time, outEffect, 0)
                        end
                end
                
                function ff:deactivate()
                        if ff.gravTimer then
                                timer.cancel(ff.gravTimer)
                        end
                end
                                
                function ff:flash()
                        if ff.flasher then
                                display.remove(flasher)
                                flasher=nil
                        end
                        flasher=display.newCircle(0, 0, ff.radius)
                        flasher.x, flasher.y=ff.x, ff.y
                        flasher.alpha=0.5
                        timer.performWithDelay(100, function() display.remove(flasher) flasher=nil end)
                end
        
                return ff
        end
end
 
public.setGravity=setGravity
public.removeGravity=removeGravity
public.setGravityBounds=setGravityBounds
public.removeGravityBounds=removeGravityBounds
public.newForceField=newForceField
 
return public