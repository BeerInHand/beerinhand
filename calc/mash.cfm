<script language="javascript" type="text/javascript">
	$(document).ready(
		function() {
			$("#mash_tunits").on("click", mashUnitsTemp);
			spinnerBind($("#mash_steps input.units_m"), incAmt, mashEvent);
			spinnerBind($("#mash_steps input.units_vi"), incAmt, mashEvent);
			spinnerBind($("#mash_strike"), incAmt, mashEvent);
			spinnerBind($("#mash_steps input.duration"), incTime, mashEvent);
			spinnerBindTemp($("#mash_steps input.units_t"), bihDefaults.TUNITS, mashEvent);
			popUnitSelect("#mash_vunits", LitersConvert);
			popUnitSelect("#mash_viunits", LitersConvert);
			popUnitSelect("#mash_munits", GramsConvert);
			popStepType(".steptype");
			calcClear("m");
		}
	);
</script>
<style>
</style>
<table id="tabMash" class="datagrid calculator" cellspacing="0">
	<caption>
		<div class="bih-grid-caption ui-widget-header">
			<span class="icons"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-trash" onclick="calcClear('m')" title="Clear Calculator"/></span>
			Mash Schedule
		</div>
	</caption>
	<tbody class="nobevel">
		<tr>
			<td class="miniHead">
				<div class="ui-widget-content">-- Mash Schedule --</div>
			</td>
		</tr>
		<tr>
			<td id="mash_steps">
				<table cellspacing="0">
					<thead class="bubbleHead">
					<tr>
						<th class="icon" width="20">&nbsp;</th>
						<th width="85">Step</th>
						<th width="60">Step Duration Minutes</th>
						<th width="60">Desired Mash Temp&nbsp;<button id="mash_tunits" value="F" class="butRotate tunits" style="display:inline" type="button">&deg;F</button></th>
						<th width="60">Current Malt Temp</th>
						<th width="60">Strike Water Temp</th>
						<th width="85">Strike Water <select class="bold center" id="mash_viunits" onchange="mashUnitsVolume(this)"></select></th>
						<th width="75">Total Malt <select class="bold center" id="mash_munits" onchange="mashUnitsWeight(this)"></select></select></th>
						<th width="85">Total Water <select class="bold center" id="mash_vunits" onchange="mashUnitsVolume(this)"></select></select></th>
						<th width="85">Mash Ratio <span class="mash_ratio_units"></span></th>
					</tr>
					</thead>
					<tbody>
						<tr class="inputrow" data-row="0">
							<td class="icon">&nbsp;</td>
							<td class="bold">Strike</td>
							<td class="center"><input type="text" class="decimal duration" maxlength="3" id="mash_duration0" /></th>
							<td class="center"><input type="text" class="decimal units_t" maxlength="5" id="mash_temp_f0" /></th>
							<td class="center"><input type="text" class="decimal units_t" maxlength="5" id="mash_temp_i0" /></td>
							<td class="center"><input type="text" class="decimal units_t" maxlength="5" id="mash_temp_a0" /></td>
							<td class="center"><input type="text" class="decimal units_vi" maxlength="7" id="mash_infuse0" /></td>
							<td class="center"><input type="text" class="decimal units_m" maxlength="5" id="mash_malt" /></td>
							<td class="center"><input type="text" class="decimal units_v" maxlength="7" id="mash_volume0" /></td>
							<td class="center"><input type="text" class="decimal units_m" maxlength="5" id="mash_ratio0" /></td>
						</tr>
					</tbody>
				</table>
				<table cellspacing="0">
					<thead class="bubbleHead">
					<tr>
						<th class="icon" width="20"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-circle-plus" onclick="mashStepAdd()" /></th>
						<th width="85">Step</th>
						<th width="60">Step Duration Minutes</th>
						<th width="60">Desired Mash Temp</th>
						<th width="60">Current Mash Temp</th>
						<th width="60">Infusion Temp</th>
						<th width="85">Infusion Volume</th>
						<th width="75">Decoction Weight</th>
						<th width="85">Total Water Volume</th>
						<th width="85">Mash Ratio <span class="mash_ratio_units"></span></th>
					</tr>
					</thead>
					<tbody id="mash_steps_rows">
						<tr class="inputrow" data-row="1">
							<td class="icon"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" id="btnMashStepDelete" src="ui-icon-trash" onclick="mashStepDelete()" /></th>
							<td class="center"><select class="steptype" id="mash_steptype1" onchange="mashStepType(this)"></select></td>
							<td class="center"><input type="text" class="decimal duration" maxlength="3" id="mash_duration1" /></th>
							<td class="center"><input type="text" class="decimal units_t" maxlength="5" id="mash_temp_f1" /></td>
							<td class="center"><input type="text" class="decimal units_t" maxlength="5" id="mash_temp_i1" /></td>
							<td class="center"><input type="text" class="decimal units_t" maxlength="5" id="mash_temp_a1" /></td>
							<td class="center"><input type="text" class="decimal units_vi" maxlength="7" id="mash_infuse1" /></td>
							<td class="center"><input type="text" class="decimal units_m" maxlength="7" id="mash_decoct1" style="display:none" /></td>
							<td class="center"><input type="text" class="decimal" maxlength="7" id="mash_volume1" disabled="disabled" /></td>
							<td class="center"><input type="text" class="decimal" maxlength="5" id="mash_ratio1" disabled="disabled" /></td>
						</tr>
					</tbody>
					<tfoot>
						<tr class="inputrow" data-row="2">
							<td class="icon">&nbsp;</td>
							<td class="center">&nbsp;</td>
							<td class="center"><input type="text" class="decimal duration" maxlength="7" id="mash_length" disabled="disabled" /></td>
							<td class="center">&nbsp;</td>
							<td class="center">&nbsp;</td>
							<td class="center">&nbsp;</td>
							<td class="center"><input type="text" class="decimal mash_vi" maxlength="7" id="mash_infuse_f" disabled="disabled" /></td>
							<td class="center">&nbsp;</td>
							<td class="center">&nbsp;</td>
						</tr>
					</tfoot>
				</table>
			</td>
		</tr>
		<tr><td class="miniHead"><div class="ui-widget-content">-- Malt --</div></td></tr>
		<tr>
			<td>
				<table cellspacing="0">
					<tbody class="bih-grid-form nobevel">
						<tr>
							<td class="unitlabel label">Malt Heat Capacity</td>
							<td class="unitinput"><input type="text" class="decimal duration" maxlength="5" id="mash_maltcap" /></td>
							<td>&nbsp;</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<table id="mash_stepAdd" style="display:none">
	<tr class="inputrow">
		<td class="icon"><cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" class="ui-button-icon-tiny" id="btnMashStepDelete" src="ui-icon-trash" onclick="mashStepDelete()" /></th>
		<td class="center"><select class="steptype" name="mash_steptype" onchange="mashStepType(this)"></select></td>
		<td class="center"><input type="text" class="decimal units_t" maxlength="5" name="mash_temp_f" /></th>
		<td class="center"><input type="text" class="decimal units_t" maxlength="5" name="mash_temp_i" /></td>
		<td class="center"><input type="text" class="decimal units_t" maxlength="5" name="mash_temp_a" /></td>
		<td class="center"><input type="text" class="decimal units_vi" maxlength="7" name="mash_infuse" /></td>
		<td class="center"><input type="text" class="decimal units_m" maxlength="7" name="mash_decoct" /></td>
		<td class="center"><input type="text" class="decimal" maxlength="7" name="mash_volume" disabled="disabled" /></td>
		<td class="center"><input type="text" class="decimal" maxlength="5" name="mash_ratio" disabled="disabled" /></td>
	</tr>
</table>