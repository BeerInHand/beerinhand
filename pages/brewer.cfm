<cfset RowCnt = 0 />

<cfif StructKeyExists(REQUEST, "URLTokens")>
	<cfif ArrayLen(REQUEST.URLTokens) EQ 0>
		<cfif SESSION.LoggedIn>
			<cfset REQUEST.brewer = SESSION.USER.user />
			<cfset REQUEST.URLTokens = ArrayNew(1) />
		</cfif>
	<cfelse>
		<cfif REQUEST.URLTokens[1] NEQ "recipe">
			<cfset REQUEST.Brewer = REQUEST.URLTokens[1] />
			<cfset ArrayDeleteAt(REQUEST.URLTokens, 1) />
		</cfif>
		<cfif ArrayLen(REQUEST.URLTokens) GT 1>
			<cfif REQUEST.URLTokens[1] EQ "recipe">
				<cfset ArrayDeleteAt(REQUEST.URLTokens, 1) />
				<cfset REQUEST.recipe = REQUEST.URLTokens[1] />
				<cfset ArrayDeleteAt(REQUEST.URLTokens, 1) />
				<cfif isNumeric(REQUEST.recipe)>
					<cfset qryRecipe = APPLICATION.CFC.Recipe.QueryRecipe(re_reid = REQUEST.recipe) />
					<cfif qryRecipe.RecordCount>
						<cfif SESSION.LoggedIn AND SESSION.USER.usid EQ qryRecipe.re_usid>
							<cfset REQUEST.brewer = SESSION.USER.user />
						<cfelse>
							<cfif qryRecipe.re_privacy>
								<cfabort showError = "401:You do not have the required permissions to view this recipe." />
							</cfif>
							<cfset REQUEST.brewer = APPLICATION.CFC.Users.QueryUsers(us_usid = qryRecipe.re_usid).us_user />
						</cfif>
						<cfset REQUEST.URLTokens = ["recipe"] />
					<cfelse>
						<cfset StructDelete(REQUEST, "recipe") />
					</cfif>
				<cfelse>
					<cfset StructDelete(REQUEST, "recipe") />
				</cfif>
			</cfif>
		</cfif>
	</cfif>


<!--- 	<cfif ArrayLen(REQUEST.URLTokens) GT 1>
		<cfif ListFind("brewer,recipe", REQUEST.URLTokens[1])>
			<cfset REQUEST[REQUEST.URLTokens[1]] = REQUEST.URLTokens[2] />
			<cfset ArrayDeleteAt(REQUEST.URLTokens, 1) />
			<cfset ArrayDeleteAt(REQUEST.URLTokens, 1) />
		</cfif>
	</cfif>
	<cfif StructKeyExists(REQUEST, "recipe")>
		<cfif isNumeric(REQUEST.recipe)>
			<cfset qryRecipe = APPLICATION.CFC.Recipe.QueryRecipe(re_reid = REQUEST.recipe) />
			<cfif qryRecipe.RecordCount>
				<cfif SESSION.LoggedIn AND SESSION.USER.usid EQ qryRecipe.re_usid>
					<cfset REQUEST.brewer = SESSION.USER.user />
				<cfelse>
					<cfif qryRecipe.re_privacy>
						<cfabort showError = "401:You do not have the required permissions to view this recipe." />
					</cfif>
					<cfset REQUEST.brewer = APPLICATION.CFC.Users.QueryUsers(us_usid = qryRecipe.re_usid).us_user />
				</cfif>
				<cfset REQUEST.URLTokens = ["recipe"] />
			<cfelse>
				<cfset StructDelete(REQUEST, "recipe") />
			</cfif>
		<cfelse>
			<cfset StructDelete(REQUEST, "recipe") />
		</cfif>
	</cfif>
	<cfif SESSION.LoggedIn AND NOT StructKeyExists(REQUEST, "brewer")>
		<cfset REQUEST.brewer = SESSION.USER.user />
		<cfset REQUEST.URLTokens = ArrayNew(1) />
	</cfif> --->
</cfif>
<cfif StructKeyExists(REQUEST, "brewer")>
	<cfset qryBrewer = APPLICATION.CFC.Users.QueryUsers(us_user = REQUEST.brewer, extend=1) />
	<cfset RowCnt = qryBrewer.RecordCount />
<cfelse>
	<cfset REQUEST.brewer = "Unknown" />
</cfif>
<cfif NOT RowCnt>
	<cfabort showError = "404:Brewer '#REQUEST.brewer#' was not found." />
</cfif>

<cfset LoadPage = "_inc_mill.cfm" />
<cfset LoadBar = "_inc_mill_bar.cfm" />
<cfset PageText = "Grist Mill" />
<cfif ArrayLen(REQUEST.URLTokens)>
	<cfif REQUEST.URLTokens[1] eq "recipes">
		<cfset LoadPage = "_inc_recipes.cfm" />
		<cfset LoadBar = "_inc_recipes_bar.cfm" />
		<cfset PageText = "Recipes" />
	<cfelseif REQUEST.URLTokens[1] eq "grist">
		<cfset LoadPage = "_inc_grist.cfm" />
		<cfset LoadBar = "_inc_grist_bar.cfm" />
		<cfset PageText = "Grist" />
	<cfelseif REQUEST.URLTokens[1] eq "stats">
		<cfset LoadPage = "_inc_stats.cfm" />
		<cfset LoadBar = "" />
		<cfset PageText = "Stats" />
	<cfelseif REQUEST.URLTokens[1] eq "recipe">
		<cfset LoadPage = "_inc_recipe.cfm" />
		<cfset LoadBar = "" />
		<cfset PageText = "Recipe" />
	<cfelseif REQUEST.URLTokens[1] eq "favorites">
		<cfset LoadPage = "_inc_favorites.cfm" />
		<cfset LoadBar = "_inc_recipes_bar.cfm" />
		<cfset PageText = "Favorites" />
	<cfelseif REQUEST.URLTokens[1] eq "blog">
		<cfset LoadPage = "_inc_blog.cfm" />
		<cfset LoadBar = "_inc_blog_bar.cfm" />
		<cfset PageText = "Blog" />
	</cfif>
	<cfset ArrayDeleteAt(REQUEST.URLTokens, 1) />
</cfif>

<cfset isUserBrewer = SESSION.LoggedIn AND SESSION.USER.usid EQ qryBrewer.us_usid />
<cfset BrewerStats = APPLICATION.CFC.Recipe.QueryUserStats(re_usid=qryBrewer.us_usid) />
<cfset strForumData = APPLICATION.FORUM.User.getUser(qryBrewer.us_user) />

<cfoutput>
<script>
	var brewerID = #qryBrewer.us_usid#;
	var isUserBrewer = <cfif isUserBrewer>true<cfelse>false</cfif>;
	<cfif StructKeyExists(REQUEST, "recipe")>var recipeID = #qryRecipe.re_reid#;</cfif>
</script>

<div id="divSubPage">
	<div id="divSubPageNav">
		<ul>
			<li><div class="page_head bih-grid-caption padlr10 ui-widget-header ui-corner-all">#qryBrewer.us_user#'s #PageText#</div></li>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/mill/p.brewer.cfm">GRIST MILL</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/grist/p.brewer.cfm">GRIST</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/blog/p.brewer.cfm">BLOG</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/recipes/p.brewer.cfm">RECIPES</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/favorites/p.brewer.cfm">FAVORITES</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/#qryBrewer.us_user#/stats/p.brewer.cfm">STATS</a></li>
		</ul>
	</div>
	<div class="subpage_content">
		<cfinclude template="#LoadPage#" />
	</div>
	<div class="subpage_sidebar dynatree-invert">
		<cfinclude template="_inc_info.cfm" />
		<cfif Len(LoadBar)>
			<cfinclude template="#LoadBar#" />
		</cfif>
	</div>
</div>
</cfoutput>