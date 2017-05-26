
nut.config = nut.config or {};
nut.config.__ConfigStruct = nut.config.__ConfigStruct or {};

CONFIG_NET_TYPE_SERVER = 1;
CONFIG_NET_TYPE_CLIENT = 2;
CONFIG_NET_TYPE_SHARE = 3;

CONFIG_VAR_TYPE_NUMBER = "number";
CONFIG_VAR_TYPE_STRING = "string";
CONFIG_VAR_TYPE_BOOL = "boolean";
CONFIG_VAR_TYPE_TABLE = "table";

CONFIG_VAR_VALID_OK = 1;
CONFIG_VAR_VALID_REGISTERED = 2;  
CONFIG_VAR_VALID_NOT_REGISTERED = 3;
CONFIG_VAR_VALID_MISS_MATCHED = 4;

CONFIG_VAR_VALID_IS_REGISTERED = 1;
CONFIG_VAR_VALID_IS_SETABLE = 2;

function nut.config.IsValid(key, value, callType)
	if (callType == CONFIG_VAR_VALID_IS_REGISTERED) then
		if (nut.config.__ConfigStruct[key] != nil) then
			return CONFIG_VAR_VALID_REGISTERED;
		else
			return CONFIG_VAR_VALID_NOT_REGISTERED;
		end
	elseif (callType == CONFIG_VAR_VALID_IS_SETABLE) then
		if (nut.config.__ConfigStruct[key] == nil) then
			return CONFIG_VAR_VALID_NOT_REGISTERED;
		elseif (nut.config.__ConfigStruct[key].VarType != type(value)) then
			return CONFIG_VAR_VALID_MISS_MATCHED;
		else
			return CONFIG_VAR_VALID_OK;
		end
	else
		return CONFIG_VAR_VALID_MISS_MATCHED;
	end
end

function nut.config.Register(key, value, netType)
	local isValid = nut.config.IsValid(key, nil, CONFIG_VAR_VALID_IS_REGISTERED);
	if (isValid == CONFIG_VAR_VALID_REGISTERED) then
		if(nut.config.IsValid(key, value, CONFIG_VAR_VALID_IS_SETABLE) != CONFIG_VAR_VALID_OK) then
			MsgC(Color(255, 0, 0, 255), string.format("Dup Config Register Call, Key : %s / Error Code : %d\n", key, isValid));
		else
			nut.config[key] = value;
		end
	elseif (type(value) != CONFIG_VAR_TYPE_BOOL && type(value) != CONFIG_VAR_TYPE_NUMBER && type(value) != CONFIG_VAR_TYPE_STRING && type(value) != CONFIG_VAR_TYPE_TABLE) then
		MsgC(Color(255, 0, 0, 255), string.format("Not Valid Var Type : %s / Error Code : %d\n", type(value), CONFIG_VAR_VALID_MISS_MATCHED));
	else
		nut.config[key] = value;
		nut.config.__ConfigStruct[key] = {Key = key, VarType = type(value), NetType = netType};
	end
end

function nut.config.Set(key, value)
	local isValid = nut.config.IsValid(key, value, CONFIG_VAR_VALID_IS_SETABLE); 
	if (isValid != CONFIG_VAR_VALID_OK) then
		MsgC(Color(255, 0, 0, 255), string.format("Not Valid Key Value : %s / Error Code : %d\n", key, isValid));
	else
		nut.config[key] = value;
	end
end

function nut.config.Get(key, default)
	return nut.config[key] or default;
end

function nut.config.GetType(key, default)
	local isValid = nut.config.IsValid(key, nil, CONFIG_VAR_VALID_IS_REGISTERED);
	if (isValid == CONFIG_VAR_VALID_NOT_REGISTERED) then
		MsgC(Color(255, 0, 0, 255), string.format("Not Valid Key Valud : %s / Error Code : %d\n", key, isValid));
		return default;
	else
		return nut.config.__ConfigStruct[key].VarType;
	end
end

function nut.config.GetAll()
	local tmpTable = table.Copy(nut.config);
	tmpTable.Register = nil;
	tmpTable.Get = nil;
	tmpTable.GetAll = nil;
	tmpTable.__ConfigStruct = nil;
	
	return tmpTable;
end