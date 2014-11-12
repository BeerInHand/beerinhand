<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
	Name         : category.cfm
	Author       : Raymond Camden
	Created      : 04/07/06
	Last Updated :
	History      :
--->

<!---
<cfif not SESSION.BROG.isBlogAuthorized('ManageCategories')>
	<cflocation url="x.index.cfm" addToken="false">
</cfif>
 --->

<cftry>
	<cfif URL.id neq 0>
		<cfset cat = SESSION.BROG.getCategory(URL.id)>
		<cfparam name="form.name" default="#cat.categoryname#">
		<cfparam name="form.alias" default="#cat.categoryalias#">
	<cfelse>
		<cfparam name="form.name" default="">
		<cfparam name="form.alias" default="">
	</cfif>
	<cfcatch>
		<cflocation url="#APPLICATION.PATH.FULL#/#REQUEST.BLOG#/blog/categories/p.brewer.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfif structKeyExists(form, "cancel")>
	<cflocation url="#APPLICATION.PATH.FULL#/#REQUEST.BLOG#/blog/categories/p.brewer.cfm" addToken="false">
</cfif>

<cfif structKeyExists(form, "save")>
	<cfset errors = arrayNew(1)>

	<cfif not len(trim(form.name))>
		<cfset arrayAppend(errors, "The name cannot be blank.")>
	</cfif>
	<cfif not len(trim(form.alias))>
		<cfset form.alias = SESSION.BROG.makeTitle(form.name)>
	<cfelseif reFind("[^[:alnum:] -]", form.alias)>
		<cfset arrayAppend(errors, "Your alias may only contain letters, numbers, spaces, or hyphens.")>
	</cfif>
	<cfif not arrayLen(errors)>
		<cftry>
		<cfif URL.id neq 0>
			<cfset SESSION.BROG.saveCategory(URL.id, left(form.name,50), left(form.alias, 50))>
		<cfelse>
			<cfset SESSION.BROG.addCategory(left(form.name,50), left(form.alias,50))>
		</cfif>
		<cfcatch>
			<cfif findNoCase("already exists as a category", cfcatch.message)>
				<cfset arrayAppend(errors, "A category with this name already exists.")>
			<cfelse>
				<cfrethrow>
			</cfif>
		</cfcatch>
		</cftry>

		<cfif not arrayLen(errors)>
			<!--- clear the archive pod cache --->
			<cfmodule template="../tags/scopecache.cfm" action="clear" scope="application" cachename="pod_archives" />

			<cflocation url="#APPLICATION.PATH.FULL#/#REQUEST.BLOG#/blog/categories/p.brewer.cfm" addToken="false">
		</cfif>
	</cfif>

</cfif>


<cfmodule template="../tags/adminlayout.cfm" title="Category Editor">

	<cfif structKeyExists(variables, "errors") and arrayLen(errors)>
		<cfoutput>
		<div class="errors">
		Please correct the following error(s):
		<ul>
		<cfloop index="x" from="1" to="#arrayLen(errors)#">
		<li>#errors[x]#</li>
		</cfloop>
		</ul>
		</div>
		</cfoutput>
	</cfif>

	<cfoutput>
	<p>Use the form below to edit your blog category.</p>

	<form action="#APPLICATION.PATH.FULL#/#REQUEST.BLOG#/blog/category/p.brewer.cfm?id=#URL.id#" method="post">
	<table cellspacing="10">
		<tr>
			<td class="label">Category:</td>
			<td><input type="text" name="name" value="#form.name#" class="txtField" maxlength="50" required="required"></td>
		</tr>
		<tr>
			<td class="label">SES Alias:</td>
			<td>
				<input type="text" name="alias" value="#form.alias#" class="txtField" maxlength="50" readonly="readonly">
				<span class="moderated">...autogenerated</span>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-cancel" name="cancel" text="Cancel" submit="true" />
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-disk" name="save" text="Save" submit="true" />
		</tr>
	</table>
	</form>
	<script language="javaScript" TYPE="text/javascript">
	<!--
	document.forms[0].name.focus();
	//-->
	</script>
	</cfoutput>
</cfmodule>

<cfsetting enablecfoutputonly="false" />
