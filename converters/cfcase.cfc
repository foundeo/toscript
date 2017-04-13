component extends="BaseConverter" {
	
	public string function toScript(tag) {
		var s = "case ";
		var attr = tag.getAttributes();
		if (!tag.hasAttributes() || !structKeyExists(attr, "value")) {
			throw(message="cfcase must have value");
		}
		s = s & " " & trim(unPound(attr.value)) & ":";
		return s;
	}

	public boolean function indentBody(tag) {
		return true;
	}
	
}