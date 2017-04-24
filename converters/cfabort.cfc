component extends="BaseConverter" {
	
	public string function toScript(tag) {
		var attr = tag.getAttributes();
		if (structKeyExists(attr, "showerror")) {
			return "abort " & unPound(attr.showerror) & ";";
		}
		return "abort;";
	}
		
}