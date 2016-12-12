component extends="BaseConverter" {

	public string function toScript(tag) {
		return replaceNoCase(toScriptGeneric(tag), "cfdump(", "writeDump(");
	}

}