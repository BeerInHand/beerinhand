<cfsetting enablecfoutputonly = true />
<cfif not isDefined("URL.conferenceid") or not len(URL.conferenceid)>
	<cflocation url="f.index.cfm" addToken="false">
</cfif>
<cftry>
	<cfset REQUEST.conference = APPLICATION.FORUM.Conference.getConference(URL.conferenceid) /><!--- get parent conference --->
	<cfcatch>
		<cflocation url="f.index.cfm" addToken="false">
	</cfcatch>
</cftry>
<cfif not APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, URL.conferenceid, REQUEST.udf.getGroups())><!--- Am I allowed to look at this? --->
	<cflocation url="f.denied.cfm" addToken="false" />
</cfif>
<cfset data = APPLICATION.FORUM.Forums.getForums(conferenceid=URL.conferenceid) /><!--- get my forums --->
<cfset data = APPLICATION.FORUM.Permission.filter(query=data, groups=REQUEST.udf.getGroups(), right=APPLICATION.FORUM.Rights.CANVIEW) /><!--- filter by what I can read... --->
<cfset data = REQUEST.udf.querySort(data,URL.sort,URL.sortdir)/><!--- sort --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#APPLICATION.FORUM.SETTING.title# : #REQUEST.conference.name#"><!--- Loads header --->
	<cfif data.recordCount and data.recordCount gt APPLICATION.FORUM.SETTING.perpage><!--- determine max pages --->
		<cfset pages = ceiling(data.recordCount / APPLICATION.FORUM.SETTING.perpage) />
	<cfelse>
		<cfset pages = 1 />
	</cfif>
	<cfmodule template="tags/pagination.cfm" pages="#pages#" mode="conference" /><!--- Displays pagination on right side, plus left side buttons for threads --->
	<cfoutput>
	<div class="ui-widget ui-widget-header"><p>#REQUEST.conference.name#</p></div>
	<div class="ui-widget-content">
		<div class="row_name">
			<div class="left_20 keep_on border_right"><p>#REQUEST.udf.headerLink("Forum","name")#</p></div>
			<div class="left_40 keep_on border_right"><p>#REQUEST.udf.headerLink("Description")#</p></div>
			<div class="left_10 keep_on border_right"><p>#REQUEST.udf.headerLink("Messages","messages")#</p></div>
			<div class="left_auto keep_on"><p>#REQUEST.udf.headerLink("Last Post","lastpost")#</p></div>
		</div>
		<cfif data.recordCount>
			<cfset cachedUserInfo = REQUEST.udf.cachedUserInfo />
			<cfloop query="data" startrow="#(URL.page-1)*APPLICATION.FORUM.SETTING.perpage+1#" endrow="#(URL.page-1)*APPLICATION.FORUM.SETTING.perpage+APPLICATION.FORUM.SETTING.perpage#">
				<div class="row_#currentRow mod 2#">
					<div class="left_20 keep_on border_right"><p><a href="f.threads.cfm?forumid=#id#">#name#</a></p></div>
					<div class="left_40 keep_on border_right"><p>#description#</p></div>
					<div class="left_10 keep_on border_right"><p>#messages#</p></div>
					<div class="left_auto keep_on">
						<p>
						<cfif len(lastpostuseridfk)>
							<cfset uinfo = cachedUserInfo(username=lastpostuseridfk,userid=true) />
							<a href="f.messages.cfm?threadid=#lastpost#&last##last">#dateFormat(lastpostcreated,"m/d/yy")# #timeFormat(lastpostcreated,"h:mm tt")#</a> by #uinfo.username#
						<cfelse>
							&nbsp;
						</cfif>
						</p>
					</div>
				</div>
			</cfloop>
		<cfelse>
			<div class="row_0">Sorry, but there are no forums available for this conference.</div>
		</cfif>
	</div>
	</cfoutput>
</cfmodule><!--- Loads footer --->
<cfsetting enablecfoutputonly = false />