<cfsetting enablecfoutputonly = true />
<cfif not SESSION.LoggedIn>
	<cfset thisPage = CGI.script_name & "?" & CGI.query_string>
	<cflocation url="p.login.cfm?ref=#urlEncodedFormat(thisPage)#" addToken="false">
</cfif>
<cfset data = APPLICATION.FORUM.User.getPrivateMessage(URL.id,getAuthUser())>
<cfparam name="form.subject" default="RE: #data.subject#">
<cfparam name="form.body" default="">
<cfif structKeyExists(form, "send")>
	<cfset errors = "">
	<cfif not len(form.subject)>
		<cfset errors = errors & "You did not specify a subject for your message.<br/>">
	</cfif>
	<cfif not len(form.body)>
		<cfset errors = errors & "You did not specify a body for your message.<br/>">
	</cfif>
	<cfif not len(errors)>
		<!--- Send the PM --->
		<cfset showForm = false>
		<cfset APPLICATION.FORUM.User.sendPrivateMessage(to=data.sender,from=getAuthUser(), subject=form.subject, body=form.body)>
		<cfset form.body = "">
		<cfset form.subject = "RE: #data.subject#">
		<cfset msgSent = true>
	</cfif>
</cfif>
<cfmodule template="tags/layout.cfm" templatename="main" title="#APPLICATION.FORUM.SETTING.title# : Private Message : #data.subject#"><!--- Loads header --->
	<cfoutput>
	<div class="ui-widget-header post_title">
		<p>
		Subject: #data.subject#<br/>
		Sender: #data.sender#<br/>
		Sent: #dateFormat(data.sent,"m/d/yy")# #timeFormat(data.sent,"h:mm tt")#
		</p>
	</div>
	<div class="ui-widget-content pad10">
		#paragraphformat(data.body)#
	</div>
	<br/>
	<cfif isDefined("errors") and len(errors)>
		<div class="row_0">
			<div class="clearer"></div>
			<p>Please correct the following error(s):</p>
			<div class="submit_error"><p><b>#errors#</b></p></div><br />
		</div>
	<cfelseif structKeyExists(variables, "msgSent")>
		<div class="row_0">
			<div class="clearer"></div>
			<p>Your reply has been sent.</p>
		</div>
	</cfif>
	<div class="ui-widget-header post_title">Reply</div>
	<div class="ui-widget-content">
		<form action="" method="post">
			<input type="hidden" name="send" value="1">
			<table class="datagrid noborder" cellspacing="0">
				<tbody class="bih-grid-form nobevel">
					<tr>
						<td class="label">Subject:</td>
						<td><input type="text" class="input_box_wide" name="subject" value="#form.subject#"></td>
					</tr>
					<tr>
						<td class="label">Body:</td>
						<td><textarea name="body" class="textarea_medium">#form.body#</textarea></td>
					</tr>
				</tbody>
			</table>
			<div class="post_buttons ui-widget-content ui-corner-all">
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" submit="true" class="ui-button-text-tiny" src="bih-icon bih-icon-pencilpad" name="send" text="Send Reply"/>
			</div>
		</form>
	</div>
	</cfoutput>
</cfmodule>