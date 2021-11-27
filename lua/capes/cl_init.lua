/*
	Capes CL Init
*/
Capes = Capes or {};
Capes.Cape = Capes.Cape or {};

hook.Add(
	"Think",
	"UpdatePoints",
	function()
		for _,capeConstraints in pairs(Capes.Cape.Constraints) do
			for _,c in pairs(capeConstraints) do
				c:update();
			end;
		end;
		for _,points in pairs(Capes.Cape.Points) do
			for _,point in pairs(points) do
				point:update();
			end;
		end;
	end
);

hook.Add(
	"HUDPaint",
	"DrawPoints",
	function()
		for _,capeConstraints in pairs(Capes.Cape.Constraints) do
			for _,c in pairs(capeConstraints) do
				c:draw();
			end;
		end;
		for _,points in pairs(Capes.Cape.Points) do
			for _,point in pairs(points) do
				point:draw();
			end;
		end;
	end
);