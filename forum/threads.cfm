<cfsetting enablecfoutputonly = true />
<cfif not isDefined("URL.forumid") or not len(URL.forumid)>
	<cflocation url="f.index.cfm" addToken="false">
</cfif>
<cftry><!--- get parents --->
	<cfset REQUEST.forum = APPLICATION.FORUM.Forums.getForum(URL.forumid)>
	<cfset REQUEST.conference = APPLICATION.FORUM.Conference.getConference(REQUEST.forum.conferenceidfk)>
	<cfcatch>
		<cflocation url="f.index.cfm" addToken="false">
	</cfcatch>
</cftry>
<!--- Am I allowed to look at this? --->
<cfif not APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, URL.forumid, REQUEST.udf.getGroups()) or not APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, REQUEST.conference.id, REQUEST.udf.getGroups())>
	<cflocation url="f.denied.cfm" addToken="false">
</cfif>
<cfset tdata = APPLICATION.FORUM.Thread.getThreads(forumid=URL.forumid)><!--- get my threads --->
<cfset data = tdata.data>
<cfset data = REQUEST.udf.querySort(data,URL.sort,URL.sortdir)><!--- sort --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#APPLICATION.FORUM.SETTING.title# : #REQUEST.conference.name# : #REQUEST.forum.name#"><!--- Loads header --->
	<cfif data.recordCount and data.recordCount gt APPLICATION.FORUM.SETTING.perpage><!--- determine max pages --->
		<cfset pages = ceiling(data.recordCount / APPLICATION.FORUM.SETTING.perpage)>
	<cfelse>
		<cfset pages = 1>
	</cfif>
	<!--- Before we call our header, we need to know if we can write. --->
	<cfif APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANPOST, URL.forumid, REQUEST.udf.getGroups()) and APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANPOST, REQUEST.conference.id, REQUEST.udf.getGroups())>
		<cfset canPost = true>
	<cfelse>
		<cfset canPost = false>
	</cfif>
	<cfmodule template="tags/pagination.cfm" pages="#pages#" mode="threads" canPost="#canPost#" /><!--- Displays pagination on right side, plus left side buttons for threads --->
	<cfoutput>
	<div class="ui-widget-header post_title">#REQUEST.forum.name#</div>
	<div class="ui-widget-content">
		<div class="row_name">
			<div class="left_45 keep_on border_right"><p>#REQUEST.udf.headerLink("Thread","name")#</p></div>
			<div class="left_15 keep_on border_right"><p>#REQUEST.udf.headerLink("Originator","username")#</p></div>
			<div class="left_15 keep_on border_right"><p>#REQUEST.udf.headerLink("Replies","messages")#</p></div>
			<div class="left_auto keep_on"><p>#REQUEST.udf.headerLink("Last Post","lastpostcreated")#</p></div>
		</div>
		<cfif data.recordCount>
			<cfloop query="data" startrow="#(URL.page-1)*APPLICATION.FORUM.SETTING.perpage+1#" endrow="#(URL.page-1)*APPLICATION.FORUM.SETTING.perpage+APPLICATION.FORUM.SETTING.perpage#">
				<!--- I add this because it is possible for a thread to have 0 posts. --->
				<cfif messages is "" or messages is 0>
					<cfset mcount = 0>
				<cfelse>
					<cfset mcount = messages - 1>
				</cfif>
				<div class="row_#currentRow mod 2#">
					<div class="left_45 keep_on border_right"><p><cfif isBoolean(sticky) and sticky><b>[Sticky]</b></cfif> <a href="f.messages.cfm?threadid=#id#">#name#</a></p></div>
					<div class="left_15 keep_on border_right"><p>#username#</p></div>
					<div class="left_15 keep_on border_right"><p>#mcount#</p></div>
					<div class="left_24 keep_on">
						<p>
						<cfif len(lastpostuseridfk)>
							<cfset uinfo = cachedUserInfo(username=lastpostuseridfk,userid=true)>
							<a href="f.messages.cfm?threadid=#id#&last##last">#dateFormat(lastpostcreated,"m/d/yy")# #timeFormat(lastpostcreated,"h:mm tt")#</a> by #uinfo.username#
						<cfelse>
							&nbsp;
						</cfif>
						</p>
					</div>
				</div>
			</cfloop>
		<cfelse>
			<div class="row_1"><p>Sorry, but there are no threads available for this forum.</p></div>
		</cfif>
	</div>
	</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly = false />