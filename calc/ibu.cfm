<cfinvoke component="#APPLICATION.CFC.Javascript#" method="IncludeHopsJS" />

<script>
	$(document).ready(
		function() {
			spinnerBind($("#ibu_volume"), incAmt, ibuEvent);
			spinnerBind($("#ibu_amount"), incAmt, ibuEvent);
			spinnerBind($("#ibu_aau"), incAAU, ibuEvent);
			spinnerBind($(".ibu_ibu"), incIBU, ibuEvent);
			spinnerBind($("#ibu_boillen"), incTime, ibuEvent);
			popUnitSelect("#ibu_vunits", LitersConvert);
			popUnitSelect("#ibu_wunits", GramsConvert);
			ibuHopsAuto();
			calcClear("i");
		}
	);
</script>
<table id="tabCarb" class="datagrid calculator" cellspacing="0">
	<caption>
		<div class="bih-grid-caption ui-widget-header">
			<span class="icons"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-trash" onclick="calcClear('i')" title="Clear Calculator"/></span>
			IBU Calculator
		</div>
	</caption>
	<tbody class="bih-grid-form nobevel">
		<tr>
			<td class="unitlabel label">Volume</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="ibu_volume" /></td>
			<td><select class="vunits" name="ibu_vunits" id="ibu_vunits" onchange="ibuUnitsVolume(this)"></select></td>
		</tr>
		<tr>
			<td class="unitlabel label font8">Gravity</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="ibu_expgrv" /></td>
			<td><button id="ibu_eunits" class="butRotate eunits" type="button" onclick="ibuUnitsGravity(this)">SG</button></td>
		</tr>
		<tr>
			<td class="unitlabel label">Boiled For</td>
			<td class="unitinput"><input type="text" class="integer" maxlength="3" id="ibu_boillen" /></td>
			<td class="smallcaps bold">Minutes</td>
		</tr>
		<tr>
			<td class="unitlabel label">Utilization</td>
			<td class="unitinput" width="80"><input type="text" class="decimal unit" maxlength="5" id="ibu_util" disabled="disabled" /></td>
			<td>%</td>
		</tr>
		<tr>
			<td class="unitlabel label" width="150">Hop</td>
			<td colspan="2"><input type="text" name="ibu_hop" id="ibu_hop" maxlength="35" style="width: 300px" /></td>
		</tr>
		<tr>
			<td class="unitlabel label">Typical Aau Range</td>
			<td class="unitinput" width="80"><input type="text" class="decimal unit" maxlength="5" id="ibu_aarange" disabled="disabled" /></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="unitlabel label">Hop Aau</td>
			<td class="unitinput" width="80"><input type="text" class="decimal unit" maxlength="5" id="ibu_aau" /></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="unitlabel label font8">Hop Form</td>
			<td><button type="button" class="butRotate units" id="ibu_form" onclick="ibuHopForm(this)">Pellet</button></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="unitlabel label">Hop Amount</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="ibu_amount" /></td>
			<td><select class="wunits" name="ibu_wunits" id="ibu_wunits" onchange="ibuUnitsWeight(this)"></select></td>
		</tr>
		<tr>
			<td class="unitlabel label font8">IBU</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="ibu_ibu" /></td>
			<td>&nbsp;</td>
		</tr>
	</tbody>
</table>