<cfset cfcDB = CreateObject("component", "#APPLICATION.MAP.CFC#.data.grains").init() />
<cfinclude template="funct.cfm">
<cfset LOCAL = StructNew() />
<cfset GRAINS = ArrayNew(1) />
<cfset LOCAL.XMLResponse=XMLParse("grains.xml") />

<cfloop from="1" to="#ArrayLen(LOCAL.XMLResponse.FERMENTABLES.FERMENTABLE)#" index="idx">
	<cfset GRAINS[idx] = StructNew() />
	<cfset LOCAL.GRAIN = LOCAL.XMLResponse.FERMENTABLES.FERMENTABLE[idx] />
	<cfset GRAINS[idx].gr_maltster = ReadKey(LOCAL.GRAIN, "SUPPLIER") />
	<cfset GRAINS[idx].gr_type = ReplaceNoCase(ReadKey(LOCAL.GRAIN, "NAME"), "(#GRAINS[idx].gr_maltster#)", "") />
	<cfset GRAINS[idx].gr_country = ReadKey(LOCAL.GRAIN, "ORIGIN") />
	<cfset GRAINS[idx].gr_cat = ReadKey(LOCAL.GRAIN, "TYPE") />
	<cfset GRAINS[idx].gr_lvb = ReadKey(LOCAL.GRAIN, "COLOR") />
	<cfset GRAINS[idx].gr_sgc = ReadKey(LOCAL.GRAIN, "POTENTIAL") />
	<cfset GRAINS[idx].gr_fcdif = ReadKey(LOCAL.GRAIN, "COARSE_FINE_DIFF") />
	<cfset GRAINS[idx].gr_mc = ReadKey(LOCAL.GRAIN, "MOISTURE") />
	<cfset GRAINS[idx].gr_lintner = ReadKey(LOCAL.GRAIN, "DIASTATIC_POWER") />
	<cfset GRAINS[idx].gr_protein = ReadKey(LOCAL.GRAIN, "PROTEIN") />
	<cfset GRAINS[idx].gr_mash = ReadKey(LOCAL.GRAIN, "RECOMMEND_MASH", FALSE) />
	<!--- <cfset GRAINS[idx].gr_info = ReadKey(LOCAL.GRAIN, "NOTES") /> --->
	<cfquery name="qryChk" datasource="bih">
		select * from grains where gr_type = '#GRAINS[idx].gr_type#' and gr_maltster ='#GRAINS[idx].gr_maltster#'
	</cfquery>

<!---
	<cfset GRAINS[idx].qry = qryChk />
	<cfif GRAINS[idx].gr_maltster eq "Hoepfner" and not qryChk.recordcount>
		<cfdump var="#GRAINS[idx]#">
	</cfif> --->
	<cfif qryChk.RecordCount>
		<cfinvoke component="#cfcDB#" method="UpdateGrains">
			<cfinvokeargument name="gr_grid" value="#qryChk.gr_grid#" />
			<cfloop list="gr_protein" index="col">
				<cfinvokeargument name="#col#" value="#GRAINS[idx][col]#" />
			</cfloop>
		</cfinvoke>
	<cfelse>
		<cfinvoke component="#cfcDB#" method="InsertGrains">
			<cfloop collection="#GRAINS[idx]#" item="col">
				<cfinvokeargument name="#col#" value="#GRAINS[idx][col]#" />
			</cfloop>
		</cfinvoke>
	</cfif>
</cfloop>


