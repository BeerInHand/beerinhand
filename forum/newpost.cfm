<cfsetting enablecfoutputonly = true />
<cfprocessingdirective pageencoding="utf-8" />
<cfif not SESSION.LoggedIn>
	<cfif not structIsEmpty(form)>
		<cfset SESSION.oldform = duplicate(form) /><!--- remember any form info --->
	</cfif>
	<cfset thisPage = CGI.script_name & "?" & CGI.query_string />
	<cflocation url="p.login.cfm?ref=#urlEncodedFormat(thisPage)#" addToken="false">
</cfif>
<cfif not isDefined("URL.forumid") or not len(URL.forumid)>
	<cflocation url="f.index.cfm" addToken="false">
</cfif>
<!--- checks to see if we can post --->
<cfset blockedAttempt = false>
<!--- get parents --->
<cftry>
	<cfset REQUEST.forum = APPLICATION.FORUM.Forums.getForum(URL.forumid)>
	<cfset REQUEST.conference = APPLICATION.FORUM.Conference.getConference(REQUEST.forum.conferenceidfk)>
	<cfif not APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANPOST, URL.forumid, REQUEST.udf.getGroups()) or not APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANPOST, REQUEST.conference.id, REQUEST.udf.getGroups())>
		<cfset blockedAttempt = true>
	</cfif>
	<cfcatch>
		<cflocation url="f.index.cfm" addToken="false">
	</cfcatch>
</cftry>
<cfif structKeyExists(session, "oldForm")>
	<cfif structKeyExists(SESSION.oldForm, "body")>
		<cfset form.body = SESSION.oldForm.body>
	</cfif>
	<cfif structKeyExists(SESSION.oldForm, "title")>
		<cfset form.title = SESSION.oldForm.title>
	</cfif>
	<cfset structDelete(session, "oldForm")>
</cfif>
<cfparam name="form.title" default="">
<cfparam name="form.body" default="">
<cfparam name="form.subscribe" default="false">
<cfparam name="form.oldattachment" default="">
<cfparam name="form.attachment" default="">
<cfparam name="form.filename" default="">
<cfparam name="form.sticky" default="false">
<cfif isDefined("form.post") and not blockedAttempt>
	<cfset errors = "">
	<!--- clean the fields --->
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
		<cfset args.forumid = URL.forumid>
		<cfif isUserInRole("forumsadmin")>
			<cfset args.sticky = form.sticky>
		</cfif>
		<cfset msgid = APPLICATION.FORUM.Message.addMessage(argumentCollection=args)>
		<!--- get the message so we can get thread id --->
		<cfset message = APPLICATION.FORUM.Message.getMessage(msgid)>
		<cfif form.subscribe>
			<cfset APPLICATION.FORUM.User.subscribe(getAuthUser(), "thread", message.threadidfk)>
		</cfif>
		<!--- clear my user info --->
		<cfset uinfo = REQUEST.udf.cachedUserInfo(getAuthUser(), false)>
		<cflocation url="f.messages.cfm?threadid=#message.threadidfk#" addToken="false">
	</cfif>
</cfif>
<cfmodule template="tags/layout.cfm" templatename="main" title="#APPLICATION.FORUM.SETTING.title# : New Post"><!--- Loads header --->
	<cfoutput>
	<cfif isDefined("errors") and len(errors)>
		<div class="row_0">
			<div class="clearer"></div>
			<p>Please correct the following error(s):</p>
			<div class="submit_error"><p><b>#errors#</b></p></div><br />
		</div>
	</cfif>
	<div class="ui-widget-header post_title">New Post</div>
	<div class="ui-widget-content">
		<form action="#CGI.script_name#?#CGI.query_string#" method="post" enctype="multipart/form-data">
			<cfinclude template="#APPLICATION.PATH.ROOT#/cfformprotect/cffp.cfm">
			<input type="hidden" name="post" value="1">
			<cfif not blockedAttempt>
				<table class="datagrid noborder" cellspacing="0">
					<tbody class="bih-grid-form nobevel">
					<cfif isUserInRole("forumsadmin")><!--- only admins may make sticky posts --->
						<tr>
							<td class="label">Sticky:</td>
							<td><input type="checkbox" name="sticky" value="true" <cfif form.sticky>checked</cfif>></td>
						</tr>
					</cfif>
						<tr>
							<td width="75" class="label required">Title:</td>
							<td><input type="text" name="title" value="#form.title#" class="input_box_wide"></td>
						</tr>
						<tr>
							<td class="label required">Body:</td>
							<td><textarea id="markitup" class="textarea_markup" name="body">#form.body#</textarea></td>
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
			<cfelse>
				<div class="row_0">
					<div class="clearer"></div>
					<p><b>Sorry, but you may not post here.</b></p>
				</div>
			</cfif>
		</form>
	</div>
	<br/>
	<div class="forum_post_markitup">
		<p>#APPLICATION.FORUM.Message.renderHelp()#</p>
	</div>
	</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly = false />
