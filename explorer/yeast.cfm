<cfinvoke component="#APPLICATION.CFC.Javascript#" method="IncludeYeastJS" />
<div class="hide">
<table class="datagrid" id="tabYeast" cellspacing="0">
	<caption>Yeast Strains</caption>
	<thead>
		<tr>
			<th class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pin-w" onclick="pinToggle(this)" title="Pin"/></th>
			<th class="ye_yeast">Yeast</th>
			<th class="ye_mfg">Manufacturer</th>
			<th class="ye_mfgno">Mfg #</th>
			<th class="ye_type">Type</th>
			<th class="ye_atlow {sorter: 'digit'}">&laquo;At</th>
			<th class="ye_athigh {sorter: 'digit'}">At&raquo;</th>
<cfoutput>
			<th class="ye_templow {sorter: 'digit'}">&laquo;&deg;#SESSION.SETTING.TUNITS#</th>
			<th class="ye_temphigh {sorter: 'digit'}">&deg;#SESSION.SETTING.TUNITS#&raquo;</th>
</cfoutput>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-arrowthick-1-w" onclick="recipeYeastPick(this)" title="Select"/></td>
			<td class="ye_yeast"></td>
			<td class="ye_mfg"></td>
			<td class="ye_mfgno"></td>
			<td class="ye_type"></td>
			<td class="ye_atlow"></td>
			<td class="ye_athigh"></td>
			<td class="ye_templow"></td>
			<td class="ye_temphigh"></td>
		</tr>
	</tbody>
</table>
<table class="datagrid" id="infoYeast" cellspacing="0">
	<tbody class="bih-grid-form nobevel">
		<tr>
			<td class="label" width="105">Yeast:</td>
			<td class="ye_yeast"></td>
			<td class="label" width="105" title="Flocculation refers to the clumping of yeast cells at the end of fermentation. Strains are separated into three main degrees of flocculation- High, Medium, and Low. An example of a highly flocculent strain would be an English Ale yeast, which will settle at the bottom of the fermentation tank. An example of a low flocculent strain would be a Hefeweizen yeast.">Floculation:</td>
			<td class="ye_floc"></td>
		</tr>
		<tr>
			<td class="label">Manufacturer:</td>
			<td class="ye_mfg"></td>
			<td class="label" title="Attenuation is the percentage of sugars that the yeast consume during fermentation. If the fermentation went to 1.000 gravity, that would be 100% attenuation. Understanding the different attenuation ranges of each strain will help determine the terminal gravity of the beer.">Attenuation:</td>
			<td class="ye_at"></td>
		</tr>
		<tr>
			<td class="label">Mfg #:</td>
			<td class="ye_mfgno"></td>
			<td class="label">Temp Range:</td>
			<td class="ye_temp"></td>
		</tr>
		<tr>
			<td class="infoContent" colspan="4"><div class="ye_info infoDiv" name="ye_info"></div></td>
		</tr>
	</tbody>
</table>
</div>