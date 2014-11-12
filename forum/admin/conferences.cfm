<cfsetting enablecfoutputonly = true />
<cfmodule template="../tags/layout.cfm" templatename="admin" title="Conference Editor">
	<cfif isDefined("form.mark") and len(form.mark)><!--- handle deletions --->
		<cfloop index="id" list="#form.mark#">
			<cfset APPLICATION.FORUM.Conference.deleteConference(id)>
		</cfloop>
		<cfset url.msg = "Conference(s) deleted.">
	</cfif>
	<cfset conferences = APPLICATION.FORUM.Conference.getConferences(false)><!--- get conferences --->
	<cfmodule template="../tags/datatable.cfm" data="#conferences#" list="name,description,lastpostcreated,messages,active"
		classlist="left_20,left_30,left_20,left_10 center,right_10 center" editlink="z.conferences_edit.cfm" linkcol="name" label="Conference" />
</cfmodule>
<cfsetting enablecfoutputonly = false />