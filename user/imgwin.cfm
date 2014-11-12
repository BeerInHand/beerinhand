<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<cfoutput><link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/css/popout.css" /></cfoutput>

<cfset REQUEST.brewer = SESSION.USER.user />
<cfset qryBrewer = APPLICATION.CFC.Users.QueryUsers(us_user = REQUEST.brewer) />
<cfinclude template="#APPLICATION.PATH.ROOT#/blog/OnRequest.cfm">
<!--- <cfif NOT SESSION.BROG.isBlogAuthorized()>
	<cfoutput><script>window.close();</script></cfoutput>
	<cfabort>
</cfif> --->

<cfif structKeyExists(form, "upload") and len(trim(form.newimage))>
	<cfset imageDirectory = udfMakeDirIfNot("#APPLICATION.DISK.BLOGIMG#\#REQUEST.BLOG#") />
	<cffile action="upload" filefield="form.newimage" destination="#imageDirectory#" nameconflict="overwrite">
	<cfif not listFindNoCase("gif,jpg,png", cffile.serverFileExt) OR NOT IsImageFile(cffile.serverDirectory & "/" & cffile.serverFile)>
		<cfset notImageFlag = true>
		<cffile action="delete" file="#cffile.serverDirectory#/#cffile.serverFile#">
	<cfelse>
		<cfset fileName = cffile.serverFile>
		<cfoutput>
		<script>
			opener.newImage("#APPLICATION.PATH.BLOGIMG#/#REQUEST.BLOG#/#jsStringFormat(filename)#");
			window.close();
		</script>
		</cfoutput>
		<cfabort>
	</cfif>
</cfif>
<cfoutput>

<cfif structKeyExists(variables, "notImageFlag")>
	<div class="pad10"><div class="ui-state-default ui-state-error ui-corner-all pad10">File '#cffile.serverFile#' is not a valid image.</div></div>
</cfif>
<div class="page_head bih-grid-caption pad10 ui-widget-header ui-corner-all">#REQUEST.BLOG#'s Image Upload</div>
<br>
<h3>Select Image to Upload</h3>
<form method="post" enctype="multipart/form-data">
	<input type="file" name="newimage"> <input type="submit" name="upload" value="Upload Image">
</form>
</cfoutput>
<cfsetting enablecfoutputonly="false" />
