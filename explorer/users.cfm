<cfinvoke component="#APPLICATION.CFC.Javascript#" method="IncludeUsersJS" />
<div class="hide">
<table class="datagrid tabUsers" id="tabUsers" cellspacing="0">
	<caption>Brewers</caption>
	<thead>
		<tr>
			<th class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pin-w" onclick="pinToggle(this)" title="Pin"/></th>
			<th class="us_user">Brewer</th>
			<th class="us_mashtype">Mash Type</th>
			<th class="us_postal">Location</th>
			<th class="us_volume {sorter: 'digit'}">Volume</th>
			<th class="us_vunits">Units</th>
			<th class="us_recipecnt {sorter: 'digit'}">Recipes</th>
			<th class="us_brewcnt {sorter: 'digit'}">Brews</th>
			<th class="us_brewamt {sorter: 'digit'}"><cfoutput>#SESSION.SETTING.VUNITS#</cfoutput></th>
			<th class="us_dla {sorter: 'bihDate'}">DLA</th>
			<th class="us_added {sorter: 'bihDate'}">Joined</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-document" onclick="userexpPick(this)" title="Open"/></td>
			<td class="us_user"></td>
			<td class="us_mashtype"></td>
			<td class="us_postal"></td>
			<td class="us_volume"></td>
			<td class="us_vunits"></td>
			<td class="us_recipecnt"></td>
			<td class="us_brewcnt"></td>
			<td class="us_brewamt"></td>
			<td class="us_dla"></td>
			<td class="us_added"></td>
		</tr>
	</tbody>
</table>

<table class="datagrid" id="infoUsers" cellspacing="0">
	<caption>
		<div class="ui-widget-content left">
			<h2><a class="us_user"></a></h2>
			<span class="dates fright"><span class="us_dla"></span><span class="us_added"></span></span>
		</div>
	</caption>
	<tbody class="bih-grid-form nobevel">
		<tr>
			<td>
				<table width="284">
					<tr><td class="label" width="100">Name:</td><td class="us_name"></td></tr>
					<tr><td class="label">Where:</td><td class="us_postal"></td></tr>
					<tr><td class="label">Mash Type:</td><td class="us_mashtype"></td></tr>
					<tr><td class="label">Batch Size:</td><td class="us_volume"></td></tr>
					<tr><td class="label">Recipe Count:</td><td class="us_recipecnt"></td></tr>
					<tr><td class="label">Batches Brewed:</td><td class="us_brewcnt"></td></tr>
					<tr><td class="label">Amount Brewed:</td><td class="us_brewamt"></td></tr>
				</table>
			</td>
			<td>
				<table width="275">
					<tr><td class="label" width="100">Gravity Units:</td><td class="us_eunits"></td></tr>
					<tr><td class="label">Temp Units:</td><td class="us_tunits"></td></tr>
					<tr><td class="label">Grain Units:</td><td class="us_munits"></td></tr>
					<tr><td class="label">Hop Units:</td><td class="us_hunits"></td></tr>
					<tr><td class="label">Primer:</td><td class="us_primer"></td></tr>
					<tr><td class="label">Joined:</td><td class="us_added"></td></tr>
					<tr><td class="label">DLA:</td><td class="us_dla"></td></tr>
				</table>
			</td>
			<td width="150" class="profile">
				<img class="avatar" src="#udfAvatarSrc()#" />
			</td>
		</tr>
	</tbody>
</table>
</div>