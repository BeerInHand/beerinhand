<cfif isDefined("URL.key") AND isDefined("URL.user")>
	<cfset rtn = APPLICATION.CFC.USERS.Validate(user = URL.user, key = URL.key) />
	<cfif rtn.validated>
		Congratulations! Your BeerInHand account has been validated and you may now log in.
	<cfelse>
		<cfset REQUEST.ERR.CODE = 100 />
		<cfinclude template="#APPLICATION.PATH.ROOT#/error/error.cfm" />
	</cfif>
<cfelseif isDefined("URL.done")>
	<p>Thank you for signing up for a BeerInHand account. Please check your email for the Confirmation link to verify your new account. Unverified accounts will be deleted after 30 days.</p>
	<p>Make sure you allow donotrespond@beerinhand.com through any spam filters so you can receive our confirmation message.</p>
<cfelse>
	<cfoutput><script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/login.js"></script></cfoutput>
	<form id="frmUser" name="frmUser" action="p.signup.cfm">
		<table cellspacing="10" width="375">
			<caption class="left">
	<h3>Sign up for BeerInHand</h3>
	<p>It's free and when it comes to beer, that's a good thing.</p>
	<hr>

			</caption>
			<tr title="Username must start with a letter and be at least 4 characters long.">
				<td class="label">Username:</td>
				<td>
					<input type="text" id="username" name="username" maxlen="15" onblur="verifyUser(false)" onfocus="verifyClear()" tabindex="1" required="required" />
					<span id="icoVerify" style="float: right; margin-right: 5px; padding: 1px;"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiIcon" src="ui-icon-bullet" /></span>
				</td>
			</tr>
			<tr>
				<td class="label">Password:</td>
				<td><input type="password" id="password" name="password" tabindex="2" required="required" /></td>
			</tr>
			<tr>
				<td class="label">Confirm Password:</td>
				<td><input type="password" id="password2" name="password2" tabindex="3" required="required" /></td>
			</tr>
			<tr title="Your email will never be displayed on BeerInHand.">
				<td class="label">Email:</td>
				<td><input type="text" id="email" name="email" tabindex="4" required="required" /></td>
			</tr>
			<tr>
				<td class="label">Confirm Email:</td>
				<td><input type="text" id="email2" name="email2" tabindex="5" required="required" /></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
					<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny smallcaps" id="btnLogin" onclick="verifyProcess(this)" text="Sign Up" tabindex="6" />
					<div style="height:20px; margin-bottom: 5px;" class="red bold" id="loginmsg"></div>
					<p><a href="?contact">Need help? Contact us.</a></p>
				</td>
			</tr>
		</table>
	</form>

</cfif>
