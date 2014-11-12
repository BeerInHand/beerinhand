<cfparam name="COOKIE.user" default="" />
<cfoutput>
<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/login.js"></script>
<script>$(document).ready(function() {document.frmLogin.username.focus()});</script>

<form id="frmLogin" name="frmLogin" onsubmit="return false;">
<table cellspacing="0">
	<tbody>
		<tr>
			<td><label for="username">Username</label></td>
			<td><label for="password">Password</label></td>
		</tr>
		<tr>
			<td><input type="text" id="username" name="username" maxlen="15" value="#COOKIE.user#" style="width: 125px" /></td>
			<td><input type="password" id="password" name="password" style="width: 125px" /></td>
			<td><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny smallcaps" id="btnLogin" onclick="loginProcess(this)" title="Log In" text="Log In" /></td>
		</tr>
		<tr>
			<td>
				<input type="checkbox" id="remember" name="remember" value="1" />
				<label for="remember">Keep me logged in</label>
			</td>
			<td><a href="p.forgot.cfm" title="Duh">Forgot your password?</a></td>
		</tr>
	</tbody>
</table>
</form>

</cfoutput>
