<cfinvoke component="#APPLICATION.CFC.Javascript#" method="IncludeBrewLogJS" />
<cfif NOT SESSION.LoggedIn>
	<div class="ui-widget-content ui-corner-all" style="margin:10px; padding: 10px;">
		<p>You are not logged in. While recipes can be saved in your browser's local storage, they can only be seen from this computer and cannot be shared with others.</p>
		<p>The fully experience the BeerInHand.com community, we recommend you create an account and save your recipes in the brewcloud.</p>
		<p id="brewlogMsg">Listed below are the recipes that were found stored locally on this computer.</p>
	</div>
</cfif>
<table class="datagrid" id="tabBrewLog" cellspacing="0">
	<caption>Brew Log</caption>
	<thead>
		<tr>
			<th class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-circle-plus" onclick="recipeOpen(this)" title="Add"/></th>
			<th class="bl_name">Name</th>
			<th class="bl_style">Style</th>
			<th class="bl_brewed {sorter: 'bihDate'}">Brewed</th>
			<th class="bl_volume {sorter: 'digit'}" id="exp_vunits">Gallons</th>
			<th class="bl_expgrv {sorter: 'digit'}" id="exp_eunits">Grav</th>
			<th class="bl_expibu {sorter: 'digit'}">IBU</th>
			<th class="bl_expsrm {sorter: 'digit'}">SRM</th>
			<th class="bl_eff {sorter: 'digit'}">Eff</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pencil" onclick="recipeOpen(this)" title="Edit"/></td>
			<td class="bl_name"></td>
			<td class="bl_style"></td>
			<td class="bl_brewed"></td>
			<td class="bl_volume"></td>
			<td class="bl_expgrv"></td>
			<td class="bl_expibu"></td>
			<td class="bl_expsrm"></td>
			<td class="bl_eff"></td>
		</tr>
	</tbody>
	<tfoot>
		<tr>
			<th class="icon">&nbsp;</th>
			<th id="bl_cnt" class="bl_name">0 Records</th>
			<th id="bl_total" class="bl_style">0 Gallons</th>
			<th class="bl_brewed font7">Averages:</th>
			<th id="bl_avgvolume" class="bl_volume">0.00</th>
			<th id="bl_avggrv" class="bl_expgrv">1.000</th>
			<th id="bl_avgibu" class="bl_expibu">0</th>
			<th id="bl_avgsrm" class="bl_expsrm">0.0</th>
			<th id="bl_avgeff" class="bl_eff">75</th>
		</tr>
	</tfoot>
</table>