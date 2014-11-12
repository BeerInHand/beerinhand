<cfcomponent output="false" extends="explorer">

	<cfset init() />

	<cffunction name="init" returntype="users" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfset THIS.table = "users" />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryUsers" access="public" returnType="query" output="false">
		<cfargument name="us_usid" type="numeric" required="false" />
		<cfargument name="us_user" type="string" required="false" />
		<cfargument name="us_pwd" type="string" required="false" />
		<cfargument name="incPwd" type="string" required="false" />
		<cfargument name="extend" type="boolean" default="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryUsers" datasource="#THIS.dsn#">
			SELECT us_usid, us_user, us_first, us_last, us_email, <cfif StructKeyExists(ARGUMENTS, "incPwd")>us_pwd,</cfif>
					 us_vunits, us_viunits, us_munits, us_hunits, us_tunits, us_eunits, us_boilvol, us_volume, us_eff, us_primer,
					 us_ratio, us_maltcap, us_thermal, us_hopform, us_hydrotemp, us_mashtype, us_datemask, us_postal, us_privacy,
					 us_offset, us_moderate, us_tweetback,
				<cfif ARGUMENTS.extend>
					 CAST(md5(us_email) AS CHAR) AS gravatar, IF(LENGTH(avatar)=0, 'zombatar.jpg', avatar) AS avatar,
				</cfif>
					 us_validated, us_added, us_dla
			  FROM users
				<cfif ARGUMENTS.extend>
					 INNER JOIN bihforum.forum_users ON username = us_user
				</cfif>
			 WHERE 0=0
			<cfif StructKeyExists(ARGUMENTS, "us_usid")>
				AND us_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.us_usid#" />
			</cfif>
			<cfif StructKeyExists(ARGUMENTS, "us_user")>
				AND us_user = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_user#" />
			</cfif>
			<cfif StructKeyExists(ARGUMENTS, "us_pwd")>
				AND us_pwd = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_pwd#" />
			</cfif>
			 ORDER BY us_usid
		</cfquery>
		<cfreturn LOCAL.qryUsers />
	</cffunction>

	<cffunction name="QueryUsersSafe" access="public" returnType="query" output="false">
		<cfargument name="us_usid" type="numeric" required="false" />
		<cfargument name="us_user" type="string" required="false" />
		<cfset var LOCAL = StructNew() />
		<cfquery name="LOCAL.qryUsers" datasource="#THIS.dsn#">
			SELECT us_usid, us_user, us_first, us_last, us_vunits, us_volume, us_mashtype, us_postal, us_added, us_dla,
					 us_munits, us_hunits, us_tunits, us_eunits, us_eff, us_primer, us_hopform,
					 CAST(md5(us_email) AS CHAR) AS gravatar, IF(LENGTH(avatar)=0, 'zombatar.jpg', avatar) AS avatar,
					 IFNULL(us_recipecnt,0) AS us_recipecnt, IFNULL(us_brewamt,0) AS us_brewamt, IFNULL(us_brewcnt,0) AS us_brewcnt
			  FROM users
					 INNER JOIN bihforum.forum_users ON username = us_user
					 LEFT OUTER JOIN (
						SELECT re_usid, COUNT(*) AS us_recipecnt,
								SUM(ConvertVolume(re_vunits, IF(re_brewed IS NOT NULL, re_volume, 0), <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#SESSION.SETTING.vunits#" />)) AS us_brewamt,
								SUM(IF(re_brewed IS NOT NULL, 1, 0)) AS us_brewcnt
						  FROM recipe
						 WHERE IF(re_usid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#udfIfDefined('SESSION.USER.usid',0)#" />, 0, re_privacy) < 2
						 GROUP BY re_usid
					 ) AS rcpstats ON re_usid = us_usid
			 WHERE 0=0
			<cfif StructKeyExists(ARGUMENTS, "us_usid")>
				AND us_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.us_usid#" />
			</cfif>
			<cfif StructKeyExists(ARGUMENTS, "us_user")>
				AND us_user = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_user#" />
			</cfif>
			 ORDER BY us_user
		</cfquery>
		<cfreturn LOCAL.qryUsers />
	</cffunction>


	<cffunction name="InsertUsers" access="public" returnType="numeric" output="false">
		<cfargument name="us_user" type="string" required="true" />
		<cfargument name="us_pwd" type="string" required="true" />
		<cfargument name="us_first" type="string" required="false" />
		<cfargument name="us_last" type="string" required="false" />
		<cfargument name="us_email" type="string" required="false" />
		<cfargument name="us_vunits" type="string" required="false" />
		<cfargument name="us_viunits" type="string" required="false" />
		<cfargument name="us_munits" type="string" required="false" />
		<cfargument name="us_hunits" type="string" required="false" />
		<cfargument name="us_tunits" type="string" required="false" />
		<cfargument name="us_eunits" type="string" required="false" />
		<cfargument name="us_boilvol" type="numeric" required="false" />
		<cfargument name="us_volume" type="numeric" required="false" />
		<cfargument name="us_eff" type="numeric" required="false" />
		<cfargument name="us_primer" type="string" required="false" />
		<cfargument name="us_ratio" type="numeric" required="false" />
		<cfargument name="us_maltcap" type="numeric" required="false" />
		<cfargument name="us_thermal" type="numeric" required="false" />
		<cfargument name="us_hopform" type="string" required="false" />
		<cfargument name="us_hydrotemp" type="numeric" required="false" />
		<cfargument name="us_mashtype" type="string" required="false" />
		<cfargument name="us_datemask" type="string" required="false" />
		<cfargument name="us_postal" type="string" required="false" />
		<cfargument name="us_privacy" type="numeric" required="false" />
		<cfargument name="us_offset" type="numeric" required="false" />
		<cfargument name="us_moderate" type="numeric" required="false" />
		<cfargument name="us_tweetback" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insUsers" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO users (
				<cfif StructKeyExists(ARGUMENTS, "us_first")>us_first,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_last")>us_last,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_email")>us_email,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_vunits")>us_vunits,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_viunits")>us_viunits,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_munits")>us_munits,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_hunits")>us_hunits,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_tunits")>us_tunits,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_eunits")>us_eunits,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_boilvol")>us_boilvol,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_volume")>us_volume,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_eff")>us_eff,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_primer")>us_primer,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_ratio")>us_ratio,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_maltcap")>us_maltcap,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_thermal")>us_thermal,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_hopform")>us_hopform,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_hydrotemp")>us_hydrotemp,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_mashtype")>us_mashtype,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_postal")>us_postal,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_privacy")>us_privacy,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_offset")>us_offset,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_moderate")>us_moderate,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_tweetback")>us_tweetback,</cfif>
				us_user, us_datemask, us_added, us_dla
			) VALUES (
				<cfif StructKeyExists(ARGUMENTS, "us_first")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_first#" maxlength="15" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_last")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_last#" maxlength="15" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_email")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_email#" maxlength="50" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_vunits")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_vunits#" maxlength="12" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_viunits")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_viunits#" maxlength="12" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_munits")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_munits#" maxlength="12" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_hunits")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_hunits#" maxlength="12" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_tunits")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_tunits#" maxlength="10" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_eunits")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_eunits#" maxlength="6" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_boilvol")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.us_boilvol#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_volume")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.us_volume#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_eff")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.us_eff#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_primer")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_primer#" maxlength="10" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_ratio")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.us_ratio#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_maltcap")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.us_maltcap#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_thermal")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.us_thermal#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_hopform")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_hopform#" maxlength="6" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_hydrotemp")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.us_hydrotemp#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_mashtype")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_mashtype#" maxlength="12" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_postal")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_postal#" maxlength="15" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_privacy")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.us_privacy#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_offset")><cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.us_offset#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_moderate")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.us_moderate#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "us_tweetback")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.us_tweetback#" />,</cfif>
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_user#" maxlength="15" />,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_datemask#" maxlength="11" />,
				NOW(), NOW()
			)
		</cfquery>
		<cfset LOCAL.usid = LOCAL.insRtn.GENERATED_KEY />
		<cfset THIS.UpdateUsers(us_usid = LOCAL.usid, us_pwd = ARGUMENTS.us_pwd) />
		<cfset  APPLICATION.CFC.Factory.get("FollowUser").InsertFollowUser(LOCAL.usid, LOCAL.usid) />
		<cfreturn LOCAL.usid />
	</cffunction>

	<cffunction name="UpdateUsers" access="public" returnType="numeric" output="false">
		<cfargument name="us_usid" type="numeric" required="true" />
		<cfargument name="us_user" type="string" required="false" />
		<cfargument name="us_first" type="string" required="false" />
		<cfargument name="us_last" type="string" required="false" />
		<cfargument name="us_email" type="string" required="false" />
		<cfargument name="us_pwd" type="string" required="false" />
		<cfargument name="us_vunits" type="string" required="false" />
		<cfargument name="us_viunits" type="string" required="false" />
		<cfargument name="us_munits" type="string" required="false" />
		<cfargument name="us_hunits" type="string" required="false" />
		<cfargument name="us_tunits" type="string" required="false" />
		<cfargument name="us_eunits" type="string" required="false" />
		<cfargument name="us_boilvol" type="numeric" required="false" />
		<cfargument name="us_volume" type="numeric" required="false" />
		<cfargument name="us_eff" type="numeric" required="false" />
		<cfargument name="us_primer" type="string" required="false" />
		<cfargument name="us_ratio" type="numeric" required="false" />
		<cfargument name="us_maltcap" type="numeric" required="false" />
		<cfargument name="us_thermal" type="numeric" required="false" />
		<cfargument name="us_hopform" type="string" required="false" />
		<cfargument name="us_hydrotemp" type="numeric" required="false" />
		<cfargument name="us_mashtype" type="string" required="false" />
		<cfargument name="us_datemask" type="string" required="false" />
		<cfargument name="us_postal" type="string" required="false" />
		<cfargument name="us_privacy" type="numeric" required="false" />
		<cfargument name="us_offset" type="numeric" required="false" />
		<cfargument name="us_moderate" type="numeric" required="false" />
		<cfargument name="us_tweetback" type="numeric" required="false" />
		<cfargument name="us_validated" type="string" required="false" />
		<cfargument name="us_sig" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updUsers" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE users
				SET <cfif StructKeyExists(ARGUMENTS, "us_first")>us_first = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_first#" maxlength="15" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_last")>us_last = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_last#" maxlength="15" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_email")>us_email = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_email#" maxlength="50" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_pwd")>us_pwd = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Hash(ARGUMENTS.us_pwd & ARGUMENTS.us_usid, "SHA-256")#" maxlength="100" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_vunits")>us_vunits = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_vunits#" maxlength="12" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_viunits")>us_viunits = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_viunits#" maxlength="12" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_munits")>us_munits = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_munits#" maxlength="12" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_hunits")>us_hunits = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_hunits#" maxlength="12" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_tunits")>us_tunits = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_tunits#" maxlength="10" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_eunits")>us_eunits = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_eunits#" maxlength="6" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_boilvol")>us_boilvol = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.us_boilvol#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_volume")>us_volume = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.us_volume#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_eff")>us_eff = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.us_eff#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_primer")>us_primer = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_primer#" maxlength="10" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_ratio")>us_ratio = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.us_ratio#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_maltcap")>us_maltcap = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.us_maltcap#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_thermal")>us_thermal = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.us_thermal#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_hopform")>us_hopform = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_hopform#" maxlength="6" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_hydrotemp")>us_hydrotemp = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.us_hydrotemp#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_mashtype")>us_mashtype = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_mashtype#" maxlength="12" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_datemask")>us_datemask = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_datemask#" maxlength="11" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_postal")>us_postal = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.us_postal#" maxlength="15" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_privacy")>us_privacy = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.us_privacy#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_offset")>us_offset = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.us_offset#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_moderate")>us_moderate = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.us_moderate#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_tweetback")>us_tweetback = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.us_tweetback#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "us_validated") AND NOT isDate(ARGUMENTS.us_validated)>us_validated = NOW(),</cfif> <!--- ONLY IF NOT DATE TO PREVENT UPDATES VIA ADMIN --->
					 us_dla = NOW()
			 WHERE us_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.us_usid#" />
		</cfquery>
		<cfif StructKeyExists(ARGUMENTS, "us_sig")>
			<cfset APPLICATION.FORUM.User.saveUser(username=SESSION.USER.user, signature=ARGUMENTS.us_sig) />
		</cfif>
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="DeleteUsers" access="public" returnType="numeric" output="false">
		<cfargument name="us_usid" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />
		<cfquery name="LOCAL.delUsers" datasource="#THIS.dsn#" result="delRtn">
			DELETE
			  FROM users
			 WHERE us_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.us_usid#" />
		</cfquery>
		<cfreturn LOCAL.delRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="CreateUserStruct" access="public" returnType="void" output="false">
		<cfargument name="us_usid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.qryUser = THIS.QueryUsers(us_usid = ARGUMENTS.us_usid, incPwd = 1, extend = 1) />
		<cfset SESSION.USER = StructNew() />
		<cfset SESSION.SETTING = StructNew() />
		<cfloop list="#LOCAL.qryUser.ColumnList#" index="col">
			<cfset LOCAL.key = ReplaceNoCase(col, "US_", "", "all") />
			<cfif ListFindNoCase("US_USID,US_USER,US_FIRST,US_LAST,US_EMAIL,US_PWD,US_POSTAL,US_DLA,US_VALIDATED,US_ADDED,AVATAR,GRAVATAR", col)>
				<cfset SESSION.USER[LOCAL.key] = LOCAL.qryUser[col][1] />
			<cfelse>
				<cfset SESSION.SETTING[LOCAL.key] = LOCAL.qryUser[col][1] />
			</cfif>
		</cfloop>
		<cfset SESSION.USER.FORUM = APPLICATION.FORUM.User.getUser(SESSION.USER.user) />
		<cfset LOCAL.roles = APPLICATION.FORUM.User.getGroupsForUser(SESSION.USER.user) />
		<cfif SESSION.USER.usid EQ 1>
			<cfset LOCAL.roles = ListAppend(LOCAL.roles, "siteadmin") />
			<cfset SESSION.SETTING.blog = APPLICATION.SETTING.blog />
		<cfelse>
			<cfset SESSION.SETTING.blog = SESSION.USER.user />
		</cfif>
		<cflogout />
		<cflogin>
			<cfloginuser name="#SESSION.USER.user#" password="#SESSION.USER.pwd#" roles="#LOCAL.roles#" />
		</cflogin>
	</cffunction>

	<cffunction name="LoginHashword" access="public" returntype="void" output="false" returnformat="JSON">
		<cfif isDefined("COOKIE.user") AND isDefined("COOKIE.hashword")>
			<cfif COOKIE.user is not "" and COOKIE.hashword is not "">
				<cfset LOCAL.qryUser = THIS.QueryUsers(us_user = COOKIE.user, us_pwd = COOKIE.hashword) />
				<cfif LOCAL.qryUser.RecordCount eq 1>
					<cfset THIS.UpdateUsers(us_usid = LOCAL.qryUser.us_usid) />
					<cflock scope="SESSION" timeout="10" type="exclusive">
						<cfset SESSION.LoggedIn = true />
						<cfset THIS.CreateUserStruct(LOCAL.qryUser.us_usid) />
					</cflock>
					<cfreturn />
				</cfif>
			</cfif>
			<cfcookie name="user" expires="now" />
			<cfcookie name="hashword" expires="now" />
		</cfif>
	</cffunction>

	<cffunction name="Login" access="public" returntype="struct" output="false" returnformat="JSON">
		<cfargument name="user" type="string" required="false" default="" />
		<cfargument name="pwd" type="string" required="false" default="" />
		<cfargument name="rem" type="string" required="false" default="" />

		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.method = "Login" />
		<cfset LOCAL.Response.validated = false />
		<cflock scope="SESSION" timeout="10" type="exclusive">
			<cfparam name="SESSION.LoginAttempts" default="0" />
			<cfset SESSION.LoginAttempts = SESSION.LoginAttempts + 1 />
		</cflock>
		<cfif SESSION.LoginAttempts gt 8>
			<cfif SESSION.LoginAttempts mod 10 eq 0>
				<cfsavecontent variable="LOCAL.body"><cfdump var="#ARGUMENTS#"/></cfsavecontent>
				<cfset APPLICATION.CFC.GlobalUDF.udfEmail(to=APPLICATION.EMAIL.admin, from=APPLICATION.EMAIL.support, subject="#SESSION.LoginAttempts# Failed Login Attempts", type="html", body=LOCAL.body) />
			</cfif>
			<cfset LOCAL.Response.LoginMsg = "Too many failed log in attempts. Try again in 6 hours." />
			<cfreturn LOCAL.Response />
		</cfif>
		<cfif ARGUMENTS.user is not "" and ARGUMENTS.pwd is not "">
			<cfset LOCAL.qryUser = THIS.QueryUsers(us_user = ARGUMENTS.user, incPwd = 1) />
			<cfset LOCAL.hashword = Hash(ARGUMENTS.pwd & LOCAL.qryUser.us_usid, "SHA-256") />
			<cfif LOCAL.qryUser.RecordCount eq 1 and Compare(LOCAL.hashword, LOCAL.qryUser.us_pwd) EQ 0>
				<cfif isDate(LOCAL.qryUser.us_validated)>
					<cfset THIS.UpdateUsers(us_usid = LOCAL.qryUser.us_usid) />
					<cflock scope="SESSION" timeout="10" type="exclusive">
						<cfset SESSION.LoggedIn = true />
						<cfset THIS.CreateUserStruct(LOCAL.qryUser.us_usid) />
						<cfset StructDelete(SESSION, "LoginAttempts") />
					</cflock>
					<cfcookie name="user" expires="never" value="#LOCAL.qryUser.us_user#" />
					<cfif ARGUMENTS.rem eq "true">
						<cfcookie name="hashword" expires="never" value="#LOCAL.hashword#" />
					</cfif>
					<cfset LOCAL.Response.validated = true />
				<cfelse>
					<cfset LOCAL.Response.LoginAttempts = SESSION.LoginAttempts />
					<cfset LOCAL.Response.LoginMsg = "Account not validated (#SESSION.LoginAttempts#)." />
				</cfif>
			<cfelse>
				<cfset LOCAL.Response.LoginAttempts = SESSION.LoginAttempts />
				<cfset LOCAL.Response.LoginMsg = "Unknown user name or password (#SESSION.LoginAttempts#)." />
			</cfif>
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="Logout" access="public" returntype="void" output="false">
		<cflock scope="SESSION" type="exclusive" timeout="5" throwontimeout="true">
			<cfset StructClear(SESSION.USER) />
			<cfset SESSION.LoggedIn = false />
		</cflock>
		<cflogout />
		<cfcookie name="hashword" expires="now" />
	</cffunction>

	<cffunction name="CheckExists" access="public" returnType="struct">
		<cfargument name="user" type="string" required="true" />
		<cfargument name="us_usid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.method = "Exists" />
		<cfquery name="LOCAL.qryDup" datasource="#THIS.dsn#">
			SELECT us_usid
			  FROM users
			 WHERE us_user = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.user#" />
			<cfif StructKeyExists(ARGUMENTS, "us_usid")>
				AND us_usid <> <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.us_usid#" />
			</cfif>
		</cfquery>
		<cfset LOCAL.Response.Exists = LOCAL.qryDup.RecordCount />
		<cfset LOCAL.Response.Valid = ReFindNoCase("[^A-Za-z0-9]", ARGUMENTS.user) EQ 0 AND LEN(ARGUMENTS.user) GT 3 />
		<cfset LOCAL.Response.User = ARGUMENTS.user />
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="SignUp" access="public" returnType="struct">
		<cfargument name="user" type="string" required="true" />
		<cfargument name="pwd" type="string" required="true" />
		<cfargument name="email" type="string" required="true" />

		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.method = "SignUp" />
		<cfset LOCAL.Response.us_usid = 0 />
		<cfset LOCAL.Response.Exists = THIS.CheckExists(user = ARGUMENTS.user).Exists />
		<cfset LOCAL.Response.Valid = ReFindNoCase("[^A-Za-z0-9]", ARGUMENTS.user) EQ 0 AND LEN(ARGUMENTS.user) GT 3 />
		<cfif (NOT LOCAL.Response.Exists) AND LOCAL.Response.Valid>
			<cfset LOCAL.ROW = StructNew() />
			<cfloop collection="#APPLICATION.SETTING#" item="LOCAL.key">
				<cfset LOCAL.ROW["us_#LOCAL.key#"] = APPLICATION.SETTING[key] />
			</cfloop>
			<cfset LOCAL.ROW.us_user = ARGUMENTS.user />
			<cfset LOCAL.ROW.us_pwd = ARGUMENTS.pwd />
			<cfset LOCAL.ROW.us_email = ARGUMENTS.email />
			<cfset LOCAL.us_usid = THIS.InsertUsers(argumentcollection = LOCAL.ROW) />
			<cfset LOCAL.Response.us_usid = JavaCast("int", LOCAL.us_usid) />
			<cfset LOCAL.Response.key = Hash(LOCAL.ROW.us_pwd & LOCAL.Response.us_usid, "SHA-256") />
			<cfset LOCAL.link = udfURLShorten("#APPLICATION.PATH.FULL#/p.signup.cfm?user=#LOCAL.ROW.us_user#&key=#LOCAL.Response.key#") />
			<cfsavecontent variable="LOCAL.body">
<cfoutput>Please click the following link to confirm your BeerInHand account:<br/><br/><a href="#LOCAL.link#">#LOCAL.link#</a></cfoutput>
			</cfsavecontent>
			<cfset APPLICATION.CFC.GlobalUDF.udfEmail(to=LOCAL.ROW.us_email, from=APPLICATION.EMAIL.failto, subject="BeerInHand Confirmation Email For #LOCAL.ROW.us_user#", type="html", body=LOCAL.body) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="Validate" access="public" returntype="struct" output="false">
		<cfargument name="user" type="string" required="true" default="" />
		<cfargument name="key" type="string" required="true" default="" />

		<cfset LOCAL.Response.validated = false />
		<cflock scope="SESSION" timeout="10" type="exclusive">
			<cfparam name="SESSION.LoginAttempts" default="0" />
			<cfset SESSION.LoginAttempts = SESSION.LoginAttempts + 1 />
		</cflock>
		<cfif SESSION.LoginAttempts gt 8>
			<cfif SESSION.LoginAttempts mod 10 eq 0>
				<cfsavecontent variable="LOCAL.body"><cfdump var="#ARGUMENTS#"/></cfsavecontent>
				<cfset APPLICATION.CFC.GlobalUDF.udfEmail(to=APPLICATION.EMAIL.admin, from=APPLICATION.EMAIL.support, subject="#SESSION.LoginAttempts# Failed Validation Attempts", type="html", body=LOCAL.body) />
			</cfif>
			<cfreturn LOCAL.Response />
		</cfif>
		<cfif ARGUMENTS.user is not "" and ARGUMENTS.key is not "">
			<cfset LOCAL.qryUser = THIS.QueryUsers(us_user = ARGUMENTS.user, us_pwd = ARGUMENTS.key) />
			<cfif LOCAL.qryUser.RecordCount>
				<cfif NOT isDate(LOCAL.qryUser.us_validated)>
					<cfset THIS.UpdateUsers(us_usid = LOCAL.qryUser.us_usid, us_validated = 1) />
					<cfset APPLICATION.FORUM.User.addUser(LOCAL.qryUser.US_USID, LOCAL.qryUser.US_USER, "", LOCAL.qryUser.US_EMAIL, "forumsmember") />
					<cfset LOCAL.Response.validated = true />
					<cflock scope="SESSION" timeout="10" type="exclusive">
						<cfset StructDelete(SESSION, "LoginAttempts") />
					</cflock>
					<cfcookie name="user" expires="never" value="#LOCAL.qryUser.us_user#" />
				</cfif>
			<cfelse>
				<cfset LOCAL.Response.LoginAttempts = SESSION.LoginAttempts />
			</cfif>
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="ForgotSend" access="public" returntype="struct" output="false">
		<cfargument name="user" type="string" required="true" default="" />

		<cfset LOCAL.Response.validated = false />
		<cflock scope="SESSION" timeout="10" type="exclusive">
			<cfparam name="SESSION.LoginAttempts" default="0" />
			<cfset SESSION.LoginAttempts = SESSION.LoginAttempts + 1 />
		</cflock>
		<cfif SESSION.LoginAttempts gt 8>
			<cfif SESSION.LoginAttempts mod 10 eq 0>
				<cfsavecontent variable="LOCAL.body"><cfdump var="#ARGUMENTS#"/></cfsavecontent>
				<cfset APPLICATION.CFC.GlobalUDF.udfEmail(to=APPLICATION.EMAIL.admin, from=APPLICATION.EMAIL.support, subject="#SESSION.LoginAttempts# Forgot Send Attempts", type="html", body=LOCAL.body) />
			</cfif>
			<cfreturn LOCAL.Response />
		</cfif>
		<cfif ARGUMENTS.user is not "">
			<cfset LOCAL.qryUser = THIS.QueryUsers(us_user = ARGUMENTS.user, incPwd = 1) />
			<cfif LOCAL.qryUser.RecordCount>
				<cfset LOCAL.link = udfURLShorten("#APPLICATION.PATH.FULL#/p.forgot.cfm?user=#LOCAL.qryUser.us_user#&key=#LOCAL.qryUser.us_pwd#") />
				<cfsavecontent variable="LOCAL.body">
<cfoutput>A request has been made to reset your BeerInHand password. If you wish to complete this request, please click the following link:<br/><br/><a href="#LOCAL.link#">#LOCAL.link#</a></cfoutput>
				</cfsavecontent>
				<cfset APPLICATION.CFC.GlobalUDF.udfEmail(to=LOCAL.qryUser.us_email, from=APPLICATION.EMAIL.failto, subject="BeerInHand Password Reset Request For #LOCAL.qryUser.us_user#", type="html", body=LOCAL.body) />
				<cfset LOCAL.Response.validated = true />
				<cflock scope="SESSION" timeout="10" type="exclusive">
					<cfset StructDelete(SESSION, "LoginAttempts") />
				</cflock>
			<cfelse>
				<cfset LOCAL.Response.LoginAttempts = SESSION.LoginAttempts />
			</cfif>
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="RandomPassword" returntype="string" access="public" output="no" hint="creates a random password string">
		<cfargument name="passwordLength" type="numeric" default="6" required="no"/>
		<cfset LOCAL.strPassword = ''/>
		<cfset LOCAL.strLowerCaseAlpha = "abcdefghjkmnpqrstuvwxyz" />
		<cfset LOCAL.strUpperCaseAlpha = "ABCDEFGHJKLMNPQRSTUVWXYZ" />
		<cfset LOCAL.strNumbers = "123456789" />
		<cfset LOCAL.strOtherChars = "" />
		<cfset LOCAL.strAllValidChars = (LOCAL.strLowerCaseAlpha & LOCAL.strUpperCaseAlpha & LOCAL.strNumbers & LOCAL.strOtherChars) />
		<cfset LOCAL.arrPassword = ArrayNew( 1 ) />
		<cfset arrPassword[1] = MID(LOCAL.strNumbers,RandRange(1,Len(LOCAL.strNumbers)),1)/>
		<cfset arrPassword[2] = MID(LOCAL.strUpperCaseAlpha,RandRange(1,Len(LOCAL.strUpperCaseAlpha)),1)/>
		<cfset arrPassword[3] = MID(LOCAL.strLowerCaseAlpha,RandRange(1,Len(LOCAL.strLowerCaseAlpha)),1)/>
		<cfloop index="intChar" from="#(ArrayLen(LOCAL.arrPassword)+1)#" to="#arguments.passwordLength#" step="1">
			<cfset LOCAL.arrPassword[ intChar ] = Mid(LOCAL.strAllValidChars,RandRange(1,Len(LOCAL.strAllValidChars)),1)/>
		</cfloop>
		<cfset CreateObject( "java", "java.util.Collections" ).Shuffle(LOCAL.arrPassword) />
		<cfset LOCAL.strPassword = ArrayToList(LOCAL.arrPassword,"")/>
		<cfreturn LOCAL.strPassword/>
	</cffunction>

	<cffunction name="ForgotReset" access="public" returntype="struct" output="false">
		<cfargument name="user" type="string" required="true" default="" />
		<cfargument name="key" type="string" required="true" default="" />

		<cfset LOCAL.Response.validated = false />
		<cflock scope="SESSION" timeout="10" type="exclusive">
			<cfparam name="SESSION.LoginAttempts" default="0" />
			<cfset SESSION.LoginAttempts = SESSION.LoginAttempts + 1 />
		</cflock>
		<cfif SESSION.LoginAttempts gt 8>
			<cfif SESSION.LoginAttempts mod 10 eq 0>
				<cfsavecontent variable="LOCAL.body"><cfdump var="#ARGUMENTS#"/></cfsavecontent>
				<cfset APPLICATION.CFC.GlobalUDF.udfEmail(to=APPLICATION.EMAIL.admin, from=APPLICATION.EMAIL.support, subject="#SESSION.LoginAttempts# Forgot Reset Attempts", type="html", body=LOCAL.body) />
			</cfif>
			<cfreturn LOCAL.Response />
		</cfif>
		<cfif ARGUMENTS.user is not "" and ARGUMENTS.key is not "">
			<cfset LOCAL.qryUser = THIS.QueryUsers(us_user = ARGUMENTS.user, us_pwd = ARGUMENTS.key) />
			<cfif LOCAL.qryUser.RecordCount>
				<cfset LOCAL.pwd = RandomPassword() />
				<cfset THIS.UpdateUsers(us_usid = LOCAL.qryUser.us_usid, us_pwd = LOCAL.pwd) />
				<cfset LOCAL.Response.validated = true />
				<cflock scope="SESSION" timeout="10" type="exclusive">
					<cfset StructDelete(SESSION, "LoginAttempts") />
				</cflock>
				<cfset APPLICATION.CFC.GlobalUDF.udfEmail(to=LOCAL.qryUser.us_email, from=APPLICATION.EMAIL.failto, subject="BeerInHand Password Reset Confirmation For #LOCAL.qryUser.us_user#", type="html", body="Your BeerInHand password has been reset to: #LOCAL.pwd#") />
			<cfelse>
				<cfset LOCAL.Response.LoginAttempts = SESSION.LoginAttempts />
			</cfif>
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="SetAvatar" access="public" returntype="struct" output="true">
		<cfset LOCAL.Response.valid = false />
		<cfset LOCAL.Response.method = "Avatar" />
		<cfif SESSION.LoggedIn>
			<cfif StructKeyExists(FORM, "newavatar") AND len(FORM.newavatar)>
				<cffile action="upload" filefield="newavatar" destination="#APPLICATION.DISK.TEMP#" nameConflict="makeunique">
				<cfif cffile.fileWasSaved>
					<cfif IsImageFile(cffile.serverdirectory & "/" & cffile.serverfile)>
						<cfset LOCAL.Response.valid = true />
						<cfset LOCAL.qryFUser = APPLICATION.FORUM.User.getUser(SESSION.USER.user)>
						<cfset LOCAL.newPath = APPLICATION.DISK.AVATARS & "/" & createUUID() & "." & cffile.serverfileext><!--- copy from temp --->
						<cfset LOCAL.Respsonse.size = cffile.fileSize />
						<cffile action="move" source="#cffile.serverdirectory#/#cffile.serverfile#" destination="#LOCAL.newPath#">
						<cfset LOCAL.myImage=ImageNew("#LOCAL.newPath#") />
						<cfset ImageSetAntialiasing(LOCAL.myImage, "on") />
						<cfset ImageScaleToFit(LOCAL.myImage,150,150)>
						<cfimage source="#LOCAL.myImage#" action="write" destination="#LOCAL.newPath#" overwrite="yes">
						<cfset LOCAL.Response.Avatar = getFileFromPath(LOCAL.newPath)>
						<cfif len(LOCAL.qryFUser.avatar) and LOCAL.qryFUser.avatar neq "@gravatar" and fileExists(APPLICATION.DISK.AVATARS & "/" & LOCAL.qryFUser.avatar)><!--- delete old --->
							<cffile action="delete" file="#APPLICATION.DISK.AVATARS#/#LOCAL.qryFUser.avatar#">
						</cfif>
						<cfset APPLICATION.FORUM.User.saveUser(username=SESSION.USER.user, avatar=LOCAL.Response.Avatar)>
		 				<!--- <cfset REQUEST.udf.cachedUserInfo(SESSION.USER.user, false)> --->
					<cfelse>
						<cfset LOCAL.Response.errors ="File uploaded was not valid." />
						<cffile action="delete" file="#cffile.serverdirectory#/#cffile.serverfile#">
					</cfif>
				<cfelse>
					<cfset LOCAL.Response.errors ="Uploaded file was not saved." />
				</cfif>
			<cfelse>
				<cfset LOCAL.Response.errors ="Form not found." />
			</cfif>
		<cfelse>
			<cfset LOCAL.Response.errors ="You are not logged in." />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="GetAvatar" access="public" returnType="struct" output="false">
		<cfargument name="us_usid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.us_usid = JavaCast("int", ARGUMENTS.us_usid) />
		<cfset LOCAL.Response.method ="Avatar" />

		<cfquery name="LOCAL.qryUser" datasource="#THIS.dsn#">
			SELECT avatar, us_email
			  FROM users
					 INNER JOIN bihforum.forum_users ON username = us_user
					 AND us_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.us_usid#" />
		</cfquery>
		<cfif LOCAL.qryUser.avatar is "@gravatar">
			<cfset LOCAL.Response.avatar = "http://www.gravatar.com/avatar.php?gravatar_id=#lcase(hash(LOCAL.qryUser.us_email))#&amp;rating=PG&amp;size=150&amp;default=#APPLICATION.PATH.AVATARS#/zombatar.jpg" />
		<cfelse>
			<cfset LOCAL.Response.avatar = "#APPLICATION.PATH.AVATARS#/#LOCAL.qryUser.avatar#" />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="ValidateUsers" access="public" returntype="numeric" output="false">
		<cfargument name="us_usid" type="numeric" default="0" />
		<cfif THIS.UpdateUsers(us_usid = ARGUMENTS.us_usid, us_validated = 1)>
			<cfset LOCAL.qryUser = THIS.QueryUsers(us_usid = ARGUMENTS.us_usid) />
			<cfset APPLICATION.FORUM.User.addUser(LOCAL.qryUser.us_user, "", LOCAL.qryUser.us_email, "forumsmember") />
			<cfreturn 1 />
		</cfif>
		<cfreturn 0 />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfif isUserInRole("siteadmin")>
			<cfset LOCAL.Response.us_usid = JavaCast("int", ARGUMENTS.us_usid) />
		<cfelse>
			<cfset LOCAL.Response.us_usid = JavaCast("int", SESSION.USER.usid) />
		</cfif>
		<cfset ARGUMENTS.us_usid = LOCAL.Response.us_usid />
		<cfif StructKeyExists(ARGUMENTS, "kill")>
			<cfset LOCAL.Response.method="Delete" />
		<cfelseif StructKeyExists(ARGUMENTS, "validate")>
			<cfset LOCAL.Response.method="Validate" />
		<cfelseif LOCAL.Response.us_usid neq 0>
			<cfset LOCAL.Response.method="Update" />
		<cfelse>
			<cfset LOCAL.Response.method="Insert" />
		</cfif>
		<cfinvoke method="#LOCAL.Response.method#Users" returnvariable="LOCAL.rtn">
			<cfloop collection="#ARGUMENTS#" item="LOCAL.key">
				<cfif ARGUMENTS[LOCAL.key] neq "null">
					<cfinvokeargument name="#LOCAL.key#" value="#ARGUMENTS[LOCAL.key]#" />
				</cfif>
			</cfloop>
		</cfinvoke>
		<cfif LOCAL.Response.method eq "Insert">
			<cfset LOCAL.Response.us_usid = JavaCast("int", LOCAL.rtn) />
		<cfelseif LOCAL.Response.method eq "Update">
			<cfset THIS.CreateUserStruct(LOCAL.Response.us_usid) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="QueryAlphaGrouping" access="public" returnType="query" output="false">
		<cfquery name="LOCAL.qryAlphaGroup" datasource="#THIS.dsn#">
			SELECT left(us_user, 1) AS us_alpha, COUNT(*) AS cntRows
			  FROM users
			 WHERE us_validated IS NOT NULL
			 GROUP BY left(us_user, 1)
			 ORDER BY us_alpha
		</cfquery>
		<cfreturn LOCAL.qryAlphaGroup />
	</cffunction>

	<cffunction name="GetExplorerNodes" access="public" returntype="struct">
		<cfargument name="root" type="string" required="Yes" />
		<cfargument name="incStruct" type="boolean" default="false" />
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.method = "Get" />
		<cfset LOCAL.node = ListFirst(root, "!") />
		<cfset LOCAL.value = ListLast(root, "!") />
		<cfif LOCAL.node eq "source">
			<cfset LOCAL.tree = ArrayNew(1) />
			<cfset ArrayAppend(LOCAL.tree, AddNode("trUsers", " Brewers", "nodeRoot", true, [])) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("US_ALPHA", "Rolodex", "nodeFolder", true, GetNodeChildren("users", "us_alpha", "US_ALPHA", THIS.QueryAlphaGrouping() ))) />
			<cfset ArrayAppend(LOCAL.tree[1].children, AddNode("US_MASHTYPE", "Brewing Type", "nodeFolder", false, true)) />
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(LOCAL.tree) />
			<cfif ARGUMENTS.incStruct><cfset LOCAL.Response.tree = LOCAL.tree /></cfif>
		<cfelseif LOCAL.node eq "US_MASHTYPE">
			<cfset LOCAL.Response["nodeJSON"] = SerializeJSON(GetNodeChildren("users", "us_mashtype", LOCAL.node, false)) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="GetTreeNodes" access="public" returntype="array">
		<cfset LOCAL.tree = ArrayNew(1) />
		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QueryAlphaGrouping() />
		<cfoutput query="LOCAL.qry">
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("US_USER!^#US_ALPHA#", "#US_ALPHA#<i>#cntRows#</i>", "nodeEnd", false, [])) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="Rolodex", nodes=LOCAL.branch }) />
		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QueryDataGroup("US_MASHTYPE") />
		<cfoutput query="LOCAL.qry">
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("US_MASHTYPE!#US_MASHTYPE#", "#US_MASHTYPE#<i>#cntRows#</i>", "nodeEnd", false, [])) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="Mash Type", nodes=LOCAL.branch }) />
		<cfreturn LOCAL.tree />
	</cffunction>

</cfcomponent>