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
		cfquery( dbtype="query", name="local.result" ) {

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
	}

	public function testLoopListDelimiters() {
		var list = "Apple;Orange;Watermellon";
		var f = "";
		var i = 0;
		for ( f in listToArray( list, ";" ) ) {
			i = i+1;
			$assert.isEqual(f, listGetAt(list, i, ";"));
		}
	}

	public function testTryCatch() {
		try {
			local.x = 5/0;
		} catch (any cfcatch) {
			$assert.isTrue(true);
		}
	}

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

	public function testCFHTTP() {
		var httpResult = "";
		cfhttp( url="http://httpbin.org/status/200", timeout=10, result="httpResult" );
		$assert.includes(httpResult.statusCode,"200");
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
	}

}
