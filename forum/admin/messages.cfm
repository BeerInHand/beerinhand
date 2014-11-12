<cfsetting enablecfoutputonly = true />
<cfparam name="url.search" default="">
<cfparam name="form.search" default="#url.search#">
<cfparam name="url.start" default="1">
<cfparam name="url.sort" default="posted">
<cfparam name="url.dir" default="asc">

<cfmodule template="../tags/layout.cfm" templatename="admin" title="Message Editor">
	<!--- handle deletions --->
	<cfif isDefined("form.mark") and len(form.mark)>
		<cfloop index="id" list="#form.mark#">
			<cfset APPLICATION.FORUM.Message.deleteMessage(id)>
		</cfloop>
		<cfset url.msg = "Message(s) deleted.">
	</cfif>
	<!--- get messages --->
	<cfset messages = APPLICATION.FORUM.Message.getMessages(search=form.search, start=url.start, max=10, sort="#url.sort# #url.dir#")>
	<cfoutput>
	<div class="top_input_misc">
		<cfset qs = cgi.query_string>
		<cfset qs = rereplace(qs, "&*page=[0-9]+", "")>
	<form action="#cgi.script_name#?#qs#" method="post">
	<input type="text" name="search" value="#form.search#" class="filter_input"> <input type="image" src="../images/btn_filter.jpg" value="Filter" class="filter_btn">
	</form>
	</div>
	</cfoutput>

	<cfmodule template="../tags/datatablenew.cfm"
			  data="#messages.data#" list="title,posted,threadname,forumname,conferencename,username"
			  total="#messages.total#" perpage=10 start="#url.start#"
			  classList="left_20,left_15,left_20,left_15,left_15,left_10"
			  nosort="threadname,forumname,conferencename,username"
			  editlink="z.messages_edit.cfm" linkcol="title" label="Message" linkappend="&search=#urlEncodedFormat(form.search)#" />


</cfmodule>

<cfsetting enablecfoutputonly = false />