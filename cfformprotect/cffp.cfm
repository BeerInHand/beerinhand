<cfset cffpConfig = APPLICATION.CFC.Factory.get("CFFP") />

<!--- Bas van der Graaf (bvdgraaf@e-dynamics.nl): Make sure JS is only included once when securing multiple forms with cfformprotect. --->
<cfif not structkeyExists(REQUEST,"cffpJS")>
	<cfhtmlhead text="<script type='text/javascript' src='#APPLICATION.PATH.ROOT#/cfformprotect/js/cffp.js'></script>">
	<cfset REQUEST.cffpJS = true>
</cfif>

<!--- check the config (from the ini file)to see if each test is turned on --->
<cfif cffpConfig.getConfig().mouseMovement>
	<!--- If the user moves their mouse, put the distance in this field (JavaScript function handles this).
				cffpVerify.cfm will make sure the user at least used their keyboard. A spam
				bot won't trigger this --->
	<input id="fp<cfoutput>#createuuid()#</cfoutput>" type="hidden" name="formfield1234567891" class="cffp_mm" value="" />
</cfif>

<cfif cffpConfig.getConfig().usedKeyboard>
	<!--- If the types on their keyboard, put the amount of keys pressed in this field.
				cffpVerify.cfm will make sure the user at least used their keyboard. A spam
				bot won't trigger this --->
	<input id="fp<cfoutput>#createuuid()#</cfoutput>" type="hidden" name="formfield1234567892" class="cffp_kp" value="" />
</cfif>

<cfif cffpConfig.getConfig().timedFormSubmission>
	<!--- in cffpVerify.cfm I will verify that the amount of time it took to
				fill out this form is 'normal' (the time limits are set in the ini file)--->
	<!--- get the current time, obfuscate it and load it to this hidden field --->
	<cfset currentDate = dateFormat(now(),'yyyymmdd')>
	<cfset currentTime = timeFormat(now(),'HHmmss')>
	<!--- Add an arbitrary number to the date/time values to mask them from prying eyes --->
	<cfset blurredDate = currentDate+19740206>
	<cfset blurredTime = currentTime+19740206>
	<input id="fp<cfoutput>#createuuid()#</cfoutput>" type="hidden" name="formfield1234567893" value="<cfoutput>#blurredDate#,#blurredTime#</cfoutput>" />
</cfif>

<cfif cffpConfig.getConfig().hiddenFormField>
	<!--- A lot of spam bots automatically fill in all form fields.  cffpVerify.cfm will
				test to see if this field is blank. The "leave this empty" text is there for blind people,
				who might see this hidden field --->
	<span style="display:none">Leave this field empty <input id="fp<cfoutput>#createuuid()#</cfoutput>" type="text" name="formfield1234567894" value="" /></span>
</cfif>