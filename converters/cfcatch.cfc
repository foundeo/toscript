component extends="BaseConverter" {
	
	public string function toScript(tag) {
		var s = "} catch (";
		var attr = tag.getAttributes();
		if (structKeyExists(attr, "type")) {
			s = s & attr.type & " "; 
		} else {
			s = s & "any ";
		}
		if (structKeyExists(attr, "name")) {
			s = s & attr.name; 
		} else {
			s = s & "cfcatch";
		}
		s = s & ") {";
		return s;
	}

	public boolean function indentBody(tag) {
		return true;
	}

	public string function toScriptEndTag(tag) {
		return "";
	}
	
}