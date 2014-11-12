<cfcomponent output="false" >

	<cfset init() />

	<cffunction name="init" returntype="recipemisc" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryRecipeMisc" access="public" returnType="query" output="false">
		<cfargument name="rm_rmid" type="numeric" required="false" />
		<cfargument name="rm_reid" type="numeric" required="false" />
		<cfargument name="rm_usid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryRecipeMisc" datasource="#THIS.dsn#">
			SELECT rm_rmid, rm_reid, rm_usid, rm_type, rm_amount, rm_unit, rm_utype, rm_note, rm_phase, rm_action, rm_offset, rm_added, rm_sort
			  FROM recipemisc
			 WHERE 0=0
			<cfif isDefined("ARGUMENTS.rm_rmid")>
				AND rm_rmid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rm_rmid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.rm_reid")>
				AND rm_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rm_reid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.rm_usid")>
				AND rm_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rm_usid#" />
			</cfif>
			 ORDER BY rm_phase, rm_added DESC
		</cfquery>
		<cfreturn LOCAL.qryRecipeMisc />
	</cffunction>

	<cffunction name="InsertRecipeMisc" access="public" returnType="numeric" output="false">
		<cfargument name="rm_reid" type="numeric" required="true" />
		<cfargument name="rm_usid" type="numeric" required="true" />
		<cfargument name="rm_type" type="string" required="false" />
		<cfargument name="rm_amount" type="numeric" required="false" />
		<cfargument name="rm_unit" type="string" required="false" />
		<cfargument name="rm_utype" type="string" required="false" />
		<cfargument name="rm_note" type="string" required="false" />
		<cfargument name="rm_phase" type="string" required="false" />
		<cfargument name="rm_action" type="string" required="false" />
		<cfargument name="rm_offset" type="numeric" required="false" />
		<cfargument name="rm_added" type="string" required="false" />
		<cfargument name="rm_sort" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insRecipeMisc" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO recipemisc (
				<cfif isDefined("ARGUMENTS.rm_type")>rm_type,</cfif>
				<cfif isDefined("ARGUMENTS.rm_amount")>rm_amount,</cfif>
				<cfif isDefined("ARGUMENTS.rm_unit")>rm_unit,</cfif>
				<cfif isDefined("ARGUMENTS.rm_utype")>rm_utype,</cfif>
				<cfif isDefined("ARGUMENTS.rm_note")>rm_note,</cfif>
				<cfif isDefined("ARGUMENTS.rm_phase")>rm_phase,</cfif>
				<cfif isDefined("ARGUMENTS.rm_action")>rm_action,</cfif>
				<cfif isDefined("ARGUMENTS.rm_offset")>rm_offset,</cfif>
				<cfif isDefined("ARGUMENTS.rm_added")>rm_added,</cfif>
				<cfif isDefined("ARGUMENTS.rm_sort")>rm_sort,</cfif>
				rm_reid, rm_usid
			) VALUES (
				<cfif isDefined("ARGUMENTS.rm_type")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_type,50)#" maxlength="50" />,</cfif>
				<cfif isDefined("ARGUMENTS.rm_amount")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rm_amount#" />,</cfif>
				<cfif isDefined("ARGUMENTS.rm_unit")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_unit,12)#" maxlength="12" />,</cfif>
				<cfif isDefined("ARGUMENTS.rm_utype")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_utype,1)#" maxlength="1" />,</cfif>
				<cfif isDefined("ARGUMENTS.rm_note")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_note,25)#" maxlength="25" />,</cfif>
				<cfif isDefined("ARGUMENTS.rm_phase")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_phase,8)#" maxlength="8" />,</cfif>
				<cfif isDefined("ARGUMENTS.rm_action")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_action,12)#" maxlength="12" />,</cfif>
				<cfif isDefined("ARGUMENTS.rm_offset")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.rm_offset#" />,</cfif>
				<cfif isDefined("ARGUMENTS.rm_added")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_added,15)#" maxlength="15" />,</cfif>
				<cfif isDefined("ARGUMENTS.rm_sort")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_sort,8)#" maxlength="8" />,</cfif>
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rm_reid#" />,
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rm_usid#" />
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="UpdateRecipeMisc" access="public" returnType="numeric" output="false">
		<cfargument name="rm_rmid" type="numeric" required="true" />
		<cfargument name="rm_reid" type="numeric" required="true" />
		<cfargument name="rm_usid" type="numeric" required="true" />
		<cfargument name="rm_type" type="string" required="false" />
		<cfargument name="rm_amount" type="numeric" required="false" />
		<cfargument name="rm_unit" type="string" required="false" />
		<cfargument name="rm_utype" type="string" required="false" />
		<cfargument name="rm_note" type="string" required="false" />
		<cfargument name="rm_phase" type="string" required="false" />
		<cfargument name="rm_action" type="string" required="false" />
		<cfargument name="rm_offset" type="numeric" required="false" />
		<cfargument name="rm_added" type="string" required="false" />
		<cfargument name="rm_sort" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updRecipeMisc" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE recipemisc
				SET <cfif isDefined("ARGUMENTS.rm_type")>rm_type = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_type,25)#" maxlength="25" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rm_amount")>rm_amount = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rm_amount#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rm_unit")>rm_unit = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_unit,12)#" maxlength="12" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rm_utype")>rm_utype = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_utype,1)#" maxlength="1" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rm_note")>rm_note = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_note,25)#" maxlength="25" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rm_phase")>rm_phase = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_phase,8)#" maxlength="8" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rm_action")>rm_action = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_action,12)#" maxlength="12" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rm_offset")>rm_offset = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.rm_offset#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rm_added")>rm_added = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_added,15)#" maxlength="15" />,</cfif>
					 rm_sort = <cfif isDefined("ARGUMENTS.rm_sort")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rm_sort,8)#" maxlength="8" /><cfelse>rm_sort</cfif>
			 WHERE rm_rmid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rm_rmid#" />
				AND rm_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rm_reid#" />
				AND rm_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rm_usid#" />
		</cfquery>
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="DeleteRecipeMisc" access="public" returnType="numeric" output="false">
		<cfargument name="rm_reid" type="numeric" required="true" />
		<cfargument name="rm_usid" type="numeric" required="true" />
		<cfargument name="rm_rmid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delRecipeMisc" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM recipemisc
			 WHERE rm_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rm_reid#" />
				AND rm_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rm_usid#" />
			<cfif isDefined("ARGUMENTS.rm_rmid")>
				AND rm_rmid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rm_rmid#" />
			</cfif>
		</cfquery>
		<cfreturn LOCAL.delRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.rm_rmid = JavaCast("int", ARGUMENTS.rm_rmid) />
		<cfif IsDefined("ARGUMENTS.kill")>
			<cfset LOCAL.Response.method="Delete" />
		<cfelseif LOCAL.Response.rm_rmid neq 0>
			<cfset LOCAL.Response.method="Update" />
		<cfelse>
			<cfset LOCAL.Response.method="Insert" />
		</cfif>
		<cfinvoke method="#LOCAL.Response.method#RecipeMisc" returnvariable="LOCAL.rtn">
			<cfloop collection="#ARGUMENTS#" item="LOCAL.key">
				<cfif ARGUMENTS[LOCAL.key] neq "null">
					<cfinvokeargument name="#LOCAL.key#" value="#ARGUMENTS[LOCAL.key]#" />
				</cfif>
			</cfloop>
		</cfinvoke>
		<cfif LOCAL.Response.method eq "Insert">
			<cfset LOCAL.Response.rm_rmid = JavaCast("int", LOCAL.rtn) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

</cfcomponent>
