<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />

<cfset REQUEST.brewer = SESSION.USER.user />
<cfset qryBrewer = APPLICATION.CFC.Users.QueryUsers(us_user = REQUEST.brewer) />
<cfinclude template="#APPLICATION.PATH.ROOT#/blog/OnRequest.cfm">

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset SESSION.BROG.deleteComment(u)>
	</cfloop>
</cfif>

<cfset sSortDir = "desc" />

<cfset comments = SESSION.BROG.getComments(id=URL.id, sortdir=sSortDir)>

<cfoutput>
<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/css/popout.css" />
<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/blog/css/admin.css" media="screen" />
<style>
##divHeader { display: none; }
##divContent { padding: 0; margin: 0; }
</style>
	<script type="text/javascript">
		window.onload = adjustIframeSize;

		function adjustIframeSize(){
			var el = document.getElementById("commentsBody");

			parent.document.getElementById("commentsFrame").style.height = el.offsetHeight + "px";
		}
	</script>

	<p>
		This entry currently has
			<cfif comments.RecordCount gt 1>
			#numberFormat(comments.RecordCount)# comments.
			<cfelseif comments.RecordCount is 1>
			1 comment.
			<cfelse>
			0 comments.
			</cfif>
	</p>
</cfoutput>

<cfmodule template="#APPLICATION.PATH.ROOT#/blog/tags/datatable.cfm" data="#comments#" editlink="x.comment.cfm" label="Comments"
		  linkcol="none" defaultsort="posted" defaultdir="#sSortDir#" showAdd="false" queryString="id=#URL.id#" perpage="10">
	<cfmodule template="#APPLICATION.PATH.ROOT#/blog/tags/datacol.cfm" colname="name" label="Name" width="150" />
	<cfmodule template="#APPLICATION.PATH.ROOT#/blog/tags/datacol.cfm" colname="posted" label="Posted" format="datetime" width="150" />
	<cfmodule template="#APPLICATION.PATH.ROOT#/blog/tags/datacol.cfm" colname="comment" label="Comment" width="300"/>
	<cfmodule template="#APPLICATION.PATH.ROOT#/blog/tags/datacol.cfm" label="View" data="<a href=""#APPLICATION.PATH.ROOT#/x.comment.cfm?id=$id$"" target=""_top"">View</a>" sort="false"/>
</cfmodule>

<cfsetting enablecfoutputonly="false" />