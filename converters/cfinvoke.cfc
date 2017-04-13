component extends="BaseConverter" {

	public string function toScript(tag) {
		return reReplace(toScriptGeneric(tag), "\);$", ") { //bug in lucee, see: https://luceeserver.atlassian.net/browse/LDEV-1110");
	}
		
	public boolean function indentBody(tag) {
		return true;
	}

	public string function toScriptEndTag(tag) {
		return "}";
	}

}