<cfsetting enablecfoutputonly = true />
<cfmodule template="tags/layout.cfm" templatename="main" title="#APPLICATION.FORUM.SETTING.title# : Permission Denied"><!--- Loads header --->
	<cfoutput>
	<p>
	Sorry, but you do not have permissions to view this page.
	</p>
	</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly = false />
