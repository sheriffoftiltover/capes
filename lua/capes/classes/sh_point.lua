/*
	Point Class
*/
Point = {};
/*
	Point Prototype
*/
Point.Prototype = {};
function Point.Prototype:setOffset(offset)
	self.offset = offset;
end;

function Point.Prototype:setVelocity(velocity)
	self.velocity = velocity;
end;

function Point.Prototype:setColor(color)
	self.color = color;
end;

function Point.Prototype:setSize(w, h)
	self.w = w;
	self.h = h;
end;

function Point.Prototype:setEntityOffset(entityOffset)
	self.entityOffset = entityOffset;
end;

function Point.Prototype:setEntity(ent)
	self.entity = ent;
end;

function Point.Prototype:setIndex(index)
	self.index = index;
end;

function Point.Prototype:addPointConstraint(pointConstraint)
	table.insert(self.constraints, pointConstraint);
end;

function Point.Prototype:draw()
	local worldPos = self.offset;
	local scrPos = worldPos:ToScreen();
	if (scrPos.x > 0 && scrPos.x < ScrW() + self.w && scrPos.y > 0 && scrPos.y < ScrH() + self.h) then
		surface.SetDrawColor(self.color);
		surface.DrawRect(
			scrPos.x - self.w / 2,
			scrPos.y - self.h / 2,
			self.w,
			self.h
		);
	end;
end;

function Point.Prototype:addVelocity(velocity)
	self.velocity = (self.velocity + velocity);
end;

function Point.Prototype:update()
	if (self.entity ~= nil) then
		self.offset = self.entity:GetPos() + self.entityOffset;
	else
		local delta = CurTime() - self.lastUpdate;
		local newOffset = self.offset + self.velocity * delta;
		local trace = util.TraceLine({
			start = self.offset,
			endpos = newOffset - Vector(0, 0, 9.8) * delta
		});
		if (!trace.HitWorld) then
			newOffset = newOffset - Vector(0, 0, 9.8) * delta;
		end;
		self.offset = newOffset;
	end;
	self.velocity = Vector(0, 0, 0);
	self.lastUpdate = CurTime();
end;

/*
	Point Metatable
*/
Point.Meta = {};
function Point.Meta.__call(table, name)
	local point = {
		offset = Vector(0, 0, 0),
		velocity = Vector(0, 0, 0),
		color = Color(255, 255, 255),
		w = 1,
		h = 1,
		constraints = {},
		entity = nil,
		entityOffset = Vector(0, 0, 0),
		lastUpdate = CurTime(),
		index = 1,
	};
	setmetatable(point, Point.Meta);
	return point;
end;

function Point.Meta.__index(table, key)
	return Point.Prototype[key];
end;
setmetatable(Point, Point.Meta);