component extends="BaseConverter" {
	
	public string function toScript(tag) {
		var s = "if ";
		if (!tag.hasAttributes()) {
			throw(message="cfif must have attributes");
		}
		s = s & "( " & trim(convertOperators(tag.getAttributeContent())) & " ) {";
		return s;
	}

	public boolean function indentBody(tag) {
		return true;
	}
	
	public string function toScriptEndTag(tag) {
		return "}";
	}
}