<cfcomponent output="false" >

	<cfset init() />

	<cffunction name="init" returntype="datafiles" output="true">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfset THIS.SetDLAs() />
		<cfquery name="LOCAL.qryDataFiles" datasource="#THIS.dsn#">
			SELECT COUNT(*) FROM DATAFILES
		</cfquery>
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryDataFiles" access="public" returnType="query" output="false">
		<cfargument name="df_table" type="string" required="false" />
		<cfquery name="LOCAL.qryDataFiles" datasource="#THIS.dsn#">
			SELECT df_table, df_dla
			  FROM datafiles
			<cfif isDefined("ARGUMENTS.df_dfid")>
				AND df_table = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.df_table#" maxlength="25" />
			</cfif>
		</cfquery>
		<cfreturn LOCAL.qryDataFiles />
	</cffunction>

	<cffunction name="InsertDataFiles" access="public" returnType="numeric" output="false">
		<cfargument name="df_table" type="string" required="true" />
		<cfargument name="df_dla" type="date" default="#now()#" />
		<cfquery name="LOCAL.insDataFiles" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO datafiles (
				df_table, df_dla
			) VALUES (
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.df_table#" maxlength="25" />,
				<cfqueryparam cfsqltype="CF_SQL_DATE" value="#ARGUMENTS.df_dla#" null="#not IsDate(ARGUMENTS.df_dla)#" />
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="UpdateDataFiles" access="public" returnType="numeric" output="false">
		<cfargument name="df_table" type="string" required="true" />
		<cfargument name="df_dla" type="date" required="true" />
		<cfquery name="LOCAL.updDataFiles" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE datafiles
				SET df_dla = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#ARGUMENTS.df_dla#" null="#not IsDate(ARGUMENTS.df_dla)#" />
			 WHERE df_table = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.df_table#" maxlength="25" />
		</cfquery>
		<cfset VARIABLES["DLA#ARGUMENTS.df_table#"] = ParseDateTime(ARGUMENTS.df_dla).getTime()/1000 />
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="SetCFC" access="public" output="No" returntype="void">
		<cfargument name="table" type="string" required="true" />
		<cfargument name="cfc" type="any" required="true" />
		<cfset VARIABLES[ARGUMENTS.table] = ARGUMENTS.cfc />
	</cffunction>

	<cffunction name="GetDLA" access="public" output="No" returntype="string">
		<cfargument name="table" type="string" required="true" />
		<cfreturn VARIABLES["DLA#ARGUMENTS.table#"] />
	</cffunction>

	<cffunction name="SetDLAs" access="public" output="No" returntype="void">
		<cfset LOCAL.qry = THIS.QueryDataFiles() />
		<cfloop query="LOCAL.qry">
			<cfset VARIABLES["DLA#LOCAL.qry.df_table#"] = ParseDateTime(LOCAL.qry.df_dla).getTime()/1000 />
		</cfloop>
	</cffunction>

	<cffunction name="WriteDataFile" access="public" returntype="void">
		<cfargument name="table" type="string" required="true" />
		<cfargument name="idx_field" type="string" required="true" />
		<cfargument name="dla_field" type="string" required="true" />
		<cfargument name="pk_field" type="string" required="true" />
		<cfset LOCAL.lower = LCASE(ARGUMENTS.table) />
		<cfif ARGUMENTS.table EQ "BJCPStyles">
			<cfset LOCAL.DLA = CreateDate(2008,1,1) />
		<cfelse>
			<cfinvoke component="#VARIABLES[ARGUMENTS.table]#" method="QueryDLA" table="#ARGUMENTS.table#" field="#ARGUMENTS.dla_field#" returnvariable="LOCAL.DLA" />
		</cfif>
		<cfinvoke component="#VARIABLES[ARGUMENTS.table]#" method="Query#ARGUMENTS.table#" returnvariable="LOCAL.qry" />
		<cfinvoke component="#VARIABLES[ARGUMENTS.table]#" method="GetTreeNodes" returnvariable="LOCAL.nodes" />

		<cffile action="write" file="#APPLICATION.DISK.ROOT#/js/#LOCAL.lower#_data.js" charset="utf-8"
output="
qry#ARGUMENTS.table# = #udfQueryToJSON(LOCAL.qry)#;
qry#ARGUMENTS.table#.PKID = ""#ARGUMENTS.pk_field#"";
idx#ARGUMENTS.table# = #udfMakeIndex(LOCAL.qry, ARGUMENTS.idx_field)#;
nodes#ARGUMENTS.table# = #SerializeJSON(LOCAL.nodes)#;
" />
		<cfset THIS.UpdateDataFiles(ARGUMENTS.table, LOCAL.DLA) />
	</cffunction>

</cfcomponent>