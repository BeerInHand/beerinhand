<cfcomponent displayName="Permissio" hint="Handles all permissions issues.">

	<cfset VARIABLES.dsn = APPLICATION.DSN.FORUM />

	<cffunction name="init" access="public" returnType="permission" output="false">
		<cfreturn this>
	</cffunction>

	<cffunction name="allowed" access="public" output="false" returnType="boolean" hint="For a resource and right, see if any of the passed groups is allowed.">
		<cfargument name="right" type="uuid" required="true">
		<cfargument name="resource" type="uuid" required="true">
		<cfargument name="groups" type="string" required="true">
		
		<!--- get allowed --->
		<cfset var allowedgroups = getAllowed(ARGUMENTS.right, ARGUMENTS.resource)>
		<cfset var g = "">
		
		<cfif allowedgroups.recordCount is 0>
			<cfreturn true>
		</cfif>
		
		<cfloop index="g" list="#valueList(allowedgroups.group)#">
			<cfif listFind(ARGUMENTS.groups, g)>
				<cfreturn true>
			</cfif>
		</cfloop>
	
		<cfreturn false>
	</cffunction>
	
	<cffunction name="filter" access="public" output="false" returnType="query"
				hint="This is utility function. Given a query, a right, and your groups, it can remove what you don't have a right to.">
		<cfargument name="query" type="query" required="true">
		<cfargument name="groups" type="string" required="true">
		<cfargument name="right" type="uuid" required="true">
		<cfargument name="resourcecol" type="string" required="false" default="id" hint="What column in the query refers to the resource.">

		<cfset var resource = "">
		<cfset var allowedgroup = "">
		<cfset var toKill = "">
		<cfset var allowed = "">
		<cfset var result = "">
		<cfset var validgroups = "">
		
		<cfif not listFindNoCase(ARGUMENTS.query.columnlist, ARGUMENTS.resourcecol)>
			<cfthrow message="Invalid resourcecol (#ARGUMENTS.resourcecol#) - valid columns are #ARGUMENTS.query.columnlist#">
		</cfif>
		
		<!--- 
		So this is the idea. For each resource, we look in the permissions table.
		If there are NO rows, anyone can do it.
		if there ARE rows, and you aren't in the list, you are blocked.
		--->
		<cfloop query="ARGUMENTS.query">
			<cfset resource = ARGUMENTS.query[ARGUMENTS.resourcecol][currentrow]>
			<cfset validgroups = getAllowed(ARGUMENTS.right, resource)>
			<cfif validgroups.recordCount>
				<cfset allowed = false>
				<cfloop index="allowedgroup" list="#valueList(validgroups.group)#">
					<cfif listFind(ARGUMENTS.groups, allowedgroup)>
						<cfset allowed = true>
						<cfbreak>
					</cfif>		
				</cfloop>
				<cfif not allowed>
					<cfset toKill = listAppend(toKill, resource)>
				</cfif>	
			</cfif>		
		</cfloop>
		
		<cfif len(toKill)>
			<cfquery name="result" dbtype="query">
			select	*
			from	ARGUMENTS.query
			where	#ARGUMENTS.resourcecol# not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#toKill#">)
			</cfquery>
			
			<cfreturn result>
		<cfelse>
			<cfreturn ARGUMENTS.query>
		</cfif>
	</cffunction>

	<cffunction name="getAllowed" access="public" output="false" returnType="query" hint="Returns all groups that have a right to a resource.">
		<cfargument name="right" type="uuid" required="true">
		<cfargument name="resource" type="uuid" required="true">
		<cfset var q = "">
		
		<cfquery name="q" datasource="#VARIABLES.dsn#">
		select	groupidfk as `group`
		from	forum_permissions
		where	rightidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.right#" maxlength="35">
		and		resourceidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.resource#" maxlength="35">
		</cfquery>
		
		<cfreturn q>
	</cffunction>

	<cffunction name="setAllowed" access="public" output="false" returnType="void" hint="Sets all groups that have a right to a resource.">
		<cfargument name="right" type="uuid" required="true">
		<cfargument name="resource" type="uuid" required="true">
		<cfargument name="grouplist" type="string" required="true">
		<cfset var q = "">
		<cfset var g = "">
		
		<!--- first remove all --->
		<cfquery datasource="#VARIABLES.dsn#">
		delete from forum_permissions
		where	rightidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.right#" maxlength="35">
		and		resourceidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.resource#" maxlength="35">
		</cfquery>
		
		<!--- now add each one --->
		<cfloop index="g" list="#ARGUMENTS.grouplist#">

			<cfquery name="q" datasource="#VARIABLES.dsn#">
			insert into forum_permissions(id,rightidfk,resourceidfk,groupidfk)
			values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#createUUID()#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.right#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.resource#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#g#" maxlength="35">)
			</cfquery>

		</cfloop>
				
	</cffunction>
	
	<cffunction name="setSettings" access="public" output="No" returntype="void">
		<cfargument name="settings" required="true" hint="Setting">
		<cfset VARIABLES.dsn = APPLICATION.DSN.FORUM />
	</cffunction>
	
</cfcomponent>