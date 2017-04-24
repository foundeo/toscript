<cfsetting requesttimeout="0" />
<cfset converter = new ToScript()>

<!--- Source folder where all the ColdFusion tag files are. --->
<cfparam name="source" default="/source">

<!--- Destination folder where all the CFScript converted ColdFusion files should be saved. --->
<cfparam name="destination" default="/destination">

<cftry>
    <!--- Read Files to convert within directory structure. --->
    <cfdirectory
        action="list"
        directory="#ExpandPath(source)#"
        name="FilesToConvert"
        recurse = "yes"
        filter="*.cfm|*.cfc"
    />

    <cfloop query="#FilesToConvert#">
        <!--- Create destination directory that corresponds to the source directory, for the current file --->
        <cfset scriptDestination = replace(FilesToConvert.Directory, ExpandPath(source), ExpandPath(destination)) />

        <cfif not DirectoryExists(scriptDestination)>
            <cfset DirectoryCreate(scriptDestination) />
        </cfif>

        <cfset scr = converter.toScript(filePath=FilesToConvert.Directory & '/' & FilesToConvert.Name)>
        <cfset fileWrite("#scriptDestination#/#FilesToConvert.Name#", scr.code)>

        <cfoutput>File written:  #scriptDestination#/#FilesToConvert.Name#<br></cfoutput>
    </cfloop>

    <cfcatch type="any">
        <cfheader statuscode="500" statustext="Script Conversion Failed">

        <cfoutput>Script Conversion Issue: #encodeForHTML(cfcatch.message)# -- #encodeForHTML(cfcatch.detail)#</cfoutput>
        <cfif NOT plainText>
            <cfdump var="#cfcatch#" label="Error Details">
        </cfif>
        <cfabort>
    </cfcatch>
</cftry>
<cfabort>