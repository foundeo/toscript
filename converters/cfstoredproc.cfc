component extends="BaseConverter" {
	
	public string function toScript(tag) {
		return reReplace(toScriptGeneric(tag), "\);$", ") {");
	}

	public boolean function indentBody(tag) {
		return true;
	}
	
	public string function toScriptEndTag(tag) {
		return "}"; //handled by end catch or end finally
	}
}