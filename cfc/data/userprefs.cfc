<cfcomponent output="false" >

	<cfset init() />

	<cffunction name="init" returntype="userprefs" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryUserPrefs" access="public" returnType="query" output="false">
		<cfargument name="up_usid" type="numeric" required="true" />
		<cfargument name="up_name" type="string" required="true" />
		<cfargument name="up_upid" type="numeric" required="false" />

		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryUserPrefs" datasource="#THIS.dsn#">
			SELECT up_upid, up_usid, up_name, up_value, up_dla
			  FROM userprefs
			 WHERE up_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.up_usid#" />
				AND up_name = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.up_name#" maxlength="15">
			<cfif isDefined("ARGUMENTS.up_upid")>
				AND up_upid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.up_upid#" />
			</cfif>
			 ORDER BY up_usid, up_name
		</cfquery>
		<cfreturn LOCAL.qryUserPrefs />
	</cffunction>

	<cffunction name="InsertUserPrefs" access="public" returnType="numeric" output="false">
		<cfargument name="up_usid" type="numeric" required="true" />
		<cfargument name="up_name" type="string" required="true" />
		<cfargument name="up_value" type="string" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insUserPrefs" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO userprefs (
				up_usid, up_name,up_value,up_dla
			) VALUES (
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.up_usid#" />,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.up_name#" maxlength="15" />,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.up_value#" maxlength="5000" />,
				NOW()
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="UpdateUserPrefs" access="public" returnType="numeric" output="false">
		<cfargument name="up_usid" type="numeric" required="true" />
		<cfargument name="up_name" type="string" required="true" />
		<cfargument name="up_value" type="string" required="true" />
		<cfargument name="up_upid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updUserPrefs" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE userprefs
				SET up_value = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.up_value#" maxlength="5000" />,
					 up_dla = NOW()
			 WHERE up_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.up_usid#" />
		<cfif isDefined("ARGUMENTS.up_upid")>
				AND up_upid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.up_upid#" />
		<cfelse>
				AND up_name = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.up_name#" maxlength="15" />
		</cfif>
		</cfquery>
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="GetUserPrefs" access="public" returnType="string" output="false">
		<cfargument name="up_name" type="string" required="true" />
		<cfargument name="defaultvalue" type="string" required="false" default="" />
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.qryUP = QueryUserPrefs(up_name=ARGUMENTS.up_name, up_usid = SESSION.USER.usid) />
		<cfif LOCAL.qryUP.RecordCount>
			<cfreturn LOCAL.qryUP.up_value />
		</cfif>
		<cfreturn ARGUMENTS.defaultvalue />
	</cffunction>

	<cffunction name="SetUserPrefs" access="public" returnType="string" output="true">
		<cfargument name="up_name" type="string" required="true" />
		<cfargument name="up_value" type="string" required="true" />
		<cfset var LOCAL = StructNew() />
		<cfinvoke method="UpdateUserPrefs" returnvariable="LOCAL.updcnt">
			<cfinvokeargument name="up_usid" value="#SESSION.USER.usid#" />
			<cfinvokeargument name="up_name" value="#ARGUMENTS.up_name#" />
			<cfinvokeargument name="up_value" value="#ARGUMENTS.up_value#" />
		</cfinvoke>
		<cfif LOCAL.updcnt eq 0>
			<cfinvoke method="InsertUserPrefs" returnvariable="LOCAL.rtn">
				<cfinvokeargument name="up_usid" value="#SESSION.USER.usid#" />
				<cfinvokeargument name="up_name" value="#ARGUMENTS.up_name#" />
				<cfinvokeargument name="up_value" value="#ARGUMENTS.up_value#" />
			</cfinvoke>
		</cfif>
		<cfreturn ARGUMENTS.up_value />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfargument name="value" type="any" default="" />
		<cfargument name="defaultvalue" type="any" default="" />
		<cfset var LOCAL = StructNew() />
		<cfif IsDefined("ARGUMENTS.Set")>
			<cfset LOCAL.Response.method="Set" />
			<cfif NOT IsSimpleValue(ARGUMENTS.value)>
				<cfset ARGUMENTS.value = SerializeJSON(ARGUMENTS.value) />
			</cfif>
			<cfinvoke method="SetUserPrefs" returnvariable="LOCAL.rtn">
				<cfinvokeargument name="up_name" value="#ARGUMENTS.set#" />
				<cfinvokeargument name="up_value" value="#ARGUMENTS.value#" />
			</cfinvoke>
		<cfelse>
			<cfset LOCAL.Response.method="Get" />
			<cfset LOCAL.Response.value = ARGUMENTS.defaultvalue />
			<cfif IsDefined("ARGUMENTS.Get")>
				<cfinvoke method="GetUserPrefs" returnvariable="LOCAL.Response.data">
					<cfinvokeargument name="up_name" value="#ARGUMENTS.get#" />
					<cfinvokeargument name="defaultvalue" value="#ARGUMENTS.defaultvalue#" />
				</cfinvoke>
				<cfif isJSON(LOCAL.Response.data)>
					<cfset LOCAL.Response.value = DeserializeJSON(LOCAL.Response.data) />
				</cfif>
			</cfif>
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

</cfcomponent>
