<cfsetting enablecfoutputonly = true />
<cfif not SESSION.LoggedIn>
	<cfset thisPage = CGI.script_name & "?" & CGI.query_string>
	<cflocation url="p.login.cfm?ref=#urlEncodedFormat(thisPage)#" addToken="false">
</cfif>
<cfif structKeyExists(url, "del")>
	<cfset APPLICATION.FORUM.User.deletePrivateMessage(URL.del,getAuthUser())>
</cfif>
<cfparam name="URL.sort" default="sent">
<cfparam name="URL.sortdir" default="dir">
<cfset data = APPLICATION.FORUM.User.getPrivateMessages(getAuthUser(),sort,sortdir)>
<cfmodule template="tags/layout.cfm" templatename="main" title="#APPLICATION.FORUM.SETTING.title# : Private Messages"><!--- Loads header --->
	<!--- determine max pages --->
	<cfif data.recordCount and data.recordCount gt APPLICATION.FORUM.SETTING.perpage>
		<cfset pages = ceiling(data.recordCount / APPLICATION.FORUM.SETTING.perpage)>
	<cfelse>
		<cfset pages = 1>
	</cfif>
	<!--- clean up possible CSS attack --->
	<cfset qs = replaceList(CGI.query_string,"<,>",",")>
	<cfparam name="URL.page" default=1>
	<cfmodule template="tags/pagination.cfm" pages="#pages#" mode="messages" showButtons="false" />
	<!--- Now display the table. This changes based on what our data is. --->
	<cfoutput>
	<div class="ui-widget-header post_title">Private Messages</div>
	<div class="ui-widget-content">
		<table class="datagrid noborder" width="100%" cellspacing="0">
			<thead>
				<tr>
					<th class="icon" width="25"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiIcon" src="bih-icon bih-icon-delete" title="Delete"/></th>
					<th width="150">#REQUEST.udf.headerLink("Sender","sender")#</th>
					<th width="150">#REQUEST.udf.headerLink("Sent","sent")#</th>
					<th>#REQUEST.udf.headerLink("Subject","subject")#</th>
				</tr>
			</thead>
			<tbody>
		<cfif data.recordCount>
			<cfloop query="data" startrow="#(URL.page-1)*APPLICATION.FORUM.SETTING.perpage+1#" endrow="#(URL.page-1)*APPLICATION.FORUM.SETTING.perpage+APPLICATION.FORUM.SETTING.perpage#">
				<tr class="bih-grid-row-stripe#currentRow mod 2#">
					<td><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" href="f.pms.cfm?del=#id#" src="bih-icon bih-icon-delete" title="Delete"/></td>
					<td>#sender#</td>
					<td>#udfUserDateFormat(sent)# #timeFormat(sent,"h:mm tt")#</td>
					<td><cfif unread><b></cfif><a href="f.pm.cfm?id=#id#">#subject#</a><cfif unread></b></cfif></td>
				</tr>
			</cfloop>
		<cfelse>
				<tr><td colspan="4"><p>Sorry, but there are no messages for you.</p></td></tr>
		</cfif>
			</tbody>
		</table>
	</div>
	</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly = false />
