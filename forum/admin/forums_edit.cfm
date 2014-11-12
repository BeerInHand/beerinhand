<cfsetting enablecfoutputonly = true />
<cfif isDefined("form.cancel") or not isDefined("url.id") or not len(url.id)>
	<cflocation url="z.forums.cfm" addToken="false">
</cfif>
<cfif url.id neq 0><!--- get forum if not new --->
	<cfset forum = APPLICATION.FORUM.Forums.getForum(url.id)>
	<cfparam name="form.name" default="#forum.name#">
	<cfparam name="form.description" default="#forum.description#">
	<cfparam name="form.active" default="#forum.active#">
	<cfparam name="form.attachments" default="#forum.attachments#">
	<cfparam name="form.conferenceidfk" default="#forum.conferenceidfk#">
	<cfparam name="form.rank" default="#forum.rank#">
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
	<cfparam name="form.attachments" default="false">
	<cfparam name="form.conferenceidfk" default="">
	<cfparam name="form.rank" default="">
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
		<cfset forum = structNew()>
		<cfset forum.name = trim(htmlEditFormat(form.name))>
		<cfset forum.description = trim(htmlEditFormat(form.description))>
		<cfset forum.active = trim(htmlEditFormat(form.active))>
		<cfset forum.attachments = trim(htmlEditFormat(form.attachments))>
		<cfset forum.conferenceidfk = trim(htmlEditFormat(form.conferenceidfk))>
		<cfset forum.rank = trim(htmlEditFormat(form.rank))>
		<cfif url.id neq 0>
			<cfset APPLICATION.FORUM.Forums.saveForum(url.id, forum)>
		<cfelse>
			<cfset url.id = APPLICATION.FORUM.Forums.addForum(forum)>
		</cfif>
		<cfset APPLICATION.FORUM.Permission.setAllowed(APPLICATION.FORUM.Rights.CANVIEW, url.id, form.canread)>
		<cfset APPLICATION.FORUM.Permission.setAllowed(APPLICATION.FORUM.Rights.CANPOST, url.id, form.canpost)>
		<cfset APPLICATION.FORUM.Permission.setAllowed(APPLICATION.FORUM.Rights.CANEDIT, url.id, form.canedit)>

		<cfset msg = "Forum, #forum.name#, has been updated.">
		<cflocation url="z.forums.cfm?msg=#urlEncodedFormat(msg)#" addToken="false">
	</cfif>
</cfif>
<!--- Security Related --->
<cfset groups = APPLICATION.FORUM.User.getGroups()><!--- get all groups --->
<cfset conferences = APPLICATION.FORUM.Conference.getConferences(false)><!--- get all conferences --->
<cfmodule template="../tags/layout.cfm" templatename="admin" title="Forum Editor">
	<cfif conferences.recordCount is 0>
		<cfoutput>
		<div class="clearer"></div>
		<div>You do not have any conferences. You must <a href="conferences_edit.cfm?id=0">create one</a> before creating a forum.</div>
		</cfoutput>
	<cfelse>
		<cfoutput>
		<form action="#cgi.script_name#?#cgi.query_string#" method="post">
			<div class="clearer"></div>
			<cfif isDefined("errors")><div class="input_error"><ul><b>#errors#</b></ul></div></cfif>
			<div class="name_row"><p class="left_100"></p></div>
			<div class="dataset ui-widget-content">
				<div class="row_0">
					<p class="input_name">Name</p>
					<input type="text" name="name" value="#form.name#" class="inputs_01">
					<div class="clearer"></div>
				</div>
				<div class="row_1">
					<p class="input_name">Conference</p>
					<select name="conferenceidfk" class="inputs_02">
						<cfloop query="conferences"><option value="#id#" <cfif form.conferenceidfk is id>selected</cfif>>#name#</option></cfloop>
					</select>
					<div class="clearer"></div>
				</div>
				<div class="row_0">
					<p class="input_name">Description</p>
					<input type="text" name="description" value="#form.description#" class="inputs_01">
					<div class="clearer"></div>
				</div>
				<div class="row_1">
					<p class="input_name">Active</p>
					<select name="active" class="inputs_02">
						<option value="1" <cfif form.active>selected</cfif>>Yes</option>
						<option value="0" <cfif not form.active>selected</cfif>>No</option>
					</select>
					<div class="clearer"></div>
				</div>
				<div class="row_0">
					<p class="input_name">Rank</p>
					<input type="text" name="rank" value="#form.rank#" class="inputs_01" size="3"> (Overrides Alpha sort)
					<div class="clearer"></div>
				</div>
				<div class="row_1">
					<p class="input_name">Attachments</p>
					<select name="attachments" class="inputs_02">
						<option value="1" <cfif isBoolean(form.attachments) and form.attachments>selected</cfif>>Yes</option>
						<option value="0" <cfif (isBoolean(form.attachments) and not form.attachments) or form.attachments is "">selected</cfif>>No</option>
					</select>
					<div class="clearer"></div>
				</div>
				<div class="row_0">
					<p class="input_name">Groups with Read Access</p>
					<select name="canread" multiple="true" size="4" class="inputs_02">
						<option value="" <cfif form.canread is "">selected</cfif>>Everyone</option>
						<cfloop query="groups"><option value="#id#" <cfif listFind(form.canread, id)>selected</cfif>>#group#</option></cfloop>
					</select>
					<div class="clearer"></div>
				</div>
				<div class="row_1">
					<p class="input_name">Groups with Post Access</p>
					<select name="canpost" multiple="true" size="4" class="inputs_02">
						<option value="" <cfif form.canpost is "">selected</cfif>>Everyone</option>
						<cfloop query="groups"><option value="#id#" <cfif listFind(form.canpost, id)>selected</cfif>>#group#</option></cfloop>
					</select>
					<div class="clearer"></div>
				</div>
				<div class="row_0">
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

	</cfif>
</cfmodule>

<cfsetting enablecfoutputonly = false />