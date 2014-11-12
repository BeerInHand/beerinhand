<cfsetting enablecfoutputonly = true />
<cfset data = APPLICATION.FORUM.Conference.getConferences() /><!--- get my conferences --->
<cfset data = APPLICATION.FORUM.Permission.filter(query=data, groups=REQUEST.udf.getGroups(), right=APPLICATION.FORUM.Rights.CANVIEW) /><!--- filter by what I can read... --->
<cfif data.recordCount is 1><!--- if just one, auto go to a forums for it --->
	<cflocation url="f.forums.cfm?conferenceid=#data.id#" addToken="false" />
</cfif>
<cfset data = REQUEST.udf.querySort(data,URL.sort,URL.sortdir) /><!--- sort --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#APPLICATION.FORUM.SETTING.title#"><!--- Loads header --->
	<cfif data.recordCount and data.recordCount gt APPLICATION.FORUM.SETTING.perpage><!--- determine max pages --->
		<cfset pages = ceiling(data.recordCount / APPLICATION.FORUM.SETTING.perpage) />
	<cfelse>
		<cfset pages = 1 />
	</cfif>
	<cfmodule template="tags/pagination.cfm" pages="#pages#" /><!--- Displays pagination on right side, plus left side buttons for threads --->
	<!--- Now display the table. This changes based on what our data is. --->
	<cfoutput>
	<div class="ui-widget-header post_title">Conferences</div>
	<div class="ui-widget-content">
		<div class="row_name">
			<div class="left_20 keep_on border_right"><p>#REQUEST.udf.headerLink("Name")#</p></div>
			<div class="left_40 keep_on border_right"><p>#REQUEST.udf.headerLink("Description")#</p></div>
			<div class="left_10 keep_on border_right"><p>#REQUEST.udf.headerLink("Messages","messages")#</p></div>
			<div class="left_auto keep_on"><p>#REQUEST.udf.headerLink("Last Post","lastpost")#</p></div>
		</div>
		<cfif data.recordCount>
			<!--- Have to 'fake out' CF since it doesn't like named params with udfs in a struct --->
			<cfset cachedUserInfo = REQUEST.udf.cachedUserInfo />
			<cfloop query="data" startrow="#(URL.page-1)*APPLICATION.FORUM.SETTING.perpage+1#" endrow="#(URL.page-1)*APPLICATION.FORUM.SETTING.perpage+APPLICATION.FORUM.SETTING.perpage#">
				<div class="row_#currentRow mod 2#">
					<div class="left_20 keep_on border_right"><p><a href="f.forums.cfm?conferenceid=#id#">#name#</a></p></div>
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
			<div class="row_0"><p>Sorry, but there are no conferences available.</p></div>
		</cfif>
	</div>
	</cfoutput>
</cfmodule><!--- Loads footer --->
<cfsetting enablecfoutputonly = false />
