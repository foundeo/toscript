component extends="BaseConverter" {
	
	public string function toScript(tag) {
		var s = "switch ";
		var attr = tag.getAttributes();
		if (!tag.hasAttributes() || !structKeyExists(attr, "expression")) {
			throw(message="cfswitch must have expression");
		}
		s = s & "( " & trim(unPound(attr.expression)) & " ) {";
		return s;
	}

	public boolean function indentBody() {
		return true;
	}

	public string function toScriptEndTag(tag) {
		return "}";
	}
	
}