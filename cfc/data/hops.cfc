<cfcomponent output="false" extends="explorer">

	<cfset init() />

	<cffunction name="init" returntype="hops" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfset THIS.table = "hops" />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryHops" access="public" returnType="query" output="false">
		<cfargument name="hp_hpid" type="numeric" required="false" />
		<cfargument name="hp_hop" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryHops" datasource="#THIS.dsn#">
			SELECT hp_hpid, hp_hop, hp_aalow, hp_aahigh, hp_hsi, hp_grown, hp_profile, hp_use, hp_example, hp_sub, hp_info, hp_url, hp_dry, hp_aroma, hp_bitter, hp_dla
			  FROM hops
			 WHERE 0=0
			<cfif isDefined("ARGUMENTS.hp_hpid")>
				AND hp_hpid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.hp_hpid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.hp_hop")>
				AND hp_hop = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_hop#" />
			</cfif>
			 ORDER BY hp_hop, hp_grown
		</cfquery>
		<cfreturn LOCAL.qryHops />
	</cffunction>

	<cffunction name="QueryAAUGrouping" access="public" returnType="query" output="false">
		<cfquery name="LOCAL.qryAAUGroup" datasource="#THIS.dsn#">
			SELECT hp_aarange, cntRows
			  FROM (
						SELECT CASE WHEN (hp_aalow+hp_aahigh)/2<6 THEN "1-5" WHEN (hp_aalow+hp_aahigh)/2<11 THEN "6-10" WHEN (hp_aalow+hp_aahigh)/2<16 THEN "11-15" WHEN (hp_aalow+hp_aahigh)/2<21 THEN "16-20" ELSE "21+" END AS hp_aarange,
								 CASE WHEN (hp_aalow+hp_aahigh)/2<6 THEN 1 WHEN (hp_aalow+hp_aahigh)/2<11 THEN 2 WHEN (hp_aalow+hp_aahigh)/2<16 THEN 3 WHEN (hp_aalow+hp_aahigh)/2<21 THEN 4 ELSE 5 END AS hp_aaorder,
								 COUNT(*) AS cntRows
						  FROM hops
						 GROUP BY CASE WHEN (hp_aalow+hp_aahigh)/2<6 THEN "1-5" WHEN (hp_aalow+hp_aahigh)/2<11 THEN "6-10" WHEN (hp_aalow+hp_aahigh)/2<16 THEN "11-15" WHEN (hp_aalow+hp_aahigh)/2<21 THEN "16-20" ELSE "21+" END
					 ) AS aarange
			 ORDER BY hp_aaorder
		</cfquery>
		<cfreturn LOCAL.qryAAUGroup />
	</cffunction>

	<cffunction name="QueryUseGrouping" access="public" returnType="query" output="false">
		<cfquery name="LOCAL.qryUseGroup" datasource="#THIS.dsn#">
			SELECT 'Bittering' AS hp_usage, sum(abs(hp_bitter)) AS cntRows FROM hops
			UNION
			SELECT 'Aroma', sum(abs(hp_aroma)) FROM hops
			UNION
			SELECT 'Dry Hop', sum(abs(hp_dry)) FROM hops
		</cfquery>
		<cfreturn LOCAL.qryUseGroup />
	</cffunction>

	<cffunction name="InsertHops" access="public" returnType="numeric" output="false">
		<cfargument name="hp_hop" type="string" required="true" />
		<cfargument name="hp_aalow" type="numeric" required="false" />
		<cfargument name="hp_aahigh" type="numeric" required="false" />
		<cfargument name="hp_hsi" type="numeric" required="false" />
		<cfargument name="hp_grown" type="string" required="false" />
		<cfargument name="hp_profile" type="string" required="false" />
		<cfargument name="hp_use" type="string" required="false" />
		<cfargument name="hp_example" type="string" required="false" />
		<cfargument name="hp_sub" type="string" required="false" />
		<cfargument name="hp_info" type="string" required="false" />
		<cfargument name="hp_url" type="string" required="false" />
		<cfargument name="hp_dry" type="numeric" required="false" />
		<cfargument name="hp_aroma" type="numeric" required="false" />
		<cfargument name="hp_bitter" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insHops" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO hops (
				<cfif isDefined("ARGUMENTS.hp_aalow")>hp_aalow,</cfif>
				<cfif isDefined("ARGUMENTS.hp_aahigh")>hp_aahigh,</cfif>
				<cfif isDefined("ARGUMENTS.hp_hsi")>hp_hsi,</cfif>
				<cfif isDefined("ARGUMENTS.hp_grown")>hp_grown,</cfif>
				<cfif isDefined("ARGUMENTS.hp_profile")>hp_profile,</cfif>
				<cfif isDefined("ARGUMENTS.hp_use")>hp_use,</cfif>
				<cfif isDefined("ARGUMENTS.hp_example")>hp_example,</cfif>
				<cfif isDefined("ARGUMENTS.hp_sub")>hp_sub,</cfif>
				<cfif isDefined("ARGUMENTS.hp_info")>hp_info,</cfif>
				<cfif isDefined("ARGUMENTS.hp_url")>hp_url,</cfif>
				<cfif isDefined("ARGUMENTS.hp_dry")>hp_dry,</cfif>
				<cfif isDefined("ARGUMENTS.hp_aroma")>hp_aroma,</cfif>
				<cfif isDefined("ARGUMENTS.hp_bitter")>hp_bitter,</cfif>
				hp_hop, hp_dla
			) VALUES (
				<cfif isDefined("ARGUMENTS.hp_aalow")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.hp_aalow#" />,</cfif>
				<cfif isDefined("ARGUMENTS.hp_aahigh")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.hp_aahigh#" />,</cfif>
				<cfif isDefined("ARGUMENTS.hp_hsi")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.hp_hsi#" />,</cfif>
				<cfif isDefined("ARGUMENTS.hp_grown")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_grown#" maxlength="15" />,</cfif>
				<cfif isDefined("ARGUMENTS.hp_profile")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_profile#" maxlength="100" />,</cfif>
				<cfif isDefined("ARGUMENTS.hp_use")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_use#" maxlength="100" />,</cfif>
				<cfif isDefined("ARGUMENTS.hp_example")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_example#" maxlength="100" />,</cfif>
				<cfif isDefined("ARGUMENTS.hp_sub")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_sub#" maxlength="100" />,</cfif>
				<cfif isDefined("ARGUMENTS.hp_info")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_info#" maxlength="1000" />,</cfif>
				<cfif isDefined("ARGUMENTS.hp_url")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_url#" maxlength="150" />,</cfif>
				<cfif isDefined("ARGUMENTS.hp_dry")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.hp_dry#" />,</cfif>
				<cfif isDefined("ARGUMENTS.hp_aroma")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.hp_aroma#" />,</cfif>
				<cfif isDefined("ARGUMENTS.hp_bitter")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.hp_bitter#" />,</cfif>
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_hop#" maxlength="25" />,
				NOW()
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="UpdateHops" access="public" returnType="numeric" output="false">
		<cfargument name="hp_hpid" type="numeric" required="true" />
		<cfargument name="hp_hop" type="string" required="false" />
		<cfargument name="hp_aalow" type="numeric" required="false" />
		<cfargument name="hp_aahigh" type="numeric" required="false" />
		<cfargument name="hp_hsi" type="numeric" required="false" />
		<cfargument name="hp_grown" type="string" required="false" />
		<cfargument name="hp_profile" type="string" required="false" />
		<cfargument name="hp_use" type="string" required="false" />
		<cfargument name="hp_example" type="string" required="false" />
		<cfargument name="hp_sub" type="string" required="false" />
		<cfargument name="hp_info" type="string" required="false" />
		<cfargument name="hp_url" type="string" required="false" />
		<cfargument name="hp_dry" type="numeric" required="false" />
		<cfargument name="hp_aroma" type="numeric" required="false" />
		<cfargument name="hp_bitter" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updHops" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE hops
				SET <cfif isDefined("ARGUMENTS.hp_hop")>hp_hop = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_hop#" maxlength="25" />,</cfif>
					 <cfif isDefined("ARGUMENTS.hp_aalow")>hp_aalow = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.hp_aalow#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.hp_aahigh")>hp_aahigh = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.hp_aahigh#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.hp_hsi")>hp_hsi = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.hp_hsi#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.hp_grown")>hp_grown = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_grown#" maxlength="15" />,</cfif>
					 <cfif isDefined("ARGUMENTS.hp_profile")>hp_profile = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_profile#" maxlength="100" />,</cfif>
					 <cfif isDefined("ARGUMENTS.hp_use")>hp_use = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_use#" maxlength="100" />,</cfif>
					 <cfif isDefined("ARGUMENTS.hp_example")>hp_example = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_example#" maxlength="100" />,</cfif>
					 <cfif isDefined("ARGUMENTS.hp_sub")>hp_sub = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_sub#" maxlength="100" />,</cfif>
					 <cfif isDefined("ARGUMENTS.hp_info")>hp_info = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_info#" maxlength="1000" />,</cfif>
					 <cfif isDefined("ARGUMENTS.hp_url")>hp_url = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.hp_url#" maxlength="150" />,</cfif>
					 <cfif isDefined("ARGUMENTS.hp_dry")>hp_dry = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.hp_dry#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.hp_aroma")>hp_aroma = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.hp_aroma#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.hp_bitter")>hp_bitter = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.hp_bitter#" />,</cfif>
					 hp_dla = NOW()
			 WHERE hp_hpid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.hp_hpid#" />
		</cfquery>
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="DeleteHops" access="public" returnType="numeric" output="false">
		<cfargument name="hp_hpid" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delHops" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM hops
			 WHERE hp_hpid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.hp_hpid#" />
		</cfquery>
		<cfreturn LOCAL.delRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.hp_hpid = JavaCast("int", ARGUMENTS.hp_hpid) />
		<cfif IsDefined("ARGUMENTS.kill")>
			<cfset LOCAL.Response.method="Delete" />
		<cfelseif LOCAL.Response.hp_hpid neq 0>
			<cfset LOCAL.Response.method="Update" />
		<cfelse>
			<cfset LOCAL.Response.method="Insert" />
		</cfif>
		<cfinvoke method="#LOCAL.Response.method#Hops" returnvariable="LOCAL.rtn">
			<cfloop collection="#ARGUMENTS#" item="LOCAL.key">
				<cfif ARGUMENTS[LOCAL.key] neq "null">
					<cfinvokeargument name="#LOCAL.key#" value="#ARGUMENTS[LOCAL.key]#" />
				</cfif>
			</cfloop>
		</cfinvoke>
		<cfif LOCAL.Response.method eq "Insert">
			<cfset LOCAL.Response.hp_hpid = JavaCast("int", LOCAL.rtn) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="GetExplorerNodes" access="public" returntype="struct">
		<cfargument name="root" type="string" required="Yes" />
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.method = "Get" />
		<cfset LOCAL.node = ListFirst(root, "!") />
		<cfset LOCAL.value = ListLast(root, "!") />
		<cfif LOCAL.node eq "source">
			<cfset LOCAL.tree = ArrayNew(1) />
			<cfset ArrayAppend(LOCAL.tree, AddNode("trHops", " Hops", "nodeRoot", true, [])) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("HP_GROWN", "Grown", "nodeFolder", true, GetNodeChildren("hops", "hp_grown", "HP_GROWN"))) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("HP_USE", "Use", "nodeFolder", false, true)) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("HP_AAU", "AAU", "nodeFolder", false, true)) />
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(LOCAL.tree) />
		<cfelseif LOCAL.node eq "HP_USE">
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(GetNodeChildren("hops", "hp_usage", LOCAL.node, THIS.QueryUseGrouping(), {"hideCheckbox"=true})) />
		<cfelseif LOCAL.node eq "HP_AAU">
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(GetNodeChildren("hops", "hp_aarange", LOCAL.node, THIS.QueryAAUGrouping(), {"hideCheckbox"=true})) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="GetTreeNodes" access="public" returntype="array">
		<cfset LOCAL.tree = ArrayNew(1) />
		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QueryDataGroup("HP_GROWN") />
		<cfoutput query="LOCAL.qry" group="HP_GROWN">
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("HP_GROWN!#HP_GROWN#", "#HP_GROWN#<i>#cntRows#</i>", "flagTR flag#Replace(HP_GROWN,' ','','ALL')#", false, [])) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="Grown", nodes=LOCAL.branch }) />

		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QueryAAUGrouping() />
		<cfoutput query="LOCAL.qry">
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("HP_AAU!#hp_aarange#", "#hp_aarange#<i>#cntRows#</i>", "nodeEnd", false, [])) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="AAU Average", nodes=LOCAL.branch }) />

		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QueryUseGrouping() />
		<cfoutput query="LOCAL.qry">
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("HP_USE!#hp_usage#", "#hp_usage#<i>#cntRows#</i>", "nodeEnd", false, [])) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="Uses", nodes=LOCAL.branch }) />

		<cfreturn LOCAL.tree />
	</cffunction>

</cfcomponent>