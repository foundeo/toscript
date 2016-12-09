component extends="BaseConverter" {
	
	public string function toScript(tag) {
		var s = "location( ";
		var attr = tag.getAttributes();
		if (structKeyExists(attr, "url")) {
			s = s & unPound(attr.url); 
		} else {
			throw(message="cflocation tag must have url attribute");
		}
		if (structKeyExists(attr, "addtoken")) {
			s = s & ", " & unPound(attr.addtoken); 
		} 
		if (structKeyExists(attr, "statuscode")) {
			s = s & ", " & unPound(attr.statuscode); 
		} 

		s = s & " );";
		return s;
	}

	
}