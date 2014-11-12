<cfcomponent output="false" >

	<cfset init() />

	<cffunction name="init" returntype="recipegrains" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryRecipeGrains" access="public" returnType="query" output="false">
		<cfargument name="rg_rgid" type="numeric" required="false" />
		<cfargument name="rg_reid" type="numeric" required="false" />
		<cfargument name="rg_usid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryRecipeGrains" datasource="#THIS.dsn#">
			SELECT rg_rgid, rg_reid, rg_usid, rg_type, rg_amount, rg_sgc, rg_lvb, rg_mash, rg_maltster, rg_pct
			  FROM recipegrains
			 WHERE 0=0
			<cfif isDefined("ARGUMENTS.rg_rgid")>
				AND rg_rgid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rg_rgid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.rg_reid")>
				AND rg_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rg_reid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.rg_usid")>
				AND rg_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rg_usid#" />
			</cfif>
			 ORDER BY (rg_sgc * rg_amount) DESC
		</cfquery>
		<cfreturn LOCAL.qryRecipeGrains />
	</cffunction>

	<cffunction name="InsertRecipeGrains" access="public" returnType="numeric" output="false">
		<cfargument name="rg_reid" type="numeric" required="true" />
		<cfargument name="rg_usid" type="numeric" required="true" />
		<cfargument name="rg_type" type="string" required="true" />
		<cfargument name="rg_amount" type="numeric" required="false" />
		<cfargument name="rg_sgc" type="numeric" required="false" />
		<cfargument name="rg_lvb" type="numeric" required="false" />
		<cfargument name="rg_mash" type="numeric" required="false" />
		<cfargument name="rg_maltster" type="string" required="false" />
		<cfargument name="rg_pct" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insRecipeGrains" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO recipegrains (
				<cfif isDefined("ARGUMENTS.rg_amount")>rg_amount,</cfif>
				<cfif isDefined("ARGUMENTS.rg_sgc")>rg_sgc,</cfif>
				<cfif isDefined("ARGUMENTS.rg_lvb")>rg_lvb,</cfif>
				<cfif isDefined("ARGUMENTS.rg_mash")>rg_mash,</cfif>
				<cfif isDefined("ARGUMENTS.rg_maltster")>rg_maltster,</cfif>
				<cfif isDefined("ARGUMENTS.rg_pct")>rg_pct,</cfif>
				rg_reid, rg_usid,rg_type
			) VALUES (
				<cfif isDefined("ARGUMENTS.rg_amount")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rg_amount#" />,</cfif>
				<cfif isDefined("ARGUMENTS.rg_sgc")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rg_sgc#" />,</cfif>
				<cfif isDefined("ARGUMENTS.rg_lvb")><cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rg_lvb#" />,</cfif>
				<cfif isDefined("ARGUMENTS.rg_mash")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.rg_mash#" />,</cfif>
				<cfif isDefined("ARGUMENTS.rg_maltster")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rg_maltster,25)#" maxlength="25" />,</cfif>
				<cfif isDefined("ARGUMENTS.rg_pct")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rg_pct#" />,</cfif>
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rg_reid#" />,
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rg_usid#" />,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rg_type,25)#" maxlength="25" />
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="UpdateRecipeGrains" access="public" returnType="numeric" output="false">
		<cfargument name="rg_rgid" type="numeric" required="true" />
		<cfargument name="rg_reid" type="numeric" required="true" />
		<cfargument name="rg_usid" type="numeric" required="true" />
		<cfargument name="rg_type" type="string" required="true" />
		<cfargument name="rg_amount" type="numeric" required="false" />
		<cfargument name="rg_sgc" type="numeric" required="false" />
		<cfargument name="rg_lvb" type="numeric" required="false" />
		<cfargument name="rg_mash" type="numeric" required="false" />
		<cfargument name="rg_maltster" type="string" required="false" />
		<cfargument name="rg_pct" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updRecipeGrains" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE recipegrains
				SET <cfif isDefined("ARGUMENTS.rg_type")>rg_type = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rg_type,25)#" maxlength="25" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rg_amount")>rg_amount = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rg_amount#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rg_sgc")>rg_sgc = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rg_sgc#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rg_lvb")>rg_lvb = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rg_lvb#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rg_mash")>rg_mash = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.rg_mash#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.rg_maltster")>rg_maltster = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.rg_maltster,25)#" maxlength="25" />,</cfif>
					 rg_pct = <cfif isDefined("ARGUMENTS.rg_pct")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.rg_pct#" /><cfelse>rg_pct</cfif>
			 WHERE rg_rgid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rg_rgid#" />
				AND rg_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rg_reid#" />
				AND rg_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rg_usid#" />
		</cfquery>
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="DeleteRecipeGrains" access="public" returnType="numeric" output="false">
		<cfargument name="rg_reid" type="numeric" required="true" />
		<cfargument name="rg_usid" type="numeric" required="true" />
		<cfargument name="rg_rgid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delRecipeGrains" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM recipegrains
			 WHERE rg_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rg_reid#" />
				AND rg_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rg_usid#" />
			<cfif isDefined("ARGUMENTS.rg_rgid")>
				AND rg_rgid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.rg_rgid#" />
			</cfif>
		</cfquery>
		<cfreturn LOCAL.delRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.rg_rgid = JavaCast("int", ARGUMENTS.rg_rgid) />
		<cfif IsDefined("ARGUMENTS.kill")>
			<cfset LOCAL.Response.method="Delete" />
		<cfelseif LOCAL.Response.rg_rgid neq 0>
			<cfset LOCAL.Response.method="Update" />
		<cfelse>
			<cfset LOCAL.Response.method="Insert" />
		</cfif>
		<cfinvoke method="#LOCAL.Response.method#RecipeGrains" returnvariable="LOCAL.rtn">
			<cfloop collection="#ARGUMENTS#" item="LOCAL.key">
				<cfif ARGUMENTS[LOCAL.key] neq "null">
					<cfinvokeargument name="#LOCAL.key#" value="#ARGUMENTS[LOCAL.key]#" />
				</cfif>
			</cfloop>
		</cfinvoke>
		<cfif LOCAL.Response.method eq "Insert">
			<cfset LOCAL.Response.rg_rgid = JavaCast("int", LOCAL.rtn) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

</cfcomponent>