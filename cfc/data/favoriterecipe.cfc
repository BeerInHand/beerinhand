<cfcomponent output="false" extends="explorer">

	<cfset init() />

	<cffunction name="init" returntype="favoriterecipe" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfset THIS.table = "favoriterecipe" />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryFavoriteRecipe" access="public" returnType="query" output="false">
		<cfargument name="fr_usid" type="numeric" required="false" />
		<cfargument name="fr_reid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryFavoriteRecipe" datasource="#THIS.dsn#">
			SELECT fr_usid, fr_reid, fr_dla
			  FROM favoriterecipe
			 WHERE 0=0
			<cfif isDefined("ARGUMENTS.fr_usid")>
				AND fr_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fr_usid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.fr_reid")>
				AND fr_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fr_reid#" />
			</cfif>
			 ORDER BY fr_dla
		</cfquery>
		<cfreturn LOCAL.qryFavoriteRecipe />
	</cffunction>

	<cffunction name="InsertFavoriteRecipe" access="public" returnType="numeric" output="false">
		<cfargument name="fr_usid" type="numeric" required="true" />
		<cfargument name="fr_reid" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insFavoriteRecipe" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO favoriterecipe (
				fr_usid, fr_reid, fr_dla
			) VALUES (
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fr_usid#" />,
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fr_reid#" />,
				NOW()
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.RecordCount />
	</cffunction>

	<cffunction name="DeleteFavoriteRecipe" access="public" returnType="numeric" output="false">
		<cfargument name="fr_usid" type="numeric" required="true" />
		<cfargument name="fr_reid" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delFavoriteRecipe" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM favoriterecipe
			 WHERE fr_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fr_usid#" />
				AND fr_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fr_reid#" />
		</cfquery>
		<cfreturn LOCAL.delRtn.RecordCount />
	</cffunction>

	<cffunction name="IsFavorite" access="public" returnType="boolean" output="false">
		<cfargument name="fr_usid" type="numeric" required="true" />
		<cfargument name="fr_reid" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryFavoriteRecipe" datasource="#THIS.dsn#">
			SELECT 1
			  FROM favoriterecipe
			 WHERE fr_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fr_usid#" />
				AND fr_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fr_reid#" />
		</cfquery>
		<cfreturn LOCAL.qryFavoriteRecipe.RecordCount NEQ 0 />
	</cffunction>

	<cffunction name="GetTreeNodes" access="public" returntype="array">
		<cfargument name="re_usid" type="numeric" required="true" />
		<cfset LOCAL.tree = ArrayNew(1) />
		<cfset LOCAL.branch = GetNodeChildren(tab="favoritelog", fld="re_style", id="RE_STYLE", qry=false, brewerID = ARGUMENTS.re_usid) />
		<cfset ArrayAppend(LOCAL.tree, AddNode("RE_STYLE", "Style", "nodeRoot", false, LOCAL.branch)) />
		<cfset LOCAL.branch = GetNodeChildren(tab="favoritelog", fld="re_name", id="RE_NAME", qry=false, brewerID = ARGUMENTS.re_usid) />
		<cfset ArrayAppend(LOCAL.tree, AddNode("RE_NAME", "Name", "nodeRoot", false, LOCAL.branch)) />
		<cfreturn [ { title="Favorites", nodes=LOCAL.tree } ] />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfif not SESSION.LoggedIn><cfreturn {} /></cfif>
		<cfif THIS.IsFavorite(SESSION.USER.usid,ARGUMENTS.recipe)>
			<cfset LOCAL.Response.method="FavoriteDelete" />
			<cfinvoke method="DeleteFavoriteRecipe" returnvariable="LOCAL.rtn">
				<cfinvokeargument name="fr_usid" value="#SESSION.USER.usid#" />
				<cfinvokeargument name="fr_reid" value="#ARGUMENTS.recipe#" />
			</cfinvoke>
		<cfelse>
			<cfset LOCAL.Response.method="FavoriteInsert" />
			<cfinvoke method="InsertFavoriteRecipe" returnvariable="LOCAL.rtn">
				<cfinvokeargument name="fr_usid" value="#SESSION.USER.usid#" />
				<cfinvokeargument name="fr_reid" value="#ARGUMENTS.recipe#" />
			</cfinvoke>
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

</cfcomponent>
