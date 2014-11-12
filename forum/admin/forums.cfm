<cfsetting enablecfoutputonly = true />
<cfmodule template="../tags/layout.cfm" templatename="admin" title="Forum Editor">
	<cfif isDefined("form.mark") and len(form.mark)><!--- handle deletions --->
		<cfloop index="id" list="#form.mark#">
			<cfset APPLICATION.FORUM.Forums.deleteForum(id)>
		</cfloop>
		<cfset url.msg = "Forum(s) deleted.">
	</cfif>
	<cfset forums = APPLICATION.FORUM.Forums.getForums(false)><!--- get forums --->
	<cfmodule template="../tags/datatable.cfm" data="#forums#" list="name,description,conference,lastpostcreated,messages,active"
		classList="left_20,left_25,left_15 center,left_15 center,left_10 center,right_10 center" editlink="z.forums_edit.cfm" linkcol="name" label="Forum" />
</cfmodule>
<cfsetting enablecfoutputonly = false />