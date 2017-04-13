component extends="BaseConverter" {

	public string function toScript(tag) {
		var s = toScriptGeneric(tag=arguments.tag);
		
		if (tag.hasInnerContent()) {
			//has child tags so use block form
			s = reReplace(s, ";$", " {");
		} 
		return s;
	}

	public boolean function indentBody(tag) {
		return tag.hasInnerContent();
	}

	public string function toScriptEndTag(tag) {
		if (tag.hasInnerContent()) {
			return "}";
		} else {
			return "";
		}
	}
}