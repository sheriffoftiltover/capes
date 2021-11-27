/*
	Constraint
*/
Constraint = {};
Constraint.Prototype = {};

function Constraint.Prototype:setPoints(p1, p2)
	self.p1 = p1;
	self.p2 = p2;
end;

function Constraint.Prototype:setLength(length)
	self.length = length;
end;

function Constraint.Prototype:update()
	if (self.p1 ~= nil and self.p2 ~= nil) then
		local diffPos = self.p1.offset - self.p2.offset;
		local distance = self.p1.offset:Distance(self.p2.offset);
		local lengthDiff = self.length / distance;
		local diffNormal = diffPos:GetNormal();
		local deltaTime = CurTime() - self.lastUpdate;
		self.p1.velocity = -diffPos * (distance - self.length);
		self.lastUpdate = CurTime();
	end;
end;

function Constraint.Prototype:draw()
	local scrPos1 = self.p1.offset:ToScreen();
	local scrPos2 = self.p2.offset:ToScreen();
	if (scrPos1.x < 0) then
		scrPos1.x = 0;
	end;
	if(scrPos1.x > ScrW() + self.p1.w) then
		scrPos1.x = ScrW();
	end;
	if (scrPos1.y < 0) then
		scrPos1.y = 0;
	end;
	if (scrPos1.y > ScrH() + self.p1.h) then
		scrPos1.y = ScrH();
	end;
	if (scrPos2.x > 0 && scrPos2.x < ScrW() + self.p2.w && scrPos2.y > 0 && scrPos2.y < ScrH() + self.p2.h) then
		surface.SetDrawColor(self.p1.color);
		surface.DrawLine(
			scrPos1.x,
			scrPos1.y,
			scrPos2.x,
			scrPos2.y
		);
	end;
end;

Constraint.Meta = {};
function Constraint.Meta.__call(table, name)
	local c = {
		p1 = nil,
		p2 = nil,
		length = 1,
		lastUpdate = CurTime(),
	};
	setmetatable(c, Constraint.Meta);
	return c;
end;

function Constraint.Meta.__index(table, key)
	return Constraint.Prototype[key];
end;
setmetatable(Constraint, Constraint.Meta);