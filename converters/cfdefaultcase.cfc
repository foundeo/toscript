component extends="BaseConverter" {
	
	public string function toScript(tag) {
		return "default:";
	}

	public boolean function indentBody() {
		return true;
	}
	
}