<cfsetting enablecfoutputonly = true />
<cfif structKeyExists(form, "save")>
	<cfset errors = arrayNew(1)>
	<cfif not len(trim(form.perpage)) or not isNumeric(form.perpage) or form.perpage lte 0>
		<cfset arrayAppend(errors, "Items per page must be numeric and greater than zero.")>
	</cfif>
	<cfif not len(trim(form.title))>
		<cfset arrayAppend(errors, "Your forum must have a title.")>
	</cfif>
	<cfif not len(trim(form.version))>
		<cfset arrayAppend(errors, "Your forum must have a version.")>
	</cfif>
	<cfif not arrayLen(errors)>
		<cfset keylist = "bbcode_editor,perpage,requireconfirmation,title,version,fullemails,encryptpasswords,allowavatars,safeextensions,allowpms">
		<cfloop index="key" list="#keylist#">
			<cfif structKeyExists(form, key)>
				<cfset APPLICATION.CFC.Factory.Get("galleonSettings").setSetting(key, trim(form[key]))>
			</cfif>
		</cfloop>
		<cflocation url="z.settings.cfm?reinit=1" addToken="false">
	</cfif>
</cfif>
<cfloop item="setting" collection="#APPLICATION.FORUM.SETTING#">
	<cfparam name="form.#setting#" default="#APPLICATION.FORUM.SETTING[setting]#">
</cfloop>
<cfmodule template="../tags/layout.cfm" templatename="admin" title="Settings">
	<cfoutput>
	<cfif isDefined("errors")>
		<p>
		Please correct the following errors:
		<ul>
			<cfloop index="x" from="1" to="#arrayLen(errors)#"><li>#errors[x]#</li></cfloop>
		</ul>
		</p>
	</cfif>
	<div class="clearer"></div>
	<div>
		<p class="right red bold">
		<cfif not structKeyExists(url, "reinit")>
			Please note that editing these settings incorrectly can break shit.
		<cfelse>
			Settings have been updated and your cache refreshed.
		</cfif>
		</p>
		<div class="clearer"></div>
	</div>
	<form action="#CGI.script_name#?#CGI.query_string#" method="post">
		<div class="dataset ui-widget-content">
			<div class="row_0">
				<p class="input_name">Items Per Page</p>
				<input type="text" name="perpage" value="#form.perpage#" class="inputs_01">
				<div class="clearer"></div>
			</div>
			<div class="row_1">
				<p class="input_name">Version</p>
				<input type="text" name="version" value="#form.version#" class="inputs_01">
				<div class="clearer"></div>
			</div>
			<div class="row_0">
				<p class="input_name">Require Confirmation</p>
					<input type="radio" name="requireconfirmation" value="true" <cfif form.requireconfirmation>checked</cfif>>&nbsp;Yes&nbsp;&nbsp;
					<input type="radio" name="requireconfirmation" value="false" <cfif not form.requireconfirmation>checked</cfif>>&nbsp;No&nbsp;
				<div class="clearer"></div>
			</div>
			<div class="row_1">
				<p class="input_name">Title</p>
				<input type="text" name="title" value="#form.title#" class="inputs_01">
				<div class="clearer"></div>
			</div>
			<div class="row_0">
				<p class="input_name">Full Emails</p>
				<input type="radio" name="fullemails" value="true" <cfif form.fullemails>checked</cfif>>&nbsp;Yes&nbsp;&nbsp;
				<input type="radio" name="fullemails" value="false" <cfif not form.fullemails>checked</cfif>>&nbsp;No&nbsp;
				<div class="clearer"></div>
			</div>
			<div class="row_1">
				<p class="input_name">Encrypt Passwords</p>
				<input type="radio" name="encryptpasswords" value="true" <cfif form.encryptpasswords>checked</cfif>>&nbsp;Yes&nbsp;&nbsp;
				<input type="radio" name="encryptpasswords" value="false" <cfif not form.encryptpasswords>checked</cfif>>&nbsp;No&nbsp;
				<div class="clearer"></div>
			</div>
			<div class="row_0">
				<p class="input_name">Allow Avatars</p>
				<input type="radio" name="allowavatars" value="true" <cfif form.allowavatars>checked</cfif>>&nbsp;Yes&nbsp;&nbsp;
				<input type="radio" name="allowavatars" value="false" <cfif not form.allowavatars>checked</cfif>>&nbsp;No&nbsp;
				<div class="clearer"></div>
			</div>
			<div class="row_1">
				<p class="input_name">Allow Private Messages</p>
				<input type="radio" name="allowpms" value="true" <cfif form.allowpms>checked</cfif>>&nbsp;Yes&nbsp;&nbsp;
				<input type="radio" name="allowpms" value="false" <cfif not form.allowpms>checked</cfif>>&nbsp;No&nbsp;
				<div class="clearer"></div>
			</div>
			<div class="row_0">
				<p class="input_name">Safe Extensions</p>
				<input type="text" name="safeextensions" value="#form.safeextensions#" class="inputs_01">
				<div class="clearer"></div>
			</div>
			<div class="row_1">
				<p class="input_name">Use markItUp! for RTE</p>
				<input type="radio" name="bbcode_editor" value="true" <cfif form.bbcode_editor>checked</cfif>>&nbsp;Yes&nbsp;&nbsp;
				<input type="radio" name="bbcode_editor" value="false" <cfif not form.bbcode_editor>checked</cfif>>&nbsp;No&nbsp;
				<div class="clearer"></div>
			</div>
		</div>
		<div id="input_btns" class="ui-widget-content right">
			<button class="liveHover juiButton-text-icon ui-state-default ui-corner-all ui-button ui-button-text-icon-primary" type="submit" name="save" value="Save"><span class="ui-button-icon-primary ui-icon ui-icon-circle-arrow-e"></span><span class="ui-button-text ">Save Changes</span></button>
		</div>
	</form>
	</cfoutput>


</cfmodule>

<cfsetting enablecfoutputonly = false />
