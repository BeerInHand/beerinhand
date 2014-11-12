<cfcomponent output="false" extends="explorer">

	<cfset init() />

	<cffunction name="init" returntype="grains" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfset THIS.table = "grains" />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryGrains" access="public" returnType="query" output="false">
		<cfargument name="gr_grid" type="numeric" required="false" />
		<cfargument name="gr_type" type="string" required="false" />
		<cfargument name="gr_cat" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryGrains" datasource="#THIS.dsn#">
			SELECT gr_grid, gr_type, gr_cat, gr_lvb, gr_sgc, gr_mash, gr_maltster, gr_country, gr_info, gr_url, gr_lintner, gr_cgdb, gr_mc, gr_fgdb, gr_fcdif, gr_protein, gr_dla
			  FROM grains
			 WHERE 0=0
			<cfif isDefined("ARGUMENTS.gr_grid")>
				AND gr_grid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.gr_grid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.gr_type")>
				AND gr_type = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_type#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.gr_cat")>
				AND gr_cat = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_cat#" />
			</cfif>
			 ORDER BY gr_type, gr_maltster
		</cfquery>
		<cfreturn LOCAL.qryGrains />
	</cffunction>

	<cffunction name="QuerySRMGrouping" access="public" returnType="query" output="false">
		<cfquery name="LOCAL.qrySRMGroup" datasource="#THIS.dsn#">
			SELECT gr_lvbrange, cntRows
			  FROM (
						SELECT CASE WHEN gr_lvb<6 THEN "0-5" WHEN gr_lvb<11 THEN "6-10" WHEN gr_lvb<21 THEN "11-20" WHEN gr_lvb<51 THEN "21-50" WHEN gr_lvb<101 THEN "51-100" WHEN gr_lvb<201 THEN "101-200" WHEN gr_lvb<401 THEN "201-400" ELSE "401+" END AS gr_lvbrange,
								 CASE WHEN gr_lvb<6 THEN 1 WHEN gr_lvb<11 THEN 2 WHEN gr_lvb<21 THEN 3 WHEN gr_lvb<51 THEN 4 WHEN gr_lvb<101 THEN 5 WHEN gr_lvb<201 THEN 6 WHEN gr_lvb<401 THEN 7 ELSE 8 END AS ord,
								 COUNT(*) AS cntRows
						  FROM grains
						 GROUP BY CASE WHEN gr_lvb<6 THEN "0-5" WHEN gr_lvb<11 THEN "6-10" WHEN gr_lvb<21 THEN "11-20" WHEN gr_lvb<51 THEN "21-50" WHEN gr_lvb<101 THEN "51-100" WHEN gr_lvb<201 THEN "101-200" WHEN gr_lvb<401 THEN "201-400" ELSE "401+" END
					 ) AS srm_range
			 ORDER BY ord
		</cfquery>
		<cfreturn LOCAL.qrySRMGroup />
	</cffunction>

	<cffunction name="InsertGrains" access="public" returnType="numeric" output="false">
		<cfargument name="gr_type" type="string" required="true" />
		<cfargument name="gr_lvb" type="numeric" required="false" />
		<cfargument name="gr_sgc" type="numeric" required="false" />
		<cfargument name="gr_lintner" type="numeric" required="false" />
		<cfargument name="gr_mash" type="numeric" required="false" />
		<cfargument name="gr_cgdb" type="numeric" default="0" />
		<cfargument name="gr_mc" type="numeric" default="0" />
		<cfargument name="gr_fgdb" type="numeric" default="0" />
		<cfargument name="gr_fcdif" type="numeric" default="0" />
		<cfargument name="gr_protein" type="numeric" default="0" />
		<cfargument name="gr_maltster" type="string" required="false" />
		<cfargument name="gr_country" type="string" required="false" />
		<cfargument name="gr_cat" type="string" required="false" />
		<cfargument name="gr_info" type="string" required="false" />
		<cfargument name="gr_url" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insGrains" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO grains (
				<cfif isDefined("ARGUMENTS.gr_lvb")>gr_lvb,</cfif>
				<cfif isDefined("ARGUMENTS.gr_sgc")>gr_sgc,</cfif>
				<cfif isDefined("ARGUMENTS.gr_lintner")>gr_lintner,</cfif>
				<cfif isDefined("ARGUMENTS.gr_mash")>gr_mash,</cfif>
				<cfif isDefined("ARGUMENTS.gr_cgdb")>gr_cgdb,</cfif>
				<cfif isDefined("ARGUMENTS.gr_mc")>gr_mc,</cfif>
				<cfif isDefined("ARGUMENTS.gr_fgdb")>gr_fgdb,</cfif>
				<cfif isDefined("ARGUMENTS.gr_fcdif")>gr_fcdif,</cfif>
				<cfif isDefined("ARGUMENTS.gr_protein")>gr_protein,</cfif>
				<cfif isDefined("ARGUMENTS.gr_maltster")>gr_maltster,</cfif>
				<cfif isDefined("ARGUMENTS.gr_country")>gr_country,</cfif>
				<cfif isDefined("ARGUMENTS.gr_cat")>gr_cat,</cfif>
				<cfif isDefined("ARGUMENTS.gr_info")>gr_info,</cfif>
				<cfif isDefined("ARGUMENTS.gr_url")>gr_url,</cfif>
				gr_type, gr_dla
			) VALUES (
				<cfif isDefined("ARGUMENTS.gr_lvb")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.gr_lvb#" />,</cfif>
				<cfif isDefined("ARGUMENTS.gr_sgc")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.gr_sgc#" />,</cfif>
				<cfif isDefined("ARGUMENTS.gr_lintner")><cfqueryparam cfsqltype="CF_SQL_DOUBLE" value="#ARGUMENTS.gr_lintner#" />,</cfif>
				<cfif isDefined("ARGUMENTS.gr_mash")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.gr_mash#" />,</cfif>
				<cfif isDefined("ARGUMENTS.gr_cgdb")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.gr_cgdb#" />,</cfif>
				<cfif isDefined("ARGUMENTS.gr_mc")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.gr_mc#" />,</cfif>
				<cfif isDefined("ARGUMENTS.gr_fgdb")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.gr_fgdb#" />,</cfif>
				<cfif isDefined("ARGUMENTS.gr_fcdif")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.gr_fcdif#" />,</cfif>
				<cfif isDefined("ARGUMENTS.gr_protein")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.gr_protein#" />,</cfif>
				<cfif isDefined("ARGUMENTS.gr_maltster")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_maltster#" maxlength="25" />,</cfif>
				<cfif isDefined("ARGUMENTS.gr_country")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_country#" maxlength="15" />,</cfif>
				<cfif isDefined("ARGUMENTS.gr_cat")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_cat#" maxlength="15" />,</cfif>
				<cfif isDefined("ARGUMENTS.gr_info")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_info#" maxlength="1000" />,</cfif>
				<cfif isDefined("ARGUMENTS.gr_url")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_url#" maxlength="150" />,</cfif>
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_type#" maxlength="25" />,
				NOW()
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="UpdateGrains" access="public" returnType="numeric" output="false">
		<cfargument name="gr_grid" type="numeric" required="true" />
		<cfargument name="gr_type" type="string" required="false" />
		<cfargument name="gr_lvb" type="numeric" required="false" />
		<cfargument name="gr_sgc" type="numeric" required="false" />
		<cfargument name="gr_lintner" type="numeric" required="false" />
		<cfargument name="gr_mash" type="numeric" required="false" />
		<cfargument name="gr_cgdb" type="numeric" required="false" />
		<cfargument name="gr_mc" type="numeric" required="false" />
		<cfargument name="gr_fgdb" type="numeric" required="false" />
		<cfargument name="gr_fcdif" type="numeric" required="false" />
		<cfargument name="gr_protein" type="numeric" required="false" />
		<cfargument name="gr_maltster" type="string" required="false" />
		<cfargument name="gr_country" type="string" required="false" />
		<cfargument name="gr_cat" type="string" required="false" />
		<cfargument name="gr_info" type="string" required="false" />
		<cfargument name="gr_url" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updGrains" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE grains
				SET <cfif isDefined("ARGUMENTS.gr_type")>gr_type = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_type#" maxlength="25" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_lvb")>gr_lvb = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.gr_lvb#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_sgc")>gr_sgc = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.gr_sgc#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_lintner")>gr_lintner = <cfqueryparam cfsqltype="CF_SQL_DOUBLE" value="#ARGUMENTS.gr_lintner#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_mash")>gr_mash = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.gr_mash#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_cgdb")>gr_cgdb = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.gr_cgdb#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_mc")>gr_mc = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.gr_mc#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_fgdb")>gr_fgdb = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.gr_fgdb#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_fcdif")>gr_fcdif = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.gr_fcdif#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_protein")>gr_protein = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.gr_protein#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_maltster")>gr_maltster = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_maltster#" maxlength="25" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_country")>gr_country = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_country#" maxlength="15" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_cat")>gr_cat = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_cat#" maxlength="15" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_info")>gr_info = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_info#" maxlength="1000" />,</cfif>
					 <cfif isDefined("ARGUMENTS.gr_url")>gr_url = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.gr_url#" maxlength="150" />,</cfif>
					 gr_dla = NOW()
			 WHERE gr_grid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.gr_grid#" />
		</cfquery>
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="DeleteGrains" access="public" returnType="numeric" output="false">
		<cfargument name="gr_grid" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delGrains" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM grains
			 WHERE gr_grid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.gr_grid#" />
		</cfquery>
		<cfreturn LOCAL.delRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.gr_grid = JavaCast("int", ARGUMENTS.gr_grid) />
		<cfif IsDefined("ARGUMENTS.kill")>
			<cfset LOCAL.Response.method="Delete" />
		<cfelseif LOCAL.Response.gr_grid neq 0>
			<cfset LOCAL.Response.method="Update" />
		<cfelse>
			<cfset LOCAL.Response.method="Insert" />
		</cfif>
		<cfinvoke method="#LOCAL.Response.method#Grains" returnvariable="LOCAL.rtn">
			<cfloop collection="#ARGUMENTS#" item="LOCAL.key">
				<cfif ARGUMENTS[LOCAL.key] neq "null">
					<cfinvokeargument name="#LOCAL.key#" value="#ARGUMENTS[LOCAL.key]#" />
				</cfif>
			</cfloop>
		</cfinvoke>
		<cfif LOCAL.Response.method eq "Insert">
			<cfset LOCAL.Response.gr_grid = JavaCast("int", LOCAL.rtn) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="GetExplorerNodes" access="public" returntype="struct">
		<cfargument name="root" type="string" required="Yes" />
		<cfargument name="incStruct" type="boolean" default="false" />
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.method = "Get" />
		<cfset LOCAL.node = ListFirst(root, "!") />
		<cfset LOCAL.value = ListLast(root, "!") />
		<cfif LOCAL.node eq "source">
			<cfset LOCAL.tree = ArrayNew(1) />
			<cfset ArrayAppend(LOCAL.tree, AddNode("trGrains", " Grains", "nodeRoot", true, [])) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("GR_MALTSTER", "Maltster", "nodeFolder", true, GetNodeChildren("grains", "gr_maltster", "GR_MALTSTER"))) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("GR_COUNTRY", "Country", "nodeFolder", false, true)) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("GR_CAT", "Category", "nodeFolder", false, true)) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("GR_LVB", "SRM", "nodeFolder", false, true)) />
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(LOCAL.tree) />
			<cfif ARGUMENTS.incStruct><cfset LOCAL.Response.tree = LOCAL.tree /></cfif>
		<cfelseif LOCAL.node eq "GR_COUNTRY">
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(GetNodeChildren("grains", "gr_country", LOCAL.node)) />
		<cfelseif LOCAL.node eq "GR_CAT">
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(GetNodeChildren("grains", "gr_cat", LOCAL.node)) />
		<cfelseif LOCAL.node eq "GR_LVB">
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(GetNodeChildren("grains", "gr_lvbrange", LOCAL.node, THIS.QuerySRMGrouping(), {"hideCheckbox"=true})) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="GetTreeNodes" access="public" returntype="array">
		<cfset LOCAL.tree = ArrayNew(1) />
		<cfset LOCAL.branch = ArrayNew(1) />

		<cfset LOCAL.qry = THIS.QueryDataGroup("GR_MALTSTER, GR_COUNTRY, GR_CAT") />
		<cfoutput query="LOCAL.qry" group="GR_MALTSTER">
			<cfset LOCAL.leaf = ArrayNew(1) />
			<cfset LOCAL.sumRows = 0 />
			<cfoutput>
				<cfset LOCAL.sumRows = LOCAL.sumRows + cntRows />
				<cfset ArrayAppend(LOCAL.leaf, THIS.AddNode("GR_CAT!#GR_CAT#", "#GR_CAT#<i>#cntRows#</i>", "nodeEnd", false, [])) />
			</cfoutput>
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("GR_MALTSTER!#GR_MALTSTER#", "#GR_MALTSTER#<i>#LOCAL.sumRows#</i>", "flagTR flag#Replace(GR_COUNTRY,' ','','ALL')#", false, LOCAL.leaf)) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="Maltster", nodes=LOCAL.branch }) />

		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QueryDataGroup("GR_CAT, GR_MALTSTER, GR_COUNTRY") />
		<cfoutput query="LOCAL.qry" group="GR_CAT">
			<cfset LOCAL.leaf = ArrayNew(1) />
			<cfset LOCAL.sumRows = 0 />
			<cfoutput>
				<cfset LOCAL.sumRows = LOCAL.sumRows + cntRows />
				<cfset ArrayAppend(LOCAL.leaf, THIS.AddNode("GR_MALTSTER!#GR_MALTSTER#", "#GR_MALTSTER#<i>#cntRows#</i>", "flagTR flag#Replace(GR_COUNTRY,' ','','ALL')#", false, [])) />
			</cfoutput>
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("GR_CAT!#GR_CAT#", "#GR_CAT#<i>#LOCAL.sumRows#</i>", "nodeEnd", false, LOCAL.leaf)) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="Category", nodes=LOCAL.branch }) />

		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QuerySRMGrouping() />
		<cfoutput query="LOCAL.qry">
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("GR_LVB!#gr_lvbrange#", "#gr_lvbrange#<i>#cntRows#</i>", "nodeEnd", false, [])) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="SRM Range", nodes=LOCAL.branch }) />

		<cfreturn LOCAL.tree />
	</cffunction>

</cfcomponent>