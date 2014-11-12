<cfcomponent output="false">

	<cffunction name="bihSerializeMeta" returntype="string" output="No">
		<cfargument name="table" type="string" required="Yes" />
		<cfquery datasource="bih" name="LOCAL.meta">
			select column_name, data_type, if(character_maximum_length is null,"0",character_maximum_length) as maximum_length
			  from information_schema.COLUMNS
			  where table_schema='bih' and table_name='#ARGUMENTS.table#'
				  order by ordinal_position
		</cfquery>
		<cfset LOCAL.TYPE = "'TYPE':{">
		<cfset LOCAL.SIZE = "'SIZE':{">
		<cfloop query="LOCAL.meta">
			<cfset LOCAL.TYPE = LOCAL.TYPE & "'" & LOCAL.meta.column_name & "':'" & LOCAL.meta.data_type & "'">
			<cfset LOCAL.SIZE = LOCAL.SIZE & "'" & LOCAL.meta.column_name & "':'" & LOCAL.meta.maximum_length & "'">
			<cfif not LOCAL.meta.isLast()>
				<cfset LOCAL.TYPE = LOCAL.TYPE & ",">
				<cfset LOCAL.SIZE = LOCAL.SIZE & ",">
			</cfif>
		</cfloop>
		<cfset LOCAL.TYPE = LOCAL.TYPE & "}">
		<cfset LOCAL.SIZE = LOCAL.SIZE & "}">
		<cfreturn "{" & LOCAL.TYPE & "," & LOCAL.SIZE & "}">
	</cffunction>

</cfcomponent>
