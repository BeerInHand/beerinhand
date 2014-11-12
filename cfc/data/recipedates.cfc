<cfcomponent output="false" >

	<cfset init() />

	<cffunction name="init" returntype="recipedates" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryRecipeDates" access="public" returnType="query" output="false">
		<cfargument name="rd_rdid" type="numeric" required="false" />
		<cfargument name="rd_reid" type="numeric" required="false" />
		<cfargument name="rd_usid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryRecipeDates" datasource="#THIS.dsn#">
			SELECT rd_rdid, rd_reid, rd_usid, rd_date, rd_type, rd_gravity, rd_temp, rd_note
			  FROM recipedates
			 WHERE 0=0
			<cfif isDefined("ARGUMENTS.rd_rdid")>
				AND rd_rdid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rd_rdid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.rd_reid")>
				AND rd_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rd_reid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.rd_usid")>
				AND rd_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rd_usid#" />
			</cfif>
			 ORDER BY rd_date, rd_type
		</cfquery>
		<cfreturn LOCAL.qryRecipeDates />
	</cffunction>

	<cffunction name="InsertRecipeDates" access="public" returnType="numeric" output="false">
		<cfargument name="rd_reid" type="numeric" required="true" />
		<cfargument name="rd_usid" type="numeric" required="true" />
		<cfargument name="rd_date" type="string" required="false" />
		<cfargument name="rd_type" type="string" required="false" />
		<cfargument name="rd_gravity" type="string" required="false" />
		<cfargument name="rd_temp" type="string" required="false" />
		<cfargument name="rd_note" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insRecipeDates" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO recipedates (
				<cfif isDefined("ARGUMENTS.rd_date")>rd_date,</cfif>
				<cfif isDefined("ARGUMENTS.rd_type")>rd_type,</cfif>
				<cfif isDefined("ARGUMENTS.rd_gravity")>rd_gravity,</cfif>
				<cfif isDefined("ARGUMENTS.rd_temp")>rd_temp,</cfif>
				<cfif isDefined("ARGUMENTS.rd_note")>rd_note,</cfif>
				rd_reid, rd_usid
			) VALUES (
				<cfif isDefined("ARGUMENTS.rd_date")><cfqueryparam cfsqltype="CF_SQL_DATE" value="#ARGUMENTS.rd_date#" null="#not IsDate(ARGUMENTS.rd_date)#" />,</cfif>
				<cfif isDefined("ARGUMENTS.rd_type")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.rd_type#" maxlength="10" />,</cfif>
				<cfif isDefined("ARGUMENTS.rd_gravity")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rd_gravity#" null="#NOT isNumeric(ARGUMENTS.rd_gravity)#" />,</cfif>
				<cfif isDefined("ARGUMENTS.rd_temp")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rd_temp#" null="#NOT isNumeric(ARGUMENTS.rd_temp)#" />,</cfif>
				<cfif isDefined("ARGUMENTS.rd_note")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.rd_note#" maxlength="5000" />,</cfif>
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rd_reid#" />,
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rd_usid#" />
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="UpdateRecipeDates" access="public" returnType="numeric" output="false">
		<cfargument name="rd_rdid" type="numeric" required="true" />
		<cfargument name="rd_usid" type="numeric" required="true" />
		<cfargument name="rd_type" type="string" required="false" />
		<cfargument name="rd_gravity" type="string" required="false" />
		<cfargument name="rd_temp" type="string" required="false" />
		<cfargument name="rd_note" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updRecipeDates" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE recipedates
				SET <cfif isDefined("ARGUMENTS.rd_date")>rd_date = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#ARGUMENTS.rd_date#" null="#not IsDate(ARGUMENTS.rd_date)#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rd_type")>rd_type = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.rd_type#" maxlength="10" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rd_gravity")>rd_gravity = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rd_gravity#" null="#NOT isNumeric(ARGUMENTS.rd_gravity)#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rd_temp")>rd_temp = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rd_temp#" null="#NOT isNumeric(ARGUMENTS.rd_temp)#" />,</cfif>
					 rd_note = <cfif isDefined("ARGUMENTS.rd_note")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.rd_note#" maxlength="5000" /><cfelse>rd_note</cfif>
			 WHERE rd_rdid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rd_rdid#" />
				AND rd_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rd_usid#" />
		</cfquery>
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="DeleteRecipeDates" access="public" returnType="numeric" output="false">
		<cfargument name="rd_reid" type="numeric" required="true" />
		<cfargument name="rd_usid" type="numeric" required="true" />
		<cfargument name="rd_rdid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delRecipeDates" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM recipedates
			 WHERE rd_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rd_reid#" />
				AND rd_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rd_usid#" />
			<cfif isDefined("ARGUMENTS.rd_rdid")>
				AND rd_rdid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rd_rdid#" />
			</cfif>
		</cfquery>
		<cfreturn LOCAL.delRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.rd_rdid = JavaCast("int", ARGUMENTS.rd_rdid) />
		<cfset LOCAL.Response.rd_usid = JavaCast("int", SESSION.USER.usid) />
		<cfset ARGUMENTS.rd_usid = LOCAL.Response.rd_usid />
		<cfif IsDefined("ARGUMENTS.kill")>
			<cfset LOCAL.Response.method="Delete" />
		<cfelseif LOCAL.Response.rd_rdid neq 0>
			<cfset LOCAL.Response.method="Update" />
		<cfelse>
			<cfset LOCAL.Response.method="Insert" />
		</cfif>
		<cfinvoke method="#LOCAL.Response.method#RecipeDates" returnvariable="LOCAL.rtn">
			<cfloop collection="#ARGUMENTS#" item="LOCAL.key">
				<cfif ARGUMENTS[LOCAL.key] neq "null">
					<cfinvokeargument name="#LOCAL.key#" value="#ARGUMENTS[LOCAL.key]#" />
				</cfif>
			</cfloop>
		</cfinvoke>
		<cfif LOCAL.Response.method eq "Insert">
			<cfset LOCAL.Response.rd_rdid = JavaCast("int", LOCAL.rtn) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

</cfcomponent>
