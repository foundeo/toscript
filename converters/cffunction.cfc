component extends="BaseConverter" {
	
	public string function toScript(tag) {
		var s = "";
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
		if (structKeyExists(attr, "hint")) {
			s = "/" & "**" & getLineBreak() & getIndentChars() & " * " & attr.hint & getLineBreak() & getIndentChars() & " *";
		}
		for (a in attr) {
			if (listFindNoCase(additionalArgs, a)) {
				//ignore these go at end
				continue;
			} else if (listFindNoCase("access,returntype,name,hint", a)) {
				//ignore these they go elsewhere
				continue;
			} else {
				if (len(s) == 0) {
					/* */
					s = "/" & "**" & getLineBreak() & getIndentChars() & " *";
				}
				s = s & " @" & a & " " & attr[a] & getLineBreak() & getIndentChars() & " *";
			}
		}
		if (len(s)) {
			s = s & "/" & getLineBreak() & getIndentChars();
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
		return s;
	}

	public boolean function indentBody(tag) {
		return true;
	}

	public string function toScriptEndTag(tag) {
		return "}";
	}

}