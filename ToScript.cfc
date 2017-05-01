component {
	variables.indentLevel = 0;
	variables.options = {indentChars=Chr(9)};

	public struct function toScript(filePath="", options={}, fileContent="") {
		var codeFile = new cfmlparser.File(filePath=filePath,fileContent=fileContent);
		var statements = codeFile.getStatements();
		var sb = createObject("java", "java.lang.StringBuilder").init(codeFile.getFileLength());
		var outputBuffer = createObject("java", "java.lang.StringBuilder");
		var content = codeFile.getFileContent();
		var s = "";
		var converter = "";
		var i = 0;
		var code = "";
		var handledChar = false;
		var result = {"code":"","errors":[], "converted":false};
		structAppend(variables.options, arguments.options, true);
		if (codeFile.isScript()) {
			//already CFML script
			result.code = codeFile.getFileContent();
			result.converted = false;
			return result;
		}
		for (i=1;i<=codeFile.getFileLength();i++) {
			handledChar = false;
			for (s in statements) {
				if (s.getStartPosition() == i) {
					handledChar = true;
					handleOutput(outputBuffer, sb);
					//start of a tag or comment
					if (s.isComment()) {
						indent(sb);
						if (find(Chr(10), s.getComment())) {
							sb.append("/* ");
							sb.append(s.getComment());
							sb.append("*/");	
						} else {
							sb.append("// ");
							sb.append(s.getComment());
						}
						
						lineBreak(sb);
						//jump to end of comment
						i = s.getEndPosition();
						break;
					} else if (s.isTag()) {
						
						try {
							if (s.getName() == "cfscript") {
								//cfscript does not need a converter so just insert it
								lineBreak(sb);
								indent(sb);
								sb.append(trim(s.getInnerContent()));
								lineBreak(sb);
								i = s.getEndPosition();
								break;
							} else {
								converter = getTagConverter(s.getName());
								code = converter.toScript(s);
								if (s.getName() == "cffunction") {
									// add extra new line to space out functions
									lineBreak(sb);
								} else if (listFindNoCase("cfelse,cfelseif,cfcatch,cffinally", s.getName())) {
									decreaseIndent();
								}

								if (len(code)) {
									indent(sb);
									sb.append(code);
									lineBreak(sb);	
								}	
							}
							
						} catch(any e) {
							arrayAppend(result.errors, {"tag":"|"&s.getName()&"|", "error":e});
							lineBreak(sb);
							indent(sb);
							sb.append("/*");
							sb.append(" toScript ERROR: ");
							sb.append(e.message);
							lineBreak(sb);
							lineBreak(sb);
							indent(sb);
							indent(sb);
							code = s.getText();

							code = replace(code, "*/", "* /");
							sb.append(code);
							lineBreak(sb);
							lineBreak(sb);
							indent(sb);
							sb.append("*/");
							lineBreak(sb);
							lineBreak(sb);
							//jump to end of tag end
							i = s.getEndPosition();
							continue;
						}
						
						if (converter.indentBody(s)) {
							increaseIndent();
						}
						i = s.getStartTagEndPosition();
					}
				} else if (s.getStartPosition() > i) {
					//past current marker
					break;
				} else if (s.isTag() && s.getEndTagStartPosition() == i) {
					handleOutput(outputBuffer, sb);
					handledChar = true;	
					converter = getTagConverter(s.getName());			
					code = converter.toScriptEndTag(s);
					//end tag
					if (code == "}") {
						decreaseIndent();
						if (s.getName() == "cfcomponent") {
							//space out cfcomponent
							lineBreak(sb);
						}
						indent(sb);
						sb.append("}");
						lineBreak(sb);
					} else if (s.getName() == "cfcase" || s.getName() == "cfdefaultcase") {
						indent(sb);
						sb.append("break;");
						lineBreak(sb);
						decreaseIndent();
					}
					i = s.getEndPosition();
				} 
			}
			if (!handledChar) {
				local.outputChar = mid(content, i, 1);
				if (local.outputChar == """") {
					outputBuffer.append("""""");
				} else {
					outputBuffer.append(local.outputChar);
				}
			}
		}
		result.converted = true;
		result.code = sb.toString();
		return result;
	}

	public function getTagConverter(tagName) {
		var converter = "";
		try {
			converter = createObject("component", "converters." & trim(lCase(tagName))).init(options);
		} catch(any e) {
			if (e.type == "Template") {
				//due to compiler error of the CFC
				rethrow;	
			}
			converter = createObject("component", "converters.BaseConverter").init(options);
		}
		return converter;
	}

	private function lineBreak(sb) {
		sb.append(Chr(13));
		sb.append(Chr(10));
	}

	private function indent(sb) {
		if (variables.indentLevel > 0) {
			for (var i=0;i<variables.indentLevel;i++) {
				sb.append(variables.options.indentChars);
			}
		}
	}

	private function increaseIndent() {
		variables.indentLevel = variables.indentLevel+1;
	}

	private function decreaseIndent() {
		variables.indentLevel = variables.indentLevel-1;
		if (variables.indentLevel < 0) {
			variables.indentLevel = 0;
		} 
	}

	private function handleOutput(outputBuffer, sb) {
		if (outputBuffer.length() == 0) {
			return;
		}
		local.outputString = trim(outputBuffer.toString());
		if (len(local.outputString) > 0) {
			lineBreak(sb);
			indent(sb);
			sb.append("writeOutput(""");
			sb.append(outputString);
			sb.append(""");");
			lineBreak(sb);
		}
		outputBuffer.setLength(0);
	}

}