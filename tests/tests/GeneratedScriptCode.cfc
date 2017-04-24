/*  
	When you hit run.cfm it will convert 
	TagTemplate.cfc into GeneratedScriptCode.cfc

	This test will require CF11+ or Lucee 4.5+
*/
component extends="testbox.system.BaseSpec" {
	property name="testProperty" default="Bacon";

	public function testFunction() {
		$assert.isTrue(testReturnTrue());
	}

	public function testReturnTrue() {
		return true;
	}

	public function testIfElse() {
		if ( false ) {
			//  should not get here 
			$assert.isTrue(false);
		} else {
			$assert.isFalse(false);
		}
	}

	public function testIfElseIf() {
		if ( false ) {
			//  should not get here 
			$assert.isTrue(false);
		} else if ( true ) {
			$assert.isTrue(true);
		} else {
			$assert.isFalse(true);
		}
	}

	public function testCFQuery() {
		var rows = [ {"id":1,"title":"Dewey defeats Truman"}, {"id":2,"title":"Man walks on Moon"} ];
		var news = news = queryNew("id,title", "integer,varchar", rows);
		$assert.isEqual(arrayLen(rows), news.recordcount);
		cfquery( dbtype="query", name="local.result" ) { //Note: queryExecute() is the preferred syntax but this syntax is easier to convert generically

			writeOutput("SELECT id, title
			FROM news
			WHERE id =");
			cfqueryparam( cfsqltype="cf_sql_integer", value=1 );
		}
		$assert.isEqual(1, local.result.recordcount);
	}

	public function testCFSaveContent() {
		savecontent variable="local.content" {

			writeOutput("Hello World");
		}
		$assert.isEqual("Hello World", local.content);
	}

	public function testSwitch() {
		var fruit = "Apple";
		switch ( fruit ) {
			case  "Orange":
				$assert.isEqual("Orange", fruit);
				break;
			case  "Apple":
				$assert.isEqual("Apple", fruit);
				break;
			default:
				$assert.isNotEqual("Orange", fruit);
				$assert.isNotEqual("Apple", fruit);
				break;
		}
	}

	public function testLoopList() {
		var list = "Apple,Orange,Watermellon";
		var f = "";
		var i = 0;
		for ( f in list ) {
			i = i+1;
			$assert.isEqual(f, listGetAt(list, i));
		}
		$assert.isEqual(i, listLen(list));
	}

	public function testLoopListDelimiters() {
		var list = "Apple;Orange;Watermellon";
		var f = "";
		var i = 0;
		for ( f in listToArray( list, ";" ) ) {
			i = i+1;
			$assert.isEqual(f, listGetAt(list, i, ";"));
		}
		$assert.isEqual(i, listLen(list, ";"));
	}

	public function testLoopArray() {
		var a = ["Apple","Orange","Watermellon"];
		var f = "";
		var i = 0;
		for ( f in a ) {
			i = i+1;
			$assert.isEqual(f, a[i]);
		}
		$assert.isEqual(i, arrayLen(a));
	}

	public function testLoopArrayItem() {
		var a = ["Apple","Orange","Watermellon"];
		var f = "";
		var i = 0;
		if ( structKeyExists(server, "lucee") || listFirst(server.coldfusion.productversion) >= 2016 ) {
			for ( f in a ) {
				i = i+1;
				$assert.isEqual(f, a[i]);
			}
			$assert.isEqual(i, arrayLen(a));
		}
	}

	public function testLoopArrayItemAndIndex() {
		var a = ["Apple","Orange","Watermellon"];
		var f = "";
		var i = 0;
		if ( structKeyExists(server, "lucee") || listFirst(server.coldfusion.productversion) >= 2016 ) {
			i=0; for ( f in a ) { i++;
				$assert.isEqual(f, a[i]);
			}
			$assert.isEqual(i, arrayLen(a));
		}
	}

	public function testLoopCollection() {
		var st = {"Apple"=1,"Orange"=2,"Watermellon"=3};
		var f = "";
		var i = 0;
		for ( f in st ) {
			if ( f == "Apple" ) {
				$assert.isEqual(st[f], 1);
			} else if ( f == "Orange" ) {
				$assert.isEqual(st[f], 2);
			} else if ( f == "Watermellon" ) {
				$assert.isEqual(st[f], 3);
			} else {
				//  should not reach this 
				$assert.isEqual(st[f], -1);
			}
			i = i + 1;
		}
		$assert.isEqual(structCount(st), i);
	}

	public function testTryCatch() {
		try {
			local.x = 5/0;
		} catch (any cfcatch) {
			$assert.isTrue(true);
		}
	}
	/*  
		Known issue in lucee: https://luceeserver.atlassian.net/browse/
		Throws a compiler error
	<cffunction name="testCFInvoke">
		<cfset var answer = 0>
		<cfif NOT structKeyExists(server, "lucee")>
			<cfinvoke webservice="http://soaptest.parasoft.com/calculator.wsdl" method="add" returnvariable="answer">
			    <cfinvokeargument name="x" value="2">
			    <cfinvokeargument name="y" value="3">
			</cfinvoke>
			<cfset $assert.isEqual(answer, 5)>
		</cfif>
	</cffunction>
	*/

	public function testTryCatchFinally() {
		finallyRan = false;
		try {
			local.x = 5/0;
		} catch (any cfcatch) {
			$assert.isTrue(true);
		} finally {
			finallyRan = true;
		}
		$assert.isTrue(finallyRan);
	}

	public function testBreak() {
		var i = 0;
		for ( i=1 ; i<=10 ; i++ ) {
			if ( i == 8 ) {
				break;
			}
		}
		$assert.isEqual(i, 8);
	}

	public function testContinue() {
		var i = 0;
		for ( i=1 ; i<=10 ; i++ ) {
			if ( i < 5 ) {
				continue;
			}
			$assert.isGTE(i, 5);
		}
	}

	public function testArguments() {
		$assert.isEqual(add(), 8, "Testing arg defaults");
		$assert.isEqual(add(a=3, b=2), 5, "Testing named arguments");
		$assert.isEqual(add(6,1), 7, "Testing unnamed arguments");
	}

	private numeric function add(numeric a="5", numeric b="3") {
		return arguments.a + arguments.b;
	}
	/*  
		not actually executing the syntaxChecks function (access private) 
		just including them to make sure they do not throw syntax errors 
	*/

	private function syntaxChecks() {
		abort;
		location( "/", false );
		include "functions.cfm";
		writeDump( var=variables );
	}

	public function testCFHTTPWithParams() {
		var httpResult = "";
		cfhttp( url="https://httpbin.org/headers", timeout=3, result="httpResult", method="GET" ) {
			cfhttpparam( name="X-Cow-Says", type="header", value="MOO" );
		}
		$assert.isTrue(isJSON(httpResult.fileContent), "HTTP Result should be JSON");
		local.resultHeaders = deserializeJSON(httpResult.fileContent);
		debug(local.resultHeaders);
		$assert.key(local.resultHeaders.headers, "X-Cow-Says", "Should return X-Cow-Says header");
		$assert.isEqual(local.resultHeaders.headers["X-Cow-Says"], "MOO", "Cow says MOO!");
	}

	public function testCFHTTPWithoutParams() {
		var httpResult = "";
		var userAgent = "Test: " & createUUID();
		cfhttp( useragent=userAgent, url="https://httpbin.org/user-agent", timeout=3, result="httpResult", method="GET" );
		$assert.isTrue(isJSON(httpResult.fileContent), "HTTP Result should be JSON");
		local.resultData = deserializeJSON(httpResult.fileContent);
		$assert.key(local.resultData, "user-agent", "Should return user-agent");
		$assert.isEqual(local.resultData["user-agent"], userAgent);
	}

}
