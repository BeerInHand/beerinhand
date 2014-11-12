<cfsetting enablecfoutputonly = true />
<cfif not isDefined("URL.threadid") or not len(URL.threadid)>
	<cflocation url="f.index.cfm" addToken="false">
</cfif>
<cftry><!--- get parents --->
	<cfset REQUEST.thread = APPLICATION.FORUM.Thread.getThread(URL.threadid)>
	<cfset REQUEST.forum = APPLICATION.FORUM.Forums.getForum(REQUEST.thread.forumidfk)>
	<cfset REQUEST.conference = APPLICATION.FORUM.Conference.getConference(REQUEST.forum.conferenceidfk)>
	<cfcatch>
		<cflocation url="f.index.cfm" addToken="false">
	</cfcatch>
</cftry>
<!--- Am I allowed to look at this? --->
<cfif not APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, REQUEST.forum.id, REQUEST.udf.getGroups()) or not APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, REQUEST.conference.id, REQUEST.udf.getGroups())>
	<cflocation url="f.denied.cfm" addToken="false">
</cfif>
<!--- Am I allowed to post here? --->
<cfif APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANPOST, REQUEST.forum.id, REQUEST.udf.getGroups()) and APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANPOST, REQUEST.conference.id, REQUEST.udf.getGroups())>
	<cfset canPost = true>
<cfelse>
	<cfset canPost = false>
</cfif>
<!--- Am I allowed to edit here? --->
<cfif APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANEDIT, REQUEST.forum.id, REQUEST.udf.getGroups()) and APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANEDIT, REQUEST.conference.id, REQUEST.udf.getGroups())>
	<cfset canEdit = true>
<cfelse>
	<cfset canEdit = false>
</cfif>
<!--- handle new post --->
<cfparam name="form.title" default="RE: #REQUEST.thread.name#">
<cfparam name="form.body" default="">
<cfparam name="form.subscribe" default="false">
<cfparam name="form.oldattachment" default="">
<cfparam name="form.attachment" default="">
<cfparam name="form.filename" default="">
<cfparam name="form.username" default="">
<cfif isDefined("form.post") and canPost>
	<cfset errors = "">
	<!--- clean the fields --->
	<!--- Added the params since its possible someone could remove them. --->
	<cfparam name="form.title" default="">
	<cfparam name="form.body" default="">
	<cfset form.title = trim(htmlEditFormat(form.title))>
	<cfset form.body = trim(form.body)>
	<cfif not len(form.title)>
		<cfset errors = errors & "You must enter a title.<br>">
	</cfif>
	<cfif not len(form.body)>
		<cfset errors = errors & "You must enter a body.<br>">
	</cfif>
	<cfif len(form.title) gt 255>
		<cfset errors = errors & "Your title is too long.<br>">
	</cfif>
	<cfif not APPLICATION.CFC.Factory.get("CFFP").testSubmission(form)>
		<cfset errors = errors & "Your post has been flagged as spam.<br>">
	</cfif>
	<cfif isBoolean(REQUEST.forum.attachments) and REQUEST.forum.attachments and len(trim(form.attachment))>
		<cffile action="upload" destination="#APPLICATION.DISK.TEMP#" filefield="attachment" nameConflict="makeunique">
		<cfif cffile.fileWasSaved>
			<!--- Is the extension allowed? --->
			<cfset newFileName = cffile.serverDirectory & "/" & cffile.serverFile>
			<cfset newExtension = cffile.serverFileExt>
			<cfif not listFindNoCase(APPLICATION.FORUM.SETTING.safeExtensions, newExtension)>
				<cfset errors = errors & "Your file did not have a valid extension. Allowed extensions are: #APPLICATION.FORUM.SETTING.safeExtensions#.<br>">
				<cffile action="delete" file="#newFilename#">
				<cfset form.attachment = "">
				<cfset form.filename = "">
			<cfelse>
				<!--- give it a new uuid but remember it. yes I called it newNew. I rock like that. --->
				<cfset newNewName = APPLICATION.DISK.ATTACH & "/" & createUUID() & "." & newExtension>
				<cffile action="move" source="#newFileName#" destination="#newNewName#">
				<cfset form.oldattachment = cffile.clientFile>
				<cfset form.attachment = cffile.clientFile>
				<cfset form.filename = getFileFromPath(newNewName)>
			</cfif>
		</cfif>
	<cfelseif len(form.oldattachment)>
		<cfset form.attachment = form.oldattachment>
	</cfif>
	<cfif not len(errors)>
		<cfset message = structNew()>
		<cfset message.title = form.title>
		<cfset message.body = form.body>
		<cfset message.attachment = form.attachment>
		<cfset message.filename = form.filename>
		<cfset args = structNew()>
		<cfset args.message = message>
		<cfset args.forumid = REQUEST.forum.id>
		<cfset args.threadid = URL.threadid>
		<cfset msgid = APPLICATION.FORUM.Message.addMessage(argumentCollection=args)>
		<cfif form.subscribe>
			<cfset APPLICATION.FORUM.User.subscribe(getAuthUser(), "thread", URL.threadid)>
		</cfif>
		<!--- clear my user info --->
		<cfset uinfo = REQUEST.udf.cachedUserInfo(getAuthUser(), false)>
		<cflocation url="f.messages.cfm?threadid=#URL.threadid#&last=true" addToken="false">
	</cfif>
</cfif>
<cfset qs = replaceList(CGI.query_string,"<,>",",")><!--- clean up possible CSS attack --->
<cfset mdata = APPLICATION.FORUM.Message.getMessages(threadid=REQUEST.thread.id)><!--- get my messages --->
<cfset data = mdata.data>
<cfmodule template="tags/layout.cfm" templatename="main" title="#APPLICATION.FORUM.SETTING.title# : #REQUEST.conference.name# : #REQUEST.forum.name# : #REQUEST.thread.name#"><!--- Loads header --->
	<cfif data.recordCount and data.recordCount gt APPLICATION.FORUM.SETTING.perpage><!--- determine max pages --->
		<cfset pages = ceiling(data.recordCount / APPLICATION.FORUM.SETTING.perpage)>
	<cfelse>
		<cfset pages = 1>
	</cfif>
	<!---
	We need to be able to go to a page if a specific msg is requested. In normal browsing we handle this by passing page, but
	we don't know the page when searching. We can skip this if pages == 1
	--->
	<cfif structKeyExists(url, "mid") and pages gt 1>
		<cfloop query="data">
			<cfif URL.mid is id>
				<cfif currentRow lte APPLICATION.FORUM.SETTING.perpage>
					<cfset URL.page = 1>
				<cfelse>
					<cfset URL.page = ((currentRow - (currentRow mod APPLICATION.FORUM.SETTING.perpage)) / APPLICATION.FORUM.SETTING.perpage)+1>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
	<cfif structKeyExists(url, "last")><!--- last page cheat --->
		<cflocation url="f.messages.cfm?threadid=#URL.threadid#&page=#pages#&###data.recordCount#" addToken="false">
	</cfif>
	<!--- Displays pagination on right side, plus left side buttons for threads --->
	<cfmodule template="tags/pagination.cfm" pages="#pages#" mode="messages" canPost="#canPost#" />
	<!--- Now display the table. This changes based on what our data is. --->
	<cfoutput>
	<div class="ui-widget-header post_title">
		<a name="top"></a>&nbsp;&nbsp; #REQUEST.thread.name#
		<div class="font8 normal gray right right_30">Thread Started: #udfUserDateFormat(REQUEST.thread.dateCreated)# #timeFormat(REQUEST.thread.dateCreated,"hh:mm tt")# / #udfAddSWithCnt("Reply", max(0,data.recordCount-1))#</div>
	</div>
	<div class="ui-widget-content">
		<cfif data.recordCount>
			<cfloop query="data" startrow="#(URL.page-1)*APPLICATION.FORUM.SETTING.perpage+1#" endrow="#(URL.page-1)*APPLICATION.FORUM.SETTING.perpage+APPLICATION.FORUM.SETTING.perpage#">
				<cfset uinfo = REQUEST.udf.cachedUserInfo(username)>
				<div class="forum_post">
					<div class="forum_post_identity">
						<div class="row head user">
							<cfif SESSION.LoggedIn and APPLICATION.FORUM.SETTING.allowpms and username neq getAuthUser()>
								<a href="f.sendpm.cfm?user=#urlEncodedFormat(username)#">#username#</a>
							<cfelse>
								#username#
							</cfif>
						</div>
						<div class="row center">
							<cfif uinfo.avatar is "@gravatar">
								<img class="forumAvatar" src="http://www.gravatar.com/avatar.php?gravatar_id=#lcase(hash(uinfo.emailaddress))#&amp;rating=PG&amp;size=150&amp;default=#APPLICATION.PATH.AVATARS#/zombatar.jpg" title="#username#'s Gravatar">
							<cfelseif len(uinfo.avatar)>
								<img class="forumAvatar" src="#APPLICATION.PATH.AVATARS#/#uinfo.avatar#" title="#username#'s Avatar">
							</cfif>
						</div>
						<div class="row"><span class="head lab">Joined:</span><span>#udfUserDateFormat(uInfo.dateCreated)#</span></div>
						<div class="row"><span class="head lab">Posts:</span><span>#numberFormat(uInfo.postcount)#</span></div>
						<div class="row"><span class="head lab">Rank:</span><span>#uInfo.rank#</span></div>
					</div>
					<div class="forum_post_right keep_on">
						<div class="forum_post_title">
							<div class="left_60">
								<p>
									<a name="#currentRow#"></a><cfif currentRow is recordCount><a name="last"></a></cfif>
									<span class="bold">#title#</span>
								</p>
							</div>
							<div class="font8 right right_30"><p>Posted: #udfUserDateFormat(posted, SESSION.SETTING.DateMask)# #timeFormat(posted,"hh:mm tt")#</p></div>
						</div>
						<div class="forum_post_content">
								<cfmodule template="tags/DP_ParseBBML.cfm" input="#body#" outputvar="result" convertsmilies="true" usecf_coloredcode="true" smileypath="images/Smilies/Default/" attachment="#attachment#" attachmenturl="attachment.cfm?id=#id#">
								<div class="post_content">
								#result.output#
								</div>
								<cfif len(uinfo.signature)>
									<cfset sig = uinfo.signature>
									<cfset sig = replaceList(sig, "#chr(10)#,#chr(13)#","<br>,<br>")>
									<cfset sig = replace(uinfo.signature,chr(13)&chr(10),chr(10),"ALL")>
									<cfset sig = replace(sig,chr(13),chr(10),"ALL")>
									<cfset sig = replace(sig,chr(10),"<br />","ALL")>
									<cfmodule template="tags/DP_ParseBBML.cfm" input="#sig#" outputvar="result" convertsmilies="true" usecf_coloredcode="true" smileypath="images/Smilies/Default/">
									<div class="signature">#result.output#</div>
								</cfif>
						</div>
						<cfif len(attachment)>
							<div class="forum_post_attach">
								<div class="left_50"><p><a href="f.attachment.cfm?id=#id#"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="bih-icon bih-icon-attach" title="Attached File"> #attachment#</a></p></div>
								<div class="right_40 right"><p>&nbsp;</p></div>
							</div>
						</cfif>
						<cfif isBoolean(CGI.server_port_secure) and CGI.server_port_secure><cfset pre = "https"><cfelse><cfset pre = "http"></cfif>
						<cfset link = "#pre#://#CGI.server_name##CGI.script_name#?#qs####currentrow#">
						<div class="forum_post_links<cfif isDate(updated)> updated</cfif>">
							<div class="left_50">
						<cfif isDate(updated)>
							<div class="forum_post_updated blue">
								This posted was updated #udfUserDateFormat(updated, SESSION.SETTING.DateMask)# #timeFormat(updated,"hh:mm tt")# by #updatedby#
							</div>
						</cfif>
							</div>
							<div class="right_40 right">
								<p>
									<cfif canEdit or (SESSION.LoggedIn and canPost and data.useridfk eq SESSION.USER.FORUM.id)>
										<a href="f.message_edit.cfm?id=#id#"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="bih-icon bih-icon-pencil" title="Edit"></a> |
									</cfif>
									<a href="#link#"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="bih-icon bih-icon-link" title="Permalink"></a> |
									<a href="##top"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="bih-icon bih-icon-top" title="Top"></a> |
									<a href="##bottom"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="bih-icon bih-icon-bottom" title="Bottom"></a>
								</p>
							</div>
						</div>
					</div>
					<div class="clearer"></div>
				</div>
			</cfloop>
		<cfelse>
			<div class="row_1"><p>Sorry, but there are no messages available for this thread.</p></div>
		</cfif>
		<a name="bottom" /></a>
	</div>
	<cfmodule template="tags/pagination.cfm" pages="#pages#" mode="messages" canPost="#canPost#" /><!--- Displays pagination on right side, plus left side buttons for threads --->
	<cfif isDefined("errors") and len(errors)>
		<div class="row_0">
			<div class="clearer"></div>
			<p>Please correct the following error(s):</p>
			<div class="submit_error"><p><b>#errors#</b></p></div><br />
		</div>
	</cfif>
	<div class="ui-widget-header post_title"><a name="newpost"></a>New Post</div>
	<div class="ui-widget-content">
		<cfif not SESSION.LoggedIn>
			<cfset thisPage = CGI.script_name & "?" & CGI.query_string & "&##newpost">
			<div class="row_0">
				<div class="left_90"><p>Please <a href="f.login.cfm?ref=#urlEncodedFormat(thisPage)#">login</a> to post a response.</p></div>
			</div>
		<cfelseif canPost>
			<form action="#CGI.script_name#?#qs#&##newpost" method="post" enctype="multipart/form-data">
				<cfinclude template="#APPLICATION.PATH.ROOT#/cfformprotect/cffp.cfm">
				<input type="hidden" name="post" value="1">
				<table class="datagrid noborder" cellspacing="0">
					<tbody class="bih-grid-form nobevel">
						<tr>
							<td width="75" class="label required">Title:</td>
							<td><input type="text" name="title" value="#form.title#" class="input_box_wide"></td>
						</tr>
						<tr>
							<td class="label required">Body:</td>
							<td><textarea id="markitup" class="textarea_markup" name="body" cols="100" rows="20">#form.body#</textarea></td>
						</tr>
						<tr>
							<td class="label">Subscribe:</td>
							<td><input type="checkbox" name="subscribe" value="true" <cfif form.subscribe>checked</cfif>></td>
						</tr>
					<cfif isBoolean(REQUEST.forum.attachments) and REQUEST.forum.attachments>
						<tr>
							<td class="label">Attach File:</td>
							<td>
								<input type="file" name="attachment">
								<cfif len(form.oldattachment)>
									<input type="hidden" name="oldattachment" value="#form.oldattachment#">
									<input type="hidden" name="filename" value="#form.filename#">
									<br>File already attached: #form.oldattachment#
								</cfif>
							</td>
						</tr>
					</cfif>
					</tbody>
				</table>
				<div class="post_buttons ui-widget-content ui-corner-all">
					<cfif not isDefined("REQUEST.thread")>
						<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" submit="true" class="ui-button-text-tiny" src="bih-icon bih-icon-pencilpad" name="post" text="Post New Topic"/>
					<cfelse>
						<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" submit="true" class="ui-button-text-tiny" src="bih-icon bih-icon-pencilpad" name="post" text="Post Reply"/>
					</cfif>
				</div>
			</form>
		<cfelse>
			<div class="row_0">
				<div class="clearer"></div>
				<p><b>Sorry, but you may not post here.</b></p>
			</div>
		</cfif>
	</div>
	<div class="forum_post_markitup">
		<p>#APPLICATION.FORUM.Message.renderHelp()#</p>
	</div>
	<!-- Edit Message Container Ender -->
	</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly = false />
