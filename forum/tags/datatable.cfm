<cfsetting enablecfoutputonly = true />

<cfparam name="ATTRIBUTES.data" type="query">
<cfparam name="ATTRIBUTES.linkcol" default="#listFirst(ATTRIBUTES.data.columnList)#">
<cfparam name="ATTRIBUTES.linkval" default="id">
<cfparam name="ATTRIBUTES.list" default="#ATTRIBUTES.data.columnList#">
<cfparam name="ATTRIBUTES.classlist" default="">
<cfparam name="URL.page" default="1">
<cfparam name="URL.sort" default="">
<cfparam name="URL.dir" default="asc">
<cfparam name="ATTRIBUTES.linkappend" default="">
<cfparam name="ATTRIBUTES.message" default="">

<cfif URL.dir is not "asc" and URL.dir is not "desc">
	<cfset URL.dir = "asc">
</cfif>

<cfif len(trim(URL.sort)) and len(trim(URL.dir))>
	<cfquery name="ATTRIBUTES.data" dbtype="query">
	select 	*
	from	ATTRIBUTES.data
	order by 	[#URL.sort#] #URL.dir#
	</cfquery>
</cfif>
<cfif not isNumeric(URL.page) or URL.page lte 0>
	<cfset URL.page = 1>
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
	<div class="clearer"></div>
	<cfoutput>
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
<cfif ATTRIBUTES.data.recordCount gt APPLICATION.FORUM.SETTING.perpage>
	<div class="records">
		[ #APPLICATION.FORUM.SETTING.perpage# of #ATTRIBUTES.data.recordCount# records ]
		[
		<cfif URL.page gt 1>
			<a href="#CGI.script_name#?page=#URL.page-1#&sort=#urlEncodedFormat(URL.sort)#&dir=#URL.dir##ATTRIBUTES.linkappend#">Previous</a>
		<cfelse>
			Previous
		</cfif>
		-
		<cfif URL.page * APPLICATION.FORUM.SETTING.perpage lt ATTRIBUTES.data.recordCount>
			<a href="#CGI.script_name#?page=#URL.page+1#&sort=#urlEncodedFormat(URL.sort)#&dir=#URL.dir##ATTRIBUTES.linkappend#">Next</a>
		<cfelse>
			Next
		</cfif>
		]
	</div>
<cfelse>
	<div class="records">[ #ATTRIBUTES.data.recordCount# records ]</div>
</cfif>
<div class="clearer"></div>
<form name="listing" action="#CGI.script_name#?#ATTRIBUTES.linkappend#" method="post">
<div class="name_row ui-widget-header">
	<p class="left_5">&nbsp;</p>
	<cfloop index="x" from="1" to="#listLen(ATTRIBUTES.list)#">
		<cfset c = listGetAt(ATTRIBUTES.list, x)>
		<cfif URL.sort is c and URL.dir is "asc">
			<cfset dir = "desc">
		<cfelse>
			<cfset dir = "asc">
		</cfif>
		<cfif x lte listLen(ATTRIBUTES.classlist)>
			<cfset theclass = listGetAt(ATTRIBUTES.classlist, x)>
		<cfelse>
			<cfset theclass = "">
		</cfif>
		<p class="#theclass#"><a href="#CGI.script_name#?page=#URL.page#&sort=#urlEncodedFormat(c)#&dir=#dir##ATTRIBUTES.linkappend#">#displayHeader(c)#</a></p>
	</cfloop>
</div>
</cfoutput>
<cfif ATTRIBUTES.data.recordCount>
	<div class="datatab ui-widget-content">
		<cfoutput query="ATTRIBUTES.data" startrow="#(URL.page-1)*APPLICATION.FORUM.SETTING.perpage + 1#" maxrows="#APPLICATION.FORUM.SETTING.perpage#">
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
					<cfif trim(value) is ""><cfset value = "&nbsp;"></cfif>
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
<div class="bottom_options">[<a href="#ATTRIBUTES.editlink#?id=0">Add #ATTRIBUTES.label#</a>] [<a href="javascript:checksubmit()">Delete Selected</a>]</div>
</cfoutput>
<cfsetting enablecfoutputonly = false />

<cfexit method="EXITTAG">