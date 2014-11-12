<cfsetting enablecfoutputonly = true />
<!---
	Name         : breadcrumbs.cfm
	Author       : Raymond Camden
	Created      : June 10, 2004
	Last Updated : October 12, 2007
	History      : Reset for V2
	Purpose		 : Used by the main page template to generate a bread crumb.
--->

<cfoutput>
<!-- Bread Crumbs Start -->
	<div class="breadCrumbs">
		<a href="f.index.cfm">Forums</a>
		<cfif isDefined("REQUEST.conference")>
			&gt; <a href="f.forums.cfm?conferenceid=#REQUEST.conference.id#">#REQUEST.conference.name#</a>
		</cfif>
		<cfif isDefined("REQUEST.forum")>
			&gt; <a href="f.threads.cfm?forumid=#REQUEST.forum.id#">#REQUEST.forum.name#</a>
		</cfif>
		<cfif isDefined("REQUEST.thread")>
			&gt; <a href="f.messages.cfm?threadid=#REQUEST.thread.id#">#REQUEST.thread.name#</a>
		</cfif>
	</div>
<!-- Bread Crumbs Ender -->
</cfoutput>

<cfsetting enablecfoutputonly = false />

<cfexit method="EXITTAG">