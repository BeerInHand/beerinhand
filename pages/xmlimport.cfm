<cfset RSP = APPLICATION.CFC.Recipe.Fetch(-1) />
<cfset RCPS = ArrayNew(1) />

<cffunction name="setDefault" access="public" returntype="string" output="false">
	<cfargument name="inVal" type="string" required="true" />
	<cfargument name="inDef" type="string" required="false" default="&nbsp;" />
	<cfif Trim(ARGUMENTS.inVal) is ""><cfreturn ARGUMENTS.inDef /></cfif>
	<cfreturn ARGUMENTS.inVal />
</cffunction>
<cffunction name="convertTemp" access="public" returntype="string" output="false">
	<cfargument name="inU" type="string" required="true" />
	<cfargument name="inT" type="numeric" required="true" />
	<cfargument name="outU" type="string" required="true" />
	<cfif ARGUMENTS.inU eq ARGUMENTS.outU><cfreturn ARGUMENTS.inT /></cfif>
	<cfif ARGUMENTS.inU eq "f"><cfreturn (ARGUMENTS.inT-32)/1.8 /></cfif>
	<cfreturn ARGUMENTS.inT * 1.8 + 32 />
</cffunction>
<cffunction name="convertVolume" access="public" returntype="string" output="false">
	<cfargument name="UnitsIn" type="string" required="true" />
	<cfargument name="VolumeIn" type="numeric" required="true" />
	<cfargument name="UnitsOut" type="string" required="true" />
	<cfset LOCAL.LitersConvert = {Barrels=117.347772,Hectoliters=100,"Imp Gallons"=4.54609,Gallons=3.785412,Liters=1,Quarts=0.946353,Pints=0.4731765,Cups=0.2365883,Ounces=0.0295735,"Imp Ounces"=0.0284131,Tablespoons=0.0147868,Teaspoons=0.0049289} />
	<cfif ARGUMENTS.UnitsIn eq ARGUMENTS.UnitsOut><cfreturn ARGUMENTS.VolumeIn /></cfif>
	<cfreturn ARGUMENTS.VolumeIn * LOCAL.LitersConvert[ARGUMENTS.UnitsIn] / LOCAL.LitersConvert[ARGUMENTS.UnitsOut] />
</cffunction>
<cffunction name="convertWeight" access="public" returntype="string" output="false">
	<cfargument name="UnitsIn" type="string" required="true" />
	<cfargument name="WeightIn" type="numeric" required="true" />
	<cfargument name="UnitsOut" type="string" required="true" />
	<cfset LOCAL.GramsConvert={Kg=1000,Lbs=453.59237,Ounces=28.3495231,Grams=1} />
	<cfif ARGUMENTS.UnitsIn eq ARGUMENTS.UnitsOut><cfreturn ARGUMENTS.WeightIn /></cfif>
	<cfreturn ARGUMENTS.WeightIn * LOCAL.GramsConvert[ARGUMENTS.UnitsIn] / LOCAL.GramsConvert[ARGUMENTS.UnitsOut] />
</cffunction>
<cffunction name="convertGravity" access="public" returntype="string" output="false">
	<cfargument name="UnitsIn" type="string" required="true" />
	<cfargument name="GravityIn" type="numeric" required="true" />
	<cfargument name="UnitsOut" type="string" required="true" />
	<cfif ARGUMENTS.UnitsIn eq ARGUMENTS.UnitsOut || ARGUMENTS.GravityIn EQ 0><cfreturn ARGUMENTS.GravityIn /></cfif>
	<cfif ARGUMENTS.UnitsIn eq "SG"><cfreturn (260 - 260 / ARGUMENTS.GravityIn) /></cfif>
	<cfreturn (260 / (260 - ARGUMENTS.GravityIn)) />
</cffunction>
<cffunction name="fixHopWhen" access="public" returntype="string" output="false">
	<cfargument name="inWhen" type="string" required="true" />
	<cfif ARGUMENTS.inWhen eq "Dry Hop"><cfreturn "Dry"/></cfif>
	<cfif ARGUMENTS.inWhen eq "First Wort"><cfreturn "Fwh"/></cfif>
	<cfif ARGUMENTS.inWhen eq "Aroma"><cfreturn "Boil"/></cfif>
	<cfreturn ARGUMENTS.inWhen />
</cffunction>
<cffunction name="fixUnitsW" access="public" returntype="string" output="false">
	<cfargument name="inUnit" type="string" required="true" />
	<cfif ARGUMENTS.inUnit eq "kg"><cfreturn "Kg"/></cfif>
	<cfif ARGUMENTS.inUnit eq "lb"><cfreturn "Lbs"/></cfif>
	<cfif ARGUMENTS.inUnit eq "oz"><cfreturn "Ounces"/></cfif>
	<cfif ARGUMENTS.inUnit eq "g"><cfreturn "Grams"/></cfif>
	<cfreturn "Kg" />
</cffunction>
<cffunction name="fixUnitsV" access="public" returntype="string" output="false">
	<cfargument name="inUnit" type="string" required="true" />
	<cfif ARGUMENTS.inUnit eq "gal"><cfreturn "Gallons"/></cfif>
	<cfif ARGUMENTS.inUnit eq "l"><cfreturn "Liters"/></cfif>
	<cfif ARGUMENTS.inUnit eq "qt"><cfreturn "Quarts"/></cfif>
	<cfif ARGUMENTS.inUnit eq "pt"><cfreturn "Pints"/></cfif>
	<cfif ARGUMENTS.inUnit eq "cup"><cfreturn "Cups"/></cfif>
	<cfif ARGUMENTS.inUnit eq "oz"><cfreturn "Ounces"/></cfif>
	<cfif ARGUMENTS.inUnit eq "tblsp"><cfreturn "Tablespoons"/></cfif>
	<cfif ARGUMENTS.inUnit eq "tsp"><cfreturn "Teaspoons"/></cfif>
	<cfif ARGUMENTS.inUnit eq "ml"><cfreturn "Milliliters"/></cfif>
	<cfreturn "Liters" />
</cffunction>
<cffunction name="fixMiscUse" access="public" returntype="string" output="false">
	<cfargument name="inUse" type="string" required="true" />
	<cfif ARGUMENTS.inUse eq "Boil"><cfreturn "Boil"/></cfif>
	<cfif ARGUMENTS.inUse eq "Mash"><cfreturn "Mash"/></cfif>
	<cfif ARGUMENTS.inUse eq "Bottling"><cfreturn "Package"/></cfif>
	<cfreturn "Ferment" />
</cffunction>
<cffunction name="ReadKey" access="public" returntype="string" output="false">
	<cfargument name="inS" type="any" required="true" />
	<cfargument name="inK" type="string" required="true" />
	<cfargument name="inDef" type="any" required="false" default="" />
	<cfif StructKeyExists(ARGUMENTS.inS, ARGUMENTS.inK)><cfreturn setDefault(ARGUMENTS.inS[ARGUMENTS.inK].xmlText,ARGUMENTS.inDef) /></cfif>
	<cfreturn ARGUMENTS.inDef />
</cffunction>

<cfset LOCAL = StructNew() />

<cfset LOCAL.XMLResponse=XMLParse("C:\Inetpub\wwwroot\beerinhand\test\test.xml") />

<cfloop from="1" to="#ArrayLen(LOCAL.XMLResponse.RECIPES.RECIPE)#" index="idxR">
	<cfset LOCAL.RECIPE = LOCAL.XMLResponse.RECIPES.RECIPE[idxR] />
	<cfset RCP = StructNew() />
	<cfset RCP.re_hunits = RSP.RCP.qryRecipe.RE_HUNITS />
	<cfset RCP.re_eunits = RSP.RCP.qryRecipe.RE_EUNITS />
	<cfset RCP.re_munits = RSP.RCP.qryRecipe.RE_MUNITS />
	<cfset RCP.re_vunits =  RSP.RCP.qryRecipe.RE_VUNITS />
	<cfset RCP.re_viunits = SESSION.SETTING.VIUNITS />
	<cfset RCP.re_tunits =  RSP.RCP.qryRecipe.RE_TUNITS />
	<cfset RCP.re_name = LOCAL.RECIPE.NAME.xmltext />
	<cfset RCP.re_volume = convertVolume("Liters", LOCAL.RECIPE.BATCH_SIZE.xmltext, RCP.re_vunits) />
	<cfset RCP.re_boilvol = convertVolume("Liters", LOCAL.RECIPE.BOIL_SIZE.xmltext, RCP.re_vunits) />
	<cfset RCP.re_eff = LOCAL.RECIPE.EFFICIENCY.xmltext />
	<cfset RCP.re_expgrv = ConvertGravity("SG", LOCAL.RECIPE.OG.xmltext, RCP.re_eunits) />
	<cfset RCP.re_expsrm = ListFirst(ReadKey(LOCAL.RECIPE, "EST_COLOR"), " ") />
	<cfset RCP.re_expibu = ListFirst(ReadKey(LOCAL.RECIPE, "IBU"), " ") />
	<cfset RCP.re_style = LOCAL.RECIPE.STYLE.NAME.xmltext />

	<cfset RCP.re_hopamt = 0 />
	<cfset RCP.re_hopcnt = 0 />
	<cfset RCP.re_grnamt = 0 />
	<cfset RCP.re_grncnt = 0 />
	<cfset RCP.re_mashamt = 0 />
	<cfset LOCAL.grn_mc = 0 />

	<cfset RCP.DATES = ArrayNew(1) />
	<cfset RCP.IsBrewed = StructKeyExists(LOCAL.RECIPE, "DATE") AND isDate(LOCAL.RECIPE.DATE.xmltext) />
	<cfif RCP.IsBrewed>
		<cfset RCP.re_brewed = LOCAL.RECIPE.DATE.xmltext />
		<cfset LOCAL.secondary = "" />
		<cfset LOCAL.tertiary = "" />
		<cfset LOCAL.packaged = "" />
		<cfif StructKeyExists(LOCAL.RECIPE, "PRIMARY_AGE") AND isNumeric(LOCAL.RECIPE.PRIMARY_AGE.xmltext)>
			<cfset LOCAL.brewedT = ConvertTemp("C", ReadKey(LOCAL.RECIPE, "PRIMARY_TEMP", 16.7), RCP.re_tunits) />
			<cfset LOCAL.packaged = DateAdd("d", RCP.re_brewed, LOCAL.RECIPE.PRIMARY_AGE.xmltext) />
			<cfset LOCAL.secondary = LOCAL.packaged />
			<cfif StructKeyExists(LOCAL.RECIPE, "SECONDARY_AGE") AND isNumeric(LOCAL.RECIPE.SECONDARY_AGE.xmltext)>
				<cfset LOCAL.secondaryT = ReadKey(LOCAL.RECIPE, "SECONDARY_TEMP") />
				<cfif LOCAL.secondaryT EQ "">
					<cfset LOCAL.secondaryT = LOCAL.brewedT />
				<cfelse>
					<cfset LOCAL.secondaryT = ConvertTemp("C", LOCAL.secondaryT, RCP.re_tunits) />
				</cfif>
				<cfset LOCAL.packaged = DateAdd("d", LOCAL.packaged, LOCAL.RECIPE.SECONDARY_AGE.xmltext) />
				<cfset LOCAL.tertiary = LOCAL.packaged />
				<cfif StructKeyExists(LOCAL.RECIPE, "TERTIARY_AGE") AND isNumeric(LOCAL.RECIPE.TERTIARY_AGE.xmltext)>
					<cfset LOCAL.tertiaryT = ReadKey(LOCAL.RECIPE, "TERTIARY_TEMP") />
					<cfif LOCAL.tertiaryT EQ "">
						<cfset LOCAL.tertiaryT = LOCAL.secondaryT />
					<cfelse>
						<cfset LOCAL.tertiaryT = ConvertTemp("C", LOCAL.tertiaryT, RCP.re_tunits) />
					</cfif>
					<cfset LOCAL.packaged = DateAdd("d", LOCAL.packaged, LOCAL.RECIPE.TERTIARY_AGE.xmltext) />
					<cfset LOCAL.packagedT = LOCAL.tertiaryT />
				</cfif>
			</cfif>
		</cfif>
		<cfset idxD = 1 /><cfset RCP.DATES[idxD] = StructNew() />
		<cfset RCP.DATES[idxD].rd_date = RCP.re_brewed />
		<cfset RCP.DATES[idxD].rd_type = "Brewed" />
		<cfset RCP.DATES[idxD].rd_gravity = RCP.re_expgrv />
		<cfset RCP.DATES[idxD].rd_temp = LOCAL.brewedT />
		<cfset RCP.DATES[idxD].rd_notes = ReadKey(LOCAL.RECIPE, "NOTES") />
		<cfif isDate(LOCAL.secondary)>
			<cfset idxD = idxD + 1 /><cfset RCP.DATES[idxD] = StructNew() />
			<cfset RCP.DATES[idxD].rd_date = LOCAL.secondary />
			<cfset RCP.DATES[idxD].rd_temp = LOCAL.secondaryT />
			<cfset RCP.DATES[idxD].rd_type = "Racked" />
		</cfif>
		<cfif isDate(LOCAL.tertiary)>
			<cfset idxD = idxD + 1 /><cfset RCP.DATES[idxD] = StructNew() />
			<cfset RCP.DATES[idxD].rd_date = LOCAL.tertiary />
			<cfset RCP.DATES[idxD].rd_temp = LOCAL.tertiaryT />
			<cfset RCP.DATES[idxD].rd_type = "Racked" />
		</cfif>
		<cfif isDate(LOCAL.packaged)>
			<cfset idxD = idxD + 1 /><cfset RCP.DATES[idxD] = StructNew() />
			<cfset RCP.DATES[idxD].rd_date = LOCAL.packaged />
			<cfset RCP.DATES[idxD].rd_temp = LOCAL.packagedT />
			<cfset RCP.DATES[idxD].rd_type = "Packaged" />
			<cfset RCP.DATES[idxD].rd_notes = ReadKey(LOCAL.RECIPE, "CARBONATION_USED") />
		</cfif>
	</cfif>

	<cfset RCP.HOPS = ArrayNew(1) />
	<cfset RCP.re_hopcnt = ArrayLen(LOCAL.RECIPE.HOPS.HOP) />
	<cfloop from="1" to="#RCP.re_hopcnt#" index="idxH">
		<cfset RCP.HOPS[idxH] = StructNew() />
		<cfset LOCAL.HOP = LOCAL.RECIPE.HOPS.HOP[idxH] />
		<cfset RCP.HOPS[idxH].rh_hop = LOCAL.HOP.NAME.xmltext />
		<cfset RCP.HOPS[idxH].rh_grown = LOCAL.HOP.ORIGIN.xmltext />
		<cfset RCP.HOPS[idxH].rh_aau = LOCAL.HOP.ALPHA.xmltext />
		<cfset RCP.HOPS[idxH].rh_amount = convertWeight("Kg", LOCAL.HOP.AMOUNT.xmltext, RCP.re_hunits) />
		<cfset RCP.HOPS[idxH].rh_when = fixHopWhen(LOCAL.HOP.USE.xmltext) />
		<cfset RCP.HOPS[idxH].rh_time = LOCAL.HOP.TIME.xmltext />
		<cfset RCP.HOPS[idxH].rh_form = LOCAL.HOP.FORM.xmltext />
		<cfset RCP.re_hopamt = RCP.re_hopamt + RCP.HOPS[idxH].rh_amount />
	</cfloop>

	<cfset RCP.GRAINS = ArrayNew(1) />
	<cfset RCP.re_grncnt = ArrayLen(LOCAL.RECIPE.FERMENTABLES.FERMENTABLE) />
	<cfloop from="1" to="#RCP.re_grncnt#" index="idxG">
		<cfset RCP.GRAINS[idxG] = StructNew() />
		<cfset LOCAL.GRAIN = LOCAL.RECIPE.FERMENTABLES.FERMENTABLE[idxG] />
		<cfset RCP.GRAINS[idxG].rg_maltster = ReadKey(LOCAL.GRAIN, "SUPPLIER") />
		<cfset RCP.GRAINS[idxG].rg_type = ReplaceNoCase(LOCAL.GRAIN.NAME.xmltext, "(#RCP.GRAINS[idxG].rg_maltster#)", "") />
		<cfset RCP.GRAINS[idxG].rg_amount = convertWeight("Kg", LOCAL.GRAIN.AMOUNT.xmltext, RCP.re_munits) />
		<cfset RCP.GRAINS[idxG].rg_lvb = LOCAL.GRAIN.COLOR.xmltext />
		<cfset RCP.GRAINS[idxG].rg_mash = ReadKey(LOCAL.GRAIN, "RECOMMEND_MASH", FALSE) />
		<cfset RCP.GRAINS[idxG].rg_sgc = ReadKey(LOCAL.GRAIN, "POTENTIAL", 1 + .046 * (LOCAL.GRAIN.YIELD.xmltext/100)) />
		<cfset RCP.re_grnamt = RCP.re_grnamt + RCP.GRAINS[idxG].rg_amount />
		<cfif RCP.GRAINS[idxG].rg_mash>
			<cfset RCP.re_mashamt = RCP.re_mashamt + RCP.GRAINS[idxG].rg_amount />
			<cfset LOCAL.grn_mc = LOCAL.grn_mc + (RCP.GRAINS[idxG].rg_amount * LOCAL.GRAIN.MOISTURE.xmltext) />
		</cfif>
	</cfloop>

	<cfset RCP.MISCS = ArrayNew(1) />
	<cfloop from="1" to="#ArrayLen(LOCAL.RECIPE.MISCS.MISC)#" index="idxM">
		<cfset RCP.MISCS[idxM] = StructNew() />
		<cfset LOCAL.MISC = LOCAL.RECIPE.MISCS.MISC[idxM] />
		<cfset RCP.MISCS[idxM].rm_type = LOCAL.MISC.NAME.xmltext />
		<cfset amt = LOCAL.MISC.AMOUNT.xmltext />
		<cfset isW = ReadKey(LOCAL.MISC, "AMOUNT_IS_WEIGHT", FALSE) />
		<cfset unit = IIF(isW, DE("Kgs"), DE("Liters")) />
		<cfif StructKeyExists(LOCAL.MISC, "DISPLAY_AMOUNT")>
			<cfset amt = ListFirst(LOCAL.MISC.DISPLAY_AMOUNT.xmltext, " ") />
			<cfif unit EQ "Kgs">
				<cfset unit = FixUnitsW(ListLast(LOCAL.MISC.DISPLAY_AMOUNT.xmltext, " ")) />
			<cfelse>
				<cfset unit = FixUnitsV(ListLast(LOCAL.MISC.DISPLAY_AMOUNT.xmltext, " ")) />
			</cfif>
		</cfif>
		<cfif unit EQ "Kgs" AND amt lt 1>
			<cfset unit = "Grams" />
			<cfset amt = amt * 1000 />
		</cfif>
		<cfset RCP.MISCS[idxM].rm_amount = amt />
		<cfset RCP.MISCS[idxM].rm_unit = unit />
		<cfset RCP.MISCS[idxM].rm_utype = IIF(isW, DE("W"), DE("V")) />
		<cfset RCP.MISCS[idxM].rm_phase = fixMiscUse(LOCAL.MISC.USE.xmltext) />
		<cfif RCP.MISCS[idxM].rm_phase EQ "Mash">
			<cfset RCP.MISCS[idxM].rm_added = "Mins After" />
			<cfset RCP.MISCS[idxM].rm_offset = LOCAL.MISC.TIME.xmltext />
			<cfset RCP.MISCS[idxM].rm_action = "Mash In" />
		<cfelseif RCP.MISCS[idxM].rm_phase EQ "Boil">
			<cfset RCP.MISCS[idxM].rm_added = "Mins After" />
			<cfset RCP.MISCS[idxM].rm_offset = LOCAL.MISC.TIME.xmltext />
			<cfset RCP.MISCS[idxM].rm_action = "Boil Start" />
		<cfelseif RCP.MISCS[idxM].rm_phase EQ "Ferment">
			<cfset RCP.MISCS[idxM].rm_added = "Days After" />
			<cfset RCP.MISCS[idxM].rm_offset = LOCAL.MISC.TIME.xmltext/1440 /> <!--- TO DAYS FROM MINS --->
			<cfif LOCAL.MISC.USE.xmltext EQ "Primary">
				<cfset RCP.MISCS[idxM].rm_action = "Pitching" />
			<cfelse>
				<cfset RCP.MISCS[idxM].rm_action = "Racking" />
			</cfif>
		<cfelseif RCP.MISCS[idxM].rm_phase EQ "Package">
			<cfset RCP.MISCS[idxM].rm_added = "Days After" />
			<cfset RCP.MISCS[idxM].rm_offset = LOCAL.MISC.TIME.xmltext/1440 /> <!--- TO DAYS FROM MINS --->
		</cfif>
	</cfloop>

	<cfset RCP.YEASTS = ArrayNew(1) />
	<cfloop from="1" to="#ArrayLen(LOCAL.RECIPE.YEASTS.YEAST)#" index="idxY">
		<cfset RCP.YEASTS[idxY] = StructNew() />
		<cfset LOCAL.YEAST = LOCAL.RECIPE.YEASTS.YEAST[idxY] />
		<cfset RCP.YEASTS[idxY].ry_yeast = LOCAL.YEAST.NAME.xmltext />
		<cfset RCP.YEASTS[idxY].ry_mfg = ReadKey(LOCAL.YEAST, "LABORATORY") />
		<cfset RCP.YEASTS[idxY].ry_mfgno = ReadKey(LOCAL.YEAST, "PRODUCT_ID") />
		<cfif ReadKey(LOCAL.YEAST, "ADD_TO_SECONDARY", FALSE)>
			<cfset RCP.YEASTS[idxY].ry_date = LOCAL.secondary />
		<cfelse>
			<cfset RCP.YEASTS[idxY].ry_date = RCP.re_brewed />
		</cfif>
	</cfloop>
	<!---	{
	"mash_tunits":"F","mash_viunits":"Quarts","mash_munits":"Lbs","mash_vunits":"Gallons","mash_length":"100","mash_infuse_f":"16.69","mash_maltcap":"0.4"
	"mash_duration0":"90","mash_temp_f0":"152","mash_temp_i0":"42","mash_temp_a0":"166","mash_infuse0":"46.50","mash_malt":"31.00","mash_volume0":"11.63","mash_ratio0":"1.50",
	"mash_steptype1":"Infusion","mash_duration1":"10","mash_temp_f1":"168","mash_temp_i1":"154","mash_temp_a1":"212","mash_infuse1":"16.69","mash_decoct1":"26.42","mash_volume1":"15.80","mash_ratio1":"2.04",
	} --->
	<cfif StructKeyExists(LOCAL.RECIPE, "MASH")>
		<cfset RCP.MASH = StructNew() />
		<cfset RCP.MASH["mash_tunits"] = RCP.re_tunits />
		<cfset RCP.MASH["mash_viunits"] = RCP.re_viunits />
		<cfset RCP.MASH["mash_munits"] = RCP.re_munits />
		<cfset RCP.MASH["mash_vunits"] = RCP.re_vunits />
		<cfset RCP.MASH["mash_infuse_f"] = 0 />
		<cftry>
			<cfset RCP.MASH["mash_maltcap"] =  0.38 + (LOCAL.grn_mc / RCP.re_mashamt / 2 / 100) />
			<cfcatch>
				<cfset RCP.MASH["mash_maltcap"] =  .40 />
			</cfcatch>
		</cftry>
		<cfloop from="1" to="#ArrayLen(LOCAL.RECIPE.MASH.MASH_STEPS.MASH_STEP)#" index="idxMS">
			<cfset idx = idxMS - 1 />
			<cfset LOCAL.MASH = LOCAL.RECIPE.MASH.MASH_STEPS.MASH_STEP[idxMS] />
			<cfset RCP.MASH["mash_duration#idx#"] = LOCAL.MASH.STEP_TIME.xmltext />
			<cfset RCP.MASH["mash_temp_f#idx#"] = ConvertTemp("C", LOCAL.MASH.STEP_TEMP.xmltext, RCP.MASH.mash_tunits) />
			<cfif StructKeyExists(LOCAL.MASH, "INFUSE_TEMP")>
				<cfset LOCAL.inT = ListFirst(LOCAL.MASH.INFUSE_TEMP.xmltext, " ") />
				<cfset LOCAL.inU = ListLast(LOCAL.MASH.INFUSE_TEMP.xmltext, " ") />
				<cfset RCP.MASH["mash_temp_a#idx#"] = convertTemp(LOCAL.inU, LOCAL.inT, RCP.MASH.mash_tunits) />
			</cfif>
			<cfset RCP.MASH["mash_infuse#idx#"] = ConvertVolume("Liters", ReadKey(LOCAL.MASH, "INFUSE_AMOUNT",0), RCP.MASH.mash_viunits) />
			<cfset RCP.MASH["mash_ratio#idx#"] = ListFirst(ReadKey(LOCAL.MASH, "WATER_GRAIN_RATIO")) />
			<cfif idxMS eq 1>
				<cfset RCP.MASH["mash_temp_i#idx#"] = ConvertTemp("C", LOCAL.RECIPE.MASH.GRAIN_TEMP.xmltext, RCP.MASH.mash_tunits) />
				<cfset RCP.MASH["mash_malt"] = DecimalFormat(RCP.re_mashamt) />
				<cfset LOCAL.endT = ConvertTemp("C", LOCAL.MASH.END_TEMP.xmltext, RCP.MASH.mash_tunits) />
			<cfelse>
				<cfset RCP.MASH["mash_temp_i#idx#"] = LOCAL.endT />
				<cfset RCP.MASH["mash_decoct#idx#"] = ConvertWeight("Kg", ReadKey(LOCAL.MASH, "DECOCTION_AMT", 0), RCP.MASH.mash_munits) />
			</cfif>
			<cfset RCP.MASH.mash_infuse_f = RCP.MASH.mash_infuse_f + RCP.MASH["mash_infuse#idx#"] />
			<cfset RCP.MASH["mash_volume#idx#"] = convertVolume(RCP.MASH.mash_viunits, RCP.MASH.mash_infuse_f, RCP.MASH.mash_vunits) />
		</cfloop>
	</cfif>

	<cfset RCPS[idxR] = Duplicate(RSP.RCP) />
	<cfloop list="#RCPS[idxR].qryRecipe.ColumnList#" index="col">
		<cfif StructKeyExists(RCP, col)>
			<cfset QuerySetCell(RCPS[idxR].qryRecipe, col, RCP[col]) />
		</cfif>
	</cfloop>
	<cfset QuerySetCell(RCPS[idxR].qryRecipe, "RE_MASH", SerializeJSON(RCP.MASH)) />
	<cfloop from="1" to="#ArrayLen(RCP.DATES)#" index="idx">
		<cfset QueryAddRow(RCPS[idxR].qryRecipeDates) />
		<cfloop list="#RCPS[idxR].qryRecipeDates.ColumnList#" index="col">
			<cfif StructKeyExists(RCP.DATES[idx], col)>
				<cfset QuerySetCell(RCPS[idxR].qryRecipeDates, col, RCP.DATES[idx][col]) />
			</cfif>
		</cfloop>
	</cfloop>
	<cfloop from="1" to="#ArrayLen(RCP.GRAINS)#" index="idx">
		<cfset QueryAddRow(RCPS[idxR].qryRecipeGrains) />
		<cfloop list="#RCPS[idxR].qryRecipeGrains.ColumnList#" index="col">
			<cfif StructKeyExists(RCP.GRAINS[idx], col)>
				<cfset QuerySetCell(RCPS[idxR].qryRecipeGrains, col, RCP.GRAINS[idx][col]) />
			</cfif>
		</cfloop>
	</cfloop>
	<cfloop from="1" to="#ArrayLen(RCP.HOPS)#" index="idx">
		<cfset QueryAddRow(RCPS[idxR].qryRecipeHops) />
		<cfloop list="#RCPS[idxR].qryRecipeHops.ColumnList#" index="col">
			<cfif StructKeyExists(RCP.HOPS[idx], col)>
				<cfset QuerySetCell(RCPS[idxR].qryRecipeHops, col, RCP.HOPS[idx][col]) />
			</cfif>
		</cfloop>
	</cfloop>
	<cfloop from="1" to="#ArrayLen(RCP.MISCS)#" index="idx">
		<cfset QueryAddRow(RCPS[idxR].qryRecipeMisc) />
		<cfloop list="#RCPS[idxR].qryRecipeMisc.ColumnList#" index="col">
			<cfif StructKeyExists(RCP.MISCS[idx], col)>
				<cfset QuerySetCell(RCPS[idxR].qryRecipeMisc, col, RCP.MISCS[idx][col]) />
			</cfif>
		</cfloop>
	</cfloop>
	<cfloop from="1" to="#ArrayLen(RCP.YEASTS)#" index="idx">
		<cfset QueryAddRow(RCPS[idxR].qryRecipeYeast) />
		<cfloop list="#RCPS[idxR].qryRecipeYeast.ColumnList#" index="col">
			<cfif StructKeyExists(RCP.YEASTS[idx], col)>
				<cfset QuerySetCell(RCPS[idxR].qryRecipeYeast, col, RCP.YEASTS[idx][col]) />
			</cfif>
		</cfloop>
	</cfloop>

</cfloop>
<cfset RSP.RCP = RCPS />
<cfdump var="#RSP.RCP#">
<script>
REID=0;
recipeHashable = function(rcpHash) {
	queryMakeHashable(rcpHash.qryRecipe);
	queryMakeHashable(rcpHash.qryRecipeGrains);
	queryMakeHashable(rcpHash.qryRecipeHops);
	queryMakeHashable(rcpHash.qryRecipeYeast);
	queryMakeHashable(rcpHash.qryRecipeMisc);
	queryMakeHashable(rcpHash.qryRecipeDates);
	return rcpHash;
}
recipeDataSaveLS = function() {
	if (REID==0) {
		var seq = toInt(localStorage.getItem("BIHSEQ"));
		localStorage.setItem("BIHSEQ", ++seq);
		var rcpList = localStorage.getItem("BIHLIST");
		rcpList = (rcpList) ? rcpList.split(",") : [];
		rcpList.push(seq);
		localStorage.setItem("BIHLIST", rcpList.join(","));
		RCP.qryRecipe.DATA[0].RE_REID = seq;
	}
	localStorage.setItem("BIHDETAIL"+seq.toString(), JSON.stringify(RCP));
	localStorage.setItem("BIHLAST", seq);
}
<cfoutput>
<cfloop from="1" to="#ArrayLen(RSP.RCP)#" index="idx">
RCP = #SerializeJSON(RSP.RCP[idx])#;
recipeHashable(RCP);
recipeDataSaveLS();
</cfloop>
</cfoutput>
</script>