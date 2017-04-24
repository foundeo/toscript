component extends="BaseConverter" {

	public string function toScript(tag) {
		var s = toScriptGeneric(tag=arguments.tag);
		
		if (useBlockSyntax()) {
			//has child tags so use block form
			s = reReplace(s, ";$", " {");
		} 
		return s;
	}

	public boolean function indentBody(tag) {
		return useBlockSyntax();
	}

	public string function toScriptEndTag(tag) {
		if (useBlockSyntax()) {
			return "}";
		} else {
			return "";
		}
	}

	public boolean function useBlockSyntax() {
		return tag.hasInnerContent();
	}
}