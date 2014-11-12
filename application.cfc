<cfcomponent>
<cfscript>
	THIS.name = "bih";
	THIS.applicationTimeout= CreateTimeSpan(0,4,0,0);
	THIS.sessionManagement = true;
	if (StructKeyExists(COOKIE, "cfid")) {
		THIS.sessionTimeout = createTimeSpan(0,0,60,0);
	} else {
		THIS.sessionTimeout = createTimeSpan(0,0,0,2); // for bots
	}
	THIS.loginStorage="session";
	THIS.scriptProtect = "All";
</cfscript>

<cffunction name="OnApplicationStart" output="false" returntype="void">

	<cfset APPLICATION.DSN = StructNew() />
	<cfset APPLICATION.PATH = StructNew() />
	<cfset APPLICATION.MAP = StructNew() />
	<cfset APPLICATION.EMAIL = StructNew() />

	<cfset APPLICATION.DSN.MAIN = "bih" />
	<cfset APPLICATION.DSN.FORUM = "bihforum" />
	<cfset APPLICATION.DSN.BLOG = "bihforum" />

	<cfif FindNoCase("beerinhand.com", CGI.SERVER_NAME)>
		<cfset APPLICATION.PATH.FULL = "http://www.beerinhand.com" />
		<cfset APPLICATION.PATH.ROOT = "" />
		<cfset APPLICATION.DISK.ROOT = "D:\home\beerinhand.com\wwwroot" /> <!--- ExpandPath(".") --->
		<cfset APPLICATION.MAP.ROOT = "" />
		<cfset APPLICATION.EMAIL.smtp = "mail.beerinhand.com" />
		<cfset APPLICATION.IsLocal = false />
	<cfelse>
		<cfset APPLICATION.PATH.FULL = "http://#CGI.SERVER_NAME#/beerinhand" />
		<cfset APPLICATION.PATH.ROOT = "/beerinhand" />
		<cfset APPLICATION.DISK.ROOT = ExpandPath("#APPLICATION.PATH.ROOT#") />
		<cfset APPLICATION.MAP.ROOT = "beerinhand." />
		<cfset APPLICATION.EMAIL.smtp = "" />
		<cfset APPLICATION.IsLocal = true />
	</cfif>
	<cfset APPLICATION.PATH.CFC = APPLICATION.PATH.ROOT & "/cfc" />
	<cfset APPLICATION.PATH.IMG = APPLICATION.PATH.FULL & "/images" />
	<cfset APPLICATION.PATH.ATTACH = APPLICATION.PATH.FULL & "/usercontent/attachments" />
	<cfset APPLICATION.PATH.AVATARS = APPLICATION.PATH.FULL & "/usercontent/avatars" />
	<cfset APPLICATION.PATH.BLOGIMG = APPLICATION.PATH.FULL & "/usercontent/blog" />

	<!--- APP.CONTENT.ATTACH --->
	<cfset APPLICATION.DISK.ATTACH = APPLICATION.DISK.ROOT & "\usercontent\attachments" />
	<cfset APPLICATION.DISK.AVATARS = APPLICATION.DISK.ROOT & "\usercontent\avatars" />
	<cfset APPLICATION.DISK.BLOGIMG = APPLICATION.DISK.ROOT & "\usercontent\blog" />
	<cfset APPLICATION.DISK.TEMP = GetTempDirectory() />

	<cfset APPLICATION.MAP.CFC = APPLICATION.MAP.ROOT & "cfc" />

	<cfset APPLICATION.SETTING = StructNew() />
	<cfset APPLICATION.SETTING.datemask = "mm/dd/yyyy" />
	<cfset APPLICATION.SETTING.timemask = "hh:mm tt" />
	<cfset APPLICATION.SETTING.boilvol = "0.00" />
	<cfset APPLICATION.SETTING.eff = "75" />
	<cfset APPLICATION.SETTING.eunits = "SG" />
	<cfset APPLICATION.SETTING.hopform = "Pellet" />
	<cfset APPLICATION.SETTING.hunits = "Grams" />
	<cfset APPLICATION.SETTING.hydrotemp = "60.0" />
	<cfset APPLICATION.SETTING.mashtype = "All Grain" />
	<cfset APPLICATION.SETTING.maltcap = "0.40" />
	<cfset APPLICATION.SETTING.munits = "Lbs" />
	<cfset APPLICATION.SETTING.primer = "Corn" />
	<cfset APPLICATION.SETTING.ratio = "0.40" />
	<cfset APPLICATION.SETTING.tunits = "F" />
	<cfset APPLICATION.SETTING.viunits = "Quarts" />
	<cfset APPLICATION.SETTING.volume = "5.00" />
	<cfset APPLICATION.SETTING.vunits = "Gallons" />
	<cfset APPLICATION.SETTING.privacy = 0 />
	<cfset APPLICATION.SETTING.GoogleShortenerAPIKey = "AIzaSyCAaSZdL3PUNwj_zhbCW8qFkiMyHwbIOxg" />
	<cfset APPLICATION.SETTING.blog = "BeerInHand" />

	<cfset APPLICATION.EMAIL.support = "support@beerinhand.com" />
	<cfset APPLICATION.EMAIL.failto = "donotrespond@beerinhand.com" />
	<cfset APPLICATION.EMAIL.admin = "rust1d@usa.net" />
	<cfset APPLICATION.EMAIL.user = "beer@beerinhand.com" />
	<cfset APPLICATION.EMAIL.pwd = "H0m3br3w" />

	<cfset APPLICATION.sessions = 0 />
	<cfset APPLICATION.errors = 0 />

	<cfset APPLICATION.CFC = StructNew() />
	<cfset APPLICATION.CFC.Factory = CreateObject("component","#APPLICATION.MAP.CFC#.objectfactory").init() />
	<!--- DATA DRIVEN CFCS --->
	<cfset APPLICATION.CFC.Users = APPLICATION.CFC.Factory.Get("Users") />
	<cfset APPLICATION.CFC.Recipe = APPLICATION.CFC.Factory.Get("Recipe") />
	<cfset APPLICATION.CFC.RecipeGrains = APPLICATION.CFC.Factory.Get("RecipeGrains") />
	<cfset APPLICATION.CFC.RecipeHops = APPLICATION.CFC.Factory.Get("RecipeHops") />
	<cfset APPLICATION.CFC.RecipeYeast = APPLICATION.CFC.Factory.Get("RecipeYeast") />
	<cfset APPLICATION.CFC.RecipeMisc = APPLICATION.CFC.Factory.Get("RecipeMisc") />
	<cfset APPLICATION.CFC.RecipeDates = APPLICATION.CFC.Factory.Get("RecipeDates") />
	<!--- UTILITY PROVIDING CFCS --->
	<cfset APPLICATION.CFC.DataFiles = APPLICATION.CFC.Factory.Get("DataFiles") />
	<cfset APPLICATION.CFC.GlobalUDF = APPLICATION.CFC.Factory.Get("GlobalUDF") />
	<cfset APPLICATION.CFC.Controls = APPLICATION.CFC.Factory.Get("Controls") />
	<cfset APPLICATION.CFC.Javascript = APPLICATION.CFC.Factory.Get("Javascript") />

	<cfinclude template="forum/OnApplicationStart.cfm" />
	<cfinclude template="blog/OnApplicationStart.cfm" />

</cffunction>

<cffunction name="OnApplicationEnd" returnType="void" output="false">
	<cfargument name="applicationScope" required="true" />
</cffunction>

<cffunction name="OnSessionStart" output="No" returntype="void">
	<cflock scope="SESSION" timeout="10" type="exclusive">
		<cfset SESSION.Started = NOW() />
		<cfset SESSION.LoggedIn = false />
		<cfset SESSION.SETTING = Duplicate(APPLICATION.SETTING) />
		<cfset SESSION.BROG = Duplicate(APPLICATION.CFC.BLOG) />
	</cflock>
	<cflock scope="APPLICATION" timeout="5" type="Exclusive">
		<cfset APPLICATION.sessions = APPLICATION.sessions + 1 />
	</cflock>
</cffunction>

<cffunction name="OnSessionEnd">
	<cfargument name="sessionScope" required="true" />
	<cfargument name="applicationScope" required="true" />
	<cflock name="AppLock" timeout="5" type="Exclusive">
		<cfset ARGUMENTS.applicationScope.sessions = ARGUMENTS.applicationScope.sessions - 1 />
	</cflock>
</cffunction>

<cffunction name="OnRequestStart" output="true" returntype="void">
	<cfargument name="template" required="true" />
	<cfset var LOCAL = StructNew() />
	<cfif IsDefined("URL.reinit")><cfset OnApplicationStart() /><cfset OnSessionStart() /></cfif>
	<cfset SetEncoding("form","utf-8")>
	<cfset SetEncoding("url","utf-8")>
	<cfset StructAppend(URL, APPLICATION.CFC.GlobalUDF, "no") />
	<cfif StructKeyExists(REQUEST, "URL")><cfset StructAppend(URL, REQUEST.URL, "no") /></cfif>
	<cfif SESSION.LoggedIn>
		<cfif FindNoCase("p.logout.cfm", SCRIPT_NAME)>
			<cfset APPLICATION.CFC.Users.Logout() />
		</cfif>
	<cfelse>
		<cfset APPLICATION.CFC.Users.LoginHashword() />
	</cfif>
	<cfset LOCAL.reqData = getHTTPRequestData()> <!--- EXPLICITLY TURN OFF DEBUGGING FOR ANY AJAX REQUESTS --->
	<cfset REQUEST.ajax = StructKeyExists(LOCAL.reqData.headers,"X-Requested-With") and LOCAL.reqData.headers["X-Requested-With"] eq "XMLHttpRequest" />
	<cfif ListLast(ARGUMENTS.template,"/") EQ "showCaptcha.cfm"> <!--- CRUEL, NASTY HACK FOR CAPTCHA --->
		<cfset REQUEST.ajax = true/>
		<cfset ARGUMENTS.template = "showCaptcha.cfc" />
	</cfif>
	<cfif REQUEST.ajax>
		<cfsetting showdebugoutput="false">
		<cfif ListLast(ARGUMENTS.template,".") EQ "cfc">
			<cfset StructDelete(THIS, "onRequest") />
			<cfset StructDelete(VARIABLES,"onRequest")/>
		</cfif>
	</cfif>
<!--- 	<cfinclude template="admin\reinit.cfm" /> --->
</cffunction>

<cffunction name="onRequest" access="public" returntype="void" output="true">
	<cfargument name="template" type="string" required="true" />
	<cfparam name="REQUEST.LoadPage" default="pages\home.cfm" />
	<cfset LOCAL.URLPage = ListLast(ARGUMENTS.template,"/") />
	<cfif LOCAL.URLPage EQ "index.cfm"><!--- NEED TO REMAP INDEX.CFM OR OUR OBFUSTICATION SCHEME CRASHES --->
		<cfif SESSION.LoggedIn><cfset LOCAL.URLPage = "p.brewer.cfm" /> <cfelse><cfset LOCAL.URLPage = "p.home.cfm" /> </cfif>
	</cfif>
	<cfset REQUEST.arrURL = ListToArray(LOCAL.URLPage,".") />
	<cfset REQUEST.ERR.CODE = 404 />
	<cfset REQUEST.LoadPage = "error\error.cfm" />
	<cfif ArrayLen(REQUEST.arrURL) gt 2>
		<cfset LOCAL.LoadPage = "pages\home.cfm" />
		<cfset LOCAL.lstA = "b,c,e,f,p,t" />
		<cfset LOCAL.lstF = "blog,calc,explorer,forum,pages,test" />
		<cfset LOCAL.posA = ListFind(LOCAL.lstA, REQUEST.arrURL[1]) />
		<cfif LOCAL.posA>
			<cfset LOCAL.LoadPage = ListGetAt(LOCAL.lstF, LOCAL.posA) />
			<cfset LOCAL.LoadPage = "#LOCAL.LoadPage#\#REQUEST.arrURL[2]#.cfm" />
			<cfif REQUEST.arrURL[1] EQ "b">
				<cfinclude template="blog/OnRequest.cfm">
			<cfelseif REQUEST.arrURL[1] EQ "f">
				<cfinclude template="forum/OnRequest.cfm">
			</cfif>
		<cfelseif NOT SESSION.LoggedIn>
			<cfset LOCAL.LoadPage = "pages/logout.cfm" />
		<cfelse>
			<cfset LOCAL.lstA = "a,u,x,z" />
			<cfset LOCAL.lstF = "admin,user,blog\admin,forum\admin" />
			<cfset LOCAL.posA = ListFind(LOCAL.lstA, REQUEST.arrURL[1]) />
			<cfif LOCAL.posA>
				<cfset LOCAL.LoadDir = ListGetAt(LOCAL.lstF, LOCAL.posA) />
				<cfset LOCAL.LoadPage = "#LOCAL.LoadDir#\#REQUEST.arrURL[2]#.cfm" />
			</cfif>
			<cfset LOCAL.lstA = "x,z" />
			<cfset LOCAL.lstF = "siteadmin,forumsadmin" />
			<cfset LOCAL.posA = ListFind(LOCAL.lstA, REQUEST.arrURL[1]) />
			<cfif LOCAL.posA>
				<cfset LOCAL.ReqRole = ListGetAt(LOCAL.lstF, LOCAL.posA) />
				<cfif NOT isUserInRole(LOCAL.ReqRole)>
					<cfset LOCAL.LoadPage = "pages/logout.cfm" />
				<cfelse>
					<cfinclude template="#LOCAL.LoadDir#\OnRequest.cfm" />
				</cfif>
			</cfif>
		</cfif>
		<cfif FileExists("#APPLICATION.DISK.ROOT#\#LOCAL.LoadPage#")>
			<cfset REQUEST.LoadPage = LOCAL.LoadPage />
			<cfset REQUEST.URLTokens = ListToArray(LCase(Replace(ExpandPath("."), "#APPLICATION.DISK.ROOT#", "")),"\") />
		</cfif>
	</cfif>
	<cfif REQUEST.ajax>
		<cfparam name="REQUEST.LoadPage" default="pages\empty.cfm" />
		<cfinclude template="#APPLICATION.PATH.ROOT#/#REQUEST.LoadPage#" />
	<cfelse>
		<cfinclude template="#APPLICATION.PATH.ROOT#/index.cfm" />
	</cfif>
</cffunction>

<cffunction name="onRequestEnd" returnType="void" output="false">
	<cfargument name="template" type="string" required="true" />
</cffunction>

<cffunction name="onError" returnType="void" output="true">
	<cfargument name="exception" required="true" />
	<cfargument name="eventname" type="string" required="true" />
	<cfif APPLICATION.IsLocal>
		<cfdump var="#ARGUMENTS.exception#">
	<cfelse>
		<cfset udfSaveError(ARGUMENTS.exception) />
	</cfif>
</cffunction>

<cffunction name="onMissingTemplate" returnType="boolean" output="true">
	<cfargument name="template" type="string" required="true" />
	<cfset THIS.onRequestStart(ARGUMENTS.template) />
	<cfset THIS.onRequest(ARGUMENTS.template) />
	<cfreturn true />
</cffunction>

</cfcomponent>
