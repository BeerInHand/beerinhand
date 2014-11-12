<script>
	$(document).ready(
		function() {
			spinnerBindGravity($("#gravity_sg"), "SG", gravityEvent);
			spinnerBindGravity($("#gravity_plato"), "P", gravityEvent);
			spinnerBindTemp($("#gravity_temp"), bihDefaults.TUNITS, gravityEvent);
			$("#gravity_tunits").bind("click", { fld: "#gravity_temp" }, gravityUnitsTemp);
			calcClear("g");
		}
	);
</script>
<table id="tabGravity" class="datagrid calculator" cellspacing="0">
	<caption>
		<div class="bih-grid-caption ui-widget-header">
			<span class="icons"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-arrowthick-1-w" onclick="calc2rcpGravity(this)" title="Select" style="display:none" /><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-trash" onclick="calcClear('g')" title="Clear Calculator"/></span>
			Gravity
		</div>
	</caption>
	<tbody class="bih-grid-form nobevel">
		<tr>
			<td class="unitlabel label font8" width="100">Specific Grav.</td>
			<td class="unitinput" width="50"><input type="text" class="decimal unit" maxlength="5" id="gravity_sg"></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="unitlabel label">% Extract</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="gravity_plato"></td>
			<td class="font8 smallcaps bold">° Plato</td>
		</tr>
		<tr><td class="miniHead" colspan="3"><div class="ui-widget-content" title="Standardized at 15°C/59°F">-- Hydrometer Correction For Temperature --</div></td></tr>
		<tr>
			<td class="unitlabel label font8">Wort Temp</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="gravity_temp"></td>
			<td><button id="gravity_tunits" value="F" class="butRotate tunits" type="button">&deg; F</button></td>
		</tr>
		<tr>
			<td class="unitlabel label">Correct S.G.</td>
			<td class="unitinput"><input type="text" class="decimal unit" readonly="readonly" disabled="disabled" maxlength="5" id="hc_sg"></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="unitlabel label">Correct % Ext</td>
			<td class="unitinput"><input type="text" class="decimal unit" readonly="readonly" disabled="disabled" maxlength="5" id="hc_plato"></td>
			<td class="font8 smallcaps bold">° Plato</td>
		</tr>
	</tbody>
</table>