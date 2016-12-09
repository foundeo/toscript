component extends="BaseConverter" {
	
	public string function toScript(tag) {
		return reReplace(toScriptGeneric(tag), "\);$", ") {");
	}
		
	public boolean function indentBody() {
		return true;
	}

	public string function toScriptEndTag(tag) {
		return "}";
	}
}