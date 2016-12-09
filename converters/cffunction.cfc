component extends="BaseConverter" {
	
	public string function toScript(tag) {
		var s = "";
		var attr = tag.getAttributes();
		var children = tag.getChildren();
		var child = "";
		var isFirst = true;
		var inComponent = tag.hasParent() && tag.getParent().getName() == "cfcomponent";
		if (!tag.hasAttributes()) {
			throw(message="cffunction must have attributes");
		}
		if (structKeyExists(attr, "access")) {
			s = attr.access & " ";
		} else if (inComponent) {
			s = "public ";
		}
		if (structKeyExists(attr, "returntype")) {
			s = s & attr.returntype & " ";
		}
		s = s & "function " & attr.name & "(";

		for (child in children) {
			if (child.isTag() && child.getName() == "cfargument") {
				attr = child.getAttributes();
				if (isFirst) {
					isFirst = false;
				} else {
					s = s & ", ";
				}
				if (structKeyExists(attr, "required") && isBoolean(attr.required) && attr.required) {
					s = s & "required ";
				}
				if (structKeyExists(attr, "type")) {
					s = s & attr.type & " ";
				}
				s = s & attr.name;
				if (structKeyExists(attr, "default")) {
					s = s & "=""" & attr.default & """"; 
				}
				
			}
		}
		s = s & ") {";
		return s;
	}

	public boolean function indentBody() {
		return true;
	}

	public string function toScriptEndTag(tag) {
		return "}";
	}

}