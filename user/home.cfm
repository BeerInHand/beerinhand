<cffunction name="outputRecipes" returntype="void" output="true">
	<cfargument name="qry" type="query" required="true" />
	<cfargument name="cnt" type="numeric" default="0" />
	<cfif ARGUMENTS.cnt eq 0><cfset ARGUMENTS.cnt = ARGUMENTS.qry.RecordCount /></cfif>
	<cfoutput query="ARGUMENTS.qry" group="re_reid">
		<div id="div#re_reid#" data-rowid="#CurrentRow-1#" class="ui-widget ui-widget-content ui-corner-all" style="padding: 1px">
		<div class="divRecipeHead ui-widget-header ui-corner-top center">
			<span class="re_name"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-pencil" onclick="recipeOpen(#CurrentRow-1#)" title="Edit Recipe"/> #re_name#</span>
			#re_style#
			<span class="re_stats">#re_expgrv# #re_eunits# / #NumberFormat(re_expibu,"999")# IBU</span>
		</div>
		<table id="re#re_reid#" class="tabDates bubbleHead ui-corner-bottom" width="100%" cellspacing="0">
			<thead>
				<tr>
					<th width="25" class="iconarea"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon ui-icon-plusthick" onclick="addRecord(this)" title="Add Date"/></th>
					<th width="90">Date</th>
					<th width="90">Activity</th>
					<th width="75">#re_eunits#</th>
					<th width="75">&deg;#re_tunits#</th>
					<th>Notes</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput>
				<tr id="rd#rd_rdid#" data-rowid="#CurrentRow-1#">
					<td class="iconarea"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-pencil" onclick="editRecord(this)" title="Edit Date"/></td>
					<td class="rd_date">#udfUserDateFormat(rd_date, SESSION.SETTING.datemask)#</td>
					<td class="rd_type">#rd_type#</td>
					<td class="rd_gravity">#rd_gravity#</td>
					<td class="rd_temp">#rd_temp#</td>
					<td class="rd_note"><div style="max-height: 40px; overflow: auto">#rd_note#</div></td>
				</tr>
				</cfoutput>
			</tbody>
		</table>
		</div>
		<p></p>
		<cfset ARGUMENTS.cnt-- />
		<cfif ARGUMENTS.cnt eq 0>
			<cfreturn />
		</cfif>
	</cfoutput>
</cffunction>

<cfset UserStats = APPLICATION.CFC.Recipe.QueryUserStats(re_usid=SESSION.USER.usid) />
<cfset BrewerFavs = APPLICATION.CFC.Recipe.QueryUserProfileFavs(re_usid=SESSION.USER.usid) />
<cfset qryOpenRecipes = APPLICATION.CFC.Recipe.QueryRecipeWithDates(re_usid=SESSION.USER.usid, list_reid=UserStats.listUnPack) />

<style>
.divRecipeHead {padding: 6px; position:relative; }
.divRecipeHead .re_name {position: absolute; left: 1px; top: 1px;}
.divRecipeHead .re_stats {position: absolute; right: 25px;}
.tabDates { border: 1px solid #7a4000; border-top: 0px }
.tabDates tr { vertical-align: top; }
.tabDates tr th, .tabDates tr td { padding: 5px 5px 0; }
.tabDates tr th.iconarea, .tabDates tr td.iconarea { padding: 1px; }
.tabDates tr td { border-top: 1px solid #7a4000; }
</style>

<cfoutput>
<h1>Brewer's Console</h1>
<p>You have #udfAddSWithCnt("Beer Recipe Entry", UserStats.CountRecipe)#.</p>
<p>Your top 5 favorite brewing styles are <cfloop query="BrewerFavs.qryFavStyle" startrow="1" endrow="5">#re_style# (#udfAddSWithCnt("recipe", cntStyle)# / #DecimalFormat(amtStyle)# #us_vunits#)<cfif not BrewerFavs.qryFavStyle.isLast()>, </cfif></cfloop>.</p>

<h1>Recent Unpackaged Batches</h1>
<p>You have #udfAddSWithCnt("Batch", UserStats.RecipeUnpackCount, "es")# that have been brewed but not yet packaged. The most recent are listed below.</p>
#outputRecipes(qryOpenRecipes,5)#
</cfoutput>

<cfoutput>
<script language="javascript" type="text/javascript">
	var cntRows = #UserStats.RecipeUnpackCount#;
	var qryOpenRecipes = #SerializeJSON(qryOpenRecipes)#;
	queryMakeHashable(qryOpenRecipes);
</script>
</cfoutput>

<script language="javascript" type="text/javascript">
	recipeOpen = function(rowid) {
		window.location.href = "?upg=recipe&reid="+qryOpenRecipes.DATA[rowid].RE_REID;
	}
	hideWinEdit = function() {
		$winEdit.dialog("close");
	}
	showWinEdit = function(mode, btn) {
		$("#btnSave span.ui-button-text").html(mode);
		var title = qryOpenRecipes.DATA[$(btn).closest("div").data("rowid")].RE_NAME;
		if (mode=="Add") {
			$("#spanDelete").hide();
			$winEdit.dialog("option", "title", title +  " - Add Actitity");
		} else {
			$winEdit.dialog("option", "title", title + " - Edit Actitity");
			$("#spanDelete").show();
		}
		$winEdit.dialog("open");
	}
	clearWinEdit = function() {
		with (document.frmEdit) {
			reset();
			rd_rdid.value = "0";
		}
	}
	addRecord = function(btn) {
		qryOpenRecipes.rowEdit = $(btn).closest("div").data("rowid"); // STORE THIS SO WE CAN COPY FROM THE ELDEST CHILD
		clearWinEdit();
		showWinEdit("Add", btn);
	}
	editRecord = function(btn) {
		var $tr = $(btn).closest("tr");
		var rowid = $tr.data("rowid");
		qryOpenRecipes.rowEdit = rowid;
		var ROW = qryOpenRecipes.DATA[rowid];
		loadRowToForm(ROW, document.frmEdit);
		$("#re_eunits").html(ROW.re_eunits);
		$("#re_tunits").html(ROW.RE_TUNITS);
		showWinEdit("Save", btn);
	}
	saveRecord = function(btn) {
		var frm = document.frmEdit;
		if (!validateForm(frm)) return false;
		if (frm.rd_rdid.value=="0") {
			qryOpenRecipes.rowAdd = queryAddRow(qryOpenRecipes); // ADDS EMPTY ROW, SAVE NEW ROW POS FOR LATER USE
			var ROW = qryOpenRecipes.DATA[qryOpenRecipes.rowAdd];
			ROW.RD_REID = qryOpenRecipes.DATA[qryOpenRecipes.rowEdit].RE_REID; // COPY FROM THE ELDEST CHILD
			ROW.re_eunits = qryOpenRecipes.DATA[qryOpenRecipes.rowEdit].re_eunits;
			ROW.RE_TUNITS = qryOpenRecipes.DATA[qryOpenRecipes.rowEdit].RE_TUNITS;
		} else {
			var ROW = qryOpenRecipes.DATA[qryOpenRecipes.rowEdit];
		}
		loadFormToRow(frm, ROW);
		remoteCall("RecipeDates.Process", ROW, cbRemote);
		$winEdit.dialog("close");
	}
	deleteRecord = function(btn) {
		var ROW = qryOpenRecipes.DATA[qryOpenRecipes.rowEdit];
		if (!confirm("Are you sure you want to delete this record?")) return false;
		remoteCall("RecipeDates.Process", {kill: 1, RD_RDID: ROW.RD_RDID}, cbRemote);
		$winEdit.dialog("close");
	}
	moveRowToTR = function($tr, ROW) {
		setTD($tr, ROW.RD_DATE, "rd_date", "");
		setTD($tr, ROW.RD_TYPE, "rd_type", "");
		setTD($tr, ROW.RD_GRAVITY, "rd_gravity", "");
		setTD($tr, ROW.RD_TEMP, "rd_temp", "");
		setTD($tr, ROW.RD_NOTE, "rd_note", "");
		return $tr;
	}
	cbRemote = function(response) {
		if (!response.SUCCESS) {
			cbErrors(response);
		} else {
			with (document.frmEdit) {
				if (response.DATA.METHOD=="Insert") {
					var ROW = qryOpenRecipes.DATA[qryOpenRecipes.rowAdd];
					ROW.RD_RDID = response.DATA.RD_RDID;
					var $tr = $("<tr>").attr("id", "re" + ROW.RD_RDID);
					$tr.data("rowid", qryOpenRecipes.rowAdd); // SET THE ROWID TO THE NEW User QRY POS
					setTD($tr, $newEdit.clone(), "iconarea");
					moveRowToTR($tr, ROW);
					$tab = $("#re" + ROW.RD_REID);
					$tab.find("tbody").prepend($tr);
					showStatusWindow("Row Added");
					clearWinEdit();
				} else if (response.DATA.METHOD=="Update") {
					var $tr = $("#rd"+response.DATA.RD_RDID);
					var rowid = $tr.data("rowid");
					var ROW = qryOpenRecipes.DATA[rowid];
					moveRowToTR($tr, ROW);
					showStatusWindow("Row Updated");
				} else if (response.DATA.METHOD=="Delete") {
					var $tr = $("#rd"+response.DATA.RD_RDID).fadeOut(800,updateDataBody);
					showStatusWindow("Row Deleted");
				}
			}
		}
	}
	validateForm = function(frm) {
		with (frm) {
			if (isEmpty(rd_date, "Date is required.")) return false;
			if (!validateDate(rd_date)) return false;
			if (isEmpty(rd_type, "Type is required.")) return false;
			if (!rd_gravity.onblur()) return false;
			if (!rd_temp.onblur()) return false;
		}
		return true;;
	}
	setupWinEdit = function() {
		$newEdit = $("#btnEdit").detach().removeAttr("id");
		$winEdit = $("#winEdit");
		$winEditButtons = $("#winEditButtons");
		$winEdit.dialog({autoOpen: false, width: "auto", modal: true, buttons: [{ text: "Cancel"}]});
		$winEdit.dialog("widget").find(".ui-dialog-buttonset").empty().append($winEditButtons);
	}
	mmddyyToUserFormat = function(d, dp) {
		var jsDate = $(this).datepicker("getDate");
		this.value = jsDateFormat(jsDate, cfDateMask);
	}
	$(document).ready(
		function() {
			setupWinEdit();
			$("#rd_date").datepicker({showOn: "button", buttonImageOnly: true, buttonImage: "images/icon_calendar.png", onSelect: mmddyyToUserFormat });
			spinnerBindGravity($("#rd_gravity"), bihDefaults.EUNITS, spinnerInc);
			spinnerBindTemp($("#rd_temp"), bihDefaults.TUNITS, spinnerInc);
		}
	);
</script>

<cfoutput>
<div id="winEdit" title="RecipeDates Maintenance" class="ui-dialog">
	<form id="frmEdit" name="frmEdit">
	<input type="hidden" id="rd_rdid" name="rd_rdid" />
	<table id="tabEdit" class="datagrid" cellspacing="0" align="center">
		<tbody class="nobevel bih-grid-form">
			<tr>
				<td class="label required">Date</td>
				<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="date" id="rd_date" name="rd_date" style="width: 100px" /></td>
			</tr>
			<tr>
				<td class="label required">Type</td>
				<td><button type="button" id="rd_type" name="rd_type" class="butRotateBig units" style="width: 100px; font-weight: bold;" onclick="rd_typeClick(this)" value="Packaged">Packaged</button></td>
			</tr>
			<tr>
				<td class="label">Gravity</td>
				<td>
					<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="rd_gravity" id="rd_gravity" max="1.150" min="0.990" style="width: 50px" />
					<span id="re_eunits"></span>
				</td>
			</tr>
			<tr>
				<td class="label">Temperature</td>
				<td>
					<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="rd_temp" id="rd_temp" max="100" min="0" style="width: 50px" />
					&deg;<span id="re_tunits"></span>
				</td>
			</tr>
			<tr>
				<td class="label">Note</td>
				<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="20" width="600px" maxlen="2000" name="rd_note" /></td>
			</tr>
		</tbody>
	</table>
	<div id="winEditButtons">
		<span>
			<span id="spanDelete" style="float:right">
				<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" id="btnDelete" src="ui-icon-trash" onclick="deleteRecord(this)" text="Delete"/>
			</span>
		</span>
		<span>
			<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" id="btnSave" src="ui-icon-circle-check" onclick="saveRecord(this)" text="Save"/>
			<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" id="btnCancel" src="ui-icon-circle-close" onclick="hideWinEdit(this)" text="Cancel"/>
			<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" id="btnEdit" src="ui-icon-pencil" onclick="editRecord(this)" title="Edit"/>
		</span>
	</div>
	</form>
</div>
</cfoutput>
