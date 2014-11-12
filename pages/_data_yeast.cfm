<cfset filter = StructNew() />
<cfif ArrayLen(REQUEST.URLTokens) GTE 2>
	<cfset toke = 2 />
	<cfif isNumeric(REQUEST.URLTokens[toke])>
		<cfset filter.YE_YEID = REQUEST.URLTokens[toke] />
		<cfset toke = toke + 1 />
	<cfelse>
		<cfif REQUEST.URLTokens[toke] EQ "mfg">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.YE_MFG = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelseif REQUEST.URLTokens[toke] EQ "type">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.YE_TYPE = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelseif REQUEST.URLTokens[toke] EQ "form">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.YE_FORM = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelse>
			<cfset filter.YE_YEAST = REQUEST.URLTokens[toke] />
		</cfif>
	</cfif>
</cfif>
<cfif NOT Len(StructKeyList(filter))><cfset filter = false /></cfif>
<cfoutput>
<script>
$.ajax({ url: "#APPLICATION.PATH.ROOT#/js/yeast_data.js", dataType: "script", cache: true, async: false });
$(document).ready(
	function() {
		selectFill(getById("dataSrcFld"), { Yeast:"YE_YEAST", Mfg:"YE_MFG", Info:"YE_INFO" });
		dataInit("Yeast", "Yeast", "YE_YEID", #SerializeJSON(filter)#, [#ValueList(qryPending.ue_pkid)#]);
	}
);
</script>
<ul id="dataView">
	<li class="ui-widget-content ui-corner-all">
		<div>
			<h2 class="col1"><a class="ye_yeast"></a></h2>
			<h3 class="col2"><a class="ye_mfg"></a> <span class="ye_mfgno"></span></h3>
			<h4 class="col3 right"><a class="ye_type"></a></h4>
		</div>
		<div>
			<h5 class="col1"><a class="ye_form"></a></h5>
			<h5 class="col2"><a class="ye_templow"></a><a class="ye_temp"> - </a><a class="ye_temphigh"></a> &deg;#SESSION.SETTING.tunits#</h5>
			<h5 class="col3 right"><a class="ye_atlow"></a><a class="ye_at"> - </a><a class="ye_athigh"></a> %</h5>
		</div>
		<div class="notes ye_info"></div>
	</li>
	<li id="dataSheet" class="ui-widget-content ui-corner-all">
		<form id="frmEdit" name="frmEdit">
		<input type="hidden" id="ye_grid" name="ye_grid" />
		<table id="dataTable" cellspacing="10">
			<tbody>
				<tr>
					<td class="label" width="175">Yeast</td>
					<td class="disp" width="450"><h2 class="ye_yeast"></h2></td>
					<td class="edit"><input type="text" name="ye_yeast" id="ye_yeast" maxlength="60" style="width: 500px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Manufacturer</td>
					<td class="disp"><h3><a class="ye_mfg"></a></h3></td>
					<td class="edit"><input type="text" name="ye_mfg" id="ye_mfg" maxlength="20" style="width: 185px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Mfg ##</td>
					<td class="disp"><h3 class="ye_mfgno"></h3></td>
					<td class="edit"><input type="text" name="ye_mfgno" id="ye_mfgno" maxlength="10" style="width: 95px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Type</td>
					<td class="disp"><h3><a class="ye_type"></a></h3></td>
					<td class="edit"><input type="text" name="ye_type" id="ye_type" maxlength="10" style="width: 95px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Form</td>
					<td class="disp"><h3><a class="ye_form"></a></h3></td>
					<td class="edit"><input type="text" name="ye_form" id="ye_form" maxlength="10" style="width: 95px" required="required" /></td>
				</tr>
				<tr>
					<td class="label">Temperature</td>
					<td class="disp"><h3><a class="ye_templow"></a><a class="ye_temp"> - </a><a class="ye_temphigh"></a> &deg;#SESSION.SETTING.tunits#</td>
					<td class="edit">
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" id="ye_templow" max="256" min="0" style="width: 35px" />
						&nbsp;-&nbsp;
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" id="ye_temphigh" max="256" min="0" style="width: 35px" />
						&nbsp;&nbsp;
						<button id="ye_tempunits" class="butRotate units" type="button" value="F">&deg;F</button>
					</td>
				</tr>
				<tr>
					<td class="label">Attenuation</td>
					<td class="disp"><h3><a class="ye_atlow"></a><a class="ye_at"> - </a><a class="ye_athigh"></a> %</h3></td>
					<td class="edit">
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" id="ye_atlow" max="256" min="0" style="width: 35px" />
						&nbsp;-&nbsp;
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="tinyint" id="ye_athigh" max="256" min="0" style="width: 35px" />
						%
					</td>
				</tr>
				<tr>
					<td class="label">Attenuation</td>
					<td class="disp"><h3><a class="ye_atten"></a></h3></td>
					<td class="edit"><input type="text" name="ye_atten" id="ye_atten" maxlength="11" style="width: 105px" /></td>
				</tr>
				<tr>
					<td class="label">Floculation</td>
					<td class="disp"><h3><a class="ye_floc"></a></h3></td>
					<td class="edit"><input type="text" name="ye_floc" id="ye_floc" maxlength="11" style="width: 105px" /></td>
				</tr>
				<tr>
					<td class="label">Tolerance</td>
					<td class="disp"><h3><a class="ye_tolerance"></a></h3></td>
					<td class="edit"><input type="text" name="ye_tolerance" id="ye_tolerance" maxlength="10" style="width: 95px" /></td>
				</tr>
				<tr>
					<td class="label top">Data Sheet URL</td>
					<td class="disp"><a target="_blank" class="ye_url exturl"></a></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="url" style="width: 500px" maxlen="150" name="ye_url" id="ye_url" /></td>
				</tr>
				<tr>
					<td class="label top">Information</td>
					<td class="disp ye_info"></td>
					<td class="edit"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="10" width="500px" maxlen="1000" name="ye_info" /></td>
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
						<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="textarea" rows="2" width="450px" maxlen="1000" name="ue_reason" />
					</td>
				</tr>
			</tbody>
		</table>
		</form>
	</li>
</ul>
</cfoutput>
