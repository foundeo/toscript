component {
	this.rootPath = reReplace(getDirectoryFromPath(getCurrentTemplatePath()), "tests[/\\]$", "");
	this.mappings = {
		"/cfmlparser":this.rootPath & "cfmlparser",
		"/toscript":this.rootPath,
		"/testbox" = getDirectoryFromPath(getCurrentTemplatePath()) & "testbox",
		"/tests" = getDirectoryFromPath(getCurrentTemplatePath()) & "tests"
	};

	public boolean function onRequestStart(string templatePath) {
		if (isLocalHost(cgi.remote_addr)) {
			return true;
		}
		writeOutput("Sorry localhost only please.");
		return false;	
	}
}