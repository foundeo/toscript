component extends="BaseConverter" {

	public string function toScript(tag) {
		var i = variables.toscript.getIdentLevel();
		return reReplace( trim(convertOperators(tag.getAttributeContent(stripTrailingSlash=true))) & ";", "\n\t", chr(10) & repeatString( variables.options.indentChars, i ), "all" ); 
	}
}
