<cfsetting enablecfoutputonly = true />
<cfparam name="URL.search" default="">
<cfparam name="form.search" default="#URL.search#">
<cfparam name="URL.start" default="1">
<cfparam name="URL.sort" default="username">
<cfparam name="URL.dir" default="asc">
<cfmodule template="../tags/layout.cfm" templatename="admin" title="User Editor">
	<cfif isDefined("form.mark") and len(form.mark)><!--- handle deletions --->
		<cfloop index="id" list="#form.mark#">
			<cfset APPLICATION.FORUM.User.deleteUser(id)>
		</cfloop>
		<cfset URL.msg = "User(s) deleted.">
	</cfif>
	<cfset users = APPLICATION.FORUM.User.getUsers(search=form.search,start=URL.start, sort="#URL.sort# #URL.dir#", max=10)><!--- get users --->
	<cfif APPLICATION.FORUM.SETTING.requireconfirmation>
		<cfset list = "username,emailaddress,postcount,confirmed,datecreated">
	<cfelse>
		<cfset list = "username,emailaddress,postcount,datecreated">
	</cfif>
	<cfoutput>
	<div class="top_input_misc">
		<cfset qs = CGI.query_string>
		<cfset qs = rereplace(qs, "&*page=[0-9]+", "")>
		<form action="#CGI.script_name#?#qs#" method="post">
			<input type="text" name="search" value="#form.search#" class="filter_input"> <input type="image" src="../images/btn_filter.jpg" value="Filter" class="filter_btn">
		</form>
	</div>
	</cfoutput>
	<cfmodule template="../tags/datatablenew.cfm" data="#users.data#" list="#list#" total="#users.total#" perpage=10 start="#URL.start#" nosort="postcount"
		classList="left_20,left_25,left_20 center,left_15 center,left_15" editlink="z.users_edit.cfm" linkcol="username" linkval="username" label="User" linkappend="&search=#urlEncodedFormat(form.search)#" />
</cfmodule>

<cfsetting enablecfoutputonly = false />