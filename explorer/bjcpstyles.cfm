<cfinvoke component="#APPLICATION.CFC.Javascript#" method="IncludeBJCPStylesJS" />
<div class="hide">
<table class="datagrid" id="tabBJCPStyles" cellspacing="0">
	<caption>Bjcp Recognized Styles</caption>
	<thead>
		<tr>
			<th class="bih-grid-header bih-grid-sort-no spanCol" colspan="4"><a class="font8" href="http://www.bjcp.org/" target="_blank">Bjcp Style Guidelines</a></th>
			<th class="bih-grid-header bih-grid-sort-no spanCol" colspan="2">OG</th>
			<th class="bih-grid-header bih-grid-sort-no spanCol" colspan="2">FG</th>
			<th class="bih-grid-header bih-grid-sort-no spanCol" colspan="2">IBU</th>
			<th class="bih-grid-header bih-grid-sort-no spanCol" colspan="2">SRM</th>
			<th class="bih-grid-header bih-grid-sort-no spanCol" colspan="2">ABV</th>
		</tr>
		<tr>
			<th class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pin-w" onclick="pinToggle(this)" title="Pin"/></th>
			<th class="st_subcategory">Cat</th>
			<th class="st_substyle">Style</th>
			<th class="st_type">Type</th>
			<th class="st_og_min {sorter: 'digit'}">Min</th>
			<th class="st_og_max {sorter: 'digit'}">Max</th>
			<th class="st_fg_min {sorter: 'digit'}">Min</th>
			<th class="st_fg_max {sorter: 'digit'}">Max</th>
			<th class="st_ibu_min {sorter: 'digit'}">Min</th>
			<th class="st_ibu_max {sorter: 'digit'}">Max</th>
			<th class="st_srm_min {sorter: 'digit'}">Min</th>
			<th class="st_srm_max {sorter: 'digit'}">Max</th>
			<th class="st_abv_min {sorter: 'digit'}">Min</th>
			<th class="st_abv_max {sorter: 'digit'}">Max</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-arrowthick-1-w" onclick="clickStyle(this)" title="Select"/></td>
			<td class="st_subcategory"></td>
			<td class="st_substyle"></td>
			<td class="st_type"></td>
			<td class="st_og_min right"></td>
			<td class="st_og_max right"></td>
			<td class="st_fg_min right"></td>
			<td class="st_fg_max right"></td>
			<td class="st_ibu_min right"></td>
			<td class="st_ibu_max right"></td>
			<td class="st_srm_min right"></td>
			<td class="st_srm_max right"></td>
			<td class="st_abv_min right"></td>
			<td class="st_abv_max right"></td>
		</tr>
	</tbody>
</table>
<table class="datagrid" id="infoBJCPStyles" cellspacing="0">
	<tbody class="bih-grid-form nobevel">
		<tr>
			<td class="label" width="70">Category:</td>
			<td class="st_subcategory"></td>
			<td class="label" width="30">OG:</td>
			<td class="st_og" width="95"></td>
			<td class="label" width="61">IBU:</td>
			<td class="st_ibu" width="85"></td>
		</tr>
		<tr>
			<td class="label">Style:</td>
			<td class="st_substyle"></td>
			<td class="label">FG:</td>
			<td class="st_fg"></td>
			<td class="label">SRM:</td>
			<td class="st_srm"></td>
		</tr>
		<tr>
			<td class="label">Type:</td>
			<td class="st_type"></td>
			<td class="label">ABV:</td>
			<td class="st_abv"></td>
			<td class="label">CO2:</td>
			<td class="st_co2"></td>
		</tr>
		<tr>
			<td  class="infoContent" colspan="6">
				<div id="divStylesTabs">
					<ul style="overflow: hidden; height: 19px;">
						<li id="tabsStylesAroma"			class="tabShow easing"><a href="#divStylesAroma">Aroma</a></li>
						<li id="tabsStylesAppearance"	class="tabShow easing"><a href="#divStylesAppearance">Appearance</a></li>
						<li id="tabsStylesFlavor"			class="tabShow easing"><a href="#divStylesFlavor">Flavor</a></li>
						<li id="tabsStylesMouthfeel"		class="tabShow easing"><a href="#divStylesMouthfeel">Mouthfeel</a></li>
						<li id="tabsStylesImpression"	class="tabShow easing"><a href="#divStylesImpression">Impression</a></li>
						<li id="tabsStylesComments"		class="tabShow easing"><a href="#divStylesComments">Comments</a></li>
						<li id="tabsStylesHistory"		class="tabShow easing"><a href="#divStylesHistory">History</a></li>
						<li id="tabsStylesIngredients"	class="tabShow easing"><a href="#divStylesIngredients">Ingredients</a></li>
						<li id="tabsStylesVarieties"		class="tabShow easing"><a href="#divStylesVarieties">Varieties</a></li>
						<li id="tabsStylesExceptions"	class="tabShow easing"><a href="#divStylesExceptions">Exceptions</a></li>
						<li id="tabsStylesExamples"		class="tabShow easing"><a href="#divStylesExamples">Examples</a></li>
					</ul>
					<div id="divStylesAroma"			class="infoDiv st_aroma"></div>
					<div id="divStylesAppearance"		class="infoDiv st_appearance"></div>
					<div id="divStylesFlavor"			class="infoDiv st_flavor"></div>
					<div id="divStylesMouthfeel"		class="infoDiv st_mouthfeel"></div>
					<div id="divStylesImpression"		class="infoDiv st_impression"></div>
					<div id="divStylesComments"		class="infoDiv st_comments"></div>
					<div id="divStylesHistory"			class="infoDiv st_history"></div>
					<div id="divStylesIngredients"	class="infoDiv st_ingredients"></div>
					<div id="divStylesVarieties"		class="infoDiv st_varieties"></div>
					<div id="divStylesExceptions"		class="infoDiv st_exceptions"></div>
					<div id="divStylesExamples"		class="infoDiv st_examples"></div>
				</div>
			</td>
		</tr>
	</tbody>
</table>
</div>