<cfif isDefined("URL.key") AND isDefined("URL.user")>
	<cfset rtn = APPLICATION.CFC.USERS.ForgotReset(user = URL.user, key = URL.key) />
	<cfif rtn.validated>
		Congratulations! You have completed the password reset process. Please check your email for your new password.
	<cfelse>
		<cfset REQUEST.ERR.CODE = 200 />
		<cfinclude template="#APPLICATION.PATH.ROOT#/error/error.cfm" />
	</cfif>
<cfelseif isDefined("FORM.username")>
	<cfset rtn = APPLICATION.CFC.USERS.ForgotSend(user = FORM.username) />
	<cfif rtn.validated>
		Please check your email for the Password reset link. After verifying the request, you will be emailed a new password.
	<cfelse>
		<cfset REQUEST.ERR.CODE = 200 />
		<cfinclude template="#APPLICATION.PATH.ROOT#/error/error.cfm" />
	</cfif>
<cfelse>
	<cfoutput><script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/login.js"></script></cfoutput>
	<h2>Forgotten Password Retrieval</h2>
	<p>If you cannot remember your password, enter your username in the form below to begin the reset process.</p>
	<form id="frmUser" name="frmUser" method="post">
		<table cellspacing="10">
			<tr>
				<td class="label" width="150">Username:</td>
				<td width="205">
					<input type="text" id="username" name="username" maxlen="15" tabindex="1" />
				</td>
			</tr>
			<tr>
				<td colspan="2" class="center pad10"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" id="btnLogin" src="ui-icon-circle-arrow-e" onclick="forgotProcess(this)" text="Send Request" tabindex="2" /></td>
			</tr>
		</table>
	</form>
</cfif>
