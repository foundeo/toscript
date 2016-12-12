component extends="BaseConverter" {

	public string function toScript(tag) {
		return trim("return " & trim(convertOperators(tag.getAttributeContent(stripTrailingSlash=true)))) & ";"; 
	}
}