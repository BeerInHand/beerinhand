<cfset cfcDB = CreateObject("component", "#APPLICATION.MAP.CFC#.data.Misc").init() />
<cfinclude template="funct.cfm">
<cfset LOCAL = StructNew() />
<cfset MISCS = ArrayNew(1) />
<cfset LOCAL.XMLResponse=XMLParse("miscing.xml") />
<cfloop from="1" to="#ArrayLen(LOCAL.XMLResponse.MISCS.MISC)#" index="idx">
	<cfset MISCS[idx] = StructNew() />
	<cfset LOCAL.MISC = LOCAL.XMLResponse.MISCS.MISC[idx] />
	<cfset MISCS[idx].mi_type = ReadKey(LOCAL.MISC, "NAME") />
	<cfset MISCS[idx].mi_use = ReadKey(LOCAL.MISC, "TYPE") />
	<cfset MISCS[idx].mi_utype = IIF(ReadKey(LOCAL.MISC, "AMOUNT_IS_WEIGHT", FALSE), DE("W"), DE("V")) />
	<cfset MISCS[idx].mi_unit = fixUnitsW(fixUnitsV(ListLast(ReadKey(LOCAL.MISC, "DISPLAY_AMOUNT"), " "))) />
	<cfset MISCS[idx].mi_phase = fixMiscUse(ReadKey(LOCAL.MISC, "USE")) />
	<cfset MISCS[idx].mi_info = ReadKey(LOCAL.MISC, "NOTES") />
	<cfquery name="qryChk" datasource="bih">
		select * from MISC where mi_type = '#MISCS[idx].mi_type#'
	</cfquery>
		<cfset MISCS[idx].qry = qryChk />
		<cfdump var="#MISCS[idx]#">
	<cfif qryChk.RecordCount>
		<cfinvoke component="#cfcDB#" method="UpdateMISC">
			<cfinvokeargument name="mi_miid" value="#qryChk.mi_miid#" />
			<cfloop list="mi_athigh,mi_atlow,mi_form,mi_temphigh,mi_templow,mi_floc" index="col">
				<cfinvokeargument name="#col#" value="#MISCS[idx][col]#" />
			</cfloop>
		</cfinvoke>
	<cfelse>
		<cfinvoke component="#cfcDB#" method="InsertMISC">
			<cfloop collection="#MISCS[idx]#" item="col">
				<cfinvokeargument name="#col#" value="#MISCS[idx][col]#" />
			</cfloop>
		</cfinvoke>
	</cfif>
</cfloop>

<cfquery name="qryMisc" datasource="bih">
select * from misc
</cfquery>


<cfdump var="#qryMisc#">
