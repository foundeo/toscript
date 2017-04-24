component extends="BaseConverter" {
	
	public string function toScript(tag) {
		return "} else {";
	}

	public boolean function indentBody(tag) {
		return true;
	}
	
}