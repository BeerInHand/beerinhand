<cfset filter = StructNew() />

<cfif ArrayLen(REQUEST.URLTokens) GTE 2>
	<cfif REQUEST.URLTokens[1] EQ "style">
		<cfset filter.RE_STYLE = REQUEST.URLTokens[2] />
	<cfelseif REQUEST.URLTokens[1] EQ "name">
		<cfset filter.RE_NAME = REQUEST.URLTokens[2] />
	</cfif>
</cfif>

<cfoutput>
	<link href="#APPLICATION.PATH.ROOT#/css/ui.dynatree.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/jquery.dynatree.js"></script>
</cfoutput>
<cfif StructKeyExists(REQUEST, "brewer")>
	<cfset qryBrewLog = APPLICATION.CFC.Recipe.QueryBrewLog(re_usid = qryBrewer.us_usid) />
	<cfset nodesBrewLog = APPLICATION.CFC.Recipe.GetTreeNodes(re_usid = qryBrewer.us_usid) />
<cfelse>
	<cfset qryBrewLog = APPLICATION.CFC.Recipe.QueryBrewLog(re_usid = 0) />
	<cfset nodesBrewLog = APPLICATION.CFC.Recipe.GetTreeNodes(re_usid = 0) />
</cfif>

<cfoutput>
<script>
	qryBrewLog = #udfQueryToJSON(qryBrewLog)#;
	nodesBrewLog = #SerializeJSON(nodesBrewLog)#;
	$(document).ready(
		function() {
			brewlogInit(#SerializeJSON(filter)#);
			brewlogTree();
			$("##tabScrollBodyBrewLog td.fhref").on("click",brewerFilter);
		}
	);
</script>
<div class="bih-grid-caption ui-widget-header ui-corner-all hide" id="dataEmpty"><span>Your glass is empty.</span></div>
<cfif NOT qryBrewLog.RecordCount>
	<br/>
	<span class="imgbtn"><a href="http://www.beerinhand.com/p.recipe.cfm"><img src="#APPLICATION.PATH.IMG#/trans.gif" class="bih-icon bih-icon-pencilnew" /> Add A Recipe</a></span>
</cfif>
<div id="dataFull" class="hide">
<table class="datagrid" id="tabBrewLog" cellspacing="0">
	<caption>#qryBrewer.us_user#'s Recipes</caption>
	<thead>
		<tr>
			<th class="icon bl_icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-circle-plus" onclick="brewerOpen(this)" title="Add Recipe"/></th>
			<th class="icon bl_icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-script" title="View Recipe"/></th>
			<th class="bl_name" data-filter="RE_NAME">Name</th>
			<th class="bl_style" data-filter="RE_STYLE">Style</th>
			<th class="bl_brewed {sorter: 'bihDate'}">Brewed</th>
			<th class="bl_volume {sorter: 'digit'}" id="exp_vunits" data-filter="RE_VOLUME">Gallons</th>
			<th class="bl_expgrv {sorter: 'digit'}" id="exp_eunits" data-filter="RE_EXPGRV">Grav</th>
			<th class="bl_expibu {sorter: 'digit'}" data-filter="RE_EXPIBU">IBU</th>
			<th class="bl_expsrm {sorter: 'digit'}" data-filter="RE_EXPSRM">SRM</th>
			<th class="bl_eff {sorter: 'digit'}" data-filter="RE_EFF">Eff</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="icon iconedit bl_icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-pencil" onclick="brewerOpen(this)" title="Edit"/></td>
			<td class="icon iconview bl_icon"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-icon-tiny" src="ui-icon-script" onclick="brewerView(this)" title="View"/></td>
			<td class="bl_name fhref"></td>
			<td class="bl_style fhref"></td>
			<td class="bl_brewed"></td>
			<td class="bl_volume fhref"></td>
			<td class="bl_expgrv fhref"></td>
			<td class="bl_expibu fhref"></td>
			<td class="bl_expsrm fhref"></td>
			<td class="bl_eff fhref"></td>
		</tr>
	</tbody>
	<tfoot>
		<tr>
			<th class="icon">&nbsp;</th>
			<th class="icon">&nbsp;</th>
			<th id="bl_cnt" class="bl_name">0 Records</th>
			<th id="bl_total" class="bl_style">0 Gallons</th>
			<th class="bl_brewed font7">Averages</th>
			<th id="bl_avgvolume" class="bl_volume">0.00</th>
			<th id="bl_avggrv" class="bl_expgrv">1.000</th>
			<th id="bl_avgibu" class="bl_expibu">0</th>
			<th id="bl_avgsrm" class="bl_expsrm">0.0</th>
			<th id="bl_avgeff" class="bl_eff">75</th>
		</tr>
	</tfoot>
</table>
</div>
</cfoutput>