<cfset BrewerFavs = APPLICATION.CFC.Recipe.QueryStatistics(re_usid=qryBrewer.us_usid) />
<cfoutput>
<div id="divStats">
	<div style="margin-bottom: 20px;">
		<div class="row head">
			<span class="type">Favorite Styles</span>
			<span class="cnt">Recipes</span>
			<span class="amt">#BrewerFavs.qryFavStyle.us_vunits#</span>
			<span class="lst">Last Brew</span>
		</div>
		<cfloop query="BrewerFavs.qryFavStyle">
			<div class="row">
				<span class="type">#re_style#</span>
				<span class="cnt">#cntStyle#</span>
				<span class="amt">#DecimalFormat(amtStyle)#</span>
				<span class="lst">#udfUserDateFormat(lastStyle)#</span>
			</div>
		</cfloop>
	</div>
	<div style="margin-bottom: 20px;">
		<div class="row head">
			<span class="type">Favorite Malt/Fermentable</span>
			<span class="cnt">Recipes</span>
			<span class="amt">#BrewerFavs.qryFavGrains.us_munits#</span>
			<span class="lst">Last Brew</span>
		</div>
		<cfloop query="BrewerFavs.qryFavGrains">
			<div class="row">
				<span class="type">#rg_maltster# #rg_type#</span>
				<span class="cnt">#cntGrain#</span>
				<span class="amt">#DecimalFormat(amtGrain)#</span>
				<span class="lst">#udfUserDateFormat(lastGrain)#</span>
			</div>
		</cfloop>
	</div>
	<div style="margin-bottom: 20px;">
		<div class="row head">
			<span class="type">Favorite Hops</span>
			<span class="cnt">Recipes</span>
			<span class="amt">#BrewerFavs.qryFavHops.us_munits#</span>
			<span class="lst">Last Brew</span>
		</div>
		<cfloop query="BrewerFavs.qryFavHops">
			<div class="row">
				<span class="type">#rh_grown# #rh_hop#</span>
				<span class="cnt">#cntHop#</span>
				<span class="amt">#DecimalFormat(amtHop)#</span>
				<span class="lst">#udfUserDateFormat(lastHop)#</span>
			</div>
		</cfloop>
	</div>
	<div style="margin-bottom: 20px;">
		<div class="row head">
			<span class="type">Favorite Yeast</span>
			<span class="cnt">Recipes</span>
			<span class="amt">#BrewerFavs.qryFavYeast.us_vunits#</span>
			<span class="lst">Last Brew</span>
		</div>
		<cfloop query="BrewerFavs.qryFavYeast">
			<div class="row">
				<span class="type">#ry_mfg# #ry_mfgno# #ry_yeast#</span>
				<span class="cnt">#cntYeast#</span>
				<span class="amt">#DecimalFormat(amtYeast)#</span>
				<span class="lst">#udfUserDateFormat(lastYeast)#</span>
			</div>
		</cfloop>
	</div>
</div>
</cfoutput>