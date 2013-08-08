require("display");
require("audio");



HeartMonitor = {};
HeartMonitor.__index = HeartMonitor;

local midy = _H / 2;
local timeBetweenDecrement = 120;
local lowThreshold = 50;
local highThreshold = 230;

local offsets =
{
	{
		x2 = 0.007;
		y2 = -0.05;
	},
	{
		x2 = 0.007;
		y2 = 0;
	},
	{
		x2 = 0.007;
		y2 =  0;
	},
	{
		x2 = 0.005;
		y2 = 0.04;
	},
	{
		x2 = 0.02;
		y2 = -0.4;
	},
	{
		x2 = 0.02;
		y2 = 0.3;
	},
	{
		x2 = 0.01;
		y2 = 0.05;
	},
	{
		x2 = 0.01;
		y2 = 0.065;
	},
	{
		x2 = 0.005;
		y2 = -0.03;
	},
	{
		x2 = 0.015;
		y2 = -0.01;
	},
	{
		x2 = 0.015;
		y2 = 0;
	}
};

local colors = 
{
	{
		r=60,
		g=166,
		b=45
	},
	{
		r=193,
		g=204,
		b=0
	},
	{
		r=202,
		g=0,
		b=0,
	}
};
local greenCutoff = lowThreshold;
local fullYellow = 180;
local fullRed = highThreshold;

local getHeartColor = function(bpm)
	local bpm = bpm or 100;
	if(bpm < 100) then
		return colors[1];
	end
	
	if(bpm <= fullYellow) then
		local interpolation = (bpm - greenCutoff) / (fullYellow - greenCutoff);
		local hColor = {r=colors[1].r, g=colors[1].g, b=colors[1].b};
		hColor.r = hColor.r + (colors[2].r - hColor.r) * interpolation;
		hColor.g = hColor.g + (colors[2].g - hColor.g) * interpolation;
		hColor.b = hColor.b + (colors[2].b - hColor.b) * interpolation;
		return hColor;
	end
	
	if bpm > fullRed then
		bpm = fullRed;
	end
	local interpolation = (bpm - fullYellow) / (fullRed - fullYellow);
	local hColor = {r=colors[2].r, g=colors[2].g, b=colors[2].b};
	hColor.r = hColor.r + (colors[3].r - hColor.r) * interpolation;
	hColor.g = hColor.g + (colors[3].g - hColor.g) * interpolation;
	hColor.b = hColor.b + (colors[3].b - hColor.b) * interpolation;
	return hColor;
end

function HeartMonitor:changeBeat()
	local bpm = self.bpm;
	self.lineGroup:removeSelf();
	self.lineGroup = display.newGroup();
	
	local color = getHeartColor(bpm);
	
	local midy = _H / 2;
	
	local x = _W * 0.435;
	local x1 = x;
	local y1 = midy;
	local lines = {}
	local amplitude = (bpm / (fullRed)) * 1.2;
	lines[1] = display.newLine(-_W/2, midy, x, midy);
	
	for i,v in ipairs(offsets) do
		local variation = math.random(100,110)/100;
		local newX = (v.x2 *(1-amplitude *0.3) * _W) + x1;
		local y = v.y2 *_H + midy * variation;
		local amplitudeWeight = math.abs(midy - y) / midy;
		
		local amp = amplitude * amplitudeWeight;
		local newY = (v.y2 * amp *_H + midy) * variation;
		if(i == #offsets) then
			newY = midy;
		end
		lines[1]:append(newX, newY);
		x1 = newX;
		y1 = newY;
	end
	
	lines[1].width = 6;
	lines[1]:setColor(color.r, color.g, color.b);
	self.lineGroup:insert(lines[1]);
	lines[1]:append(_W*1.5, midy);
	-- local line = display.newLine(x1,midy, _W*1.5, midy);
	-- lines[#lines+1] = line;
	-- line.width = 3;
	-- line:setColor(color.r, color.g, color.b);
	-- self.lineGroup:insert(lines[#lines]);
	
	self.displayGroup:insert(self.lineGroup);
	-- self.lineGroup:();
end

function HeartMonitor:beat()
	if(self.paused == true) then
		return;
	end
	self.bpm = self.bpm + 6;
	self:changeBeat();
	local fadeMS = 1300--((self.bpm / highThreshold) + 1) / 2 * 300
	self.black.alpha = 0;
	transition.to(self.black, {alpha=1, time =fadeMS});
	self.lineGroup.x = math.random(_W*0.70, _W*0.85) - _W/2;
	self.lineGroup.alpha = 0;
	transition.to(self.lineGroup, {x=self.lineGroup.x - _W/2, time=fadeMS});
	transition.to(self.lineGroup, {alpha=1, time=fadeMS /4, 
		onComplete=
			function()
				transition.to(self.lineGroup, {alpha=0, time=fadeMS * 0.75});
			end}
		);
	audio.play(self.blip);
	audio.play(self.a_heartbeat, {channel=31});
	
end

function HeartMonitor:death()
    
    if(self.dead == true) then
		return;
	end
	print("DEATH");
	self.dead = true;
	self.paused = true;
	audio.play(self.flatline, {channel=32});
	transition.to(self.white, {alpha=1, time=500});
	self.lineGroup:removeSelf();
	self.lineGroup = display.newGroup();

	local line = display.newLine(_W, midy, _W*10, midy);
	line:setColor(colors[3].r, colors[3].g, colors[3].b);
	line.width = 6;
	self.lineGroup:insert(line);
	
	--create credits text
	local text = display.newText("Programming:\n   Zach Helmes, John Sykes, Dan O'Sullivan and Jonathan Conley", _W,0, native.systemFont, 25);
	text:setReferencePoint(display.BottomCenterReferencePoint);
	text.y = midy - 10;
	text:setTextColor(colors[3].r, colors[3].g, colors[3].b);
	
	local artText = display.newText("Art and Sound:\n   Bryce Pelletier", _W, 0, native.systemFont, 25);
	artText:setReferencePoint(display.TopCenterReferencePoint);
	artText.y = midy + 10;
	artText:setTextColor(colors[3].r, colors[3].g, colors[3].b);
        self.lineGroup:insert(artText);
	
	self.displayGroup:insert(text);
	self.displayGroup:insert(artText);
	self.displayGroup:insert(self.lineGroup);
	self.lineGroup:toFront();
	
	transition.to(text, {x=_W/2, time=audio.getDuration(self.flatline)/3});
	transition.to(artText, {x=_W/2 - ((text.width - artText.width)/2), time=audio.getDuration(self.flatline)/3});
	
	transition.to(line, {x=-_W*2, time=audio.getDuration(self.flatline),
		onComplete=
			function()
				Runtime:dispatchEvent({name="gameOver"});
                                
                                local function RestartGame(e)
                                    if (e.phase == 'ended') then
										-- self.lineGroup:removeSelf();
                                        Runtime:removeEventListener("touch", RestartGame);
                                        local storyboard = require("storyboard");
                                        _ChangeScene("scenes.mainmenu");
                                    end
                                    return true;
                                end
                                
                                Runtime:addEventListener("touch", RestartGame);
			end
		});
	Runtime:removeEventListener("enterFrame", self.enterFrameCaller);
	Runtime:removeEventListener("HeartbeatDown", self.beatCaller);
	Runtime:removeEventListener("onDeath", self.deathCaller);
end

local onEnterFrame = function(self, event)
	if(self.paused == true) then
		--this is here to make sure that the player doesn't drop because the game was paused
		self.lastDecrement = system.getTimer();
		return;
	end
	local timeSince = system.getTimer() - self.lastDecrement;
	if(timeSince >= timeBetweenDecrement) then
		local percentToEnd = self.bpm / highThreshold;
		local bpmToRemove = (1/math.sqrt(0.5 + (percentToEnd-2)^6)) * 1.3;
		-- bpmToRemove = math.abs(bpmToRemove);
		self.bpm = self.bpm - (timeSince / timeBetweenDecrement) * bpmToRemove;
		-- print(bpmToRemove);
		self.lastDecrement = system.getTimer();
	end
	
	if(self.bpm < lowThreshold) then
		Runtime:dispatchEvent({name="onDeath", method="slow"});
		self.paused = true;
	end
	if(self.bpm > highThreshold) then
		Runtime:dispatchEvent({name="onDeath", method="fast"});
		self.paused = true;
	end
end

local function enterFrameCaller(event)
    onEnterFrame(monitor, event);
end
local function beatCaller()
    monitor:beat();
end
local function deathCaller()
    monitor:death();
end

function HeartMonitor:kill()
	Runtime:removeEventListener("enterFrame", self.enterFrameCaller);
	Runtime:removeEventListener("HeartbeatDown", self.beatCaller);
	Runtime:removeEventListener("onDeath", self.deathCaller);
	
	self.displayGroup:removeSelf();
end

function HeartMonitor.new(bpm)
	local monitor = 
	{
		displayGroup = display.newGroup();
		lineGroup = display.newGroup();
		bpm = bpm or 100;
		lastDecrement = system.getTimer();
		paused = false;
		dead = false;
	};
	setmetatable(monitor, HeartMonitor);
	-- monitor:changeBeat(greenCutoff);	
	
	local fadedBG = display.newImage(monitor.displayGroup, "gfx/heartBG.png", 0,0, true);
	fadedBG.alpha = 0.8;
	
	local black = display.newRect(0,0,_W, _H);
	black:setFillColor(0);
	
	local white = display.newRect(0,0,_W, _H);
	white.alpha = 0;
	
	monitor.white = white;
	monitor.black = black;
	monitor.fadedBG = fadedBG;
        
        
        monitor.enterFrameCaller = function(event)
            onEnterFrame(monitor, event);
        end
        monitor.beatCaller = function()
            monitor:beat();
        end
        monitor.deathCaller = function()
            monitor:death();
        end
	
	-- monitor:changeBeat(monitor.bpm);
	print(monitor.displayGroup);
	Runtime:addEventListener("enterFrame", monitor.enterFrameCaller);
	Runtime:addEventListener("HeartbeatDown", monitor.beatCaller);
	Runtime:addEventListener("onDeath", monitor.deathCaller);
	--load the sounds
	monitor.blip = audio.loadSound("audio/heart_rate_monitor.mp3");
	monitor.flatline = audio.loadSound("audio/flatline.mp3");
	
	monitor.displayGroup:insert(fadedBG);
	monitor.displayGroup:insert(black);
	monitor.displayGroup:insert(white);
	
	
	return monitor;
end