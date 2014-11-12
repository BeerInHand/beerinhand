<cfcomponent output="false">

<cffunction name="sendmail" access="public" output="false" returnType="void">
	<cfargument name="from" type="string" required="true">
	<cfargument name="to" type="string" required="true">
	<cfargument name="subject" type="string" required="true">
	<cfargument name="body" type="string" required="false" default="">
	<cfargument name="htmlbody" type="string" required="false" default="">
	
	<cfset var fakeHTML = "">
	
	<!--- fakehtml used for the html version of emails when no html is sent --->
	<cfset fakeHTML = htmlEditFormat(ARGUMENTS.body)>
	<cfset fakeHTML = replace(fakeHTML, chr(13), chr(10), "all")>
	<cfset fakeHTML = replace(fakeHTML, chr(10), "<br>", "all")>
	
	<!---
	Notice: Why do we send the same string twice in the 2 final clauses? A user, J.J. Blodgett, noticed that
	in Thunderbird and iPhone, the use of one mailpart was causing an issue. This fix is thanks to him.
	--->
	<cfif VARIABLES.server is "">
		<cfmail to="#ARGUMENTS.to#" from="#ARGUMENTS.from#" subject="#ARGUMENTS.subject#">
			<cfif len(ARGUMENTS.body) AND len(ARGUMENTS.htmlbody)>
			       <cfmailpart type="text">#ARGUMENTS.body#</cfmailpart>
			       <cfmailpart type="html">#ARGUMENTS.htmlbody#</cfmailpart>
			<cfelseif len(ARGUMENTS.body)>
			       <cfmailpart type="text">#ARGUMENTS.body#</cfmailpart>
					<cfmailpart type="html">#fakeHTML#</cfmailpart>			
			<cfelse>
			       <cfmailpart type="text">#ARGUMENTS.htmlbody#</cfmailpart>
			       <cfmailpart type="html">#ARGUMENTS.htmlbody#</cfmailpart>
			</cfif>
		</cfmail>
	<cfelse>
		<cfmail to="#ARGUMENTS.to#" from="#ARGUMENTS.from#" subject="#ARGUMENTS.subject#" server="#VARIABLES.server#" username="#VARIABLES.username#" password="#VARIABLES.password#">
			<cfif len(ARGUMENTS.body) AND len(ARGUMENTS.htmlbody)>
			       <cfmailpart type="text">#ARGUMENTS.body#</cfmailpart>
			       <cfmailpart type="html">#ARGUMENTS.htmlbody#</cfmailpart>
			<cfelseif len(ARGUMENTS.body)>
			       <cfmailpart type="text">#ARGUMENTS.body#</cfmailpart>
					<cfmailpart type="html">#fakeHTML#</cfmailpart>			
			<cfelse>
			       <cfmailpart type="text">#ARGUMENTS.htmlbody#</cfmailpart>
			       <cfmailpart type="html">#ARGUMENTS.htmlbody#</cfmailpart>
			</cfif>
		</cfmail>
	</cfif>

</cffunction>
	
<cffunction name="setSettings" access="public" output="No" returntype="void">
	<cfargument name="settings" required="true" hint="Setting">
	<cfset var mySettings = ARGUMENTS.settings.getSettings()>
	<cfset VARIABLES.server = mySettings.mailServer>
	<cfset VARIABLES.username = mySettings.mailUsername>
	<cfset VARIABLES.password = mySettings.mailPassword>
</cffunction>
		
</cfcomponent>