<cfsetting enablecfoutputonly = true />
<cfif isDefined("form.cancel.x") or not isDefined("URL.id")>
	<cflocation url="z.users.cfm" addToken="false">
</cfif>
<cfif isDefined("form.save.x")>
	<cfset errors = "">
	<cfif not len(trim(form.username))>
		<cfset errors = errors & "You must specify a username.<br>">
	</cfif>
	<cfif not len(trim(form.emailaddress)) or not REQUEST.udf.isEmail(trim(form.emailaddress))>
		<cfset errors = errors & "You must specify an emailaddress.<br>">
	</cfif>
	<cfif not len(trim(form.datecreated)) or not isDate(form.datecreated)>
		<cfset errors = errors & "You must specify a creation date.<br>">
	</cfif>
	<cfif not structKeyExists(form,"groups") or not len(form.groups)>
		<cfset errors = errors & "You must specify at least one group for the user.<br>">
	</cfif>
	<cfif not len(errors)>
		<cfset user = structNew()>
		<cfset form.username = trim(htmlEditFormat(form.username))>
		<cfset form.emailaddress = trim(form.emailaddress)>
		<cfset form.password = trim(form.password)>
		<cfset form.datecreated = trim(htmlEditFormat(form.datecreated))>
		<cfparam name="form.groups" default="">
		<cfparam name="form.confirmed" default="true"><!--- set confirmed to true if not passed --->
		<cfif URL.id neq 0>
			<cfset argStruct = structNew()>
			<cfif len(form.password)>
				<cfset argStruct.password = form.password>
			</cfif>
			<cfset APPLICATION.FORUM.User.saveUser(username=form.username,emailaddress=form.emailaddress,datecreated=form.datecreated,groups=form.groups,confirmed=form.confirmed, argumentCollection=argStruct)>
		<cfelse>
			<cfthrow message="You shouldn't be seeing this."><!--- You can't add users via the admin --->
			<cftry>
				<cfset APPLICATION.FORUM.User.addUser(form.username, form.password, form.emailaddress, form.groups,form.confirmed)>
				<cfcatch>
					<cfset errors = cfcatch.message>
				</cfcatch>
			</cftry>
		</cfif>
		<cfif not len(errors)>
			<cfset msg = "User, #form.username#, has been updated.">
			<cflocation url="z.users.cfm?msg=#urlEncodedFormat(msg)#" addToken="false">
		</cfif>
	</cfif>
</cfif>
<cfif URL.id gte 1><!--- get user if not new --->
	<cfset user = APPLICATION.FORUM.User.getUser(URL.id)>
	<cfparam name="form.username" default="#user.username#">
	<cfparam name="form.emailaddress" default="#user.emailaddress#">
	<cfif APPLICATION.FORUM.SETTING.encryptpasswords>
		<cfparam name="form.password" default="">
	<cfelse>
		<cfparam name="form.password" default="#user.password#">
	</cfif>
	<cfparam name="form.datecreated" default="#dateFormat(user.datecreated,"m/dd/yy")# #timeFormat(user.datecreated,"h:mm tt")#">
	<cfparam name="form.groups" default="#user.groups#">
	<cfparam name="form.confirmed" default="#user.confirmed#">
<cfelse>
	<cfparam name="form.username" default="">
	<cfparam name="form.emailaddress" default="">
	<cfparam name="form.password" default="">
	<cfparam name="form.datecreated" default="#dateFormat(now(),"m/dd/yy")# #timeFormat(now(),"h:mm tt")#">
	<cfparam name="form.groups" default="">
	<cfparam name="form.confirmed" default="0">
</cfif>
<cfset groups = APPLICATION.FORUM.User.getGroups()>
<cfmodule template="../tags/layout.cfm" templatename="admin" title="User Editor">
	<cfoutput>
	<form action="#CGI.script_name#?#CGI.query_string#" method="post">
		<div class="clearer"></div>
		<cfif isDefined("errors")><div class="input_error"><ul><b>#errors#</b></ul></div></cfif>
		<div class="row_0">
			<p class="input_name">User Name</p>
			<input type="hidden" name="username" value="#form.username#"><h4>#form.username#</h4>
			<div class="clearer"></div>
		</div>
		<div class="row_1">
			<p class="input_name">Email Address</p>
			<input type="hidden" name="emailaddress" value="#form.emailaddress#" class="inputs_01"><h4>#form.emailaddress#</h4>
			<div class="clearer"></div>
		</div>
		<div class="row_1">
			<p class="input_name">Date Created</p>
			<input type="hidden" name="datecreated" value="#form.datecreated#" class="inputs_01"><h4>#form.datecreated#</h4>
			<div class="clearer"></div>
		</div>
		<div class="row_0">
			<p class="input_name">Groups</p>
			<select name="groups" class="inputs_02" multiple size="3">
				<cfloop query="groups"><option value="#group#" <cfif listFindNoCase(form.groups, group)>selected</cfif>>#group#</option></cfloop>
			</select>
			<div class="clearer"></div>
		</div>
		<div id="input_btns">
			<input type="image" src="../images/btn_save.jpg"  name="save" value="Save">
			<input type="image" src="../images/btn_cancel.jpg" type="submit" name="cancel" value="Cancel">
		</div>
	</form>
	</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly = false />