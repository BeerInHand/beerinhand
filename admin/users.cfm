<cfset cudAccess = isUserInRole("siteadmin") />
<cfset cudAccess = true />
<cfset qryRows = APPLICATION.CFC.Factory.Get("users").QueryUsers() />
<script language="javascript" type="text/javascript">
	$(document).ready(
		function() {
			$tabDataBody = $("#tabData").tablescroller({
				sort: true,
				print: false,
				borderWidth: 1
			});
			if (window["setupWinEdit"]) setupWinEdit();
			$us_disptunits = $("#us_disptunits");
			$us_dispvunits = $("#us_dispvunits");
			$us_dispvunits2 = $("#us_dispvunits2");
			$us_ratiounits = $("#us_ratiounits");
			$us_eff = spinnerBind($("#us_eff"), incPct, spinnerInc);
			$us_hunits = popUnitSelect("#us_hunits", GramsConvert);
			$us_hydrotemp = spinnerBindTemp($("#us_hydrotemp"), bihDefaults.TUNITS, spinnerInc);
			$us_munits = popUnitSelect("#us_munits", GramsConvert);
			$us_primer = popPrimer("#us_primer");
			$us_viunits = popUnitSelect("#us_viunits", LitersConvert);
			$us_volume = spinnerBind($("#us_volume"), incAmt, spinnerInc);
			$us_boilvol = spinnerBind($("#us_boilvol"), incAmt, spinnerInc);
			$us_vunits = popUnitSelect("#us_vunits", LitersConvert);
			$us_maltcap = $("#us_maltcap").bind("keydown change",			{	inc: 0.001,		maxVal: 1.0,		minInc: 0.001,	maxInc: 0.01,	decimals: 3, 	minVal: 0},			spinnerInc);
			$us_ratio = $("#us_ratio").bind("keydown change",				{	inc: 0.01,		maxVal: 5.0,		minInc: 0.01,	maxInc: 0.1,	decimals: 2, 	minVal: 0},			spinnerInc);

		}
	);
</script>
<cfoutput>
<div style="margin: 5px 10px 5px 0; padding: 2px;">
	Displaying <span id="cntRows">#udfAddSWithCnt("user record", qryRows.RecordCount)#</span>.
</div>
</cfoutput>
<table id="tabData" class="datagrid" cellspacing="0">
	<caption>Users</caption>
	<thead>
		<tr>
			<cfif cudAccess><th class="icon"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" id="btnAdd" src="ui-icon-circle-plus" onclick="addRecord(this)" title="Add"/></th></cfif>
			<th class="us_user">User</th>
			<th class="us_first">First</th>
			<th class="us_last">Last</th>
			<th class="us_email">Email</th>
			<th class="us_added {sorter: 'bihDate'}">Added</th>
			<th class="us_validated {sorter: 'bihDate'}">Validated</th>
			<th class="us_dla {sorter: 'bihDate'}">DLA</th>
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
				$("#us_user").removeAttr("readonly");
				$winEdit.dialog("option", "title", "Add User");
			} else {
				$winEdit.dialog("option", "title", "Edit User");
				$("#us_user").attr("readonly","readonly");
				$("#spanDelete").show();
			}
			$winEdit.dialog("open");
		}
		clearWinEdit = function() {
			with (document.frmEdit) {
				reset();
				us_usid.value = "0";
				$us_vunits.attr("oldvalue", bihDefaults.VUNITS);
				$us_viunits.attr("oldvalue", bihDefaults.VIUNITS);
				$us_munits.attr("oldvalue", bihDefaults.MUNITS);
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
			remoteCall("users.GetAvatar", {US_USID: ROW.US_USID}, cbRemote);
			$us_vunits.attr("oldvalue", ROW.US_VUNITS);
			$us_viunits.attr("oldvalue", ROW.US_VIUNITS);
			$us_munits.attr("oldvalue", ROW.US_MUNITS);
			$us_disptunits.html(ROW.US_TUNITS);
			$us_dispvunits.html(ROW.US_VUNITS);
			$us_dispvunits2.html(ROW.US_VUNITS);
			$us_ratiounits.html(ROW.US_VIUNITS + "/" + ROW.US_MUNITS);
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
			setTD($tr, jsDateFormat(new Date(ROW.US_ADDED)), "us_added", "center");
			setTD($tr, jsDateFormat(new Date(ROW.US_VALIDATED)), "us_validated", "center");
			setTD($tr, jsDateFormat(new Date(ROW.US_DLA)), "us_dla", "center");
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
				frm = document.frmEdit;
				if (response.DATA.METHOD=="Insert") {
					var ROW = qryRows.DATA[qryRows.rowAdd];
					ROW.US_USID = response.DATA.US_USID;
					var $tr = $("<tr>").attr("id", "us" + ROW.US_USID);
					$tr.data("rowid", qryRows.rowAdd); // SET THE ROWID TO THE NEW User QRY POS
					setTD($tr, $newEdit.clone(), "icon");
					ROW.US_ADDED = new Date();
					ROW.US_DLA = new Date();
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
					ROW.US_DLA = new Date();
					moveRowToTR($tr, ROW);
					updateDataBody(true);
					showStatusWindow("Row Updated");
				} else if (response.DATA.METHOD=="Delete") {
					var $tr = $("#us"+response.DATA.US_USID).fadeOut(800,updateDataBody);
					updateRowCnt(-1);
					showStatusWindow("Row Deleted");
				} else if (response.DATA.METHOD=="Validate") {
					showStatusWindow("User Validated");
					var $tr = $("#us"+response.DATA.US_USID);
					var rowid = $tr.data("rowid");
					var ROW = qryRows.DATA[rowid];
					ROW.US_VALIDATED = jsDateFormat(new Date());
					frm.us_validated.value = ROW.US_VALIDATED;
					setTD($tr, ROW.US_VALIDATED, "us_validated", "center");
				} else if (response.DATA.METHOD=="Avatar") {
					$("#imgAvatar").attr("src", response.DATA.AVATAR);
				}
			}
		}
		validateForm = function(frm) {
			var frm = document.frmEdit;
			if (isEmpty(frm.us_first, "First Name is required.")) return false;
			if (isEmpty(frm.us_last, "Last Name is required.")) return false;
			if (isEmpty(frm.us_email, "Email is required.")) return false;
			if (isNotEmail(frm.us_email, "Email is invalid.")) return false;
			return true;;
		}
		validateUser = function(btn) {
			var ROW = qryRows.DATA[qryRows.rowEdit];
			if (!isEmpty(ROW.US_VALIDATED)) return showStatusWindow("Already Verified...");
			if (!confirm("Mark this user as validated?")) return false;
			remoteCall("users.Process", {validate: 1, US_USID: ROW.US_USID}, cbRemote);
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
	<div id="winEdit" title="User Maintenance" class="ui-dialog">
		<img id="imgAvatar" style="float:right; margin: 2px;">
		<form id="frmEdit" name="frmEdit">
		<input type="hidden" id="us_usid" name="us_usid">
		<table id="tabEdit" class="datagrid tabOptions" cellspacing="0" align="center">
			<tbody class="nobevel bih-grid-form">
				<tr>
					<td class="label required">User</td>
					<td><input type="text" name="us_user" id="us_user" maxlength="15" class="brewer" /></td>
				</tr>
				<tr>
					<td class="label">First</td>
					<td><input type="text" name="us_first" id="us_first" maxlength="15" class="brewer" /></td>
				</tr>
				<tr>
					<td class="label">Last</td>
					<td><input type="text" name="us_last" id="us_last" maxlength="15" class="brewer" /></td>
				</tr>
				<tr>
					<td class="label">Added</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="date" id="us_added" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="label">Validated</td>
					<td>
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="date" id="us_validated" readonly="readonly" class="fleft" style="margin-right: 10px" />
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="fleft ui-button-icon-tiny" src="bih-icon-checkgreen" onclick="validateUser(this)" title="Validate User"/>
					</td>
				</tr>
				<tr>
					<td class="label required">DLA</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="date" id="us_dla" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="label">Email</td>
					<td><input type="email" name="us_email" id="us_email" maxlength="50" style="width: 350px" /></td>
				</tr>
				<tr>
					<td class="label">Volume Units</td>
					<td><select class="units" name="us_vunits" id="us_vunits" onchange="optsUnitsVolume(this)"></select></td>
				</tr>
				<tr>
					<td class="label">Infusion Units</td>
					<td><select class="units" name="us_viunits" id="us_viunits" onchange="optsUnitsInfusion()"></select></td>
				</tr>
				<tr>
					<td class="label">Malt Units</td>
					<td><select class="units" name="us_munits" id="us_munits" onchange="optsUnitsMash(this)"></select></td>
				</tr>
				<tr>
					<td class="label">Hop Units</td>
					<td><select class="units" name="us_hunits" id="us_hunits"></select></td>
				</tr>
				<tr>
					<td class="label">Temp Units</td>
					<td><button id="us_tunits" class="butRotateBig units" type="button" onclick="optsUnitsTemp(this)" value="F">&deg;F</button></td>
				</tr>
				<tr>
					<td class="label">Gravity Units</td>
					<td><button id="us_eunits" class="butRotateBig units" type="button" onclick="optsUnitsGravity(this)">SG</button></td>
				</tr>
				<tr>
					<td class="label">Volume</td>
					<td>
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" id="us_volume" max="9999.99" min="0" />
						<span id="us_dispvunits" class="dunits"></span>
					</td>
				</tr>
				<tr>
					<td class="label">Boil Volume</td>
					<td>
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" id="us_boilvol" max="9999.99" min="0" />
						<span id="us_dispvunits2" class="dunits"></span>
					</td>
				</tr>
				<tr>
					<td class="label">Mash Eff</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" id="us_eff" max="100" min="10" /></td>
				</tr>
				<tr>
					<td class="label">Primer</td>
					<td><select class="primer units" name="us_primer" id="us_primer"></select></td>
				</tr>
				<tr>
					<td class="label">Ratio</td>
					<td>
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" id="us_ratio" max="99.99" min="0" />
						<span id="us_ratiounits"></span>
					</td>
				</tr>
				<tr>
					<td class="label">Malt Cap</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" id="us_maltcap" max=".99" min="0" /></td>
				</tr>
				<tr>
					<td class="label">Mash Tun Thermal</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" id="us_thermal" max="99.9" min="0" /></td>
				</tr>
				<tr>
					<td class="label">Hop Form</td>
					<td><button id="us_hopform" type="button" class="butRotateBig units" onclick="rotateHopForm(this)">Pellet</button></td>
				</tr>
				<tr>
					<td class="label">Hydrotemp</td>
					<td>
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" id="us_hydrotemp" max="99.9" min="0" />
						<span id="us_disptunits" class="dunits"></span>
					</td>
				</tr>
				<tr>
					<td class="label required">Mash Type</td>
					<td><button id="us_mashtype" type="button" class="butRotateBig mashtype" onclick="rotateMashType(this)">All Grain</button></td>
				</tr>
				<tr>
					<td class="label required">Datemask</td>
					<td><select class="dunits" name="us_datemask" id="us_datemask"><option value="mm/dd/yyyy">mm/dd/yyyy</option><option value="dd-mmm-yyyy">dd-mmm-yyyy</option></select></td>
				</tr>
				<tr>
					<td class="label required">Postal Code</td>
					<td><input type="text" name="us_postal" id="us_postal" maxlength="15" /></td>
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
