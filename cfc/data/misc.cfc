<cfcomponent output="false" extends="explorer">

	<cfset init() />

	<cffunction name="init" returntype="misc" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfset THIS.table = "misc" />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryMisc" access="public" returnType="query" output="false">
		<cfargument name="mi_miid" type="numeric" required="false" />
		<cfargument name="mi_type" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryMisc" datasource="#THIS.dsn#">
			SELECT mi_miid, mi_type, mi_use, mi_utype, mi_unit, mi_phase, mi_info, mi_url, mi_dla
			  FROM misc
			 WHERE 0=0
			<cfif isDefined("ARGUMENTS.mi_miid")>
				AND mi_miid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.mi_miid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.mi_type")>
				AND mi_type = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_type#" />
			</cfif>
			 ORDER BY mi_type
		</cfquery>
		<cfreturn LOCAL.qryMisc />
	</cffunction>

	<cffunction name="InsertMisc" access="public" returnType="numeric" output="false">
		<cfargument name="mi_type" type="string" required="true" />
		<cfargument name="mi_use" type="string" required="false" />
		<cfargument name="mi_utype" type="string" required="false" />
		<cfargument name="mi_unit" type="string" required="false" />
		<cfargument name="mi_phase" type="string" required="false" />
		<cfargument name="mi_info" type="string" required="false" />
		<cfargument name="mi_url" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insMisc" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO misc (
				<cfif isDefined("ARGUMENTS.mi_use")>mi_use,</cfif>
				<cfif isDefined("ARGUMENTS.mi_utype")>mi_utype,</cfif>
				<cfif isDefined("ARGUMENTS.mi_unit")>mi_unit,</cfif>
				<cfif isDefined("ARGUMENTS.mi_phase")>mi_phase,</cfif>
				<cfif isDefined("ARGUMENTS.mi_info")>mi_info,</cfif>
				<cfif isDefined("ARGUMENTS.mi_url")>mi_url,</cfif>
				mi_type, mi_dla
			) VALUES (
				<cfif isDefined("ARGUMENTS.mi_use")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_use#" maxlength="25" />,</cfif>
				<cfif isDefined("ARGUMENTS.mi_utype")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_utype#" maxlength="1" />,</cfif>
				<cfif isDefined("ARGUMENTS.mi_unit")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_unit#" maxlength="12" />,</cfif>
				<cfif isDefined("ARGUMENTS.mi_phase")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_phase#" maxlength="8" />,</cfif>
				<cfif isDefined("ARGUMENTS.mi_info")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_info#" maxlength="1000" />,</cfif>
				<cfif isDefined("ARGUMENTS.mi_url")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_url#" maxlength="150" />,</cfif>
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_type#" maxlength="25" />,
				NOW()
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="UpdateMisc" access="public" returnType="numeric" output="false">
		<cfargument name="mi_miid" type="numeric" required="true" />
		<cfargument name="mi_type" type="string" required="true" />
		<cfargument name="mi_use" type="string" required="false" />
		<cfargument name="mi_utype" type="string" required="false" />
		<cfargument name="mi_unit" type="string" required="false" />
		<cfargument name="mi_phase" type="string" required="false" />
		<cfargument name="mi_info" type="string" required="false" />
		<cfargument name="mi_url" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updMisc" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE misc
				SET <cfif isDefined("ARGUMENTS.mi_type")>mi_type = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_type#" maxlength="25" />,</cfif>
					 <cfif isDefined("ARGUMENTS.mi_use")>mi_use = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_use#" maxlength="25" />,</cfif>
					 <cfif isDefined("ARGUMENTS.mi_utype")>mi_utype = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_utype#" maxlength="1" />,</cfif>
					 <cfif isDefined("ARGUMENTS.mi_unit")>mi_unit = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_unit#" maxlength="12" />,</cfif>
					 <cfif isDefined("ARGUMENTS.mi_phase")>mi_phase = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_phase#" maxlength="8" />,</cfif>
					 <cfif isDefined("ARGUMENTS.mi_info")>mi_info = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_info#" maxlength="1000" />,</cfif>
					 <cfif isDefined("ARGUMENTS.mi_url")>mi_url = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.mi_url#" maxlength="150" />,</cfif>
					 mi_dla = NOW()
			 WHERE mi_miid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.mi_miid#" />
		</cfquery>
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="DeleteMisc" access="public" returnType="numeric" output="false">
		<cfargument name="mi_miid" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delMisc" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM misc
			 WHERE mi_miid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.mi_miid#" />
		</cfquery>
		<cfreturn LOCAL.delRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.mi_miid = JavaCast("int", ARGUMENTS.mi_miid) />
		<cfif IsDefined("ARGUMENTS.kill")>
			<cfset LOCAL.Response.method="Delete" />
		<cfelseif LOCAL.Response.mi_miid neq 0>
			<cfset LOCAL.Response.method="Update" />
		<cfelse>
			<cfset LOCAL.Response.method="Insert" />
		</cfif>
		<cfinvoke method="#LOCAL.Response.method#Misc" returnvariable="LOCAL.rtn">
			<cfloop collection="#ARGUMENTS#" item="LOCAL.key">
				<cfif ARGUMENTS[LOCAL.key] neq "null">
					<cfinvokeargument name="#LOCAL.key#" value="#ARGUMENTS[LOCAL.key]#" />
				</cfif>
			</cfloop>
		</cfinvoke>
		<cfif LOCAL.Response.method eq "Insert">
			<cfset LOCAL.Response.mi_miid = JavaCast("int", LOCAL.rtn) />
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
			<cfset ArrayAppend(LOCAL.tree, AddNode("trMisc", " Misc", "nodeRoot", true, [])) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("MI_USE", "Use", "nodeFolder", true, GetNodeChildren("misc", "mi_use", "MI_USE"))) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("MI_PHASE", "Phase", "nodeFolder", false, true)) />
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(LOCAL.tree) />
		<cfelseif LOCAL.node eq "MI_PHASE">
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(GetNodeChildren("misc", "mi_phase", LOCAL.node)) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="GetTreeNodes" access="public" returntype="array">
		<cfset LOCAL.tree = ArrayNew(1) />
		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QueryDataGroup("MI_PHASE") />
		<cfoutput query="LOCAL.qry">
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("MI_PHASE!#MI_PHASE#", "#MI_PHASE#<i>#cntRows#</i>", "nodeEnd", false, [])) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="Brew Phase", nodes=LOCAL.branch }) />
		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QueryDataGroup("MI_USE") />
		<cfoutput query="LOCAL.qry">
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("MI_USE!#MI_USE#", "#MI_USE#<i>#cntRows#</i>", "nodeEnd", false, [])) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="Use", nodes=LOCAL.branch }) />
		<cfreturn LOCAL.tree />
	</cffunction>


</cfcomponent>
