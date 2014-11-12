<cfcomponent output="false" >

	<cfset init() />

	<cffunction name="init" returntype="followuser" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryFollowing" access="public" returnType="query" output="false">
		<cfargument name="fu_usid" type="numeric" required="true" />
		<cfargument name="fu_usid2" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryFollowUser" datasource="#THIS.dsn#">
			SELECT fu_usid, fu_usid2, us_user, CAST(md5(us_email) AS CHAR) AS gravatar, avatar, fu_dla
			  FROM followuser
					 INNER JOIN users ON us_usid = fu_usid2
					 INNER JOIN bihforum.forum_users ON username = us_user
			 WHERE fu_usid <> fu_usid2
				AND fu_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fu_usid#" />
			<cfif isDefined("ARGUMENTS.fu_usid2")>
				AND fu_usid2 = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fu_usid2#" />
			</cfif>
			 ORDER BY us_user
		</cfquery>
		<cfreturn LOCAL.qryFollowUser />
	</cffunction>

	<cffunction name="QueryFollower" access="public" returnType="query" output="false">
		<cfargument name="fu_usid2" type="numeric" required="true" />
		<cfargument name="fu_usid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryFollowUser" datasource="#THIS.dsn#">
			SELECT fu_usid, fu_usid2, us_user, us_email,
					 CAST(md5(us_email) AS CHAR) AS gravatar, IF(LENGTH(avatar)=0, 'zombatar.jpg', avatar) AS avatar,
					 fu_dla
			  FROM followuser
					 INNER JOIN users ON us_usid = fu_usid
					 INNER JOIN bihforum.forum_users ON username = us_user
			 WHERE fu_usid <> fu_usid2
				AND fu_usid2 = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fu_usid2#" />
			<cfif isDefined("ARGUMENTS.fu_usid")>
				AND fu_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fu_usid#" />
			</cfif>
			 ORDER BY us_user
		</cfquery>
		<cfreturn LOCAL.qryFollowUser />
	</cffunction>

	<cffunction name="InsertFollowUser" access="public" returnType="numeric" output="false">
		<cfargument name="fu_usid" type="numeric" required="true" />
		<cfargument name="fu_usid2" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insFollowUser" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO followuser (
				fu_usid, fu_usid2, fu_dla
			) VALUES (
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fu_usid#" />,
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fu_usid2#" />,
				NOW()
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.RecordCount />
	</cffunction>

	<cffunction name="DeleteFollowUser" access="public" returnType="numeric" output="false">
		<cfargument name="fu_usid" type="numeric" required="true" />
		<cfargument name="fu_usid2" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delFollowUser" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM followuser
			 WHERE fu_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fu_usid#" />
				AND fu_usid2 = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fu_usid2#" />
		</cfquery>
		<cfreturn LOCAL.delRtn.RecordCount />
	</cffunction>

	<cffunction name="IsFollowing" access="public" returnType="boolean" output="false">
		<cfargument name="fu_usid" type="numeric" required="true" />
		<cfargument name="fu_usid2" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryFollowUser" datasource="#THIS.dsn#">
			SELECT 1
			  FROM followuser
			 WHERE fu_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fu_usid#" />
				AND fu_usid2 = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.fu_usid2#" />
		</cfquery>
		<cfreturn LOCAL.qryFollowUser.RecordCount NEQ 0 />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfif not SESSION.LoggedIn><cfreturn {} /></cfif>
		<cfif THIS.IsFollowing(SESSION.USER.usid,ARGUMENTS.brewer)>
			<cfset LOCAL.Response.method="FollowDelete" />
			<cfinvoke method="DeleteFollowUser" returnvariable="LOCAL.rtn">
				<cfinvokeargument name="fu_usid" value="#SESSION.USER.usid#" />
				<cfinvokeargument name="fu_usid2" value="#ARGUMENTS.brewer#" />
			</cfinvoke>
		<cfelse>
			<cfset LOCAL.Response.method="FollowInsert" />
			<cfinvoke method="InsertFollowUser" returnvariable="LOCAL.rtn">
				<cfinvokeargument name="fu_usid" value="#SESSION.USER.usid#" />
				<cfinvokeargument name="fu_usid2" value="#ARGUMENTS.brewer#" />
			</cfinvoke>
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

</cfcomponent>
