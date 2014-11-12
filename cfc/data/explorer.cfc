<cfcomponent>

	<cffunction name="AddNode" access="public" returntype="struct">
		<cfargument name="id" type="string" required="Yes" />
		<cfargument name="text" type="string" required="Yes" />
		<cfargument name="classes" type="string" required="Yes" />
		<cfargument name="expanded" type="boolean" required="Yes" />
		<cfargument name="children" type="any" required="No" />
		<cfargument name="nodeOptions" type="struct" required="No" />
		<cfset LOCAL.str = StructNew() />
		<cfset LOCAL.str["key"] = ARGUMENTS["id"] />
		<cfset LOCAL.str["title"] = ARGUMENTS["text"] />
		<cfset LOCAL.str["addClass"] = ARGUMENTS["classes"] />
		<cfset LOCAL.str["select"] = false />
		<cfif ARGUMENTS["classes"] eq "nodeFolder">
			<cfset LOCAL.str["isFolder"] = true />
		</cfif>
		<cfif ARGUMENTS["classes"] eq "nodeRoot">
			<cfset LOCAL.str["isFolder"] = true />
			<cfset LOCAL.str["isRoot"] = true />
			<cfset LOCAL.str["hideCheckbox"] = true />
		<cfelse>
			<cfset LOCAL.str["isRoot"] = false />
		</cfif>
		<cfset LOCAL.str["expand"] = ARGUMENTS["expanded"] />
		<cfif isDefined("ARGUMENTS.children")>
			<cfif isArray(ARGUMENTS.children)>
				<cfset LOCAL.str["children"] = ARGUMENTS["children"] />
			<cfelseif ARGUMENTS.children>
				<cfset LOCAL.str["isLazy"] = true />
			</cfif>
		</cfif>
		<cfif StructKeyExists(ARGUMENTS, "nodeOptions")>
			<cfloop collection="#ARGUMENTS.nodeOptions#" item="opt">
				<cfset LOCAL.str[opt] = ARGUMENTS.nodeOptions[opt] />
			</cfloop>
		</cfif>
		<cfreturn LOCAL.str />
	</cffunction>

	<cffunction name="GetNodeChildren" access="public" returntype="array">
		<cfargument name="tab" type="string" required="Yes" />
		<cfargument name="fld" type="string" required="Yes" />
		<cfargument name="id" type="string" required="Yes" />
		<cfargument name="qry" type="any" required="No" />
		<cfargument name="nodeOptions" type="struct" required="No" default="#{}#" />
		<cfargument name="brewerID" type="numeric" required="No" />
		<cfif isDefined("ARGUMENTS.qry") and isQuery(ARGUMENTS.qry)>
			<cfset LOCAL.qry = ARGUMENTS.qry />
		<cfelse>
			<cfquery name="LOCAL.qry" datasource="#THIS.dsn#">
				SELECT #ARGUMENTS.fld#, COUNT(*) AS cntRows
				  FROM #ARGUMENTS.tab#
				<cfif ARGUMENTS.tab eq "recipe">
				 WHERE re_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.brewerID#" />
				 	AND IF(re_usid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#udfIfDefined('SESSION.USER.usid',0)#" />, 0, re_privacy) < 2
				</cfif>
				 GROUP BY #ARGUMENTS.fld#
			</cfquery>
		</cfif>
		<cfset LOCAL.nodes = ArrayNew(1) />
		<cfoutput query="LOCAL.qry">
			<cfset LOCAL.txt = LOCAL.qry[ARGUMENTS.fld] />
			<cfset ArrayAppend(LOCAL.nodes, AddNode("#ARGUMENTS.id#!#LOCAL.txt#", "#LOCAL.txt#<i>#cntRows#</i>", "nodeEnd", false, false, ARGUMENTS.nodeOptions)) />
		</cfoutput>
		<cfreturn LOCAL.nodes />
	</cffunction>

	<cffunction name="QueryDLA" access="public" returnType="numeric" output="false">
		<cfargument name="table" type="string" required="true" />
		<cfargument name="field" type="string" required="true" />

		<cfquery name="LOCAL.qryDLA" datasource="#THIS.dsn#">
			SELECT max(#ARGUMENTS.field#) AS DLA
			  FROM #ARGUMENTS.table#
		</cfquery>
		<cfreturn LOCAL.qryDLA.DLA />
		<cfreturn ParseDateTime(LOCAL.qryDLA.DLA).getTime()/1000 />
	</cffunction>

	<cffunction name="QueryDataGroup" access="public" returntype="query">
		<cfargument name="fld" type="string" required="Yes" />
		<cfargument name="tab" type="string" default="#THIS.table#" />
		<cfquery name="LOCAL.qryGroup" datasource="#THIS.dsn#">
			SELECT #ARGUMENTS.fld#, COUNT(*) AS cntRows
			  FROM #ARGUMENTS.tab#
			 WHERE IFNULL(concat(#ARGUMENTS.fld#),"")<>""
			 GROUP BY #ARGUMENTS.fld#
		</cfquery>
		<cfreturn LOCAL.qryGroup />
	</cffunction>

</cfcomponent>