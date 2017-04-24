component extends="BaseConverter" {

	public string function toScript(tag) {
		var s = "property ";
		if (tag.hasAttributes()) {
			s = s & trim(tag.getAttributeContent(stripTrailingSlash=true));
		}
		return s & ";";
	}

	
}