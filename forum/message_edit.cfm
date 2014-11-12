<cfsetting enablecfoutputonly = true />
<cfif not isDefined("URL.id") or not len(URL.id)><cflocation url="f.index.cfm" addToken="false"></cfif>
<cftry>
	<cfset REQUEST.message = APPLICATION.FORUM.Message.getMessage(URL.id)>
	<cfcatch>
		<cflocation url="f.index.cfm" addToken="false">
	</cfcatch>
</cftry>
<cftry><!--- get parents --->
	<cfset REQUEST.message = APPLICATION.FORUM.Message.getMessage(URL.id)>
	<cfset REQUEST.thread = APPLICATION.FORUM.Thread.getThread(REQUEST.message.threadidfk)>
	<cfset REQUEST.forum = APPLICATION.FORUM.Forums.getForum(REQUEST.thread.forumidfk)>
	<cfset REQUEST.conference = APPLICATION.FORUM.Conference.getConference(REQUEST.forum.conferenceidfk)>
	<cfcatch>
		<cflocation url="f.index.cfm" addToken="false">
	</cfcatch>
</cftry>
<cfif not SESSION.LoggedIn><!--- Must be logged in. --->
	<cflocation url="f.index.cfm" addToken="false">
</cfif>
<!--- Am I allowed to edit here? --->
<cfif APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANEDIT, REQUEST.forum.id, REQUEST.udf.getGroups()) and APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANEDIT, REQUEST.conference.id, REQUEST.udf.getGroups())>
	<cfset canEdit = true />
<cfelse>
	<cfset canEdit = false />
</cfif>
<!--- ignore canedit if I have canPost and it's my post --->
<!--- Am I allowed to post here? --->
<cfif APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANPOST, REQUEST.forum.id, REQUEST.udf.getGroups()) and APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANPOST, REQUEST.conference.id, REQUEST.udf.getGroups())>
	<cfset canPost = true />
<cfelse>
	<cfset canPost = false />
</cfif>
<cfif not canEdit and not (canPost and REQUEST.message.useridfk eq SESSION.USER.FORUM.id)>
	<cflocation url="f.index.cfm" addToken="false" />
</cfif>
<cfparam name="form.title" default="#REQUEST.message.title#" />
<cfparam name="form.body" default="#REQUEST.message.body#" />
<cfparam name="form.oldattachment" default="#REQUEST.message.attachment#" />
<cfparam name="form.filename" default="#REQUEST.message.filename#" />
<cfparam name="form.attachment" default="" />
<!--- <cfset form.body = rereplace(form.body,'\n\[i\]\* Last updated by: .* on .* @ .* \*\[\/i\]','','ALL') /> --->
<cfif isDefined("form.post")>
	<cfset errors = "" />
	<!--- clean the fields --->
	<cfset form.title = trim(htmlEditFormat(form.title)) />
	<cfset form.body = trim(form.body) />
	<cfif not len(form.title)>
		<cfset errors = errors & "You must enter a title.<br>" />
	</cfif>
	<cfif not len(form.body)>
		<cfset errors = errors & "You must enter a body.<br>">
	</cfif>
	<cfif len(form.title) gt 50>
		<cfset errors = errors & "Your title is too long.<br>">
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
	<cfelseif structKeyExists(form, "removefile")>
		<cfset form.attachment = "">
		<cffile action="delete" file="#APPLICATION.DISK.ATTACH#\#form.filename#">
		<cfset form.filename = "">
	<cfelseif len(form.oldattachment)>
		<cfset form.attachment = form.oldattachment>
	</cfif>
	<cfif not len(errors)>
		<cfset message = structNew()>
		<cfset message.title = trim(htmlEditFormat(form.title))>
		<cfset message.body = trim(form.body)>
		<cfset message.attachment = form.attachment>
		<cfset message.filename = form.filename>
		<cfset message.posted = REQUEST.message.posted>
		<cfset message.threadidfk = REQUEST.message.threadidfk>
		<cfset message.useridfk = REQUEST.message.useridfk>
		<cfset APPLICATION.FORUM.Message.saveMessage(URL.id, message)>
		<cflocation url="f.messages.cfm?threadid=#message.threadidfk#" addToken="false">
	</cfif>
</cfif>
<cfmodule template="tags/layout.cfm" templatename="main" title="#APPLICATION.FORUM.SETTING.title# : Edit Post"><!--- Loads header --->
	<cfoutput>
	<cfif isDefined("errors")>
		<div class="row_1">
			<p>Please correct the following error(s):</p>
			<div class="submit_errors"><p><b>#errors#</b></p></div>
		</div>
	</cfif>
	<div class="ui-widget-header post_title">Edit Post</div>
	<div class="ui-widget-content">
		<form action="#CGI.script_name#?#CGI.query_string#" method="post" enctype="multipart/form-data">
			<input type="hidden" name="post" value="1">
			<table class="datagrid noborder" cellspacing="0">
				<tbody class="bih-grid-form nobevel">
					<tr>
						<td width="75" class="label required">Title:</td>
						<td><input type="text" name="title" value="#form.title#" class="input_box_wide"></td>
					</tr>
					<tr>
						<td class="label required">Body:</td>
						<td><textarea id="markitup" class="textarea_markup" name="body">#form.body#</textarea></td>
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
								<br><label>Remove Attachment <input type="checkbox" name="removefile"></label>
							</cfif>
						</td>
					</tr>
				</cfif>
				</tbody>
			</table>
			<div class="post_buttons ui-widget-content ui-corner-all">
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-pencilpad" submit="true" name="post" text="Update Post"/>
			</div>
		</form>
	</div>
	</cfoutput>
</cfmodule><!--- Loads footer --->
<cfsetting enablecfoutputonly = false />