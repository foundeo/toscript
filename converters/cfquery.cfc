component extends="BaseConverter" {
	
	public string function toScript(tag) {
		return reReplace(toScriptGeneric(tag), "\);$", ") { //Note: queryExecute() is the preferred syntax but this syntax is easier to convert generically");
	}
		
	public boolean function indentBody(tag) {
		return true;
	}

	public string function toScriptEndTag(tag) {
		return "}";
	}
}