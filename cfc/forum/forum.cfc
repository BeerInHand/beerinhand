<!---
	Name         : forum.cfc
	Author       : Raymond Camden 
	Created      : January 26, 2005
	Last Updated : November 19, 2007
	History      : Reset for V2
				 : access fix (rkc 11/19/07)
	Purpose		 : 
--->
<cfcomponent displayName="Forum" hint="Handles Forums which contain a collection of threads.">

	<cfset VARIABLES.dsn = "">
		
	<cffunction name="init" access="public" returnType="forum" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfreturn this>
		
	</cffunction>

	<cffunction name="addForum" access="remote" returnType="uuid" roles="forumsadmin" output="false"
				hint="Adds a forum.">				
		<cfargument name="forum" type="struct" required="true">
		<cfset var newforum = "">
		<cfset var newid = createUUID()>
		
		<cfif not validForum(ARGUMENTS.forum)>
			<cfset VARIABLES.utils.throw("ForumCFC","Invalid data passed to addForum.")>
		</cfif>
		
		<cfquery name="newforum" datasource="#VARIABLES.dsn#">
			insert into forum_forums(id,name,description,active,conferenceidfk,attachments,messages, rank)
			values(<cfqueryparam value="#newid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#ARGUMENTS.forum.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				   <cfqueryparam value="#ARGUMENTS.forum.description#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				   <cfqueryparam value="#ARGUMENTS.forum.active#" cfsqltype="CF_SQL_BIT">,
				   <cfqueryparam value="#ARGUMENTS.forum.conferenceidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#ARGUMENTS.forum.attachments#" cfsqltype="CF_SQL_BIT">,
				   0,
				   <cfqueryparam value="#ARGUMENTS.forum.rank#" null="#not isNumeric(ARGUMENTS.forum.rank)#">
				   )
		</cfquery>
		
		<cfreturn newid>
				
	</cffunction>
	
	<cffunction name="deleteForum" access="public" returnType="void" roles="forumsadmin" output="false"
				hint="Deletes a forum along with all of it's children.">
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="runupdate" type="boolean" required="false" default="true">
		
		<cfset var threadKids = "">
		<cfset var f = getForum(ARGUMENTS.id)>
		
		<!--- first, delete my children --->
		<cfset threadKids = VARIABLES.thread.getThreads(false,ARGUMENTS.id)>
		<cfloop query="threadKids.data">
			<cfset VARIABLES.thread.deleteThread(threadKids.data.id[currentRow],false)>
		</cfloop>

		<cfquery datasource="#VARIABLES.dsn#">
			delete	from forum_forums
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- clean up subscriptions --->
		<cfquery datasource="#VARIABLES.dsn#">
			delete	from forum_subscriptions
			where	forumidfk = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
		<!--- update stats for my parent --->
		<cfif ARGUMENTS.runupdate>
			<cfset VARIABLES.conference.updateStats(f.conferenceidfk)>
		</cfif>
		
	</cffunction>
	
	<cffunction name="getForum" access="remote" returnType="struct" output="false"
				hint="Returns a struct copy of the forum.">
		<cfargument name="id" type="uuid" required="true">
		<cfset var qGetForum = "">
				
		<cfquery name="qGetForum" datasource="#VARIABLES.dsn#">
			select	id, name, description, active, conferenceidfk, attachments, messages, lastpost, lastpostuseridfk, lastpostcreated, rank
			from	forum_forums
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- Throw if invalid id passed --->
		<cfif not qGetForum.recordCount>
			<cfset VARIABLES.utils.throw("ForumCFC","Invalid ID")>
		</cfif>
		
		<!--- Only a ForumsAdmin can get bActiveOnly=false --->
		<cfif not qGetForum.active and not isUserInRole("forumsadmin")>
			<cfset VARIABLES.utils.throw("ForumCFC","Invalid call to getForum")>
		</cfif>
		
		<cfreturn VARIABLES.utils.queryToStruct(qGetForum)>
			
	</cffunction>
		
	<cffunction name="getForums" access="remote" returnType="query" output="false"
				hint="Returns a list of forums.">

		<cfargument name="bActiveOnly" type="boolean" required="false" default="true">
		<cfargument name="conferenceid" type="uuid" required="false">
		
		<cfset var qGetForums = "">
		<cfset var getLastUser = "">
		
		<!--- Only a ForumsAdmin can be bActiveOnly=false --->
		<cfif not ARGUMENTS.bActiveOnly and not isUserInRole("forumsadmin")>
			<cfset VARIABLES.utils.throw("ForumCFC","Invalid call to getForums")>
		</cfif>
		
		<cfquery name="qGetForums" datasource="#VARIABLES.dsn#">
			select	f.id, f.name, f.description, f.active, f.attachments, f.conferenceidfk, f.lastpostcreated, 
					f.messages, f.lastpost, f.lastpostuseridfk, c.name as conference, f.rank
			from	forum_forums f, forum_conferences c
			where	f.conferenceidfk = c.id
			<cfif structKeyExists(arguments, "bactiveonly") and ARGUMENTS.bactiveonly>
			and		f.active <> 0
			</cfif>
			<cfif structKeyExists(arguments, "conferenceid")>
			and		f.conferenceidfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.conferenceid#">
			</cfif>
			order by f.rank, f.name
		</cfquery>

		
		<cfreturn qGetForums>
			
	</cffunction>
	
	<cffunction name="saveForum" access="remote" returnType="void" roles="forumsadmin" output="false"
				hint="Saves an existing forum.">
				
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="forum" type="struct" required="true">
		
		<cfif not validForum(ARGUMENTS.forum)>
			<cfset VARIABLES.utils.throw("ForumCFC","Invalid data passed to saveForum.")>
		</cfif>
		
		<cfquery datasource="#VARIABLES.dsn#">
			update	forum_forums
			set		name = <cfqueryparam value="#ARGUMENTS.forum.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					description = <cfqueryparam value="#ARGUMENTS.forum.description#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					active = <cfqueryparam value="#ARGUMENTS.forum.active#" cfsqltype="CF_SQL_BIT">,
					attachments = <cfqueryparam value="#ARGUMENTS.forum.attachments#" cfsqltype="CF_SQL_BIT">,
					conferenceidfk = <cfqueryparam value="#ARGUMENTS.forum.conferenceidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
					rank =	<cfqueryparam value="#ARGUMENTS.forum.rank#" null="#not isNumeric(ARGUMENTS.forum.rank)#">
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
	</cffunction>

	<cffunction name="search" access="remote" returnType="query" output="false"
				hint="Allows you to search forums.">
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
		
		<cfquery name="results" datasource="#VARIABLES.dsn#" maxrows="100">
			select	f.id, f.name, f.description, f.conferenceidfk, c.name as conference
			from	forum_forums f, forum_conferences c
			where	f.active = 1
			and		f.conferenceidfk = c.id
			and (
				<cfif ARGUMENTS.searchtype is not "phrase">
					<cfloop index="x" from=1 to="#arrayLen(aTerms)#">
						(f.name like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(aTerms[x],255)#%"> 
						 or
						 f.description like '%#aTerms[x]#%')
						 <cfif x is not arrayLen(aTerms)>#joiner#</cfif>
					</cfloop>
				<cfelse>
					f.name like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(ARGUMENTS.searchTerms,255)#%">
					or
					f.description like '%#ARGUMENTS.searchTerms#%'
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
		update	forum_forums
		set		lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.threadid#">,
				lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.userid#">,
				lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.posted#">,
				messages = messages + 1
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.id#">
		</cfquery>
		
	</cffunction>

	<cffunction name="updateStats" access="public" returnType="void" output="false" hint="Reset stats for forums">
		<cfargument name="id" type="uuid" required="true">
		<cfset var me = getForum(ARGUMENTS.id)>
		<cfset var threadKids = "">
		<cfset var total = 0>
		<cfset var last = createDate(1900,1,1)>
		<cfset var lastu = "">
		<cfset var lasti = "">
		<cfset var haveSome = false>
		
		<!---
		Rather simple. Get my kids. Count total msgs, and pick latest date 
		--->

		<cfset threadKids = VARIABLES.thread.getThreads(true,ARGUMENTS.id)>
		<cfset haveSome = threadKids.total gte 1>

		<cfloop query="threadKids.data">
			<cfset total = total + messages>
			<cfif isDate(lastPostCreated) and dateCompare(last, lastPostCreated) is -1>
				<cfset last = lastpostcreated>
				<cfset lastu = lastpostuseridfk>
				<cfset lasti = threadKids.data.id[currentRow]>
			</cfif>
		</cfloop>

		<!--- now update this conf --->
		<cfif haveSome>
			<cfquery datasource="#VARIABLES.dsn#">
			update	forum_forums
			set		lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#lasti#">,
					lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#lastu#">,
					lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last#">,
					messages = <cfqueryparam cfsqltype="cf_sql_numeric" value="#total#">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.id#">
			</cfquery>
		<cfelse>
			<cfquery datasource="#VARIABLES.dsn#">
			update	forum_forums
			set		lastpost = <cfqueryparam cfsqltype="cf_sql_varchar" null="true">,
					lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" null="true">,
					lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" null="true">,
					messages = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.id#">
			</cfquery>
		</cfif>
		
		<!--- now update my parent --->
		<cfset VARIABLES.conference.updateStats(me.conferenceidfk)>
		
	</cffunction>
	
	<cffunction name="validForum" access="private" returnType="boolean" output="false"
				hint="Checks a structure to see if it contains all the proper keys/values for a forum.">
		
		<cfargument name="cData" type="struct" required="true">
		<cfset var rList = "name,description,active,conferenceidfk">
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

	<cffunction name="setThread" access="public" output="No" returntype="void">
		<cfargument name="thread" required="true" hint="thread">
		<cfset VARIABLES.thread = ARGUMENTS.thread />
	</cffunction>

	<cffunction name="setConference" access="public" output="No" returntype="void">
		<cfargument name="conference" required="true" hint="conference">
		<cfset VARIABLES.conference = ARGUMENTS.conference />
	</cffunction>
	
</cfcomponent>