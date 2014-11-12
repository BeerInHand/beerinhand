<cfsetting enablecfoutputonly = true />

<cfquery name="cstats" datasource="#APPLICATION.DSN.FORUM#">
select	count(id) as conferencecount
from	forum_conferences
</cfquery>

<cfquery name="fstats" datasource="#APPLICATION.DSN.FORUM#">
select	count(id) as forumcount
from	forum_forums
</cfquery>

<cfquery name="tstats" datasource="#APPLICATION.DSN.FORUM#">
select	count(id) as threadcount
from	forum_threads
</cfquery>

<cfquery name="ustats" datasource="#APPLICATION.DSN.FORUM#">
select	count(id) as usercount
from	forum_users
</cfquery>


<cfquery name="mstats" datasource="#APPLICATION.DSN.FORUM#">
select	count(id) as messages, min(posted) as earliestpost,
		max(posted) as lastpost
from	forum_messages
</cfquery>

<cfquery name="wstats" datasource="#APPLICATION.DSN.FORUM#">
select	count(id) as messages
from	forum_messages
where	posted > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd("d", -7, now())#">
</cfquery>

<cfoutput>
<div class="clearer"></div>
<div class="name_row"><p class="left_100"></p></div>
<div class="dataset ui-widget-content">
	<div class="row_0">
		<p class="left_50"><span>Number of Conferences:</span></p>
		<p class="left40">#numberFormat(cstats.conferenceCount)#</p>
		<div class="clearer"></div>
	</div>
	<div class="row_1">
		<p class="left_50"><span>Number of Forums:</span></p>
		<p class="left40">#numberFormat(fstats.forumCount)#</p>
		<div class="clearer"></div>
	</div>
	<div class="row_0">
		<p class="left_50"><span>Number of Threads:</span></p>
		<p class="left40">#numberFormat(tstats.threadCount)#</p>
		<div class="clearer"></div>
	</div>
	<div class="row_1">
		<p class="left_50"><span>Number of Messages:</span></p>
		<p class="left40">#numberFormat(mstats.messages)#</p>
		<div class="clearer"></div>
	</div>
	<div class="row_1">
		<p class="left_50"><span>Messages Posted This Week:</span></p>
		<p class="left40">#numberFormat(wstats.messages)#</p>
		<div class="clearer"></div>
	</div>
	<div class="row_0">
		<p class="left_50"><span>First Post:</span></p>
		<p class="left40">#dateFormat(mstats.earliestPost, "m/d/yy")# #timeFormat(mstats.earliestPost, "h:mm tt")#</p>
		<div class="clearer"></div>
	</div>
	<div class="row_1">
		<p class="left_50"><span>Last Post:</span></p>
		<p class="left40">#dateFormat(mstats.lastPost, "m/d/yy")# #timeFormat(mstats.lastPost, "h:mm tt")#</p>
		<div class="clearer"></div>
	</div>
	<div class="row_0">
		<p class="left_50"><span>Number of Users:</span></p>
		<p class="left40">#numberFormat(ustats.userCount)#</p>
		<div class="clearer"></div>
	</div>
</div>
</cfoutput>

<cfsetting enablecfoutputonly = false />