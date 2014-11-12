<cfsetting enablecfoutputonly = true />
<cfoutput>
<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/forum/css/forum.css" />
<cfif isDefined("REQUEST.conference") and APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, REQUEST.conference.id, "")>
	<link rel="alternate" type="application/rss+xml" title="#REQUEST.conference.name# RSS" href="#APPLICATION.PATH.ROOT#/f.rss.cfm?conferenceid=#REQUEST.conference.id#" />
</cfif>
<cfif structKeyExists(APPLICATION.FORUM.SETTING,'bbcode_editor') IS TRUE AND APPLICATION.FORUM.SETTING.bbcode_editor IS TRUE><!-- markItUp! -->
	<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/forum/markitup/skins/markitup/style.css" />
	<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/forum/markitup/sets/default/style.css" />
	<script src="#APPLICATION.PATH.ROOT#/forum/markitup/jquery.markitup.js" type="text/javascript"></script>
	<script src="#APPLICATION.PATH.ROOT#/forum/markitup/sets/default/set.js" type="text/javascript"></script>
</cfif>
<cfif structKeyExists(APPLICATION.FORUM.SETTING,'bbcode_editor') IS TRUE AND APPLICATION.FORUM.SETTING.bbcode_editor IS TRUE>
	<script type="text/javascript">$(document).ready(function()	{ $('##markitup').markItUp(mySettings) })</script>
</cfif>
<div id="divForum"><!-- THIS DIV IS CLOSED IN main_footer.cfm -->
	<div id="divForumMenu">
		<div class="top_menu">
			<cfif SESSION.LoggedIn>
				<cfif isUserInRole("forumsadmin")>
					<a href="z.index.cfm">Admin</a> |
				</cfif>
				<a href="f.subscriptions.cfm">Subscriptions</a> |
				<cfif APPLICATION.FORUM.SETTING.allowpms>
					<cfset totalunread = APPLICATION.FORUM.User.getUnreadMessageCount(getAuthUser())>
					<cfif totalunread neq 0>
						<a href="f.pms.cfm"> (#totalunread#) Messages</a> |
					<cfelse>
						<a href="f.pms.cfm">Messages</a> |
					</cfif>
				</cfif>
			</cfif>
			<a href="f.search.cfm">Search</a>
			<cfif isDefined("REQUEST.conference") and APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, REQUEST.conference.id, "")>
				|  <a href="f.rss.cfm?conferenceid=#REQUEST.conference.id#">RSS</a>
			</cfif>
		</div>
		<cfmodule template="../tags/breadcrumbs.cfm" />
	</div>
</cfoutput>
<cfsetting enablecfoutputonly = false />
