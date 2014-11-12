<cfset cudAccess = true />
<cfset qryRows = APPLICATION.CFC.Factory.get("Hops").QueryHops() />
<script language="javascript" type="text/javascript">
	$(document).ready(
		function() {
			$tabDataBody = $("#tabData").tablescroller({
				sort: true,
				height: 640,
				print: false,
				borderWidth: 1,
				borderColor: "#979F97"
			});
			if (window["setupWinEdit"]) setupWinEdit();
		}
	);
</script>
<cfoutput>
<div style="margin: 5px 10px 5px 0; padding: 2px;">
	Displaying <span id="cntRows">#udfAddSWithCnt("Hop record", qryRows.RecordCount)#</span>.
</div>
</cfoutput>
<table id="tabData" class="datagrid" cellspacing="0">
	<caption>Hops</caption>
	<thead>
		<tr>
			<cfif cudAccess><th class="icon"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" id="btnAdd" src="ui-icon-circle-plus" onclick="addRecord(this)" title="Add"/></th></cfif>
			<th class="hp_hop">Hop</th>
			<th class="hp_grown">Grown</th>
			<th class="hp_aalow {sorter: 'digit'}">&laquo;Aa</th>
			<th class="hp_aahigh {sorter: 'digit'}">Aa&raquo;</th>
			<th class="hp_bitter {sorter: 'digit'}">Bit</th>
			<th class="hp_aroma {sorter: 'digit'}">Aro</th>
			<th class="hp_dry {sorter: 'digit'}">Dry</th>
			<th class="hp_url">Url</th>
			<th class="hp_profile {sorter: false}">Profile</th>
			<th class="hp_dla {sorter: 'bihDate'}">DLA</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="qryRows">
			<tr class="top" id="hp#hp_hpid#" data-rowid="#CurrentRow-1#">
				<cfif cudAccess><td class="icon"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pencil" onclick="editRecord(this)" title="Edit"/></td></cfif>
				<td class="hp_hop">#hp_hop#</td>
				<td class="hp_grown"><img src="images/trans.gif" class="flagSM flag#udfNoSpaces(hp_grown)#" /></td>
				<td class="hp_aalow right">#hp_aalow#</td>
				<td class="hp_aahigh right">#hp_aahigh#</td>
				<td class="hp_bitter center"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="displaycheck" value="#hp_bitter#"/></td>
				<td class="hp_aroma center"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="displaycheck" value="#hp_aroma#"/></td>
				<td class="hp_dry center"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="displaycheck" value="#hp_dry#"/></td>
				<td class="hp_url"><cfif isValid("url", hp_url)><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiIcon" src="bih-icon-popout" onclick="popOut('#hp_url#')"/><cfelse><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiIcon" src="bih-icon-question" onclick="popOut('http://www.google.com/search?q=#hp_hop#+#hp_grown#')"/></cfif></td>
				<td class="hp_profile"><div class="infochop">#left(hp_profile,60)#</div></td>
				<td class="hp_dla center">#udfUserDateFormat(hp_dla)#</td>
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
				$winEdit.dialog("option", "title", "Add Hops");
			} else {
				$winEdit.dialog("option", "title", "Edit Hops");
				$("#spanDelete").show();
			}
			$winEdit.dialog("open");
		}
		clearWinEdit = function() {
			with (document.frmEdit) {
				reset();
				hp_hpid.value = "0";
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
			if (frm.hp_hpid.value=="0") {
				qryRows.rowAdd = queryAddRow(qryRows); // ADDS EMPTY ROW, SAVE NEW ROW POS FOR LATER USE
				var ROW = qryRows.DATA[qryRows.rowAdd];
			} else {
				var ROW = qryRows.DATA[qryRows.rowEdit];
			}
			loadFormToRow(frm, ROW);
			remoteCall("hops.Process", ROW, cbRemote);
			$winEdit.dialog("close");
		}
		deleteRecord = function(btn) {
			var ROW = qryRows.DATA[qryRows.rowEdit];
			if (!confirm("Are you sure you want to delete this record?")) return false;
			remoteCall("hops.Process", {kill: 1, HP_HPID: ROW.HP_HPID}, cbRemote);
			$winEdit.dialog("close");
		}
		moveRowToTR = function($tr, ROW) {
			setTD($tr, ROW.HP_HOP, "hp_hop", "");
			setTD($tr, getFlagImg(ROW.HP_GROWN), "hp_grown", "");
			setTD($tr, ROW.HP_AALOW, "hp_aalow", "right");
			setTD($tr, ROW.HP_AAHIGH, "hp_aahigh", "right");
			setTD($tr, getCheckImg(ROW.HP_DRY), "hp_dry", "center");
			setTD($tr, getCheckImg(ROW.HP_AROMA), "hp_aroma", "center");
			setTD($tr, getCheckImg(ROW.HP_BITTER), "hp_bitter", "center");
			setTD($tr, getPopOutImg(ROW.HP_URL), "hp_url", "");
			setTD($tr, $("<div class=infochop>").html(ROW.HP_PROFILE), "hp_profile", "");
			setTD($tr, jsDateFormat(new Date(ROW.HP_DLA)), "hp_dla", "center");
			return $tr;
		}
		updateDataBody = function(noResize) {
			noResize = noResize || false;
			$tabDataBody.trigger("update"); // UPDATE THE SORT
			if (!noResize) $.tablescroller.resizeControl($tabDataBody, true);
		}
		updateRowCnt = function(chg) {
			cntRows += chg;
			$("#cntRows").html(addS(cntRows.toString() + " Hops record", cntRows));
		}
		cbRemote = function(response) {
			if (!response.SUCCESS) {
				cbErrors(response);
			} else {
				with (document.frmEdit) {
					if (response.DATA.METHOD=="Insert") {
						var ROW = qryRows.DATA[qryRows.rowAdd];
						ROW.HP_HPID = response.DATA.HP_HPID;
						var $tr = $("<tr>").attr("id", "hp" + ROW.HP_HPID);
						$tr.data("rowid", qryRows.rowAdd); // SET THE ROWID TO THE NEW User QRY POS
						setTD($tr, $newEdit.clone(), "icon");
						moveRowToTR($tr, ROW);
						$tabDataBody.find("tbody:first").append($tr);
						updateDataBody();
						updateRowCnt(1);
						showStatusWindow("Row Added");
						clearWinEdit();
					} else if (response.DATA.METHOD=="Update") {
						var $tr = $("#hp"+response.DATA.HP_HPID);
						var rowid = $tr.data("rowid");
						var ROW = qryRows.DATA[rowid];
						moveRowToTR($tr, ROW);
						updateDataBody(true);
						showStatusWindow("Row Updated");
					} else if (response.DATA.METHOD=="Delete") {
						var $tr = $("#hp"+response.DATA.HP_HPID).fadeOut(800,updateDataBody);
						updateRowCnt(-1);
						showStatusWindow("Row Deleted");
					}
				}
			}
		}
		validateForm = function(frm) {
			with (frm) {
				if (isEmpty(hp_hop, "Hop is required.")) return false;
				if (isEmpty(hp_grown, "Grown is required.")) return false;
				if (isEmpty(hp_aalow, "Aa Low is required.")) return false;
				if (!hp_aalow.onblur()) return false;
				if (isEmpty(hp_aahigh, "Aa High is required.")) return false;
				if (!hp_aahigh.onblur()) return false;
				if (!hp_hsi.onblur()) return false;
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
	<div id="winEdit" title="Hops Maintenance" class="ui-dialog">
		<form id="frmEdit" name="frmEdit">
		<input type="hidden" id="hp_hpid" name="hp_hpid">
		<table id="tabEdit" class="datagrid" cellspacing="0" align="center">
			<tbody class="nobevel bih-grid-form">
				<tr>
					<td class="label">Dla</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="date" name="hp_dla" disabled="disabled" value="#udfUserDateFormat(Now())#" /></td>
				</tr>
				<tr>
					<td class="label required">Hop</td>
					<td><input type="text" name="hp_hop" id="hp_hop" maxlength="25" style="width: 230px" required="required" /></td>
				</tr>
				<tr>
					<td class="label required">Grown</td>
					<td><input type="text" name="hp_grown" id="hp_grown" maxlength="15" style="width: 140px" required="required" /></td>
				</tr>
				<tr>
					<td class="label required">Aa Low</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="hp_aalow" max="29.9" min="0" style="width: 45px" required="required" /></td>
				</tr>
				<tr>
					<td class="label required">Aa High</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="hp_aahigh" max="29.9" min="0" style="width: 45px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Bitter</td>
					<td><input type="checkbox" name="hp_bitter" id="hp_bitter" value="1" checked /></td>
				</tr>
				<tr>
					<td class="label">Aroma</td>
					<td><input type="checkbox" name="hp_aroma" id="hp_aroma" value="1" checked /></td>
				</tr>
				<tr>
					<td class="label">Dry</td>
					<td><input type="checkbox" name="hp_dry" id="hp_dry" value="1" /></td>
				</tr>
				<tr>
					<td class="label">Storage Index</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="hp_hsi" max="99.9" min="0" style="width: 45px" value="0" /></td>
				</tr>
				<tr>
					<td class="label">Profile</td>
					<td><input type="text" name="hp_profile" id="hp_profile" maxlength="100" style="width: 700px" /></td>
				</tr>
				<tr>
					<td class="label">Use</td>
					<td><input type="text" name="hp_use" id="hp_use" maxlength="100" style="width: 700px" /></td>
				</tr>
				<tr>
					<td class="label">Example</td>
					<td><input type="text" name="hp_example" id="hp_example" maxlength="100" style="width: 700px" /></td>
				</tr>
				<tr>
					<td class="label">Substitute</td>
					<td><input type="text" name="hp_sub" id="hp_sub" maxlength="100" style="width: 700px" /></td>
				</tr>
				<tr>
					<td class="label">Url</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="url" style="width: 700px" maxlen="150" name="hp_url" /></td>
				</tr>
				<tr>
					<td class="label">Info</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="10" width="700px" maxlen="1000" name="hp_info" /></td>
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
