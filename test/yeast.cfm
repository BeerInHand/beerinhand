

<cfset cudAccess = true />
<cfset cfcYeast = APPLICATION.CFC.Factory.get("yeast") />
<cfinvoke component="#cfcYeast#" method="QueryYeast" returnvariable="qryRows" />

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
	Displaying <span id="cntRows">#udfAddSWithCnt("Yeast record", qryRows.RecordCount)#</span>.
</div>
</cfoutput>
<table id="tabData" class="datagrid" cellspacing="0">
	<caption>Yeast Listing</caption>
	<thead>
		<tr>
			<cfif cudAccess><th class="icon"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" id="btnAdd" src="ui-icon-circle-plus" onclick="addRecord(this)" title="Add"/></th></cfif>
			<th class="ye_yeast">Yeast</th>
			<th class="ye_atlow {sorter: 'digit'}">첔tten</th>
			<th class="ye_athigh {sorter: 'digit'}">Atten�</th>
			<th class="ye_type">Type</th>
			<th class="ye_mfg">Mfg</th>
			<th class="ye_mfgno">Mfgno</th>
			<th class="ye_info">Info</th>
			<th class="ye_templow {sorter: 'digit'}">첰emp</th>
			<th class="ye_temphigh {sorter: 'digit'}">Temp�</th>
			<th class="ye_dla {sorter: 'bihDate'}">Dla</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="qryRows">
			<tr class="top" id="ye#ye_yeid#" data-rowid="#CurrentRow-1#">
				<cfif cudAccess><td class="icon"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pencil" onclick="editRecord(this)" title="Edit"/></td></cfif>
				<td class="ye_yeast">#ye_yeast#</td>
				<td class="ye_atlow right">#ye_atlow#</td>
				<td class="ye_athigh right">#ye_athigh#</td>
				<td class="ye_type">#ye_type#</td>
				<td class="ye_mfg">#ye_mfg#</td>
				<td class="ye_mfgno">#ye_mfgno#</td>
				<td class="ye_info">#ye_info#</td>
				<td class="ye_templow right">#ye_templow#</td>
				<td class="ye_temphigh right">#ye_temphigh#</td>
				<td class="ye_dla center">#udfUserDateFormat(ye_dla)#</td>
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
				$winEdit.dialog("option", "title", "Add Yeast");
			} else {
				$winEdit.dialog("option", "title", "Edit Yeast");
				$("#spanDelete").show();
			}
			$winEdit.dialog("open");
		}
		clearWinEdit = function() {
			with (document.frmEdit) {
				reset();
				ye_yeid.value = "0";
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
			if (frm.ye_yeid.value=="0") {
				qryRows.rowAdd = queryAddRow(qryRows); // ADDS EMPTY ROW, SAVE NEW ROW POS FOR LATER USE
				var ROW = qryRows.DATA[qryRows.rowAdd];
			} else {
				var ROW = qryRows.DATA[qryRows.rowEdit];
			}
			loadFormToRow(frm, ROW);
			remoteCall("yeast.Process", ROW, cbRemote);
			$winEdit.dialog("close");
		}
		deleteRecord = function(btn) {
			var ROW = qryRows.DATA[qryRows.rowEdit];
			if (!confirm("Are you sure you want to delete this record?")) return false;
			remoteCall("yeast.Process", {kill: 1, YE_YEID: ROW.YE_YEID}, cbRemote);
			$winEdit.dialog("close");
		}
		moveRowToTR = function($tr, ROW) {
			setTD($tr, ROW.YE_YEAST, "ye_yeast", "");
			setTD($tr, ROW.YE_ATLOW, "ye_atlow", "right");
			setTD($tr, ROW.YE_ATHIGH, "ye_athigh", "right");
			setTD($tr, ROW.YE_TYPE, "ye_type", "");
			setTD($tr, ROW.YE_MFG, "ye_mfg", "");
			setTD($tr, ROW.YE_MFGNO, "ye_mfgno", "");
			setTD($tr, ROW.YE_INFO, "ye_info", "");
			setTD($tr, ROW.YE_TEMPLOW, "ye_templow", "right");
			setTD($tr, ROW.YE_TEMPHIGH, "ye_temphigh", "right");
			setTD($tr, ROW.YE_DLA, "ye_dla", "center");

			return $tr;
		}
		updateDataBody = function(noResize) {
			noResize = noResize || false;
			$tabDataBody.trigger("update"); // UPDATE THE SORT
			if (!noResize) $.tablescroller.resizeControl($tabDataBody, true);
		}
		updateRowCnt = function(chg) {
			cntRows += chg;
			$("#cntRows").html(addS(cntRows.toString() + " Yeast record", cntRows));
		}
		cbRemote = function(response) {
			if (!response.SUCCESS) {
				cbErrors(response);
			} else {
				with (document.frmEdit) {
					if (response.DATA.METHOD=="Insert") {
						var ROW = qryRows.DATA[qryRows.rowAdd];
						ROW.YE_YEID = response.DATA.YE_YEID;
						var $tr = $("<tr>").attr("id", "ye" + ROW.YE_YEID);
						$tr.data("rowid", qryRows.rowAdd); // SET THE ROWID TO THE NEW User QRY POS
						setTD($tr, $newEdit.clone(), "icon");
						moveRowToTR($tr, ROW);
						$tabDataBody.find("tbody:first").append($tr);
						updateDataBody();
						updateRowCnt(1);
						showStatusWindow("Row Added");
						clearWinEdit();
					} else if (response.DATA.METHOD=="Update") {
						var $tr = $("#ye"+response.DATA.YE_YEID);
						var rowid = $tr.data("rowid");
						var ROW = qryRows.DATA[rowid];
						moveRowToTR($tr, ROW);
						updateDataBody(true);
						showStatusWindow("Row Updated");
					} else if (response.DATA.METHOD=="Delete") {
						var $tr = $("#ye"+response.DATA.YE_YEID).fadeOut(800,updateDataBody);
						updateRowCnt(-1);
						showStatusWindow("Row Deleted");
					}
				}
			}
		}
		validateForm = function(frm) {
			with (frm) {
				if (isEmpty(ye_yeast, "Yeast is required.")) return false;
				if (!ye_atlow.onblur()) return false;
				if (!ye_athigh.onblur()) return false;
				if (isEmpty(ye_type, "Type is required.")) return false;
				if (isEmpty(ye_mfg, "Mfg is required.")) return false;
				if (isEmpty(ye_mfgno, "Mfgno is required.")) return false;
				if (isEmpty(ye_form, "Form is required.")) return false;
				if (!ye_templow.onblur()) return false;
				if (!ye_temphigh.onblur()) return false;
				if (isEmpty(ye_dla, "Dla is required.")) return false;
				if (!validateDate(ye_dla)) return false;
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
	<div id="winEdit" title="Yeast Maintenance" class="ui-dialog">
		<form id="frmEdit" name="frmEdit">
		<input type="hidden" id="ye_yeid" name="ye_yeid">
		<table id="tabEdit" class="datagrid" cellspacing="0" align="center">
			<tbody class="nobevel bih-grid-form">
				<tr>
					<td class="label required">Yeast</td>
					<td><input type="text" name="ye_yeast" id="ye_yeast" maxlength="60" style="width: 545px" /></td>
				</tr>
				<tr>
					<td class="label">첔tten</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" name="ye_atlow" max="256" min="0" style="width: 35px" /></td>
				</tr>
				<tr>
					<td class="label">Atten�</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" name="ye_athigh" max="256" min="0" style="width: 35px" /></td>
				</tr>
				<tr>
					<td class="label">Atten</td>
					<td><input type="text" name="ye_atten" id="ye_atten" maxlength="11" style="width: 105px" /></td>
				</tr>
				<tr>
					<td class="label">Floc</td>
					<td><input type="text" name="ye_floc" id="ye_floc" maxlength="11" style="width: 105px" /></td>
				</tr>
				<tr>
					<td class="label required">Type</td>
					<td><input type="text" name="ye_type" id="ye_type" maxlength="10" style="width: 95px" /></td>
				</tr>
				<tr>
					<td class="label required">Mfg</td>
					<td><input type="text" name="ye_mfg" id="ye_mfg" maxlength="20" style="width: 185px" /></td>
				</tr>
				<tr>
					<td class="label required">Mfgno</td>
					<td><input type="text" name="ye_mfgno" id="ye_mfgno" maxlength="10" style="width: 95px" /></td>
				</tr>
				<tr>
					<td class="label required">Form</td>
					<td><input type="text" name="ye_form" id="ye_form" maxlength="10" style="width: 95px" /></td>
				</tr>
				<tr>
					<td class="label">Tolerance</td>
					<td><input type="text" name="ye_tolerance" id="ye_tolerance" maxlength="10" style="width: 95px" /></td>
				</tr>
				<tr>
					<td class="label">Info</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="10" width="700px" maxlen="1000" name="ye_info" /></td>
				</tr>
				<tr>
					<td class="label">Url</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="1" width="700px" maxlen="150" name="ye_url" /></td>
				</tr>
				<tr>
					<td class="label">첰emp</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" name="ye_templow" max="256" min="0" style="width: 35px" /></td>
				</tr>
				<tr>
					<td class="label">Temp�</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" name="ye_temphigh" max="256" min="0" style="width: 35px" /></td>
				</tr>
				<tr>
					<td class="label">Tempunits</td>
					<td><input type="text" name="ye_tempunits" id="ye_tempunits" maxlength="10" style="width: 95px" /></td>
				</tr>
				<tr>
					<td class="label required">Dla</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="date" name="ye_dla" /></td>
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

