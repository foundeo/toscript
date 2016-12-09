# toScript()

Converts tag based CFML code into CFML Script.

## Usage

Invoke the `toScript(`

	converter = new ToScript();
	result = converter.toScript(filePath="someFile.cfc");
	fileWrite("result.cfc", result.src);

## Generated CFML Script

All of the generated script should run on ColdFusion 11+ or Lucee 4.5+ 

Much of it will also run on older versions of CFML, but it depends on which tags you use. 