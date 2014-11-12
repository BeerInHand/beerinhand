<cfoutput><script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/bjcpstyles_data.js"></script></cfoutput>
<script>
	$(document).ready(
		function() {
			queryMakeHashable(qryBJCPStyles);
			spinnerBind($("#carb_volume"), incAmt, carbEvent);
			spinnerBind($("#carb_co2_i"), incCO2, carbEvent);
			spinnerBind($("#carb_co2_f"), incCO2, carbEvent);
			spinnerBind($("#carb_amount"), incAmt, carbEvent);
			spinnerBind($("#carb_psi"), { inc: 1, minInc: .1, maxInc: 10.0, minVal: 0, maxVal: 35.0, decimals: 1 }, carbEvent);
			$("#carb_tunits").bind("click", { fld: "#carb_temp" }, carbUnitsTemp);
			popUnitSelect("#carb_vunits", LitersConvert);
			popUnitSelect("#carb_wunits", GramsConvert);
			popPrimer("#carb_primer").val(bihDefaults.PRIMER);
			carbStylesAuto();
			calcClear("c");
		}
	);
</script>
<table id="tabCarb" class="datagrid calculator" cellspacing="0">
	<caption>
		<div class="bih-grid-caption ui-widget-header">
			<span class="icons"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-trash" onclick="calcClear('c')" title="Clear Calculator"/></span>
			Beer Carbonation
		</div>
	</caption>
	<tbody class="bih-grid-form nobevel">
		<tr>
			<td class="unitlabel label" width="150">Beer Style</td>
			<td colspan="2"><input type="text" name="carb_style" id="carb_style" maxlength="35" style="width: 300px" /></td>
		</tr>
		<tr>
			<td class="unitlabel label">Typical CO2 Range</td>
			<td class="unitinput" width="80"><input type="text" class="decimal unit" maxlength="5" id="carb_co2range" disabled="disabled" /></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="unitlabel label font8">Current Temperature</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="carb_temp"></td>
			<td><button id="carb_tunits" value="F" class="butRotate tunits" type="button">&deg; F</button></td>
		</tr>
		<tr>
			<td class="unitlabel label">Current C02</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="carb_co2_i" /></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="unitlabel label">Final C02</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="carb_co2_f" /></td>
			<td>&nbsp;</td>
		</tr>
		<tr><td class="miniHead" colspan="3"><div class="ui-widget-content">-- Priming Sugar Carbonation --</div></td></tr>
		<tr>
			<td class="unitlabel label">Volume</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="carb_volume" /></td>
			<td><select class="vunits" name="carb_vunits" id="carb_vunits" onchange="carbUnitsVolume(this)"></select></td>
		</tr>
		<tr>
			<td class="unitlabel label font8">Priming Sugar</td>
			<td class="unitinput"><select class="primer" name="carb_primer" id="carb_primer" onchange="carbCalc()"></select></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="unitlabel label">Priming Amount</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="carb_amount" /></td>
			<td><select class="wunits" name="carb_wunits" id="carb_wunits" onchange="carbUnitsWeight(this)"></select></td>
		</tr>
		<tr><td class="miniHead" colspan="3"><div class="ui-widget-content">-- Forced Carbonation --</div></td></tr>
		<tr>
			<td class="unitlabel label font8">Regulator Pressure</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="carb_psi" disabled="disabled" /></td>
			<td id="carb_fvunits" class="smallcaps bold">PSI</td>
		</tr>
	</tbody>
</table>