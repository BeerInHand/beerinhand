<cfparam name="REQUEST.ERR.CODE" default="0" />

<cfset REQUEST.ERR[0] = "I got nothin'."/>
<cfset REQUEST.ERR[100] = "Invalid account validation sequence."/>
<cfset REQUEST.ERR[200] = "Invalid password reset sequence."/>
<cfset REQUEST.ERR[404] = "Your page request was considered unworthy."/>
<cfset REQUEST.ERR[420] = "Smoke 'em if you got 'em."/>
<cfif StructKeyExists(VARIABLES, "CFCATCH")>
	<cfif ListLen(CFCATCH.Message,":") eq 2>
		<cfset REQUEST.ERR.CODE = ListFirst(CFCATCH.Message,":") />
		<cfset REQUEST.ERR[REQUEST.ERR.CODE] = ListLast(CFCATCH.Message,":") />
	<cfelse>
		<cfset REQUEST.ERR.CODE = 500 />
		<cfset REQUEST.ERR[REQUEST.ERR.CODE] = CFCATCH.Message />
	</cfif>
	<cfif APPLICATION.IsLocal>
		<cfdump var="#CFCATCH#">
	<cfelse>
		<cfset udfSaveError(CFCATCH) />
	</cfif>
</cfif>
<cfif NOT StructKeyExists(REQUEST.ERR, REQUEST.ERR.CODE)><cfset REQUEST.ERR.CODE = 0></cfif>

<div class="ui-widget-content ui-state-disabled ui-corner-all" style="margin:30px; padding: 10px;"><cfoutput>Hiccup #REQUEST.ERR.CODE# -> #REQUEST.ERR[REQUEST.ERR.CODE]#</cfoutput></div>

