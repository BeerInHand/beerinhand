<cfinclude template="#APPLICATION.PATH.ROOT#/forum/includes/udf.cfm">
<cfif FindNoCase("threads.cfm", LOCAL.LoadPage)>
	<cfif NOT StructKeyExists(URL, "sort")><cfset URL.sort = "lastpostcreated" /></cfif>
	<cfif NOT StructKeyExists(URL, "sortdir")><cfset URL.sortdir = "desc" /></cfif>
<cfelseif FindNoCase("forums.cfm", LOCAL.LoadPage)>
	<cfif NOT StructKeyExists(URL, "sort")><cfset URL.sort = "rank,name" /></cfif>
	<cfif NOT StructKeyExists(URL, "sortdir")><cfset URL.sortdir = "asc" /></cfif>
<cfelse>
	<cfif NOT StructKeyExists(URL, "sort")><cfset URL.sort = "name" /></cfif>
	<cfif NOT StructKeyExists(URL, "sortdir")><cfset URL.sortdir = "asc" /></cfif>
</cfif>
