<cfset cudAccess = true />
<cfset qryRows = APPLICATION.CFC.Factory.get("Grains").QueryGrains() />
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
			setupWinEdit();
		}
	);
</script>
<cfoutput>
<div style="margin: 5px 10px 5px 0; padding: 2px;">
	Displaying <span id="cntRows">#udfAddSWithCnt("Grains record", qryRows.RecordCount)#</span>.
</div>
</cfoutput>
<table id="tabData" class="datagrid" cellspacing="0">
	<caption>Grains</caption>
	<thead>
		<tr>
			<cfif cudAccess><th class="icon" width="18"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" id="btnAdd" src="ui-icon-circle-plus" onclick="addRecord(this)" title="Add"/></th></cfif>
			<th class="gr_type">Type</th>
			<th class="gr_maltster">Maltster</th>
			<th class="gr_country">Cnt</th>
			<th class="gr_cat">Cat</th>
			<th class="gr_sgc {sorter: 'digit'}">Sgc</th>
			<th class="gr_lvb {sorter: 'digit'}">Srm</th>
			<th class="gr_mash">mash</th>
			<th class="gr_lintner {sorter: 'digit'}">Dp</th>
			<th class="gr_url">Url</th>
			<th class="gr_info {sorter: false}">Info</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="qryRows">
			<tr class="top" id="gr#gr_grid#" data-rowid="#CurrentRow-1#">
				<cfif cudAccess><td class="icon"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pencil" onclick="editRecord(this)" title="Edit"/></td></cfif>
				<td class="gr_type">#gr_type#</td>
				<td class="gr_maltster">#gr_maltster#</td>
				<td class="gr_country"><img src="images/trans.gif" class="flagSM flag#udfNoSpaces(gr_country)#" /></td>
				<td class="gr_cat">#gr_cat#</td>
				<td class="gr_sgc">#gr_sgc#</td>
				<td class="gr_lvb">#gr_lvb#</td>
				<td class="gr_mash center"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="displaycheck" value="#gr_mash#"/></td>
				<td class="gr_lintner">#gr_lintner#</td>
				<td class="gr_url"><cfif isValid("url", gr_url)><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiIcon" src="bih-icon-popout" onclick="popOut('#gr_url#')"/><cfelse><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiIcon" src="bih-icon-question" onclick="popOut('http://www.google.com/search?q=#gr_maltster#+#gr_type#')"/></cfif></td>
				<td class="gr_info"><div class="infochop">#left(gr_info,25)#</div></td>
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
		calcSGC = function(btn) {
			var frm = document.frmEdit;
			var CGDB = parseFloat(frm.gr_cgdb.value) || 0;
			var FGDB = parseFloat(frm.gr_fgdb.value) || 0;
			var MC = parseFloat(frm.gr_mc.value) || 0;
			var FCDiff = parseFloat(frm.gr_fcdif.value) ||0;
			var SGC = sgcFromPctExtract(CGDB, MC, FGDB, FCDiff).toFixed(3);
			if (confirm("Use SGC = " + SGC + "?")) frm.gr_sgc.value = SGC;
		}
		hideWinEdit = function() {
			$winEdit.dialog("close");
		}
		showWinEdit = function(mode) {
			$("#btnSave span.ui-button-text").html(mode);
			if (mode=="Add") {
				$("#spanDelete").hide();
				$winEdit.dialog("option", "title", "Add Grains");
				$("#btnCopy").hide();
			} else {
				$winEdit.dialog("option", "title", "Edit Grains");
				$("#spanDelete").show();
				$("#btnCopy").show();
			}
			$winEdit.dialog("open");
		}
		clearWinEdit = function() {
			with (document.frmEdit) {
				reset();
				gr_grid.value = "0";
			}
		}
		copyRecord = function() {
			$winEdit.dialog("option", "title", "Add Grains");
			$("#btnCopy").hide();
			document.frmEdit.gr_grid.value=0;
			document.frmEdit.gr_url.value="";
			document.frmEdit.gr_info.value="";
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
			if (frm.gr_grid.value=="0") {
				qryRows.rowAdd = queryAddRow(qryRows); // ADDS EMPTY ROW, SAVE NEW ROW POS FOR LATER USE
				var ROW = qryRows.DATA[qryRows.rowAdd];
			} else {
				var ROW = qryRows.DATA[qryRows.rowEdit];
			}
			loadFormToRow(frm, ROW);
			remoteCall("grains.Process", ROW, cbRemote);
			$winEdit.dialog("close");
		}
		deleteRecord = function(btn) {
			var ROW = qryRows.DATA[qryRows.rowEdit];
			if (!confirm("Are you sure you want to delete this record?")) return false;
			remoteCall("grains.Process", {kill: 1, GR_GRID: ROW.GR_GRID}, cbRemote);
			$winEdit.dialog("close");
		}
		moveRowToTR = function($tr, ROW) {
			setTD($tr, ROW.GR_TYPE, "gr_type", "");
			setTD($tr, ROW.GR_MALTSTER, "gr_maltster", "");
			setTD($tr, getFlagImg(ROW.GR_COUNTRY), "gr_country", "");
			setTD($tr, ROW.GR_SGC, "gr_sgc", "right");
			setTD($tr, ROW.GR_LVB, "gr_lvb", "right");
			setTD($tr, getCheckImg(ROW.GR_MASH), "gr_mash", "center");
			setTD($tr, ROW.GR_LINTNER, "gr_lintner", "right");
			setTD($tr, getPopOutImg(ROW.GR_URL), "gr_url", "");
			setTD($tr, ROW.GR_CAT, "gr_cat", "");
			setTD($tr, $("<div class=infochop>").html(ROW.GR_INFO), "gr_info", "");
			return $tr;
		}
		updateDataBody = function(noResize) {
			noResize = noResize || false;
			$tabDataBody.trigger("update"); // UPDATE THE SORT
			if (!noResize) $.tablescroller.resizeControl($tabDataBody, true);
		}
		updateRowCnt = function(chg) {
			cntRows += chg;
			$("#cntRows").html(addS(cntRows.toString() + " Grains record", cntRows));
		}
		cbRemote = function(response) {
			var ROW;
			var $tr;
			if (!response.SUCCESS) {
				cbErrors(response);
			} else {
				with (document.frmEdit) {
					if (response.DATA.METHOD=="Insert") {
						ROW = qryRows.DATA[qryRows.rowAdd];
						ROW.GR_GRID = response.DATA.GR_GRID;
						$tr = $("<tr>").attr("id", "gr" + ROW.GR_GRID);
						$tr.data("rowid", qryRows.rowAdd); // SET THE ROWID TO THE NEW User QRY POS
						setTD($tr, $newEdit.clone(), "icon");
						moveRowToTR($tr, ROW);
						$tabDataBody.find("tbody:first").append($tr);
						updateDataBody();
						updateRowCnt(1);
						showStatusWindow("Row Added");
						clearWinEdit();
					} else if (response.DATA.METHOD=="Update") {
						$tr = $("#gr"+response.DATA.GR_GRID);
						ROW = qryRows.DATA[$tr.data("rowid")];
						moveRowToTR($tr, ROW);
						updateDataBody(true);
						showStatusWindow("Row Updated");
					} else if (response.DATA.METHOD=="Delete") {
						$tr = $("#gr"+response.DATA.GR_GRID).fadeOut(800,updateDataBody);
						updateRowCnt(-1);
						showStatusWindow("Row Deleted");
					}
				}
			}
		}
		validateForm = function(frm) {
			with (frm) {
				if (isEmpty(gr_type, "Malt/Fermentable is required.")) return false;
				if (isEmpty(gr_maltster, "Maltster is required.")) return false;
				if (isEmpty(gr_country, "Country is required.")) return false;
				if (isEmpty(gr_cat, "Category is required.")) return false;
				if (isEmpty(gr_sgc, "Extract Potential (SGC) is required.")) return false;
				if (isEmpty(gr_lvb, "Color (SRM) is required.")) return false;
				if (!gr_lvb.onblur()) return false;
				if (!gr_sgc.onblur()) return false;
				if (!gr_lintner.onblur()) return false;
				if (!gr_mc.onblur()) return false;
				if (!gr_fgdb.onblur()) return false;
				if (!gr_cgdb.onblur()) return false;
				if (!gr_fcdif.onblur()) return false;
				if (!gr_protein.onblur()) return false;
				if (!validateDate(gr_dla)) return false;
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
	<div id="winEdit" title="Grains Maintenance" class="ui-dialog">
		<form id="frmEdit" name="frmEdit">
		<input type="hidden" id="gr_grid" name="gr_grid">
		<table id="tabEdit" class="datagrid" cellspacing="0" align="center">
			<tbody class="nobevel bih-grid-form">
				<tr>
					<td class="label">dla</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="date" disabled="disabled" name="gr_dla" value="#udfUserDateFormat(Now())#" /></td>
				</tr>
				<tr>
					<td class="label required">Malt/Fermentable</td>
					<td><input type="text" name="gr_type" id="gr_type" maxlength="25" style="width: 225px" required="required" /></td>
				</tr>
				<tr>
					<td class="label required">Maltster</td>
					<td><input type="text" name="gr_maltster" id="gr_maltster" maxlength="25" style="width: 225px" required="required" /></td>
				</tr>
				<tr>
					<td class="label required">Country</td>
					<td><input type="text" name="gr_country" id="gr_country" maxlength="15" style="width: 150px" required="required" /></td>
				</tr>
				<tr>
					<td class="label required">Category</td>
					<td><input type="text" name="gr_cat" id="gr_cat" maxlength="15" style="width: 150px" required="required" /></td>
				</tr>
				<tr>
					<td class="label required">Extract Potential (SGC)</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_sgc" max="9.999" min="0" style="width: 50px" required="required" /></td>
				</tr>
				<tr>
					<td class="label required">Color (SRM)</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_lvb" max="999.9" min="0" style="width: 50px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Requires Mashing</td>
					<td><input type="checkbox" name="gr_mash" id="gr_mash" value="1" checked /></td>
				</tr>
				<tr>
					<td class="label">Diastatic Power</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" name="gr_lintner" max="256" min="0" style="width: 35px" /> Lintner</td>
				</tr>
				<tr>
					<td class="label">Moisture Content</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_mc" max="9.999" min="0" style="width: 50px" /></td>
				</tr>
				<tr>
					<td class="label">Dry Basis Fine Grind</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_fgdb" max="99.9" min="0" style="width: 50px" /></td>
				</tr>
				<tr>
					<td class="label">Dry Basis Coarse Grind</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_cgdb" max="99.9" min="0" style="width: 50px" /></td>
				</tr>
				<tr>
					<td class="label">Fine/Coarse Difference</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_fcdif" max="99.9" min="0" style="width: 50px" /></td>
				</tr>
				<tr>
					<td class="label">Protein</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_protein" max="99.9" min="0" style="width: 50px" /></td>
				</tr>
				<tr>
					<td class="label">Data Sheet URL</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="url" style="width: 700px" maxlen="150" name="gr_url" id="gr_url" /></td>
				</tr>
				<tr>
					<td class="label">Information</td>
					<td><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="10" width="700px" maxlen="1000" name="gr_info" /></td>
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
				<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" id="btnSave" src="ui-icon-circle-check" onclick="saveRecord(this)" text="Save" />
				<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" id="btnCancel" src="ui-icon-circle-close" onclick="hideWinEdit(this)" text="Cancel" />
				<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" id="btnCalcSGC" src="ui-icon-calculator" onclick="calcSGC(this)" text="Calc SGC" />
				<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" id="btnCopy" src="ui-icon-copy" onclick="copyRecord()" text="Copy" />
				<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" id="btnEdit" src="ui-icon-pencil" onclick="editRecord(this)" title="Edit"  class="ui-button-icon-tiny" />
			</span>
		</div>
		</form>
	</div>
	</cfoutput>
</cfif>