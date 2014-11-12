<cfset filter = StructNew() />
<cfif ArrayLen(REQUEST.URLTokens) GTE 2>
	<cfset toke = 2 />
	<cfif isNumeric(REQUEST.URLTokens[toke])>
		<cfset filter.GR_GRID = REQUEST.URLTokens[toke] />
		<cfset toke = toke + 1 />
	<cfelse>
		<cfif REQUEST.URLTokens[toke] EQ "maltster">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.GR_MALTSTER = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelseif REQUEST.URLTokens[toke] EQ "country">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.GR_COUNTRY = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelseif REQUEST.URLTokens[toke] EQ "category">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.GR_CAT = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelse>
			<cfset filter.GR_TYPE = REQUEST.URLTokens[toke] />
		</cfif>
	</cfif>
</cfif>
<cfif NOT Len(StructKeyList(filter))><cfset filter = false /></cfif>
<cfoutput>
<script>
$.ajax({ url: "#APPLICATION.PATH.ROOT#/js/grains_data.js", dataType: "script", cache: true, async: false });
$(document).ready(
	function() {
		selectFill(getById("dataSrcFld"), { Type:"GR_TYPE", Category:"GR_CAT", Info:"GR_INFO" });
		dataInit("Grains", "Malt/Fermentables", "GR_GRID", #SerializeJSON(filter)#, [#ValueList(qryPending.ue_pkid)#]);
	}
);
</script>
<ul id="dataView">
	<li class="ui-widget-content ui-corner-all">
		<div>
			<h2 class="col1"><a href="" class="gr_type"></a></h2>
			<h3 class="col2"><a href="" class="gr_country"><img src="#APPLICATION.PATH.IMG#/trans.gif"></a> <a href="" class="gr_maltster"></a></h3>
			<h4 class="col3 right"><a href="" class="gr_cat"></a></h4>
		</div>
		<div>
			<h5 class="col1"><a href="" class="gr_lvb"></a></h5>
			<h5 class="col2"><a href="" class="gr_sgc"></a></h5>
			<h5 class="col3 right"><a href="" class="gr_lintner"></a></h5>
		</div>
		<div class="notes gr_info"></div>
	</li>
	<li id="dataSheet" class="ui-widget-content ui-corner-all">
		<form id="frmEdit" name="frmEdit">
		<input type="hidden" id="gr_grid" name="gr_grid" />
		<table id="dataTable" cellspacing="10">
			<tbody>
				<tr>
					<td class="label" width="165">Malt/Fermentable</td>
					<td class="disp" width="475"><h2 class="gr_type"></h2></td>
					<td class="edit"><input type="text" name="gr_type" id="gr_type" maxlength="25" style="width: 225px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Maltster</td>
					<td class="disp"><h3><a href="" class="gr_maltster"></a></h3></td>
					<td class="edit"><input type="text" name="gr_maltster" id="gr_maltster" maxlength="25" style="width: 225px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Country</td>
					<td class="disp"><h3><a href="" class="gr_country"><img src="#APPLICATION.PATH.IMG#/trans.gif"><span></span></a></h3></td>
					<td class="edit"><input type="text" name="gr_country" id="gr_country" maxlength="15" style="width: 150px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Category</td>
					<td class="disp"><h3><a href="" class="gr_cat"></a></h3></td>
					<td class="edit"><input type="text" name="gr_cat" id="gr_cat" maxlength="15" style="width: 150px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Extract Potential (SGC)</td>
					<td class="disp"><h3><a class="gr_sgc"></a></h3></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_sgc" max="9.999" min="0" style="width: 50px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Color (SRM)</td>
					<td class="disp"><h3><a class="gr_lvb"></a></h3></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_lvb" max="999.9" min="0" style="width: 50px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Requires Mashing</td>
					<td class="disp"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="gr_mash"></td>
					<td class="edit"><input type="checkbox" name="gr_mash" id="gr_mash" value="1" checked /></td>
				</tr>
				<tr>
					<td class="label">Diastatic Power</td>
					<td class="disp"><h3><a class="gr_lintner"></a> <span class="font10">&deg;Lintner</span></h3></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" name="gr_lintner" max="256" min="0" style="width: 35px" /> <span class="font10">&deg;Lintner</span></td>
				</tr>
				<tr>
					<td class="label">Moisture Content</td>
					<td class="disp"><h3><a class="gr_mc"></a> <span class="font10">%</span></h3></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_mc" max="9.999" min="0" style="width: 50px" /> <span class="font10">%</span></td>
				</tr>
				<tr>
					<td class="label">Dry Basis Fine Grind</td>
					<td class="disp"><h3><a class="gr_fgdb"></a> <span class="font10">%</span></h3></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_fgdb" max="99.9" min="0" style="width: 50px" /> <span class="font10">%</span></td>
				</tr>
				<tr>
					<td class="label">Dry Basis Coarse Grind</td>
					<td class="disp"><h3><a class="gr_cgdb"></a> <span class="font10">%</span></h3></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_cgdb" max="99.9" min="0" style="width: 50px" /> <span class="font10">%</span></td>
				</tr>
				<tr>
					<td class="label">Fine/Coarse Difference</td>
					<td class="disp"><h3><a class="gr_fcdif"></a> <span class="font10">%</span></h3></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_fcdif" max="99.9" min="0" style="width: 50px" /> <span class="font10">%</span></td>
				</tr>
				<tr>
					<td class="label">Protein</td>
					<td class="disp"><h3><a class="gr_protein"></a> <span class="font10">%</span></h3></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="float" name="gr_protein" max="99.9" min="0" style="width: 50px" /> <span class="font10">%</span></td>
				</tr>
				<tr>
					<td class="label top">Data Sheet URL</td>
					<td class="disp"><a href="" target="_blank" class="gr_url exturl"></a></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="url" style="width: 475px" maxlen="150" name="gr_url" id="gr_url" /></td>
				</tr>
				<tr>
					<td class="label top">Information</td>
					<td class="disp gr_info"></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="10" width="475px" maxlen="1000" name="gr_info" /></td>
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
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="2" width="475px" maxlen="1000" name="ue_reason" />
					</td>
				</tr>
			</tbody>
		</table>
		</form>
	</li>
</ul>
</cfoutput>
