component extends="BaseConverter" {

	public string function toScript(tag) {
		var s = "savecontent ";
		if (tag.hasAttributes()) {
			s = s & trim(tag.getAttributeContent()) & " ";
		}
		return s & "{";
	}

	public boolean function indentBody(tag) {
		return true;
	}

	public string function toScriptEndTag(tag) {
		return "}";
	}
}