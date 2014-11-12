<cfoutput>
<div class="brewer_sidebox ui-widget-content ui-corner-all">
	<div class="brewer_sidehead bih-grid-caption ui-widget-header ui-corner-all">
		#qryBrewer.us_user#
		<img class="toggler bih-icon bih-icon-collapse" src="#APPLICATION.PATH.IMG#/trans.gif" onclick="sidebarToggle(this)" title="Show/Hide" />
	</div>
	<div id="brewerInfo" class="brewer_info">
		<div class="center"><img src="#udfAvatarSrc(qryBrewer.avatar, qryBrewer.gravatar)#" /></div>
		<cfif Len(strForumData.signature)><div class="row sig">#strForumData.signature#</div></cfif>
		<div>
			<cfif Len(qryBrewer.us_first)><div class="row"><span class="label">Name:</span><span>#qryBrewer.us_first# #qryBrewer.us_last#</span></div></cfif>
			<cfif Len(qryBrewer.us_postal)><div class="row"><span class="label">Where:</span><span>#qryBrewer.us_postal#</span></div></cfif>
			<div class="row"><span class="label">Joined:</span><span>#udfUserDateFormat(qryBrewer.us_added)#</span></div>
			<div class="row"><span class="label">Forums:</span><span>#udfAddSWithCnt("Post", strForumData.postcount)#</span></div>
			<div class="row"><span class="label">Recipes:</span><span>#udfAddSWithCnt("record", BrewerStats.CountRecipe)#</span></div>
			<div class="row"><span class="label">Brewed:</span><span>#udfAddSWithCnt("batch", BrewerStats.CountBrewed, "es")#</span></div>
			<div class="row"><span class="label">Brewed:</span><span>#DecimalFormat(BrewerStats.VolumeBrewed)# #BrewerStats.VolumeUnits#</span></div>
		</div>
	</div>
	<cfif SESSION.LoggedIn AND NOT isUserBrewer>
		<cfset isFollowing = APPLICATION.CFC.Factory.get("FollowUser").QueryFollowing(SESSION.USER.usid, qryBrewer.us_usid).RecordCount />
		<div class="pad5 center">
			<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny smallcaps" id="btnFollow" src="ui-icon-circle-#IIF(isFollowing, DE("minus"), DE("plus"))#" onclick="brewerFollow(this)" text="#IIF(isFollowing, DE("Remove from my Grist"), DE("Add to my Grist"))#"  />
		</div>
	</cfif>
</div>
</cfoutput>