component extends="BaseConverter" {
	
	public string function toScript(tag) {
		return "try {";
	}

	public boolean function indentBody(tag) {
		return true;
	}
	
	public string function toScriptEndTag(tag) {
		return "}"; //handled by end catch or end finally
	}
}