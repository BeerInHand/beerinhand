<cfsetting enablecfoutputonly = true />
<!---
	Name         : groups.cfm
	Author       : Raymond Camden
	Created      : August 22, 2007
	Last Updated :
	History      :
	Purpose		 :
--->

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Group Editor">

<!--- handle deletions --->
<cfif isDefined("form.mark") and len(form.mark)>
	<cfloop index="id" list="#form.mark#">
		<cfset APPLICATION.FORUM.User.deleteGroup(id)>
	</cfloop>
	<cfset url.msg = "Group(s) deleted.">
</cfif>

<!--- get groups --->
<cfset groups = APPLICATION.FORUM.User.getGroups()>
<!--- remove special --->
<cfquery name="groups" dbtype="query">
select	*
from	groups
where [group] not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="forumsmember,forumsmoderator,forumsadmin">)
</cfquery>


<cfmodule template="../tags/datatable.cfm"
		  data="#groups#" list="group"
		  message="(Please note that you are not allowed to edit or delete the three core groups: forumsmember, forumsmoderator, forumsadmin.)"
		  editlink="z.groups_edit.cfm" linkcol="group" label="Group" />


</cfmodule>

<cfsetting enablecfoutputonly = false />