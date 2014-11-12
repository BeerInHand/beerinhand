<script>	$(document).ready( function() { calcClear("a") } )</script>
<table id="tabAlcohol" class="datagrid calculator" cellspacing="0">
	<caption>
		<div class="bih-grid-caption ui-widget-header">
			<span class="icons"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-trash" onclick="calcClear('k')" title="Clear Calculator"/></span>
			% Alcohol / Calories
		</div>
	</caption>
	<tbody class="bih-grid-form nobevel">
		<tr>
			<td class="unitlabel label font8">Initial Gravity</td>
			<td class="unitinput" width="90"><input type="text" class="decimal unit" maxlength="5" id="alc_expgrv_i" /></td>
			<td width="90"><button id="alc_eunits" class="butRotate eunits" type="button" onclick="alcUnitsGravity(this)">SG</button></td>
		</tr>
		<tr>
			<td class="unitlabel label font8">Final Gravity</td>
			<td class="unitinput"><input type="text" class="decimal unit" maxlength="5" id="alc_expgrv_f" /></td>
			<td id="alc_feunits" class="smallcaps bold">&nbsp;</td>
		</tr>
		<tr><td class="miniHead" colspan="3"><div class="ui-widget-content">-- % Alcohol / Calories --</div></td></tr>
		<tr>
			<td class="unitlabel label font8">ABV</td>
			<td class="unitinput"><input type="text" class="decimal" id="alc_abv" disabled="disabled" /></td>
			<td>%</td>
		</tr>
		<tr>
			<td class="unitlabel label font8">ABW</td>
			<td class="unitinput"><input type="text" class="decimal" id="alc_abw" disabled="disabled" /></td>
			<td>%</td>
		</tr>
		<tr>
			<td class="unitlabel label font8">Calories</td>
			<td class="unitinput"><input type="text" class="decimal" id="alc_calories" disabled="disabled" /></td>
			<td class="smallcaps bold">per 12 oz</td>
		</tr>
	</tbody>
</table>