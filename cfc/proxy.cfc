<cfcomponent output="false">

	<cffunction name="NewAPIResponse" access="public" returntype="struct" output="false">
		<cfset LOCAL.IsLogged = isDefined("SESSION.LoggedIn") AND SESSION.LoggedIn />
		<cfset LOCAL.Response = {Success = true, LoggedIn = LOCAL.IsLogged, Errors = [], Data = "" } />
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="NewErrorResponse" access="public" returntype="struct" output="false">
		<cfargument name="Error" type="string" required="true" />
		<cfset var LOCAL = {} />
		<cfset LOCAL.Response = THIS.NewAPIResponse() />
		<cfset LOCAL.Response.Success = false />
		<cfset LOCAL.Response.Errors[ 1 ] = {
			Property = "",
			Error = ARGUMENTS.Error
			} />
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="call" access="remote" returnformat="JSON">
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.ARGS = deserializeJSON(ARGUMENTS.ARGS) />
		<cfset ARGUMENTS = LOCAL.ARGS />
		<cfset StructDelete(LOCAL, "ARGS") />
		<cfif not isDefined("ARGUMENTS.meth")>
			<cfreturn THIS.NewErrorResponse("Error 100: Missing Component.") />
		<cfelseif ListLen(ARGUMENTS.meth,".") neq 2>
			<cfreturn THIS.NewErrorResponse("Error 200: Missing Method.") />
		</cfif>
		<cfset LOCAL.comp = ListFirst(ARGUMENTS.meth, ".") />
		<cfset LOCAL.meth = ListLast(ARGUMENTS.meth, ".") />
		<!--- <cfif not FileExists(ExpandPath("#APPLICATION.PATH.CFC#/data/#LOCAL.comp#.cfc"))><cfreturn THIS.NewErrorResponse("Error 300: Unknown Component #LOCAL.comp#.") /></cfif> --->
		<cfset LOCAL.API = APPLICATION.CFC.Factory.get("#LOCAL.comp#") /> <!--- RETURNS FALSE IF COMPONENT NOT FOUND IN FACTORY --->
		<cfif IsSimpleValue(LOCAL.API)>
			<cfreturn THIS.NewErrorResponse("Error 300: Unknown Factory #LOCAL.comp#.") />
		</cfif>
		<cfset LOCAL.Functions = GetMetaData(LOCAL.API).Functions />
		<cfloop from=1 to="#ArrayLen(LOCAL.Functions)#" index="LOCAL.idx">
			<cfif LOCAL.Functions[LOCAL.idx].Name EQ LOCAL.meth>
				<cfset LOCAL.Response = THIS.NewAPIResponse() />
				<cftry>
					<cfinvoke component="#LOCAL.API#" method="#LOCAL.meth#" argumentcollection="#ARGUMENTS.DATA#" returnvariable="LOCAL.Response.Data"/>
					<cfcatch type="any">
						<cfset LOCAL.reqData = getHTTPRequestData()> <!--- EXPLICITLY TURN OFF DEBUGGING FOR ANY AJAX REQUESTS --->
						<cfif not StructKeyExists(LOCAL.reqData.headers,"x-requested-with")>
							<cfoutput>#udfDump(CFCATCH)#</cfoutput>
						</cfif>
						<cfif NOT APPLICATION.IsLocal>
							<cfset udfSaveError(CFCATCH) />
						</cfif>
						<cfreturn THIS.NewErrorResponse("Error 999: #CFCATCH.type#<br>#CFCATCH.message#") />
					</cfcatch>
				</cftry>
				<cfreturn LOCAL.Response />
			</cfif>
		</cfloop>
		<cfreturn THIS.NewErrorResponse("Error 400: Unknown Method #LOCAL.meth#.") />
	</cffunction>

	<cffunction name="OnMissingMethod" access="remote" returntype="any" output="false">
		<cfargument name="method" type="string" required="true" />
		<cfargument name="args" type="struct" required="true" />

		<cfset LOCAL = StructNew() />
		<cfset LOCAL.comp = ListFirst(ARGUMENTS.method) />
		<cfset LOCAL.meth = ListLast(ARGUMENTS.method) />
		<cfinvoke component="beer.#ARGUMENTS.comp#" method="#ARGUMENTS.meth#" argumentcollection="#ARGUMENTS.args#" returnvariable="LOCAL.rtn" />
		<!--- Return out. --->
		<cfif isNull(LOCAL.rtn)>
			<cfreturn />
		</cfif>
		<cfreturn LOCAL.rtn />

	</cffunction>

</cfcomponent>