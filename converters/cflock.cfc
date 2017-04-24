component extends="BaseConverter" {
	
	public string function toScript(tag) {
		var s = "lock ";
		var attr = tag.getAttributes();
		s = s & trim(tag.getAttributeContent(stripTrailingSlash=true));

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