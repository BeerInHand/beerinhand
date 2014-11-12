<cfset RCP = StructNew() />
<cfset RCP.COMM = ""/>
<cfset RCP.PROC = ""/>
<cfoutput>
<cfloop file="C:\Inetpub\wwwroot\beerinhand\sql\all.rcp" index="line">
	<cfif line EQ "<********* END RECORD *********>">
<!--- 		<cfdump var="#RCP#"><cfabort> --->
		<cfinvoke component="#APPLICATION.CFC.Recipe#" method="InsertRecipe" returnvariable="RCP.re_reid">
			<cfinvokeargument name="re_usid" value="#SESSION.USER.usid#" />
			<cfif isDefined("RCP.NAME")><cfinvokeargument name="re_name" value="#RCP.NAME#" /></cfif>
			<cfif isDefined("RCP.VOLUME")><cfinvokeargument name="re_volume" value="#RCP.VOLUME#" /></cfif>
			<cfif isDefined("RCP.BOILVOL")><cfinvokeargument name="re_boilvol" value="#RCP.BOILVOL#" /></cfif>
			<cfif isDefined("RCP.STYLE")><cfinvokeargument name="re_style" value="#RCP.STYLE#" /></cfif>
			<cfif isDefined("RCP.EFF")><cfinvokeargument name="re_eff" value="#RCP.EFF#" /></cfif>
			<cfif isDefined("RCP.EXP_SG")><cfinvokeargument name="re_expgrv" value="#RCP.EXP_SG#" /></cfif>
			<cfif isDefined("RCP.EXP_LVB")><cfinvokeargument name="re_expsrm" value="#RCP.EXP_LVB#" /></cfif>
			<cfif isDefined("RCP.EXP_IBU")><cfinvokeargument name="re_expibu" value="#RCP.EXP_IBU#" /></cfif>
			<cfif isDefined("RCP.PRIME")><cfinvokeargument name="re_prime" value="#RCP.PRIME#" /></cfif>
			<cfif isDefined("RCP.VUNITS")><cfinvokeargument name="re_vunits" value="#RCP.VUNITS#" /></cfif>
			<cfif isDefined("RCP.GUNITS")><cfinvokeargument name="re_munits" value="#RCP.GUNITS#" /></cfif>
			<cfif isDefined("RCP.HUNITS")><cfinvokeargument name="re_hunits" value="#RCP.HUNITS#" /></cfif>
			<cfinvokeargument name="re_tunits" value="F" />
			<cfinvokeargument name="re_eunits" value="SG" />
			<cfif isDefined("RCP.BREW_D")><cfinvokeargument name="re_brewed" value="#RCP.BREW_D#" /></cfif>
			<cfif isDefined("RCP.re_grnamt")><cfinvokeargument name="re_grnamt" value="#RCP.re_grnamt#" /></cfif>
			<cfif isDefined("RCP.re_mashamt")><cfinvokeargument name="re_mashamt" value="#RCP.re_mashamt#" /></cfif>
			<cfif isDefined("RCP.re_hopamt")><cfinvokeargument name="re_hopamt" value="#RCP.re_hopamt#" /></cfif>
			<cfif isDefined("RCP.re_proc")><cfinvokeargument name="re_notes" value="#RCP.re_notes#" /></cfif>
			<cfif isDefined("RCP.re_hopcnt")><cfinvokeargument name="re_hopcnt" value="#RCP.re_hopcnt#" /></cfif>
			<cfif isDefined("RCP.re_grncnt")><cfinvokeargument name="re_grncnt" value="#RCP.re_grncnt#" /></cfif>
			<cfif isDefined("RCP.re_eunits")><cfinvokeargument name="re_eunits" value="#RCP.re_eunits#" /></cfif>
			<cfif isDefined("RCP.re_dla")><cfinvokeargument name="re_dla" value="#RCP.re_dla#" /></cfif>
		</cfinvoke>
		<cfif LEN(RCP.COMM)>
			<cfif LEN(RCP.PROC)>
				<cfset RCP.PROC = RCP.PROC & "||" & RCP.COMM />
			<cfelse>
				<cfset RCP.PROC = RCP.COMM />
			</cfif>
		</cfif>
		<cfinvoke component="#APPLICATION.CFC.RecipeDates#" method="InsertRecipeDates">
			<cfinvokeargument name="rd_reid" value="#RCP.re_reid#" />
			<cfinvokeargument name="rd_usid" value="#SESSION.USER.usid#" />
			<cfinvokeargument name="rd_type" value="Brewed" />
			<cfif isDefined("RCP.BREW_D")><cfinvokeargument name="rd_date" value="#RCP.BREW_D#" /></cfif>
			<cfif isDefined("RCP.BREW_SG")><cfinvokeargument name="rd_gravity" value="#RCP.BREW_SG#" /></cfif>
			<cfif isDefined("RCP.BREW_TEMP")><cfinvokeargument name="rd_temp" value="#RCP.BREW_TEMP#" /></cfif>
			<cfif isDefined("RCP.PROC")><cfinvokeargument name="rd_note" value="#RCP.PROC#" /></cfif>
		</cfinvoke>
		<cfif StructKeyExists(RCP, "RACK_D")>
			<cfinvoke component="#APPLICATION.CFC.RecipeDates#" method="InsertRecipeDates">
				<cfinvokeargument name="rd_reid" value="#RCP.re_reid#" />
				<cfinvokeargument name="rd_usid" value="#SESSION.USER.usid#" />
				<cfinvokeargument name="rd_type" value="Racked" />
				<cfif isDefined("RCP.RACK_D")><cfinvokeargument name="rd_date" value="#RCP.RACK_D#" /></cfif>
				<cfif isDefined("RCP.RACK_SG")><cfinvokeargument name="rd_gravity" value="#RCP.RACK_SG#" /></cfif>
				<cfif isDefined("RCP.RACK_TEMP")><cfinvokeargument name="rd_temp" value="#RCP.RACK_TEMP#" /></cfif>
				<!--- <cfif isDefined("RCP.COMM")><cfinvokeargument name="rd_note" value="#RCP.COMM#" /></cfif> --->
			</cfinvoke>
		</cfif>
		<cfif StructKeyExists(RCP, "BOTT_D") OR StructKeyExists(RCP, "BOTT_SG")>
			<cfif NOT StructKeyExists(RCP, "BOTT_D")>
				<cfif StructKeyExists(RCP, "RACK_D")>
					<cfset RCP.BOTT_D = DateAdd("d",14, RCP.RACK_D) />
				<cfelse>
					<cfset RCP.BOTT_D = DateAdd("d",14, RCP.BREW_D) />
				</cfif>
			</cfif>
			<cfinvoke component="#APPLICATION.CFC.RecipeDates#" method="InsertRecipeDates">
				<cfinvokeargument name="rd_reid" value="#RCP.re_reid#" />
				<cfinvokeargument name="rd_usid" value="#SESSION.USER.usid#" />
				<cfinvokeargument name="rd_type" value="Packaged" />
				<cfif isDefined("RCP.BOTT_D")><cfinvokeargument name="rd_date" value="#RCP.BOTT_D#" /></cfif>
				<cfif isDefined("RCP.BOTT_SG")><cfinvokeargument name="rd_gravity" value="#RCP.BOTT_SG#" /></cfif>
				<cfif isDefined("RCP.BOTT_TEMP")><cfinvokeargument name="rd_temp" value="#RCP.BOTT_TEMP#" /></cfif>
			</cfinvoke>
		</cfif>
		<cfloop from="1" to="10" index="cnt">
			<cfif StructKeyExists(RCP, "G#cnt#LBS")>
				<cfinvoke component="#APPLICATION.CFC.RecipeGrains#" method="InsertRecipeGrains">
					<cfinvokeargument name="rg_reid" value="#RCP.re_reid#" />
					<cfinvokeargument name="rg_usid" value="#SESSION.USER.usid#" />
					<cfif StructKeyExists(RCP, "G#cnt#MALT")><cfinvokeargument name="rg_type" value="#RCP['G#cnt#MALT']#" /></cfif>
					<cfif StructKeyExists(RCP, "G#cnt#LBS")><cfinvokeargument name="rg_amount" value="#RCP['G#cnt#LBS']#" /></cfif>
					<cfif StructKeyExists(RCP, "G#cnt#SG")><cfinvokeargument name="rg_sgc" value="#RCP['G#cnt#SG']#" /></cfif>
					<cfif StructKeyExists(RCP, "G#cnt#LVB")><cfinvokeargument name="rg_lvb" value="#RCP['G#cnt#LVB']#" /></cfif>
					<cfif StructKeyExists(RCP, "G#cnt#MASH")><cfinvokeargument name="rg_mash" value="#RCP['G#cnt#MASH'] eq '.T.'#" /></cfif>
				</cfinvoke>
			</cfif>
		</cfloop>
		<cfloop from="1" to="8" index="cnt">
			<cfif StructKeyExists(RCP, "H#cnt#OZ")>
				<cfinvoke component="#APPLICATION.CFC.RecipeHops#" method="InsertRecipeHops">
					<cfinvokeargument name="rh_reid" value="#RCP.re_reid#" />
					<cfinvokeargument name="rh_usid" value="#SESSION.USER.usid#" />
					<cfif StructKeyExists(RCP, "H#cnt#HOP")><cfinvokeargument name="rh_hop" value="#RCP['H#cnt#HOP']#" /></cfif>
					<cfif StructKeyExists(RCP, "H#cnt#AAU")><cfinvokeargument name="rh_aau" value="#RCP['H#cnt#AAU']#" /></cfif>
					<cfif StructKeyExists(RCP, "H#cnt#OZ")><cfinvokeargument name="rh_amount" value="#RCP['H#cnt#OZ']#" /></cfif>
					<cfif StructKeyExists(RCP, "H#cnt#FORM")><cfinvokeargument name="rh_form" value="#RCP['H#cnt#FORM']#" /></cfif>
					<cfif StructKeyExists(RCP, "H#cnt#TIME")>
						<cfif RCP['H#cnt#TIME'] EQ -1>
							<cfinvokeargument name="rh_time" value="0" />
							<cfinvokeargument name="rh_when" value="Dry" />
						<cfelseif RCP['H#cnt#TIME'] EQ 999>
							<cfinvokeargument name="rh_time" value="90" />
							<cfinvokeargument name="rh_when" value="Mash" />
						<cfelse>
							<cfinvokeargument name="rh_time" value="#RCP['H#cnt#TIME']#" />
							<cfinvokeargument name="rh_when" value="Boil" />
						</cfif>
					</cfif>
				</cfinvoke>
			</cfif>
		</cfloop>
		<cfloop from="1" to="5" index="cnt">
			<cfif StructKeyExists(RCP, "M#cnt#AMT")>
				<cfinvoke component="#APPLICATION.CFC.RecipeMisc#" method="InsertRecipeMisc">
					<cfinvokeargument name="rm_reid" value="#RCP.re_reid#" />
					<cfinvokeargument name="rm_usid" value="#SESSION.USER.usid#" />
					<cfif StructKeyExists(RCP, "M#cnt#TYPE")><cfinvokeargument name="rm_type" value="#RCP['M#cnt#TYPE']#" /></cfif>
					<cfif StructKeyExists(RCP, "M#cnt#AMT")><cfinvokeargument name="rm_amount" value="#RCP['M#cnt#AMT']#" /></cfif>
					<cfif StructKeyExists(RCP, "M#cnt#UNIT")><cfinvokeargument name="rm_unit" value="#RCP['M#cnt#UNIT']#" /></cfif>
					<cfinvokeargument name="rm_utype" value="W" />
					<cfinvokeargument name="rm_phase" value="Boil" />
				</cfinvoke>
			</cfif>
		</cfloop>
		<cfinvoke component="#APPLICATION.CFC.RecipeYeast#" method="InsertRecipeYeast">
			<cfinvokeargument name="ry_reid" value="#RCP.re_reid#" />
			<cfinvokeargument name="ry_usid" value="#SESSION.USER.usid#" />
			<cfif isDefined("RCP.YEAST")><cfinvokeargument name="ry_yeast" value="#RCP.YEAST#" /></cfif>
			<cfif isDefined("RCP.BREW_D")><cfinvokeargument name="ry_date" value="#RCP.BREW_D#" /></cfif>
		</cfinvoke>
		<cfset RCP = StructNew() />
		<cfset RCP.COMM = ""/>
		<cfset RCP.PROC = ""/>

	<cfelseif len(Line) GT 11>
		<cfset key = Trim(ListFirst(line, CHR(35))) />
		<cfset value = Trim(Right(line, Len(line)-11 )) />
		<cfif StructKeyExists(RCP, key)>
			<cfset RCP[key] = RCP[key] & value />
		<cfelse>
			<cfset RCP[key] = value />
		</cfif>
	</cfif>


</cfloop>
</cfoutput>

<cfquery name="updRecipeDates" datasource="bih">
		UPDATE recipedates
			SET rd_note = ''
		 WHERE rd_note is null
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_name='Unnamed'
		 WHERE re_name is null
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_name='Bob Märzen'
		 WHERE re_name like 'Bob%'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Unnamed'
		 WHERE re_style is null
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='American IPA'
		 WHERE re_style='India Pale Ale'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='American Barleywine'
		 WHERE re_style='Barley Wine'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Russian Imperial Stout'
		 WHERE re_style='Imperial Stout'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Classic American Pilsner'
		 WHERE re_style='Pre-pro' or re_style='CAP'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Common Cider'
		 WHERE re_style='Cider'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Düsseldorf Altbier'
		 WHERE re_style='Düsseldorf-style Altbier'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Imperial IPA'
		 WHERE re_style='Imperial India Pale Ale'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='American Pale Ale'
		 WHERE re_style in ('Baby Pale Ale','Pale','Classic English Pale Ale','Honey Pale Ale')
		 or (re_style='Unnamed' and re_name in ('Citra','Gbier','Green Flash') )
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Witbier'
		 WHERE re_style='White'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Belgian Tripel'
		 WHERE re_style='tripel'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Belgian Dubbel'
		 WHERE re_style='Dubbel' or re_style='Abdij Beer'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Belgian Dubbel'
		 WHERE re_style='Dubbel' or re_style='Abdij Beer'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Northern English Brown Ale'
		 WHERE re_style='English Brown Ale'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='American Stout'
		 WHERE re_style='Stout'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Extra Special Bitter'
		 WHERE re_style='English Extra Special'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Weizen'
		 WHERE re_style='German-style Weizen'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Spice, Herb, or Vegetable Beer'
		 WHERE re_name='Yammering Fool'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='American Amber Ale'
		 WHERE re_style='Amber Ale'
</cfquery>
<cfquery name="updRecipe" datasource="bih">
		UPDATE recipe
			SET re_style='Bohemian Pilsener'
		 WHERE re_style='Pils'
</cfquery>

<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster
		 WHERE rg_type = gr_type
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type in ('Pale, American 2 Row', 'Pale, American')
			AND gr_type = 'Pale Malt, 2-Row'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Biscuit, Belgian'
			AND gr_type = 'Biscuit Malt'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Black Patent, American'
			AND gr_type = 'Black Malt'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Cara 45, Belgian'
			AND gr_type = 'Cara 45'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Cara-pils, American'
			AND gr_type = 'Carapils Malt'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Cara-pils, Belgian'
			AND gr_type = 'Cara 8'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Chocolate, American'
			AND gr_type = 'Chocolate Malt'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Crystal 20, American'
			AND gr_type = 'Caramel Malt 20L'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Crystal 40, American'
			AND gr_type = 'Caramel Malt 40L'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Crystal 60, American'
			AND gr_type = 'Caramel Malt 60L'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Crystal 80, American'
			AND gr_type = 'Caramel Malt 80L'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Crystal 120, American'
			AND gr_type = 'Caramel Malt 120L'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Munich, Belgian'
			AND gr_type = 'Munich Malt' and gr_maltster='Dingemans'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Special "B", Belgian'
			AND gr_type = 'Special B'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Victory, American'
			AND gr_type = 'Victory'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type in ('Wheat Malt, Belgian', 'Wheat, Belgian Malt')
			AND gr_type = 'Wheat Malt' and gr_maltster='Dingemans'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Vienna, German'
			AND gr_type = 'Vienna' and gr_maltster='Weyermann'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Melanoidin, German'
			AND gr_type = 'Melanoidin' and gr_maltster='Weyermann'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Pale, Belgian'
			AND gr_type = 'Pale Ale Malt' and gr_maltster='Dingemans'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Aromatic, Belgian'
			AND gr_type = 'Aroma 100 Malt' and gr_maltster='Dingemans'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type in ('CaraMunich, Belgian','CaraMunich II, German')
			AND gr_type = 'Cara 45' and gr_maltster='Dingemans'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type in ('Carahelle, Belgian','Carahelles','CaraVienna, Belgian','Caravienne, Belgian')
			AND gr_type = 'Cara 20' and gr_maltster='Dingemans'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Munich, German'
			AND gr_type = 'Munich' and gr_maltster='Weyermann'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Munich, American'
			AND gr_type = 'Munich Malt 10L' and gr_maltster='Briess'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type = 'Pale Ale, American'
			AND gr_type = 'Pale Ale Malt' and gr_maltster='Briess'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_maltster = gr_maltster,
				 rg_type = gr_type
		 WHERE rg_type in ('Pale, American 6 Row', 'Pale, American Klages')
			AND gr_type = 'Pale Malt, 6 Row' and gr_maltster='Briess'
			AND rg_maltster=''
</cfquery>
<cfquery name="updGrains" datasource="bih">
		UPDATE recipegrains, grains
			SET rg_sgc = gr_sgc
				 rg_lvb = gr_lvb
		 WHERE rg_type=gr_type
			AND rg_maltster=gr_maltster
			AND rg_sgc<>gr_sgc
</cfquery>
<cfquery name="updYeast" datasource="bih">
	delete from recipeyeast where ry_yeast is null
</cfquery>
<cfquery name="updYeast" datasource="bih">
		UPDATE recipeyeast, yeast
			SET ry_mfg = ye_mfg,
				 ry_yeast = ye_yeast,
				 ry_mfgno = ye_mfgno,
				 ry_note = ry_yeast
		 WHERE ry_yeast like '%American Ale%'
			AND ye_yeast = 'American Ale' and ye_mfg='Wyeast'
			AND ry_mfg is null

		UPDATE recipeyeast, yeast
			SET ry_mfg = ye_mfg,
				 ry_yeast = ye_yeast,
				 ry_mfgno = ye_mfgno,
				 ry_note = ry_yeast
		 WHERE ry_yeast like '%German Ale%'
			AND ye_yeast = 'German Ale' and ye_mfg='Wyeast'
			AND ry_mfg is null

		UPDATE recipeyeast, yeast
			SET ry_mfg = ye_mfg,
				 ry_yeast = ye_yeast,
				 ry_mfgno = ye_mfgno,
				 ry_note = ry_yeast
		 WHERE (ry_yeast like '%Baravian%' or ry_yeast like '%Bavarian%')
			AND ye_yeast = 'Bavarian Lager' and ye_mfg='Wyeast'
			AND ry_mfg is null

		UPDATE recipeyeast, yeast
			SET ry_mfg = ye_mfg,
				 ry_yeast = ye_yeast,
				 ry_mfgno = ye_mfgno,
				 ry_note = ry_yeast
		 WHERE (ry_yeast like '%Northwest Ale%' or ry_yeast like '%Nw Ale%' or ry_yeast like '%Northwestern Ale%' or ry_yeast like '%Nw Esb%')
			AND ye_yeast = 'Northwest Ale' and ye_mfg='Wyeast'
			AND ry_mfg is null


</cfquery>
<cfquery name="updYeast" datasource="bih">
		UPDATE recipeyeast, yeast
			SET ry_mfg = ye_mfg,
				 ry_yeast = ye_yeast,
				 ry_mfgno = ye_mfgno,
				 ry_note = ry_yeast
		 WHERE ry_yeast like '%2278%'
			AND ye_mfgno = '2278' and ye_mfg='Wyeast'
			AND ry_mfg is null
</cfquery>
