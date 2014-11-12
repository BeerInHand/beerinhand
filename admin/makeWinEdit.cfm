<cfparam name="FORM.tabname" default="">

<cfquery datasource="bih" name="qryTabs">
	SELECT table_name
	  FROM information_schema.tables
	 WHERE table_schema='bih'
	 ORDER BY table_name
</cfquery>

<cfform method="post">
<table class="datagrid" cellspacing="0">
	<caption>Select a Table</caption>
	<tbody>
		<tr><td>Table Name</td><td><cfselect name="tabname" value="table_name" query="qryTabs" size="1" selected="#FORM.tabname#"></cfselect></td></tr>
	</tbody>
	<tfoot>
		<tr><th colspan="2" class="buttons"><input type="submit"></th></tr>
	</tfoot>
</table>
</cfform>

<cfif FORM.tabname is not "">
	<br/>
	<cfparam name="FORM.tabnick" default="#FORM.tabname#">
	<cfparam name="FORM.tababbr" default="#LCASE(LEFT(FORM.tabname,2))#">
	<cfparam name="FORM.charwide" default="9">
	<cfform method="post">
		<input type="hidden" name="resubmit" />
		<cfoutput>
		<table class="datagrid" cellspacing="0">
		<caption>Adjust Table Defaults</caption>
		<tbody>
			<tr class="top">
				<td>
					<table width="300" class="datagrid" cellspacing="0">
						<tr><td>Table Name</td><td><input type="text" readonly name="tabname" value="#FORM.tabname#" /></td></tr>
						<tr><td>Table Nick Name</td><td><input type="text" name="tabnick" value="#FORM.tabnick#" /></td></tr>
						<tr><td>Table Abbr</td><td><input type="text" name="tababbr" value="#FORM.tababbr#" size="6" /></td></tr>
						<tr><td>Input Char Width</td><td><input type="text" name="charwide" value="#FORM.charwide#" size="6" /></td></tr>
					</table>
				</td>
				<td>
		</cfoutput>
		<cfquery datasource="bih" name="qry">
			SELECT *,
						CASE DATA_TYPE
							WHEN "bigint"		THEN "numeric"
							WHEN "bit"			THEN "boolean"
							WHEN "char"			THEN "string"
							WHEN "date"			THEN "string"
							WHEN "datetime"	THEN "string"
							WHEN "decimal"		THEN "numeric"
							WHEN "double"		THEN "numeric"
							WHEN "float"		THEN "numeric"
							WHEN "int"			THEN "numeric"
							WHEN "longtext"	THEN "string"
							WHEN "mediumint"	THEN "numeric"
							WHEN "mediumtext"	THEN "string"
							WHEN "smallint"	THEN "numeric"
							WHEN "text"			THEN "string"
							WHEN "timestamp"	THEN "string"
							WHEN "tinyint"		THEN "numeric"
							WHEN "tinytext"	THEN "string"
							WHEN "varchar"		THEN "string"
							ELSE CONCAT("UNKNOWN_", DATA_TYPE)
						END AS ARG_TYPE,
						CASE DATA_TYPE
							WHEN "bigint"		THEN "int"
							WHEN "bit"			THEN "bit"
							WHEN "char"			THEN "char"
							WHEN "date"			THEN "date"
							WHEN "double"		THEN "float"
							WHEN "decimal"		THEN "float"
							WHEN "float"		THEN "float"
							WHEN "int"			THEN "int"
							WHEN "mediumint"	THEN "int"
							WHEN "smallint"	THEN "int"
							WHEN "datetime"	THEN "date"
							WHEN "time"			THEN "time"
							WHEN "timestamp"	THEN "date"
							WHEN "tinyint"		THEN IF(COLUMN_TYPE="tinyint(1) unsigned","boolean","int")
							WHEN "longtext"	THEN "char"
							WHEN "mediumtext"	THEN "char"
							WHEN "text"			THEN "char"
							WHEN "tinytext"	THEN "char"
							WHEN "varchar"		THEN "char"
							ELSE CONCAT("UNKNOWN_", DATA_TYPE)
						END AS ValidationType,
						IF(COLUMN_KEY<>"" AND DATA_TYPE='int', 'KEY', '') AS SEARCH_KEY,
						IF(IS_NULLABLE="YES", "false", "true") AS ARG_REQUIRED
			  FROM information_schema.COLUMNS
			 WHERE TABLE_SCHEMA='bih'
				AND TABLE_NAME='#FORM.tabname#'
			 ORDER BY ORDINAL_POSITION
		</cfquery>
		<cfset CR = chr(13) & chr(10) />
		<cfset CF = "cf" />
		<cfset outSetTD = "" />
		<cfset outValid = "" />
		<cfset outTH = "" />
		<cfset outTD = "" />
		<cfset outFormRow = "" / >
		<cfset outFormHidden = "" / >
		<cfset outFKSelect = "" />
		<cfset Identity = "NOPK" />
		<cfset ucIdentity = "NOPK" />
		<!--- <cfset ShowFK = (ListLen(ValueList(qry.foreign_key)) neq 0) /> --->
		<cfset ShowFK = false />
		<cfset ShowRange = true />
		<table class="datagrid" cellspacing="0" width="625">
			<thead>
				<tr>
					<th>Type</th>
					<th>Column</th>
					<th>Label</th>
					<th>Show<br/>Tbl</th>
					<th>Form<br/>Edit</th>
					<th>Req</th>
					<cfif ShowFK>
						<th>Make FKey Select</th>
					</cfif>
					<cfif ShowRange>
						<th>Value Range</th>
					</cfif>
				</tr>
			</thead>
			<tbody>
		<cfoutput query="qry">
			<cfif not IsDefined("FORM.resubmit")>
				<cfparam name="FORM.DISP#CurrentRow#" default="1"/>
				<cfparam name="FORM.EDIT#CurrentRow#" default="1"/>
				<cfif ARG_REQUIRED>
					<cfparam name="FORM.REQ#CurrentRow#" default="1"/>
				</cfif>
			</cfif>
			<cfif IsDefined("FORM.BP#CurrentRow#")>
				<cfset ColTitle = FORM["BP#CurrentRow#"] />
			<cfelse>
				<cfset ColTitle = ListLast(COLUMN_NAME,"_") />
				<cfset ColTitle = UCase(Left(ColTitle, 1)) & LCase(Right(ColTitle, Len(ColTitle)-1)) />
			</cfif>
			<cfset ucCOLUMN_NAME = ucase(COLUMN_NAME) />
			<cfset lcCOLUMN_NAME = lcase(COLUMN_NAME) />
			<cfset fldDisplay = IsDefined("FORM.DISP#CurrentRow#") />
			<cfset fldEdit = IsDefined("FORM.EDIT#CurrentRow#") />
			<cfset fldReq = IsDefined("FORM.REQ#CurrentRow#") />
			<cfset fldFKey = IsDefined("FORM.FKEY#CurrentRow#") />
			<cfset fldRange = IsDefined("FORM.MAX#CurrentRow#") />
			<cfif fldRange>
				<cfset MinVal = FORM["MIN#CurrentRow#"] />
				<cfset MaxVal = FORM["MAX#CurrentRow#"] />
			<cfelse>
				<cfset MinVal = 0 />
				<cfset MaxVal = 0 />
			</cfif>
			<!--- CREATE INVOKE FOR FOREIGN KEY SELECT --->
			<cfif fldEdit and fldFkey>
				<cfset outFKSelect = outFKSelect & '<#CF#invoke component="##APPLICATION.MAP.CFC##.data.#FKeyTable#" method="CreateSelect" returnvariable="select_#FKeyTable#">#CR#~ <#CF#invokeargument name="selectName" value="#lcCOLUMN_NAME#" />#CR#</#CF#invoke>#CR#' />
			</cfif>
			<cfif EXTRA eq "auto_increment">
				<cfset Identity = lcCOLUMN_NAME />
				<cfset ucIdentity = ucCOLUMN_NAME />
				<cfset outFormHidden = '<input type="hidden" id="#Identity#" name="#Identity#" />' />
			<cfelse>
				<cfset required = "" />
				<cfif fldReq and fldEdit>
					<cfif fldFkey>
						<cfset outValid = outValid & '~ ~ ~ ~ if (isNotSelected(#lcCOLUMN_NAME#, "#ColTitle# is required.")) return false;#CR#' />
					<cfelse>
						<cfset outValid = outValid & '~ ~ ~ ~ if (isEmpty(#lcCOLUMN_NAME#, "#ColTitle# is required.")) return false;#CR#' />
					</cfif>
					<cfset required = " required" />
				</cfif>
				<cfif fldEdit>
					<cfset outFormRow = outFormRow & '~ ~ ~ ~ <tr>#CR#~ ~ ~ ~ ~ <td class="label#required#">#ColTitle#</td>#CR#~ ~ ~ ~ ~ <td>' />
				<cfelse>
					<cfset outFormHidden = outFormHidden & '<input type="hidden" id="#lcCOLUMN_NAME#" name="#lcCOLUMN_NAME#" />' />
				</cfif>
				<!--- TEXT FIELDS --->
				<cfif ValidationType eq "char">
					<cfif fldEdit>
						<cfif fldEdit and fldFkey>
							<cfset outFormRow = outFormRow & '##select_#FKeyTable###' />
						<cfelse>
							<cfif CHARACTER_MAXIMUM_LENGTH lt 128>
								<cfset width = MIN(700, int((CHARACTER_MAXIMUM_LENGTH+1) * FORM.charwide / 5) * 5) /> <!--- ROUND TO NEAREST 5px --->
								<cfset outFormRow = outFormRow & '<input type="text" name="#lcCOLUMN_NAME#" id="#lcCOLUMN_NAME#" maxlength="#CHARACTER_MAXIMUM_LENGTH#" style="width: #width#px" />' />
							<cfelse>
								<cfset rows = int(CHARACTER_MAXIMUM_LENGTH / 100) />
								<cfset width = MIN(700,FORM.charwide * 100) />
								<cfset outFormRow = outFormRow & '<#CF#invoke component="##APPLICATION.CFC.Controls##" method="Create" type="textarea" rows="#rows#" width="#width#px" maxlen="#CHARACTER_MAXIMUM_LENGTH#" id="#lcCOLUMN_NAME#" />'>
							</cfif>
						</cfif>
					</cfif>
					<cfif fldDisplay>
						<cfset outTH = outTH & '~ ~ ~ <th class="#lcCOLUMN_NAME#">#ColTitle#</th>#CR#' />
						<cfset outTD = outTD & '~ ~ ~ ~ <td class="#lcCOLUMN_NAME#">###lcCOLUMN_NAME###</td>#CR#' />
						<cfset outSetTD = outSetTD & '~ ~ ~ setTD($tr, ROW.#ucCOLUMN_NAME#, "#lcCOLUMN_NAME#", "");#CR#' />
					</cfif>

				<!--- BOOLEAN FIELDS --->
				<cfelseif ValidationType eq "boolean">
					<cfif fldEdit>
						<cfset outFormRow = outFormRow & '<input type="checkbox" name="#lcCOLUMN_NAME#" id="#lcCOLUMN_NAME#" value="1" />' />
					</cfif>
					<cfif fldDisplay>
						<cfset outTH = outTH & '~ ~ ~ <th class="#lcCOLUMN_NAME#">#ColTitle#</th>#CR#' />
						<cfset outTD = outTD & '~ ~ ~ ~ <td class="#lcCOLUMN_NAME# center"><#CF#invoke component="##APPLICATION.CFC.Controls##" method="Create" type="displaycheck" value="###lcCOLUMN_NAME###"/></td>#CR#' />
						<cfset outSetTD = outSetTD & '~ ~ ~ setTD($tr, getCheckImg(ROW.#ucCOLUMN_NAME#), "#lcCOLUMN_NAME#", "center");#CR#' />
					</cfif>

				<!--- INTEGER FIELDS --->
				<cfelseif ValidationType eq "int">
					<cfif fldEdit>
						<cfif fldEdit and fldFkey>
							<cfset outFormRow = outFormRow & '##select_#FKeyTable###' />
						<cfelse>
							<cfif not fldRange>
								<cfset xlength =  ListFind("tinyint,smallint,mediumint,int,bigint",DATA_TYPE) />
								<cfset MaxVal = 2 ^ (xlength * 8) />
								<cfif FindNoCase("unsigned", COLUMN_TYPE)> <!--- UNSIGNED CAN"T BE NEG --->
									<cfset MinVal = 0/>
								<cfelse>
									<cfset MaxVal = MaxVal/2 - 1/>
									<cfset MinVal = -MaxVal />
								</cfif>
							</cfif>
							<cfset width = int((Len(MaxVal)+1) * FORM.charwide / 5) * 5 /> <!--- ROUND TO NEAREST 5px --->
							<cfset outFormRow = outFormRow & '<#CF#invoke component="##APPLICATION.CFC.Controls##" method="Create" type="#DATA_TYPE#" id="#lcCOLUMN_NAME#" max="#MaxVal#" min="#MinVal#" style="width: #width#px" />' />
							<cfset outValid = outValid & '~ ~ ~ ~ if (!#lcCOLUMN_NAME#.onblur()) return false;#CR#' />
						</cfif>
					</cfif>
					<cfif fldDisplay>
						<cfset outTH = outTH & '~ ~ ~ <th class="#lcCOLUMN_NAME# {sorter: ''digit''}">#ColTitle#</th>#CR#' />
						<cfset outTD = outTD & '~ ~ ~ ~ <td class="#lcCOLUMN_NAME# right">###lcCOLUMN_NAME###</td>#CR#' />
						<cfset outSetTD = outSetTD & '~ ~ ~ setTD($tr, ROW.#ucCOLUMN_NAME#, "#lcCOLUMN_NAME#", "right");#CR#' />
					</cfif>

				<!--- FLOAT FIELDS --->
				<cfelseif ValidationType eq "float">
					<cfif fldEdit>
						<cfif not fldRange>
							<cfif NUMERIC_PRECISION-NUMERIC_SCALE GT 0>
								<cfset MaxVal = Left("999999999999",NUMERIC_PRECISION-NUMERIC_SCALE) & Left(".9999", NUMERIC_SCALE+1) />
							<cfelse>
								<cfset MaxVal = Left(".9999", NUMERIC_SCALE+1) />
							</cfif>
							<cfset MinVal = 0 />
						</cfif>
						<cfset width = int((Len(MaxVal)+1) * FORM.charwide / 5) * 5 /> <!--- ROUND TO NEAREST 5px --->
						<cfset outFormRow = outFormRow & '<#CF#invoke component="##APPLICATION.CFC.Controls##" method="Create" type="float" id="#lcCOLUMN_NAME#" max="#MaxVal#" min="#MinVal#" style="width: #width#px" />' />
						<cfset outValid = outValid & '~ ~ ~ ~ if (!#lcCOLUMN_NAME#.onblur()) return false;#CR#' />
					</cfif>
					<cfif fldDisplay>
						<cfset outTH = outTH & '~ ~ ~ <th class="#lcCOLUMN_NAME# {sorter: ''digit''}">#ColTitle#</th>#CR#' />
						<cfset outTD = outTD & '~ ~ ~ ~ <td class="#lcCOLUMN_NAME# right">###lcCOLUMN_NAME###</td>#CR#' />
						<cfset outSetTD = outSetTD & '~ ~ ~ setTD($tr, ROW.#ucCOLUMN_NAME#, "#lcCOLUMN_NAME#", "right");#CR#' />
					</cfif>

				<!--- DATE FIELDS --->
				<cfelseif ValidationType eq "date">
					<cfif fldEdit>
						<cfset outFormRow = outFormRow & '<#CF#invoke component="##APPLICATION.CFC.Controls##" method="Create" type="date" id="#lcCOLUMN_NAME#" />' />
						<cfset outValid = outValid & '~ ~ ~ ~ if (!validateDate(#lcCOLUMN_NAME#)) return false;#CR#' />
					</cfif>
					<cfif fldDisplay>
						<cfset outTH = outTH & '~ ~ ~ <th class="#lcCOLUMN_NAME# {sorter: ''bihDate''}">#ColTitle#</th>#CR#' />
						<cfset outTD = outTD & '~ ~ ~ ~ <td class="#lcCOLUMN_NAME# center">##udfUserDateFormat(#lcCOLUMN_NAME#)##</td>#CR#' />
						<cfset outSetTD = outSetTD & '~ ~ ~ setTD($tr, ROW.#ucCOLUMN_NAME#, "#lcCOLUMN_NAME#", "center");#CR#' />
					</cfif>
				</cfif>
				<cfif fldEdit>
					<cfset outFormRow = outFormRow & '</td>#CR#~ ~ ~ ~ </tr>#CR#' />
				</cfif>
			</cfif>
			<tr>
				<td class="font7">#DATA_TYPE#</td>
				<td>#COLUMN_NAME#</td>
				<td><input type="text" name="BP#CurrentRow#" value="#ColTitle#"/></td>
				<td class="center"><input type="checkbox" name="DISP#CurrentRow#" value="1" <cfif fldDisplay>checked</cfif> /></td>
				<td class="center"><input type="checkbox" name="EDIT#CurrentRow#" value="1" <cfif fldEdit>checked</cfif> /></td>
				<td class="center"><input type="checkbox" name="REQ#CurrentRow#" value="1" <cfif fldReq>checked</cfif> /></td>
				<cfif ShowFK>
					<td class="font7">
						<cfif FKeyColumn neq "">
							<input type="checkbox" name="FKEY#CurrentRow#" value="1" <cfif fldFKey>checked</cfif> />
							#FKeyTable#.#FKeyColumn#
						<cfelse>
							&nbsp;
						</cfif>
					</td>
				</cfif>
				<cfif ShowRange>
					<td>
						<cfif ListFindNoCase("int,float", ValidationType) and SEARCH_KEY EQ "">
							<input type="text" name="MIN#CurrentRow#" value="#MinVal#" class="font7" size="8" />
							<input type="text" name="MAX#CurrentRow#" value="#MaxVal#" class="font7" size="8" />
						<cfelse>
							&nbsp;
						</cfif>
					</td>
				</cfif>
			</tr>
		</cfoutput>
		</tbody>
		</table>
		<!--- CLOSE WRAPPER TABLE --->
		</td></tr><tfoot><tr><th colspan="4" class="buttons"><input type="submit"></th></tr></tfoot></table>
	</cfform>
</cfif>

<!--- BEGIN OUTPUT OF CREATED PAGE --->
<!--- BEGIN OUTPUT OF CREATED PAGE --->
<!--- BEGIN OUTPUT OF CREATED PAGE --->
<cfif FORM.tabname is not "">
<cfoutput>
<cfsavecontent variable="output">

<#CF#set cudAccess = true />
<#CF#set cfc#FORM.tabnick# = APPLICATION.CFC.Factory.get("#FORM.tabname#") />
<#CF#invoke component="##cfc#FORM.tabnick###" method="Query#FORM.tabnick#" returnvariable="qryRows" />
#Replace(outFKSelect,"~ ",chr(9),"ALL")#
<script language="javascript" type="text/javascript">
	$(document).ready(
		function() {
			$tabDataBody = $("##tabData").tablescroller({
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
<#CF#output>
<div style="margin: 5px 10px 5px 0; padding: 2px;">
	Displaying <span id="cntRows">##udfAddSWithCnt("#FORM.tabnick# record", qryRows.RecordCount)##</span>.
</div>
</#CF#output>
<table id="tabData" class="datagrid" cellspacing="0">
	<caption>#FORM.tabnick# Listing</caption>
	<thead>
		<tr>
			<#CF#if cudAccess><th class="icon"><#CF#invoke component="##APPLICATION.CFC.Controls##" method="Create" type="juiButton" class="ui-button-icon-tiny" id="btnAdd" src="ui-icon-circle-plus" onclick="addRecord(this)" title="Add"/></th></#CF#if>
#Replace(outTH,"~ ",chr(9),"ALL")#		</tr>
	</thead>
	<tbody>
		<#CF#output query="qryRows">
			<tr class="top" id="#FORM.tababbr####Identity###" data-rowid="##CurrentRow-1##">
				<#CF#if cudAccess><td class="icon"><#CF#invoke component="##APPLICATION.CFC.Controls##" method="Create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pencil" onclick="editRecord(this)" title="Edit"/></td></#CF#if>
#Replace(outTD,"~ ",chr(9),"ALL")#			</tr>
		</#CF#output>
	</tbody>
</table>
<#CF#if cudAccess>
	<#CF#output>
	<script language="javascript" type="text/javascript">
		var cntRows = ##qryRows.RecordCount##;
		var qryRows = ##SerializeJSON(qryRows)##;
		queryMakeHashable(qryRows);
	</script>
	</#CF#output>
	<script language="javascript" type="text/javascript">
		hideWinEdit = function() {
			$winEdit.dialog("close");
		}
		showWinEdit = function(mode) {
			$("##btnSave span.ui-button-text").html(mode);
			if (mode=="Add") {
				$("##spanDelete").hide();
				$winEdit.dialog("option", "title", "Add #FORM.tabnick#");
			} else {
				$winEdit.dialog("option", "title", "Edit #FORM.tabnick#");
				$("##spanDelete").show();
			}
			$winEdit.dialog("open");
		}
		clearWinEdit = function() {
			with (document.frmEdit) {
				reset();
				#Identity#.value = "0";
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
			if (frm.#Identity#.value=="0") {
				qryRows.rowAdd = queryAddRow(qryRows); // ADDS EMPTY ROW, SAVE NEW ROW POS FOR LATER USE
				var ROW = qryRows.DATA[qryRows.rowAdd];
			} else {
				var ROW = qryRows.DATA[qryRows.rowEdit];
			}
			loadFormToRow(frm, ROW);
			remoteCall("#FORM.tabname#.Process", ROW, cbRemote);
			$winEdit.dialog("close");
		}
		deleteRecord = function(btn) {
			var ROW = qryRows.DATA[qryRows.rowEdit];
			if (!confirm("Are you sure you want to delete this record?")) return false;
			remoteCall("#FORM.tabname#.Process", {kill: 1, #ucIdentity#: ROW.#ucIdentity#}, cbRemote);
			$winEdit.dialog("close");
		}
		moveRowToTR = function($tr, ROW) {
#Replace(outSetTD,"~ ",chr(9),"ALL")#
			return $tr;
		}
		updateDataBody = function(noResize) {
			noResize = noResize || false;
			$tabDataBody.trigger("update"); // UPDATE THE SORT
			if (!noResize) $.tablescroller.resizeControl($tabDataBody, true);
		}
		updateRowCnt = function(chg) {
			cntRows += chg;
			$("##cntRows").html(addS(cntRows.toString() + " #FORM.tabnick# record", cntRows));
		}
		cbRemote = function(response) {
			if (!response.SUCCESS) {
				cbErrors(response);
			} else {
				with (document.frmEdit) {
					if (response.DATA.METHOD=="Insert") {
						var ROW = qryRows.DATA[qryRows.rowAdd];
						ROW.#ucIdentity# = response.DATA.#ucIdentity#;
						var $tr = $("<tr>").attr("id", "#FORM.tababbr#" + ROW.#ucIdentity#);
						$tr.data("rowid", qryRows.rowAdd); // SET THE ROWID TO THE NEW User QRY POS
						setTD($tr, $newEdit.clone(), "icon");
						moveRowToTR($tr, ROW);
						$tabDataBody.find("tbody:first").append($tr);
						updateDataBody();
						updateRowCnt(1);
						showStatusWindow("Row Added");
						clearWinEdit();
					} else if (response.DATA.METHOD=="Update") {
						var $tr = $("###FORM.tababbr#"+response.DATA.#ucIdentity#);
						var rowid = $tr.data("rowid");
						var ROW = qryRows.DATA[rowid];
						moveRowToTR($tr, ROW);
						updateDataBody(true);
						showStatusWindow("Row Updated");
					} else if (response.DATA.METHOD=="Delete") {
						var $tr = $("###FORM.tababbr#"+response.DATA.#ucIdentity#).fadeOut(800,updateDataBody);
						updateRowCnt(-1);
						showStatusWindow("Row Deleted");
					}
				}
			}
		}
		validateForm = function(frm) {
			with (frm) {
#Replace(outValid,"~ ",chr(9),"ALL")#			}
			return true;;
		}
		setupWinEdit = function() {
			$newEdit = $("##btnEdit").detach().removeAttr("id");
			$winEdit = $("##winEdit");
			$winEditButtons = $("##winEditButtons");
			$winEdit.dialog({autoOpen: false, width: "auto", modal: true, buttons: [{ text: "Cancel"}]});
			$winEdit.dialog("widget").find(".ui-dialog-buttonset").empty().append($winEditButtons);
		}
	</script>
	<#CF#output>
	<div id="winEdit" title="#FORM.tabnick# Maintenance" class="ui-dialog">
		<form id="frmEdit" name="frmEdit">
		<input type="hidden" id="#Identity#" name="#Identity#">
		<table id="tabEdit" class="datagrid" cellspacing="0" align="center">
			<tbody class="nobevel bih-grid-form">
#Replace(outFormRow,"~ ",chr(9),"ALL")#			</tbody>
		</table>
		<div id="winEditButtons">
			<span>
				<span id="spanDelete" style="float:right">
					<#CF#invoke component="##APPLICATION.CFC.Controls##" method="Create" type="juiButton" id="btnDelete" src="ui-icon-trash" onclick="deleteRecord(this)" text="Delete"/>
				</span>
			</span>
			<span>
				<#CF#invoke component="##APPLICATION.CFC.Controls##" method="Create" type="juiButton" id="btnSave" src="ui-icon-circle-check" onclick="saveRecord(this)" text="Save"/>
				<#CF#invoke component="##APPLICATION.CFC.Controls##" method="Create" type="juiButton" id="btnCancel" src="ui-icon-circle-close" onclick="hideWinEdit(this)" text="Cancel"/>
				<#CF#invoke component="##APPLICATION.CFC.Controls##" method="Create" type="juiButton" id="btnEdit" src="ui-icon-pencil" class="ui-button-icon-tiny" onclick="editRecord(this)" title="Edit"/>
			</span>
		</div>
		</form>
	</div>
	</#CF#output>
</#CF#if>
</cfsavecontent>
<cffile action="write" file="#APPLICATION.DISK.ROOT#\test\#lcase(FORM.tabnick)#.cfm" output="#output#"/>
<a class="standardreportlink font10" href="#APPLICATION.PATH.ROOT#/test/#lcase(FORM.tabnick)#.cfm" target="#lcase(FORM.tabnick)#">Test #lcase(FORM.tabnick)#.cfm</a>
<textarea id="txtOut" cols="225" rows="50">#output#</textarea>
<textarea cols="150" rows="20">
	<#CF#function name="Process#FORM.tabName#" access="public" returnType="struct">
		<#CF#set var LOCAL = {}>
		<#CF#set LOCAL.Response.#Identity# = JavaCast("int", ARGUMENTS.#Identity#) />
		<#CF#set ARGUMENTS.#FORM.tabAbbr#_puid = SESSION.LOGIN.PUB.puid />
		<#CF#if IsDefined("ARGUMENTS.kill")>
			<#CF#set LOCAL.Response.method="Delete">
		<#CF#elseif LOCAL.Response.#Identity# neq 0>
			<#CF#set LOCAL.Response.method="Update">
		<#CF#else>
			<#CF#set LOCAL.Response.method="Insert">
		</#CF#if>
		<#CF#invoke method="##LOCAL.Response.method###FORM.tabName#" returnvariable="LOCAL.rtn">
			<#CF#loop collection="##ARGUMENTS##" item="LOCAL.key">
				<#CF#if ARGUMENTS[LOCAL.key] neq "null">
					<#CF#invokeargument name="##LOCAL.key##" value="##ARGUMENTS[LOCAL.key]##">
				</#CF#if>
			</#CF#loop>
		</#CF#invoke>
		<#CF#if LOCAL.Response.method eq "Insert">
			<#CF#set LOCAL.Response.#Identity# = JavaCast("int", LOCAL.rtn) />
		</#CF#if>
		<#CF#return LOCAL.Response />
	</#CF#function>

</textarea>
</cfoutput>
</cfif>
