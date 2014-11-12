<cfinvoke component="#APPLICATION.CFC.Javascript#" method="IncludeGrainsJS" />
<div class="hide">
<table class="datagrid" id="tabGrains" cellspacing="0">
	<caption>Malts/Fermentables</caption>
	<thead>
		<tr>
			<th class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pin-w" onclick="pinToggle(this)" title="Pin"/></th>
			<th class="gr_type">Type</th>
			<th class="gr_maltster">Mfg</th>
			<th class="gr_country">Cnt</th>
			<th class="gr_sgc {sorter: 'digit'}">SGC</th>
			<th class="gr_lvb {sorter: 'digit'}">SRM</th>
			<th class="gr_mash font8">Mash</th>
			<th class="gr_cat">Cat</th>
			<th class="gr_url">Url</th>
			<th class="gr_info {sorter: false}">Info</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-arrowthick-1-w" onclick="recipeGrainsPick(this)" title="Select"/></td>
			<td class="gr_type"></td>
			<td class="gr_maltster"></td>
			<td class="gr_country"><img src="images/trans.gif" class="flagSM"></td>
			<td class="gr_sgc right"></td>
			<td class="gr_lvb right"></td>
			<td class="gr_mash center"><img src="images/trans.gif" class="bih-tr-icon"/></td>
			<td class="gr_cat"></td>
			<td class="gr_url"></td>
			<td><div class="gr_info infochop"></div></td>
		</tr>
	</tbody>
</table>
<table class="datagrid" id="infoGrains" cellspacing="0">
	<tbody class="bih-grid-form nobevel">
		<tr>
			<td class="label" width="130">Malt/Fermentable:</td>
			<td class="gr_type"></td>
			<td class="label" width="125">S.G. Contr:</td>
			<td class="gr_sgc"></td>
		</tr>
		<tr>
			<td class="label">Maltster/Mfg:</td>
			<td class="gr_maltster"></td>
			<td class="label">Srm:</td>
			<td class="gr_lvb"></td>
		</tr>
		<tr>
			<td class="label">Country:</td>
			<td class="gr_country"><span></span>&nbsp;<img src="images/trans.gif" id="gr_country_icon" class="flagLG"></td>
			<td class="label">Mash Req:</td>
			<td class="gr_mash"><img src="images/trans.gif" class="bih-icon bih-icon-checked0"/></td>
		</tr>
		<tr>
			<td class="infoContent" colspan="4"><textarea class="gr_info infoDiv" name="gr_info" readonly="readonly"></textarea></td>
		</tr>
	</tbody>
</table>
</div>