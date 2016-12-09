component extends="BaseConverter" {

	public string function toScript(tag) {
		return "return" & convertOperators(tag.getAttributeContent()) & ";"; 
	}
}