component extends="BaseConverter" {
	
	public string function toScript(tag) {
		var s = "";
		var javaDocs = "";
		var attr = tag.getAttributes();
		var childAttr = "";
		var children = tag.getChildren();
		var child = "";
		var isFirst = true;
		var inComponent = tag.hasParent() && tag.getParent().getName() == "cfcomponent";
		var additionalArgs = "output,roles,returnFormat,secureJSON,verifyClient,restPath,httpMethod,produces,consumes";
		var a = "";
		if (!tag.hasAttributes()) {
			throw(message="cffunction must have attributes");
		}
		// build javadocs to prepend later
		if (structKeyExists(attr, "hint")) {
			javaDocs = "/" & "**" & getLineBreak() & getIndentChars() & " * " & attr.hint & getLineBreak() & getIndentChars() & " *";
		}
		for (a in attr) {
			if (listFindNoCase(additionalArgs, a)) {
				//ignore these go at end
				continue;
			} else if (listFindNoCase("access,returntype,name,hint", a)) {
				//ignore these they go elsewhere
				continue;
			} else {
				if (len(javaDocs) == 0) {
					/* */
					javaDocs = "/" & "**" & getLineBreak() & getIndentChars() & " *";
				}
				javaDocs = javaDocs & " @" & a & " " & attr[a] & getLineBreak() & getIndentChars() & " *";
			}
		}
		if (structKeyExists(attr, "access")) {
			s = s & attr.access & " ";
		} else if (inComponent) {
			s = s & "public ";
		}
		if (structKeyExists(attr, "returntype")) {
			s = s & attr.returntype & " ";
		}
		s = s & "function " & attr.name & "(";

		for (child in children) {
			if (child.isTag() && child.getName() == "cfargument") {
				childAttr = child.getAttributes();
				if (isFirst) {
					isFirst = false;
				} else {
					s = s & ", ";
				}
				if (structKeyExists(childAttr, "required") && isBoolean(childAttr.required) && childAttr.required) {
					s = s & "required ";
				}
				if (structKeyExists(childAttr, "type")) {
					s = s & childAttr.type & " ";
				}
				s = s & childAttr.name;
				if (structKeyExists(childAttr, "default")) {
					s = s & "=""" & childAttr.default & """"; 
				}
				// add hint to javaDocs
				if (structKeyExists(childAttr, "hint")) {
					javaDocs = javaDocs & " @" & childAttr.name & " " & childAttr.hint & getLineBreak() & getIndentChars() & " *";
				}
			}
		}
		s = s & ")";
		//loop over additional args and append them
		for (a in additionalArgs) {
			if (structKeyExists(attr, a)) {
				s = s & " " & a & "=" & unPound(attr[a]);
			}
		}
		s = s & " {";
		// close and prepend javadocs, if any
		if (len(javaDocs)) {
			javaDocs = javaDocs & "/" & getLineBreak() & getIndentChars();
			s = javaDocs & s;
		}
		return s;
	}

	public boolean function indentBody(tag) {
		return true;
	}

	public string function toScriptEndTag(tag) {
		return "}";
	}

}