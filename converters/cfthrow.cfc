component extends="BaseConverter" {
	
	public string function toScript(tag) {
		return replace(toScriptGeneric(tag), "cfthrow(", "throw(");
	}
		
}