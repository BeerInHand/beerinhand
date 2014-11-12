<script>
	$(document).ready(
		function() {
			spinnerBind($("#kettle_volume_i"), incAmt, kettleEvent);
			spinnerBind($("#kettle_volume_f"), incAmt, kettleEvent);
			spinnerBind($("#kettle_boillen"), incTime, kettleEvent);
			spinnerBind($("#kettle_boilrate"), { inc: .1, maxVal: 10.0, minInc: .01, maxInc: 1.0, decimals: 2, minVal: 0}, kettleEvent);
			spinnerBind($("#kettle_boilpct"), incPct, kettleEvent);
			popUnitSelect("#kettle_vunits", LitersConvert);
			calcClear("k");
		}
	);
</script>
<table id="tabKettle" class="datagrid calculator" cellspacing="0">
	<caption>
		<div class="bih-grid-caption ui-widget-header">
			<span class="icons"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-trash" onclick="calcClear('k')" title="Clear Calculator"/></span>
			Kettle Volume
		</div>
	</caption>
	<tbody class="bih-grid-form nobevel">
		<tr><td class="miniHead" colspan="3"><div class="ui-widget-content">-- Pre-Boil Kettle Contents --</div></td></tr>
		<tr>
			<td class="unitlabel label" width="100">Initial Volume</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="kettle_volume_i" /></td>
			<td><select class="vunits" name="kettle_vunits" id="kettle_vunits" onchange="kettleUnitsVolume(this)"></select></td>
		</tr>
		<tr>
			<td class="unitlabel label font8">Initial Gravity</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="kettle_expgrv_i" /></td>
			<td><button id="kettle_eunits" class="butRotate eunits" type="button" onclick="kettleUnitsGravity(this)">SG</button></td>
		</tr>
		<tr><td class="miniHead" colspan="3"><div class="ui-widget-content">-- Wort Boil Time --</div></td></tr>
		<tr>
			<td class="unitlabel label">Boiled For</td>
			<td class="unitinput"><input type="text" class="integer" maxlength="3" id="kettle_boillen" /></td>
			<td class="smallcaps bold">Minutes</td>
		</tr>
		<tr><td class="miniHead" colspan="3"><div class="ui-widget-content">-- Post-Boil Kettle Contents --</div></td></tr>
		<tr>
			<td class="unitlabel label font8">Final Volume</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="kettle_volume_f" /></td>
			<td id="kettle_fvunits" class="smallcaps bold">&nbsp;</td>
		</tr>
		<tr>
			<td class="unitlabel label font8">Final Gravity</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="kettle_expgrv_f" /></td>
			<td id="kettle_feunits" class="smallcaps bold">&nbsp;</td>
		</tr>
		<tr><td class="miniHead" colspan="3"><div class="ui-widget-content">-- Evaporation Rates --</div></td></tr>
		<tr>
			<td class="unitlabel label font8">Boil Off</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="kettle_boilrate" /></td>
			<td id="kettle_brunits" class="smallcaps bold">&nbsp;</td>
		</tr>
		<tr>
			<td class="unitlabel label">Boil Off</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="kettle_boilpct" /></td>
			<td class="smallcaps bold">% / Hour</td>
		</tr>

	</tbody>
</table>