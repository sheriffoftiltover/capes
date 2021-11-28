/*
	Cape Lib cl_cape.lua
*/
Capes = Capes or {};
Capes.Cape = {};
Capes.Cape.Hooks = {};
Capes.Cape.Points = Capes.Cape.Points or {};
Capes.Cape.Constraints = Capes.Cape.Constraints or {};

function Capes.Cape:create(ent, size, offset, length)
	local offset = offset ~= nil and offset or Vector(0, 0, 0);
	local left = -ent:GetRight();
	local up = ent:GetUp();
	local pos = ent:GetPos();
	local hsvFraction = 360 / size;
	local capePoints = {};
	local capeConstraints = {};
	for y = 1, size do
		for x = 1, size do

			local point = Point();
			point:setOffset(pos + -(left * (size / 2 * length)) + left * x * length - up * y * length + offset);
			point:setSize(10, 10);
			point:setColor(HSVToColor(hsvFraction * y, 1, 1));
			point:setIndex(#capePoints + 1);
			table.insert(capePoints, point);
			if (x > 1) then
				local previousPoint = capePoints[(y - 1) * size + x - 1];
				local c = Constraint();
				c:setLength(length);
				c:setPoints(point, previousPoint);
				table.insert(capeConstraints, c);
			end;
			if (y > 1) then
				local abovePoint = capePoints[(y - 2) * size + x];
				local c = Constraint();
				c:setLength(length);
				c:setPoints(point, abovePoint);
				table.insert(capeConstraints, c);
			else
				local entityOffset = Vector(0, -(size / 2 * length) + x * length, -up * y * length) + offset;
				point:setEntity(ent);
				point:setEntityOffset(entityOffset);
			end;
		end;
	end;
	Capes.Cape.Points[ent] = capePoints;
	Capes.Cape.Constraints[ent] = capeConstraints;
end;

/*
	Hooks
*/

function Capes.Cape.Hooks:Think()
	for _,capeConstraints in pairs(self.Constraints) do
		for _,c in pairs(capeConstraints) do
			c:update();
		end;
	end;
	for _,points in pairs(self.Points) do
		for _,point in pairs(points) do
			point:update();
		end;
	end;
end;

function Capes.Cape.Hooks:HUDPaint()
	for _,capeConstraints in pairs(self.Constraints) do
		for _,c in pairs(capeConstraints) do
			c:draw();
		end;
	end;
	for _,points in pairs(self.Points) do
		for _,point in pairs(points) do
			point:draw();
		end;
	end;
end;

Capes:RegisterHooks(Capes.Cape);