component extends="BaseConverter" {

	public string function toScript(tag) {
		var s = "";
		var attr = tag.getAttributes();
		
		if (structKeyExists(attr, "hint")) {
			s = "/" & "**" & getLineBreak() & " * " & attr.hint & getLineBreak() & " *";
		}
		
		if (len(s)) {
			s = s & "/" & getLineBreak();
		}
		s = s & "component ";
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