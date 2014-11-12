<cfparam name="REQUEST.recipe" default="0" />
<cfset RCP = APPLICATION.CFC.Recipe.Fetch(REQUEST.recipe).RCP />
<cfoutput>
<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/css/print.css" media="print" />
<script>
	var RCP = #SerializeJSON(RCP)#;
	recipeHashable(RCP);
</script>
</cfoutput>
<script>
	rvScaleRecipe = function(which) {
		var qryRecipe = RCP.qryRecipe.DATA[0];
		var total = 0;
		var amt = 0;
		var HCU = 0;
		var ibu = 0;
		var tibu = 0;
		if (which==0) {
			var oVUNIT = nVUNIT = qryRecipe.RE_VUNITS;
			var oMUNIT = nMUNIT = qryRecipe.RE_MUNITS;
			var oHUNIT = nHUNIT = qryRecipe.RE_HUNITS;
			var newVolume = qryRecipe.RE_VOLUME;
		} else {
			var oVUNIT = qryRecipe.RE_VUNITS;
			var nVUNIT = bihDefaults.VUNITS;
			var oMUNIT = qryRecipe.RE_MUNITS;
			var nMUNIT = bihDefaults.MUNITS;
			var oHUNIT = qryRecipe.RE_HUNITS;
			var nHUNIT = bihDefaults.HUNITS;
			var newVolume = bihDefaults.VOLUME;
		}
		if (which==2) {
			newVolume = convertVolume("Liters", getById("to_s4").value, nVUNIT);
			var cnt = 0;
			for (var unit in ScaleConvert) {
				amt = parseFloat(getById("un_s"+cnt).value);
				total = parseFloat(getById("to_s"+cnt).value);
				if (amt==total) {
					nVUNIT = unit;
					newVolume = amt;
					break;
				}
				cnt++;
			}
		}
		var oldVolume = convertVolume(oVUNIT, qryRecipe.RE_VOLUME, nVUNIT);;
		if (oldVolume==0) return;
		var ratio = newVolume / oldVolume;
		$(".re_volume").html(newVolume.toFixed(2) + " " + nVUNIT);
//		newVolume = qryRecipe.RE_BOILVOL * ratio;	$(".re_boilvol").html(newVolume.toFixed(2));
		total = 0;
		$(".re_munits").html(nMUNIT);
		for (var i=0;i<RCP.qryRecipeGrains.DATA.length; i++) {
			amt = RCP.qryRecipeGrains.DATA[i].RG_AMOUNT || 0;
			amt = convertWeight(oMUNIT, amt * ratio, nMUNIT);
			HCU += RCP.qryRecipeGrains.DATA[i].RG_LVB * amt;
			$("#rg"+i+" .rg_amount").html(amt.toFixed(2));
			total += amt;
		}
		HCU = convertSRM(convertWeight(nMUNIT, HCU, "Lbs") / convertVolume(nVUNIT, newVolume, "Gallons"));
		$(".re_expsrm").html(HCU);
		$(".re_grnamt").html(total.toFixed(2));
		total = 0;
		$(".re_hunits").html(nHUNIT);
		for (var i=0;i<RCP.qryRecipeHops.DATA.length; i++) {
			ibu = ibuIBUFromAmount(qryRecipe.RE_VUNITS, qryRecipe.RE_VOLUME, qryRecipe.RE_EUNITS, qryRecipe.RE_EXPGRV, qryRecipe.RE_HUNITS, RCP.qryRecipeHops.DATA[i].RH_AMOUNT, RCP.qryRecipeHops.DATA[i].RH_AAU, RCP.qryRecipeHops.DATA[i].RH_FORM, RCP.qryRecipeHops.DATA[i].RH_TIME, RCP.qryRecipeHops.DATA[i].RH_WHEN, qryRecipe.RE_BOILVOL);
			amt = RCP.qryRecipeHops.DATA[i].RH_AMOUNT || 0;
			amt = convertWeight(oHUNIT, amt * ratio, nHUNIT);
			$("#rh"+i+" .rh_amount").html(amt.toFixed(2));
			$("#rh"+i+" .rh_ibu").html(ibu.toFixed(1));
			total += amt;
			tibu += ibu;
		}
		$(".re_hopamt").html(total.toFixed(2));
		$(".re_expibu").html(tibu.toFixed(0));
		for (var i=0;i<RCP.qryRecipeMisc.DATA.length; i++) {
			amt = RCP.qryRecipeMisc.DATA[i].RM_AMOUNT || 0;
			var nUnit = RCP.qryRecipeMisc.DATA[i].RM_UNIT;
			if (RCP.qryRecipeMisc.DATA[i].RM_UTYPE=="W" && nUnit==oMUNIT) {
				amt = convertWeight(oMUNIT, amt, nMUNIT).toFixed(2);
				nUnit = nMUNIT;
			} else if (RCP.qryRecipeMisc.DATA[i].RM_UTYPE=="W" && nUnit==oHUNIT) {
				amt = convertWeight(oHUNIT, amt, nHUNIT).toFixed(2);
				nUnit = nHUNIT;
			} else if (RCP.qryRecipeMisc.DATA[i].RM_UTYPE=="V" && nUnit==oVUNIT) {
				amt = convertVolume(oVUNIT, amt, nVUNIT).toFixed(2);
				nUnit = nVUNIT;
			}
			$("#rm"+i+" .rm_amount").html((amt * ratio).toFixed(2));
			$("#rm"+i+" .rm_unit").html(nUnit);
		}
	}

	rvScaleShow = function() {
		$winModal.dialog("open");
	}
	$(document).ready(
		function() {
			rvScaleRecipe(0);
			ucalcBuild("tabVolume", "s", ScaleConvert);
			$winModal = $("#winModal").dialog(
				{autoOpen: false, width: "auto", modal: true,
					buttons: {
						"Scale": function() { $(this).dialog("close"); rvScaleRecipe(2); },
						"Clear": function() { calcClear("s"); },
						"Cancel": function() { $(this).dialog("close"); }
					}
				}
			);
		}
	);

</script>
<style>
#recipeView { width: 735px; }
#recipeView div.header { font-variant: small-caps; text-transform: capitalize; font-family: "Cuprum"; font-weight: bold; margin-bottom: 5px; padding: 5px 10px;}
#recipeView div.head30 { font-size: 30pt; line-height: 34px; }
#recipeView div.head20 { font-size: 20pt; line-height: 34px; }
#recipeView div.head16 { font-size: 16pt; line-height: 34px; }
#recipeView table { font-size: 13pt; padding-bottom: 10px; }
#recipeView table th, #recipeView table td { padding: 1px 10px; }
#recipeView table.lines th { font-variant: small-caps; font-family: "Cuprum"; font-size: 15pt; font-weight:normal; color: #666666; }
#recipeView table.lines th.head { font-size: 18pt; }
#recipeView table.lines thead th { border-bottom: 1px solid #666666;  }
#recipeView table.lines tfoot th, #recipeView table.lines tfoot td { border-top: 1px dashed #666666; padding-top: 5px; }
#recipeView #rvButtons { margin-bottom: 5px; height: 23px; padding: 5px; }
#recipeView #rvButtons button { height: 23px; margin: 0 3px; }
</style>

<cfoutput>

	<div class="clearer"></div>
<div id="recipeView">
	<div id="rvButtons" class="ui-widget-header ui-corner-all">
		<div class="btnleft">
		<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" id="btnRecipeScale" src="ui-icon-signal" class="fleft" onclick="rvScaleShow(this)" title="Scale" />
		<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-arrowrefresh-1-w" class="ui-button-text-tiny smallcaps fleft" onclick="rvScaleRecipe(0)" text="Original" title="Reset to original saved recipe." />
		<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton"  src="ui-icon-person" class="ui-button-text-tiny smallcaps fleft"  onclick="rvScaleRecipe(1)" text="Defaults" title="Scale to #SESSION.SETTING.volume# #SESSION.SETTING.vunits#." />
		</div>
		<div class="fright">
			<cfif SESSION.LoggedIn AND NOT isUserBrewer>
				<cfset isFollowing = APPLICATION.CFC.Factory.get("FollowUser").QueryFollowing(SESSION.USER.usid, qryBrewer.us_usid).RecordCount />
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny smallcaps" src="ui-icon-#IIF(isFollowing, DE("minus"), DE("star"))#" onclick="brewerFavorite(#REQUEST.recipe#)" text="Favorite" />
			</cfif>
			<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny smallcaps" src="ui-icon-pencil" href="#APPLICATION.PATH.ROOT#/p.recipe.cfm?reid=#REQUEST.recipe#" text="Edit" />
			<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny smallcaps" src="ui-icon-print" onclick="window.print();return false;" text="Print" />
		</div>
	</div>
	<div class="header ui-widget-content ui-corner-all">
		<div class="fleft">
			<div class="head30">#RCP.qryRecipe.re_name#</div>
			<div class="head20">#RCP.qryRecipe.re_style#</div>
			<div class="head20 re_volume">#RCP.qryRecipe.re_volume# #RCP.qryRecipe.re_vunits#</div>
		</div>
		<div class="fright right head20">
			<span class="re_expibu">#RCP.qryRecipe.re_expibu#</span> IBU
			<br/>
			#RCP.qryRecipe.re_expabv#% ABV
			<br/>
			#RCP.qryRecipe.re_expsrm# SRM
		</div>
		<div class="clearer"></div>
	</div>
	<div class="content ui-widget-content pad5 ui-corner-all">
	<table class="lines" width="100%" cellspacing="0">
		<thead>
		<tr>
			<th class="head">Malts/Fermentables</td>
			<th>Maltster</th>
			<th class="center">Mash</th>
			<th class="right re_munits">#RCP.qryRecipe.re_munits#</th>
			<th class="right">SGC</th>
			<th class="right">SRM</th>
			<th class="right">%</th>
		</tr>
		<thead>
		<tbody>
		<cfloop query="RCP.qryRecipeGrains">
			<tr id="rg#CurrentRow-1#">
				<td class="rg_type">#rg_type#</td>
				<td class="rg_maltster">#rg_maltster#</td>
				<td class="rg_mash center"><img class="bih-icon bih-icon-checked#rg_mash#" src="#APPLICATION.PATH.IMG#/trans.gif" /></td>
				<td class="rg_amount right">#rg_amount#</td>
				<td class="rg_sgc right">#rg_sgc#</td>
				<td class="rg_lvb right">#rg_lvb#</td>
				<td class="rg_pct right">#rg_pct#</td>
			</tr>
		</cfloop>
		</tbody>
		<tfoot>
			<tr>
				<th class="label">Mash Efficiency:</th>
				<td class="left">#RCP.qryRecipe.re_eff# %</td>
				<th>&nbsp;</th>
				<td class="right re_grnamt">#RCP.qryRecipe.re_grnamt#</td>
				<td class="right">#RCP.qryRecipe.re_expgrv#</td>
				<td class="right">#RCP.qryRecipe.re_expsrm#</td>
				<th class="right">&nbsp;</th>
			</tr>
		</tfoot>
	</table>
	<table class="lines" width="100%" cellspacing="0">
		<thead>
			<tr>
				<th class="head">Hops</th>
				<th>Grown</th>
				<th>Form</th>
				<th class="right">AAU</th>
				<th class="right re_hunits">#RCP.qryRecipe.re_hunits#</th>
				<th>When</th>
				<th class="right">Min</th>
				<th class="right">IBU</th>
			</tr>
		</thead>
		<tbody>
		<cfloop query="RCP.qryRecipeHops">
			<tr id="rh#CurrentRow-1#">
				<td class="rh_hop">#rh_hop#</td>
				<td class="rh_grown">#rh_grown#</td>
				<td class="rh_form">#rh_form#</td>
				<td class="rh_aau right">#rh_aau#</td>
				<td class="rh_amount right">#rh_amount#</td>
				<td class="rh_when">#rh_when#</td>
				<td class="rh_time right">#rh_time#</td>
				<td class="rh_ibu right">#rh_ibu#</td>
			</tr>
		</cfloop>
		</tbody>
		<tfoot>
			<tr>
				<!--- <th class="label">Boil Volume: </th><td class="left re_boilvol">#RCP.qryRecipe.re_boilvol#</td> --->
				<th>&nbsp;</th>
				<th>&nbsp;</th>
				<th>&nbsp;</th>
				<th>&nbsp;</th>
				<td class="right re_hopamt">#RCP.qryRecipe.re_hopamt#</td>
				<th>&nbsp;</th>
				<th>&nbsp;</th>
				<td class="right re_expibu">#RCP.qryRecipe.re_expibu#</td>
			</tr>
		</tfoot>
	</table>
<cfif RCP.qryRecipeMisc.RecordCount>
	<table class="lines" width="100%" cellspacing="0">
		<thead>
			<tr>
				<th class="head">Misc Ingredients</td>
				<th class="right">Amount</th>
				<th>Units</th>
				<th>Phase</th>
				<th>Time Added</th>
				<th>Action</th>
			</tr>
		</thead>
		<tbody>
		<cfloop query="RCP.qryRecipeMisc">
			<tr id="rm#CurrentRow-1#">
				<td class="rm_type">#rm_type#</td>
				<td class="rm_amount right">#rm_amount#</td>
				<td class="rm_unit">#rm_unit#</td>
				<td class="rm_phase">#rm_phase#</td>
				<td class="rm_offset">#rm_offset# #rm_added#</td>
				<td class="rm_action">#rm_action#</td>
			</tr>
		</cfloop>
		</tbody>
	</table>
</cfif>
<cfif RCP.qryRecipeYeast.RecordCount>
	<table class="lines" width="100%" cellspacing="0">
		<thead>
			<tr>
				<th class="head">Yeast</th>
			</tr>
		</thead>
		<tbody>
		<cfloop query="RCP.qryRecipeYeast">
			<tr id="ry#CurrentRow-1#">
				<td class="ry_yeast">#ry_mfg# #ry_mfgno# #ry_yeast#</td>
			</tr>
			<cfif Len(ry_note)>
				<tr id="ry#CurrentRow-1#b" class="top">
					<td class="ry_note"><div class="notes">#ReplaceNoCase(ry_note, "|", "<br/>", "ALL")#</div></td>
				</tr>
			</cfif>
		</tbody>
		</cfloop>
	</table>
</cfif>
<cfif RCP.qryRecipeDates.RecordCount>
	<table class="lines" width="100%" cellspacing="0">
		<thead>
			<tr>
				<th class="head">Dates</th>
				<th>Activity</th>
				<th class="re_eunits center">#RCP.qryRecipe.re_eunits#</th>
				<th class="re_tunits center">&deg;#RCP.qryRecipe.re_tunits#</th>
				<th width="400"></th>
			</tr>
		</thead>
		<tbody>
		<cfloop query="RCP.qryRecipeDates">
			<tr id="rd#CurrentRow-1#" class="top">
				<td class="rd_date">#udfUserDateFormat(rd_date)#</td>
				<td class="rd_type">#rd_type#</td>
				<td class="rd_gravity">#rd_gravity#</td>
				<td class="rd_temp">#rd_temp#</td>
				<td class="rd_note"></td>
			</tr>
			<cfif Len(rd_note)>
				<tr id="rd#CurrentRow-1#b" class="top">
					<td class="rd_note" colspan="5"><div class="notes ui-corner-all">#ReplaceNoCase(rd_note, "|", "<br/>", "ALL")#</div></td>
				</tr>
			</cfif>
		</cfloop>
		</tbody>
	</table>
</cfif>
	</div>
</div>

<div id="winModal" title="Scale Recipe" style="display:none">
<table id="tabVolume" class="datagrid calculator" cellspacing="0">
	<tbody class="bih-grid-form nobevel"><tr><td class="unitlabel label" width="100"></td><td class="unitinput"></td><td class="unittotal"></td></tr></tbody>
</table>
</div>
</cfoutput>
