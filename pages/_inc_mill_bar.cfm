<cfset qryFollowing = APPLICATION.CFC.Factory.get("FollowUser").QueryFollowing(qryBrewer.us_usid) />
<div class="brewer_sidebox ui-widget-content ui-corner-all">
	<div class="brewer_sidehead bih-grid-caption ui-widget-header ui-corner-all" title="Followed Brewers">
		In This Grist
		<img class="toggler bih-icon bih-icon-collapse" src="#APPLICATION.PATH.IMG#/trans.gif" onclick="sidebarToggle(this)" title="Show/Hide" />
	</div>
	<div id="divGristBar">
		<ul class="">
		<cfif NOT qryFollowing.RecordCount>
			<li>
				<cfif isUserBrewer>
					Follow a brewer to add their activities to your grist.
				<cfelse>
					<cfoutput>No brewers are in #qryBrewer.us_user#'s grist.</cfoutput>
				</cfif>
			</li>
		</cfif>
		<cfoutput query="qryFollowing">
			<li>
				<a class="profimg" href="#APPLICATION.PATH.ROOT#/#us_user#/p.brewer.cfm"><img src="#udfAvatarSrc(avatar, gravatar)#" /></a>
				<div class="tag">
					<h5><a href="#APPLICATION.PATH.ROOT#/#us_user#/p.brewer.cfm">#us_user#</a></h5>
					<div class="date">Added #udfUserDateDisplay(fu_dla)#</div>
				</div>
			</li>
		</cfoutput>
		</ul>
	</div>
</div>

