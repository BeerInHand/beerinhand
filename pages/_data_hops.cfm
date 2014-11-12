<cfset filter = StructNew() />
<cfif ArrayLen(REQUEST.URLTokens) GTE 2>
	<cfset toke = 2 />
	<cfif isNumeric(REQUEST.URLTokens[toke])>
		<cfset filter.HP_HPID = REQUEST.URLTokens[toke] />
		<cfset toke = toke + 1 />
	<cfelse>
		<cfif REQUEST.URLTokens[toke] EQ "grown">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.HP_GROWN = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelse>
			<cfset filter.HP_HOP = REQUEST.URLTokens[toke] />
		</cfif>
	</cfif>
</cfif>
<cfif NOT Len(StructKeyList(filter))><cfset filter = false /></cfif>
<cfoutput>
<script>
$.ajax({ url: "#APPLICATION.PATH.ROOT#/js/hops_data.js", dataType: "script", cache: true, async: false });
$(document).ready(
	function() {
		selectFill(getById("dataSrcFld"), { Hop:"HP_HOP", Profile:"HP_PROFILE", Use:"HP_USE", Example:"HP_EXAMPLE", Substitute:"HP_SUB", Info:"HP_INFO" });
		dataInit("Hops", "Hops", "HP_HPID", #SerializeJSON(filter)#, [#ValueList(qryPending.ue_pkid)#]);
	}
);
</script>
<ul id="dataView">
	<li class="ui-widget-content ui-corner-all">
		<div>
			<h2 class="col1"><a href="" class="hp_hop"></a></h2>
			<h3 class="col2"><a href="" class="hp_grown"><img src="#APPLICATION.PATH.IMG#/trans.gif"><span></span></a></h3>
			<h4 class="col3 right"><a class="hp_aalow"></a><a class="hp_aau"> - </a><a class="hp_aahigh"></a> AAU</h4>
		</div>
		<div class="notes hp_info"></div>
	</li>
	<li id="dataSheet" class="ui-widget-content ui-corner-all">
		<form id="frmEdit" name="frmEdit">
		<input type="hidden" id="hp_grid" name="hp_grid" />
		<table id="dataTable" cellspacing="10">
			<tbody>
				<tr>
					<td class="label" width="140">Hop</td>
					<td class="disp" width="500"><h2 class="hp_hop"></h2></td>
					<td class="edit"><input type="text" name="hp_hop" id="hp_hop" maxlength="25" style="width: 230px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Grown</td>
					<td class="disp"><h3><a href="" class="hp_grown"><img src="#APPLICATION.PATH.IMG#/trans.gif"><span></span></a></h3></td>
					<td class="edit"><input type="text" name="hp_grown" id="hp_grown" maxlength="15" style="width: 140px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">AAU Range</td>
					<td class="disp"><h3><a class="hp_aalow"></a><a class="hp_aau"> - </a><a class="hp_aahigh"></a> <span class="font10">%</span></h3></td>
					<td class="edit">
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="hp_aalow" max="29.9" min="0" style="width: 45px" required="required" />
						&nbsp;-&nbsp;
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="hp_aahigh" max="29.9" min="0" style="width: 45px" required="required" />
						<span class="font10">%</span>
					</td>
				</tr>
				<tr>
					<td class="label">Uses</td>
					<td class="disp">
						<span class="ui-corner-all btn hp_bitter">Bitter</span>
						<span class="ui-corner-all btn hp_aroma">Aroma</span>
						<span class="ui-corner-all btn hp_dry">Dry</span>
					</td>
					<td class="edit">
						<span class="ui-corner-all btn"><label>Bitter: <input type="checkbox" name="hp_bitter" id="hp_bitter" value="1" checked /></label></span>
						<span class="ui-corner-all btn"><label>Aroma: <input type="checkbox" name="hp_aroma" id="hp_aroma" value="1" checked /></label></span>
						<span class="ui-corner-all btn"><label>Dry: <input type="checkbox" name="hp_dry" id="hp_dry" value="1" checked /></label></span>
					</td>
				</tr>
				<tr>
					<td class="label">Storage Index (HSI)</td>
					<td class="disp"><h3><a class="hp_hsi"></h3></a></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="hp_hsi" max="99.9" min="0" style="width: 45px" value="0" /></td>
				</tr>
				<tr>
					<td class="label">Profile</td>
					<td class="disp hp_profile"></td>
					<td class="edit"><input type="text" name="hp_profile" id="hp_profile" maxlength="100" style="width: 500px" /></td>
				</tr>
				<tr>
					<td class="label">Typical Usage</td>
					<td class="disp hp_use"></td>
					<td class="edit"><input type="text" name="hp_use" id="hp_use" maxlength="100" style="width: 500px" /></td>
				</tr>
				<tr>
					<td class="label">Example</td>
					<td class="disp hp_example"></td>
					<td class="edit"><input type="text" name="hp_example" id="hp_example" maxlength="100" style="width: 500px" /></td>
				</tr>
				<tr>
					<td class="label">Substitute</td>
					<td class="disp hp_sub"></td>
					<td class="edit"><input type="text" name="hp_sub" id="hp_sub" maxlength="100" style="width: 500px" /></td>
				</tr>
				<tr>
					<td class="label top">Data Sheet URL</td>
					<td class="disp"><a href="" target="_blank" class="hp_url exturl"></a></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="url" style="width: 500px" maxlen="150" name="hp_url" id="hp_url" /></td>
				</tr>
				<tr>
					<td class="label top">Information</td>
					<td class="disp hp_info"></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="10" width="500px" maxlen="1000" name="hp_info" /></td>
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
