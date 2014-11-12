<cfcomponent output="false" extends="explorer">

	<cfset init() />

	<cffunction name="init" returntype="yeast" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfset THIS.table = "yeast" />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryYeast" access="public" returnType="query" output="false">
		<cfargument name="ye_yeid" type="numeric" required="false" />
		<cfargument name="ye_yeast" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryYeast" datasource="#THIS.dsn#">
			SELECT ye_yeid, ye_yeast, ye_atlow, ye_athigh, ye_atten, ye_floc, ye_type, ye_mfg, ye_mfgno, ye_form, ye_tolerance, ye_info, ye_url, ye_templow, ye_temphigh, ye_tempunits, ye_dla
			  FROM yeast
			 WHERE 0=0
			<cfif isDefined("ARGUMENTS.ye_yeid")>
				AND ye_yeid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ye_yeid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.ye_yeast")>
				AND ye_yeast = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_yeast#" />
			</cfif>
			 ORDER BY ye_yeast, ye_mfgno
		</cfquery>
		<cfreturn LOCAL.qryYeast />
	</cffunction>

	<cffunction name="InsertYeast" access="public" returnType="numeric" output="false">
		<cfargument name="ye_yeast" type="string" required="false" />
		<cfargument name="ye_atlow" type="numeric" required="false" />
		<cfargument name="ye_athigh" type="numeric" required="false" />
		<cfargument name="ye_atten" type="string" required="false" />
		<cfargument name="ye_floc" type="string" required="false" />
		<cfargument name="ye_type" type="string" required="false" />
		<cfargument name="ye_mfg" type="string" required="false" />
		<cfargument name="ye_mfgno" type="string" required="false" />
		<cfargument name="ye_form" type="string" required="false" />
		<cfargument name="ye_tolerance" type="string" required="false" />
		<cfargument name="ye_info" type="string" required="false" />
		<cfargument name="ye_url" type="string" required="false" />
		<cfargument name="ye_templow" type="numeric" required="false" />
		<cfargument name="ye_temphigh" type="numeric" required="false" />
		<cfargument name="ye_tempunits" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insYeast" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO yeast (
				<cfif isDefined("ARGUMENTS.ye_yeast")>ye_yeast,</cfif>
				<cfif isDefined("ARGUMENTS.ye_atlow")>ye_atlow,</cfif>
				<cfif isDefined("ARGUMENTS.ye_athigh")>ye_athigh,</cfif>
				<cfif isDefined("ARGUMENTS.ye_atten")>ye_atten,</cfif>
				<cfif isDefined("ARGUMENTS.ye_floc")>ye_floc,</cfif>
				<cfif isDefined("ARGUMENTS.ye_type")>ye_type,</cfif>
				<cfif isDefined("ARGUMENTS.ye_mfg")>ye_mfg,</cfif>
				<cfif isDefined("ARGUMENTS.ye_mfgno")>ye_mfgno,</cfif>
				<cfif isDefined("ARGUMENTS.ye_form")>ye_form,</cfif>
				<cfif isDefined("ARGUMENTS.ye_tolerance")>ye_tolerance,</cfif>
				<cfif isDefined("ARGUMENTS.ye_info")>ye_info,</cfif>
				<cfif isDefined("ARGUMENTS.ye_url")>ye_url,</cfif>
				<cfif isDefined("ARGUMENTS.ye_templow")>ye_templow,</cfif>
				<cfif isDefined("ARGUMENTS.ye_temphigh")>ye_temphigh,</cfif>
				<cfif isDefined("ARGUMENTS.ye_tempunits")>ye_tempunits,</cfif>
				ye_dla
			) VALUES (
				<cfif isDefined("ARGUMENTS.ye_yeast")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_yeast#" maxlength="60" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_atlow")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.ye_atlow#" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_athigh")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.ye_athigh#" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_atten")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_atten#" maxlength="11" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_floc")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_floc#" maxlength="11" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_type")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_type#" maxlength="10" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_mfg")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_mfg#" maxlength="20" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_mfgno")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_mfgno#" maxlength="10" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_form")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_form#" maxlength="10" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_tolerance")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_tolerance#" maxlength="10" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_info")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_info#" maxlength="1000" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_url")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_url#" maxlength="150" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_templow")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.ye_templow#" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_temphigh")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.ye_temphigh#" />,</cfif>
				<cfif isDefined("ARGUMENTS.ye_tempunits")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_tempunits#" maxlength="10" />,</cfif>
				NOW()
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="UpdateYeast" access="public" returnType="numeric" output="false">
		<cfargument name="ye_yeid" type="numeric" required="true" />
		<cfargument name="ye_yeast" type="string" required="false" />
		<cfargument name="ye_atlow" type="numeric" required="false" />
		<cfargument name="ye_athigh" type="numeric" required="false" />
		<cfargument name="ye_atten" type="string" required="false" />
		<cfargument name="ye_floc" type="string" required="false" />
		<cfargument name="ye_type" type="string" required="false" />
		<cfargument name="ye_mfg" type="string" required="false" />
		<cfargument name="ye_mfgno" type="string" required="false" />
		<cfargument name="ye_form" type="string" required="false" />
		<cfargument name="ye_tolerance" type="string" required="false" />
		<cfargument name="ye_info" type="string" required="false" />
		<cfargument name="ye_url" type="string" required="false" />
		<cfargument name="ye_templow" type="numeric" required="false" />
		<cfargument name="ye_temphigh" type="numeric" required="false" />
		<cfargument name="ye_tempunits" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updYeast" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE yeast
				SET <cfif isDefined("ARGUMENTS.ye_yeast")>ye_yeast = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_yeast#" maxlength="60" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_atlow")>ye_atlow = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.ye_atlow#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_athigh")>ye_athigh = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.ye_athigh#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_atten")>ye_atten = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_atten#" maxlength="11" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_floc")>ye_floc = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_floc#" maxlength="11" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_type")>ye_type = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_type#" maxlength="10" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_mfg")>ye_mfg = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_mfg#" maxlength="20" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_mfgno")>ye_mfgno = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_mfgno#" maxlength="10" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_form")>ye_form = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_form#" maxlength="10" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_tolerance")>ye_tolerance = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_tolerance#" maxlength="10" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_info")>ye_info = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_info#" maxlength="1000" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_url")>ye_url = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_url#" maxlength="150" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_templow")>ye_templow = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.ye_templow#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_temphigh")>ye_temphigh = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.ye_temphigh#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ye_tempunits")>ye_tempunits = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ye_tempunits#" maxlength="10" />,</cfif>
					 ye_dla = NOW()
			 WHERE ye_yeid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ye_yeid#" />
		</cfquery>
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="DeleteYeast" access="public" returnType="numeric" output="false">
		<cfargument name="ye_yeid" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delYeast" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM yeast
			 WHERE ye_yeid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ye_yeid#" />
		</cfquery>
		<cfreturn LOCAL.delRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.ye_yeid = JavaCast("int", ARGUMENTS.ye_yeid) />
		<cfif IsDefined("ARGUMENTS.kill")>
			<cfset LOCAL.Response.method="Delete" />
		<cfelseif LOCAL.Response.ye_yeid neq 0>
			<cfset LOCAL.Response.method="Update" />
		<cfelse>
			<cfset LOCAL.Response.method="Insert" />
		</cfif>
		<cfinvoke method="#LOCAL.Response.method#Yeast" returnvariable="LOCAL.rtn">
			<cfloop collection="#ARGUMENTS#" item="LOCAL.key">
				<cfif ARGUMENTS[LOCAL.key] neq "null">
					<cfinvokeargument name="#LOCAL.key#" value="#ARGUMENTS[LOCAL.key]#" />
				</cfif>
			</cfloop>
		</cfinvoke>
		<cfif LOCAL.Response.method eq "Insert">
			<cfset LOCAL.Response.ye_yeid = JavaCast("int", LOCAL.rtn) />
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
			<cfset ArrayAppend(LOCAL.tree, AddNode("trYeast", " Yeast", "nodeRoot", true, [])) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("YE_MFG", "Manufacturer", "nodeFolder", true, GetNodeChildren("yeast", "ye_mfg", "YE_MFG"))) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("YE_TYPE", "Type", "nodeFolder", false, true)) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("YE_ATTEN", "Attenuation", "nodeFolder", false, true)) />
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(LOCAL.tree) />
		<cfelseif LOCAL.node eq "YE_TYPE">
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(GetNodeChildren("yeast", "ye_type", LOCAL.node)) />
		<cfelseif LOCAL.node eq "YE_ATTEN">
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(GetNodeChildren("yeast", "ye_atten", LOCAL.node, false, {"hideCheckbox"=true})) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="GetTreeNodes" access="public" returntype="array">
		<cfset LOCAL.tree = ArrayNew(1) />
		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QueryDataGroup("YE_MFG, YE_TYPE") />
		<cfoutput query="LOCAL.qry" group="YE_MFG">
			<cfset LOCAL.leaf = ArrayNew(1) />
			<cfset LOCAL.sumRows = 0 />
			<cfoutput>
				<cfset LOCAL.sumRows = LOCAL.sumRows + cntRows />
				<cfset ArrayAppend(LOCAL.leaf, THIS.AddNode("YE_TYPE!#YE_TYPE#", "#YE_TYPE#<i>#cntRows#</i>", "nodeEnd", false, [])) />
			</cfoutput>
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("YE_MFG!#YE_MFG#", "#YE_MFG#<i>#sumRows#</i>", "nodeEnd", false, LOCAL.leaf)) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="Manufacturer", nodes=LOCAL.branch }) />

		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QueryDataGroup("YE_TYPE, YE_FORM") />
		<cfoutput query="LOCAL.qry" group="YE_TYPE">
			<cfset LOCAL.leaf = ArrayNew(1) />
			<cfset LOCAL.sumRows = 0 />
			<cfoutput>
				<cfset LOCAL.sumRows = LOCAL.sumRows + cntRows />
				<cfset ArrayAppend(LOCAL.leaf, THIS.AddNode("YE_FORM!#YE_FORM#", "#YE_FORM#<i>#cntRows#</i>", "nodeEnd", false, [])) />
			</cfoutput>
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("YE_TYPE!#YE_TYPE#", "#YE_TYPE#<i>#sumRows#</i>", "nodeEnd", false, LOCAL.leaf)) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="Type", nodes=LOCAL.branch }) />

		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QueryDataGroup("YE_ATTEN") />
		<cfoutput query="LOCAL.qry">
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("YE_ATTEN!#YE_ATTEN#", "#YE_ATTEN#<i>#cntRows#</i>", "nodeEnd", false, [])) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="Attenuation", nodes=LOCAL.branch }) />

		<cfreturn LOCAL.tree />
	</cffunction>

</cfcomponent>
