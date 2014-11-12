<cfset RowCnt = 0 />

<cfset PageLoad = "_data_grains.cfm" />
<cfset PageText = "Malt/Fermentables" />
<cfset PageTab = "grains" />
<cfset CanEdit = true />
<cfif ArrayLen(REQUEST.URLTokens)>
	<cfif REQUEST.URLTokens[1] eq "hops">
		<cfset PageLoad = "_data_hops.cfm" />
		<cfset PageText = "Hops" />
		<cfset PageTab = "hops" />
	<cfelseif REQUEST.URLTokens[1] eq "misc">
		<cfset PageLoad = "_data_misc.cfm" />
		<cfset PageText = "Miscellaneous" />
		<cfset PageTab = "misc" />
	<cfelseif REQUEST.URLTokens[1] eq "yeast">
		<cfset PageLoad = "_data_yeast.cfm" />
		<cfset PageText = "Yeast" />
		<cfset PageTab = "yeast" />
	<cfelseif REQUEST.URLTokens[1] eq "bjcpstyles">
		<cfset PageLoad = "_data_styles.cfm" />
		<cfset PageText = "BJCP Styles" />
		<cfset PageTab = "bjcpstyles" />
		<cfset CanEdit = false />
	<cfelseif REQUEST.URLTokens[1] eq "brewers">
		<cfset PageLoad = "_data_users.cfm" />
		<cfset PageText = "Brewers" />
		<cfset PageTab = "users" />
		<cfset CanEdit = false />
	</cfif>
</cfif>
<cfset qryPending = APPLICATION.CFC.Factory.Get("UserEdit").QueryUserEditJoined(ue_table=PageTab) />
<cfoutput>
<link href="#APPLICATION.PATH.ROOT#/css/ui.dynatree.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/jquery.dynatree.js"></script>
<div id="divSubPage">
	<div id="divSubPageNav">
		<ul>
			<li><div class="page_head bih-grid-caption padlr10 ui-widget-header ui-corner-all">#PageText#</div></li>
			<li><a href="#APPLICATION.PATH.ROOT#/grains/p.data.cfm">MALT</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/hops/p.data.cfm">HOPS</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/yeast/p.data.cfm">YEAST</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/misc/p.data.cfm">MISC</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/bjcpstyles/p.data.cfm">STYLES</a></li>
			<li><a href="#APPLICATION.PATH.ROOT#/brewers/p.data.cfm">BREWERS</a></li>
		</ul>
	</div>
	<div id="dataContent" class="subpage_content hide">
		<div id="dataHead" class="bih-grid-caption ui-widget-header ui-corner-all">
			<span id="dataTitle">
				<div class="pad10"><div class="ui-widget-content pad10">Click on a node in the explorer pane on the right to begin.<br>Use the search box to perform wildcard searches.</div></div>
			</span>
			<span class="rowcnt"></span>
		</div>
		<div id="dataNav" class="single center">
			<div class="link left fleft" title="Previous"><a href="" class="prev"><img class="bih-icon bih-icon-arrowleft" src="#APPLICATION.PATH.IMG#/trans.gif" align="left" /><span></span></a></div>
			<span class="cnt" onclick="dataLoad()"></span>
			<span class="listview imgbtn ui-corner-all"><img class="bih-icon bih-icon-checkall0" src="#APPLICATION.PATH.IMG#/trans.gif" onclick="dataLoad()" title="View List" /></span>
			<div class="link right fright" title="Next"><a href="" class="next"><span></span><img class="bih-icon bih-icon-arrowright" src="#APPLICATION.PATH.IMG#/trans.gif" align="right" /></a></div>
		</div>
		<cfinclude template="#PageLoad#" />
		<cfif CanEdit>
			<cfif SESSION.LoggedIn>
				<div id="dataButtons" class="single ui-widget-content ui-corner-all right">
					<span class="disp">
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" id="btnSave" src="ui-icon-pencil"  class="ui-button-text-tiny" onclick="dataShowEdit()" text="Edit this data" />
					</span>
					<span class="edit">
					<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" id="btnSave" src="ui-icon-circle-check"  class="ui-button-text-tiny" onclick="dataSave()" text="Save" />
					<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" id="btnCancel" src="ui-icon-circle-close" class="ui-button-text-tiny" onclick="dataShowEdit()" text="Cancel" />
					</span>
				</div>
			</cfif>
			<div id="dataEdits" class="single ui-widget-content ui-corner-all">
				<h5>Submitted changes for the current record:</h5>
				<table>
					<tbody>
						<tr>
							<td class="icon btnDel"><span class="imgbtn ui-corner-all"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="bih-icon bih-icon-delete" onclick="dataEditDelete(this)" /></span></td>
							<td class="icon btnEdit"><span class="imgbtn ui-corner-all" onclick="dataEditView(this)"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="bih-icon bih-icon-accessread" /></span></td>
							<td class="ue_dla" width="175"></td>
							<td class="ue_user" width="175"></td>
							<td class="ue_reason" width="300"></td>
						</tr>
					</tbody>
				</table>
			</div>
		</cfif>
	</div>
	<div id="dataMenu" class="subpage_sidebar">
		<div id="dataTree" class="brewer_sidebox ui-widget-content ui-corner-all">
			<div class="brewer_sidehead bih-grid-caption ui-widget-header ui-corner-all">
				<img class="toggler bih-icon bih-icon-collapse" src="#APPLICATION.PATH.IMG#/trans.gif" onclick="sidebarToggle(this)" title="Show/Hide" />
			</div>
		</div>
		<div id="dataSearch" class="brewer_sidebox ui-widget-content ui-corner-all">
			<div class="brewer_sidehead bih-grid-caption ui-widget-header ui-corner-all">
				Search
				<img class="toggler bih-icon bih-icon-collapse" src="#APPLICATION.PATH.IMG#/trans.gif" onclick="sidebarToggle(this)" title="Show/Hide" />
			</div>
			<div class="pad10">
				<form name="frmDataSrc" onsubmit="return dataSearch();">
				<select name="dataSrcFld" id="dataSrcFld"></select>
				<input type="text" name="dataSrcVal" id="dataSrcVal" placeholder="Search" title="regex is ok" />
				<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" src="ui-icon-search" class="ui-button-icon-tiny" onclick="dataSearch()" title="Search" />
				</form>
			</div>
		</div>
		<cfif CanEdit>
			<div class="brewer_sidebox ui-widget-content ui-corner-all">
				<div class="brewer_sidehead bih-grid-caption ui-widget-header ui-corner-all">
					Pending Edits
					<img class="toggler bih-icon bih-icon-collapse" src="#APPLICATION.PATH.IMG#/trans.gif" onclick="sidebarToggle(this)" title="Show/Hide" />
				</div>
				<div id="dataPEdit" class="padlr10">
					<cfif NOT qryPending.RecordCount>
						<div class="pending">No edits pending.</div>
					<cfelse>
						<cfloop query="qryPending">
							<div class="pending">
								<a href="#APPLICATION.PATH.ROOT#/#ue_table#/#ue_pkid#/#ue_value#/p.data.cfm" title="#ue_pkid#">#ue_value#</a>
								<div class="date">#udfUserDateDisplay(ue_dla)#</div>
							</div>
						</cfloop>
					</cfif>
				</div>
			</div>
		</cfif>
	</div>
</div>

</cfoutput>