component extends="BaseConverter" {
	
	public string function toScript(tag) {
		var s = "";
		var attr = tag.getAttributes();
		if (!tag.hasAttributes()) {
			throw(message="cfloop must have attributes");
		}
		if (structKeyExists(attr, "condition")) {
			s = "while ( " & trim(convertOperators(tag.getAttributeContent())) & " ) {";	
		} else if (structKeyExists(attr, "array")) {
			if (structKeyExists(attr, "index") && !structKeyExists(attr, "item")) {
				//standard cfloop syntax cf8+
				s = "for ( " & attr.index & " in " & unPound(attr.array) & " ) {";	
			} else if (structKeyExists(attr, "item") && !structKeyExists(attr, "index")) {
				//ACF2016+ or Lucee support using item
				s = "for ( " & attr.item & " in " & unPound(attr.array) & " ) {";
			} else if (structKeyExists(attr, "item") && structKeyExists(attr, "index")) {
				//ACF2016+ or Lucee support using item and index
				s = attr.index & "=0; for ( " & attr.item & " in " & unPound(attr.array) & " ) { " & attr.index & "++;";
			} else {
				throw(message="cfloop array must have index or item arguments.");
			}
		} else if (structKeyExists(attr, "list") && structKeyExists(attr, "item")) {
			s = "for ( " & attr.item & " in ";
			if (structKeyExists(attr, "delimiters")) {
				s = s & "listToArray( " & unPound(attr.list) & ", " & unPound(attr.delimiters) & " )";
			} else {
				s = s & unPound(attr.list);
			}
			s = s & " ) {"; 
		} else if (structKeyExists(attr, "list") && structKeyExists(attr, "index")) {
			s = "for ( " & attr.index & " in ";
			if (structKeyExists(attr, "delimiters")) {
				s = s & "listToArray( " & unPound(attr.list) & ", " & unPound(attr.delimiters) & " )";
			} else {
				s = s & unPound(attr.list);
			}
			s = s & " ) {"; 	
		} else if (structKeyExists(attr, "collection") && structKeyExists(attr, "item")) {
			s = "for ( " & attr.item & " in " & unPound(attr.collection) & " ) {";
		} else if (structKeyExists(attr, "from") && structKeyExists(attr, "to") && structKeyExists(attr, "index")) {
			s = "for ( " & attr.index & "=" & unPound(attr.from) & " ; " & attr.index & "<=" & unPound(attr.to) & " ; " & attr.index;
			if (structKeyExists(attr, "step") && attr.step != 1) {
				s = s & "+" & attr.step;
			} else {
				s = s & "++";
			}
			s = s & " ) {";
		} else {
			throw(message="Unimplemented cfloop condition");
		}
		
		return s;
	}

	public boolean function indentBody(tag) {
		return true;
	}

	public string function toScriptEndTag(tag) {
		return "}";
	}
	
}