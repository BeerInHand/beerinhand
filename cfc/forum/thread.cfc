<!---
	Name         : thread.cfc
	Author       : Raymond Camden
	Created      : January 26, 2005
	Last Updated : November 19, 2007
	History      : Reset for V2
				 : Access fix (rkc 11/19/07)
	Purpose		 :
--->
<cfcomponent displayName="Thread" hint="Handles Threads which contain a collection of message.">

	<cfset VARIABLES.dsn = "">
	<cfset VARIABLES.settings = "">


	<cffunction name="init" access="public" returnType="thread" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfreturn this>

	</cffunction>

	<cffunction name="addThread" access="remote" returnType="uuid" output="false"
				hint="Adds a thread.">

		<cfargument name="thread" type="struct" required="true">
		<cfset var newthread = "">
		<cfset var newid = createUUID()>

		<cfif not validThread(ARGUMENTS.thread)>
			<cfset VARIABLES.utils.throw("ThreadCFC","Invalid data passed to addThread.")>
		</cfif>

		<cfquery name="newthread" datasource="#VARIABLES.dsn#">
			insert into forum_threads(id,name,active,forumidfk,useridfk,datecreated,sticky,messages)
			values(<cfqueryparam value="#newid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#ARGUMENTS.thread.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				   <cfqueryparam value="#ARGUMENTS.thread.active#" cfsqltype="CF_SQL_BIT">,
				   <cfqueryparam value="#ARGUMENTS.thread.forumidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
   				   <cfqueryparam value="#ARGUMENTS.thread.useridfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#ARGUMENTS.thread.datecreated#" cfsqltype="CF_SQL_TIMESTAMP">,
   				   <cfqueryparam value="#ARGUMENTS.thread.sticky#" cfsqltype="CF_SQL_BIT">,
					0
				   )
		</cfquery>

		<cfreturn newid>
	</cffunction>

	<cffunction name="deleteThread" access="public" returnType="void" output="false"
				hint="Deletes a thread along with all of it's children.">

		<cfargument name="id" type="uuid" required="true">
		<cfargument name="runupdate" type="boolean" required="false" default="true">

		<cfset var t = getThread(ARGUMENTS.id)>

		<!--- delete kids --->
		<cfset var msgKids = VARIABLES.message.getMessages(ARGUMENTS.id)>

		<cfloop query="msgKids.data">
			<cfset VARIABLES.message.deleteMessage(msgKids.data.id[currentRow],false)>
		</cfloop>

		<cfquery datasource="#VARIABLES.dsn#">
			delete	from forum_threads
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- clean up subscriptions --->
		<cfquery datasource="#VARIABLES.dsn#">
			delete	from forum_subscriptions
			where	threadidfk = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- update my parent --->
		<cfif ARGUMENTS.runupdate>
			<cfset VARIABLES.forum.updateStats(t.forumidfk)>
		</cfif>

	</cffunction>

	<cffunction name="getThread" access="remote" returnType="struct" output="false"
				hint="Returns a struct copy of the thread.">
		<cfargument name="id" type="uuid" required="true">
		<cfset var qGetThread = "">

		<cfquery name="qGetThread" datasource="#VARIABLES.dsn#">
			select	id, name, active, forumidfk, useridfk, datecreated, sticky, lastpostuseridfk, lastpostcreated, messages
			from	forum_threads
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- Throw if invalid id passed --->
		<cfif not qGetThread.recordCount>
			<cfset VARIABLES.utils.throw("ThreadCFC","Invalid ID")>
		</cfif>

		<!--- Only a ForumsAdmin can get bActiveOnly=false --->
		<cfif not qGetThread.active and not isUserInRole("forumsadmin")>
			<cfset VARIABLES.utils.throw("ThreadCFC","Invalid call to getThread")>
		</cfif>

		<cfreturn VARIABLES.utils.queryToStruct(qGetThread)>

	</cffunction>

	<cffunction name="getThreads" access="public" returnType="struct" output="false"
				hint="Returns a list of threads.">

		<cfargument name="bActiveOnly" type="boolean" required="false" default="true">
		<cfargument name="forumid" type="uuid" required="false">

		<cfargument name="start" type="numeric" required="false">
		<cfargument name="max" type="numeric" required="false">

		<cfargument name="sort" type="string" required="false" default="messages asc">
		<cfargument name="search" type="string" required="false">

		<cfset var qGetThreads = "">
		<cfset var qGetThreadsID = "">
		<cfset var idfilter = "">
		<cfset var smalleridfilter = "">
		<cfset var x = "">
		<cfset var getTotal = "">
		<cfset var result = structNew()>

		<!--- Only a ForumsAdmin can be bActiveOnly=false --->
		<cfif not ARGUMENTS.bActiveOnly and not isUserInRole("forumsadmin")>
			<cfset VARIABLES.utils.throw("ThreadCFC","Invalid call to getThreads")>
		</cfif>

		<cfif structKeyExists(arguments, "start") and structKeyExists(arguments, "max")>
			<cfquery name="gettotal" datasource="#VARIABLES.dsn#" result="aa">
			select	count(t.id) as total
			from	((forum_threads t
						inner join forum_forums f on t.forumidfk = f.id)
						inner join forum_conferences c on f.conferenceidfk = c.id)
						inner join forum_users u on t.useridfk = u.id
			where	1=1
			<cfif ARGUMENTS.bActiveOnly>
				and		t.active = 1
			</cfif>
			<cfif isDefined("ARGUMENTS.forumid")>
				and		t.forumidfk = <cfqueryparam value="#ARGUMENTS.forumid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			</cfif>
			<cfif structKeyExists(arguments, "search") and len(ARGUMENTS.search)>
				and		t.name like  <cfqueryparam value="%#ARGUMENTS.search#%" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			</cfif>
			</cfquery>

			<cfquery name="qGetThreadsID" datasource="#VARIABLES.dsn#" maxrows="#ARGUMENTS.start+ARGUMENTS.max-1#" result="rr">
				select	t.id
				from	((forum_threads t
						inner join forum_forums f on t.forumidfk = f.id)
						inner join forum_conferences c on f.conferenceidfk = c.id)
						inner join forum_users u on t.useridfk = u.id

				where 1=1
				<cfif ARGUMENTS.bActiveOnly>
					and		t.active = 1
				</cfif>
				<cfif isDefined("ARGUMENTS.forumid")>
					and		t.forumidfk = <cfqueryparam value="#ARGUMENTS.forumid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
				</cfif>
				<cfif structKeyExists(arguments, "search") and len(ARGUMENTS.search)>
					and		t.name like  <cfqueryparam value="%#ARGUMENTS.search#%" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
				</cfif>
				order by t.sticky desc, t.#ARGUMENTS.sort#
				limit #ARGUMENTS.start-1#,#ARGUMENTS.max#
			</cfquery>
			<cfset idfilter = valueList(qGetThreadsID.id)>

			<cfif listLen(idfilter) gt ARGUMENTS.max>
				<cfloop index="x" from="#listLen(idfilter)-ARGUMENTS.start#" to="#listLen(idfilter)#">
					<cfset smalleridfilter = listAppend(smalleridfilter, listGetAt(idfilter, x))>
				</cfloop>
				<cfset idfilter = smalleridfilter>
			</cfif>
		</cfif>

		<cfquery name="qGetThreads" datasource="#VARIABLES.dsn#">
		select	t.id, t.name, t.active, t.forumidfk, t.useridfk, t.datecreated, t.messages, t.lastpostuseridfk,
			   	t.lastpostcreated, f.name as forum, u.username, sticky, c.name as conference

		from	((forum_threads t
		inner join forum_forums f on t.forumidfk = f.id)
		inner join forum_conferences c on f.conferenceidfk = c.id)
		inner join forum_users u on t.useridfk = u.id

		where 1=1
		<cfif len(idfilter)>
			and	t.id in (<cfqueryparam value="#idfilter#" cfsqltype="cf_sql_varchar" list="true">)
		</cfif>
		<cfif ARGUMENTS.bActiveOnly>
			and		t.active = 1
		</cfif>
		<cfif isDefined("ARGUMENTS.forumid")>
			and		t.forumidfk = <cfqueryparam value="#ARGUMENTS.forumid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfif>
		<cfif structKeyExists(arguments, "search") and len(ARGUMENTS.search)>
			and		t.name like  <cfqueryparam value="%#ARGUMENTS.search#%" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfif>
		order by t.sticky desc, t.#ARGUMENTS.sort#
		</cfquery>

		<cfif structKeyExists(arguments, "start") and structKeyExists(arguments, "max")>
			<cfset result.total = gettotal.total>
		<cfelse>
			<cfset result.total = qGetThreads.recordCount>
		</cfif>

		<cfset result.data = qGetThreads>

		<cfreturn result>

	</cffunction>

	<cffunction name="saveThread" access="remote" returnType="void" roles="forumsadmin" output="false"
				hint="Saves an existing thread.">

		<cfargument name="id" type="uuid" required="true">
		<cfargument name="thread" type="struct" required="true">

		<cfif not validThread(ARGUMENTS.thread)>
			<cfset VARIABLES.utils.throw("ThreadCFC","Invalid data passed to saveThread.")>
		</cfif>

		<cfquery datasource="#VARIABLES.dsn#">
			update	forum_threads
			set		name = <cfqueryparam value="#ARGUMENTS.thread.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					active = <cfqueryparam value="#ARGUMENTS.thread.active#" cfsqltype="CF_SQL_BIT">,
					forumidfk = <cfqueryparam value="#ARGUMENTS.thread.forumidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
					useridfk = <cfqueryparam value="#ARGUMENTS.thread.useridfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
					datecreated = <cfqueryparam value="#ARGUMENTS.thread.datecreated#" cfsqltype="CF_SQL_TIMESTAMP">,
					sticky = <cfqueryparam value="#ARGUMENTS.thread.sticky#" cfsqltype="CF_SQL_BIT">
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

	</cffunction>

	<cffunction name="search" access="remote" returnType="query" output="false"
				hint="Allows you to search threads.">
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
			select	t.id, t.name, t.forumidfk, f.conferenceidfk
			from	forum_threads t, forum_forums f
			where	t.active = 1
			and		t.forumidfk = f.id
			and (
				<cfif ARGUMENTS.searchtype is not "phrase">
					<cfloop index="x" from=1 to="#arrayLen(aTerms)#">
						(t.name like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(aTerms[x],255)#%">)
						 <cfif x is not arrayLen(aTerms)>#joiner#</cfif>
					</cfloop>
				<cfelse>
					t.name like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(ARGUMENTS.searchTerms,255)#%">
				</cfif>
			)
		</cfquery>

		<cfreturn results>
	</cffunction>

	<cffunction name="updateLastMessage" access="public" returnType="void" output="false" hint="Updates last message stats">
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="posted" type="date" required="true">

		<cfquery datasource="#VARIABLES.dsn#">
		update	forum_threads
		set		lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.userid#">,
				lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.posted#">,
				messages = messages + 1
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.id#">
		</cfquery>

	</cffunction>

	<cffunction name="updateStats" access="public" returnType="void" output="false" hint="Reset stats for thread">
		<cfargument name="id" type="uuid" required="true">
		<cfset var threadKids = "">
		<cfset var me = getThread(ARGUMENTS.id)>
		<cfset var total = 0>
		<cfset var last = createDate(1900,1,1)>
		<cfset var lastu = "">
		<cfset var lasti = "">
		<cfset var haveSome = false>
		<cfset var msgKids = "">

		<!---
		Rather simple. Get my kids. Count total msgs, and pick latest date
		--->

		<cfset msgKids = VARIABLES.message.getMessages(ARGUMENTS.id)>
		<cfset haveSome = msgKids.total gte 1>

		<!--- last msg is latest --->
		<cfif haveSome>
			<cfset total = msgKids.total>
			<cfset last = msgKids.data.posted[msgKids.total]>
			<cfset lastu = msgKids.data.useridfk[msgKids.total]>
			<cfset lasti = msgKids.data.id[msgKids.total]>
			<!--- lasti is NOT used. I know this. keeping this anyway for now. --->
		</cfif>

		<!--- now update this conf --->
		<cfif haveSome>
			<cfquery datasource="#VARIABLES.dsn#">
			update	forum_threads
			set
					lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#lastu#">,
					lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last#">,
					messages = <cfqueryparam cfsqltype="cf_sql_numeric" value="#total#">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.id#">
			</cfquery>
		<cfelse>
			<cfquery datasource="#VARIABLES.dsn#">
			update	forum_threads
			set
					lastpostuseridfk = <cfqueryparam cfsqltype="cf_sql_varchar" null="true">,
					lastpostcreated = <cfqueryparam cfsqltype="cf_sql_timestamp" null="true">,
					messages = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#ARGUMENTS.id#">
			</cfquery>
		</cfif>

		<!--- now update my parent --->
		<cfset VARIABLES.forum.updateStats(me.forumidfk)>

	</cffunction>

	<cffunction name="validThread" access="private" returnType="boolean" output="false"
				hint="Checks a structure to see if it contains all the proper keys/values for a thread.">

		<cfargument name="cData" type="struct" required="true">
		<cfset var rList = "name,active,forumidfk,useridfk,datecreated,sticky">
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
		<!--- keep a global copy to pass later on --->
		<cfset VARIABLES.settings = ARGUMENTS.settings.getSettings() />
	</cffunction>

	<cffunction name="setUtils" access="public" output="No" returntype="void">
		<cfargument name="utils" required="true" hint="utils">
		<cfset VARIABLES.utils = ARGUMENTS.utils />
	</cffunction>

	<cffunction name="setMessage" access="public" output="No" returntype="void">
		<cfargument name="message" required="true" hint="message">
		<cfset VARIABLES.message = ARGUMENTS.message />
	</cffunction>

	<cffunction name="setForum" access="public" output="No" returntype="void">
		<cfargument name="forum" required="true" hint="forum">
		<cfset VARIABLES.forum = ARGUMENTS.forum />
	</cffunction>

</cfcomponent>