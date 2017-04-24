component extends="BaseConverter" {

	public string function toScript(tag) {
		var s = toScriptGeneric(tag=arguments.tag);
		
		if (useBlockSyntax(tag)) {
			//has child tags so use block form
			s = reReplace(s, ";$", " {");
		} 
		return s;
	}

	public boolean function indentBody(tag) {
		return useBlockSyntax(tag);
	}

	public string function toScriptEndTag(tag) {
		if (useBlockSyntax(tag)) {
			return "}";
		} else {
			return "";
		}
	}

	public boolean function useBlockSyntax(tag) {
		return tag.hasInnerContent();
	}
}