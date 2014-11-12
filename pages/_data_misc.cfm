<cfset filter = StructNew() />
<cfif ArrayLen(REQUEST.URLTokens) GTE 2>
	<cfset toke = 2 />
	<cfif isNumeric(REQUEST.URLTokens[toke])>
		<cfset filter.MI_MIID = REQUEST.URLTokens[toke] />
		<cfset toke = toke + 1 />
	<cfelse>
		<cfif REQUEST.URLTokens[toke] EQ "use">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.MI_USE = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelseif REQUEST.URLTokens[toke] EQ "phase">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.MI_PHASE = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelse>
			<cfset filter.MI_TYPE = REQUEST.URLTokens[toke] />
		</cfif>
	</cfif>
</cfif>
<cfif NOT Len(StructKeyList(filter))><cfset filter = false /></cfif>

<cfoutput>
<script>
$.ajax({ url: "#APPLICATION.PATH.ROOT#/js/misc_data.js", dataType: "script", cache: true, async: false });
$(document).ready(
	function() {
		selectFill(getById("dataSrcFld"), { Type:"MI_TYPE", Use:"MI_USE", Info:"MI_INFO" });
		var $mi_unit = popUnitSelect("##mi_unit", GramsConvert);
		popUnitSelect($mi_unit, LitersConvert);
		$mi_unit.val(bihDefaults.HUNITS);
		dataInit("Misc", "Misc", "MI_MIID", #SerializeJSON(filter)#, [#ValueList(qryPending.ue_pkid)#]);
	}
);
</script>
<ul id="dataView">
	<li class="ui-widget-content ui-corner-all">
		<div>
			<h2 class="col1"><a class="mi_type"></a></h2>
			<h3 class="col2"><a class="mi_use"></a></h3>
			<h4 class="col3 right"><a class="mi_phase"></a></h4>
		</div>
		<div class="notes mi_info"></div>
	</li>
	<li id="dataSheet" class="ui-widget-content ui-corner-all">
		<form id="frmEdit" name="frmEdit">
		<input type="hidden" id="mi_grid" name="mi_grid" />
		<table id="dataTable" cellspacing="10">
			<tbody>
				<tr>
					<td class="label" width="120">Type</td>
					<td class="disp" width="500"><h2 class="mi_type"></h2></td>
					<td class="edit"><input type="text" name="mi_type" id="mi_type" maxlength="25" style="width: 230px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Use</td>
					<td class="disp"><h3><a class="mi_use"></a></h3></td>
					<td class="edit"><input type="text" name="mi_use" id="mi_use" maxlength="25" style="width: 230px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Brewing Phase</td>
					<td class="disp"><h3><a class="mi_phase"></a></h3></td>
					<td class="edit"><button type="button" name="mi_phase" id="mi_phase"  class="butRotate" onclick="rotateSetVal(this, Phase[this.innerHTML])">Mash</button></td>
				</tr>
				<tr>
					<td class="label">Units</td>
					<td class="disp mi_unit"></td>
					<td class="edit">
						<button type="button" name="mi_utype" id="mi_utype"  class="butRotate" onclick="rotateSetVal(this, this.value=='W'?'Volume':'Weight', this.value=='W'?'V':'W')"></button>
						<select name="mi_unit" id="mi_unit"></select>
					</td>
				</tr>
				<tr>
					<td class="label top">Data Sheet URL</td>
					<td class="disp"><a target="_blank" class="mi_url exturl"></a></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="url" style="width: 500px" maxlen="150" name="mi_url" id="mi_url" /></td>
				</tr>
				<tr>
					<td class="label top">Information</td>
					<td class="disp mi_info"></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="10" width="500px" maxlen="1000" name="mi_info" /></td>
				</tr>
			</tbody>
			<tbody class="nobevel edit">
				<tr>
					<td colspan="3" class="font8">
						<hr/>
						<div class="pad10">Your changes will be reviewed by a site admin before appearing on the site.</div>
					</td>
				</tr>
				<tr>
					<td class="label top">Reason For Edit</td>
					<td colspan="2">
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="2" width="500px" maxlen="1000" name="ue_reason" />
					</td>
				</tr>
			</tbody>
		</table>
		</form>
	</li>
</ul>
</cfoutput>
