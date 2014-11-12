<cfparam name="FORM.tabname" default="">
<cfparam name="FORM.tabnick" default="">
<cfquery datasource="bih" name="qryTabs">
	select table_name
	  from information_schema.TABLES
	 where table_schema='bih'
	 order by table_name
</cfquery>

<cfform method="post">
	<cfoutput>
	Table Name: <cfselect name="tabname" value="table_name" query="qryTabs" size="1" selected="#FORM.tabname#" onchange="this.form.tabnick.value=this.value"></cfselect><br>
	Table Nick Name: <input type="text" name="tabnick" value="#FORM.tabnick#"/><br>
	Include Table Name? <input type="Checkbox" name="inctab"><br>
	Optional Inputs? <input type="Checkbox" name="optinp" <cfif isDefined("FORM.optinp")>checked</cfif>><br>
	<input type="submit">
	</cfoutput>
</cfform>
<cfif FORM.tabname is not "">
	<cfquery datasource="bih" name="qry">
		SELECT *,
					CASE DATA_TYPE
						WHEN "bigint"		THEN "numeric"
						WHEN "bit"			THEN "boolean"
						WHEN "char"			THEN "string"
						WHEN "date"			THEN "string"
						WHEN "datetime"	THEN "string"
						WHEN "decimal"		THEN "numeric"
						WHEN "double"		THEN "numeric"
						WHEN "float"		THEN "numeric"
						WHEN "int"			THEN "numeric"
						WHEN "longtext"	THEN "string"
						WHEN "mediumint"	THEN "numeric"
						WHEN "mediumtext"	THEN "string"
						WHEN "smallint"	THEN "numeric"
						WHEN "text"			THEN "string"
						WHEN "timestamp"	THEN "string"
						WHEN "tinyint"		THEN "numeric"
						WHEN "tinytext"	THEN "string"
						WHEN "varchar"		THEN "string"
						ELSE CONCAT("UNKNOWN_", DATA_TYPE)
					END AS ARG_TYPE,
					CASE DATA_TYPE
						WHEN "bigint"		THEN "CF_SQL_BIGINT"
						WHEN "bit"			THEN "CF_SQL_BIT"
						WHEN "blob"			THEN "CF_SQL_BLOB"
						WHEN "longblob"	THEN "CF_SQL_BLOB"
						WHEN "mediumblob"	THEN "CF_SQL_BLOB"
						WHEN "char"			THEN "CF_SQL_CHAR"
						WHEN "date"			THEN "CF_SQL_DATE"
						WHEN "double"		THEN "CF_SQL_DOUBLE"
						WHEN "decimal"		THEN "CF_SQL_FLOAT"
						WHEN "float"		THEN "CF_SQL_FLOAT"
						WHEN "int"			THEN "CF_SQL_INTEGER"
						WHEN "mediumint"	THEN "CF_SQL_INTEGER"
						WHEN "smallint"	THEN "CF_SQL_SMALLINT"
						WHEN "datetime"	THEN "CF_SQL_TIMESTAMP"
						WHEN "time"			THEN "CF_SQL_TIME"
						WHEN "timestamp"	THEN "CF_SQL_TIMESTAMP"
						WHEN "tinyint"		THEN "CF_SQL_TINYINT"
						WHEN "longtext"	THEN "CF_SQL_VARCHAR"
						WHEN "mediumtext"	THEN "CF_SQL_VARCHAR"
						WHEN "text"			THEN "CF_SQL_VARCHAR"
						WHEN "tinytext"	THEN "CF_SQL_VARCHAR"
						WHEN "varchar"		THEN "CF_SQL_VARCHAR"
						ELSE CONCAT("UNKNOWN_", DATA_TYPE)
					END AS QP_TYPE,
					CASE DATA_TYPE
						WHEN "longtext"	THEN INSERT(" maxlength="" """, 13, 1, CHARACTER_MAXIMUM_LENGTH)
						WHEN "mediumtext"	THEN INSERT(" maxlength="" """, 13, 1, CHARACTER_MAXIMUM_LENGTH)
						WHEN "text"			THEN INSERT(" maxlength="" """, 13, 1, CHARACTER_MAXIMUM_LENGTH)
						WHEN "tinytext"	THEN INSERT(" maxlength="" """, 13, 1, CHARACTER_MAXIMUM_LENGTH)
						WHEN "varchar"		THEN INSERT(" maxlength="" """, 13, 1, CHARACTER_MAXIMUM_LENGTH)
						ELSE ""
					END AS QP_MAXLEN,
					CASE DATA_TYPE
						WHEN "bigint"		THEN "numeric"
						WHEN "decimal"		THEN "numeric"
						WHEN "double"		THEN "numeric"
						WHEN "float"		THEN "numeric"
						WHEN "int"			THEN "numeric"
						WHEN "mediumint"	THEN "numeric"
						WHEN "smallint"	THEN "numeric"
						WHEN "tinyint"		THEN "numeric"
						ELSE "string_noCase"
					END AS GRID_TYPE,
					CASE DATA_TYPE
						WHEN "char"			THEN CHARACTER_MAXIMUM_LENGTH
						WHEN "longtext"	THEN CHARACTER_MAXIMUM_LENGTH
						WHEN "mediumtext"	THEN CHARACTER_MAXIMUM_LENGTH
						WHEN "text"			THEN CHARACTER_MAXIMUM_LENGTH
						WHEN "tinytext"	THEN CHARACTER_MAXIMUM_LENGTH
						WHEN "varchar"		THEN CHARACTER_MAXIMUM_LENGTH
						ELSE 10
					END AS GRID_MAXLEN,
					IF(COLUMN_KEY<>"" AND DATA_TYPE='int', 'KEY', '') AS SEARCH_KEY,
					IF(IS_NULLABLE="YES", "false", "true") AS ARG_REQUIRED
		  FROM information_schema.COLUMNS
		 WHERE TABLE_SCHEMA='bih'
			AND TABLE_NAME='#FORM.tabname#'
		 ORDER BY ORDINAL_POSITION
	</cfquery>
	<cfquery name="qryKeys" dbtype="query">
		SELECT *
		  FROM qry
		 WHERE COLUMN_KEY <> ''
		 ORDER BY ORDINAL_POSITION
	</cfquery>
	<cfset TABDOT = "">
	<cfif isDefined("FORM.inctab")><cfset TABDOT = FORM.tabname & "."></cfif>
	<cfset COLLIST = "" />
	<cfset CR = chr(13) & chr(10) />
	<cfset QT = chr(34) />
	<cfset OB = chr(60) />
	<cfset CB = chr(62) />
	<cfset TB = chr(9) />
	<cfset SP = chr(32) />
	<cfset OB = "&lt;" />
	<cfset CB = "&gt;" />
	<cfset STRING50="                                                  " />
	<cfset outInsertArgs = "" />
	<cfset outInsertQueryCols = "">
	<cfset outInsertQueryColsReq = "">
	<cfset outInsertQueryParam = "">
	<cfset outInsertQueryParamReq = "">
	<cfset outUpdateArgs = "">
	<cfset outUpdateQueryColumn = "">
	<cfset outFormFields = "">
	<cfset outFormInvoke = "">
	<cfset outGridColumns = "">
	<cfset primary = "">
	<cfoutput query="qry">
		<cfif collist neq ""><cfset collist = collist & ", "></cfif>
		<cfset collist = collist & column_name>
		<cfif COLUMN_KEY EQ "PRI">
			<cfset primary = column_name>
			<cfset outUpdateArgs = outUpdateArgs & "		#OB#cfargument name=#QT##COLUMN_NAME##QT# type=#QT##ARG_TYPE##QT# required=#QT##ARG_REQUIRED##QT# /#CB##CR#">
		<cfelse>
			<cfif SEARCH_KEY EQ "KEY">
				<cfset outInsertArgs = outInsertArgs & "		#OB#cfargument name=#QT##COLUMN_NAME##QT# type=#QT##ARG_TYPE##QT# required=#QT##ARG_REQUIRED##QT# /#CB##CR#">
				<cfset outInsertQueryParamReq = ListAppend(outInsertQueryParamReq, "				#OB#cfqueryparam cfsqltype=#QT##QP_TYPE##QT# value=#QT###ARGUMENTS.#COLUMN_NAME####QT##ToString(QP_MAXLEN)# /#CB#")>
				<cfset outInsertQueryColsReq = ListAppend(outInsertQueryColsReq, "#TABDOT##COLUMN_NAME#") />
				<cfset outUpdateArgs = outUpdateArgs & "		#OB#cfargument name=#QT##COLUMN_NAME##QT# type=#QT##ARG_TYPE##QT# required=#QT##ARG_REQUIRED##QT# /#CB##CR#">
			<cfelse>
				<cfif ListFindNoCase("date",DATA_TYPE)>
					<cfset outInsertQueryParam = outInsertQueryParam & "				#OB#cfif isDefined(#QT#ARGUMENTS.#COLUMN_NAME##QT#)#CB##OB#cfqueryparam cfsqltype=#QT##QP_TYPE##QT# value=#QT###ARGUMENTS.#COLUMN_NAME####QT# null=#QT###not IsDate(ARGUMENTS.#COLUMN_NAME#)###QT# /#CB#,#OB#/cfif#CB##CR#">
					<cfset outUpdateQueryColumn = outUpdateQueryColumn & "					 #OB#cfif isDefined(#QT#ARGUMENTS.#COLUMN_NAME##QT#)#CB##TABDOT##COLUMN_NAME# = #OB#cfqueryparam cfsqltype=#QT##QP_TYPE##QT# value=#QT###ARGUMENTS.#COLUMN_NAME####QT# null=#QT###not IsDate(ARGUMENTS.#COLUMN_NAME#)###QT# /#CB#,#OB#/cfif#CB##CR#">
				<cfelse>
					<cfif qry.isLast()>
						<cfif DATA_TYPE EQ "timestamp">
							<cfset outInsertQueryColsReq = ListAppend(outInsertQueryColsReq, "#TABDOT##COLUMN_NAME#") />
							<cfset outInsertQueryParamReq = ListAppend(outInsertQueryParamReq, "				NOW()")>
							<cfset outUpdateQueryColumn = outUpdateQueryColumn & "					 #TABDOT##COLUMN_NAME# = NOW()#CR#">
						<cfelse>
							<cfset outUpdateQueryColumn = outUpdateQueryColumn & "					 #TABDOT##COLUMN_NAME# = #OB#cfif isDefined(#QT#ARGUMENTS.#COLUMN_NAME##QT#)#CB##OB#cfqueryparam cfsqltype=#QT##QP_TYPE##QT# value=#QT###ARGUMENTS.#COLUMN_NAME####QT##ToString(QP_MAXLEN)# /#CB##OB#cfelse>#TABDOT##COLUMN_NAME##OB#/cfif#CB##CR#">
						</cfif>
					<cfelse>
						<cfset outUpdateQueryColumn = outUpdateQueryColumn & "					 #OB#cfif isDefined(#QT#ARGUMENTS.#COLUMN_NAME##QT#)#CB##TABDOT##COLUMN_NAME# = #OB#cfqueryparam cfsqltype=#QT##QP_TYPE##QT# value=#QT###ARGUMENTS.#COLUMN_NAME####QT##ToString(QP_MAXLEN)# /#CB#,#OB#/cfif#CB##CR#">
					</cfif>
					<cfif DATA_TYPE NEQ "timestamp">
						<cfif ARG_REQUIRED EQ "YES">
							<cfset outInsertArgs = outInsertArgs & "		#OB#cfargument name=#QT##COLUMN_NAME##QT# type=#QT##ARG_TYPE##QT# required=#QT##ARG_REQUIRED##QT# /#CB##CR#">
							<cfset outInsertQueryColsReq = ListAppend(outInsertQueryColsReq, "#TABDOT##COLUMN_NAME#") />
							<cfset outInsertQueryParamReq = ListAppend(outInsertQueryParamReq, "				#OB#cfqueryparam cfsqltype=#QT##QP_TYPE##QT# value=#QT###ARGUMENTS.#COLUMN_NAME####QT##ToString(QP_MAXLEN)# /#CB#")>
						<cfelse>
							<cfset outInsertArgs = outInsertArgs & "		#OB#cfargument name=#QT##COLUMN_NAME##QT# type=#QT##ARG_TYPE##QT# required=#QT##ARG_REQUIRED##QT# /#CB##CR#">
							<cfset outInsertQueryCols = outInsertQueryCols & "				#OB#cfif isDefined(#QT#ARGUMENTS.#COLUMN_NAME##QT#)#CB##TABDOT##COLUMN_NAME#,#OB#/cfif#CB##CR#">
							<cfset outInsertQueryParam = outInsertQueryParam & "				#OB#cfif isDefined(#QT#ARGUMENTS.#COLUMN_NAME##QT#)#CB##OB#cfqueryparam cfsqltype=#QT##QP_TYPE##QT# value=#QT###ARGUMENTS.#COLUMN_NAME####QT##ToString(QP_MAXLEN)# /#CB#,#OB#/cfif#CB##CR#">
						</cfif>
						<cfset outUpdateArgs = outUpdateArgs & "		#OB#cfargument name=#QT##COLUMN_NAME##QT# type=#QT##ARG_TYPE##QT# required=#QT##ARG_REQUIRED##QT# /#CB##CR#">
					</cfif>
				</cfif>
			</cfif>
		</cfif>

		<cfif GRID_MAXLEN lt 128>
			<cfset outFormFields = outFormFields & "#OB#tr#CB##OB#td#CB##column_name##OB#/td#CB##OB#td#CB##OB#input name=#QT##column_name##QT# type=#QT#text#QT# value=#QT####column_name####QT# maxlength=#QT##GRID_MAXLEN##QT# /#CB##OB#/td#CB##OB#/tr#CB##CR#">
		<cfelse>
			<cfset outFormFields = outFormFields & "#OB#tr#CB##OB#td#CB##column_name##OB#/td#CB##OB#td#CB##OB#textarea rows=3 cols=50 name=#QT##column_name##QT##CB####column_name####OB#/textarea#CB##OB#/td#CB##OB#/tr#CB##CR#">
		</cfif>
		<cfset outFormInvoke = outFormInvoke & "#OB#cfif isDefined(#QT#FORM.#column_name##QT#)#CB##OB#cfinvokeargument name=#QT##column_name##QT# value=#QT###FORM.#column_name####QT# /#CB##OB#/cfif#CB##CR#">
		<cfset g_head = left("header=#QT##right(COLUMN_NAME,len(COLUMN_NAME)-3)##QT##STRING50#", 25)>
		<cfset g_name = left("name=#QT##COLUMN_NAME##QT##STRING50#", 25)>
		<cfset g_width = left("width=#QT##GRID_MAXLEN*9##QT##STRING50#", 12)>
		<cfset g_type = "type=#QT##GRID_TYPE##QT#">
		<cfset outGridColumns = outGridColumns & "#OB#cfgridcolumn #g_name# #g_head# #g_width# #g_type# /#CB##CR#">
	</cfoutput>
	<cfoutput>

	TABLE COLUMN LIST<BR>
	<textarea cols=140 rows=3>#collist#</textarea><br>
	TABLE CFC<br>
	<textarea cols=140 rows=50>
#OB#cfcomponent output=#QT#false#QT# #CB##CR#
#CR#
#TB##OB#cfset init() /#CB##CR#
#CR#
#TB##OB#cffunction name=#QT#init#QT# returntype=#QT##FORM.tabname##QT# output=#QT#false#QT##CB##CR#
#TB##TB##OB#cfargument name=#QT#dsn#QT# type=#QT#string#QT# required=#QT#false#QT# default=#QT###APPLICATION.DSN.MAIN###QT# /#CB##CR#
#TB##TB##OB#cfset THIS.dsn = ARGUMENTS.dsn /#CB##CR#
#TB##TB##OB#cfreturn THIS /#CB##CR#
#TB##OB#/cffunction#CB##CR#
#CR#

#TB##OB#cffunction name=#QT#Query#FORM.tabnick##QT# access=#QT#public#QT# returnType=#QT#query#QT# output=#QT#false#QT##CB##CR#
<cfloop query="qryKeys">
#TB##TB##OB#cfargument name=#QT##COLUMN_NAME##QT# type=#QT##ARG_TYPE##QT# required=#QT#false#QT# /#CB##CR#
</cfloop>
#TB##TB##OB#cfset var LOCAL = StructNew() /#CB##CR#
#CR#
#TB##TB##OB#cfquery name=#QT#LOCAL.qry#FORM.tabnick##QT# datasource=#QT###THIS.dsn###QT##CB##CR#
#TB##TB##TB#SELECT #collist##CR#
#TB##TB##TB##SP##SP#FROM #FORM.tabname##CR#
#TB##TB##TB##SP#WHERE 0=0#CR#
<cfloop query="qryKeys">
#TB##TB##TB##OB#cfif isDefined(#QT#ARGUMENTS.#COLUMN_NAME##QT#)#CB##CR#
#TB##TB##TB##TB#AND #COLUMN_NAME# = #OB#cfqueryparam cfsqltype=#QT##QP_TYPE##QT# value=#QT###ARGUMENTS.#COLUMN_NAME####QT# /#CB##CR#
#TB##TB##TB##OB#/cfif#CB##CR#
</cfloop>
#TB##TB##TB##SP#ORDER BY #primary##CR#
#TB##TB##OB#/cfquery#CB##CR#
#TB##TB##OB#cfreturn LOCAL.qry#FORM.tabnick# /#CB##CR#
#TB##OB#/cffunction#CB##CR#
#CR#
#TB##OB#cffunction name=#QT#Insert#FORM.tabnick##QT# access=#QT#public#QT# returnType=#QT#numeric#QT# output=#QT#false#QT##CB##CR#
#outInsertArgs#
#TB##TB##OB#cfset var LOCAL = StructNew() /#CB##CR#
#CR#
#TB##TB##OB#cfquery name=#QT#LOCAL.ins#FORM.tabnick##QT# datasource=#QT###THIS.dsn###QT# result=#QT#LOCAL.insRtn#QT##CB##CR#
#TB##TB##TB#INSERT INTO #FORM.tabname# (#CR#
#outInsertQueryCols#
#TB##TB##TB##TB##Replace(outInsertQueryColsReq, ',', ', ', 'ALL')##CR#
#TB##TB##TB#) VALUES (#CR#
#outInsertQueryParam#
#Replace(outInsertQueryParamReq, ',', ',#CR#', 'ALL')##CR#
#TB##TB##TB#)#CR#
#TB##TB##OB#/cfquery#CB##CR#
#TB##TB##OB#cfreturn LOCAL.insRtn.GENERATED_KEY /#CB##CR#
#TB##OB#/cffunction#CB##CR#
#CR#
#TB##OB#cffunction name=#QT#Update#FORM.tabnick##QT# access=#QT#public#QT# returnType=#QT#numeric#QT# output=#QT#false#QT##CB##CR#
#outUpdateArgs#
#TB##TB##OB#cfset var LOCAL = StructNew() /#CB##CR#
#CR#
#TB##TB##OB#cfquery name=#QT#LOCAL.upd#FORM.tabnick##QT# datasource=#QT###THIS.dsn###QT# result=#QT#LOCAL.updRtn#QT##CB##CR#
#TB##TB##TB#UPDATE #FORM.tabname##CR#
#TB##TB##TB##TB#SET #TRIM(outUpdateQueryColumn)##CR#
<cfloop query="qryKeys"><cfif qryKeys.isFirst()><cfset clause = " WHERE"><cfelse><cfset clause = "	AND"></cfif>
<cfif COLUMN_KEY EQ "PRI">
#TB##TB##TB##clause# #TABDOT##COLUMN_NAME# = #OB#cfqueryparam cfsqltype=#QT##QP_TYPE##QT# value=#QT###ARGUMENTS.#COLUMN_NAME####QT# /#CB##CR#
<cfelseif SEARCH_KEY EQ "KEY">
#TB##TB##TB##OB#cfif isDefined(#QT#ARGUMENTS.#COLUMN_NAME##QT#)#CB##CR#
#TB##TB##TB##clause# #TABDOT##COLUMN_NAME# = #OB#cfqueryparam cfsqltype=#QT##QP_TYPE##QT# value=#QT###ARGUMENTS.#COLUMN_NAME####QT##ToString(QP_MAXLEN)# /#CB##CR#
#TB##TB##TB##OB#/cfif#CB##CR#
</cfif>
</cfloop>
#TB##TB##OB#/cfquery#CB##CR#
#TB##TB##OB#cfreturn LOCAL.updRtn.RecordCount /#CB##CR#
#TB##OB#/cffunction#CB##CR#
#CR#
#TB##OB#cffunction name=#QT#Delete#FORM.tabnick##QT# access=#QT#public#QT# returnType=#QT#numeric#QT# output=#QT#false#QT##CB##CR#
<cfloop query="qryKeys">
<cfif SEARCH_KEY EQ "KEY">
#TB##TB##OB#cfargument name=#QT##COLUMN_NAME##QT# type=#QT##ARG_TYPE##QT# required=#QT#true#QT# /#CB##CR#
</cfif>
</cfloop>
#TB##TB##OB#cfset var LOCAL = StructNew() /#CB##CR#
#CR#
#TB##TB##OB#cfquery name=#QT#LOCAL.del#FORM.tabnick##QT# datasource=#QT###THIS.dsn###QT# result=#QT#LOCAL.delRtn#QT##CB##CR#
#TB##TB##TB#DELETE#CR#
#TB##TB##TB##SP##SP#FROM #FORM.tabname##CR#
<cfloop query="qryKeys"><cfif qryKeys.isFirst()><cfset clause = " WHERE"><cfelse><cfset clause = "	AND"></cfif>
<cfif COLUMN_KEY EQ "PRI">
#TB##TB##TB##clause# #TABDOT##COLUMN_NAME# = #OB#cfqueryparam cfsqltype=#QT##QP_TYPE##QT# value=#QT###ARGUMENTS.#COLUMN_NAME####QT# /#CB##CR#
<cfelseif SEARCH_KEY EQ "KEY">
#TB##TB##TB##OB#cfif isDefined(#QT#ARGUMENTS.#COLUMN_NAME##QT#)#CB##CR#
#TB##TB##TB##clause# #TABDOT##COLUMN_NAME# = #OB#cfqueryparam cfsqltype=#QT##QP_TYPE##QT# value=#QT###ARGUMENTS.#COLUMN_NAME####QT##ToString(QP_MAXLEN)# /#CB##CR#
#TB##TB##TB##OB#/cfif#CB##CR#
</cfif>
</cfloop>
#TB##TB##OB#/cfquery#CB##CR#
#TB##TB##OB#cfreturn LOCAL.delRtn.RecordCount /#CB##CR#
#TB##OB#/cffunction#CB##CR#
#CR#
#TB##OB#cffunction name="Process" access="public" returnType="struct"#CB##CR#
#TB##TB##OB#cfset var LOCAL = StructNew() /#CB##CR#
#TB##TB##OB#cfset LOCAL.Response.#primary# = JavaCast("int", ARGUMENTS.#primary#) /#CB##CR#
#TB##TB##OB#cfif IsDefined("ARGUMENTS.kill")#CB##CR#
#TB##TB##TB##OB#cfset LOCAL.Response.method="Delete" /#CB##CR#
#TB##TB##OB#cfelseif LOCAL.Response.#primary# neq 0#CB##CR#
#TB##TB##TB##OB#cfset LOCAL.Response.method="Update" /#CB##CR#
#TB##TB##OB#cfelse#CB##CR#
#TB##TB##TB##OB#cfset LOCAL.Response.method="Insert" /#CB##CR#
#TB##TB##OB#/cfif#CB##CR#
#TB##TB##OB#cfinvoke method="##LOCAL.Response.method###FORM.tabnick#" returnvariable="LOCAL.rtn"#CB##CR#
#TB##TB##TB##OB#cfloop collection="##ARGUMENTS##" item="LOCAL.key"#CB##CR#
#TB##TB##TB##TB##OB#cfif ARGUMENTS[LOCAL.key] neq "null"#CB##CR#
#TB##TB##TB##TB##TB##OB#cfinvokeargument name="##LOCAL.key##" value="##ARGUMENTS[LOCAL.key]##" /#CB##CR#
#TB##TB##TB##TB##OB#/cfif#CB##CR#
#TB##TB##TB##OB#/cfloop#CB##CR#
#TB##TB##OB#/cfinvoke#CB##CR#
#TB##TB##OB#cfif LOCAL.Response.method eq "Insert"#CB##CR#
#TB##TB##TB##OB#cfset LOCAL.Response.#primary# = JavaCast("int", LOCAL.rtn) /#CB##CR#
#TB##TB##OB#/cfif#CB##CR#
#TB##TB##OB#cfreturn LOCAL.Response /#CB##CR#
#TB##OB#/cffunction#CB##CR#
#CR#
#OB#/cfcomponent#CB#
	</textarea><br>
	ARGUMENTS<BR>
	<textarea cols=140 rows=#qry.RecordCount#>#outUpdateArgs#</textarea><br>
	COLUMN LIST FOR UPDATE W/QUERYPARAMS<BR>
	<textarea cols=140 rows=#qry.RecordCount#>#outUpdateQueryColumn#</textarea><br>
	COLUMN LIST FOR INSERT<BR>
	<textarea cols=140 rows=#qry.RecordCount#>#outInsertQueryCols#</textarea><br>
	VALUE LIST FOR INSERT<BR>
	<textarea cols=140 rows=#qry.RecordCount#>#outInsertQueryParam#</textarea><br>
	FORM<BR>
	<textarea cols=140 rows=#qry.RecordCount+5#>
#OB#form name=#QT#frmMe#QT# action=#QT###CGI.SCRIPT_NAME###QT# method=#QT#post#QT##CB##CR#
#OB#table#CB##CR#
#outFormFields#
#OB#tr#CB##OB#td#CB##OB#/td#CB##OB#td#CB##OB#input type=#QT#submit#QT##CB##OB#/td#CB##OB#/tr#CB##CR#
#OB#/table#CB##CR#
#OB#/form#CB##CR#
</textarea><BR>
	CFINVOKE<BR>
	<textarea cols=140 rows=#qry.RecordCount#>#outFormInvoke#</textarea><br>
	GRIDCOLUMNS<BR>
	<textarea cols=140 rows=#qry.RecordCount#>#outGridColumns#</textarea><br>

	</cfoutput>
</cfif>