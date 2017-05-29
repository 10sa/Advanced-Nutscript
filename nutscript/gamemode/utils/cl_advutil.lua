AdvNut.util = nut.util or {};

function AdvNut.util.WriteTable(uniqueID, value)
	if (type(value) != "table") then
		value = {value}
	end

	local encoded = pon.encode(value);
	file.CreateDir("AdvNutscript/data/");
	file.Write("AdvNutscript/data/"..uniqueID..".txt", encoded);
end;

function AdvNut.util.ReadTable(uniqueID)
	local data = file.Read("AdvNutscript/data/"..uniqueID..".txt", "DATA");
	
	if (data) then
		return pon.decode(data);
	else
		return {};
	end;
end;