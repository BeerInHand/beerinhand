

<cfset cudAccess = true />
<cfset cfcMisc = APPLICATION.CFC.Factory.get("misc") />
<cfinvoke component="#cfcMisc#" method="QueryMisc" returnvariable="qryRows" />

<script language="javascript" type="text/javascript">
	$(document).ready(
		function() {
			$tabDataBody = $("#tabData").tablescroller({
				sort: true,
				print: false,
				width: viewport.width()-25,
				height: viewport.height()-175,
				borderWidth: 1
			});
			if (window["setupWinEdit"]) setupWinEdit();
		}
	);
</script>
<cfoutput>
<div style="margin: 5px 10px 5px 0; padding: 2px;">
	Displaying <span id="cntRows">#udfAddSWithCnt("Misc record", qryRows.RecordCount)#</span>.
</div>
</cfoutput>
<table id="tabData" class="datagrid" cellspacing="0">
	<caption>Misc Listing</caption>
	<thead>
		<tr>
			<cfif cudAccess><th class="icon"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" id="btnAdd" src="ui-icon-circle-plus" onclick="addRecord(this)" title="Add"/></th></cfif>
			<th class="mi_type">Type</th>
			<th class="mi_use">Use</th>
			<th class="mi_utype">Unit type</th>
			<th class="mi_unit">Unit</th>
			<th class="mi_phase">Phase</th>
			<th class="mi_info">Info</th>
			<th class="mi_url">Url</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="qryRows">
			<tr class="top" id="mi#mi_miid#" data-rowid="#CurrentRow-1#">
				<cfif cudAccess><td class="icon"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pencil" onclick="editRecord(this)" title="Edit"/></td></cfif>
				<td class="mi_type">#mi_type#</td>
				<td class="mi_use">#mi_use#</td>
				<td class="mi_utype">#mi_utype#</td>
				<td class="mi_unit">#mi_unit#</td>
				<td class="mi_phase">#mi_phase#</td>
				<td class="mi_info">#mi_info#</td>
				<td class="mi_url">#mi_url#</td>
			</tr>
		</cfoutput>
	</tbody>
</table>
<cfif cudAccess>
	<cfoutput>
	<script language="javascript" type="text/javascript">
		var cntRows = #qryRows.RecordCount#;
		var qryRows = #SerializeJSON(qryRows)#;
		queryMakeHashable(qryRows);
	</script>
	</cfoutput>
	<script language="javascript" type="text/javascript">
		hideWinEdit = function() {
			$winEdit.dialog("close");
		}
		showWinEdit = function(mode) {
			$("#btnSave span.ui-button-text").html(mode);
			if (mode=="Add") {
				$("#spanDelete").hide();
				$winEdit.dialog("option", "title", "Add Misc");
			} else {
				$winEdit.dialog("option", "title", "Edit Misc");
				$("#spanDelete").show();
			}
			$winEdit.dialog("open");
		}
		clearWinEdit = function() {
			with (document.frmEdit) {
				reset();
				mi_miid.value = "0";
			}
		}
		addRecord = function() {
			clearWinEdit();
			showWinEdit("Add");
		}
		editRecord = function(btn) {
			var $tr = $(btn).closest("tr");
			var rowid = $tr.data("rowid");
			qryRows.rowEdit = rowid;
			var ROW = qryRows.DATA[rowid];
			loadRowToForm(ROW, document.frmEdit);
			showWinEdit("Save");
		}
		saveRecord = function(btn) {
			var frm = document.frmEdit;
			if (!validateForm(frm)) return false;
			if (frm.mi_miid.value=="0") {
				qryRows.rowAdd = queryAddRow(qryRows); // ADDS EMPTY ROW, SAVE NEW ROW POS FOR LATER USE
				var ROW = qryRows.DATA[qryRows.rowAdd];
			} else {
				var ROW = qryRows.DATA[qryRows.rowEdit];
			}
			loadFormToRow(frm, ROW);
			remoteCall("misc.Process", ROW, cbRemote);
			$winEdit.dialog("close");
		}
		deleteRecord = function(btn) {
			var ROW = qryRows.DATA[qryRows.rowEdit];
			if (!confirm("Are you sure you want to delete this record?")) return false;
			remoteCall("misc.Process", {kill: 1, MI_MIID: ROW.MI_MIID}, cbRemote);
			$winEdit.dialog("close");
		}
		moveRowToTR = function($tr, ROW) {
			setTD($tr, ROW.MI_TYPE, "mi_type", "");
			setTD($tr, ROW.MI_USE, "mi_use", "");
			setTD($tr, ROW.MI_UTYPE, "mi_utype", "");
			setTD($tr, ROW.MI_UNIT, "mi_unit", "");
			setTD($tr, ROW.MI_PHASE, "mi_phase", "");
			setTD($tr, ROW.MI_INFO, "mi_info", "");
			setTD($tr, ROW.MI_URL, "mi_url", "");

			return $tr;
		}
		updateDataBody = function(noResize) {
			noResize = noResize || false;
			$tabDataBody.trigger("update"); // UPDATE THE SORT
			if (!noResize) $.tablescroller.resizeControl($tabDataBody, true);
		}
		updateRowCnt = function(chg) {
			cntRows += chg;
			$("#cntRows").html(addS(cntRows.toString() + " Misc record", cntRows));
		}
		cbRemote = function(response) {
			if (!response.SUCCESS) {
				cbErrors(response);
			} else {
				with (document.frmEdit) {
					if (response.DATA.METHOD=="Insert") {
						var ROW = qryRows.DATA[qryRows.rowAdd];
						ROW.MI_MIID = response.DATA.MI_MIID;
						var $tr = $("<tr>").attr("id", "mi" + ROW.MI_MIID);
						$tr.data("rowid", qryRows.rowAdd); // SET THE ROWID TO THE NEW User QRY POS
						setTD($tr, $newEdit.clone(), "icon");
						moveRowToTR($tr, ROW);
						$tabDataBody.find("tbody:first").append($tr);
						updateDataBody();
						updateRowCnt(1);
						showStatusWindow("Row Added");
						clearWinEdit();
					} else if (response.DATA.METHOD=="Update") {
						var $tr = $("#mi"+response.DATA.MI_MIID);
						var rowid = $tr.data("rowid");
						var ROW = qryRows.DATA[rowid];
						moveRowToTR($tr, ROW);
						updateDataBody(true);
						showStatusWindow("Row Updated");
					} else if (response.DATA.METHOD=="Delete") {
						var $tr = $("#mi"+response.DATA.MI_MIID).fadeOut(800,updateDataBody);
						updateRowCnt(-1);
						showStatusWindow("Row Deleted");
					}
				}
			}
		}
		validateForm = function(frm) {
			with (frm) {
				if (isEmpty(mi_type, "Type is required.")) return false;
				if (isEmpty(mi_dla, "Dla is required.")) return false;
				if (!validateDate(mi_dla)) return false;
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
	</script>
	<cfoutput>
	<div id="winEdit" title="Misc Maintenance" class="ui-dialog">
		<form id="frmEdit" name="frmEdit">
		<input type="hidden" id="mi_miid" name="mi_miid">
		<table id="tabEdit" class="datagrid" cellspacing="0" align="center">
			<tbody class="nobevel bih-grid-form">
				<tr>
					<td class="label required">Type</td>
					<td><input type="text" name="mi_type" id="mi_type" maxlength="25" style="width: 230px" /></td>
				</tr>
				<tr>
					<td class="label">Use</td>
					<td><input type="text" name="mi_use" id="mi_use" maxlength="25" style="width: 230px" /></td>
				</tr>
				<tr>
					<td class="label">Unit type</td>
					<td><input type="text" name="mi_utype" id="mi_utype" maxlength="1" style="width: 15px" /></td>
				</tr>
				<tr>
					<td class="label">Unit</td>
					<td><input type="text" name="mi_unit" id="mi_unit" maxlength="12" style="width: 115px" /></td>
				</tr>
				<tr>
					<td class="label">Phase</td>
					<td><input type="text" name="mi_phase" id="mi_phase" maxlength="8" style="width: 80px" /></td>
				</tr>
				<tr>
					<td class="label">Info</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="10" width="700px" maxlen="1000" name="mi_info" /></td>
				</tr>
				<tr>
					<td class="label">Url</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="1" width="700px" maxlen="150" name="mi_url" /></td>
				</tr>
				<tr>
					<td class="label required">Dla</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="date" name="mi_dla" /></td>
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
</cfif>

