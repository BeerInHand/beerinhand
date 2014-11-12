<cfinclude template="#APPLICATION.PATH.ROOT#/blog/OnRequest.cfm">
<cfset LoadPage = "index.cfm" />
<cfif ArrayLen(REQUEST.URLTokens) AND REQUEST.URLTokens[1] eq "unsubscribe">
	<cfset LoadPage = "unsubscribe.cfm" />
<cfelseif isUserBrewer>
	<cfif ArrayLen(REQUEST.URLTokens) AND ListFind("category,categories,comment,comments,entry,entries,mailsubscribers,moderate,stats,subscribers",REQUEST.URLTokens[1])>
		<cfset LoadPage = "admin/#REQUEST.URLTokens[1]#.cfm" />
	</cfif>
	<cfoutput>
	<div id="divBlogNav">
		<ul>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/blog/entry/p.brewer.cfm">ADD ENTRY</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/blog/entries/p.brewer.cfm">ENTRIES</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/blog/categories/p.brewer.cfm">CATEGORIES</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/blog/comments/p.brewer.cfm">COMMENTS</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/blog/moderate/p.brewer.cfm">MODERATE</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/blog/stats/p.brewer.cfm">STATS</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/blog/subscribers/p.brewer.cfm">SUBSCRIBERS</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/blog/mailsubscribers/p.brewer.cfm">MAIL</a></li>
		</ul>
	</div>
	</cfoutput>
</cfif>

<cfinclude template="#APPLICATION.PATH.ROOT#/blog/#LoadPage#">