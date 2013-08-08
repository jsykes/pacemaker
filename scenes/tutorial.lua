----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------
 local INSTRUCTION_FADE_TIME = 1000;
 
local storyboard = require( "storyboard" )
require("HeartMonitor.HeartMonitor");
local scene = storyboard.newScene();

local step;
local instructions;
 
local setInvisible;
local setVisible;
local instructionComplete;
local instructionForRun;
local instructionForJump;
local instructionForGame;
local changeScene;
local performNextInstruction;

-- Menu Text Obj
local menuText;
local menuTextShowing = true;

local highlight;
local monitor;

setInvisible = function()
    transition.to(menuText, {alpha=0, time=1000, onComplete=setVisible});
end

setVisible = function()
    transition.to(menuText, {alpha=1.0, time=1000, onComplete=setInvisible});
end

instructionComplete = function()
    transition.to(menuText, {delay = 500, time = INSTRUCTION_FADE_TIME, alpha = 0.0});
    transition.to(highlight.fader, {delay = 500, time = INSTRUCTION_FADE_TIME, alpha = 0.0, onComplete = performNextInstruction});
end

instructionForRun = function()
    print('instruction For Run');
    highlight.x = _W * .1;
    highlight.y = _H * .9;
    menuText.text = "tap to jump";
    menuText:setReferencePoint(display.CenterReferencePoint);
    menuText.x = _w; menuText.y = _h;
    transition.to(menuText, {time = INSTRUCTION_FADE_TIME, alpha = 1.0});
    transition.to(highlight.fader, {time = INSTRUCTION_FADE_TIME, alpha = 1.0});
end

instructionForJump = function()
    print('instruction For Jump');
    highlight.x = _W * .9;
    highlight.y = _H * .9;
    menuText.text = "tap to run";
    menuText:setReferencePoint(display.CenterReferencePoint);
    menuText.x = _w; menuText.y = _h;
    transition.to(menuText, {time = INSTRUCTION_FADE_TIME, alpha = 1.0});
    transition.to(highlight.fader, {time = INSTRUCTION_FADE_TIME, alpha = 1.0});
end

instructionForGame = function()
    print('instruction For Game');
    highlight.x = _W * .9;
    highlight.y = _H * .9;
    menuText.text = "live";
    menuText:setReferencePoint(display.CenterReferencePoint);
    menuText.x = _w; menuText.y = _h;
    transition.to(menuText, {time = INSTRUCTION_FADE_TIME, alpha = 1.0, onComplete = instructionComplete});
end

changeScene = function()
    highlight.isVisible = false;
    _ChangeScene('scenes.Gameplay');
end


performNextInstruction = function()
    step = step + 1;
    print('Performing step: ' .. step);
    timer.performWithDelay(500, instructions[step], 1);
end

local function heartBeater()
    -- monitor.paused = false;
    if(menuText.text == "tap to run") then
            monitor.paused = false;
            monitor:beat();
            monitor.paused = true;
    end
  
    instructionComplete();
end
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
        
        -- Menu Background
	local background = display.newRect(0, 0, _W, _H);
	group:insert(background);
	
	-- Menu Text
	menuText = display.newText(group, "tap to run", 0, 0, native.systemFont, 64);
        menuText:setTextColor(255, 255, 255);
	menuText:setReferencePoint(display.CenterReferencePoint);
	menuText.x = _w; menuText.y = _h;
	menuText.alpha = 0;
	
	--heart monitor
	monitor = HeartMonitor.new(100);
	monitor.paused = true;
	group:insert(monitor.displayGroup);
	
	local areaHighlightOutline = display.newCircle( -100, -100, _W*.1 );
	areaHighlightOutline:setFillColor(255, 255, 255, 255);
        areaHighlightOutline.alpha = 1;
	local areaHighlightInner = display.newCircle( -100, -100, _W*.08 );
	areaHighlightInner:setFillColor(0, 0, 0, 255);
	
	highlight = display.newGroup();
	highlight:insert(areaHighlightOutline);
	highlight:insert(areaHighlightInner);
	highlight:setReferencePoint(display.CenterReferencePoint);
	highlight.alpha = 1.0;
	highlight.fader = areaHighlightOutline;
	
	highlight:addEventListener("tap", heartBeater);
	
	group:insert(highlight);
	group:insert(menuText);
	highlight:toFront();
        
        
        instructions = {};
        instructions[1] = instructionForRun;
        instructions[2] = instructionForJump;
        instructions[3] = instructionForGame;
        instructions[4] = changeScene;
end
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    storyboard.purgeScene(_PreviousScene);
	local group = self.view
        
        step = 0;
        
        performNextInstruction();
end
 
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
    
	monitor:kill();
        
	highlight:removeEventListener("tap", heartBeater);
        
end
 
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
        
end
 
---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )
 
-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )
 
-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )
 
-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )
 
---------------------------------------------------------------------------------
 
return scene