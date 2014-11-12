<cfcomponent output="false" >

	<cfset init() />

	<cffunction name="init" returntype="recipeyeast" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryRecipeYeast" access="public" returnType="query" output="false">
		<cfargument name="ry_ryid" type="numeric" required="false" />
		<cfargument name="ry_reid" type="numeric" required="false" />
		<cfargument name="ry_usid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryRecipeYeast" datasource="#THIS.dsn#">
			SELECT ry_ryid, ry_reid, ry_usid, ry_yeast, ry_mfg, ry_mfgno, ry_date, ry_note
			  FROM recipeyeast
			 WHERE 0=0
			<cfif isDefined("ARGUMENTS.ry_ryid")>
				AND ry_ryid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ry_ryid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.ry_reid")>
				AND ry_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ry_reid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.ry_usid")>
				AND ry_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ry_usid#" />
			</cfif>
			 ORDER BY ry_date
		</cfquery>
		<cfreturn LOCAL.qryRecipeYeast />
	</cffunction>

	<cffunction name="InsertRecipeYeast" access="public" returnType="numeric" output="false">
		<cfargument name="ry_reid" type="numeric" required="true" />
		<cfargument name="ry_usid" type="numeric" required="true" />
		<cfargument name="ry_yeast" type="string" required="false" />
		<cfargument name="ry_mfg" type="string" required="false" />
		<cfargument name="ry_mfgno" type="string" required="false" />
		<cfargument name="ry_date" type="string" required="false" />
		<cfargument name="ry_note" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insRecipeYeast" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO recipeyeast (
				<cfif isDefined("ARGUMENTS.ry_yeast")>ry_yeast,</cfif>
				<cfif isDefined("ARGUMENTS.ry_mfg")>ry_mfg,</cfif>
				<cfif isDefined("ARGUMENTS.ry_mfgno")>ry_mfgno,</cfif>
				<cfif isDefined("ARGUMENTS.ry_date")>ry_date,</cfif>
				<cfif isDefined("ARGUMENTS.ry_note")>ry_note,</cfif>
				ry_reid, ry_usid
			) VALUES (
				<cfif isDefined("ARGUMENTS.ry_yeast")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.ry_yeast,60)#" maxlength="60" />,</cfif>
				<cfif isDefined("ARGUMENTS.ry_mfg")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.ry_mfg,20)#" maxlength="20" />,</cfif>
				<cfif isDefined("ARGUMENTS.ry_mfgno")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.ry_mfgno,10)#" maxlength="10" />,</cfif>
				<cfif isDefined("ARGUMENTS.ry_date")><cfqueryparam cfsqltype="CF_SQL_DATE" value="#ARGUMENTS.ry_date#" null="#not IsDate(ARGUMENTS.ry_date)#" />,</cfif>
				<cfif isDefined("ARGUMENTS.ry_note")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.ry_note,2000)#" maxlength="2000" />,</cfif>
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ry_reid#" />,
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ry_usid#" />
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="UpdateRecipeYeast" access="public" returnType="numeric" output="false">
		<cfargument name="ry_ryid" type="numeric" required="true" />
		<cfargument name="ry_reid" type="numeric" required="true" />
		<cfargument name="ry_usid" type="numeric" required="true" />
		<cfargument name="ry_yeast" type="string" required="false" />
		<cfargument name="ry_mfg" type="string" required="false" />
		<cfargument name="ry_mfgno" type="string" required="false" />
		<cfargument name="ry_note" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updRecipeYeast" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE recipeyeast
				SET <cfif isDefined("ARGUMENTS.ry_yeast")>ry_yeast = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.ry_yeast,25)#" maxlength="25" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ry_mfg")>ry_mfg = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.ry_mfg,20)#" maxlength="20" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ry_mfgno")>ry_mfgno = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.ry_mfgno,10)#" maxlength="10" />,</cfif>
					 <cfif isDefined("ARGUMENTS.ry_date")>ry_date = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#ARGUMENTS.ry_date#" null="#not IsDate(ARGUMENTS.ry_date)#" />,</cfif>
					 ry_note = <cfif isDefined("ARGUMENTS.ry_note")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.ry_note,2000)#" maxlength="2000" /><cfelse>ry_note</cfif>
			 WHERE ry_ryid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ry_ryid#" />
				AND ry_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ry_reid#" />
				AND ry_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ry_usid#" />
		</cfquery>
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="DeleteRecipeYeast" access="public" returnType="numeric" output="false">
		<cfargument name="ry_reid" type="numeric" required="true" />
		<cfargument name="ry_usid" type="numeric" required="true" />
		<cfargument name="ry_ryid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delRecipeYeast" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM recipeyeast
			 WHERE ry_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ry_reid#" />
				AND ry_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ry_usid#" />
			<cfif isDefined("ARGUMENTS.ry_ryid")>
				AND ry_ryid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ry_ryid#" />
			</cfif>
		</cfquery>
		<cfreturn LOCAL.delRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.ry_ryid = JavaCast("int", ARGUMENTS.ry_ryid) />
		<cfif IsDefined("ARGUMENTS.kill")>
			<cfset LOCAL.Response.method="Delete" />
		<cfelseif LOCAL.Response.ry_ryid neq 0>
			<cfset LOCAL.Response.method="Update" />
		<cfelse>
			<cfset LOCAL.Response.method="Insert" />
		</cfif>
		<cfinvoke method="#LOCAL.Response.method#RecipeYeast" returnvariable="LOCAL.rtn">
			<cfloop collection="#ARGUMENTS#" item="LOCAL.key">
				<cfif ARGUMENTS[LOCAL.key] neq "null">
					<cfinvokeargument name="#LOCAL.key#" value="#ARGUMENTS[LOCAL.key]#" />
				</cfif>
			</cfloop>
		</cfinvoke>
		<cfif LOCAL.Response.method eq "Insert">
			<cfset LOCAL.Response.ry_ryid = JavaCast("int", LOCAL.rtn) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

</cfcomponent>
