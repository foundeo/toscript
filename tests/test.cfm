

<form method="post">
<textarea name="code" rows="10" cols="70" placeholder="Paste in some CFML Tags">

</textarea>
<input type="submit" value="toScript()">
</form>
<cfparam name="form.code" default="">
<cfif len(form.code)>
	<cfset converter = new toscript.ToScript()>
	<cftry>
		<cfset scr = converter.toScript(fileContent=form.code)>
		<cfoutput><pre>#encodeForHTML(scr.code)#</pre></cfoutput>
		<cfdump var="#scr#">
		<cfcatch type="any">
			<cfdump var="#cfcatch#">
		</cfcatch>
	</cftry>
</cfif>

