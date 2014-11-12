<cfcomponent output="false">
	<cffunction name="IncludeCommonJS" returntype="void" output="true" access="public">
		<cfargument name="simple_js" type="boolean" required="false" default="true" />
		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
		<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/jquery.tablescroller.js"></script>
		<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/jquery.tablesorter.js"></script>
		<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/jquery.metadata.js"></script>
		<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/jquery.scrollto-min.js"></script>
		<cfif ARGUMENTS.simple_js>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/helper.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/bih.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/bjcpstyles.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/brewer.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/brewlog.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/data.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/calc.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/explorer.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/grains.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/hops.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/misc.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/recipe.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/settings.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/yeast.js"></script>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/users.js"></script>
		<cfelse>
			<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/allbih.js"></script>
		</cfif>
		<script language="javascript" type="text/javascript">
			var bihPath = {
				root: "#APPLICATION.PATH.ROOT#",
				img: "#APPLICATION.PATH.IMG#",
				cfc: "#APPLICATION.PATH.CFC#",
				avatar: "#APPLICATION.PATH.AVATARS#",
				blog: "#APPLICATION.PATH.BLOGIMG#"
			};
			var cfDateMask = "#SESSION.SETTING.DateMask#";
			var imgAjaxRunSm = "<img src='"+bihPath.img+"/ani_ajaxrun.gif' />";
			var bihDefaults = <cfif StructKeyExists(SESSION, "SETTING")>#SerializeJSON(SESSION.SETTING)#<cfelse>#SerializeJSON(APPLICATION.SETTING)#</cfif>;
		<cfif SESSION.LoggedIn>
			var bihUser = #SerializeJSON(SESSION.USER)#;
			var brewerID = #SESSION.USER.usid#;
		</cfif>
			var bihLoggedIn = <cfif SESSION.LoggedIn>true<cfelse>false</cfif>;
			var bihStorage = getStorage();
			$(document).ready(function() {liveHover();});
		</script>
	</cffunction>

	<cffunction name="IncludeRecipeJS" returntype="void" output="true" access="public">
		<script>
			REID = <cfif StructKeyExists(URL, "reid") AND isNumeric(URL.reid)>#URL.reid#<cfelse>null</cfif>;
			#THIS.IncludeFilterDataJS()#
			$(document).ready(recipeInit);
		</script>
	</cffunction>

	<cffunction name="IncludeGrainsJS" returntype="void" output="true" access="public">
		<cfset LOCAL.DLA = VARIABLES.DataFiles.GetDLA("Grains") />
		<script>
			#THIS.IncludeFilterDataJS()#
			$.ajax({ url: "#APPLICATION.PATH.ROOT#/js/grains_data.js?v=#LOCAL.DLA#", dataType: "script", cache: true, async: false });
			$(document).ready(grainsInit);
		</script>
	</cffunction>

	<cffunction name="IncludeHopsJS" returntype="void" output="true" access="public">
		<cfset LOCAL.DLA = VARIABLES.DataFiles.GetDLA("Hops") />
		<script>
			#THIS.IncludeFilterDataJS()#
			$.ajax({ url: "#APPLICATION.PATH.ROOT#/js/hops_data.js?v=#LOCAL.DLA#", dataType: "script", cache: true, async: false });
			$(document).ready(hopsInit);
		</script>
	</cffunction>

	<cffunction name="IncludeMiscJS" returntype="void" output="true" access="public">
		<cfset LOCAL.DLA = VARIABLES.DataFiles.GetDLA("Misc") />
		<script>
			#THIS.IncludeFilterDataJS()#
			$.ajax({ url: "#APPLICATION.PATH.ROOT#/js/misc_data.js?v=#LOCAL.DLA#", dataType: "script", cache: true, async: false });
			$(document).ready(miscInit);
		</script>
	</cffunction>

	<cffunction name="IncludeUsersJS" returntype="void" output="true" access="public">
		<cfset LOCAL.qryUsers = APPLICATION.CFC.Users.QueryUsersSafe() />
		<script>
			qryUsers = #SerializeJSON(LOCAL.qryUsers)#;
			$(document).ready(userexpInit);
		</script>
	</cffunction>

	<cffunction name="IncludeYeastJS" returntype="void" output="true" access="public">
		<cfset LOCAL.DLA = VARIABLES.DataFiles.GetDLA("Yeast") />
		<script>
			#THIS.IncludeFilterDataJS()#
			$.ajax({ url: "#APPLICATION.PATH.ROOT#/js/yeast_data.js?v=#LOCAL.DLA#", dataType: "script", cache: true, async: false });
			$(document).ready(yeastInit);
		</script>
	</cffunction>

	<cffunction name="IncludeBJCPStylesJS" returntype="void" output="true" access="public">
		<cfset LOCAL.DLA = VARIABLES.DataFiles.GetDLA("BJCPStyles") />
		<script>
			$.ajax({ url: "#APPLICATION.PATH.ROOT#/js/bjcpstyles_data.js?v=#LOCAL.DLA#", dataType: "script", cache: true, async: false });
			$(document).ready(stylesInit)
		</script>
	</cffunction>

	<cffunction name="IncludeExplorerJS" returntype="void" output="true" access="public">
		<cfargument name="which" type="string" default="Grains" />
		<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/jquery.dynatree.js"></script>
		<script>
			#THIS.IncludeFilterDataJS()#
			$(document).ready(function() { treeInit("#ARGUMENTS.which#") });
			isExplorer = true;
		</script>
	</cffunction>

	<cffunction name="IncludeBrewLogJS" returntype="void" output="true" access="public">
		<script>
		<cfif SESSION.LoggedIn>
			<cfset LOCAL.qryBrewLog = APPLICATION.CFC.Recipe.QueryBrewLog(re_usid=SESSION.USER.usid) />
			qryBrewLog = #SerializeJSON(LOCAL.qryBrewLog)#;
		</cfif>
			$(document).ready(brewlogInit);
		</script>
	</cffunction>

	<cffunction name="IncludeCalcJS" returntype="void" output="true" access="public">
		<script>$(document).ready(calcInit)</script>
	</cffunction>

	<cffunction name="IncludeFilterDataJS" returntype="void" output="true" access="public">
		<cfif SESSION.LoggedIn>
			<cfset LOCAL.cfcUserPrefs = APPLICATION.CFC.Factory.get("UserPrefs") />
			var filterData = {
				Grains: #cfcUserPrefs.GetUserPrefs("filterGrains", "{}")#,
				Hops: #cfcUserPrefs.GetUserPrefs("filterHops", "{}")#,
				Misc: #cfcUserPrefs.GetUserPrefs("filterMisc", "{}")#,
				Yeast: #cfcUserPrefs.GetUserPrefs("filterYeast", "{}")#,
				Users: {},
				FavoriteRecipe: {}
			}
		<cfelse>
			var filterData = {Grains: [], Hops: [], Misc: [], Yeast: [], Users: [], FavoriteRecipe: [] }
		</cfif>
	</cffunction>

	<cffunction name="SetCFC" access="public" output="No" returntype="void">
		<cfargument name="table" type="string" required="true" />
		<cfargument name="cfc" type="any" required="true" />
		<cfset VARIABLES[ARGUMENTS.table] = ARGUMENTS.cfc />
	</cffunction>


</cfcomponent>