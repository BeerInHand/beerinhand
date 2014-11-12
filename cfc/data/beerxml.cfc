<cfcomponent output="false">
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
	<cffunction name="CountKids" access="public" returntype="string" output="false">
		<cfargument name="inS" type="any" required="true" />
		<cfargument name="inK" type="string" required="true" />
		<cfargument name="inGk" type="string" required="false" />
		<cfif StructKeyExists(ARGUMENTS.inS, ARGUMENTS.inK)>
			<cfif StructKeyExists(ARGUMENTS, "inGk")>
				<cfif StructKeyExists(ARGUMENTS.inS[ARGUMENTS.inK], ARGUMENTS.inGK)>
					<cfreturn ArrayLen(ARGUMENTS.inS[ARGUMENTS.inK][ARGUMENTS.inGK]) />
				<cfelse>
					<cfreturn 0>
				</cfif>
			</cfif>
			<cfreturn ArrayLen(ARGUMENTS.inS[ARGUMENTS.inK]) />
		</cfif>
		<cfreturn 0 />
	</cffunction>
	<cffunction name="ParseXML" access="public" returntype="struct" output="true">
		<cfset LOCAL.defRecipe = APPLICATION.CFC.Recipe.Fetch(-1).RCP />
		<cfset LOCAL.outRecipes = ArrayNew(1) />
		<cfset LOCAL.XMLResponse=XMLParse(ARGUMENTS.xml) />
		<cfloop from="1" to="#ArrayLen(LOCAL.XMLResponse.RECIPES.RECIPE)#" index="LOCAL.idxR">
			<cfset LOCAL.xmlRecipe = LOCAL.XMLResponse.RECIPES.RECIPE[LOCAL.idxR] />
			<cfset LOCAL.BREW = StructNew() />
			<cfset LOCAL.BREW.re_hunits = LOCAL.defRecipe.qryRecipe.RE_HUNITS />
			<cfset LOCAL.BREW.re_eunits = LOCAL.defRecipe.qryRecipe.RE_EUNITS />
			<cfset LOCAL.BREW.re_munits = LOCAL.defRecipe.qryRecipe.RE_MUNITS />
			<cfset LOCAL.BREW.re_vunits =  LOCAL.defRecipe.qryRecipe.RE_VUNITS />
			<cfset LOCAL.BREW.re_viunits = SESSION.SETTING.VIUNITS />
			<cfset LOCAL.BREW.re_tunits =  LOCAL.defRecipe.qryRecipe.RE_TUNITS />
			<cfset LOCAL.BREW.re_name = LOCAL.xmlRecipe.NAME.xmltext />
			<cfset LOCAL.BREW.re_volume = convertVolume("Liters", LOCAL.xmlRecipe.BATCH_SIZE.xmltext, LOCAL.BREW.re_vunits) />
			<cfset LOCAL.BREW.re_boilvol = convertVolume("Liters", LOCAL.xmlRecipe.BOIL_SIZE.xmltext, LOCAL.BREW.re_vunits) />
			<cfset LOCAL.BREW.re_eff = LOCAL.xmlRecipe.EFFICIENCY.xmltext />
			<cfset LOCAL.BREW.re_expgrv = ConvertGravity("SG", LOCAL.xmlRecipe.OG.xmltext, LOCAL.BREW.re_eunits) />
			<cfset LOCAL.BREW.re_expsrm = ListFirst(ReadKey(LOCAL.xmlRecipe, "EST_COLOR"), " ") />
			<cfset LOCAL.BREW.re_expibu = ListFirst(ReadKey(LOCAL.xmlRecipe, "IBU"), " ") />
			<cfset LOCAL.BREW.re_style = LOCAL.xmlRecipe.STYLE.NAME.xmltext />
			<cfset LOCAL.BREW.re_hopamt = 0 />
			<cfset LOCAL.BREW.re_hopcnt = 0 />
			<cfset LOCAL.BREW.re_grnamt = 0 />
			<cfset LOCAL.BREW.re_grncnt = 0 />
			<cfset LOCAL.BREW.re_mashamt = 0 />
			<cfset LOCAL.grn_mc = 0 />
			<cfset LOCAL.BREW.DATES = ArrayNew(1) />
			<cfset LOCAL.BREW.IsBrewed = StructKeyExists(LOCAL.xmlRecipe, "DATE") AND isDate(LOCAL.xmlRecipe.DATE.xmltext) />
			<cfif LOCAL.BREW.IsBrewed>
				<cfset LOCAL.BREW.re_brewed = LOCAL.xmlRecipe.DATE.xmltext />
				<cfset LOCAL.secondary = "" />
				<cfset LOCAL.tertiary = "" />
				<cfset LOCAL.packaged = "" />
				<cfif StructKeyExists(LOCAL.xmlRecipe, "PRIMARY_AGE") AND isNumeric(LOCAL.xmlRecipe.PRIMARY_AGE.xmltext)>
					<cfset LOCAL.brewedT = ConvertTemp("C", ReadKey(LOCAL.xmlRecipe, "PRIMARY_TEMP", 16.7), LOCAL.BREW.re_tunits) />
					<cfset LOCAL.packaged = DateAdd("d", LOCAL.BREW.re_brewed, LOCAL.xmlRecipe.PRIMARY_AGE.xmltext) />
					<cfset LOCAL.secondary = LOCAL.packaged />
					<cfif StructKeyExists(LOCAL.xmlRecipe, "SECONDARY_AGE") AND isNumeric(LOCAL.xmlRecipe.SECONDARY_AGE.xmltext)>
						<cfset LOCAL.secondaryT = ReadKey(LOCAL.xmlRecipe, "SECONDARY_TEMP") />
						<cfif LOCAL.secondaryT EQ "">
							<cfset LOCAL.secondaryT = LOCAL.brewedT />
						<cfelse>
							<cfset LOCAL.secondaryT = ConvertTemp("C", LOCAL.secondaryT, LOCAL.BREW.re_tunits) />
						</cfif>
						<cfset LOCAL.packaged = DateAdd("d", LOCAL.packaged, LOCAL.xmlRecipe.SECONDARY_AGE.xmltext) />
						<cfset LOCAL.tertiary = LOCAL.packaged />
						<cfif StructKeyExists(LOCAL.xmlRecipe, "TERTIARY_AGE") AND isNumeric(LOCAL.xmlRecipe.TERTIARY_AGE.xmltext)>
							<cfset LOCAL.tertiaryT = ReadKey(LOCAL.xmlRecipe, "TERTIARY_TEMP") />
							<cfif LOCAL.tertiaryT EQ "">
								<cfset LOCAL.tertiaryT = LOCAL.secondaryT />
							<cfelse>
								<cfset LOCAL.tertiaryT = ConvertTemp("C", LOCAL.tertiaryT, LOCAL.BREW.re_tunits) />
							</cfif>
							<cfset LOCAL.packaged = DateAdd("d", LOCAL.packaged, LOCAL.xmlRecipe.TERTIARY_AGE.xmltext) />
							<cfset LOCAL.packagedT = LOCAL.tertiaryT />
						</cfif>
					</cfif>
				</cfif>
				<cfset LOCAL.idxD = 1 /><cfset LOCAL.BREW.DATES[LOCAL.idxD] = StructNew() />
				<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_date = LOCAL.BREW.re_brewed />
				<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_type = "Brewed" />
				<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_gravity = LOCAL.BREW.re_expgrv />
				<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_temp = LOCAL.brewedT />
				<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_notes = ReadKey(LOCAL.xmlRecipe, "NOTES") />
				<cfif isDate(LOCAL.secondary)>
					<cfset LOCAL.idxD = LOCAL.idxD + 1 /><cfset LOCAL.BREW.DATES[LOCAL.idxD] = StructNew() />
					<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_date = LOCAL.secondary />
					<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_temp = LOCAL.secondaryT />
					<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_type = "Racked" />
				</cfif>
				<cfif isDate(LOCAL.tertiary)>
					<cfset LOCAL.idxD = LOCAL.idxD + 1 /><cfset LOCAL.BREW.DATES[LOCAL.idxD] = StructNew() />
					<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_date = LOCAL.tertiary />
					<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_temp = LOCAL.tertiaryT />
					<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_type = "Racked" />
				</cfif>
				<cfif isDate(LOCAL.packaged)>
					<cfset LOCAL.idxD = LOCAL.idxD + 1 /><cfset LOCAL.BREW.DATES[LOCAL.idxD] = StructNew() />
					<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_date = LOCAL.packaged />
					<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_temp = LOCAL.packagedT />
					<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_type = "Packaged" />
					<cfset LOCAL.BREW.DATES[LOCAL.idxD].rd_notes = ReadKey(LOCAL.xmlRecipe, "CARBONATION_USED") />
				</cfif>
			</cfif>
			<cfset LOCAL.BREW.HOPS = ArrayNew(1) />
			<cfset LOCAL.BREW.re_hopcnt = CountKids(LOCAL.xmlRecipe, "HOPS", "HOP") />
			<cfloop from="1" to="#LOCAL.BREW.re_hopcnt#" index="LOCAL.idxH">
				<cfset LOCAL.BREW.HOPS[LOCAL.idxH] = StructNew() />
				<cfset LOCAL.HOP = LOCAL.xmlRecipe.HOPS.HOP[LOCAL.idxH] />
				<cfset LOCAL.BREW.HOPS[LOCAL.idxH].rh_hop = LOCAL.HOP.NAME.xmltext />
				<cfset LOCAL.BREW.HOPS[LOCAL.idxH].rh_grown = LOCAL.HOP.ORIGIN.xmltext />
				<cfset LOCAL.BREW.HOPS[LOCAL.idxH].rh_aau = LOCAL.HOP.ALPHA.xmltext />
				<cfset LOCAL.BREW.HOPS[LOCAL.idxH].rh_amount = convertWeight("Kg", LOCAL.HOP.AMOUNT.xmltext, LOCAL.BREW.re_hunits) />
				<cfset LOCAL.BREW.HOPS[LOCAL.idxH].rh_when = fixHopWhen(LOCAL.HOP.USE.xmltext) />
				<cfset LOCAL.BREW.HOPS[LOCAL.idxH].rh_time = LOCAL.HOP.TIME.xmltext />
				<cfset LOCAL.BREW.HOPS[LOCAL.idxH].rh_form = LOCAL.HOP.FORM.xmltext />
				<cfset LOCAL.BREW.re_hopamt = LOCAL.BREW.re_hopamt + LOCAL.BREW.HOPS[LOCAL.idxH].rh_amount />
			</cfloop>
			<cfset LOCAL.BREW.GRAINS = ArrayNew(1) />
			<cfset LOCAL.BREW.re_grncnt = CountKids(LOCAL.xmlRecipe, "FERMENTABLES", "FERMENTABLE") />
			<cfloop from="1" to="#LOCAL.BREW.re_grncnt#" index="LOCAL.idxG">
				<cfset LOCAL.BREW.GRAINS[LOCAL.idxG] = StructNew() />
				<cfset LOCAL.GRAIN = LOCAL.xmlRecipe.FERMENTABLES.FERMENTABLE[LOCAL.idxG] />
				<cfset LOCAL.BREW.GRAINS[LOCAL.idxG].rg_maltster = ReadKey(LOCAL.GRAIN, "SUPPLIER") />
				<cfset LOCAL.BREW.GRAINS[LOCAL.idxG].rg_type = ReplaceNoCase(LOCAL.GRAIN.NAME.xmltext, "(#LOCAL.BREW.GRAINS[LOCAL.idxG].rg_maltster#)", "") />
				<cfset LOCAL.BREW.GRAINS[LOCAL.idxG].rg_amount = convertWeight("Kg", LOCAL.GRAIN.AMOUNT.xmltext, LOCAL.BREW.re_munits) />
				<cfset LOCAL.BREW.GRAINS[LOCAL.idxG].rg_lvb = LOCAL.GRAIN.COLOR.xmltext />
				<cfset LOCAL.BREW.GRAINS[LOCAL.idxG].rg_mash = ReadKey(LOCAL.GRAIN, "RECOMMEND_MASH", FALSE) />
				<cfset LOCAL.BREW.GRAINS[LOCAL.idxG].rg_sgc = ReadKey(LOCAL.GRAIN, "POTENTIAL", 1 + .046 * (LOCAL.GRAIN.YIELD.xmltext/100)) />
				<cfset LOCAL.BREW.re_grnamt = LOCAL.BREW.re_grnamt + LOCAL.BREW.GRAINS[LOCAL.idxG].rg_amount />
				<cfif LOCAL.BREW.GRAINS[LOCAL.idxG].rg_mash>
					<cfset LOCAL.BREW.re_mashamt = LOCAL.BREW.re_mashamt + LOCAL.BREW.GRAINS[LOCAL.idxG].rg_amount />
					<cfset LOCAL.grn_mc = LOCAL.grn_mc + (LOCAL.BREW.GRAINS[LOCAL.idxG].rg_amount * udfDefault(LOCAL.GRAIN.MOISTURE.xmltext,.4)) />
				</cfif>
			</cfloop>
			<cfset LOCAL.BREW.MISCS = ArrayNew(1) />
			<cfset LOCAL.micnt = CountKids(LOCAL.xmlRecipe, "MISCS", "MISC") />
			<cfloop from="1" to="#LOCAL.micnt#" index="LOCAL.idxM">
				<cfset LOCAL.BREW.MISCS[LOCAL.idxM] = StructNew() />
				<cfset LOCAL.MISC = LOCAL.xmlRecipe.MISCS.MISC[LOCAL.idxM] />
				<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_type = LOCAL.MISC.NAME.xmltext />
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
				<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_amount = amt />
				<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_unit = unit />
				<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_utype = IIF(isW, DE("W"), DE("V")) />
				<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_phase = fixMiscUse(LOCAL.MISC.USE.xmltext) />
				<cfif LOCAL.BREW.MISCS[LOCAL.idxM].rm_phase EQ "Mash">
					<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_added = "Mins After" />
					<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_offset = LOCAL.MISC.TIME.xmltext />
					<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_action = "Mash In" />
				<cfelseif LOCAL.BREW.MISCS[LOCAL.idxM].rm_phase EQ "Boil">
					<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_added = "Mins After" />
					<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_offset = LOCAL.MISC.TIME.xmltext />
					<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_action = "Boil Start" />
				<cfelseif LOCAL.BREW.MISCS[LOCAL.idxM].rm_phase EQ "Ferment">
					<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_added = "Days After" />
					<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_offset = LOCAL.MISC.TIME.xmltext/1440 /> <!--- TO DAYS FROM MINS --->
					<cfif LOCAL.MISC.USE.xmltext EQ "Primary">
						<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_action = "Pitching" />
					<cfelse>
						<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_action = "Racking" />
					</cfif>
				<cfelseif LOCAL.BREW.MISCS[LOCAL.idxM].rm_phase EQ "Package">
					<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_added = "Days After" />
					<cfset LOCAL.BREW.MISCS[LOCAL.idxM].rm_offset = LOCAL.MISC.TIME.xmltext/1440 /> <!--- TO DAYS FROM MINS --->
				</cfif>
			</cfloop>
			<cfset LOCAL.BREW.YEASTS = ArrayNew(1) />
			<cfset LOCAL.yecnt = CountKids(LOCAL.xmlRecipe, "YEASTS", "YEAST") />
			<cfloop from="1" to="#LOCAL.yecnt#" index="LOCAL.idxY">
				<cfset LOCAL.BREW.YEASTS[LOCAL.idxY] = StructNew() />
				<cfset LOCAL.YEAST = LOCAL.xmlRecipe.YEASTS.YEAST[LOCAL.idxY] />
				<cfset LOCAL.BREW.YEASTS[LOCAL.idxY].ry_yeast = LOCAL.YEAST.NAME.xmltext />
				<cfset LOCAL.BREW.YEASTS[LOCAL.idxY].ry_mfg = ReadKey(LOCAL.YEAST, "LABORATORY") />
				<cfset LOCAL.BREW.YEASTS[LOCAL.idxY].ry_mfgno = ReadKey(LOCAL.YEAST, "PRODUCT_ID") />
				<cfif ReadKey(LOCAL.YEAST, "ADD_TO_SECONDARY", FALSE)>
					<cfset LOCAL.BREW.YEASTS[LOCAL.idxY].ry_date = LOCAL.secondary />
				<cfelse>
					<cfset LOCAL.BREW.YEASTS[LOCAL.idxY].ry_date = LOCAL.BREW.re_brewed />
				</cfif>
			</cfloop>
			<cfif StructKeyExists(LOCAL.xmlRecipe, "MASH")>
				<cfset LOCAL.BREW.MASH = StructNew() />
				<cfset LOCAL.BREW.MASH["mash_tunits"] = LOCAL.BREW.re_tunits />
				<cfset LOCAL.BREW.MASH["mash_viunits"] = LOCAL.BREW.re_viunits />
				<cfset LOCAL.BREW.MASH["mash_munits"] = LOCAL.BREW.re_munits />
				<cfset LOCAL.BREW.MASH["mash_vunits"] = LOCAL.BREW.re_vunits />
				<cfset LOCAL.BREW.MASH["mash_infuse_f"] = 0 />
				<cftry>
					<cfset LOCAL.BREW.MASH["mash_maltcap"] =  0.38 + (LOCAL.grn_mc / LOCAL.BREW.re_mashamt / 2 / 100) />
					<cfcatch>
						<cfset LOCAL.BREW.MASH["mash_maltcap"] =  .40 />
					</cfcatch>
				</cftry>
				<cfloop from="1" to="#ArrayLen(LOCAL.xmlRecipe.MASH.MASH_STEPS.MASH_STEP)#" index="LOCAL.idxMS">
					<cfset LOCAL.idx = LOCAL.idxMS - 1 />
					<cfset LOCAL.MASH = LOCAL.xmlRecipe.MASH.MASH_STEPS.MASH_STEP[LOCAL.idxMS] />
					<cfset LOCAL.BREW.MASH["mash_duration#LOCAL.idx#"] = LOCAL.MASH.STEP_TIME.xmltext />
					<cfset LOCAL.BREW.MASH["mash_temp_f#LOCAL.idx#"] = ConvertTemp("C", LOCAL.MASH.STEP_TEMP.xmltext, LOCAL.BREW.MASH.mash_tunits) />
					<cfif StructKeyExists(LOCAL.MASH, "INFUSE_TEMP")>
						<cfset LOCAL.inT = ListFirst(LOCAL.MASH.INFUSE_TEMP.xmltext, " ") />
						<cfset LOCAL.inU = ListLast(LOCAL.MASH.INFUSE_TEMP.xmltext, " ") />
						<cfset LOCAL.BREW.MASH["mash_temp_a#LOCAL.idx#"] = convertTemp(LOCAL.inU, LOCAL.inT, LOCAL.BREW.MASH.mash_tunits) />
					</cfif>
					<cfset LOCAL.BREW.MASH["mash_infuse#LOCAL.idx#"] = ConvertVolume("Liters", ReadKey(LOCAL.MASH, "INFUSE_AMOUNT",0), LOCAL.BREW.MASH.mash_viunits) />
					<cfset LOCAL.BREW.MASH["mash_ratio#LOCAL.idx#"] = ListFirst(ReadKey(LOCAL.MASH, "WATER_GRAIN_RATIO")) />
					<cfif LOCAL.idxMS eq 1>
						<cfset LOCAL.BREW.MASH["mash_temp_i#LOCAL.idx#"] = ConvertTemp("C", LOCAL.xmlRecipe.MASH.GRAIN_TEMP.xmltext, LOCAL.BREW.MASH.mash_tunits) />
						<cfset LOCAL.BREW.MASH["mash_malt"] = LOCAL.BREW.re_mashamt />
						<cfset LOCAL.endT = ConvertTemp("C", LOCAL.MASH.END_TEMP.xmltext, LOCAL.BREW.MASH.mash_tunits) />
					<cfelse>
						<cfset LOCAL.BREW.MASH["mash_temp_i#LOCAL.idx#"] = LOCAL.endT />
						<cfset LOCAL.BREW.MASH["mash_decoct#LOCAL.idx#"] = ConvertWeight("Kg", ListFirst(ReadKey(LOCAL.MASH, "DECOCTION_AMT", 0), " "), LOCAL.BREW.MASH.mash_munits) />
					</cfif>
					<cfset LOCAL.BREW.MASH.mash_infuse_f = LOCAL.BREW.MASH.mash_infuse_f + LOCAL.BREW.MASH["mash_infuse#LOCAL.idx#"] />
					<cfset LOCAL.BREW.MASH["mash_volume#LOCAL.idx#"] = convertVolume(LOCAL.BREW.MASH.mash_viunits, LOCAL.BREW.MASH.mash_infuse_f, LOCAL.BREW.MASH.mash_vunits) />
				</cfloop>
			</cfif>

			<cfset LOCAL.outRecipes[LOCAL.idxR] = Duplicate(LOCAL.defRecipe) />
			<cfloop list="#LOCAL.outRecipes[LOCAL.idxR].qryRecipe.ColumnList#" index="LOCAL.col">
				<cfif StructKeyExists(LOCAL.BREW, LOCAL.col)>
					<cfset QuerySetCell(LOCAL.outRecipes[LOCAL.idxR].qryRecipe, LOCAL.col, LOCAL.BREW[LOCAL.col]) />
				</cfif>
			</cfloop>
			<cfif StructKeyExists(LOCAL.BREW, "MASH")>
				<cfset QuerySetCell(LOCAL.outRecipes[LOCAL.idxR].qryRecipe, "RE_MASH", SerializeJSON(LOCAL.BREW.MASH)) />
			</cfif>
			<cfloop from="1" to="#ArrayLen(LOCAL.BREW.DATES)#" index="LOCAL.idx">
				<cfset QueryAddRow(LOCAL.outRecipes[LOCAL.idxR].qryRecipeDates) />
				<cfloop list="#LOCAL.outRecipes[LOCAL.idxR].qryRecipeDates.ColumnList#" index="LOCAL.col">
					<cfif StructKeyExists(LOCAL.BREW.DATES[LOCAL.idx], LOCAL.col)>
						<cfset QuerySetCell(LOCAL.outRecipes[LOCAL.idxR].qryRecipeDates, LOCAL.col, LOCAL.BREW.DATES[LOCAL.idx][LOCAL.col]) />
					</cfif>
				</cfloop>
			</cfloop>
			<cfloop from="1" to="#ArrayLen(LOCAL.BREW.GRAINS)#" index="LOCAL.idx">
				<cfset QueryAddRow(LOCAL.outRecipes[LOCAL.idxR].qryRecipeGrains) />
				<cfloop list="#LOCAL.outRecipes[LOCAL.idxR].qryRecipeGrains.ColumnList#" index="LOCAL.col">
					<cfif StructKeyExists(LOCAL.BREW.GRAINS[LOCAL.idx], LOCAL.col)>
						<cfset QuerySetCell(LOCAL.outRecipes[LOCAL.idxR].qryRecipeGrains, LOCAL.col, LOCAL.BREW.GRAINS[LOCAL.idx][LOCAL.col]) />
					</cfif>
				</cfloop>
			</cfloop>
			<cfloop from="1" to="#ArrayLen(LOCAL.BREW.HOPS)#" index="LOCAL.idx">
				<cfset QueryAddRow(LOCAL.outRecipes[LOCAL.idxR].qryRecipeHops) />
				<cfloop list="#LOCAL.outRecipes[LOCAL.idxR].qryRecipeHops.ColumnList#" index="LOCAL.col">
					<cfif StructKeyExists(LOCAL.BREW.HOPS[LOCAL.idx], LOCAL.col)>
						<cfset QuerySetCell(LOCAL.outRecipes[LOCAL.idxR].qryRecipeHops, LOCAL.col, LOCAL.BREW.HOPS[LOCAL.idx][LOCAL.col]) />
					</cfif>
				</cfloop>
			</cfloop>
			<cfloop from="1" to="#ArrayLen(LOCAL.BREW.MISCS)#" index="LOCAL.idx">
				<cfset QueryAddRow(LOCAL.outRecipes[LOCAL.idxR].qryRecipeMisc) />
				<cfloop list="#LOCAL.outRecipes[LOCAL.idxR].qryRecipeMisc.ColumnList#" index="LOCAL.col">
					<cfif StructKeyExists(LOCAL.BREW.MISCS[LOCAL.idx], LOCAL.col)>
						<cfset QuerySetCell(LOCAL.outRecipes[LOCAL.idxR].qryRecipeMisc, LOCAL.col, LOCAL.BREW.MISCS[LOCAL.idx][LOCAL.col]) />
					</cfif>
				</cfloop>
			</cfloop>
			<cfloop from="1" to="#ArrayLen(LOCAL.BREW.YEASTS)#" index="LOCAL.idx">
				<cfset QueryAddRow(LOCAL.outRecipes[LOCAL.idxR].qryRecipeYeast) />
				<cfloop list="#LOCAL.outRecipes[LOCAL.idxR].qryRecipeYeast.ColumnList#" index="LOCAL.col">
					<cfif StructKeyExists(LOCAL.BREW.YEASTS[LOCAL.idx], LOCAL.col)>
						<cfset QuerySetCell(LOCAL.outRecipes[LOCAL.idxR].qryRecipeYeast, LOCAL.col, LOCAL.BREW.YEASTS[LOCAL.idx][LOCAL.col]) />
					</cfif>
				</cfloop>
			</cfloop>
		</cfloop>
		<cfset LOCAL.Response.method = "ParseXML">
		<cfset LOCAL.Response["Recipes"] = LOCAL.outRecipes />
		<cfreturn LOCAL.Response />
	</cffunction>
</cfcomponent>