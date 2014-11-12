<cfsetting enablecfoutputonly = true />
<cfparam name="form.searchterms" default="">
<cfset form.searchterms = trim(htmlEditFormat(APPLICATION.FORUM.Utils.searchSafe(form.searchterms)))>
<cfparam name="form.searchtype" default="phrase">
<cfmodule template="tags/layout.cfm" templatename="main" title="#APPLICATION.FORUM.SETTING.title# : Search"><!--- Loads header --->
	<cfif len(form.searchterms)><!--- Handle attempted search --->
		<cfif not listFindNoCase("phrase,any,all", form.searchtype)>
			<cfset form.searchtype = "phrase">
		</cfif>
		<cfset messages = APPLICATION.FORUM.Message.search(form.searchterms, form.searchtype)>
		<cfset APPLICATION.FORUM.Utils.logSearch(form.searchTerms, APPLICATION.DSN.FORUM)>
		<cfset data = APPLICATION.FORUM.Conference.getConferences()><!--- get my conferences --->
		<cfset data = APPLICATION.FORUM.Permission.filter(query=data, groups=REQUEST.udf.getGroups(), right=APPLICATION.FORUM.Rights.CANVIEW)><!--- filter by what I can read... --->
		<cfif data.recordCount is 1>
			<cfset showConferences = false>
		<cfelse>
			<cfset showConferences = true>
		</cfif>
	</cfif>
	<cfoutput>
	<div class="ui-widget-header post_title">Search</div>
	<div class="ui-widget-content">
		<form action="#CGI.script_name#?#CGI.query_string#" method="post" id="searchForm">
			<table class="datagrid noborder" cellspacing="0">
				<tbody class="bih-grid-form nobevel">
					<tr>
						<td class="label">Search Terms:</td>
						<td><input type="text" name="searchterms" value="#form.searchterms#"  class="input_box" maxlength="100"></td>
					</tr>
					<tr>
						<td class="label">Match:</td>
						<td>
							<select name="searchtype" class="select_box">
								<option value="phrase" <cfif form.searchtype is "phrase">selected</cfif>>Phrase</option>
								<option value="any" <cfif form.searchtype is "any">selected</cfif>>Any Word</option>
								<option value="all" <cfif form.searchtype is "all">selected</cfif>>All Words</option>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="post_buttons ui-widget-content ui-corner-all">
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" submit="true" class="ui-button-text-tiny" src="ui-icon-search" name="search" text="Search"/>
			</div>
		</form>
	</div>
	<cfif len(form.searchterms)>
		<br/>
		<div class="ui-widget-content">
			<cfif messages.recordCount>
				<cfset lastConf = "">
				<cfset lastForum = "">
				<cfset didOne = false>
				<cfloop query="messages">
					<cfif APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, forumidfk, REQUEST.udf.getGroups()) and APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, conferenceidfk, REQUEST.udf.getGroups())>
						<cfif not didOne>
								<table class="datagrid noborder" cellspacing="0" width="100%">
						</cfif>
						<cfif conference neq lastConf or forum neq lastForum>
						<thead class="bubbleHead">
							<tr>
								<th colspan="2"><cfif showConferences>#conference# / </cfif>#forum#</th>
							</tr>
						</thead>
							<cfset lastConf = conference>
							<cfset lastForum = forum>
						</cfif>
						<tr>
							<td>#thread#</td>
							<td><a href="f.messages.cfm?threadid=#threadidfk#&mid=#id#">#title#</a></td>
						</tr>
						<cfset didOne = true>
					</cfif>
				</cfloop>
				<cfif didOne>
							</table>
				<cfelse>
					Sorry, but there were no matches.
				</cfif>
			<cfelse>
				Sorry, but there were no matches.
			</cfif>
		</div>
	</cfif>
	<script>window.onload = function() {document.getElementById("searchForm").searchterms.focus()}</script>
	</cfoutput>
</cfmodule>
<cfsetting enablecfoutputonly = false />
