<cfset sFunct = StructNew() />
<cfset sFunct._Imm = "" />
<cfset fArr = ArrayNew(1) />
<cfset inFunct = false />
<cfset curFunct = "" />
<cfset listFunct = "" />
<cfset start = 0 />
<cfset end = 0 />
<cfloop file="c:/inetpub/wwwroot/beerinhand/js/brewlog.js" index="line">
	<cfif len(line)><cfset line = RTrim(line) & chr(13) & chr(10) /></cfif>
	<cfif NOT inFunct>
		<cfif FindNoCase("function", line)>
			<cfset inFunct = true />
			<cfset curFunct = Trim(ListFirst(line, "=")) />
			<cfset sFunct[curFunct] = "" />
			<cfset listFunct = ListAppend(listFunct, curFunct) />
		<cfelse>
			<cfset sFunct._Imm = sFunct._Imm & line />
		</cfif>
	</cfif>
	<cfif inFunct>
		<cfset sFunct[curFunct] = sFunct[curFunct] & line />
		<cfset start = start + Len(REReplace(line, "[^{]+", "", "ALL")) />
		<cfset end = end + Len(REReplace(line, "[^}]+", "", "ALL")) />
		<cfset inFunct = (start NEQ end) />
	</cfif>
</cfloop>

<cfset listFunct = ListSort(listFunct, "TextNoCase") />
<cfset output = sFunct._Imm & chr(13) & chr(10) />
<cfloop list="#listFunct#" index="key">
	<cfset output = output & sFunct[key] />
</cfloop>
<cfdump var="#output#">
<cffile action="write" file="#APPLICATION.DISK.ROOT#\test\test.js" output="#output#"/>