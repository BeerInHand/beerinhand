<!---
	Name         : user.cfc
	Author       : Raymond Camden
	Created      : January 25, 2005
	Last Updated : November 21, 2007
	History      : Reset for V2
				 : Hash the password on user save (rkc 11/21/07)
	Purpose		 :
--->
<cfcomponent displayName="User" hint="Handles all user/security issues for the application.">
	<cfset VARIABLES.dsn = "">
	<cfset VARIABLES.requireconfirmation = 0>
	<cfset VARIABLES.title = "">
	<cfset VARIABLES.encryptpasswords = false>

	<cffunction name="init" access="public" returnType="user" output="false">
		<cfreturn this>
	</cffunction>

	<cffunction name="addGroup" access="public" returnType="void" output="false"
				hint="Attempts to create a new group.">
		<cfargument name="group" type="string" required="true">
		<cfset var checkgroup = "">
		<cfset var newid = createUUID()>

		<cflock name="user.cfc" type="exclusive" timeout="30">
			<cfquery name="checkgroup" datasource="#VARIABLES.dsn#">
				select	id
				from	forum_groups
				where
					forum_groups.`group`  = <cfqueryparam value="#ARGUMENTS.group#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">
			</cfquery>

			<cfif checkgroup.recordCount>
				<cfset VARIABLES.utils.throw("User CFC","Group already exists")>
			<cfelse>
				<cfquery datasource="#VARIABLES.dsn#">
				insert into forum_groups(id,`group`)
				values(<cfqueryparam value="#newid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				<cfqueryparam value="#ARGUMENTS.group#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">
				)
				</cfquery>
			</cfif>
		</cflock>

	</cffunction>

	<cffunction name="addUser" access="public" returnType="void" output="false" hint="Attempts to create a new user.">
		<cfargument name="usid" type="numeric" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="emailaddress" type="string" required="true">
		<cfargument name="groups" type="string" required="false">

		<cfset var checkuser = "" />
		<cfset var insuser = "" />
		<cfset var newid = createUUID() />

		<cflock name="user.cfc" type="exclusive" timeout="30">
			<cfquery name="checkuser" datasource="#VARIABLES.dsn#">
				select id
				  from forum_users
				 where username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
			</cfquery>
			<cfif checkuser.recordCount>
				<cfset VARIABLES.utils.throw("User CFC","User already exists")>
			<cfelse>
				<cfquery name="insuser" datasource="#VARIABLES.dsn#">
					insert into forum_users (
						id,usid,username,password,emailaddress,datecreated,confirmed,signature,avatar
					) values(
						<cfqueryparam value="#newid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
						<cfqueryparam value="#ARGUMENTS.usid#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#ARGUMENTS.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
						<cfqueryparam value="#ARGUMENTS.password#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
						<cfqueryparam value="#ARGUMENTS.emailaddress#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
						<cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
						1, '', ''
					)
				</cfquery>
				<cfif isDefined("ARGUMENTS.groups") and len(ARGUMENTS.groups)>
					<cfset assignGroups(ARGUMENTS.username,ARGUMENTS.groups)>
				</cfif>
			</cfif>

		</cflock>
	</cffunction>

	<cffunction name="assignGroups" access="private" returnType="void" output="false"
				hint="Assigns a user to groups.">
		<cfargument name="username" type="string" required="true">
		<cfargument name="groups" type="string" required="true">
		<cfset var uid = getUserId(ARGUMENTS.username)>
		<cfset var gid = "">
		<cfset var group = "">

		<cfloop index="group" list="#ARGUMENTS.groups#">
			<cfset gid = getGroupID(group)>
			<cfquery datasource="#VARIABLES.dsn#">
				insert into forum_users_groups(useridfk,groupidfk)
				values(<cfqueryparam value="#uid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,<cfqueryparam value="#gid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">)
			</cfquery>
		</cfloop>

	</cffunction>

	<cffunction name="authenticate" access="public" returnType="boolean" output="false"
				hint="Returns true or false if the user authenticates.">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfset var qAuth = "">

		<cfif VARIABLES.encryptpasswords>
			<cfset ARGUMENTS.password = hash(ARGUMENTS.password)>
		</cfif>

		<cfquery name="qAuth" datasource="#VARIABLES.dsn#">
			select	id
			from	forum_users
			where	username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
			and		password = <cfqueryparam value="#ARGUMENTS.password#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
			and		confirmed = 1
		</cfquery>

		<cfreturn qAuth.recordCount gt 0>

	</cffunction>

	<cffunction name="confirm" access="public" returnType="boolean" output="false"
				hint="Confirms a user.">
		<cfargument name="id" type="uuid" required="true">
		<cfset var q = "">

		<cfquery name="q" datasource="#VARIABLES.dsn#">
		select	id
		from	forum_users
		where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="cf_sql_varchar" maxlength="35">
		</cfquery>

		<cfif q.recordCount is 1>
			<cfquery datasource="#VARIABLES.dsn#">
			update	forum_users
			set		confirmed = 1
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="cf_sql_varchar" maxlength="35">
			</cfquery>
		</cfif>

		<cfreturn q.recordCount is 1>

	</cffunction>

	<cffunction name="deleteGroup" access="public" returnType="void" output="false"
				hint="Deletes a group.">
		<cfargument name="group" type="uuid" required="true">

		<cfquery datasource="#VARIABLES.dsn#">
			delete from forum_groups
			where  id = <cfqueryparam value="#ARGUMENTS.group#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<cfquery datasource="#VARIABLES.dsn#">
			delete from forum_users_groups
			where  groupidfk = <cfqueryparam value="#ARGUMENTS.group#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

	</cffunction>

	<cffunction name="deletePrivateMessage" access="public" returnType="void" output="false"
				hint="Deletes a PM.">
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="username" type="string" required="true">
		<cfset var pm = "">

		<!--- fetch it just to ensure we can get it --->
		<cftry>
			<cfset pm = getPrivateMessage(ARGUMENTS.id, ARGUMENTS.username)>

			<cfquery datasource="#VARIABLES.dsn#">
			delete	from forum_privatemessages
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.id#" maxlength="35">
			</cfquery>
			<cfcatch>
				<!--- do nothing, it is either a hack or a user reloading by accident --->
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="deleteUser" access="public" returnType="void" output="false"
				hint="Deletes a user.">
		<cfargument name="username" type="string" required="true">
		<cfset var uid = getUserId(ARGUMENTS.username)>

		<cflock name="user.cfc" type="exclusive" timeout="30">

		<cfquery datasource="#VARIABLES.dsn#">
			delete	from forum_users_groups
			where	useridfk = <cfqueryparam value="#uid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<cfquery datasource="#VARIABLES.dsn#">
			delete	from forum_users
			where	id = <cfqueryparam value="#uid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<cfquery datasource="#VARIABLES.dsn#">
			delete	from forum_subscriptions
			where	useridfk = <cfqueryparam value="#uid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		</cflock>

	</cffunction>

	<cffunction name="getGroup" access="public" returnType="struct" output="false"
				hint="Returns a group.">
		<cfargument name="id" type="uuid" required="true">
		<cfset var qGetGroup = "">
		<cfset var s = structNew()>

		<cfquery name="qGetGroup" datasource="#VARIABLES.dsn#">
			select	id, `group`
			from	forum_groups
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<cfif qGetGroup.recordCount>
			<cfset s.id = qGetGroup.id>
			<cfset s.group = qGetGroup.group>
			<cfreturn s>
		<cfelse>
			<cfset VARIABLES.utils.throw("UserCFC","Invalid Group [#ARGUMENTS.id#]")>
		</cfif>

	</cffunction>

	<cffunction name="getGroupID" access="public" returnType="uuid" output="false"
				hint="Returns a group id.">
		<cfargument name="group" type="string" required="true">
		<cfset var qGetGroup = "">

		<cfquery name="qGetGroup" datasource="#VARIABLES.dsn#">
			select	id
			from	forum_groups
			where forum_groups.`group` = <cfqueryparam value="#ARGUMENTS.group#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">
		</cfquery>

		<cfif qGetGroup.recordCount>
			<cfreturn qGetGroup.id>
		<cfelse>
			<cfset VARIABLES.utils.throw("UserCFC","Invalid Group [#ARGUMENTS.group#]")>
		</cfif>

	</cffunction>

	<cffunction name="getGroups" access="public" returnType="query" output="false"
				hint="Returns a query of all the known groups.">
		<cfset var qGetGroups = "">

		<cfquery name="qGetGroups" datasource="#VARIABLES.dsn#">
			select	id, `group`
			from	forum_groups
		</cfquery>

		<cfreturn qGetGroups>

	</cffunction>

	<cffunction name="getGroupsForUser" access="public" returnType="string" output="false"
				hint="Returns a list of groups for a user.">
		<cfargument name="username" type="string" required="true">
		<cfset var qGetGroups = "">

		<cfquery name="qGetGroups" datasource="#VARIABLES.dsn#">
        	select forum_groups.`group`
			from	forum_users, forum_groups, forum_users_groups
			where	forum_users_groups.useridfk = forum_users.id
			and		forum_users_groups.groupidfk = forum_groups.id
			and		forum_users.username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
		</cfquery>

		<cfreturn valueList(qGetGroups.group)>

	</cffunction>

	<cffunction name="getPrivateMessage" access="public" returnType="struct" output="false" hint="Gets my private messages.">
		<cfargument name="id" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfset var q = "">
		<cfset var s = structNew()>
		<cfset var col = "">

		<cfquery name="q" datasource="#VARIABLES.dsn#">
		select pm.id, pm.subject, pm.body, pm.unread, pm.sent, u2.username as sender
		from forum_privatemessages pm
		left join forum_users u2 on pm.fromuseridfk = u2.id
		left join forum_users u on pm.touseridfk = u.id
		where u.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.username#">
		and	pm.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.id#">
		</cfquery>

		<cfif q.recordCount is 0>
			<cfthrow message="Invalid or unauthorized message load.">
		</cfif>

		<cfloop index="col" list="#q.columnList#">
			<cfset s[col] = q[col][1]>
		</cfloop>

		<cfquery datasource="#VARIABLES.dsn#">
		update forum_privatemessages
		set unread = 0
		where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.id#">
		</cfquery>

		<cfreturn s>

	</cffunction>

	<cffunction name="getPrivateMessages" access="public" returnType="query" output="false" hint="Gets my private messages.">
		<cfargument name="username" type="string" required="true">
		<cfargument name="sort" type="string" required="false" default="sent">
		<cfargument name="sortdir" type="string" required="false" default="desc">

		<cfset var q = "">

		<cfif not listFindNoCase("sender,sent,subject", ARGUMENTS.sort)>
			<cfset ARGUMENTS.sort = "sent">
		</cfif>
		<cfif not listFindNoCase("asc,desc", ARGUMENTS.sortdir)>
			<cfset ARGUMENTS.sortdir = "desc">
		</cfif>

		<cfquery name="q" datasource="#VARIABLES.dsn#">
		select pm.id, pm.subject, pm.body, pm.unread, pm.sent, u2.username as sender
		from forum_privatemessages pm
		left join forum_users u2 on pm.fromuseridfk = u2.id
		left join forum_users u on pm.touseridfk = u.id
		where u.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.username#">
		order by #ARGUMENTS.sort# #ARGUMENTS.sortdir#
		</cfquery>

		<cfreturn q>
	</cffunction>

	<cffunction name="getSubscriptions" access="public" returnType="query" output="false"
				hint="Gets subscriptions for a user.">
		<cfargument name="username" type="string" required="true">
		<cfset var uid = getUserId(ARGUMENTS.username)>
		<cfset var q = "">

		<cfquery name="q" datasource="#VARIABLES.dsn#">
		    select  s.id, s.threadidfk, s.forumidfk, s.conferenceidfk
            from    forum_subscriptions s
            left join forum_threads t on s.threadidfk = t.id
            left join forum_forums f on s.forumidfk = f.id
            left join forum_conferences c on s.conferenceidfk = c.id
            where    s.useridfk = <cfqueryparam value="#uid#" cfsqltype="cf_sql_varchar" maxlength="35">
			and
			(
			(s.threadidfk is not null and t.active = 1)
			or
			(s.forumidfk is not null and f.active=1)
			or
			(s.conferenceidfk is not null and c.active=1)
			)
		</cfquery>

		<cfreturn q>
	</cffunction>

	<cffunction name="getUnreadMessageCount" access="public" returnType="numeric" output="false" hint="Returns the number of unread messages for a user.">
		<cfargument name="username" type="string" required="true">

		<cfset var result = "">

		<cfquery name="result" datasource="#VARIABLES.dsn#">
		select count(pm.id) as total
		from forum_privatemessages pm
		left join forum_users u on pm.touseridfk = u.id
		where u.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.username#">
		and pm.unread = 1
		</cfquery>

		<cfreturn result.total>

	</cffunction>

	<cffunction name="getUser" access="public" returnType="struct" output="false"
				hint="Returns a user.">
		<cfargument name="username" type="string" required="true">
		<cfset var qGetUser = "" />
		<cfset var user = StructNew() />
		<cfset var g = "" />
		<cfset var qGetPostCount = "" />

		<cfquery name="qGetUser" datasource="#VARIABLES.dsn#">
			select id, username, password, emailaddress, datecreated, confirmed, signature, avatar
			  from forum_users
			 where username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
		</cfquery>

		<cfquery name="qGetPostCount" datasource="#VARIABLES.dsn#">
			select count(id) as postcount
			  from forum_messages
			 where useridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetUser.id#" maxlength="35">
		</cfquery>

		<cfset user = VARIABLES.utils.queryToStruct(qGetUser)>
		<cfif qGetPostCount.postcount neq "">
			<cfset user.postcount = qGetPostCount.postcount>
		<cfelse>
			<cfset user.postcount = 0>
		</cfif>
		<cfset user.groups = getGroupsForUser(ARGUMENTS.username)>

		<cfset user.groupids = "">
		<cfloop index="g" list="#user.groups#">
			<cfset user.groupids = listAppend(user.groupids, getGroupId(g))>
		</cfloop>

		<cfreturn user>

	</cffunction>

	<cffunction name="getUserID" access="public" returnType="uuid" output="false"
				hint="Returns a user id.">
		<cfargument name="username" type="string" required="true">
		<cfset var qGetUser = "">

		<cfquery name="qGetUser" datasource="#VARIABLES.dsn#">
			select	id
			from	forum_users
			where	username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
		</cfquery>

		<cfif qGetUser.recordCount>
			<cfreturn qGetUser.id>
		<cfelse>
			<cfset VARIABLES.utils.throw("UserCFC","Invalid Username")>
		</cfif>

	</cffunction>

	<cffunction name="getUsernameFromID" access="public" returnType="string" output="false"
				hint="Returns a username from a user id.">
		<cfargument name="userid" type="string" required="true">
		<cfset var qGetUser = "">

		<cfquery name="qGetUser" datasource="#VARIABLES.dsn#">
			select	username
			from	forum_users
			where	id = <cfqueryparam value="#ARGUMENTS.userid#" cfsqltype="cf_sql_varchar" maxlength="35">
		</cfquery>

		<cfreturn qGetUser.username>
	</cffunction>

	<cffunction name="getUsers" access="public" returnType="struct" output="false"
				hint="Returns all the users.">
		<cfargument name="start" type="numeric" required="false">
		<cfargument name="max" type="numeric" required="false">

		<cfargument name="sort" type="string" required="false" default="messages asc">
		<cfargument name="search" type="string" required="false">

		<cfset var qGetUsers = "">
		<cfset var getTotal = "">
		<cfset var qGetUsersId = "">
		<cfset var idfilter = "">
		<cfset var smalleridfilter = "">
		<cfset var result = structNew()>
		<cfset var x = "">

		<cfif structKeyExists(ARGUMENTS, "start") and structKeyExists(ARGUMENTS, "max")>
			<cfquery name="gettotal" datasource="#VARIABLES.dsn#">
			select	count(id) as total
			from	forum_users u
			where	1=1
			<cfif structKeyExists(ARGUMENTS, "search") and len(ARGUMENTS.search)>
				and		u.username like  <cfqueryparam value="%#ARGUMENTS.search#%" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			</cfif>
			</cfquery>

			<cfquery name="qGetUsersID" datasource="#VARIABLES.dsn#" maxrows="#ARGUMENTS.start+ARGUMENTS.max-1#">
				select	u.id
				from	forum_users u
				where 1=1
				<cfif structKeyExists(ARGUMENTS, "search") and len(ARGUMENTS.search)>
					and		u.username like  <cfqueryparam value="%#ARGUMENTS.search#%" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
				</cfif>
				order by u.#ARGUMENTS.sort#
				limit #ARGUMENTS.start-1#,#ARGUMENTS.max#
			</cfquery>
			<cfset idfilter = valueList(qGetUsersID.id)>

			<cfif listLen(idfilter) gt ARGUMENTS.max>
				<cfloop index="x" from="#ARGUMENTS.start#" to="#listlen(idfilter)#">
					<cfset smalleridfilter = listAppend(smalleridfilter, listGetAt(idfilter, x))>
				</cfloop>
				<cfset idfilter = smalleridfilter>
			</cfif>
		</cfif>

		<cfquery name="qGetUsers" datasource="#VARIABLES.dsn#">
		select u.id, u.username, u.password, u.emailaddress, u.datecreated, count(forum_messages.id) as postcount, u.confirmed
		from forum_users u
		left join  forum_messages
		on  u.id = forum_messages.useridfk
		where 1=1
		<cfif len(idfilter)>
			and	u.id in (<cfqueryparam value="#idfilter#" cfsqltype="cf_sql_varchar" list="true">)
		</cfif>
		<cfif structKeyExists(ARGUMENTS, "search") and len(ARGUMENTS.search)>
			and		u.username like  <cfqueryparam value="%#ARGUMENTS.search#%" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfif>

		group by u.id, u.username,u.password, u.emailaddress, u.datecreated, u.confirmed
		order by u.#ARGUMENTS.sort#
		</cfquery>

		<cfif structKeyExists(ARGUMENTS, "start") and structKeyExists(ARGUMENTS, "max")>
			<cfset result.total = gettotal.total>
		<cfelse>
			<cfset result.total = qGetUsers.recordCount>
		</cfif>

		<cfset result.data = qGetUsers>

		<cfreturn result>
	</cffunction>

	<cffunction name="removeGroups" access="private" returnType="void" output="false"
				hint="Removes all groups from a user.">
		<cfargument name="username" type="string" required="true">

		<cfset var uid = getUserId(ARGUMENTS.username)>

		<cfquery datasource="#VARIABLES.dsn#">
			delete from forum_users_groups
			where useridfk = <cfqueryparam value="#uid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

	</cffunction>

	<cffunction name="saveGroup" access="public" returnType="void" output="false"
				hint="Attempts to save a group.">
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="group" type="string" required="true">
		<cfset var checkgroup = "">

		<cflock name="user.cfc" type="exclusive" timeout="30">
			<cfquery name="checkgroup" datasource="#VARIABLES.dsn#">
				select	id
				from	forum_groups
				where forum_groups.`group` = <cfqueryparam value="#ARGUMENTS.group#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">
				and		id != <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="cf_sql_varchar" maxlength="35">
			</cfquery>

			<cfif checkgroup.recordCount>
				<cfset VARIABLES.utils.throw("User CFC","Another group has that name")>
			<cfelse>
				<cfquery datasource="#VARIABLES.dsn#">
				update	forum_groups
				set forum_groups.`group` = <cfqueryparam value="#ARGUMENTS.group#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">
				where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
				</cfquery>
			</cfif>
		</cflock>

	</cffunction>

	<cffunction name="saveUser" access="public" returnType="void" output="false"
				hint="Attempts to save a user.">
		<cfargument name="username" type="string" required="true">
		<cfargument name="emailaddress" type="string" required="false">
		<cfargument name="datecreated" type="date" required="false">
		<cfargument name="groups" type="string" required="false">
		<cfargument name="confirmed" type="boolean" required="false" default="false">
		<cfargument name="signature" type="string" required="false">
		<cfargument name="avatar" type="string" required="false">
		<cfargument name="password" type="string" required="false">

		<cfset var uid = getUserId(ARGUMENTS.username)>

		<!--- hash password --->
		<cfif VARIABLES.encryptpasswords and structKeyExists(ARGUMENTS, "password")>
			<cfset ARGUMENTS.password = hash(ARGUMENTS.password)>
		</cfif>

		<cfquery datasource="#VARIABLES.dsn#">
			update forum_users
				set
				<cfif structKeyExists(ARGUMENTS, "emailaddress")>
					emailaddress = <cfqueryparam value="#ARGUMENTS.emailaddress#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				</cfif>
				<cfif structKeyExists(ARGUMENTS, "password")>
					password = <cfqueryparam value="#ARGUMENTS.password#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
				</cfif>
				<cfif structKeyExists(ARGUMENTS, "confirmed")>
					confirmed = <cfqueryparam value="#ARGUMENTS.confirmed#" cfsqltype="CF_SQL_BIT">,
				</cfif>
				<cfif structKeyExists(ARGUMENTS, "signature")>
					signature = <cfqueryparam value="#left(htmleditFormat(ARGUMENTS.signature),1000)#" cfsqltype="cf_sql_varchar">,
				</cfif>
				<cfif structKeyExists(ARGUMENTS, "avatar")>
					avatar = <cfqueryparam value="#ARGUMENTS.avatar#" cfsqltype="cf_sql_varchar" maxlength="255">,
				</cfif>
					datecreated = <cfif structKeyExists(ARGUMENTS, "datecreated")><cfqueryparam value="#ARGUMENTS.datecreated#" cfsqltype="CF_SQL_TIMESTAMP"><cfelse>datecreated</cfif>
			where	username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
		</cfquery>

		<cfif structKeyExists(ARGUMENTS, "groups")>
			<!--- remove groups --->
			<cfset removeGroups(ARGUMENTS.username)>
			<!--- assign groups --->
			<cfset assignGroups(ARGUMENTS.username,ARGUMENTS.groups)>
		</cfif>

	</cffunction>

	<cffunction name="sendPrivateMessage" access="public" returnType="void" output="false" hint="Sends a Private Message.">
		<cfargument name="to" type="string" required="true">
		<cfargument name="from" type="string" required="true">
		<cfargument name="subject" type="string" required="true">
		<cfargument name="body" type="string" required="true">

		<cfset var toid = getuserid(ARGUMENTS.to)>
		<cfset var fromid = getuserid(ARGUMENTS.from)>

		<cfquery datasource="#VARIABLES.dsn#">
		insert into forum_privatemessages(id,fromuseridfk,touseridfk,sent,body,subject,unread)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#createUUID()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#fromid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#toid#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.body#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.subject#" maxlength="255">,
			1)
		</cfquery>

	</cffunction>

	<cffunction name="subscribe" access="public" returnType="void" output="false"
				hint="Subscribes a user to Galleon.">
		<cfargument name="username" type="string" required="true">
		<cfargument name="mode" type="string" required="true">
		<cfargument name="id" type="uuid" required="true">
		<cfset var uid = getUserId(ARGUMENTS.username)>
		<cfset var check = "">

		<cfif not listFindNoCase("conference,forum,thread", ARGUMENTS.mode)>
			<cfset VARIABLES.utils.throw("UserCFC","Invalid Mode")>
		</cfif>

		<cfquery name="check" datasource="#VARIABLES.dsn#">
		select	useridfk
		from	forum_subscriptions
		where
				<cfif ARGUMENTS.mode is "conference">
				conferenceidfk =
				<cfelseif ARGUMENTS.mode is "forum">
				forumidfk =
				<cfelseif ARGUMENTS.mode is "thread">
				threadidfk =
				</cfif>
				<cfqueryparam value="#ARGUMENTS.id#" cfsqltype="cf_sql_varchar" maxlength="35">
		and		useridfk = <cfqueryparam value="#uid#" cfsqltype="cf_sql_varchar" maxlength="35">
		</cfquery>

		<cfif check.recordCount is 0>
			<cfquery datasource="#VARIABLES.dsn#">
			insert into forum_subscriptions(id,useridfk,
				<cfif ARGUMENTS.mode is "conference">
				conferenceidfk
				<cfelseif ARGUMENTS.mode is "forum">
				forumidfk
				<cfelseif ARGUMENTS.mode is "thread">
				threadidfk
				</cfif>)
			values(<cfqueryparam value="#createUUID()#" cfsqltype="cf_sql_varchar" maxlength="35">,
			<cfqueryparam value="#uid#" cfsqltype="cf_sql_varchar" maxlength="35">,
			<cfqueryparam value="#ARGUMENTS.id#" cfsqltype="cf_sql_varchar" maxlength="35">)
			</cfquery>
		</cfif>

	</cffunction>

	<cffunction name="unsubscribe" access="public" returnType="void" output="false"
				hint="Unsubscribes a user from Galleon data.">
		<cfargument name="username" type="string" required="true">
		<cfargument name="id" type="uuid" required="true">
		<cfset var uid = getUserId(ARGUMENTS.username)>

		<cfquery datasource="#VARIABLES.dsn#">
		delete	from	forum_subscriptions
		where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="cf_sql_varchar" maxlength="35">
		and		useridfk = <cfqueryparam value="#uid#" cfsqltype="cf_sql_varchar" maxlength="35">
		</cfquery>

	</cffunction>

	<cffunction name="setMailService" access="public" output="No" returntype="void">
		<cfargument name="mailservice" required="true" hint="thread">
		<cfset VARIABLES.mailservice = ARGUMENTS.mailservice />
	</cffunction>

	<cffunction name="setSettings" access="public" output="No" returntype="void">
		<cfargument name="settings" required="true" hint="Setting">

		<cfset var cfg = ARGUMENTS.settings.getSettings() />
		<cfset VARIABLES.dsn = APPLICATION.DSN.FORUM />
		<cfset VARIABLES.requireconfirmation = cfg.requireconfirmation>
		<cfset VARIABLES.title = cfg.title>
		<cfset VARIABLES.encryptpasswords = cfg.encryptpasswords>

	</cffunction>

	<cffunction name="setUtils" access="public" output="No" returntype="void">
		<cfargument name="utils" required="true" hint="utils">
		<cfset VARIABLES.utils = ARGUMENTS.utils />
	</cffunction>

</cfcomponent>