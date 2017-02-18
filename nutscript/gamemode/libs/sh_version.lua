hook.Add("BuildHelpOptions", "AdvNut_VersionCounter", function(data, tree)
	data:AddHelp("버전", function(tree)
		return nut.lang.Get("framework_version", nut.config.frameworkVersion);
	end, "icon16/server.png");
end);