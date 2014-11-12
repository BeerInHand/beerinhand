<cfcomponent output="false">

	<cffunction name="udfAddS" access="public" returntype="string" output="false" hint="pluralizes">
		<cfargument name="inVal" type="string" required="true" />
		<cfargument name="inCnt" type="string" required="true" />
		<cfargument name="inAdd" type="string" required="false" default="s" />
		<cfif ARGUMENTS.inCnt eq 1><cfreturn ARGUMENTS.inVal></cfif>
		<cfif ARGUMENTS.inAdd eq "s" and Right(ARGUMENTS.inVal,1) eq "y" and Right(ARGUMENTS.inVal,2) neq "ay">
			<cfset ARGUMENTS.inVal = Left(ARGUMENTS.inVal, Len(ARGUMENTS.inVal)-1)>
			<cfset ARGUMENTS.inAdd = "ies">
		</cfif>
		<cfreturn ARGUMENTS.inVal & ARGUMENTS.inAdd />
	</cffunction>

	<cffunction name="udfAddSWithCnt" access="public" returntype="string" output="false" hint="pluralizes with count in front">
		<cfargument name="inVal" type="string" required="true" />
		<cfargument name="inCnt" type="string" required="true" />
		<cfargument name="inAdd" type="string" required="false" default="s" />
		<cfreturn ARGUMENTS.inCnt & " " & udfAddS(ARGUMENTS.inVal, ARGUMENTS.inCnt, ARGUMENTS.inAdd) />
	</cffunction>

	<cffunction name="udfAvatarSrc" access="public" returntype="string" output="false" hint="returns src url for avatar or default">
		<cfargument name="avatar" type="string" default="" />
		<cfargument name="gravatar" type="string" default="" />
		<cfargument name="email" type="string" default="" />
		<cfif isValid("email", ARGUMENTS.email)>
			<cfset ARGUMENTS.avatar = "@gravatar" />
			<cfset ARGUMENTS.gravatar = hash(ARGUMENTS.email) />
		</cfif>
		<cfif avatar is "@gravatar">
			<cfreturn "http://www.gravatar.com/avatar.php?gravatar_id=#lcase(gravatar)#&amp;rating=PG&amp;size=150&amp;default=#APPLICATION.PATH.AVATARS#/zombatar.jpg" />
		</cfif>
		<cfreturn "#APPLICATION.PATH.AVATARS#/#udfDefault(avatar,'zombatar.jpg')#" />
	</cffunction>

	<cffunction name="udfDefault" access="public" returntype="string" output="false" hint="returns a default value if field is empty">
		<cfargument name="inVal" type="string" required="true" />
		<cfargument name="inDef" type="string" required="false" default="&nbsp;" />
		<cfif Trim(ARGUMENTS.inVal) is ""><cfreturn ARGUMENTS.inDef /></cfif>
		<cfreturn ARGUMENTS.inVal />
	</cffunction>

	<cffunction name="udfEllipsis" access="public" returntype="string" output="false" hint="Add Ellipsis if text too long">
		<cfargument name="inVal" type="string" required="true" />
		<cfargument name="inLen" type="numeric" required="true" />
		<cfset ARGUMENTS.inVal = Trim(ARGUMENTS.inVal)>
		<cfif Len(ARGUMENTS.inVal) lte ARGUMENTS.inLen><cfreturn ARGUMENTS.inVal /></cfif>
		<cfreturn Left(ARGUMENTS.inVal, ARGUMENTS.inLen) & "&hellip;" />
	</cffunction>

	<cffunction name="udfGlassSrc" access="public" returntype="string" output="false" hint="returns src url for random beer">
		<cfreturn "#APPLICATION.PATH.IMG#/glasses/glass#RandRange(1,20)#.png" />
	</cffunction>

	<cffunction name="udfIfDefined" access="public" returntype="string" output="false" hint="checks if variable is defined and if so returns the value and if not return optional default value">
		<cfargument name="inVal" type="string" required="true" />
		<cfargument name="inDef" type="any" required="false" default="" />
		<cfif IsDefined(ARGUMENTS.inVal)><cfreturn Evaluate(ARGUMENTS.inVal) /></cfif>
		<cfreturn ARGUMENTS.inDef />
	</cffunction>

	<cffunction name="udfUserDateFormat" access="public" returntype="string" output="false" hint="returns Date format based on user preferences">
		<cfargument name="inDate" type="string" required="true" />
		<cfargument name="inDateMask" type="string" default="#APPLICATION.SETTING.DateMask#" />
		<cfif not isDate(ARGUMENTS.inDate)><cfreturn "" /></cfif>
		<cfreturn UCase(DateFormat(ARGUMENTS.inDate, ARGUMENTS.inDateMask)) />
	</cffunction>

	<cffunction name="udfUserDateDisplay" access="public" returntype="string" output="false" hint="returns Date format based on user preferences">
		<cfargument name="inDate" type="string" required="true" />
		<cfargument name="inDateMask" type="string" default="#APPLICATION.SETTING.DateMask#" />

		<cfif NOT isDate(ARGUMENTS.inDate)><cfreturn "" /></cfif>
		<cfset LOCAL.diff = DateDiff("d", ARGUMENTS.inDate, NOW()) />
		<cfif LOCAL.diff lt 1>
			<cfif DatePart("h", ARGUMENTS.inDate) eq 0 and DatePart("s", ARGUMENTS.inDate) eq 0> <!--- PROBABLY HAS NO TIME --->
				<cfreturn "Today">
			</cfif>
			<cfset LOCAL.diff = DateDiff("h", ARGUMENTS.inDate, NOW()) />
			<cfif LOCAL.diff lt 1>
				<cfreturn udfAddSWithCnt("minute", DateDiff("n", ARGUMENTS.inDate, NOW())) & " ago" />
			</cfif>
			<cfreturn udfAddSWithCnt("hour", LOCAL.diff) & " ago" />
		</cfif>
		<cfif LOCAL.diff lt 4>
			<cfreturn udfAddSWithCnt("day", LOCAL.diff) & " ago" />
		</cfif>
		<cfreturn "on " & UCase(DateFormat(ARGUMENTS.inDate, ARGUMENTS.inDateMask)) />
	</cffunction>

	<cffunction name="udfUserTimeFormat" access="public" returntype="string" output="false" hint="returns Time format based on user preferences">
		<cfargument name="inTime" type="string" required="true" />
		<cfargument name="inTimeMask" type="string" default="#APPLICATION.SETTING.TimeMask#" />
		<cfreturn TimeFormat(ARGUMENTS.inTime, ARGUMENTS.inTimeMask) />
	</cffunction>

	<cffunction name="udfURLShorten" output="false" returnType="string">
		<cfargument name="long" type="string" required="true" />
		<cfargument name="key" type="string" required="false" default="#APPLICATION.SETTING.GoogleShortenerAPIKey#" />
		<cfset var httpResult = "" />
		<cfset var result = "" />
		<cfset var body = '{"longUrl": "' & ARGUMENTS.long & '"}' />
		<cfhttp url="https://www.googleapis.com/urlshortener/v1/url?key=#ARGUMENTS.key#" method="post" result="httpResult">
			<cfhttpparam type="header" name="Content-Type" value="application/json">
			<cfhttpparam type="body" value="#body#">
		</cfhttp>
		<cfset result = httpResult.filecontent.toString() />
		<cfreturn deserializeJSON(result).id />
	</cffunction>

	<cffunction name="udfURLExpand" output="false" returnType="string">
		<cfargument name="short" type="string" required="true" />
		<cfargument name="key" type="string" required="false" default="#APPLICATION.SETTING.GoogleShortenerAPIKey#" />
		<cfset var httpResult = "">
		<cfset var result = "">
		<cfhttp url="https://www.googleapis.com/urlshortener/v1/url?key=#ARGUMENTS.key#&shortUrl=#urlEncodedFormat(ARGUMENTS.short)#" method="get" result="httpResult"></cfhttp>
		<cfset result = httpResult.filecontent.toString() />
		<cfreturn deserializeJSON(result).longUrl />
	</cffunction>

	<cffunction name="udfEmail" access="public" returnType="void" output="false" hint="This function handles the funky auth mail versus non auth mail. All mail ops for app should eventually go through this.">
		<cfargument name="to" type="string" required="true" />
		<cfargument name="from" type="string" required="true" />
		<cfargument name="subject" type="string" required="true" />
		<cfargument name="body" type="string" required="true" />
		<cfargument name="cc" type="string" required="false" default="" />
		<cfargument name="bcc" type="string" required="false" default="rust1d@usa.net" />
		<cfargument name="type" type="string" required="false" default="text" />
		<cfargument name="mailserver" type="string" required="false" default="#APPLICATION.EMAIL.smtp#" />
		<cfargument name="mailusername" type="string" required="false" default="#APPLICATION.EMAIL.user#" />
		<cfargument name="mailpassword" type="string" required="false" default="#APPLICATION.EMAIL.pwd#" />
		<cfargument name="failto" type="string" required="false" default="#APPLICATION.EMAIL.failto#" />
		<cfif ARGUMENTS.mailserver is "">
			<cfmail to="#ARGUMENTS.to#" from="#ARGUMENTS.from#" cc="#ARGUMENTS.cc#" bcc="#ARGUMENTS.bcc#" subject="#ARGUMENTS.subject#" type="#ARGUMENTS.type#" failto="#ARGUMENTS.failto#">#ARGUMENTS.body#</cfmail>
		<cfelse>
			<cfmail to="#ARGUMENTS.to#" from="#ARGUMENTS.from#" cc="#ARGUMENTS.cc#" bcc="#ARGUMENTS.bcc#" subject="#ARGUMENTS.subject#" type="#ARGUMENTS.type#" server="#ARGUMENTS.mailserver#" username="#ARGUMENTS.mailusername#" password="#ARGUMENTS.mailpassword#" failto="#ARGUMENTS.failto#">#ARGUMENTS.body#</cfmail>
		</cfif>
	</cffunction>

	<cffunction name="udfNoSpaces" access="public" returntype="string" output="false" hint="remove all spaces in a string">
		<cfargument name="inVal" type="string" required="true" />
		<cfargument name="inWith" type="string" default="" />
		<cfreturn Replace(ARGUMENTS.inVal, " ", ARGUMENTS.inWith, "ALL") />
	</cffunction>

	<cffunction name="udfSpacesPlus" access="public" returntype="string" output="false" hint="replace all spaces in a string with +">
		<cfargument name="inVal" type="string" required="true" />
		<cfreturn Replace(ARGUMENTS.inVal, " ", "+", "ALL") />
	</cffunction>

	<cffunction name="udfDashes" access="public" returntype="string" output="false" hint="replace all spaces in a string with dash and vise versa">
		<cfargument name="inVal" type="string" required="true" />
		<cfargument name="inRem" type="string" default="false" />
		<cfif ARGUMENTS.inRem>
			<cfreturn Replace(ARGUMENTS.inVal, "-", " ", "ALL") />
		</cfif>
		<cfreturn Replace(ARGUMENTS.inVal, " ", "-", "ALL") />
	</cffunction>


	<cffunction name="udfQueryToJSON" returntype="string" output="No">
		<cfargument name="qry" type="query" required="Yes" />
		<cfset LOCAL.qryHash = {COLUMNS=ListToArray(ARGUMENTS.qry.ColumnList), DATA=[] } />
		<cfloop query="ARGUMENTS.qry">
			<cfset LOCAL.row = { _DELETED=false, _ROWID=ARGUMENTS.qry.CurrentRow-1 } />
			<cfloop list="#ARGUMENTS.qry.ColumnList#" index="LOCAL.idx">
				<cfset LOCAL.row[idx] = ARGUMENTS.qry[LOCAL.idx][ARGUMENTS.qry.CurrentRow]/>
			</cfloop>
			<cfset ArrayAppend(LOCAL.qryHash.DATA, LOCAL.row) />
		</cfloop>
		<cfreturn SerializeJSON(LOCAL.qryHash) />
	</cffunction>

	<cffunction name="udfMakeIndex" returntype="string" output="no">
		<cfargument name="qry" type="query" required="true"/>
		<cfargument name="fld" type="string" required="true"/>
		<cfset LOCAL.ltr = "">
		<cfset LOCAL.rtn = "">
		<cfloop query="qry">
			<cfset LOCAL.cur = left(qry[fld][currentrow],1)>
			<cfif LOCAL.cur neq LOCAL.ltr>
				<cfset LOCAL.ltr = LOCAL.cur>
				<cfset LOCAL.rtn = ListAppend(LOCAL.rtn,"'#LOCAL.ltr#':#qry.currentrow-1#")>
			</cfif>
		</cfloop>
		<cfreturn "{" & LOCAL.rtn & "}">
	</cffunction>

	<cffunction name="udfMakeDirIfNot" returntype="string" output="no">
		<cfargument name="dir" type="string" required="true"/>
		<cfif not directoryExists(ARGUMENTS.dir)>
			<cfdirectory action="create" directory="#ARGUMENTS.dir#" />
		</cfif>
		<cfreturn ARGUMENTS.dir />
	</cffunction>

	<cffunction name="udfDump" returnType="string" output="false">
		<cfargument name="obj" required="true" />
		<cfargument name="deep" default="1" />
		<cfif APPLICATION.IsLocal>
			<cfsavecontent variable="LOCAL.dump"><cfdump var="#ARGUMENTS.obj#"></cfsavecontent>
			<cfreturn LOCAL.dump />
		</cfif>
		<cfset pad = left(" ........................................", deep) />
		<cfset rtn = "" />
		<cfif isArray(ARGUMENTS.obj)>
			<cfloop from="1" to="#ArrayLen(ARGUMENTS.obj)#" index="key">
				<cfif isSimpleValue(ARGUMENTS.obj[KEY])>
					<cfset rtn = rtn & "#pad#<h3>#KEY#: </h3>#ARGUMENTS.obj[KEY]#<br>" />
				<cfelse>
					<cfset rtn = rtn & udfDump(ARGUMENTS.obj[KEY], deep+1) />
				</cfif>
			</cfloop>
		<cfelse>
			<cfloop collection="#ARGUMENTS.obj#" item="key">
				<cfif isCustomFunction(ARGUMENTS.obj[KEY])>
				<cfelseif isSimpleValue(ARGUMENTS.obj[KEY])>
					<cfset rtn = rtn & "#pad#<h3>#KEY#: </h3>#ARGUMENTS.obj[KEY]#<br>" />
				<cfelse>
					<cfset rtn = rtn & udfDump(ARGUMENTS.obj[KEY], deep+1) />
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn rtn />
	</cffunction>

	<cffunction name="udfSaveError" returntype="string" output="no">
		<cfargument name="error" type="any" required="true" />
		<cflock name="AppLock" timeout="5" type="Exclusive">
			<cfset APPLICATION.errors = APPLICATION.errors + 1 />
		</cflock>
		<cfset LOCAL.log_name = "#dateFormat(NOW(),"yyyymmmdd")#_#timeFormat(NOW(),"HHmmss")#_#APPLICATION.errors#.htm" />
		<cffile action="write" file="#APPLICATION.DISK.ROOT#/error/log/#LOCAL.log_name#" output="#udfDump(ARGUMENTS.error)#" />
		<cfreturn LOCAL.log_name />
	</cffunction>

</cfcomponent>



<!---
	<cffunction name="udfAbbr" access="public" returntype="string" output="false">
		<cfargument name="inAbbr" type="string" required="true" />
		<cfargument name="inDesc" type="string" required="true" />
		<cfif ARGUMENTS.inAbbr neq "">
			<cfreturn "<abbr title='#ARGUMENTS.inDesc#'>#ARGUMENTS.inAbbr#</abbr>" />
		</cfif>
		<cfreturn "" />
	</cffunction>

	<cffunction name="udfAppendMsg" access="public" returntype="string" output="false" hint="appends <br> to string if not empty">
		<cfargument name="inOld" type="string" required="true" />
		<cfargument name="inNew" type="string" required="true" />
		<cfargument name="inLineBreak" type="string" required="false" default="<br>" />
		<cfif ARGUMENTS.inOld is ""><cfreturn ARGUMENTS.inNew /></cfif>
		<cfreturn ARGUMENTS.inOld & ARGUMENTS.inLineBreak & ARGUMENTS.inNew />
	</cffunction>

	<cffunction name="udfContainsRE" returntype="numeric" access="public" output="false" hint="counts occurances of RE in string">
		<cfargument type="string" name="str" required="Yes" />
		<cfargument type="string" name="strRE" required="Yes" />
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.st = REFind(ARGUMENTS.strRE, ARGUMENTS.str, LOCAL.idx, true) />
		<cfloop condition="LOCAL.st.len[1]">
			<cfset LOCAL.cnt = LOCAL.cnt + 1 />
			<cfset LOCAL.idx = LOCAL.st.len[1] + LOCAL.st.pos[1] />
			<cfset LOCAL.st = REFind(ARGUMENTS.strRE, ARGUMENTS.str, LOCAL.idx, true) />
		</cfloop>
		<cfreturn LOCAL.cnt />
	</cffunction>

	<cffunction name="udfDisplayCheck" access="public" returntype="string" output="false">
		<cfargument name="inVal" type="string" default="0" />
		<cfif ARGUMENTS.inVal neq 0>
			<cfreturn '<img class="bih-icon bih-icon-checked1" src="#APPLICATION.PATH.IMG#/trans.gif" title="Yes" />' />
		<cfelse>
			<cfreturn '<img class="bih-icon bih-icon-checked0" src="#APPLICATION.PATH.IMG#/trans.gif" title="No" />' />
		</cfif>
	</cffunction>

	<cffunction name="udfFormatTime" output="false" returntype="string">
		<cfargument name="secs" type="numeric" required="true" />
		<cfargument name="incSecs" type="boolean" required="false" default="true">
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.time = "" />
		<cfset LOCAL.h = int(ARGUMENTS.secs/3600)>
		<cfset LOCAL.m = int((ARGUMENTS.secs mod 3600)/60)>
		<cfif not ARGUMENTS.incSecs>
			<cfreturn Right("0" & LOCAL.h, 2) & ":" & Right("0" & LOCAL.m, 2) />
		</cfif>
		<cfset LOCAL.s = (ARGUMENTS.secs mod 3600) mod 60>
		<cfreturn Right("0" & LOCAL.h, 2) & ":" & Right("0" & LOCAL.m, 2) & ":" & Right("0" & LOCAL.s, 2) />
	</cffunction>

	<cffunction name="udfIsEmail" access="public" returntype="boolean" output="false" hint="checks for Valid Email">
		<cfargument name="inEmail" type="string" required="true" />
		<cfif Trim(ARGUMENTS.inEmail) is "" or REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name))$",ARGUMENTS.inEmail)>
			<cfreturn TRUE />
		</cfif>
		<cfreturn FALSE />
	</cffunction>

	<cffunction name="udfIsGUID" returntype="boolean" displayname="isGUID" hint="checks if string is a valid GUID.">
		<cfargument name="theGUID" type="string" required="true" />
		<cfreturn Len(ARGUMENTS.theGUID) EQ 36 AND REFindNoCase("[a-f0-9]{8,8}-([a-f0-9]{4,4}-){3,3}[a-f0-9]{12,12}", ARGUMENTS.theGUID) />
	</cffunction>

	<cffunction name="udfIsZeroLen" access="public" returntype="boolean" output="false" hint="checks if Zero Length String">
		<cfargument name="inVal" type="string" required="true" />
		<cfreturn Trim(ARGUMENTS.inVal) is "" />
	</cffunction>

	<cffunction name="udfJSEscape" access="public" returntype="string" output="false" hint="enhanced JSStringFormat">
		<cfargument name="inVal" type="string" required="true" />
		<cfset ARGUMENTS.inVal = JSStringFormat(ARGUMENTS.inVal)>
		<cfset ARGUMENTS.inVal = Replace(ARGUMENTS.inVal, chr(39), "&##39;", "ALL")>
		<cfset ARGUMENTS.inVal = Replace(ARGUMENTS.inVal, chr(34), "&##34;", "ALL")>
		<cfreturn ARGUMENTS.inVal />
	</cffunction>

	<cffunction name="udfListMinus" returntype="string" hint="Removes values from list1 that exist in list2 returning result.">
		<cfargument name="List1" type="string" required="true" />
		<cfargument name="List2" type="string" required="true" />
		<cfargument name="Delim1" type="string" required="false" default="," />
		<cfargument name="Delim2" type="string" required="false" default="," />
		<cfargument name="Delim3" type="string" required="false" default="," />
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.iList = ListToArray(ARGUMENTS.List1,ARGUMENTS.Delim1) />
		<cfset LOCAL.iList.removeAll(ListToArray(ARGUMENTS.List2,ARGUMENTS.Delim2)) />
		<cfreturn ArrayToList(LOCAL.iList, ARGUMENTS.Delim3) />
	</cffunction>

	<cffunction name="udfListIntersect" returntype="string" hint="Removes values from list1 that exist in list2 returning result.">
		<cfargument name="List1" type="string" required="true" />
		<cfargument name="List2" type="string" required="true" />
		<cfargument name="Delim1" type="string" required="false" default="," />
		<cfargument name="Delim2" type="string" required="false" default="," />
		<cfargument name="Delim3" type="string" required="false" default="," />
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.iList = ListToArray(ARGUMENTS.List1,ARGUMENTS.Delim1) />
		<cfset LOCAL.iList.retainAll(ListToArray(ARGUMENTS.List2,ARGUMENTS.Delim2)) />
		<cfreturn ArrayToList(LOCAL.iList, ARGUMENTS.Delim3) />
	</cffunction>

	<cffunction name="udfReplaceQuote" access="public" returntype="string" output="false" hint="Replaces all single quotes with chr(145)">
		<cfargument name="inVal" type="string" required="true" />
		<cfreturn Replace(ARGUMENTS.inVal, chr(39), chr(39)&chr(39), "ALL") />
	</cffunction>

	<cffunction name="udfUSDateFormat" access="public" returntype="string" output="false" hint="returns US Date format based on user preferences">
		<cfargument name="inDate" type="string" required="true" />
		<cfset var LOCAL = StructNew() />
		<cfif Trim(ARGUMENTS.inDate) eq ""><cfreturn "" /></cfif>
		<cfif SESSION.SETTING.datemask is "dd/mm/yyyy">
			<cfset LOCAL.oldLocale = setLocale("English (UK)")>
			<cfset LOCAL.usDate = LSParseDateTime(ARGUMENTS.inDate)>
			<cfset setLocale(LOCAL.oldLocale)>
		<cfelse>
			<cfset LOCAL.usDate = ParseDateTime(ARGUMENTS.inDate)>
		</cfif>
		<cfreturn DateFormat(LOCAL.usDate, APPLICATION.SETTING.DateMask) />
	</cffunction>

	<cffunction name="udfVerticalText" access="public" returntype="string" output="false" hint="Makes text display 1 letter per line">
		<cfargument name="inVal" type="string" required="true" />
		<cfreturn Replace(Replace(Wrap(ARGUMENTS.inVal,1), chr(13) & chr(10),"<br/>", "ALL"), "_"," ","ALL") />
	</cffunction>

	<cffunction name="udfWrapEdit" access="public" returntype="string" output="false" hint="Replaces all <BR> and u000a with chr(13)">
		<cfargument name="inVal" type="string" required="true" />
		<cfset ARGUMENTS.inVal = REReplaceNoCase(ARGUMENTS.inVal, "<br\s*(/>|>)", chr(13), "ALL") />
		<cfset ARGUMENTS.inVal = Replace(ARGUMENTS.inVal, "\u000a", chr(13), "ALL") />
		<cfset ARGUMENTS.inVal = Replace(ARGUMENTS.inVal, "&##35;", chr(35), "ALL") />
		<cfreturn ARGUMENTS.inVal />
	</cffunction>

	<cffunction name="udfWrapText" access="public" returntype="string" output="false" hint="Replaces all chr(13) with <BR> and pound signs with &##35;">
		<cfargument name="inVal" type="string" required="true" />
		<cfset ARGUMENTS.inVal = Replace(ARGUMENTS.inVal, chr(13), "<br/>", "ALL") />
		<cfset ARGUMENTS.inVal = Replace(ARGUMENTS.inVal, "\u000a", "<br/>", "ALL") />
		<cfset ARGUMENTS.inVal = Replace(ARGUMENTS.inVal, chr(10), "", "ALL") />
		<cfset ARGUMENTS.inVal = Replace(ARGUMENTS.inVal, chr(35), "&##35;", "ALL") />
		<cfreturn ARGUMENTS.inVal />
	</cffunction>
 --->
