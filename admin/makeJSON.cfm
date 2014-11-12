<cfset LOCAL = StructNew() />
<cfset LOCAL.qryGrains = APPLICATION.CFC.Factory.get("Grains").QueryGrains() />
<cffile action="write" file="#APPLICATION.DISK.ROOT#/js/grains_data.js" output="
qryGrains = #udfQueryToJSON(qryGrains)#;
idxGrains = #udfMakeIndex(qryGrains, 'gr_type')#;
" />


<!---
<cfset qry = {COLUMNS=ListToArray(qryGrains.ColumnList), DATA=[] } />
<cfloop query="qryGrains">
	<cfset row = {} />
	<cfloop list="#qryGrains.ColumnList#" index="idx">
		<cfset row[idx] = qryGrains[idx][qryGrains.CurrentRow]/>
	</cfloop>
	<cfset ArrayAppend(qry.DATA, row) />
</cfloop>
<cffile action="append" file="#APPLICATION.DISK.ROOT#/js/grain_data.js" output="qryGrains = #SerializeJSON(qry,true)#;#CHR(13)##CHR(10)#" />
<cfdump var="#qry#"> --->