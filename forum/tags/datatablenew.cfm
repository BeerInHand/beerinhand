<cfsetting enablecfoutputonly = true />
<!---
	Name         : datatable.cfm
	Author       : Raymond Camden
	Created      : June 02, 2004
	Last Updated : February 26, 2007
	History      : JS fix (7/23/04)
				   Minor formatting updates (rkc 8/29/05)
				   finally add sorting (rkc 9/9/05)
				   mods for new stuff (rkc 11/3/06)
				   added linkappend (rkc 2/26/07)
	Purpose		 : A VERY app specific datable tag.
--->

<cfparam name="ATTRIBUTES.data" type="query">
<cfparam name="ATTRIBUTES.linkcol" default="#listFirst(ATTRIBUTES.data.columnList)#">
<cfparam name="ATTRIBUTES.linkval" default="id">
<cfparam name="ATTRIBUTES.list" default="#ATTRIBUTES.data.columnList#">
<cfparam name="ATTRIBUTES.classlist" default="">
<cfparam name="ATTRIBUTES.start" default="1">
<cfparam name="URL.sort" default="">
<cfparam name="URL.dir" default="asc">
<cfparam name="ATTRIBUTES.linkappend" default="">
<cfparam name="ATTRIBUTES.message" default="">
<cfparam name="ATTRIBUTES.total" default="#ATTRIBUTES.data.recordCount#">
<cfparam name="ATTRIBUTES.perpage" default="#APPLICATION.FORUM.SETTING.perpage#">
<cfparam name="ATTRIBUTES.nosort" default="">
<cfif URL.dir is not "asc" and URL.dir is not "desc">
	<cfset URL.dir = "asc">
</cfif>
<cfscript>
function displayHeader(col) {
	if(col is "readonly") return "Read Only";
	if(col is "datecreated") return "Date Created";
	if(col is "messagecount") return "Posts";
	if(col is "lastpost") return "Last Post";
	if(col is "postcount") return "Number of Posts";
	if(col is "emailaddress") return "Email Address";
	if(col is "threadname") return "Thread";
	if(col is "sendnotifications") return "Send Notifications";
	if(col is "forumname") return "Forum";
	if(col is "conferencename") return "Conference";
	if(col is "minposts") return "Minimum Number of Posts";
	if(col is "lastpostcreated") return "Last Post";
	if(col is "messages") return "Msgs";
	else if(len(col) is 1) return uCase(col);
	else return ucase(left(col,1)) & right(col, len(col)-1);
}
</cfscript>
<cfoutput>
<script>
function checksubmit() {
	if(document.listing.mark.length == null) {
		if(document.listing.mark.checked) {
			document.listing.submit();
			return;
		}
	}
	for(i=0; i < document.listing.mark.length; i++) {
		if(document.listing.mark[i].checked) document.listing.submit();
	}
}
</script>
<cfif isDefined("URL.msg")>
	<cfoutput>
	<div class="clearer"></div>
	<div class="bubbleHead">
		<p class="center bold">#URL.msg#</span></p>
		<div class="clearer"></div>
	</div>
	</cfoutput>
</cfif>
<cfif len(ATTRIBUTES.message)>
	<cfoutput>
	<div class="clearer"></div>
	<div class="bubbleHead">
		<p class="center bold">#ATTRIBUTES.message#</span></p>
		<div class="clearer"></div>
	</div>
	</cfoutput>
</cfif>
<cfif ATTRIBUTES.total gt ATTRIBUTES.perpage>
	<div class="records">
		[ #ATTRIBUTES.perpage# of #numberFormat(ATTRIBUTES.total)# records ]
		[
		<cfif ATTRIBUTES.start gt 1>
			<a href="#CGI.script_name#?start=#ATTRIBUTES.start-ATTRIBUTES.perpage#&sort=#urlEncodedFormat(URL.sort)#&dir=#URL.dir##ATTRIBUTES.linkappend#">Previous</a>
		<cfelse>
			Previous
		</cfif>
		-
		<cfif (ATTRIBUTES.start+ATTRIBUTES.perpage) lt ATTRIBUTES.total>
			<a href="#CGI.script_name#?start=#ATTRIBUTES.start+ATTRIBUTES.perpage#&sort=#urlEncodedFormat (URL.sort)#&dir=#URL.dir##ATTRIBUTES.linkappend#">Next</a>
		<cfelse>
			Next
		</cfif>
		]
	</div>
<cfelse>
	<div class="records">[ #ATTRIBUTES.total# records ]</div>
</cfif>
<div class="clearer"></div>
<form name="listing" action="#CGI.script_name#?#ATTRIBUTES.linkappend#" method="post">
</cfoutput>
	<cfoutput>
	<div class="name_row ui-widget-header">
		<p class="left_5">&nbsp;</p>
		<cfloop index="x" from="1" to="#listLen(ATTRIBUTES.list)#">
			<cfset c = listGetAt(ATTRIBUTES.list, x)>
			<cfif x lte listLen(ATTRIBUTES.classlist)>
				<cfset theclass = listGetAt(ATTRIBUTES.classlist, x)>
			<cfelse>
				<cfset theclass = "">
			</cfif>
			<cfif not listFindNoCase(ATTRIBUTES.nosort, c)>
				<cfif URL.sort is c and URL.dir is "asc">
					<cfset dir = "desc">
				<cfelse>
					<cfset dir = "asc">
				</cfif>
				<p class="#theclass#">
				<!--- static rewrites of a few of the columns --->
				<a href="#CGI.script_name#?start=#ATTRIBUTES.start#&sort=#urlEncodedFormat(c)#&dir=#dir##ATTRIBUTES.linkappend#">#displayHeader(c)#</a>
				</p>
			<cfelse>
				<p class="#theclass#">#displayHeader(c)#</p>
			</cfif>
		</cfloop>
	</div>
	</cfoutput>
	<cfif ATTRIBUTES.total>
		<div class="datatab ui-widget-content">
			<cfoutput query="ATTRIBUTES.data">
				<cfset theLink = ATTRIBUTES.editlink & "?id=#id#">
				<div class="row_#currentRow mod 2#">
					<p class="left_5"><input type="checkbox" name="mark" value="#ATTRIBUTES.data[ATTRIBUTES.linkval][currentRow]#"></p>
					<cfloop index="x" from="1" to="#listLen(ATTRIBUTES.list)#">
						<cfset c = listGetAt(ATTRIBUTES.list, x)>
						<cfset value = ATTRIBUTES.data[c][currentRow]>
						<cfif c is "readonly" or c is "active" or c is "sendnotifications" or c is "sticky" or c is "confirmed" or c is "attachments">
							<cfset value = yesNoFormat(value)>
						<cfelseif (c is "datecreated" or c is "posted" or c is "lastpostcreated") and len(value)>
							<cfset value = dateFormat(value,"mm/dd/yy") & " " & timeFormat(value,"h:mm tt")>
						</cfif>
						<cfif trim(value) is "">
							<cfset value = "&nbsp;">
						</cfif>
						<cfif x lte listLen(ATTRIBUTES.classlist)>
							<cfset theclass = listGetAt(ATTRIBUTES.classlist, x)>
						<cfelse>
							<cfset theclass = "">
						</cfif>
						<div class="#theclass#">
							<p class="right_pad">
							<cfif c is ATTRIBUTES.linkcol>
								<a href="#ATTRIBUTES.editlink#?id=#ATTRIBUTES.data[ATTRIBUTES.linkval][currentRow]#">#value#</a>
							<cfelse>
								#value#
							</cfif>
							</p>
						</div>
					</cfloop>
					<div class="clearer"></div>
				</div>
			</cfoutput>
		</div>
	</cfif>
<cfoutput>
</form>
<div class="bottom_options">[<a href="javascript:checksubmit()">Delete Selected</a>]</div>
</cfoutput>
<cfsetting enablecfoutputonly = false />
<cfexit method="EXITTAG">