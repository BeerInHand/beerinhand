

<cfset cudAccess = true />
<cfset cfcusers = APPLICATION.CFC.Factory.get("users") />
<cfinvoke component="#cfcusers#" method="Queryusers" returnvariable="qryRows" />

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
	Displaying <span id="cntRows">#udfAddSWithCnt("users record", qryRows.RecordCount)#</span>.
</div>
</cfoutput>
<table id="tabData" class="datagrid" cellspacing="0">
	<caption>users Listing</caption>
	<thead>
		<tr>
			<cfif cudAccess><th class="icon"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" id="btnAdd" src="ui-icon-circle-plus" onclick="addRecord(this)" title="Add"/></th></cfif>
			<th class="us_user">User</th>
			<th class="us_first">First</th>
			<th class="us_last">Last</th>
			<th class="us_email">Email</th>
			<th class="us_pwd">Pwd</th>
			<th class="us_vunits">Vunits</th>
			<th class="us_viunits">Viunits</th>
			<th class="us_munits">Munits</th>
			<th class="us_hunits">Hunits</th>
			<th class="us_tunits">Tunits</th>
			<th class="us_eunits">Eunits</th>
			<th class="us_boilvol {sorter: 'digit'}">Boilvol</th>
			<th class="us_volume {sorter: 'digit'}">Volume</th>
			<th class="us_eff {sorter: 'digit'}">Eff</th>
			<th class="us_primer">Primer</th>
			<th class="us_ratio {sorter: 'digit'}">Ratio</th>
			<th class="us_maltcap {sorter: 'digit'}">Maltcap</th>
			<th class="us_thermal {sorter: 'digit'}">Thermal</th>
			<th class="us_hopform">Hopform</th>
			<th class="us_hydrotemp {sorter: 'digit'}">Hydrotemp</th>
			<th class="us_mashtype">Mashtype</th>
			<th class="us_datemask">Datemask</th>
			<th class="us_postal">Postal</th>
			<th class="us_privacy {sorter: 'digit'}">Privacy</th>
			<th class="us_offset {sorter: 'digit'}">Offset</th>
			<th class="us_moderate {sorter: 'digit'}">Moderate</th>
			<th class="us_tweetback {sorter: 'digit'}">Tweetback</th>
			<th class="us_added {sorter: 'bihDate'}">Added</th>
			<th class="us_validated {sorter: 'bihDate'}">Validated</th>
			<th class="us_dla {sorter: 'bihDate'}">Dla</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="qryRows">
			<tr class="top" id="us#us_usid#" data-rowid="#CurrentRow-1#">
				<cfif cudAccess><td class="icon"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pencil" onclick="editRecord(this)" title="Edit"/></td></cfif>
				<td class="us_user">#us_user#</td>
				<td class="us_first">#us_first#</td>
				<td class="us_last">#us_last#</td>
				<td class="us_email">#us_email#</td>
				<td class="us_pwd">#us_pwd#</td>
				<td class="us_vunits">#us_vunits#</td>
				<td class="us_viunits">#us_viunits#</td>
				<td class="us_munits">#us_munits#</td>
				<td class="us_hunits">#us_hunits#</td>
				<td class="us_tunits">#us_tunits#</td>
				<td class="us_eunits">#us_eunits#</td>
				<td class="us_boilvol right">#us_boilvol#</td>
				<td class="us_volume right">#us_volume#</td>
				<td class="us_eff right">#us_eff#</td>
				<td class="us_primer">#us_primer#</td>
				<td class="us_ratio right">#us_ratio#</td>
				<td class="us_maltcap right">#us_maltcap#</td>
				<td class="us_thermal right">#us_thermal#</td>
				<td class="us_hopform">#us_hopform#</td>
				<td class="us_hydrotemp right">#us_hydrotemp#</td>
				<td class="us_mashtype">#us_mashtype#</td>
				<td class="us_datemask">#us_datemask#</td>
				<td class="us_postal">#us_postal#</td>
				<td class="us_privacy right">#us_privacy#</td>
				<td class="us_offset right">#us_offset#</td>
				<td class="us_moderate right">#us_moderate#</td>
				<td class="us_tweetback right">#us_tweetback#</td>
				<td class="us_added center">#udfUserDateFormat(us_added)#</td>
				<td class="us_validated center">#udfUserDateFormat(us_validated)#</td>
				<td class="us_dla center">#udfUserDateFormat(us_dla)#</td>
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
				$winEdit.dialog("option", "title", "Add users");
			} else {
				$winEdit.dialog("option", "title", "Edit users");
				$("#spanDelete").show();
			}
			$winEdit.dialog("open");
		}
		clearWinEdit = function() {
			with (document.frmEdit) {
				reset();
				us_usid.value = "0";
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
			if (frm.us_usid.value=="0") {
				qryRows.rowAdd = queryAddRow(qryRows); // ADDS EMPTY ROW, SAVE NEW ROW POS FOR LATER USE
				var ROW = qryRows.DATA[qryRows.rowAdd];
			} else {
				var ROW = qryRows.DATA[qryRows.rowEdit];
			}
			loadFormToRow(frm, ROW);
			remoteCall("users.Process", ROW, cbRemote);
			$winEdit.dialog("close");
		}
		deleteRecord = function(btn) {
			var ROW = qryRows.DATA[qryRows.rowEdit];
			if (!confirm("Are you sure you want to delete this record?")) return false;
			remoteCall("users.Process", {kill: 1, US_USID: ROW.US_USID}, cbRemote);
			$winEdit.dialog("close");
		}
		moveRowToTR = function($tr, ROW) {
			setTD($tr, ROW.US_USER, "us_user", "");
			setTD($tr, ROW.US_FIRST, "us_first", "");
			setTD($tr, ROW.US_LAST, "us_last", "");
			setTD($tr, ROW.US_EMAIL, "us_email", "");
			setTD($tr, ROW.US_PWD, "us_pwd", "");
			setTD($tr, ROW.US_VUNITS, "us_vunits", "");
			setTD($tr, ROW.US_VIUNITS, "us_viunits", "");
			setTD($tr, ROW.US_MUNITS, "us_munits", "");
			setTD($tr, ROW.US_HUNITS, "us_hunits", "");
			setTD($tr, ROW.US_TUNITS, "us_tunits", "");
			setTD($tr, ROW.US_EUNITS, "us_eunits", "");
			setTD($tr, ROW.US_BOILVOL, "us_boilvol", "right");
			setTD($tr, ROW.US_VOLUME, "us_volume", "right");
			setTD($tr, ROW.US_EFF, "us_eff", "right");
			setTD($tr, ROW.US_PRIMER, "us_primer", "");
			setTD($tr, ROW.US_RATIO, "us_ratio", "right");
			setTD($tr, ROW.US_MALTCAP, "us_maltcap", "right");
			setTD($tr, ROW.US_THERMAL, "us_thermal", "right");
			setTD($tr, ROW.US_HOPFORM, "us_hopform", "");
			setTD($tr, ROW.US_HYDROTEMP, "us_hydrotemp", "right");
			setTD($tr, ROW.US_MASHTYPE, "us_mashtype", "");
			setTD($tr, ROW.US_DATEMASK, "us_datemask", "");
			setTD($tr, ROW.US_POSTAL, "us_postal", "");
			setTD($tr, ROW.US_PRIVACY, "us_privacy", "right");
			setTD($tr, ROW.US_OFFSET, "us_offset", "right");
			setTD($tr, ROW.US_MODERATE, "us_moderate", "right");
			setTD($tr, ROW.US_TWEETBACK, "us_tweetback", "right");
			setTD($tr, ROW.US_ADDED, "us_added", "center");
			setTD($tr, ROW.US_VALIDATED, "us_validated", "center");
			setTD($tr, ROW.US_DLA, "us_dla", "center");

			return $tr;
		}
		updateDataBody = function(noResize) {
			noResize = noResize || false;
			$tabDataBody.trigger("update"); // UPDATE THE SORT
			if (!noResize) $.tablescroller.resizeControl($tabDataBody, true);
		}
		updateRowCnt = function(chg) {
			cntRows += chg;
			$("#cntRows").html(addS(cntRows.toString() + " users record", cntRows));
		}
		cbRemote = function(response) {
			if (!response.SUCCESS) {
				cbErrors(response);
			} else {
				with (document.frmEdit) {
					if (response.DATA.METHOD=="Insert") {
						var ROW = qryRows.DATA[qryRows.rowAdd];
						ROW.US_USID = response.DATA.US_USID;
						var $tr = $("<tr>").attr("id", "us" + ROW.US_USID);
						$tr.data("rowid", qryRows.rowAdd); // SET THE ROWID TO THE NEW User QRY POS
						setTD($tr, $newEdit.clone(), "icon");
						moveRowToTR($tr, ROW);
						$tabDataBody.find("tbody:first").append($tr);
						updateDataBody();
						updateRowCnt(1);
						showStatusWindow("Row Added");
						clearWinEdit();
					} else if (response.DATA.METHOD=="Update") {
						var $tr = $("#us"+response.DATA.US_USID);
						var rowid = $tr.data("rowid");
						var ROW = qryRows.DATA[rowid];
						moveRowToTR($tr, ROW);
						updateDataBody(true);
						showStatusWindow("Row Updated");
					} else if (response.DATA.METHOD=="Delete") {
						var $tr = $("#us"+response.DATA.US_USID).fadeOut(800,updateDataBody);
						updateRowCnt(-1);
						showStatusWindow("Row Deleted");
					}
				}
			}
		}
		validateForm = function(frm) {
			with (frm) {
				if (isEmpty(us_user, "User is required.")) return false;
				if (isEmpty(us_pwd, "Pwd is required.")) return false;
				if (!us_boilvol.onblur()) return false;
				if (!us_volume.onblur()) return false;
				if (!us_eff.onblur()) return false;
				if (!us_ratio.onblur()) return false;
				if (!us_maltcap.onblur()) return false;
				if (!us_thermal.onblur()) return false;
				if (!us_hydrotemp.onblur()) return false;
				if (isEmpty(us_privacy, "Privacy is required.")) return false;
				if (!us_privacy.onblur()) return false;
				if (isEmpty(us_offset, "Offset is required.")) return false;
				if (!us_offset.onblur()) return false;
				if (isEmpty(us_moderate, "Moderate is required.")) return false;
				if (!us_moderate.onblur()) return false;
				if (isEmpty(us_tweetback, "Tweetback is required.")) return false;
				if (!us_tweetback.onblur()) return false;
				if (!validateDate(us_added)) return false;
				if (!validateDate(us_validated)) return false;
				if (isEmpty(us_dla, "Dla is required.")) return false;
				if (!validateDate(us_dla)) return false;
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
	<div id="winEdit" title="users Maintenance" class="ui-dialog">
		<form id="frmEdit" name="frmEdit">
		<input type="hidden" id="us_usid" name="us_usid">
		<table id="tabEdit" class="datagrid" cellspacing="0" align="center">
			<tbody class="nobevel bih-grid-form">
				<tr>
					<td class="label required">User</td>
					<td><input type="text" name="us_user" id="us_user" maxlength="15" style="width: 140px" /></td>
				</tr>
				<tr>
					<td class="label">First</td>
					<td><input type="text" name="us_first" id="us_first" maxlength="15" style="width: 140px" /></td>
				</tr>
				<tr>
					<td class="label">Last</td>
					<td><input type="text" name="us_last" id="us_last" maxlength="15" style="width: 140px" /></td>
				</tr>
				<tr>
					<td class="label">Email</td>
					<td><input type="text" name="us_email" id="us_email" maxlength="50" style="width: 455px" /></td>
				</tr>
				<tr>
					<td class="label required">Pwd</td>
					<td><input type="text" name="us_pwd" id="us_pwd" maxlength="100" style="width: 700px" /></td>
				</tr>
				<tr>
					<td class="label">Vunits</td>
					<td><input type="text" name="us_vunits" id="us_vunits" maxlength="12" style="width: 115px" /></td>
				</tr>
				<tr>
					<td class="label">Viunits</td>
					<td><input type="text" name="us_viunits" id="us_viunits" maxlength="12" style="width: 115px" /></td>
				</tr>
				<tr>
					<td class="label">Munits</td>
					<td><input type="text" name="us_munits" id="us_munits" maxlength="12" style="width: 115px" /></td>
				</tr>
				<tr>
					<td class="label">Hunits</td>
					<td><input type="text" name="us_hunits" id="us_hunits" maxlength="12" style="width: 115px" /></td>
				</tr>
				<tr>
					<td class="label">Tunits</td>
					<td><input type="text" name="us_tunits" id="us_tunits" maxlength="10" style="width: 95px" /></td>
				</tr>
				<tr>
					<td class="label">Eunits</td>
					<td><input type="text" name="us_eunits" id="us_eunits" maxlength="6" style="width: 60px" /></td>
				</tr>
				<tr>
					<td class="label">Boilvol</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" id="us_boilvol" max="9999.99" min="0" style="width: 70px" /></td>
				</tr>
				<tr>
					<td class="label">Volume</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" id="us_volume" max="9999.99" min="0" style="width: 70px" /></td>
				</tr>
				<tr>
					<td class="label">Eff</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" id="us_eff" max="127" min="-127" style="width: 35px" /></td>
				</tr>
				<tr>
					<td class="label">Primer</td>
					<td><input type="text" name="us_primer" id="us_primer" maxlength="10" style="width: 95px" /></td>
				</tr>
				<tr>
					<td class="label">Ratio</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" id="us_ratio" max="99.99" min="0" style="width: 50px" /></td>
				</tr>
				<tr>
					<td class="label">Maltcap</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" id="us_maltcap" max=".99" min="0" style="width: 35px" /></td>
				</tr>
				<tr>
					<td class="label">Thermal</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" id="us_thermal" max="99.9" min="0" style="width: 45px" /></td>
				</tr>
				<tr>
					<td class="label">Hopform</td>
					<td><input type="text" name="us_hopform" id="us_hopform" maxlength="6" style="width: 60px" /></td>
				</tr>
				<tr>
					<td class="label">Hydrotemp</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" id="us_hydrotemp" max="99.9" min="0" style="width: 45px" /></td>
				</tr>
				<tr>
					<td class="label">Mashtype</td>
					<td><input type="text" name="us_mashtype" id="us_mashtype" maxlength="12" style="width: 115px" /></td>
				</tr>
				<tr>
					<td class="label">Datemask</td>
					<td><input type="text" name="us_datemask" id="us_datemask" maxlength="11" style="width: 105px" /></td>
				</tr>
				<tr>
					<td class="label">Postal</td>
					<td><input type="text" name="us_postal" id="us_postal" maxlength="15" style="width: 140px" /></td>
				</tr>
				<tr>
					<td class="label required">Privacy</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" id="us_privacy" max="256" min="0" style="width: 35px" /></td>
				</tr>
				<tr>
					<td class="label required">Offset</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" id="us_offset" max="127" min="-127" style="width: 35px" /></td>
				</tr>
				<tr>
					<td class="label required">Moderate</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" id="us_moderate" max="127" min="-127" style="width: 35px" /></td>
				</tr>
				<tr>
					<td class="label required">Tweetback</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" id="us_tweetback" max="127" min="-127" style="width: 35px" /></td>
				</tr>
				<tr>
					<td class="label">Added</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="date" id="us_added" /></td>
				</tr>
				<tr>
					<td class="label">Validated</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="date" id="us_validated" /></td>
				</tr>
				<tr>
					<td class="label required">Dla</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="date" id="us_dla" /></td>
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
				<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" id="btnEdit" src="ui-icon-pencil" class="ui-button-icon-tiny" onclick="editRecord(this)" title="Edit"/>
			</span>
		</div>
		</form>
	</div>
	</cfoutput>
</cfif>

