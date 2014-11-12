<cfsetting enablecfoutputonly = true />
<cfscript>
function navon(s) {
	var l = "";
	var i = "";
	for(i=1; i lte listLen(s);i=i+1) {
		l = listGetAt(s, i);
		if(find(l,CGI.script_name)) return "ui-widget-content ui-state-hover";
	}
	return "ui-widget-content";
}
</cfscript>
<cfoutput>
<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/forum/css/forum.css" />
<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/forum/css/admin.css" />
<div id="divForum"> <!--- THIS DIV IS CLOSED IN admin_header.cfm --->
	<div id="divForumLeft">
		<div class="nav_title ui-widget-header">Forum Options</div>
		<a href="z.conferences.cfm" name="Conferences" class="#navOn('conferences.cfm,conferences_edit.cfm')#">Conferences</a>
		<a href="z.forums.cfm" name="Forums" class="#navOn('forums.cfm,forums_edit.cfm')#">Forums</a>
		<a href="z.threads.cfm" name="Threads" class="#navOn('threads.cfm,threads_edit.cfm')#">Threads</a>
		<a href="z.messages.cfm" name="Messages" class="#navOn('messages.cfm,messages_edit.cfm')#">Messages</a>
		<a href="z.ranks.cfm" name="Ranks" class="#navOn('ranks.cfm,ranks_edit.cfm')#">Ranks</a>
		<a href="z.settings.cfm" name="Galleon Settings" class="#navOn('settings.cfm')#">Forum Settings</a>
		<a href="z.reset_stats.cfm" name="Reset Stats" class="#navOn('reset_stats.cfm')#">Reset Stats</a>
		<div class="nav_breaker"></div>
		<div class="nav_title ui-widget-header">Security Options</div>
		<a href="z.groups.cfm" name="Group Editor" class="#navOn('groups.cfm,groups_edit.cfm')#">Group Editor</a>
		<a href="z.users.cfm" name="User Editor" class="#navOn('users.cfm,users_edit.cfm')#">User Editor</a>
		<div class="nav_breaker"></div>
		<div class="nav_title ui-widget-header">Stats</div>
		<!---<a href="z.stats.cfm" name="General Reporting" class="#navOn('/stats.cfm')#">General Reporting</a>--->
		<a href="z.search_stats.cfm" name="Search Reporting" class="#navOn('search_stats.cfm')#">Search Reporting</a>
		<div class="nav_breaker"></div>
		<div class="nav_title ui-widget-header">Main</div>
		<a href="z.index.cfm" name="Admin Home" class="#navOn('index.cfm')#">Admin Home</a>
		<div class="clearer"></div>
	</div>
	<div id="divForumRight">
		<h1>#ATTRIBUTES.title#</h1>
</cfoutput>

<cfsetting enablecfoutputonly = false />

