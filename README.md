# toScript()

Converts tag based CFML code into CFML Script.

## Usage

Invoke the `toScript(filePath="", options={}, fileContent="")` function. 

### Options

The `options` struct currently only supports one option `indentChars` which defaults to a tab character. You could pass `{indentChars="    "}` if you wanted to indent with 4 spaces instead of a tabs.

### Example

	converter = new ToScript();
	result = converter.toScript(filePath="someFile.cfc");
	fileWrite("result.cfc", result.src);

## Generated CFML Script

All of the generated script should run on ColdFusion 11+ or Lucee 4.5+ 

Much of it will also run on older versions of CFML, but it depends on which tags you use. 