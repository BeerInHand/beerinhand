<!---
	Name         : rank.cfc
	Author       : Raymond Camden 
	Created      : August 28, 2005
	Last Updated : 
	History      : 
	Purpose		 : 
--->
<cfcomponent displayName="Rank" hint="Handles Ranks. It's not stinky.">

	<cfset VARIABLES.dsn = "">

	<cffunction name="init" access="public" returnType="rank" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfreturn this>
		
	</cffunction>

	<cffunction name="addRank" access="remote" returnType="uuid" roles="forumsadmin" output="false"
				hint="Adds a rank.">
				
		<cfargument name="rank" type="struct" required="true">
		<cfset var newid = createUUID()>
		
		<cfif not validRank(ARGUMENTS.rank)>
			<cfset VARIABLES.utils.throw("RankCFC","Invalid data passed to addRank.")>
		</cfif>
		
		<cfquery datasource="#VARIABLES.dsn#">
			insert into forum_ranks(id,name,minposts)
			values(<cfqueryparam value="#newid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#ARGUMENTS.rank.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">,
				   <cfqueryparam value="#ARGUMENTS.rank.minposts#" cfsqltype="CF_SQL_INTEGER">)
		</cfquery>
		
		<cfreturn newid>
		
	</cffunction>
	
	<cffunction name="deleteRank" access="public" returnType="void" roles="forumsadmin" output="false"
				hint="Deletes a rank.">

		<cfargument name="id" type="uuid" required="true">
						
		<cfquery datasource="#VARIABLES.dsn#">
			delete	from forum_ranks
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
	</cffunction>

	<cffunction name="getHighestRank" access="public" returnType="string" output="false"
				hint="For a 'minpost' value, returns the highest rank">
		<cfargument name="minposts" type="numeric" required="true">
		<cfset var qGetRank = "">
		
		<cfquery name="qGetRank" datasource="#VARIABLES.dsn#">
            select	
		name
		from	forum_ranks
		where	minposts <= <cfqueryparam value="#ARGUMENTS.minposts#" cfsqltype="cf_sql_numeric">
		order by minposts desc
                    limit 1
		</cfquery>
		
		<cfreturn qGetRank.name>
		
	</cffunction>
	
	<cffunction name="getRank" access="remote" returnType="struct" output="false"
				hint="Returns a struct copy of the rank.">
		<cfargument name="id" type="uuid" required="true">
		<cfset var qGetRank = "">
				
		<cfquery name="qGetRank" datasource="#VARIABLES.dsn#">
			select	id, name, minposts
			from	forum_ranks
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- Throw if invalid id passed --->
		<cfif not qGetRank.recordCount>
			<cfset VARIABLES.utils.throw("RankCFC","Invalid ID")>
		</cfif>
		
		<cfreturn VARIABLES.utils.queryToStruct(qGetRank)>
			
	</cffunction>
		
	<cffunction name="getRanks" access="remote" returnType="query" output="false"
				hint="Returns a list of ranks.">
		<cfset var qGetRanks = "">
				
		<cfquery name="qGetRanks" datasource="#VARIABLES.dsn#">
			select	id, name, minposts
			from	forum_ranks
		</cfquery>
		
		<cfreturn qGetRanks>
			
	</cffunction>
	
	<cffunction name="saveRank" access="remote" returnType="void" roles="forumsadmin" output="false"
				hint="Saves an existing rank.">
				
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="rank" type="struct" required="true">
		
		<cfif not validRank(ARGUMENTS.rank)>
			<cfset VARIABLES.utils.throw("RankCFC","Invalid data passed to saveRank.")>
		</cfif>
		
		<cfquery datasource="#VARIABLES.dsn#">
			update	forum_ranks
			set		name = <cfqueryparam value="#ARGUMENTS.rank.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">,
					minposts = <cfqueryparam value="#ARGUMENTS.rank.minposts#" cfsqltype="CF_SQL_INTEGER">
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
	</cffunction>
		
	<cffunction name="validRank" access="private" returnType="boolean" output="false"
				hint="Checks a structure to see if it contains all the proper keys/values for a rank.">
		
		<cfargument name="cData" type="struct" required="true">
		<cfset var rList = "name,minposts">
		<cfset var x = "">
		
		<cfloop index="x" list="#rList#">
			<cfif not structKeyExists(cData,x)>
				<cfreturn false>
			</cfif>
		</cfloop>
		
		<cfreturn true>
		
	</cffunction>

	<cffunction name="setSettings" access="public" output="No" returntype="void">
		<cfargument name="settings" required="true" hint="Setting">
		<cfset VARIABLES.dsn = APPLICATION.DSN.FORUM />
	</cffunction>

	<cffunction name="setUtils" access="public" output="No" returntype="void">
		<cfargument name="utils" required="true" hint="utils">
		<cfset VARIABLES.utils = ARGUMENTS.utils />
	</cffunction>
</cfcomponent>