<cfset qryBrewAct = APPLICATION.CFC.Users.QueryUsers(us_user = REQUEST.brewer) />

<cfquery name="qryBrewAct" datasource="#APPLICATION.DSN.MAIN#">
	SELECT us_usid, us_user, CAST(md5(us_email) AS CHAR) AS gravatar, avatar,
			 re_reid, re_name, re_brewed, re_style, re_volume, re_vunits, CalculateABV(re_eunits, re_expgrv, 0) AS re_expabv, re_privacy,
			 IFNULL(rd_rdid, 0) AS rd_rdid, IFNULL(rd_date,DATE(re_added)) AS rd_date, IFNULL(rd_type, "Added") AS rd_type, rd_note, re_dla
	  FROM recipe
			 LEFT OUTER JOIN recipedates ON rd_reid = re_reid
			 INNER JOIN users ON us_usid = re_usid AND us_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qryBrewer.us_usid#" />
			 INNER JOIN bihforum.forum_users ON username = us_user
	 WHERE IFNULL(re_brewed,NOW()) > DATE_SUB(NOW(), INTERVAL 180 DAY)
		AND IF(re_usid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#udfIfDefined('SESSION.USER.usid',0)#" />, 0, re_privacy) < 2
	ORDER BY re_brewed DESC
</cfquery>

<cfquery name="qryBlogging" datasource="#APPLICATION.DSN.MAIN#">
	SELECT us_usid, us_user, CAST(md5(us_email) AS CHAR) AS gravatar, avatar,
			 entry.id AS bl_blid, title, alias, posted, body
	  FROM bihforum.tblblogentries AS entry
			 INNER JOIN users ON us_user = entry.username AND us_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qryBrewer.us_usid#" />
			 INNER JOIN bihforum.forum_users AS fu ON fu.username = us_user
	 WHERE posted > DATE_SUB(NOW(), INTERVAL 60 DAY)
		AND released = 1
	ORDER BY posted DESC
</cfquery>

<cfquery name="qryPosting" datasource="#APPLICATION.DSN.MAIN#">
	SELECT us_usid, us_user, CAST(md5(us_email) AS CHAR) AS gravatar, avatar,
			 ff.id AS ff_ffid, ff.name AS forum, ft.id AS ft_ftid, ft.datecreated, ft.name AS title, body, ft.messages
		FROM bihforum.forum_threads AS ft
			 INNER JOIN bihforum.forum_messages AS fm ON fm.threadidfk = ft.id AND fm.posted = ft.datecreated
			 INNER JOIN bihforum.forum_forums AS ff ON ff.id = ft.forumidfk
			 INNER JOIN bihforum.forum_users AS fu ON fu.id = ft.useridfk
			 INNER JOIN users ON us_user = fu.username AND us_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qryBrewer.us_usid#" />
	 WHERE ft.datecreated > DATE_SUB(NOW(), INTERVAL 60 DAY)
	ORDER BY ft.datecreated DESC
</cfquery>

<cfquery name="qryEditing" datasource="#APPLICATION.DSN.MAIN#">
	SELECT us_usid, us_user, CAST(md5(us_email) AS CHAR) AS gravatar, avatar,
			 ue_ueid, ue_table, ue_pkid, ue_data, ue_dla
		FROM useredit
			 INNER JOIN users ON us_usid = ue_usid AND us_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qryBrewer.us_usid#" />
			 INNER JOIN bihforum.forum_users ON username = us_user
	 WHERE ue_dla > DATE_SUB(NOW(), INTERVAL 60 DAY)
	ORDER BY ue_dla DESC
</cfquery>

<cfquery name="qryFavorited" datasource="#APPLICATION.DSN.MAIN#">
SELECT us_usid, us_user, CAST(md5(us_email) AS CHAR) AS gravatar, avatar, re_reid, re_name, re_style, fr_dla
  FROM favoriterecipe
		 INNER JOIN users ON us_usid = fr_usid
		 INNER JOIN bihforum.forum_users ON username = us_user AND us_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qryBrewer.us_usid#" />
		 INNER JOIN recipe ON re_reid = fr_reid AND re_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qryBrewer.us_usid#" />
	 WHERE fr_dla > DATE_SUB(NOW(), INTERVAL 60 DAY)
	ORDER BY fr_dla DESC
</cfquery>

<cfquery name="qryFavorites" datasource="#APPLICATION.DSN.MAIN#">
SELECT users.us_usid, users.us_user, CAST(md5(users.us_email) AS CHAR) AS gravatar, fu.avatar,
		 fru.us_usid AS fru_usid, fru.us_user AS fru_user, CAST(md5(fru.us_email) AS CHAR) AS fru_gravatar, frfu.avatar AS fru_avatar,
		 re_reid, re_name, re_style,
		 fr_dla
  FROM favoriterecipe
		 INNER JOIN users ON users.us_usid = fr_usid AND fr_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qryBrewer.us_usid#" />
		 INNER JOIN bihforum.forum_users AS fu ON fu.username = users.us_user
		 INNER JOIN recipe ON re_reid = fr_reid
		 INNER JOIN users AS fru ON fru.us_usid = re_usid
		 INNER JOIN bihforum.forum_users AS frfu ON frfu.username = fru.us_user
	 WHERE fr_dla > DATE_SUB(NOW(), INTERVAL 60 DAY)
	ORDER BY fr_dla DESC
</cfquery>



<cffunction name="GristWrap" returntype="struct" output="true">
	<cfargument name="WrapTS" type="date" required="true" />
	<cfargument name="WrapID" type="string" required="true" />
	<cfargument name="Wrap" type="string" required="true" />
	<cfset LOCAL.POST = StructNew() />
	<cfset LOCAL.POST.TS = Val(DateFormat(ARGUMENTS.WrapTS,"YYMMDD") & TimeFormat(ARGUMENTS.WrapTS,"HHmmss")) />
	<cfsavecontent variable="LOCAL.POST.content">
	<li id="#ARGUMENTS.WrapID#">
		<a class="profimg" href="#APPLICATION.PATH.ROOT#/#us_user#/p.brewer.cfm"><img src="#udfAvatarSrc(avatar, gravatar)#" /></a>
		<div class="activity">
			<h4><a href="#APPLICATION.PATH.ROOT#/#us_user#/p.brewer.cfm">#us_user#</a></h4>
			#ARGUMENTS.Wrap#
		</div>
	</li>
	</cfsavecontent>
	<cfreturn LOCAL.POST />
</cffunction>

<cfset POSTS = StructNew() />
<cfset PostCnt = 0 />

<cfoutput query="qryBrewAct">
	<cfsavecontent variable="content">
		<div class="action">
			<cfif rd_type eq "Brewed">
				#rd_type# #re_volume# #re_vunits# of #re_name#, a #re_expabv#% ABV #re_style#.
			<cfelseif rd_type eq "Added" OR (rd_type eq "Note" AND LEN(rd_note) EQ 0)>
				Added a new #re_style# recipe, #re_name#.
			<cfelseif rd_type eq "Note">
				Added a new note to the recipe, #re_name#.
			<cfelseif rd_type eq "Packaged">
				#rd_type# #re_name#, a #re_expabv#% ABV #re_style#, #DateDiff("d", re_brewed, rd_date)# days after brewing.
			</cfif>
		</div>
		<div class="links">
			<cfif isUserBrewer OR re_privacy EQ 0>
				<a href="#APPLICATION.PATH.ROOT#/#us_user#/recipe/#RE_REID#/#udfDashes(RE_STYLE)#/p.brewer.cfm">View</a> &middot;
				<a href="#APPLICATION.PATH.ROOT#/p.recipe.cfm?reid=#re_reid#">Edit</a>
			<cfelse>
				<img src="#APPLICATION.PATH.IMG#/trans.gif" class="fleft bih-icon bih-icon-ballyellow" title="The details of this recipe are private.">&nbsp;
			</cfif>
			 &middot; <span class="date">#udfUserDateDisplay(rd_date)#</span>
		</div>
	</cfsavecontent>
	<cfset POSTS[PostCnt] = GristWrap(rd_date, "brewact_#us_user#_#rd_rdid#", content) />
	<cfset PostCnt = PostCnt + 1 />
</cfoutput>
<cfoutput query="qryBlogging">
	<cfset link = SESSION.BROG.makeLink(bl_blid) />
	<cfsavecontent variable="POST.content">
		<div class="action">Added a new blog post.</div>
		<div class="blog">
			<div class="title"><a href="#link#">#title#</a></div>
			<div class="post">#udfEllipsis(APPLICATION.BLOG.utils.htmlToPlainText(body), 200)#</div>
		</div>
		<div class="links"><a href="#link#">View</a> &middot; <span class="date">#udfUserDateDisplay(posted)#</span></div>
	</cfsavecontent>
	<cfset POSTS[PostCnt] = GristWrap(posted, "blog_#us_user#_#bl_blid#", POST.content) />
	<cfset PostCnt = PostCnt + 1 />
</cfoutput>
<cfoutput query="qryPosting">
	<cfset link = "#APPLICATION.PATH.ROOT#/f.messages.cfm?threadid=#ft_ftid#" />
	<cfsavecontent variable="POST.content">
		<div class="action">Started a thread in the forum <a href="#APPLICATION.PATH.ROOT#/f.threads.cfm?forumid=#ff_ffid#">#forum#</a>.</div>
		<div class="forum">
			<div class="title"><a href="#link#">#title#</a></div>
			<div class="post">#udfEllipsis(APPLICATION.BLOG.utils.htmlToPlainText(body), 200)#</div>
		</div>
		<div class="links">
			<a href="#link#">View</a> &middot;
			<span class="comments"><img class="bih-icon bih-icon-comment" src="#APPLICATION.PATH.IMG#/trans.gif" title="Show/Hide Comments" /> #messages#</span> &middot;
			<span class="date">#udfUserDateDisplay(datecreated)#</span>
		</div>
	</cfsavecontent>
	<cfset POSTS[PostCnt] = GristWrap(datecreated, "post_#us_user#_#ft_ftid#", POST.content) />
	<cfset PostCnt = PostCnt + 1 />
</cfoutput>
<cfoutput query="qryEditing">
	<cfsavecontent variable="POST.content">
		<cfset ROW = DeserializeJSON(ue_data) />
		<cfif ue_table EQ "Grains">
			<cfset data = ROW.GR_MALTSTER & " " & ROW.GR_TYPE />
			<cfset link= "#APPLICATION.PATH.FULL#/#ue_table#/#ue_pkid#/#udfSpacesPlus(ROW.GR_MALTSTER & "/" & ROW.GR_TYPE)#/p.data.cfm" />
		<cfelseif ue_table EQ "Hops">
			<cfset data = ROW.HP_HOP & " " & HP_GROWN />
			<cfset link= "#APPLICATION.PATH.FULL#/#ue_table#/#ue_pkid#/#udfSpacesPlus(ROW.HP_GROWN & "/" & ROW.HP_HOP)#/p.data.cfm" />
		<cfelseif ue_table EQ "Yeast">
			<cfset data = ROW.YE_MFG & " " & ROW.YE_MFGNO & " " & ROW.YE_YEAST />
			<cfset link= "#APPLICATION.PATH.FULL#/#ue_table#/#ue_pkid#/#udfSpacesPlus(ROW.YE_MFG & "/" & ROW.YE_MFGNO & "/" & ROW.YE_YEAST)#/p.data.cfm" />
		<cfelseif ue_table EQ "Misc">
			<cfset data = ROW.MI_TYPE />
			<cfset link= "#APPLICATION.PATH.FULL#/#ue_table#/#ue_pkid#/#udfSpacesPlus(ROW.MI_PHASE & "/" & ROW.MI_USE & "/" & ROW.MI_TYPE)#/p.data.cfm" />
		</cfif>
		<div class="action">Submited an edit request for <a href="#link#">#data#</a>.</div>
		<div class="links"><a href="#link#">View</a> &middot; <span class="date">#udfUserDateDisplay(ue_dla)#</span></div>
	</cfsavecontent>
	<cfset POSTS[PostCnt] = GristWrap(ue_dla, "edit_#us_user#_#ue_ueid#", POST.content) />
	<cfset PostCnt = PostCnt + 1 />
</cfoutput>

<cfoutput query="qryFavorites">
	<cfset href = "#APPLICATION.PATH.ROOT#/#fru_user#/recipe/#RE_REID#/#udfDashes(RE_STYLE)#" />
	<cfsavecontent variable="content">
		<div class="action">
			Favorited a <a href="#href#">recipe</a>.
		</div>
		<ul>
			<li>
				<a class="subprofimg" href="#APPLICATION.PATH.ROOT#/#fru_user#/p.brewer.cfm"><img src="#udfAvatarSrc(fru_avatar, fru_gravatar)#" /></a>
				<div class="subaction">
					<div class="title"><a href="#APPLICATION.PATH.ROOT#/#fru_user#/p.brewer.cfm">#fru_user#</a></div>
					<div class="title">
						<a href="#APPLICATION.PATH.ROOT#/bjcpstyles/#re_style#/p.data.cfm">#re_style#</a>
						&middot;
						<a href="#href#/p.brewer.cfm">#re_name#</a>
					</div>
				</div>
			</li>
		</ul>
		<div class="links">
			<a href="#href#/p.brewer.cfm">View</a> &middot; <a href="#APPLICATION.PATH.ROOT#/p.recipe.cfm?reid=#re_reid#">Edit</a>
			 &middot; <span class="date">#udfUserDateDisplay(fr_dla)#</span>
		</div>
	</cfsavecontent>
	<cfset POSTS[PostCnt] = GristWrap(fr_dla, "fav_#us_user#_#re_reid#", content) />
	<cfset PostCnt = PostCnt + 1 />
</cfoutput>

<cfif DateDiff("d", qryBrewer.us_added, NOW()) lt 60>
	<cfoutput query="qryBrewer">
		<cfsavecontent variable="POST.content">
			<div class="action">Joined BeerInHand!</div>
			<div class="links"><span class="date">#udfUserDateDisplay(us_added)#</span></div>
		</cfsavecontent>
		<cfset POSTS[PostCnt] = GristWrap(us_added, "join_#us_user#_#us_usid#", POST.content) />
		<cfset PostCnt = PostCnt + 1 />
	</cfoutput>
</cfif>

<cfset KEYS = StructSort(POSTS, "text", "DESC", "TS") />

<div id="divGrist">
<ul class="">
<cfoutput>
<cfif ArrayLen(KEYS)>
	<cfloop array="#KEYS#" index="KEY">
		#POSTS[KEY].content#
	</cfloop>
<cfelse>
	<li>The hopper is empty.</li>
</cfif>
</cfoutput>
</ul>
</div>