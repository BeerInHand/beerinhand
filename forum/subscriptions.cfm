<cfsetting enablecfoutputonly = true />
<cfif not SESSION.LoggedIn>
	<cfset thisPage = CGI.script_name & "?" & CGI.query_string>
	<cflocation url="p.login.cfm?ref=#urlEncodedFormat(thisPage)#" addToken="false">
</cfif>
<!--- attempt to subscribe --->
<cfif isDefined("URL.s")>
	<cftry>
		<cfif isDefined("URL.threadid")>
			<cfset subMode = "thread">
			<cfset subID = URL.threadID>
			<cfset thread = APPLICATION.FORUM.Thread.getThread(subID)>
			<cfset name = thread.name>
		<cfelseif isDefined("URL.forumid")>
			<cfset subMode = "forum">
			<cfset subID = URL.forumid>
			<cfset forum = APPLICATION.FORUM.Forums.getForum(subID)>
			<cfset name = forum.name>
		<cfelseif isDefined("URL.conferenceid")>
			<cfset subMode = "conference">
			<cfset subID = URL.conferenceid>
			<cfset conference = APPLICATION.FORUM.Conference.getConference(subid)>
			<cfset name = conference.name>
		</cfif>
		<cfcatch>
			<cflocation url="f.index.cfm" addToken="false">
		</cfcatch>
	</cftry>
	<cfif isDefined("VARIABLES.subMode")>
		<cfset APPLICATION.FORUM.User.subscribe(getAuthUser(), subMode, subID)>
		<cfset subscribeMessage = "You have been subscribed to the #submode#: <b>#name#</b>">
	</cfif>
</cfif>
<cfif isDefined("URL.removeAllSub")><!--- attempt to unsubscribe --->
	<cfset subs = APPLICATION.FORUM.User.getSubscriptions(getAuthUser())>
	<cfloop query="subs">
		<cfset APPLICATION.FORUM.User.unsubscribe(getAuthUser(), id)>
	</cfloop>
<cfelseif isDefined("URL.removeSub")>
	<cftry>
		<cfset APPLICATION.FORUM.User.unsubscribe(getAuthUser(), URL.removeSub)>
		<cfset subscribeMessage = "Your unsubscribe request has been processed.<br>">
		<cfcatch>
			<!--- silently fail ---><cfdump var="#cfcatch#"><cfabort>
		</cfcatch>
	</cftry>
</cfif>
<!--- <cfset user = APPLICATION.FORUM.User.getUser(getAuthUser())> --->
<cfset subs = APPLICATION.FORUM.User.getSubscriptions(getAuthUser())>
<cfmodule template="tags/layout.cfm" templatename="main" title="#APPLICATION.FORUM.SETTING.title# : Profile"><!--- Loads header --->
	<cfoutput>
	<div class="ui-widget-header post_title">Subscriptions</div>
	<div class="ui-widget-content">
		<div class="row_0">
			<cfif isDefined("subscribeMessage")>
				<div class="left_90"><p>#subscribeMessage#</p></div>
			</cfif>
			<cfif subs.recordCount is 0>
				<div class="left_90"><p>You are not currently subscribed to anything.</p></div>
			<cfelse>
				<div class="left_90">
					<p>
					<a href="f.subscriptions.cfm?removeAllSub=1">Unsubscribe from all</a>
					<p>
					The following are your subscription(s):
					</p>
				</div>
				<cfloop query="subs">
					<cfif len(conferenceidfk)>
						<cfset data = APPLICATION.FORUM.Conference.getConference(conferenceidfk)>
						<cfset label = "Conference">
						<cfset link = "forums.cfm?conferenceid=#conferenceidfk#">
					<cfelseif len(forumidfk)>
						<cfset data = APPLICATION.FORUM.Forums.getForum(forumidfk)>
						<cfset label = "Forum">
						<cfset link = "threads.cfm?forumid=#threadidfk#">
					<cfelse>
						<cfset data = APPLICATION.FORUM.Thread.getThread(threadidfk)>
						<cfset label = "Thread">
						<cfset link = "messages.cfm?threadid=#threadidfk#">
					</cfif>
					<div class="left_90">
						<p class="left_20">#label#:</p>
						<p class="left_40"><a href="f.#link#">#data.name#</a></p>
						<p class"left_30">[<a href="f.subscriptions.cfm?removeSub=#id#">Unsubscribe</a>]</p>
					</div>
				</cfloop>
			</cfif>
		</div>
	</div>
	</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly = false />
