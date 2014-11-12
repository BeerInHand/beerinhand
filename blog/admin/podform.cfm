<cfsetting enablecfoutputonly = "true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
	Name         : Pods Display
	Author       : Scott Pinkston
	Created      : October 14, 2006
	Last Updated :
	History      :
--->

<cfparam name="URL.pod" default="">
<cfset podfile = expandPath("#APPLICATION.PATH.ROOT#/blog/includes/pods/#URL.pod#") />
<cfset dir = expandPath("#APPLICATION.PATH.ROOT#/blog/includes/pods")>
<cfset podContent = "">

<cfif len(URL.pod) and fileExists(podfile)>
	<cffile action="read" file="#podfile#" variable="podContent">
</cfif>
<cfset URL.pod = rereplace(URL.pod,".cfm","","ALL")>
<!--- ********************** --->
<cfset podTemplateStart =
"<cfsetting enablecfoutputonly='true'>
<cfprocessingdirective pageencoding='utf-8'>
<cfmodule template='../../tags/podlayout.cfm' title='__TITLE__'>
<!--- Your Pod text goes here - Remember it has to be in cfoutput tags or it will not be displayed --->
<cfoutput>
">

<cfset podTemplateEnd = "
</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly='false'/>">
<!--- ********************** --->

<cfmodule template="../tags/adminlayout.cfm" title="Pods">
	<cfoutput>
	<br />
	<fieldset>
		<legend>Create/Edit Pod</legend>
			<cfform action="x.pod.cfm" method="post">
				Pod Name: <cfinput value="#URL.pod#" validateat="onBlur" validate="regular_expression" pattern="[A-Za-z]" message="Please enter only Alpha characters for the Pod Title" type="text" name="NewPod" size="25"><br>
<cfif len(podContent)>
	<textarea rows="30" cols="75" name="NewPodText">#podContent#</textarea>
	<br><input type="submit" value="Save Changes">
<cfelse>
	<textarea rows="30" cols="75" name="NewPodText">#podTemplateStart#
	#podTemplateEnd#
	</textarea>
	<br><input type="submit" value="Create New Pod">
</cfif>
			</cfform>
		Note: The file will be created in the includes/pods folder.<br />
	</fieldset>
	</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly="false">
<!--- eof --->