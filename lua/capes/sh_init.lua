/*
	Capes SH Init
*/
Capes = Capes or {};
function Capes:LoadFile(filePath)
	local split = string.Split( filePath, "/" );
	--Separate our file name from the full path
	local fileName = split[#split];
	--Get the prefix to determine how to load it
	local prefix = string.sub( fileName, 1, 3 );
	
	if( SERVER ) then
		if( prefix == "sh_" or prefix == "cl_" ) then
			AddCSLuaFile( filePath );
		end;
		if( prefix ~= "cl_" ) then
			include( filePath );
		end;
	else
		if( prefix ~= "sv_" ) then
			include( filePath );
		end;
	end;
end;

function Capes:LoadDir(dirPath)
	local files, dirs = file.Find( dirPath .. "/*", "LUA" );
	for _,file in pairs(files) do
		local filePath = dirPath .. '/' .. file;
		self:LoadFile(filePath);
	end;
	for _,dir in pairs( dirs ) do
		PrintTable(files);
		local dirPath = dirPath .. dir;
		self:LoadDir(dirPath);
	end;
end;
print('Capes SH Loaded!');

if (SERVER) then
	include('sv_init.lua');
	AddCSLuaFile('cl_init.lua');
else
	include('cl_init.lua');
end;

-- Load classes
Capes:LoadDir('capes/classes');
Capes:LoadDir('capes/libraries');