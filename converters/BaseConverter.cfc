component {
	variables.options = {};
	public function init(options) {
		variables.options = arguments.options;
		return this;
	}

	public string function toScript(tag) {
		if (listFindNoCase("cfcontent,cfcookie,cfheader,cfdbinfo,cfdirectory,cfexecute,cffeed,cffile,cffileupload,cfflush,cfftp,cfimage,cfldap,cflog,cfparam,cfpop,cfprint,cfquery,cfqueryparam,cfprocparam,cfhttp,cfhttpparam,cfoutput,cfinvokeargument,cfsetting,cfprocessingdirective,cfmailparam,cflogout,cfloginuser", tag.getName())) {
			//do generic CF11+ conversion
			return toScriptGeneric(tag);
		}
		throw(message="Unable to convert tag: " & tag.getName() & " to CFML Script");
	}

	public string function toScriptEndTag(tag) {
		return "";
	}

	public boolean function indentBody(tag) {
		return false;
	}

	public string function convertOperators(str) {
		arguments.str = replaceNoCase(arguments.str, " EQ ", " == ", "ALL");
		arguments.str = replaceNoCase(arguments.str, " NEQ ", " != ", "ALL");
		arguments.str = replaceNoCase(arguments.str, " IS NOT ", " != ", "ALL");
		arguments.str = replaceNoCase(arguments.str, " IS ", " == ", "ALL");
		arguments.str = replaceNoCase(arguments.str, " GT ", " > ", "ALL");
		arguments.str = replaceNoCase(arguments.str, " LT ", " < ", "ALL");
		arguments.str = replaceNoCase(arguments.str, " LTE ", " <= ", "ALL");
		arguments.str = replaceNoCase(arguments.str, " GTE ", " >= ", "ALL");
		arguments.str = replaceNoCase(arguments.str, " NOT ", " !", "ALL");
		arguments.str = replaceNoCase(arguments.str, " AND ", " && ", "ALL");
		arguments.str = replaceNoCase(arguments.str, " OR ", " || ", "ALL");
		return arguments.str;
	}

	public string function unPound(str) {
		if (left(arguments.str, 1) == "##" && right(arguments.str,1) == "##" && len(arguments.str) > 2) {
			return mid(arguments.str, 2, len(arguments.str)-2);
		} else if (isNumeric(str)) {
			return arguments.str;
		} else if (str == "yes") {
			return "true";
		} else if (str == "no") {
			return "false";
		} else if (str == "true" || str == "false") {
			return arguments.str;
		}
		return """" & arguments.str & """";
	}

	/**
	 * Does the generic CF11+ conversion format cftag(arg1=a,arg2=b) 
	 */
	public string function toScriptGeneric(tag) {
		var s = trim(lCase(tag.getName())) & "( ";
		var attributes = tag.getAttributes();
		var attr = "";
		var first = true;
		for (attr in attributes) {
			if (!first) { 
				s&= ", "; 
			}
			s &= attr & "=" & unPound(attributes[attr]);
			first = false;
		}
		return s & " );";
	}

	public string function getIndentChars() {
		if (structKeyExists(variables.options, "indentChars")) {
			return variables.options.indentChars;
		} else {
			return Chr(9);
		}
	}

	public string function getLineBreak() {
		return Chr(13) & Chr(10);
	}

}