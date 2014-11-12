<cfsetting enablecfoutputonly = true />
<!---
	Name				 : udf.cfm
	Author			 : Raymond Camden
	Created			: June 01, 2004
	Last Updated : October 12, 2007
	History			: Reset for V2
	Purpose		 :
--->

<cfscript>

function getGroups() {
	if (SESSION.LoggedIn) return SESSION.USER.FORUM.groupids;
	return "";
}
REQUEST.udf.getGroups = getGroups;

function isEmail(str) {
	return (REFindNoCase("^['_a-z0-9-\+]+(\.['_a-z0-9-\+]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|asia|biz|cat|coop|info|museum|name|jobs|post|pro|tel|travel|mobi))$", ARGUMENTS.str) AND len(listGetAt(ARGUMENTS.str, 1, "@")) LTE 64 AND len(listGetAt(ARGUMENTS.str, 2, "@")) LTE 255) IS 1;
}
REQUEST.udf.isEmail = isEmail;

function isValidUsername(str) {
	if (reFindNoCase("[^a-z0-9]",str)) return false;
	return true;
}
REQUEST.udf.isValidUsername = isValidUsername;

function XHTMLParagraphFormat(string) {
	var attributeString = '';
	var returnValue = '';
	//added by me to support different line breaks
	string = replace(string, chr(10) & chr(10), chr(13) & chr(10), "all");
	if (ArrayLen(arguments) GTE 2) attributeString = ' ' & arguments[2];
	if (Len(Trim(string))) returnValue = '<p' & attributeString & '>' & Replace(string, Chr(13) & Chr(10), '</p>' & Chr(13) & Chr(10) & '<p' & attributeString & '>', 'ALL') & '</p>';
	return returnValue;
}

REQUEST.udf.XHTMLParagraphFormat = XHTMLParagraphFormat;


/*
 This function returns asc or desc, depending on if the current dir matches col
*/
function dir(col) {
	if (isDefined("URL.sort") and URL.sort is col and isDefined("URL.sortdir") and URL.sortdir is "asc") return "desc";
	return "asc";
}
REQUEST.udf.dir = dir;

function headerLink(col) {
	var str = "";
	var colname = ARGUMENTS.col;
	var qs = CGI.query_string;

	if (arrayLen(arguments) gte 2) colname = arguments[2];

	// can't be too safe
	if (not isDefined("URL.sort")) URL.sort = "";
	if (not isDefined("URL.sortdir")) URL.sortdir = "";

	//clean qs
	qs = reReplaceNoCase(qs, "&*sort=[^&]*","");
	qs = reReplaceNoCase(qs, "&*sortdir=[^&]*","");
	qs = reReplaceNoCase(qs, "&*page=[^&]*","");
	qs = reReplaceNoCase(qs, "&*logout=[^&]*","");
	qs = reReplaceNoCase(qs, "&{2,}","");
	if (len(qs)) qs = qs & "&";

	if (URL.sort is colname) str = str & "[";
	str = str & "<a rel=""nofollow"" href=""#CGI.script_name#?#qs#sort=#urlEncodedFormat(colname)#&sortdir=" & dir(colname) & """>#col#</a>";
	if (URL.sort is colname) str = str & "]";
	return str;
}
REQUEST.udf.headerLink = headerLink;

/*
*/

function MakePassword() {
	var valid_password = 0;
	var loopindex = 0;
	var this_char = "";
	var seed = "";
	var new_password = "";
	var new_password_seed = "";
	while (valid_password eq 0){
		new_password = "";
		new_password_seed = CreateUUID();
		for(loopindex=20; loopindex LT 35; loopindex = loopindex + 2){
			this_char = inputbasen(mid(new_password_seed, loopindex,2),16);
			seed = int(inputbasen(mid(new_password_seed,loopindex/2-9,1),16) mod 3)+1;
			switch(seed){
				case "1": {
					new_password = new_password & chr(int((this_char mod 9) + 48));
					break;
				}
				case "2": {
					new_password = new_password & chr(int((this_char mod 26) + 65));
					break;
				}
				case "3": {
					new_password = new_password & chr(int((this_char mod 26) + 97));
					break;
				}
			} //end switch
		}
		valid_password = iif(refind("(O|o|0|i|l|1|I|5|S)",new_password) gt 0,0,1);
	}
	return new_password;
}
REQUEST.udf.makePassword = makePassword;
</cfscript>

<!--- provides a cached way to get user info --->
<cffunction name="cachedUserInfo" returnType="struct" output="false">
	<cfargument name="username" type="string" required="true">
	<cfargument name="usecache" type="boolean" required="false" default="true">
	<cfargument name="userid" type="boolean" required="false" default="false">
	<cfset var userInfo = "">

	<cfif not isDefined("APPLICATION.FORUM.UserCache")>
		<cfset APPLICATION.FORUM.UserCache = structNew()>
		<cfset APPLICATION.FORUM.UserCache_created = now()>
	</cfif>

	<cfif dateDiff("h",APPLICATION.FORUM.UserCache_created,now()) gte 2>
		<cfset structClear(APPLICATION.FORUM.UserCache)>
		<cfset APPLICATION.FORUM.UserCache_created = now()>
	</cfif>

	<!--- New argument, userid, if true, we first convert from ID to username --->
	<cfif ARGUMENTS.userid>
		<cfset ARGUMENTS.username = APPLICATION.FORUM.User.getUsernameFromID(ARGUMENTS.username)>
	</cfif>

	<cfif structKeyExists(APPLICATION.FORUM.UserCache, ARGUMENTS.username) and ARGUMENTS.usecache>
		<cfreturn duplicate(APPLICATION.FORUM.UserCache[ARGUMENTS.username])>
	</cfif>

	<cfset userInfo = APPLICATION.FORUM.User.getUser(ARGUMENTS.username)>
	<!--- Get a rank for their posts --->
	<cfset userInfo.rank = APPLICATION.FORUM.Rank.getHighestRank(userInfo.postCount)>

	<cfset APPLICATION.FORUM.UserCache[ARGUMENTS.username] = userInfo>
	<cfreturn userInfo>

</cffunction>
<cfset REQUEST.udf.cachedUserInfo = cachedUserInfo>

<cffunction name="querySortManual" returnType="query" output="false">
	<cfargument name="query" type="query" required="true">
	<cfargument name="column" type="string" required="true">
	<cfargument name="direction" type="string" required="true">
	<cfset var result = "">
	<cfset var stickyStr = "sticky ">

	<cfif findNoCase("sticky", query.columnlist)>
		<cfset stickyStr = stickyStr & "desc,">
	<cfelse>
		<cfset stickyStr = "">
	</cfif>

	<cfif not listFindNoCase(query.columnList, column)>
		<cfreturn query>
	</cfif>

	<cfif not listFindNoCase("asc,desc", ARGUMENTS.direction)>
		<cfset ARGUMENTS.direction = "asc">
	</cfif>

	<cfquery name="result" dbtype="query">
	select		*
	from		ARGUMENTS.query
	order by 	#stickyStr# #ARGUMENTS.column# #ARGUMENTS.direction#
	</cfquery>

	<cfreturn result>
</cffunction>
<cfset REQUEST.udf.querySort = querySortManual>

<cfsetting enablecfoutputonly = false />