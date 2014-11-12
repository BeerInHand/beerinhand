<cfsetting enablecfoutputonly = true />
<cfif isDefined("form.cancel") or not isDefined("url.id") or not len(url.id)>
	<cflocation url="z.conferences.cfm" addToken="false">
</cfif>
<cfif url.id neq "0"><!--- get conference if not new --->
	<cfset conference = APPLICATION.FORUM.Conference.getConference(url.id)>
	<cfparam name="form.name" default="#conference.name#">
	<cfparam name="form.description" default="#conference.description#">
	<cfparam name="form.active" default="#conference.active#">
	<!--- get groups with can read --->
	<cfset canread = APPLICATION.FORUM.Permission.getAllowed(APPLICATION.FORUM.Rights.CANVIEW, url.id)>
	<!--- get groups with can post --->
	<cfset canpost = APPLICATION.FORUM.Permission.getAllowed(APPLICATION.FORUM.Rights.CANPOST, url.id)>
	<!--- get groups with can edit --->
	<cfset canedit = APPLICATION.FORUM.Permission.getAllowed(APPLICATION.FORUM.Rights.CANEDIT, url.id)>
<cfelse>
	<cfparam name="form.name" default="">
	<cfparam name="form.description" default="">
	<cfparam name="form.active" default="true">
	<cfset canread = queryNew("group")>
	<cfset canpost = queryNew("group")>
	<cfset canedit = queryNew("group")>
</cfif>
<cfif not isDefined("form.save")>
	<cfparam name="form.canread" default="#valueList(canread.group)#">
	<cfparam name="form.canpost" default="#valueList(canpost.group)#">
	<cfparam name="form.canedit" default="#valueList(canedit.group)#">
<cfelse>
	<cfparam name="form.canread" default="">
	<cfparam name="form.canpost" default="">
	<cfparam name="form.canedit" default="">
</cfif>
<cfif isDefined("form.save")>
	<cfset errors = "">
	<cfif not len(trim(form.name))>
		<cfset errors = errors & "You must specify a name.<br>">
	</cfif>
	<cfif not len(trim(form.description))>
		<cfset errors = errors & "You must specify a description.<br>">
	</cfif>
	<cfif not len(errors)>
		<cfset conference = structNew()>
		<cfset conference.name = trim(htmlEditFormat(form.name))>
		<cfset conference.description = trim(htmlEditFormat(form.description))>
		<cfset conference.active = trim(htmlEditFormat(form.active))>
		<cfif url.id neq 0>
			<cfset APPLICATION.FORUM.Conference.saveConference(url.id, conference)>
		<cfelse>
			<cfset url.id = APPLICATION.FORUM.Conference.addConference(conference)>
		</cfif>
		<!--- update security --->
		<cfset APPLICATION.FORUM.Permission.setAllowed(APPLICATION.FORUM.Rights.CANVIEW, url.id, form.canread)>
		<cfset APPLICATION.FORUM.Permission.setAllowed(APPLICATION.FORUM.Rights.CANPOST, url.id, form.canpost)>
		<cfset APPLICATION.FORUM.Permission.setAllowed(APPLICATION.FORUM.Rights.CANEDIT, url.id, form.canedit)>

		<cfset msg = "Conference, #conference.name#, has been updated.">
		<cflocation url="z.conferences.cfm?msg=#urlEncodedFormat(msg)#" addToken="false">
	</cfif>
</cfif>
<!--- Security Related --->
<cfset groups = APPLICATION.FORUM.User.getGroups()><!--- get all groups --->
<cfmodule template="../tags/layout.cfm" templatename="admin" title="Conference Editor">
	<cfoutput>
	<div class="name_row"><p class="left_100"></p></div>
	<form action="#cgi.script_name#?#cgi.query_string#" method="post">
		<div class="clearer"></div>
		<cfif isDefined("errors")><div class="input_error"><ul><b>#errors#</b></ul></div></cfif>
		<div class="dataset ui-widget-content">
			<div class="row_0">
				<p class="input_name">Name</p>
				<input type="text" name="name" value="#form.name#" class="inputs_01">
				<div class="clearer"></div>
			</div>
			<div class="row_1">
				<p class="input_name">Description</p>
				<input type="text" name="description" value="#form.description#" class="inputs_01">
				<div class="clearer"></div>
			</div>
			<div class="row_0">
				<p class="input_name">Active</p>
				<select name="active" class="inputs_02">
					<option value="1" <cfif form.active>selected</cfif>>Yes</option>
					<option value="0" <cfif not form.active>selected</cfif>>No</option>
				</select>
				<div class="clearer"></div>
			</div>
			<div class="row_1">
				<p class="input_name">Groups with Read Access</p>
				<select name="canread" multiple="true" size="4" class="inputs_02">
					<option value="" <cfif form.canread is "">selected</cfif>>Everyone</option>
					<cfloop query="groups"><option value="#id#" <cfif listFind(form.canread, id)>selected</cfif>>#group#</option></cfloop>
				</select>
				<div class="clearer"></div>
			</div>
			<div class="row_0">
				<p class="input_name">Groups with Post Access</p>
				<select name="canpost" multiple="true" size="4" class="inputs_02">
					<option value="" <cfif form.canpost is "">selected</cfif>>Everyone</option>
					<cfloop query="groups"><option value="#id#" <cfif listFind(form.canpost, id)>selected</cfif>>#group#</option></cfloop>
				</select>
				<div class="clearer"></div>
			</div>
			<div class="row_1">
				<p class="input_name">Groups with Edit Access</p>
				<select name="canedit" multiple="true" size="4" class="inputs_02">
					<option value="" <cfif form.canedit is "">selected</cfif>>Everyone</option>
					<cfloop query="groups"><option value="#id#" <cfif listFind(form.canedit, id)>selected</cfif>>#group#</option></cfloop>
				</select>
				<div class="clearer"></div>
			</div>
		</div>
		<div id="input_btns" class="ui-widget-content right">
			<button class="liveHover juiButton-text-icon ui-state-default ui-corner-all ui-button ui-button-text-icon-primary" type="submit" name="save" value="Save"><span class="ui-button-icon-primary ui-icon ui-icon-circle-check"></span><span class="ui-button-text ">Save Changes</span></button>
			<button class="liveHover juiButton-text-icon ui-state-default ui-corner-all ui-button ui-button-text-icon-primary" type="submit" name="cancel" value="Cancel"><span class="ui-button-icon-primary ui-icon ui-icon-circle-close"></span><span class="ui-button-text ">Cancel</span></button>
		</div>
	</form>
	</cfoutput>
</cfmodule>

<cfsetting enablecfoutputonly = false />