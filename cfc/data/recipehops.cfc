<cfcomponent output="false" >

	<cfset init() />

	<cffunction name="init" returntype="recipehops" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryRecipeHops" access="public" returnType="query" output="false">
		<cfargument name="rh_rhid" type="numeric" required="false" />
		<cfargument name="rh_reid" type="numeric" required="false" />
		<cfargument name="rh_usid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryRecipeHops" datasource="#THIS.dsn#">
			SELECT rh_rhid, rh_reid, rh_usid, rh_hop, rh_aau, rh_amount, rh_form, rh_time, rh_ibu, rh_grown, rh_when
			  FROM recipehops
			 WHERE 0=0
			<cfif isDefined("ARGUMENTS.rh_rhid")>
				AND rh_rhid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rh_rhid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.rh_reid")>
				AND rh_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rh_reid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.rh_usid")>
				AND rh_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rh_usid#" />
			</cfif>
			 ORDER BY rh_time DESC, rh_ibu DESC
		</cfquery>
		<cfreturn LOCAL.qryRecipeHops />
	</cffunction>

	<cffunction name="InsertRecipeHops" access="public" returnType="numeric" output="false">
		<cfargument name="rh_reid" type="numeric" required="true" />
		<cfargument name="rh_usid" type="numeric" required="true" />
		<cfargument name="rh_hop" type="string" required="false" />
		<cfargument name="rh_aau" type="numeric" required="false" />
		<cfargument name="rh_amount" type="numeric" required="false" />
		<cfargument name="rh_form" type="string" required="false" />
		<cfargument name="rh_time" type="string" required="false" />
		<cfargument name="rh_ibu" type="numeric" required="false" />
		<cfargument name="rh_grown" type="string" required="false" />
		<cfargument name="rh_when" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insRecipeHops" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO recipehops (
				<cfif isDefined("ARGUMENTS.rh_hop")>rh_hop,</cfif>
				<cfif isDefined("ARGUMENTS.rh_aau")>rh_aau,</cfif>
				<cfif isDefined("ARGUMENTS.rh_amount")>rh_amount,</cfif>
				<cfif isDefined("ARGUMENTS.rh_form")>rh_form,</cfif>
				<cfif isDefined("ARGUMENTS.rh_time")>rh_time,</cfif>
				<cfif isDefined("ARGUMENTS.rh_ibu")>rh_ibu,</cfif>
				<cfif isDefined("ARGUMENTS.rh_grown")>rh_grown,</cfif>
				<cfif isDefined("ARGUMENTS.rh_when")>rh_when,</cfif>
				rh_reid, rh_usid
			) VALUES (
				<cfif isDefined("ARGUMENTS.rh_hop")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rh_hop,25)#" maxlength="25" />,</cfif>
				<cfif isDefined("ARGUMENTS.rh_aau")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rh_aau#" />,</cfif>
				<cfif isDefined("ARGUMENTS.rh_amount")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rh_amount#" />,</cfif>
				<cfif isDefined("ARGUMENTS.rh_form")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rh_form,6)#" maxlength="6" />,</cfif>
				<cfif isDefined("ARGUMENTS.rh_time")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="0#TRIM(ARGUMENTS.rh_time)#" />,</cfif>
				<cfif isDefined("ARGUMENTS.rh_ibu")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rh_ibu#" />,</cfif>
				<cfif isDefined("ARGUMENTS.rh_grown")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rh_grown,15)#" maxlength="15" />,</cfif>
				<cfif isDefined("ARGUMENTS.rh_when")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rh_when,4)#" maxlength="4" />,</cfif>
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rh_reid#" />,
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rh_usid#" />
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="UpdateRecipeHops" access="public" returnType="numeric" output="false">
		<cfargument name="rh_rhid" type="numeric" required="true" />
		<cfargument name="rh_reid" type="numeric" required="true" />
		<cfargument name="rh_usid" type="numeric" required="true" />
		<cfargument name="rh_hop" type="string" required="false" />
		<cfargument name="rh_aau" type="numeric" required="false" />
		<cfargument name="rh_amount" type="numeric" required="false" />
		<cfargument name="rh_form" type="string" required="false" />
		<cfargument name="rh_time" type="string" required="false" />
		<cfargument name="rh_ibu" type="numeric" required="false" />
		<cfargument name="rh_grown" type="string" required="false" />
		<cfargument name="rh_when" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updRecipeHops" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE recipehops
				SET <cfif isDefined("ARGUMENTS.rh_hop")>rh_hop = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rh_hop,25)#" maxlength="25" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rh_aau")>rh_aau = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rh_aau#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rh_amount")>rh_amount = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rh_amount#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rh_form")>rh_form = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rh_form,6)#" maxlength="6" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rh_time")>rh_time = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="0#TRIM(ARGUMENTS.rh_time)#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rh_ibu")>rh_ibu = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rh_ibu#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rh_grown")>rh_grown = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rh_grown,15)#" maxlength="15" />,</cfif>
					 rh_when = <cfif isDefined("ARGUMENTS.rh_when")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rh_when,4)#" maxlength="4" /><cfelse>rh_when</cfif>
			 WHERE rh_rhid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rh_rhid#" />
			<cfif isDefined("ARGUMENTS.rh_reid")>
				AND rh_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rh_reid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.rh_usid")>
				AND rh_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rh_usid#" />
			</cfif>
		</cfquery>
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="DeleteRecipeHops" access="public" returnType="numeric" output="false">
		<cfargument name="rh_reid" type="numeric" required="true" />
		<cfargument name="rh_usid" type="numeric" required="true" />
		<cfargument name="rh_rhid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delRecipeHops" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM recipehops
			 WHERE rh_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rh_reid#" />
				AND rh_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rh_usid#" />
			<cfif isDefined("ARGUMENTS.rh_rhid")>
				AND rh_rhid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rh_rhid#" />
			</cfif>
		</cfquery>
		<cfreturn LOCAL.delRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.rh_rhid = JavaCast("int", ARGUMENTS.rh_rhid) />
		<cfif IsDefined("ARGUMENTS.kill")>
			<cfset LOCAL.Response.method="Delete" />
		<cfelseif LOCAL.Response.rh_rhid neq 0>
			<cfset LOCAL.Response.method="Update" />
		<cfelse>
			<cfset LOCAL.Response.method="Insert" />
		</cfif>
		<cfinvoke method="#LOCAL.Response.method#RecipeHops" returnvariable="LOCAL.rtn">
			<cfloop collection="#ARGUMENTS#" item="LOCAL.key">
				<cfif ARGUMENTS[LOCAL.key] neq "null">
					<cfinvokeargument name="#LOCAL.key#" value="#ARGUMENTS[LOCAL.key]#" />
				</cfif>
			</cfloop>
		</cfinvoke>
		<cfif LOCAL.Response.method eq "Insert">
			<cfset LOCAL.Response.rh_rhid = JavaCast("int", LOCAL.rtn) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

</cfcomponent>