<cfinvoke component="#APPLICATION.CFC.Javascript#" method="IncludeRecipeJS" />
<div id="divRecipeButtons">
	<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" id="btnRecipeAdd" src="bih-icon-pencilnew" onclick="recipeDataAdd()" text="New" class="ui-button-text-tiny smallcaps" />
	<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" id="btnRecipeXML" src="ui-icon-arrowreturnthick-1-s" onclick="recipeImport(this)" text="Import" class="ui-button-text-tiny smallcaps" />
	&nbsp;|&nbsp;
	<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" id="btnRecipeSave" src="bih-icon-disk" onclick="recipeDataSave(this)" text="Save" class="ui-button-text-tiny smallcaps" />
	<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" id="btnRecipeCancel" src="ui-icon-arrowrefresh-1-w" onclick="recipeDataCancel(this)" text="Cancel" class="ui-button-text-tiny smallcaps" />
	<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" id="btnRecipeDelete" src="ui-icon-trash" onclick="recipeDataDelete(this)" text="Delete" class="ui-button-text-tiny smallcaps" />
	&nbsp;|&nbsp;
	<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" id="btnRecipeScale" src="ui-icon-signal" onclick="recipeScaleShow(this)" text="Scale" class="ui-button-text-tiny smallcaps" />
</div>
<form name="frmRecipe" action="?" method="post">
<div id="divRecipe" class="ui-corner-all ui-widget-content">
	<div id="divRecipeHead">
		<table id="tabRecipeHead" class="tabFldData" cellspacing="4">
			<tbody>
			<tr>
				<td>
					<table>
						<tbody>
							<tr>
								<td class="label" width="50">Recipe:</td>
								<td colspan="3"><input type="text" name="re_name" id="re_name" maxlength="35" tabindex="1" /></td>
							</tr>
							<tr>
								<td class="label">Volume:</td>
								<td colspan="3">
									<input class="decimal" type="text" name="re_volume" id="re_volume" maxlength="7" tabindex="2" />
									<select class="vunits" name="re_vunits" id="re_vunits" onchange="recipeVolumeUnits()"></select>
								</td>
							<tr>
								<td class="label">Style:</td>
								<td colspan="3"><input type="text" name="re_style" id="re_style" maxlength="35" tabindex="3" /></td>
							</tr>
							<tr>
								<td class="label">Type:</td>
								<td width="105"><button id="re_mashtype" type="button" class="butRotate mashtype" onclick="recipeShowMash(this, true)">All Grain</button></td>
								<td class="label" width="80">Privacy:</td>
								<td colspan="2">
									<button id="re_privacy" type="button" class="butRotate" onclick="rotatePrivacy(this)" value="0">Public</button>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
				<td class="top">
					<table>
						<tbody>
							<tr>
								<td class="label">OG:</td>
								<td>
									<input class="decimal" type="text" name="re_expgrv2" id="re_expgrv2" disabled="disabled" />
									<button id="re_eunits" style="display:inline" class="butRotate eunits" type="button" onclick="recipeUnitsGravity(this)">SG</button>
								</td>
							<tr>
								<td class="label">IBU:</td>
								<td><input type="text" name="re_expibu2" id="re_expibu2" disabled="disabled" /></td>
							</tr>
							<tr>
								<td class="label">SRM:</td>
								<td><input type="text" name="re_expsrm2" id="re_expsrm2" disabled="disabled" /></td>
							</tr>
							<tr id="trBrewed">
								<td class="label" width="50">Brewed:</td>
								<td><input class="date" type="text" name="re_brewed" id="re_brewed" disabled="disabled" /></td>
							</tr>
						</tbody>
					</table>
				</td>
				<td>
				</td>
			</tr>
			</tbody>
		</table>
	</div>
	<div id="divRecipeTabs" class="easing ui-tabs ui-widget ui-widget-content ui-corner-all">
		<ul id="ulRecipeTabs" class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
			<li class="ui-state-default ui-corner-top ui-tabs-selected ui-state-active easing">
				<a href="#divRecipeIng" title="divRecipeIng"><span>Ingredients</span></a>
			</li>
			<li class="ui-state-default ui-corner-top ui-tabs-selected ui-state-active easing">
				<a href="#divRecipeNotes" title="divRecipeNotes"><span>Notebook</span></a>
			</li>
			<li class="easing" id="RecipeTabMash">
				<a href="c.mash.cfm" title="divRecipeMash"><span>Mashing</span></a>
			</li>
			<li class="easing">
				<a href="c.boil.cfm" title="divCalcKettle"><span>Boiling</span></a>
			</li>
			<li class="easing">
				<a href="c.carb.cfm" title="divCalcCarb"><span>Carbonation</span></a>
			</li>
			<li class="easing">
				<a href="c.alcohol.cfm" title="divCalcAlcohol"><span>% Alcohol</span></a>
			</li>
		</ul>
		<div id="divRecipeIng" class="ui-tabs-panel ui-widget-content ui-corner-bottom">
			<div id="divRecipeGrains">
				<table id="tabRecipeGrains" class="tabRowData datagrid noborder" cellspacing="1">
					<thead class="bubbleHead">
						<tr>
							<th class="icon"><button id="rg_add" type="button" onclick="recipeRowAdd(metaRecipeGrains, '#tabRecipeGrains', $RecipeGrains, true)" class="ui-button-icon-tiny liveHover juiButton-icon-only ui-state-default ui-widget ui-button ui-button-icon-only" title="Add"><span class="ui-button-icon-primary ui-icon ui-icon-circle-plus"></span><span class="ui-button-text ">&nbsp;</span></button></th>
							<th>Malts/Fermentables</td>
							<th>Maltster</th>
							<th>Mash</th>
							<th><select class="wunits edit" name="re_munits" id="re_munits" onchange="recipeUnitsGrains()"></select></th>
							<th>Sgc</th>
							<th>Srm</th>
							<th class="right">%</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="icon" id="rg_delete"></td>
							<td class="inputarea" id="rg_type"></td>
							<td class="inputarea" id="rg_maltster"></td>
							<td class="inputarea center" id="rg_mash"></td>
							<td class="inputarea" id="rg_amount"></td>
							<td class="inputarea" id="rg_sgc"></td>
							<td class="inputarea" id="rg_lvb"></td>
							<td class="right" id="rg_pct"></td>
						</tr>
					</tbody>
					<tfoot class="tabFldData">
						<tr>
							<th class="icon"><button id="rg_hide" type="button" onclick="tbodyHide(this)" class="ui-button-icon-tiny liveHover juiButton-icon-only ui-state-default ui-widget ui-button ui-button-icon-only"><span class="ui-button-icon-primary ui-icon ui-icon-arrowthickstop-1-n"></span><span class="ui-button-text ">&nbsp;</span></button></th>
							<th class="label">Mash Efficiency:</th>
							<th class="left"><input name="re_eff" id="re_eff" type="text" maxlength="3" class="integer" />&nbsp;%</th>
							<th></th>
							<th class="borderro"><input name="re_grnamt" id="re_grnamt" type="text" maxlength="7" class="decimal" disabled="disabled" /></th>
							<th><input name="re_expgrv" id="re_expgrv" type="text" maxlength="5" class="decimal" /></th>
							<th class="borderro"><input name="re_expsrm" id="re_expsrm" type="text" maxlength="5" class="decimal" disabled="disabled" /></th>
							<th></th>
						</tr>
					</tfoot>
				</table>
			</div>
			<div id="divRecipeHops">
				<table id="tabRecipeHops" class="tabRowData datagrid noborder" cellspacing="1">
					<thead class="bubbleHead">
						<tr>
							<th class="icon"><button id="rh_add" type="button" onclick="recipeRowAdd(metaRecipeHops, '#tabRecipeHops', $RecipeHops, true)" class="ui-button-icon-tiny liveHover juiButton-icon-only ui-state-default ui-widget ui-button ui-button-icon-only" title="Add"><span class="ui-button-icon-primary ui-icon ui-icon-circle-plus"></span><span class="ui-button-text ">&nbsp;</span></button></th>
							<th>Hops</th>
							<th>Grown</th>
							<th>Form</th>
							<th>Aau</th>
							<th><select class="wunits edit" name="re_hunits" id="re_hunits" onchange="recipeUnitsHops(this)"></select></th>
							<th>When</th>
							<th>Min</th>
							<th>Ibu</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="icon" id="rh_delete"></td>
							<td class="inputarea" id="rh_hop"></td>
							<td class="inputarea" id="rh_grown"></td>
							<td class="inputarea" id="rh_form"></td>
							<td class="inputarea" id="rh_aau"></td>
							<td class="inputarea" id="rh_amount"></td>
							<td class="inputarea" id="rh_when"></td>
							<td class="inputarea" id="rh_time"></td>
							<td class="inputarea" id="rh_ibu"></td>
						</tr>
					</tbody>
					<tfoot class="tabFldData">
						<tr>
							<th class="icon"><button id="rh_hide" type="button" onclick="tbodyHide(this)" class="ui-button-icon-tiny liveHover juiButton-icon-only ui-state-default ui-widget ui-button ui-button-icon-only"><span class="ui-button-icon-primary ui-icon ui-icon-arrowthickstop-1-n"></span><span class="ui-button-text ">&nbsp;</span></button></th>
							<th class="label">Boil Volume: </th>
							<th class="left"><input class="decimal" type="text" name="re_boilvol" id="re_boilvol" maxlength="7"/></th>
							<th></th>
							<th></th>
							<th class="borderro"><input name="re_hopamt" id="re_hopamt" type="text" maxlength="7" class="decimal" disabled="disabled" /></th>
							<th></th>
							<th></th>
							<th class="borderro"><input name="re_expibu" id="re_expibu" type="text" maxlength="5" class="decimal" disabled="disabled" /></th>
						</tr>
					</tfoot>
				</table>
			</div>
			<div id="divRecipeYeast">
				<table id="tabRecipeYeast" class="tabRowData datagrid noborder" cellspacing="1">
					<thead class="bubbleHead">
						<tr>
							<th class="icon"><button id="rm_add" type="button" onclick="recipeRowAdd(metaRecipeYeast, '#tabRecipeYeast', $RecipeYeast, true)" class="ui-button-icon-tiny liveHover juiButton-icon-only ui-state-default ui-widget ui-button ui-button-icon-only" title="Add"><span class="ui-button-icon-primary ui-icon ui-icon-circle-plus"></span><span class="ui-button-text ">&nbsp;</span></button></th>
							<th>Yeast</th>
							<th>Lab</th>
							<th>Lab #</th>
							<th>Notes</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="icon" id="ry_delete"></td>
							<td class="inputarea" id="ry_yeast"></td>
							<td class="inputarea" id="ry_mfg"></td>
							<td class="inputarea" id="ry_mfgno"></td>
							<td class="inputarea" id="ry_note"></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div id="divRecipeMisc">
				<table id="tabRecipeMisc" class="tabRowData datagrid noborder" cellspacing="1">
					<thead class="bubbleHead">
						<tr>
							<th class="icon"><button id="ry_add" type="button" onclick="recipeRowAdd(metaRecipeMisc, '#tabRecipeMisc', $RecipeMisc, true)" class="ui-button-icon-tiny liveHover juiButton-icon-only ui-state-default ui-widget ui-button ui-button-icon-only" title="Add"><span class="ui-button-icon-primary ui-icon ui-icon-circle-plus"></span><span class="ui-button-text ">&nbsp;</span></button></th>
							<th>Misc Ingredients</td>
							<th>Amount</th>
							<th>Units</th>
							<th>Phase</th>
							<th colspan="2">Time Added</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="icon" id="rm_delete"></td>
							<td class="inputarea" id="rm_type"></td>
							<td class="inputarea center" id="rm_amount"></td>
							<td class="inputarea" id="rm_unit"></td>
							<td class="inputarea" id="rm_phase"></td>
							<td class="inputarea" id="rm_offset"></td>
							<td class="inputarea" id="rm_added"></td>
							<td class="inputarea" id="rm_action"></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div id="divRecipeNotes" class="ui-tabs-panel ui-widget-content ui-corner-bottom">
			<div id="divRecipeDates">
				<table id="tabRecipeDates" class="tabRowData datagrid noborder" cellspacing="1">
					<thead class="bubbleHead">
						<tr>
							<th class="icon"><button id="rd_add" type="button" onclick="recipeRowAdd(metaRecipeDates, '#tabRecipeDates', $RecipeDates, true)" class="ui-button-icon-tiny liveHover juiButton-icon-only ui-state-default ui-widget ui-button ui-button-icon-only" title="Add"><span class="ui-button-icon-primary ui-icon ui-icon-circle-plus"></span><span class="ui-button-text ">&nbsp;</span></button></th>
							<th>Date <input id="rd_datepick" value="Date" /></th>
							<th>Activity</th>
							<th id="disp_eunits"></th>
							<th><button id="re_tunits" class="butRotate tunits edit" type="button" onclick="recipeUnitsTemp(this)" value="F">&deg;F</button></th>
							<th>Notes</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="icon" id="rd_delete"></td>
							<td class="inputarea" id="rd_date"></td>
							<td class="inputarea" id="rd_type"></td>
							<td class="inputarea" id="rd_gravity"></td>
							<td class="inputarea" id="rd_temp"></td>
							<td class="inputarea" id="rd_note"></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div>
				<div id="rd_notehead" class="ui-widget-header ui-corner-top">Brew Notes</div>
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="textarea" name="rd_noteedit" id="rd_noteedit" maxlen="5000" onblur="recipeNoteSave()" disabled="disabled" />
			</div>
		</div>

	</div>
</div>


<div id="divToolbar" class="toolbarIn easing">
	<div id="divToolbarButtons" class="ui-corner-tl toolbarIn easing">
		<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-close" onclick="recipeToolbarToggle(true)" title="Close" class="ui-button-icon-tiny" />
		<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-arrowthickstop-1-e" onclick="recipeToolbarDock()" title="Dock" class="ui-button-icon-tiny" />
		<div id="btnDragger" class="liveHover ui-state-default ui-corner-all"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiIcon" src="ui-icon-arrow-4" style="cursor: move;" title="Move"/></div>
	</div>
	<div id="divToolbarTabs" class="toolbarIn easing">
		<ul id="ulToolbarTabs" class="toolbarIn easing">
			<li>
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-calculator" title="Convert" />
				<a href="c.convert.cfm" title="divToolbarConvert"><span>Convert</span></a>
			</li>
			<li>
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-circle-arrow-w" title="Grains"/>
				<a href="e.grains.cfm" title="divToolbarGrains"><span>Grains</span></a>
			</li>
			<li>
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-circle-arrow-w" title="Hops"/>
				<a href="e.hops.cfm" title="divToolbarHops"><span>Hops</span></a>
			</li>
			<li>
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-circle-arrow-w" title="Yeast"/>
				<a href="e.yeast.cfm" title="divToolbarYeast"><span>Yeast</span></a>
			</li>
			<li>
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-circle-arrow-w" title="Misc"/>
				<a href="e.misc.cfm" title="divToolbarMisc"><span>Misc</span></a>
			</li>
			<li>
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-circle-arrow-w" title="Styles"/>
				<a href="e.bjcpstyles.cfm" title="divToolbarStyles"><span>Styles</span></a>
			</li>
			<li>
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-circle-arrow-w" title="Recipes"/>
				<a href="e.brewlog.cfm" title="divToolbarExplorer"><span>Recipes</span></a>
			</li>
		</ul>
		<div id="divToolbarLoading" style="display: none">
			<img src="images/ajax-loader.gif" height="50" />
		</div>
	</div>
</div>
</form>
<br clear="all" /><br />
<div id="winModal" title="" style="display:none"><table id="tabModal"></table></div>
<table id="tabNotes" style="display:none;">
	<tbody>
		<tr>
			<td>
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="textarea" name="note_edit" id="note_edit" maxlen="80" class="note_edit" />
			</td>
		</tr>
	</tbody>
</table>
<table id="tabCopy" style="display:none;">
	<tbody>
		<tr>
			<td width="400">
				<p>You are currently editing a recipe. Do you want to...</p>
				<div class="ui-widget-content ui-corner-all" style="padding: 10px">
					Discard the changes and open the selected recipe
					<div class="right" style="padding-top: 10px"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-circle-arrow-w" id="btnCopyOpen" onclick="recipeCopyAnswer(this)" text="Open" /></div>
				</div>
				<div class="ui-widget-content ui-corner-all" style="padding: 10px; margin-top: 10px;">
					Copy data from the selected recipe
					<br/>
					<div style="padding: 10px 20px 5px; line-height: 22px;">
					<form name="frmCopy">
					<label><input type="checkbox" name="incHeader" checked /> Include Header (name, volume, style, etc)</label><br />
					<label><input type="checkbox" name="incGrains" checked /> Include Malt/Fermentables</label><br />
					<label><input type="checkbox" name="incHops" checked /> Include Hops</label><br />
					<label><input type="checkbox" name="incYeast" checked /> Include Yeast</label><br />
					<label><input type="checkbox" name="incMisc" checked /> Include Misc Ingredients</label><br />
					<label><input type="checkbox" name="incDates" /> Include Dates</label><br />
					</form>
					</div>
					<div class="right"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-circle-arrow-w" id="btnCopyCopy" onclick="recipeCopyAnswer(this)" text="Copy" /></div>
				</div>
			</td>
		</tr>
	</tbody>
</table>
<table id="tabImport" style="display:none;">
	<tbody>
		<tr>
			<td class="bold"><p>To import a recipe, copy and paste valid beer.xml into the text area below.</p></td>
		</tr>
		<tr>
			<td>
				<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="textarea" name="xml_text" id="xml_text" maxlen="60000" class="note_edit" />
			</td>
		</tr>
	</tbody>
</table>
</div>
