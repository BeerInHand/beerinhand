<cfinvoke component="#APPLICATION.CFC.Javascript#" method="IncludeHopsJS" />
<div class="hide">
<table class="datagrid" id="tabHops" cellspacing="0">
	<caption>Hops</caption>
	<thead>
		<tr>
			<th class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pin-w" onclick="pinToggle(this)" title="Pin"/></th>
			<th class="hp_hop">Type</th>
			<th class="hp_grown">Cnt</th>
			<th class="hp_bitter">Bit</th>
			<th class="hp_aroma">Aro</th>
			<th class="hp_dry">Dry</th>
			<th class="hp_aalow {sorter: 'digit'}">&laquo;Aau</th>
			<th class="hp_aahigh {sorter: 'digit'}">Aau&raquo;</th>
			<th class="hp_profile {sorter: false}">Profile</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-arrowthick-1-w" onclick="recipeHopsPick(this)" title="Select"/></td>
			<td class="hp_hop" width="120"></td>
			<td class="hp_grown"><img src="images/trans.gif" class="flagSM"></td>
			<td class="hp_bitter center"><img src="images/trans.gif" class="bih-icon"/></td>
			<td class="hp_aroma center"><img src="images/trans.gif" class="bih-icon"/></td>
			<td class="hp_dry center"><img src="images/trans.gif" class="bih-icon"/></td>
			<td class="hp_aalow right"></td>
			<td class="hp_aahigh right"></td>
			<td><div class="hp_profile infochop"></div></td>
		</tr>
	</tbody>
</table>
<table class="datagrid" id="infoHops" cellspacing="0">
	<tbody class="bih-grid-form nobevel">
		<tr>
			<td class="label" width="80">Hop:</td>
			<td class="hp_hop"></td>
			<td class="label" width="80">Bittering:</td>
			<td class="hp_bitter"><img src="images/trans.gif" class="bih-icon bih-icon-checked0"/></td>
		</tr>
		<tr>
			<td class="label">Country:</td>
			<td class="hp_grown"><span></span>&nbsp;<img src="images/trans.gif" class="flagLG"></td>
			<td class="label">Aroma:</td>
			<td class="hp_aroma"><img src="images/trans.gif" class="bih-icon bih-icon-checked0"/></td>
		</tr>
		<tr>
			<td class="label">AA Range:</td>
			<td class="hp_aa"></td>
			<td class="label">Dry Hop:</td>
			<td class="hp_dry"><img src="images/trans.gif" class="bih-icon bih-icon-checked0"/></td>
		</tr>
		<tr>
			<td class="infoContent" colspan="4"><div class="hp_info infoDiv" name="hp_info"></div></td>
		</tr>
	</tbody>
</table>
</div>