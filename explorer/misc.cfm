<cfinvoke component="#APPLICATION.CFC.Javascript#" method="IncludeMiscJS" />
<div class="hide">
<table class="datagrid" id="tabMisc" cellspacing="0">
	<caption>Miscellaneous Ingredients</caption>
	<thead>
		<tr>
			<th class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pin-w" onclick="pinToggle(this)" title="Pin"/></th>
			<th class="mi_type">Misc Ingredient</th>
			<th class="mi_use">Use</th>
			<th class="mi_phase">Phase</th>
			<th class="mi_info {sorter: false}">Info</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-arrowthick-1-w" onclick="recipeMiscPick(this)" title="Select"/></td>
			<td class="mi_type"></td>
			<td class="mi_use"></td>
			<td class="mi_phase"></td>
			<td><div class="mi_info infochop"></div></td>
		</tr>
	</tbody>
</table>
<table class="datagrid" id="infoMisc" cellspacing="0">
	<tbody class="bih-grid-form nobevel">
		<tr>
			<td class="label" width="115">Misc Ingredient:</td>
			<td class="mi_type"></td>
			<td class="label" width="75">Brew Phase:</td>
			<td class="mi_phase"></td>
		</tr>
		<tr>
			<td class="label">Use:</td>
			<td class="mi_use"></td>
			<td class="label">Default Unit:</td>
			<td class="mi_unit"></td>
		</tr>
		<tr>
			<td class="infoContent" colspan="4"><div class="mi_info infoDiv" name="mi_info"></div></td>
		</tr>
	</tbody>
</table>
</div>