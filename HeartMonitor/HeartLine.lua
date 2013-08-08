require("display");
require("audio");



HeartLine = {};
HeartLine.__index = HeartLine;

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

function HeartLine:changeBeat()
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

function HeartLine:beat()
	-- self.bpm = self.bpm + 6;
	self:changeBeat();
	local fadeMS = 1300--((self.bpm / highThreshold) + 1) / 2 * 300
	-- self.black.alpha = 0;
	-- transition.to(self.black, {alpha=1, time =fadeMS});
	self.lineGroup.x = math.random(_W*1.0, _W*1.1) - _W/2;
	self.lineGroup.alpha = 0;
	transition.to(self.lineGroup, {x=self.lineGroup.x - _W, time=fadeMS});
	transition.to(self.lineGroup, {alpha=1, time=fadeMS /4, 
		onComplete=
			function()
				transition.to(self.lineGroup, {alpha=0, time=fadeMS * 0.75});
			end}
		);
	audio.play(self.blip);
	audio.play(self.a_heartbeat, {channel=31});
	
end

local onEnterFrame = function(self, event)
end

function HeartLine.new(bpm)
	local monitor = 
	{
		displayGroup = display.newGroup();
		lineGroup = display.newGroup();
		bpm = bpm or 100;
		lastDecrement = system.getTimer();
		paused = false;
	};
	setmetatable(monitor, HeartLine);
	
	-- monitor:changeBeat(monitor.bpm);
	print(monitor.displayGroup);
	-- Runtime:addEventListener("onDeath", function() monitor:death(); end);
	--load the sounds
	monitor.blip = audio.loadSound("audio/heart_rate_monitor.mp3");
	monitor.flatline = audio.loadSound("audio/flatline.mp3");
	
	
	return monitor;
end