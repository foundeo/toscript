<!--- 
	When you hit run.cfm it will convert 
	TagTemplate.cfc into GeneratedScriptCode.cfc

	This test will require CF11+ or Lucee 4.5+
--->
<cfcomponent extends="testbox.system.BaseSpec">
			
	<cfproperty name="testProperty" default="Bacon">

	<cffunction name="testFunction">
		<cfset $assert.isTrue(testReturnTrue())>
	</cffunction>

	<cffunction name="testReturnTrue">
		<cfreturn true>
	</cffunction>

	<cffunction name="testIfElse">
		<cfif false>
			<!--- should not get here --->
			<cfset $assert.isTrue(false)>
		<cfelse>
			<cfset $assert.isFalse(false)>
		</cfif>
	</cffunction>

	<cffunction name="testIfElseIf">
		<cfif false>
			<!--- should not get here --->
			<cfset $assert.isTrue(false)>
		<cfelseif true>
			<cfset $assert.isTrue(true)>
		<cfelse>
			<cfset $assert.isFalse(true)>
		</cfif>
	</cffunction>

	<cffunction name="testCFQuery">
		<cfset var rows = [ {"id":1,"title":"Dewey defeats Truman"}, {"id":2,"title":"Man walks on Moon"} ]>
		<cfset var news = news = queryNew("id,title", "integer,varchar", rows)>
		<cfset $assert.isEqual(arrayLen(rows), news.recordcount)>
		<cfquery dbtype="query" name="local.result">
			SELECT id, title
			FROM news
			WHERE id = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset $assert.isEqual(1, local.result.recordcount)>
	</cffunction>


	<cffunction name="testCFSaveContent">
		<cfsavecontent variable="local.content">Hello World</cfsavecontent>
		<cfset $assert.isEqual("Hello World", local.content)>
	</cffunction>

	<cffunction name="testSwitch">
		<cfset var fruit = "Apple">
		<cfswitch expression="#fruit#">
			<cfcase value="Orange">
				<cfset $assert.isEqual("Orange", fruit)>
			</cfcase>
			<cfcase value="Apple">
				<cfset $assert.isEqual("Apple", fruit)>
			</cfcase>
			<cfdefaultcase>
				<cfset $assert.isNotEqual("Orange", fruit)>
				<cfset $assert.isNotEqual("Apple", fruit)>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="testLoopList">
		<cfset var list = "Apple,Orange,Watermellon">
		<cfset var f = "">
		<cfset var i = 0>
		<cfloop list="#list#" item="f">
			<cfset i = i+1>
			<cfset $assert.isEqual(f, listGetAt(list, i))>
		</cfloop>
		<cfset $assert.isEqual(i, listLen(list))>
	</cffunction>

	<cffunction name="testLoopListDelimiters">
		<cfset var list = "Apple;Orange;Watermellon">
		<cfset var f = "">
		<cfset var i = 0>
		<cfloop list="#list#" item="f" delimiters=";">
			<cfset i = i+1>
			<cfset $assert.isEqual(f, listGetAt(list, i, ";"))>
		</cfloop>
		<cfset $assert.isEqual(i, listLen(list, ";"))>
	</cffunction>

	<cffunction name="testLoopArray">
		<cfset var a = ["Apple","Orange","Watermellon"]>
		<cfset var f = "">
		<cfset var i = 0>
		<cfloop array="#a#" index="f">
			<cfset i = i+1>
			<cfset $assert.isEqual(f, a[i])>
		</cfloop>
		<cfset $assert.isEqual(i, arrayLen(a))>
	</cffunction>

	<cffunction name="testLoopArrayItem">
		<cfset var a = ["Apple","Orange","Watermellon"]>
		<cfset var f = "">
		<cfset var i = 0>
		<cfif structKeyExists(server, "lucee") OR listFirst(server.coldfusion.productversion) GTE 2016>
			<cfloop array="#a#" index="f">
				<cfset i = i+1>
				<cfset $assert.isEqual(f, a[i])>
			</cfloop>
			<cfset $assert.isEqual(i, arrayLen(a))>
		</cfif>
	</cffunction>

	<cffunction name="testLoopArrayItemAndIndex">
		<cfset var a = ["Apple","Orange","Watermellon"]>
		<cfset var f = "">
		<cfset var i = 0>
		<cfif structKeyExists(server, "lucee") OR listFirst(server.coldfusion.productversion) GTE 2016>
			<cfloop array="#a#" index="i" item="f">
				<cfset $assert.isEqual(f, a[i])>
			</cfloop>
			<cfset $assert.isEqual(i, arrayLen(a))>
		</cfif>
	</cffunction>

	<cffunction name="testLoopCollection">
		<cfset var st = {"Apple"=1,"Orange"=2,"Watermellon"=3}>
		<cfset var f = "">
		<cfset var i = 0>
		<cfloop collection="#st#" item="f">
			<cfif f IS "Apple">
				<cfset $assert.isEqual(st[f], 1)>
			<cfelseif f IS "Orange">
				<cfset $assert.isEqual(st[f], 2)>
			<cfelseif f IS "Watermellon">
				<cfset $assert.isEqual(st[f], 3)>
			<cfelse>
				<!--- should not reach this --->
				<cfset $assert.isEqual(st[f], -1)>
			</cfif>
			<cfset i = i + 1>
		</cfloop>
		<cfset $assert.isEqual(structCount(st), i)>
	</cffunction>

	<cffunction name="testTryCatch">
		<cftry>
			<cfset local.x = 5/0>
			<cfcatch>
				<cfset $assert.isTrue(true)>
			</cfcatch>
		</cftry>
	</cffunction>

	<!--- 
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
	--->

	<cffunction name="testTryCatchFinally">
		<cfset finallyRan = false>
		<cftry>
			<cfset local.x = 5/0>
			<cfcatch>
				<cfset $assert.isTrue(true)>
			</cfcatch>
			<cffinally>
				<cfset finallyRan = true>
			</cffinally>
		</cftry>
		<cfset $assert.isTrue(finallyRan)>
	</cffunction>

	

	<cffunction name="testBreak">
		<cfset var i = 0>
		<cfloop from="1" to="10" index="i">
			<cfif i EQ 8>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfset $assert.isEqual(i, 8)>
	</cffunction>

	<cffunction name="testContinue">
		<cfset var i = 0>
		<cfloop from="1" to="10" index="i">
			<cfif i LT 5>
				<cfcontinue>
			</cfif>
			<cfset $assert.isGTE(i, 5)>
		</cfloop>
		
	</cffunction>

	<cffunction name="testArguments">
		<cfset $assert.isEqual(add(), 8, "Testing arg defaults")>
		<cfset $assert.isEqual(add(a=3, b=2), 5, "Testing named arguments")>
		<cfset $assert.isEqual(add(6,1), 7, "Testing unnamed arguments")>
	</cffunction>

	<cffunction name="add" access="private" returntype="numeric">
		<cfargument name="a" default="5" type="numeric" hint="First number to add">
		<cfargument name="b" default="3" type="numeric" hint="Second number to add">
		<cfreturn arguments.a + arguments.b>
	</cffunction>

	<!--- 
		not actually executing the syntaxChecks function (access private) 
		just including them to make sure they do not throw syntax errors 
	--->
	<cffunction name="syntaxChecks" access="private">
		<cfabort>
		<cflocation url="/" addtoken="false">
		<cfinclude template="functions.cfm">
		<cfdump var="#variables#">
	</cffunction>

	<cffunction name="testCFHTTPWithParams">
		<cfset var httpResult = "">
		<cfhttp url="https://httpbin.org/headers" method="GET" timeout="3" result="httpResult">
			<cfhttpparam type="header" name="X-Cow-Says" value="MOO">
		</cfhttp>
		<cfset $assert.isTrue(isJSON(httpResult.fileContent), "HTTP Result should be JSON")>
		<cfset local.resultHeaders = deserializeJSON(httpResult.fileContent)>
		<cfset debug(local.resultHeaders)>
		<cfset $assert.key(local.resultHeaders.headers, "X-Cow-Says", "Should return X-Cow-Says header")>
		<cfset $assert.isEqual(local.resultHeaders.headers["X-Cow-Says"], "MOO", "Cow says MOO!")>
	</cffunction>

	<cffunction name="testCFHTTPWithoutParams">
		<cfset var httpResult = "">
		<cfset var userAgent = "Test: " & createUUID()> 
		<cfhttp url="https://httpbin.org/user-agent" method="GET" useragent="#userAgent#" timeout="3" result="httpResult">
		<cfset $assert.isTrue(isJSON(httpResult.fileContent), "HTTP Result should be JSON")>
		<cfset local.resultData = deserializeJSON(httpResult.fileContent)>
		<cfset $assert.key(local.resultData, "user-agent", "Should return user-agent")>
		<cfset $assert.isEqual(local.resultData["user-agent"], userAgent)>
	</cffunction>



</cfcomponent>