<cfset filter = StructNew() />
<cfif ArrayLen(REQUEST.URLTokens) GTE 2>
	<cfset toke = 2 />
	<cfif isNumeric(REQUEST.URLTokens[toke])>
		<cfset filter.ST_STID = REQUEST.URLTokens[toke] />
		<cfset toke = toke + 1 />
	<cfelse>
		<cfif REQUEST.URLTokens[toke] EQ "style">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.ST_STYLE = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelseif REQUEST.URLTokens[toke] EQ "substyle">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.ST_SUBSTYLE = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelseif REQUEST.URLTokens[toke] EQ "category">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.GR_CAT = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelse>
			<cfset filter.ST_SUBSTYLE = REQUEST.URLTokens[toke] />
		</cfif>
	</cfif>
</cfif>
<cfif NOT Len(StructKeyList(filter))><cfset filter = false /></cfif>
<script>
<cfoutput>
$.ajax({ url: "#APPLICATION.PATH.ROOT#/js/bjcpstyles_data.js", dataType: "script", cache: true, async: false });
$(document).ready(
	function() {
		selectFill(getById("dataSrcFld"), { Style:"ST_STYLE", Substyle:"ST_SUBSTYLE", Aroma:"ST_AROMA", Appearance:"ST_APPEARANCE", Flavor:"ST_FLAVOR", Mouthfeel:"ST_MOUTHFEEL", Impression:"ST_IMPRESSION", Ingredients:"ST_INGREDIENTS", Examples:"ST_EXAMPLES", History:"ST_HISTORY", Comments:"ST_COMMENTS" });
		dataInit("BJCPStyles", "BJCP Styles", "ST_STID", #SerializeJSON(filter)#, []);
	}
);
</cfoutput>
</script>
<ul id="dataView">
	<li class="ui-widget-content ui-corner-all">
		<table class="dataBJCP" cellspacing="5">
			<tbody class="bih-grid-form nobevel">
				<tr>
					<td width="300"><h2><a class="st_substyle"></a></h2></td>
					<td class="label" width="50">OG:</td>
					<td width="100"><h4><a class="st_og_min"></a><a class="st_og"> - </a><a class="st_og_max"></a></h4></td>
					<td class="label" width="50">IBU:</td>
					<td width="100"><h4><a class="st_ibu_min"></a><a class="st_ibu"> - </a><a class="st_ibu_max"></a></h4></td>
				</tr>
				<tr>
					<td><h3><a class="st_style"></a></h3></td>
					<td class="label">FG:</td>
					<td><h4><a class="st_fg_min"></a><a class="st_fg"> - </a><a class="st_fg_max"></a></h4></td>
					<td class="label">SRM:</td>
					<td><h4><a class="st_srm_min"></a><a class="st_srm"> - </a><a class="st_srm_max"></a></h4></td>
				</tr>
				<tr>
					<td><h3><a class="st_type"></a></h3></td>
					<td class="label">ABV:</td>
					<td><h4><a class="st_abv_min"></a><a class="st_abv"> - </a><a class="st_abv_max"></a></h4></td>
					<td class="label">CO2:</td>
					<td><h4><a class="st_co2_min"></a><a class="st_co2"> - </a><a class="st_co2_max"></a></h4></td>
				</tr>
			</tbody>
		</table>
	</li>
	<li id="dataSheet" class="ui-widget-content ui-corner-all">
		<table id="dataTable" cellspacing="10">
			<tbody class="bih-grid-form nobevel">
				<tr>
					<td width="300"><h2><a class="st_substyle"></a></h2></td>
					<td class="label" width="50">OG:</td>
					<td width="100"><h4><a class="st_og_min"></a><a class="st_og"> - </a><a class="st_og_max"></a></h4></td>
					<td class="label" width="50">IBU:</td>
					<td width="100"><h4><a class="st_ibu_min"></a><a class="st_ibu"> - </a><a class="st_ibu_max"></a></h4></td>
				</tr>
				<tr>
					<td><h3><a class="st_style"></a></h3></td>
					<td class="label">FG:</td>
					<td><h4><a class="st_fg_min"></a><a class="st_fg"> - </a><a class="st_fg_max"></a></h4></td>
					<td class="label">SRM:</td>
					<td><h4><a class="st_srm_min"></a><a class="st_srm"> - </a><a class="st_srm_max"></a></h4></td>
				</tr>
				<tr>
					<td><h3><a class="st_type"></a></h3></td>
					<td class="label">ABV:</td>
					<td><h4><a class="st_abv_min"></a><a class="st_abv"> - </a><a class="st_abv_max"></a></h4></td>
					<td class="label">CO2:</td>
					<td><h4><a class="st_co2_min"></a><a class="st_co2"> - </a><a class="st_co2_max"></a></h4></td>
				</tr>
			</tbody>
		</table>
		<ul class="infoStyle">
			<li class="st_aroma"><h5>Aroma</h5><div class="infoDiv"></div></li>
			<li class="st_appearance"><h5>Appearance</h5><div class="infoDiv"></div></li>
			<li class="st_flavor"><h5>Flavor</h5><div class="infoDiv"></div></li>
			<li class="st_mouthfeel"><h5>Mouthfeel</h5><div class="infoDiv"></div></li>
			<li class="st_impression"><h5>Impression</h5><div class="infoDiv"></div></li>
			<li class="st_comments"><h5>Comments</h5><div class="infoDiv"></div></li>
			<li class="st_history"><h5>History</h5><div class="infoDiv"></div></li>
			<li class="st_ingredients"><h5>Ingredients</h5><div class="infoDiv"></div></li>
			<li class="st_varieties"><h5>Varieties</h5><div class="infoDiv"></div></li>
			<li class="st_exceptions"><h5>Exceptions</h5><div class="infoDiv"></div></li>
			<li class="st_examples"><h5>Examples</h5><div class="infoDiv"></div></li>
		</ul>
	</li>
</ul>
