<!---
	Name		 : message.cfc
	Author	   : Raymond Camden
	Created	  : October 21, 2004
	Last Updated : October 12, 2007
	History	  : Reset for V2
	Purpose		 :
--->
<cfcomponent displayName="Message" hint="Handles Messages.">

	<cfset VARIABLES.dsn = "">

	<cffunction name="init" access="public" returnType="message" output="false" hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfreturn this>

	</cffunction>

	<cffunction name="addMessage" access="remote" returnType="uuid" output="false" hint="Adds a message, and potentially a new thread.">

		<cfargument name="message" type="struct" required="true">
		<cfargument name="forumid" type="uuid" required="true">
		<cfargument name="username" type="string" required="false" default="#getAuthUser()#">
		<cfargument name="threadid" type="uuid" required="false">
		<cfargument name="sticky" type="boolean" required="false" default="false">
		<cfset var badForum = false>
		<cfset var forum = "">
		<cfset var badThread = false>
		<cfset var tmpThread = "">
		<cfset var tmpConference = "">
		<cfset var newmessage = "">
		<cfset var getInterestedFolks = "">
		<cfset var thread = "">
		<cfset var newid = createUUID()>
		<cfset var delid = createUUID()>
		<cfset var notifiedList = "">
		<cfset var body = "">
		<cfset var posted = now()>
		<cfset var fullbody = "">

		<!--- Another security check - if ARGUMENTS.username neq getAuthUser, throw --->
		<cfif ARGUMENTS.username neq getAuthUser() and not isUserInRole("forumsadmin")>
			<cfset VARIABLES.utils.throw("Message CFC","Unauthorized execution of addMessage.")>
		</cfif>

		<cfif not validmessage(ARGUMENTS.message)>
			<cfset VARIABLES.utils.throw("Message CFC","Invalid data passed to addMessage.")>
		</cfif>

		<!--- is the forum readonly, or non existent? --->
		<cftry>
			<cfset forum = VARIABLES.forum.getForum(ARGUMENTS.forumid)>
			<!---
			<cfif forum.readonly and not isUserInRole("forumsadmin")>
				<cfset badForum = true>
			<cfelse>
				<cfset tmpConference = VARIABLES.conference.getConference(forum.conferenceidfk)>
			</cfif>
			--->
			<cfset tmpConference = VARIABLES.conference.getConference(forum.conferenceidfk)>

			<cfcatch type="forumcfc">
				<!--- don't really care which it is - it is bad --->
				<cfset badForum = true>
			</cfcatch>
		</cftry>

		<cfif badForum>
			<cfset VARIABLES.utils.throw("MessageCFC","Invalid or Protected Forum")>
		</cfif>

		<!--- is the thread readonly, or nonexistent? --->
		<cfif isDefined("ARGUMENTS.threadid")>
			<cftry>
				<cfset tmpThread = VARIABLES.thread.getThread(ARGUMENTS.threadid)>
				<!---
				<cfif tmpThread.readonly and not isUserInRole("forumsadmin")>
					<cfset badThread = true>
				</cfif>
				--->
				<cfcatch type="threadcfc">
					<!--- don't really care which it is - it is bad --->
					<cfset badThread = true>
				</cfcatch>
			</cftry>

			<cfif badThread>
				<cfset VARIABLES.utils.throw("MessageCFC","Invalid or Protected Thread")>
			</cfif>
		<cfelse>
			<!--- We need to create a new thread --->
			<cfset tmpThread = structNew()>
			<cfset tmpThread.name = message.title>
			<cfset tmpThread.readonly = false>
			<cfset tmpThread.active = true>
			<cfset tmpThread.forumidfk = ARGUMENTS.forumid>
			<cfset tmpThread.useridfk = VARIABLES.user.getUserID(ARGUMENTS.username)>
			<cfset tmpThread.dateCreated = posted>
			<cfset tmpThread.sticky = ARGUMENTS.sticky>
			<cfset ARGUMENTS.threadid = VARIABLES.thread.addThread(tmpThread)>
		</cfif>

		<cfquery name="newmessage" datasource="#VARIABLES.dsn#">
			insert into forum_messages(id,title,body,useridfk,threadidfk,posted,attachment,filename,deleteid)
			values(<cfqueryparam value="#newid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#ARGUMENTS.message.title#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				   <cfqueryparam value="#ARGUMENTS.message.body#" cfsqltype="CF_SQL_LONGVARCHAR">,
				   <cfqueryparam value="#VARIABLES.user.getUserID(ARGUMENTS.username)#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#ARGUMENTS.threadid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				   <cfqueryparam value="#posted#" cfsqltype="CF_SQL_TIMESTAMP">,
				   <cfqueryparam value="#ARGUMENTS.message.attachment#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
   				   <cfqueryparam value="#ARGUMENTS.message.filename#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					<cfqueryparam value="#delid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
				   )
		</cfquery>

		<!--- Do clean up of special layout. I may need to abstract this later. --->
		<cfset body = reReplaceNoCase(ARGUMENTS.message.body, "\[/{0,1}code\]", "", "all")>
		<cfset body = reReplaceNoCase(body, "\[/{0,1}img\]", "", "all")>
		<cfset body = reReplaceNoCase(body, "\[/{0,1}quote.*?\]", "", "all")>

		<!--- get everyone in the thread who wants posts --->
		<cfset notifiedList = notifySubscribers(ARGUMENTS.threadid, tmpThread.name, ARGUMENTS.forumid, VARIABLES.user.getUserID(ARGUMENTS.username),body)>
		<cfif structKeyExists(VARIABLES.settings,"sendonpost") and len(VARIABLES.settings.sendonpost)>

			<cfprocessingdirective suppresswhitespace="false">
			<cfsavecontent variable="fullbody">
			<cfoutput>
Title:		#ARGUMENTS.message.title#
Thread: 	#tmpThread.name#
Forum:		#forum.name#
Conference:	#tmpConference.name#
User:		#ARGUMENTS.username#

#wrap(body,80)#

#APPLICATION.PATH.ROOT#/f.messages.cfm?threadid=#ARGUMENTS.threadid#&last##last

DELETE MESSAGE: #APPLICATION.PATH.ROOT#/f.index.cfm?del=#delid#
Note - clicking the link above will delete the message and delete the user. Use with caution!

			</cfoutput>
			</cfsavecontent>
			</cfprocessingdirective>

			<cfset VARIABLES.mailService.sendMail(APPLICATION.EMAIL.failto,VARIABLES.settings.sendonpost,"#APPLICATION.FORUM.SETTING.title# Notification: Post to #tmpThread.name#",trim(fullbody))>

		</cfif>

		<!--- Now we notify our thread, forum, and conference on our new stats --->
		<cfset VARIABLES.conference.updateLastMessage(tmpConference.id, ARGUMENTS.threadid, VARIABLES.user.getUserID(ARGUMENTS.username), posted)>
		<cfset VARIABLES.forum.updateLastMessage(forum.id, ARGUMENTS.threadid, VARIABLES.user.getUserID(ARGUMENTS.username), posted)>
		<cfset VARIABLES.thread.updateLastMessage(ARGUMENTS.threadid, VARIABLES.user.getUserID(ARGUMENTS.username), posted)>

		<cfreturn newid>

	</cffunction>

	<cffunction name="deleteMessage" access="public" returnType="void" output="false" hint="Deletes a message.">

		<cfargument name="id" type="uuid" required="true">
		<cfargument name="runupdate" type="boolean" required="false" default="true">

		<cfset var q = "">
		<cfset var m = getMessage(ARGUMENTS.id)>

		<!--- Since you can't delete from the front end, except for the email thing, I'm removing this security check.
		It prevents the email thing from working for an anonymous request which we explicitely want to allow. --->
		<!---
		<!--- First see if we can delete a message. Because roles= doesn't allow for OR, we use a UDF --->
		<cfif not IsUserInAnyRole("forumsadmin,forumsmoderator")>
			<cfset VARIABLES.utils.throw("Message CFC","Unauthorized execution of deleteMessage.")>
		</cfif>
		--->
		<cfquery name="q" datasource="#VARIABLES.dsn#">
			select	filename
			from 	forum_messages
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<cfquery datasource="#VARIABLES.dsn#">
			delete	from forum_messages
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<cfif len(q.filename) and fileExists("#APPLICATION.DISK.ATTACH#\#q.filename#")>
			<cffile action="delete" file="#APPLICATION.DISK.ATTACH#\#q.filename#">
		</cfif>

		<!--- update my parent --->
		<cfif ARGUMENTS.runupdate>
			<cfset VARIABLES.thread.updateStats(m.threadidfk)>
		</cfif>

	</cffunction>

	<cffunction name="getMessage" access="remote" returnType="struct" output="false" hint="Returns a struct copy of the message.">
		<cfargument name="id" type="uuid" required="true">
		<cfset var qGetMessage = "">

		<cfquery name="qGetMessage" datasource="#VARIABLES.dsn#">
			select	m.id, m.title, m.body, m.posted, m.useridfk, m.threadidfk, m.attachment, m.filename, m.updated, m.updatedby, u.username, t.name as thread
			from	forum_messages m
			left join forum_users u on m.useridfk = u.id
			left join forum_threads t on m.threadidfk = t.id
			where	m.id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<!--- Throw if invalid id passed --->
		<cfif not qGetMessage.recordCount>
			<cfset VARIABLES.utils.throw("MessageCFC","Invalid ID")>
		</cfif>

		<cfreturn VARIABLES.utils.queryToStruct(qGetMessage)>

	</cffunction>

	<cffunction name="getMessages" access="public" returnType="struct" output="false" hint="Returns a list of messages.">

		<cfargument name="threadid" type="uuid" required="false">
		<cfargument name="start" type="numeric" required="false">
		<cfargument name="max" type="numeric" required="false">
		<cfargument name="sort" type="string" required="false" default="posted asc">
		<cfargument name="search" type="string" required="false">

		<cfset var qGetMessages = "">
		<cfset var qGetMessagesID = "">
		<cfset var idfilter = "">
		<cfset var smalleridfilter = "">
		<cfset var x = "">
		<cfset var getTotal = "">
		<cfset var result = structNew()>

		<cfif structKeyExists(arguments, "start") and structKeyExists(arguments, "max")>
			<cfquery name="gettotal" datasource="#VARIABLES.dsn#">
			select	count(id) as total
			from	forum_messages
			where	1=1
			<cfif structKeyExists(arguments, "threadid")>
				and		forum_messages.threadidfk = <cfqueryparam value="#ARGUMENTS.threadid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			</cfif>
			<cfif structKeyExists(arguments, "search") and len(ARGUMENTS.search)>
				and		forum_messages.title like  <cfqueryparam value="%#ARGUMENTS.search#%" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			</cfif>
			</cfquery>

			<cfquery name="qGetMessagesID" datasource="#VARIABLES.dsn#" maxrows="#ARGUMENTS.start+ARGUMENTS.max-1#">
				select	forum_messages.id
				from forum_messages
				where 1=1
				<cfif structKeyExists(arguments, "threadid")>
					and		forum_messages.threadidfk = <cfqueryparam value="#ARGUMENTS.threadid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
				</cfif>
				<cfif structKeyExists(arguments, "search") and len(ARGUMENTS.search)>
					and		forum_messages.title like  <cfqueryparam value="%#ARGUMENTS.search#%" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
				</cfif>
				order by #ARGUMENTS.sort#
				limit #ARGUMENTS.start-1#,#ARGUMENTS.max#
			</cfquery>
			<cfset idfilter = valueList(qGetMessagesID.id)>

			<cfif listLen(idfilter) gt ARGUMENTS.max>
				<cfloop index="x" from="#listLen(idfilter)-ARGUMENTS.start#" to="#listLen(idfilter)#">
					<cfset smalleridfilter = listAppend(smalleridfilter, listGetAt(idfilter, x))>
				</cfloop>
				<cfset idfilter = smalleridfilter>
			</cfif>
		</cfif>

		<cfquery name="qGetMessages" datasource="#VARIABLES.dsn#">
		select
				forum_messages.id, forum_messages.title, forum_messages.body, forum_messages.attachment, forum_messages.filename,
				forum_messages.posted, forum_messages.threadidfk, forum_messages.useridfk, forum_messages.updated, forum_messages.updatedby,
				forum_threads.name as threadname, forum_users.username,
				forum_forums.name as forumname, forum_conferences.name as conferencename
		from 	(((forum_messages left join forum_threads on forum_messages.threadidfk = forum_threads.id)
					left join forum_forums on forum_threads.forumidfk = forum_forums.id)
					left join forum_conferences on forum_forums.conferenceidfk = forum_conferences.id)
					left join forum_users on forum_messages.useridfk = forum_users.id
		where	1=1
		<cfif structKeyExists(arguments, "threadid")>
			and		forum_messages.threadidfk = <cfqueryparam value="#ARGUMENTS.threadid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfif>
		<cfif structKeyExists(arguments, "search") and len(ARGUMENTS.search)>
			and		forum_messages.title like  <cfqueryparam value="%#ARGUMENTS.search#%" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfif>
		<cfif len(idfilter)>
			and	forum_messages.id in (<cfqueryparam value="#idfilter#" cfsqltype="cf_sql_varchar" list="true">)
		</cfif>
		order by	#ARGUMENTS.sort#
		</cfquery>

		<cfif structKeyExists(arguments, "start") and structKeyExists(arguments, "max")>
			<cfset result.total = gettotal.total>
		<cfelse>
			<cfset result.total = qGetMessages.recordCount>
		</cfif>

		<cfset result.data = qGetMessages>

		<cfreturn result>
	</cffunction>

	<cffunction name="handleDeletion" access="public" returnType="void" output="false" hint="Allows for one click deletion from emails">
		<cfargument name="delkey" type="any" required="false">
		<cfset var checkMsg = "">
		<cfset var thread = "">
		<cfset var username = "">

		<cfif not len(trim(ARGUMENTS.delKey))>
			<cfreturn>
		</cfif>

		<cfquery name="checkMsg" datasource="#VARIABLES.dsn#">
			select	m.id, m.threadidfk, m.useridfk
			from	forum_messages m
			where	m.deleteid = <cfqueryparam value="#ARGUMENTS.delkey#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<cfif checkMsg.recordCount is 0>
			<cfreturn>
		</cfif>

		<!--- Kill the message --->
		<cfset deleteMessage(checkMsg.id)>
		<!--- Kill the messenger --->
		<!--- possibly we should get his messages too, but I assume if spammer X does N posts, you will delete them all via click --->
		<!---
		Note too that possibly bad things can happen if they are still logged in - it SHOULD throw an error when they try to post
		which I'd be happy with.
		--->
		<cfset username = VARIABLES.user.getUsernameFromId(checkMsg.useridfk)>
		<cfif len(username)>
			<cfset VARIABLES.user.deleteUser(username)>
		</cfif>

		<!--- get the thread, if 0, we kill it --->
		<cfset thread = VARIABLES.thread.getThread(checkMsg.threadidfk)>
		<cfif thread.messages is 0>
			<cfset VARIABLES.thread.deleteThread(checkMsg.threadidfk)>
		</cfif>

	</cffunction>

	<cffunction name="notifySubscribers" access="private" returnType="string" output="false" hint="Emails subscribers about a new post.">
		<cfargument name="threadid" type="uuid" required="true">
		<cfargument name="threadname" type="string" required="true">
		<cfargument name="forumid" type="uuid" required="true">
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="body" type="string" required="true">
		<cfset var forum = VARIABLES.forum.getForum(ARGUMENTS.forumid)>
		<cfset var conference = VARIABLES.conference.getConference(forum.conferenceidfk)>
		<cfset var subscribers = "">

		<cfset var username = VARIABLES.user.getUser(VARIABLES.user.getUsernameFromId(ARGUMENTS.userid)).username>
		<cfset var fullbody = "">
		<cfset var htmlBody = "">
		<cfset var result = "">

		<!---
			  In order to get our subscribers, we need to get the forum and conference for the thread.
			  Then - anyone who is subscribed to ANY of those guys will get notified, unless the person
			  is #userid#, the originator of the post.
		--->
		<cfquery name="subscribers" datasource="#VARIABLES.dsn#">
		select	distinct forum_subscriptions.useridfk, forum_users.emailaddress
		from	forum_subscriptions, forum_users
		where	(forum_subscriptions.threadidfk = <cfqueryparam value="#ARGUMENTS.threadid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		or		forum_subscriptions.forumidfk = <cfqueryparam value="#ARGUMENTS.forumid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		or		forum_subscriptions.conferenceidfk = <cfqueryparam value="#conference.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">)
		and		forum_subscriptions.useridfk <> <cfqueryparam value="#ARGUMENTS.userid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		and		forum_subscriptions.useridfk = forum_users.id
		</cfquery>

		<cfif subscribers.recordCount>

			<cfprocessingdirective suppresswhitespace="false">
			<cfsavecontent variable="fullbody">
			<cfoutput>
A post has been made to a thread, forum, or conference that you are subscribed to.
You can change your subscription preferences by updating your profile.
You can visit the thread here:

#APPLICATION.PATH.ROOT#/f.messages.cfm?threadid=#ARGUMENTS.threadid#&last##last

Conference: #conference.name#
Forum:	  #forum.name#
Thread:	 #ARGUMENTS.threadname#
User:	   #username#
<cfif VARIABLES.settings.fullemails>
Message:
#wrap(ARGUMENTS.body,80)#
</cfif>

			</cfoutput>
			</cfsavecontent>
			</cfprocessingdirective>

			<cfif VARIABLES.settings.fullemails>

				<!--- Calling a custom tag from a CFC. Is that crazy? Hell yeah! I considering creating a CFC service wrapper. And I may still. --->
				<cfmodule template="#APPLICATION.PATH.ROOT#/forum/tags/DP_ParseBBML.cfm" input="#body#" outputvar="result" convertsmilies="true" usecf_coloredcode="true" smileypath="images/Smilies/Default/">

				<cfprocessingdirective suppresswhitespace="false">
				<cfsavecontent variable="htmlbody">
				<cfoutput>
	A post has been made to a thread, forum, or conference that you are subscribed to.<br/>
	You can change your subscription preferences by updating your profile.<br/>
	You can visit the thread here:<br/>
	<br/>
	#APPLICATION.PATH.ROOT#/f.messages.cfm?threadid=#ARGUMENTS.threadid#&last##last<br/>

	Conference: #conference.name#<br/>
	Forum:	  #forum.name#<br/>
	Thread:	 #ARGUMENTS.threadname#<br/>
	User:	   #username#<br/>
	Message:<br/>#result.output#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>

			</cfif>
			<!--- The mailService doesn't support queries yet. --->
			<cfloop query="subscribers">
				<cfset VARIABLES.mailService.sendMail(APPLICATION.EMAIL.failto,emailaddress,"#VARIABLES.settings.title# Notification: Post to #ARGUMENTS.threadname#",trim(fullbody),trim(htmlbody))>
			</cfloop>
		</cfif>

		<cfreturn valueList(subscribers.emailaddress)>
	</cffunction>

	<!--- DISABLED! Now that we have bbml. --->
	<cffunction name="renderMessage" access="public" returnType="string" roles="" output="false" hint="This is used to render messages. Handles all string manipulations.">
		<cfargument name="message" type="string" required="true">
		<cfset var counter = "">
		<cfset var codeblock = "">
		<cfset var codeportion = "">
		<cfset var style = "code">
		<cfset var result = "">
		<cfset var newbody = "">
		<cfset var codeBlocks = arrayNew(1)>
		<cfset var imgBlocks = arrayNew(1)>
		<cfset var quoteBlocks = arrayNew(1)>
		<cfset var quoteportion = "">
		<cfset var quotename = "">
		<cfset var quotetag = "">
		<cfset var quoteblock = "">
		<cfset var imgblock = "">
		<cfset var imgportion = "">

		<!--- Add Code Support --->
		<cfif findNoCase("[code]",ARGUMENTS.message) and findNoCase("[/code]",ARGUMENTS.message)>
			<cfset counter = findNoCase("[code]",ARGUMENTS.message)>
			<cfloop condition="counter gte 1">
				<cfset codeblock = reFindNoCase("(?s)(.*)(\[code\])(.*)(\[/code\])(.*)",ARGUMENTS.message,1,1)>
				<cfif arrayLen(codeblock.len) gte 6>
					<cfset codeportion = mid(ARGUMENTS.message, codeblock.pos[4], codeblock.len[4])>
					<cfif len(trim(codeportion))>
						<cfset result = VARIABLES.utils.coloredcode(codeportion, style)>
					<cfelse>
						<cfset result = "">
					</cfif>

					<cfset arrayAppend(codeBlocks,result)>
					<cfset newbody = mid(ARGUMENTS.message, 1, codeblock.len[2]) & "****CODEBLOCK:#arrayLen(codeBlocks)#:KCOLBEDOC****" & mid(ARGUMENTS.message,codeblock.pos[6],codeblock.len[6])>
					<cfset ARGUMENTS.message = newbody>
					<cfset counter = findNoCase("[code]",ARGUMENTS.message,counter)>
				<cfelse>
					<!--- bad crap, maybe <code> and no ender, or maybe </code><code> --->
					<cfset counter = 0>
				</cfif>
			</cfloop>
		</cfif>

		<cfif findNoCase("[img]",ARGUMENTS.message) and findNoCase("[/img]",ARGUMENTS.message)>
			<cfset counter = findNoCase("[img]",ARGUMENTS.message)>
			<cfloop condition="counter gte 1">
				<cfset imgblock = reFindNoCase("(?s)(.*)(\[img\])(.*)(\[/img\])(.*)",ARGUMENTS.message,1,1)>
				<cfif arrayLen(imgblock.len) gte 6>
					<cfset imgportion = mid(ARGUMENTS.message, imgblock.pos[4], imgblock.len[4])>
					<cfif len(trim(imgportion))>
						<cfset result = "<img src=""#imgportion#"">">
					<cfelse>
						<cfset result = "">
					</cfif>

					<cfset arrayAppend(imgBlocks,result)>
					<cfset newbody = mid(ARGUMENTS.message, 1, imgblock.len[2]) & "****IMGBLOCK:#arrayLen(imgBlocks)#:KCOLBGMI****" & mid(ARGUMENTS.message,imgblock.pos[6],imgblock.len[6])>
					<cfset ARGUMENTS.message = newbody>
					<cfset counter = findNoCase("[img]",ARGUMENTS.message,counter)>
				<cfelse>
					<!--- bad crap, maybe <code> and no ender, or maybe </code><code> --->
					<cfset counter = 0>
				</cfif>
			</cfloop>
		</cfif>

		<cfif reFindNoCase("[quote.*?]",ARGUMENTS.message) and findNoCase("[/quote]",ARGUMENTS.message)>
			<cfset counter = reFindNoCase("[quote.*?]",ARGUMENTS.message)>
			<cfloop condition="counter gte 1">
				<cfset quoteblock = reFindNoCase("(?s)(.*)(\[quote.*?\])(.*)(\[/quote\])(.*)",ARGUMENTS.message,1,1)>
				<cfif arrayLen(quoteblock.len) gte 6>
					<!--- look for name="" in the tag --->
					<!--- so the tag is pos 3 --->
					<cfset quotetag = mid(ARGUMENTS.message, quoteblock.pos[3], quoteblock.len[3])>
					<cfif findNoCase("name=", quotetag)>
						<cfset quotename = rereplace(quotetag, ".*?name=""(.+?)"".*\]", "\1")>
					</cfif>
					<cfset quoteportion = mid(ARGUMENTS.message, quoteblock.pos[4], quoteblock.len[4])>
					<cfif len(trim(quoteportion))>
						<cfif len(quotename)>
							<cfset result = "<blockquote><div class=""bqheader"">#quotename# said:</div>#quoteportion#</blockquote>">
						<cfelse>
							<cfset result = "<blockquote>#quoteportion#</blockquote>">
						</cfif>
					<cfelse>
						<cfset result = "">
					</cfif>

					<cfset arrayAppend(quoteBlocks,result)>
					<cfset newbody = mid(ARGUMENTS.message, 1, quoteblock.len[2]) & "****QUOTEBLOCK:#arrayLen(quoteBlocks)#:KCOLBETOUQ****" & mid(ARGUMENTS.message,quoteblock.pos[6],quoteblock.len[6])>
					<cfset ARGUMENTS.message = newbody>
					<cfset counter = reFindNoCase("[quote.*?]",ARGUMENTS.message,counter)>
				<cfelse>
					<!--- bad crap, maybe <code> and no ender, or maybe </code><code> --->
					<cfset counter = 0>
				</cfif>
			</cfloop>
		</cfif>

		<!--- now htmlecode --->
		<cfset ARGUMENTS.message = htmlEditFormat(ARGUMENTS.message)>

		<!--- turn on URLs --->
		<cfset ARGUMENTS.message = VARIABLES.utils.activeURL(ARGUMENTS.message)>

		<!--- now put those blocks back in --->
		<cfloop index="counter" from="1" to="#arrayLen(codeBlocks)#">
			<cfset ARGUMENTS.message = replace(ARGUMENTS.message,"****CODEBLOCK:#counter#:KCOLBEDOC****", codeBlocks[counter])>
		</cfloop>
		<cfloop index="counter" from="1" to="#arrayLen(imgBlocks)#">
			<cfset ARGUMENTS.message = replace(ARGUMENTS.message,"****IMGBLOCK:#counter#:KCOLBGMI****", imgBlocks[counter])>
		</cfloop>
		<cfloop index="counter" from="1" to="#arrayLen(quoteBlocks)#">
			<cfset ARGUMENTS.message = replace(ARGUMENTS.message,"****QUOTEBLOCK:#counter#:KCOLBETOUQ****", quoteBlocks[counter])>
		</cfloop>

		<!--- add Ps --->
		<cfset ARGUMENTS.message = VARIABLES.utils.paragraphFormat2(ARGUMENTS.message)>

		<cfreturn ARGUMENTS.message>
	</cffunction>

	<cffunction name="renderHelp" access="public" returnType="string" roles="" output="false" hint="This is used to return help for message editing.">
		<cfset var msg = "">

		<cfsavecontent variable="msg">
<a href="f.syntax.cfm">View Complete BBML Syntax</a> ~ Basic Formatting Rules:<br />
<table cellspacing="10">
	<tbody>
		<tr valign="top">
			<td>
				[b]...[/b] for bold<br />
				[i]...[/i] for italics<br />
				[code]...[/code] for code<br />
			</td>
			<td>
				[pre]...[/pre] for preformatted text<br />
				[link]...[/link] for URLs<br />
				[img]...[/img] for images<br />
			</td>
		</tr>
		<tr>
			<td colspan="2">
				[attachment]...[/attachment] will link to your attachment if one exists. If your attachment is an image, it will be displayed inline.
			</td>
		</tr>
	</tbody>
</table>
<p class="credit_ref">
	<a href="http://markitup.jaysalvat.com/home/">Markup editor by  Jay Salvat</a>
</p>
		</cfsavecontent>

		<cfreturn msg>
	</cffunction>

	<cffunction name="saveMessage" access="remote" returnType="void" roles="" output="false" hint="Saves an existing message.">
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="message" type="struct" required="true">
		<cfset var bodyreplace = "">
		<cfset var theNow = now()>
		<cfset var CRNL = CHR(13)&CHR(10)>
		<cfif not validMessage(ARGUMENTS.message)>
			<cfset VARIABLES.utils.throw("Message CFC","Invalid data passed to saveMessage.")>
		</cfif>
<!---
		<!--- // Remove "old" Last Updated by if there is one --->
		<cfset bodyreplace = rereplace(ARGUMENTS.message.body,'\n\[i\]\* Last updated by: .* \*\[\/i\]','','ALL')>
		<!--- // Insert "new" Last Updated by --->
		<cfset ARGUMENTS.message.body = bodyreplace & "#CRNL#[i]* Last updated by: #SESSION.USER.user# on #dateFormat(theNow,'m/d/yyyy')# @ #timeFormat(theNow,'h:mm tt')# *[/i]">
 --->
		<cfquery datasource="#VARIABLES.dsn#">
			update forum_messages
				set title = <cfqueryparam value="#ARGUMENTS.message.title#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					 body = <cfqueryparam value="#ARGUMENTS.message.body#" cfsqltype="CF_SQL_LONGVARCHAR">,
					 threadidfk = <cfqueryparam value="#ARGUMENTS.message.threadidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
					 useridfk = <cfqueryparam value="#ARGUMENTS.message.useridfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
					 posted = <cfqueryparam value="#ARGUMENTS.message.posted#" cfsqltype="CF_SQL_TIMESTAMP">,
					 attachment = <cfqueryparam value="#ARGUMENTS.message.attachment#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					 filename = <cfqueryparam value="#ARGUMENTS.message.filename#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					 updated = <cfqueryparam value="#theNow#" cfsqltype="CF_SQL_TIMESTAMP">,
					 updatedby = <cfqueryparam value="#SESSION.USER.user#" cfsqltype="CF_SQL_VARCHAR" maxlength="20">
			where	id = <cfqueryparam value="#ARGUMENTS.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

	</cffunction>

	<cffunction name="search" access="remote" returnType="query" output="false" hint="Allows you to search messages.">
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
			select	m.id, m.title, m.threadidfk, t.forumidfk, f.conferenceidfk, t.name as thread, f.name as forum, c.name as conference
			from	forum_messages m, forum_threads t,
					forum_forums f, forum_conferences c
			where	m.threadidfk = t.id
			and		t.forumidfk = f.id
			and		f.conferenceidfk = c.id
			and (
				<cfif ARGUMENTS.searchtype is not "phrase">
					<cfloop index="x" from=1 to="#arrayLen(aTerms)#">
						(title like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(aTerms[x],255)#%">
						or
						 body like '%#aTerms[x]#%'
						)
						 <cfif x is not arrayLen(aTerms)>#joiner#</cfif>
					</cfloop>
				<cfelse>
					title like <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="%#left(ARGUMENTS.searchTerms,255)#%">
					or
					body like '%#ARGUMENTS.searchTerms#%'
				</cfif>
			)
			group by c.id, c.name, f.id, f.name, f.conferenceidfk, t.id, t.name, t.forumidfk, m.id, m.title, m.threadidfk
		</cfquery>

		<cfreturn results>
	</cffunction>

	<cffunction name="validMessage" access="private" returnType="boolean" output="false" hint="Checks a structure to see if it contains all the proper keys/values for a forum.">

		<cfargument name="cData" type="struct" required="true">
		<cfset var rList = "title,body">
		<cfset var x = "">

		<cfloop index="x" list="#rList#">
			<cfif not structKeyExists(cData,x)>
				<cfreturn false>
			</cfif>
		</cfloop>

		<cfreturn true>

	</cffunction>

	<cffunction name="setMailService" access="public" output="No" returntype="void">
		<cfargument name="mailservice" required="true" hint="thread">
		<cfset VARIABLES.mailservice = ARGUMENTS.mailservice />
	</cffunction>

	<cffunction name="setSettings" access="public" output="No" returntype="void">
		<cfargument name="settings" required="true" hint="Setting">
		<cfset VARIABLES.dsn = APPLICATION.DSN.FORUM>
		<cfset VARIABLES.settings = ARGUMENTS.settings.getSettings()>
	</cffunction>

	<cffunction name="setUtils" access="public" output="No" returntype="void">
		<cfargument name="utils" required="true" hint="utils">
		<cfset VARIABLES.utils = ARGUMENTS.utils />
	</cffunction>

	<cffunction name="setThread" access="public" output="No" returntype="void">
		<cfargument name="thread" required="true" hint="thread">
		<cfset VARIABLES.thread = ARGUMENTS.thread />
	</cffunction>

	<cffunction name="setForum" access="public" output="No" returntype="void">
		<cfargument name="forum" required="true" hint="forum">
		<cfset VARIABLES.forum = ARGUMENTS.forum />
	</cffunction>

	<cffunction name="setUser" access="public" output="No" returntype="void">
		<cfargument name="user" required="true" hint="user" />
		<cfset VARIABLES.user = ARGUMENTS.user />
	</cffunction>

	<cffunction name="setConference" access="public" output="No" returntype="void">
		<cfargument name="conference" required="true" hint="conference" />
		<cfset VARIABLES.conference = ARGUMENTS.conference />
	</cffunction>

</cfcomponent>