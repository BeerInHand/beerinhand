<cfsetting enablecfoutputonly = true />
<!---
	Name         : layout.cfm
	Author       : Raymond Camden 
	Created      : June 02, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : Loads up templates. Will look in a subdirectory for templates, 
				   and will load #ATTRIBUTES.template#_header.cfm and 
				   #ATTRIBUTES.template#_footer.cfm
--->

<!--- Because "template" is a reserved attribute for cfmodule, we allow templatename as well. --->
<cfif isDefined("ATTRIBUTES.templatename")>
	<cfset ATTRIBUTES.template = ATTRIBUTES.templatename>
</cfif>
<cfparam name="ATTRIBUTES.template">
<cfparam name="ATTRIBUTES.title" default="">

<cfset base = ATTRIBUTES.template>

<cfif thisTag.executionMode is "start">
	<cfset myFile = base & "_header.cfm">
<cfelse>
	<cfset myFile = base & "_footer.cfm">
</cfif>

<cfinclude template="../pagetemplates/#myFile#">

<cfsetting enablecfoutputonly = false />