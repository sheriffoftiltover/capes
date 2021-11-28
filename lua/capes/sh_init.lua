/*
	Capes SH Init
*/
Capes = Capes or {};
Capes.Hooks = {};

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
		self:LoadFile(dirPath .. '/' .. file);
	end;
	for _,dir in pairs(dirs) do
		self:LoadDir(dirPath .. '/' .. dir);
	end;
end;

function Capes:RegisterHooks(library)
	local hookTable = library.Hooks or {};
	for hookType, hookFunc in pairs(hookTable) do
		-- If we don't have a table for these hooks, create one
		if (!self.Hooks[hookType]) then
			self.Hooks[hookType] = {};
		end;

		-- Create our callback function for this particular hook
		local func = function(...)
			local returnValue = hookFunc(library, ...);
			if (returnValue) then
				return returnValue;
			end;
		end;

		table.insert(self.Hooks[hookType], func);

		-- Create our hook
		hook.Add(hookType, 'Capes_' .. hookType, function(...)
			local hookFuncs = Capes.Hooks[hookType];
			if (hookFuncs) then
				for _,hookFunc in pairs(hookFuncs) do
					local returnValue = hookFunc(...);
					if (returnValue) then
						return returnValue;
					end;
				end;
			end;
		end);

		print('Added hook: ' .. hookType);
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