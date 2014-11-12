<cfsetting enablecfoutputonly = true />
<cfif not SESSION.LoggedIn>
	<cfset thisPage = CGI.script_name & "?" & CGI.query_string>
	<cflocation url="p.login.cfm?ref=#urlEncodedFormat(thisPage)#" addToken="false">
</cfif>
<cfparam name="form.subject" default="">
<cfparam name="form.body" default="">
<cfparam name="URL.user" default="">
<cfparam name="form.to" default="#URL.user#">
<cfset showForm = true>
<cfif structKeyExists(form, "send")>
	<cfset errors = "">
	<cfset touser = APPLICATION.FORUM.User.getUser(form.to)>
	<cfif touser.id is "">
		<cfset errors = errors & "You did not specify a valid user.<br/>">
	</cfif>
	<cfset form.subject = trim(htmlEditFormat(form.subject))>
	<cfset form.body = trim(htmlEditFormat(form.body))>
	<cfif not len(form.subject)>
		<cfset errors = errors & "You did not specify a subject for your message.<br/>">
	</cfif>
	<cfif not len(form.body)>
		<cfset errors = errors & "You did not specify a body for your message.<br/>">
	</cfif>
	<cfif not len(errors)>
		<!--- Send the PM --->
		<cfset showForm = false>
		<cfset APPLICATION.FORUM.User.sendPrivateMessage(to=form.to,from=getAuthUser(), subject=form.subject, body=form.body)>
	</cfif>
</cfif>
<cfmodule template="tags/layout.cfm" templatename="main" title="#APPLICATION.FORUM.SETTING.title# : Send Private Message"><!--- Loads header --->
	<cfoutput>
	<cfif isDefined("errors")>
		<cfif len(errors)>
			<p>Please correct the following error(s):</p>
			<div class="submit_errors"><p><b>#errors#</b></p></div>
		<cfelse>
			<p>Your profile has been updated.</p>
		</cfif>
	<cfelse>
		<p>The form below may be used to send a private message to another user. No one else will be able to read the message.</p>
	</cfif>
	<div class="ui-widget-header post_title">Send Private Message</div>
	<cfif showForm>
		<div class="ui-widget-content">
			<form action="#CGI.script_name#" method="post">
				<input type="hidden" name="send" value="1">
				<table class="datagrid noborder" cellspacing="0">
					<tbody class="bih-grid-form nobevel">
						<tr>
							<td class="label">To:</td>
							<td><input type="text" class="input_box" name="to" value="#form.to#"></td>
						</tr>
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
					<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" submit="true" class="ui-button-text-tiny" src="bih-icon bih-icon-pencilpad" name="send" text="Send PM"/>
				</div>
			</form>
		</div>
	<cfelse>
		<div class="row_1"><p>Your message has been sent.</p></div>
	</cfif>
	</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly = false />