<!---
	Name         : message.cfc
	Author       : Raymond Camden 
	Created      : January 25, 2005
	Last Updated : November 10, 2007
	History      : Reset for V2
				 : mod to get latest posts (rkc 11/10/07)
	Purpose		 : 
--->
<cfcomponent displayName="Conference" hint="Handles Conferences, the highest level container for Forums.">

	<cfset VARIABLES.dsn = "">
		
	<cffunction name="init" access="public" returnType="conference" output="false">
		<cfreturn this>
	</cffunction>

	<cffunction name="addConference" access="remote" returnType="uuid" roles="forumsadmin" output="false"
				hint="Adds a conference.">
				
		<cfargument name="conference" type="struct" required="true">
		<cfset var newconference = "">
		<cfset var newid = createUUID()>
		
		<cfif not validConference(ARGUMENTS.conference)>
			<cfset VARIABLES.utils.throw("ConferenceCFC","Invalid data passed to addConference.")>
		</cfif>
		
		<cfquery name="newconference" datasource="#VARIABLES.dsn#">
			insert into forum_conferences(id,name,description,active,messages)
			values(<cfqueryparam value="#newid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#ARGUMENTS.conference.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				   <cfqueryparam value="#ARGUMENTS.conference.description#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				   <cfqueryparam value="#ARGUMENTS.conference.active#" cfsqltype="CF_SQL_BIT">,
				   0
				   )
		</cfquery>
		
		<cfreturn newid>
		
	</cffunction>
	
	<cffunction name="deleteConference" access="public" returnType="void" roles="forumsadmin" output="false"
				hint="Deletes a conference along with all of it's children.">

		<cfargument name="id" type="uuid" required="true">
		<cfset var forumKids = "">
				
		<!--- first, delete my children --->
		<cfset forumKids = VARIABLES.forum.getForums(false,ARGUMENTS.id)>
		<cfloop query="forumKids">
			<cfset VARIABLES.forum.deleteForum(forumKids.id,false)>
		</cfloop>
		
		<cfquery datasource="#VARIABLES.dsn#">
			delete	from forum_conferences
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- clean up subscriptions --->
		<cfquery datasource="#VARIABLES.dsn#">
			delete	from forum_subscriptions
			where	conferenceidfk = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
	</cffunction>

	<cffunction name="getConference" access="remote" returnType="struct" output="false"
				hint="Returns a struct copy of the conferene.">
		<cfargument name="id" type="uuid" required="true">
		<cfset var qGetConference = "">
				
		<cfquery name="qGetConference" datasource="#VARIABLES.dsn#">
			select	id, name, description, active, messages, lastpost, lastpostuseridfk, lastpostcreated
			from	forum_conferences
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- Throw if invalid id passed --->
		<cfif not qGetConference.recordCount>
			<cfset VARIABLES.utils.throw("ConferenceCFC","Invalid ID")>
		</cfif>
		
		<!--- Only a ForumsAdmin can get bActiveOnly=false --->
		<cfif not qGetConference.active and not isUserInRole("forumsadmin")>
			<cfset VARIABLES.utils.throw("ConferenceCFC","Invalid call to getConference")>
		</cfif>
		
		<cfreturn VARIABLES.utils.queryToStruct(qGetConference)>
			
	</cffunction>
		
	<cffunction name="getConferences" access="remote" returnType="query" output="false"
				hint="Returns a list of conferences.">

		<cfargument name="bActiveOnly" type="boolean" required="false" default="true">
		
		<cfset var qGetConferences = "">
		
		<!--- Only a ForumsAdmin can be bActiveOnly=false --->
		<cfif not ARGUMENTS.bActiveOnly and not isUserInRole("forumsadmin")>
			<cfset VARIABLES.utils.throw("ConferenceCFC","Invalid call to getConferences")>
		</cfif>
		
		<cfquery name="qGetConferences" datasource="#VARIABLES.dsn#">
			select	id, name, description, active, messages, lastpost, lastpostuseridfk, lastpostcreated
			from	forum_conferences
			order by name
		</cfquery>
				
		<cfreturn qGetConferences>
			
	</cffunction>
	
	<cffunction name="getLatestPosts" access="remote" returnType="query" output="false"
				hint="Retrieve the last 20 posts to any threads in forums in this conference.">
		<cfargument name="conferenceid" type="uuid" required="true">
		<cfset var qLatestPosts = "">
		
		<cfquery name="qLatestPosts" datasource="#VARIABLES.dsn#">
			select		
						forum_messages.title, forum_threads.name as thread, 
						forum_messages.posted, forum_users.username, 
						forum_messages.threadidfk as threadid, 
						forum_messages.body,
						forum_threads.forumidfk,
						forum_forums.conferenceidfk
			from		forum_messages, forum_threads, forum_users, forum_forums
			where		forum_messages.threadidfk = forum_threads.id
			and			forum_messages.useridfk = forum_users.id
			and			forum_threads.forumidfk = forum_forums.id
			and			forum_forums.conferenceidfk = <cfqueryparam value="#ARGUMENTS.conferenceid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			order by	forum_messages.posted desc
				limit 20
		</cfquery>
		
		<cfreturn qLatestPosts>
	</cffunction>
	
	<cffunction name="saveConference" access="remote" returnType="void" roles="forumsadmin" output="false"
				hint="Saves an existing conference.">
				
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="conference" type="struct" required="true">
		
		<cfif not validConference(ARGUMENTS.conference)>
			<cfset VARIABLES.utils.throw("ConferenceCFC","Invalid data passed to saveConference.")>
		</cfif>
		
		<cfquery datasource="#VARIABLES.dsn#">
			update	forum_conferences
			set		name = <cfqueryparam value="#ARGUMENTS.conference.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					description = <cfqueryparam value="#ARGUMENTS.conference.description#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					active = <cfqueryparam value="#ARGUMENTS.conference.active#" cfsqltype="CF_SQL_BIT">
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
	</cffunction>
	
	<cffunction name="search" access="remote" returnType="query" output="false"
				hint="Allows you to search conferences.">
		<cfargument name="searchterms" type="string" required="true">
		<cfargument name="searchtype" type="string" required="false" default="phrase" hint="Must be: phrase,any,all">
		
		<cfset var results  = "">
		<cfset var x = "">
		<cfset var joiner = "">	
		<cfset var aTerms = "">

		<cfset ARGUMENTS.searchTerms = VARIABLES.utils.searchSafe(ARGUMENTS.searchTerms)>

				
		<!--- massage search terms into an array --->		
		<cfset aTerms = listToArray(ARGUMENTS.searchTerms," ")>
		
		
		<!--- confirm searchtype is ok --->
		<cfif not listFindNoCase("phrase,any,all", ARGUMENTS.searchtype)>
			<cfset ARGUMENTS.searchtype = "phrase">
		<cfelseif ARGUMENTS.searchtype is "any">
			<cfset joiner = "OR">
		<cfelseif ARGUMENTS.searchtype is "all">
			<cfset joiner = "AND">
		</cfif>
		
		<cfquery name="results" datasource="#VARIABLES.dsn#">
			select	id, name, description
			from	forum_conferences
			where	active = 1
			and (
				<cfif ARGUMENTS.searchtype is not "phrase">
					<cfloop index="x" from=1 to="#arrayLen(aTerms)#">
						(name like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(aTerms[x],255)#%"> 
						 or
						 description like '%#aTerms[x]#%')
						 <cfif x is not arrayLen(aTerms)>#joiner#</cfif>
					</cfloop>
				<cfelse>
					name like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(ARGUMENTS.searchTerms,255)#%">
					or
					description like '%#ARGUMENTS.searchTerms#%'
				</cfif>
			)
		</cfquery>
		
		<cfreturn results>
	</cffunction>
	
	<cffunction name="updateLastMessage" access="public" returnType="void" output="false" hint="Updates last message stats">
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="threadid" type="uuid" required="true">
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="posted" type="date" required="true">
			
		<cfquery datasource="#VARIABLES.dsn#">
		update	forum_conferences
		set		lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.threadid#">,
				lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.userid#">,
				lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.posted#">,
				messages = messages + 1
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.id#">
		</cfquery>
		
	</cffunction>

	<cffunction name="updateStats" access="public" returnType="void" output="false" hint="Reset stats for conferences">
		<cfargument name="id" type="uuid" required="true">
		<cfset var forumKids = "">
		<cfset var total = 0>
		<cfset var last = createDate(1900,1,1)>
		<cfset var lastu = "">
		<cfset var lasti = "">
		<cfset var haveSome = false>
		
		<!---
		Rather simple. Get my kids. Count total msgs, and pick latest date 
		--->

		<cfset forumKids = VARIABLES.forum.getForums(true,ARGUMENTS.id)>
		<cfset haveSome = forumKids.recordCount gte 1>
		
		<cfloop query="forumKids">
			<cfset total = total + messages>
			<cfif isDate(lastPostCreated) and dateCompare(last, lastPostCreated) is -1>
				<cfset last = lastpostcreated>
				<cfset lastu = lastpostuseridfk>
				<cfset lasti = lastpost>
			</cfif>
		</cfloop>
		<cflog file="galleon" text="havesome=#havesome#, last=#last#, lastu=#lastu#, lasti=#lasti#">
		<!--- now update this conf --->
		<cfif haveSome and lastu neq "">
			<!---
			As a user reported, it is possible the last X for a forum is null. This
			can happen if you kill the last thread in a forum.
			So haveSome is kinda meh now.
			--->
			<cfquery datasource="#VARIABLES.dsn#">
			update	forum_conferences
			set		lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#lasti#">,
					lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#lastu#">,
					lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last#">,
					messages = <cfqueryparam cfsqltype="cf_sql_numeric" value="#total#">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.id#">
			</cfquery>
		<cfelse>
			<cfquery datasource="#VARIABLES.dsn#">
			update	forum_conferences
			set		lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" null="true">,
					lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" null="true">,
					lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" null="true">,
					messages = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.id#">
			</cfquery>
		</cfif>
	</cffunction>
		
	<cffunction name="validConference" access="private" returnType="boolean" output="false"
				hint="Checks a structure to see if it contains all the proper keys/values for a conference.">
		
		<cfargument name="cData" type="struct" required="true">
		<cfset var rList = "name,description,active">
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
		<cfset VARIABLES.dsn = APPLICATION.DSN.FORUM>
	</cffunction>
	
	<cffunction name="setUtils" access="public" output="No" returntype="void">
		<cfargument name="utils" required="true" hint="utils">
		<cfset VARIABLES.utils = ARGUMENTS.utils />
	</cffunction>

	<cffunction name="setForum" access="public" output="No" returntype="void">
		<cfargument name="forum" required="true" hint="forum">
		<cfset VARIABLES.forum = ARGUMENTS.forum />
	</cffunction>
	
</cfcomponent>