component extends="BaseConverter" {
	
	public string function toScript(tag) {
		return "} finally {";
	}
		
	public boolean function indentBody(tag) {
		return true;
	}

	public string function toScriptEndTag(tag) {
		return "";
	}
}