component extends="BaseConverter" {
	
	public string function toScript(tag) {
		var s = "include ";
		var attr = tag.getAttributes();
		if (structKeyExists(attr, "template")) {
			s = s & unPound(attr.template); 
		} else {
			throw(message="cfinclude tag must have template attribute");
		}
		if (structKeyExists(attr, "runonce")) {
			s = s & " runonce=" & unPound(attr.runonce); 
		} 
		s = s & ";";
		return s;
	}

	
}