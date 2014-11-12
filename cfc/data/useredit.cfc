<cfcomponent output="false" >

	<cfset init() />

	<cffunction name="init" returntype="useredit" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryUserEdit" access="public" returnType="query" output="false">
		<cfargument name="ue_ueid" type="numeric" required="false" />
		<cfargument name="ue_usid" type="numeric" required="false" />
		<cfargument name="ue_pkid" type="numeric" required="false" />
		<cfargument name="ue_table" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryUserEdit" datasource="#THIS.dsn#">
			SELECT ue_ueid, ue_usid, ue_pkid, ue_table, ue_data, ue_reason, ue_dla, us_user AS ue_user
			  FROM useredit
					 INNER JOIN users ON us_usid = ue_usid
			 WHERE 0=0
			<cfif isDefined("ARGUMENTS.ue_ueid")>
				AND ue_ueid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ue_ueid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.ue_usid")>
				AND ue_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ue_usid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.ue_table")>
				AND ue_table = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ue_table#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.ue_pkid")>
				AND ue_pkid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ue_pkid#" />
			</cfif>
			 ORDER BY ue_dla desc
		</cfquery>
		<cfreturn LOCAL.qryUserEdit />
	</cffunction>

	<cffunction name="QueryUserEditJoined" access="public" returnType="query" output="false">
		<cfargument name="ue_table" type="string" required="true" />
		<cfargument name="ue_usid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryUserEdit" datasource="#THIS.dsn#">
			SELECT ue_pkid, ue_table, ue_dla,
					<cfif ARGUMENTS.ue_table EQ "Grains">
						concat(gr_maltster, " ", gr_type) AS ue_value
					<cfelseif ARGUMENTS.ue_table EQ "Hops">
						concat(hp_hop, " ", hp_grown) AS ue_value
					<cfelseif ARGUMENTS.ue_table EQ "Misc">
						concat(mi_type, " ", mi_use) AS ue_value
					<cfelseif ARGUMENTS.ue_table EQ "Yeast">
						concat(ye_yeast, " ", ye_mfg) AS ue_value
					<cfelse>
						st_substyle AS ue_value
					</cfif>
			  FROM (
						SELECT ue_pkid, ue_table, max(ue_dla) AS ue_dla
						  FROM useredit
						 WHERE ue_table = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ue_table#" />
						<cfif isDefined("ARGUMENTS.ue_usid")>
							AND ue_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ue_usid#" />
						</cfif>
						GROUP BY ue_pkid, ue_table
					 ) AS DUE
				<cfif ARGUMENTS.ue_table EQ "Grains">
					 INNER JOIN grains ON gr_grid = ue_pkid
				<cfelseif ARGUMENTS.ue_table EQ "Hops">
					 INNER JOIN hops ON hp_hpid = ue_pkid
				<cfelseif ARGUMENTS.ue_table EQ "Misc">
					 INNER JOIN Misc ON mi_miid = ue_pkid
				<cfelseif ARGUMENTS.ue_table EQ "Yeast">
					 INNER JOIN Yeast ON ye_yeid = ue_pkid
				<cfelse>
					 INNER JOIN BJCPStyles ON st_stid = ue_pkid
				</cfif>
			 ORDER BY ue_dla desc
		</cfquery>
		<cfreturn LOCAL.qryUserEdit />
	</cffunction>

	<cffunction name="InsertUserEdit" access="public" returnType="numeric" output="false">
		<cfargument name="ue_usid" type="numeric" required="true" />
		<cfargument name="ue_pkid" type="numeric" required="true" />
		<cfargument name="ue_table" type="string" required="true" />
		<cfargument name="ue_data" type="string" required="true" />
		<cfargument name="ue_reason" type="string" default="" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insUserEdit" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO useredit (
				ue_usid, ue_pkid, ue_table, ue_data, ue_reason, ue_dla
			) VALUES (
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ue_usid#" />,
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ue_pkid#" />,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ue_table#" maxlength="20" />,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ue_data#" maxlength="65535" />,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ue_reason#" maxlength="500" />,
				NOW()
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="DeleteUserEdit" access="public" returnType="numeric" output="false">
		<cfargument name="ue_ueid" type="numeric" required="true" />
		<cfargument name="ue_usid" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delUserEdit" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM useredit
			 WHERE ue_ueid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ue_ueid#" />
				AND ue_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ue_usid#" />
		</cfquery>
		<cfreturn LOCAL.delRtn.RecordCount />
	</cffunction>

	<cffunction name="UpdateUserEdit" access="public" returnType="numeric" output="false">
		<cfargument name="ue_ueid" type="numeric" required="true" />
		<cfargument name="ue_usid" type="numeric" required="true" />
		<cfargument name="ue_data" type="string" required="false" />
		<cfargument name="ue_reason" type="string" default="" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updUserEdit" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE useredit
				SET ue_data = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ue_data#" maxlength="65535" />,
					 ue_reason = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.ue_reason#" maxlength="500" />,
					 ue_dla = NOW()
			 WHERE ue_ueid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ue_ueid#" />
				AND ue_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.ue_usid#" />
		</cfquery>
		<cfreturn LOCAL.updRtn.RecordCount />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />

		<cfif IsDefined("ARGUMENTS.fetch")>
			<cfset LOCAL.Response["qryUserEdit"] = THIS.QueryUserEdit(ue_table = ARGUMENTS.fetch, ue_pkid = ARGUMENTS.pkid) />
			<cfset LOCAL.Response.method = "Fetch" />
		<cfelse>
			<cfif NOT SESSION.LoggedIn><cfthrow message="User not logged in." /></cfif>
			<cfif IsDefined("ARGUMENTS.kill")>
				<cfinvoke method="DeleteUserEdit" returnvariable="LOCAL.rtn">
					<cfinvokeargument name="ue_usid" value="#SESSION.USER.usid#" />
					<cfinvokeargument name="ue_ueid" value="#ARGUMENTS.ue_ueid#" />
				</cfinvoke>
				<cfset LOCAL.Response.method = "Delete" />
			<cfelse>
				<cfset ARGUMENTS.ue_data = SerializeJSON(ARGUMENTS) />
				<cfset ARGUMENTS.ue_usid = SESSION.USER.usid />
				<cfif StructKeyExists(ARGUMENTS, "GR_GRID")>
					<cfset ARGUMENTS.ue_table = "Grains" />
					<cfset ARGUMENTS.ue_pkid = ARGUMENTS.GR_GRID />
				</cfif>
				<cfset ARGUMENTS.ue_ueid = THIS.QueryUserEdit(ue_usid = SESSION.USER.usid, ue_table = ARGUMENTS.ue_table, ue_pkid = ARGUMENTS.ue_pkid).ue_ueid />
				<cfif isNumeric(ARGUMENTS.ue_ueid)>
					<cfset LOCAL.Response.method = "Update" />
					<cfset LOCAL.Response.ue_ueid = JavaCast("int", ARGUMENTS.ue_ueid) />
				<cfelse>
					<cfset LOCAL.Response.method = "Insert" />
				</cfif>
				<cfinvoke method="#LOCAL.Response.method#UserEdit" returnvariable="LOCAL.rtn">
					<cfinvokeargument name="ue_usid" value="#SESSION.USER.usid#" />
					<cfinvokeargument name="ue_ueid" value="#ARGUMENTS.ue_ueid#" />
					<cfinvokeargument name="ue_pkid" value="#ARGUMENTS.ue_pkid#" />
					<cfinvokeargument name="ue_table" value="#ARGUMENTS.ue_table#" />
					<cfinvokeargument name="ue_data" value="#ARGUMENTS.ue_data#" />
					<cfinvokeargument name="ue_reason" value="#ARGUMENTS.ue_reason#" />
				</cfinvoke>
			</cfif>
			<cfif LOCAL.Response.method EQ "Insert">
				<cfset LOCAL.Response.ue_ueid = JavaCast("int", LOCAL.rtn) />
			<cfelse>
				<cfset LOCAL.Response.ue_ueid = JavaCast("int", ARGUMENTS.ue_ueid) />
			</cfif>
			<cfset LOCAL.Response["qryUserEdit"] = THIS.QueryUserEdit(ue_table = ARGUMENTS.ue_table, ue_pkid = ARGUMENTS.ue_pkid) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

</cfcomponent>
