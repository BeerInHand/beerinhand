var selectedRow = {tab: "", row: 0, rowid: 0};
var metaRecipe={RE_REID:["int",0,"<input type=hidden />",""],RE_NAME:["varchar",35,"<input type=text maxlength=35 />",""],RE_VOLUME:["decimal",4.2,"<input type=text maxlength=7 class=decimal />",""],RE_BOILVOL:["decimal",4.2,"<input type=text maxlength=7 class=decimal />",""],RE_STYLE:["varchar",35,"<input type=text maxlength=35 />",""],RE_EFF:["int",0,"<input type=text maxlength=3 class=integer />",""],RE_EXPGRV:["decimal",1.3,"<input type=text maxlength=5 class=decimal readonly=readonly />",""], RE_EXPSRM:["int",0,"<input type=text maxlength=5 class=decimal readonly=readonly />",""],RE_EXPIBU:["decimal",3.1,"<input type=text maxlength=5 class=decimal readonly=readonly />",""],RE_PRIME:["varchar",500,"<textarea></textarea>",""],RE_VUNITS:["varchar",12,"<select class=vunits></select>",""],RE_MUNITS:["varchar",12,"<select class=wunits></select>",""],RE_HUNITS:["varchar",12,"<select class=wunits></select>",""],RE_TUNITS:["varchar",10, "<button class='butRotate tunits' type=button></button>",function(UnitsIn){return TempUnits[UnitsIn]}],RE_EUNITS:["varchar",5,"<button class='butRotate eunits' type=button></button>",""],RE_BREWED:["date",10,"<input type=text maxlength=10 class=date />",function(val){alert('no')}],RE_MASHTYPE:["varchar",12,"<button class='butRotate mashtype' type=button></button>",""],RE_TYPE:["varchar",10,"<input type=text maxlength=10 />",""],RE_GRNAMT:["decimal",4.2,"<input type=text maxlength=7 class=decimal readonly=readonly />",""],RE_MASHAMT:["decimal",4.2,"<input type=text maxlength=7 class=decimal readonly=readonly />", ""],RE_HOPAMT:["decimal",4.2,"<input type=text maxlength=7 class=decimal readonly=readonly />",""],RE_NOTES:["varchar",5E3,"<textarea></textarea>",""],RE_HOPCNT:["tinyint",2,"<input type=text maxlength=2 class=integer readonly=readonly />",""],RE_GRNCNT:["tinyint",2,"<input type=text maxlength=2 class=integer readonly=readonly />",""],RE_PRIVACY:["tinyint",2,"<input type=text maxlength=2 />",function(val){return getPrivacyImg(val)}]};
var metaRecipeGrains={RG_RGID:["int",0,"<input type=hidden />",""],RG_REID:["int",0,"<input type=hidden />",""],RG_TYPE:["varchar",25,"<input type=text maxlength=25 />",""],RG_AMOUNT:["decimal",4.2,"<input type=text maxlength=7 class=decimal />",""],RG_SGC:["decimal",1.3,"<input type=text maxlength=5 class=decimal />",""],RG_LVB:["int",4.1,"<input type=text maxlength=5 class=decimal />",""],RG_MASH:["boolean",1,"<input type=checkbox />",""],RG_MALTSTER:["varchar",25,"<input type=text maxlength=25 />", ""],RG_PCT:["decimal",3.1,"<input type=text maxlength=5 class=decimal readonly=readonly disabled=disabled />",""]};
var metaRecipeHops={RH_RHID:["int",0,"<input type=hidden />",""],RH_REID:["int",0,"<input type=hidden />",""],RH_HOP:["varchar",25,"<input type=text maxlength=25 />",""],RH_AAU:["decimal",2.1,"<input type=text maxlength=4 class=decimal />",""],RH_AMOUNT:["decimal",4.2,"<input type=text maxlength=7 class=decimal />",""],RH_FORM:["varchar",6,"<button type=button class=butRotate onclick='recipeHopForm(this)'></button>",""],RH_TIME:["tinyint",3,"<input type=text maxlength=3 class=integer />",""],RH_IBU:["decimal", 3.1,"<input type=text maxlength=5 class=decimal />",""],RH_GROWN:["varchar",15,"<input type=text maxlength=15 />",""],RH_WHEN:["varchar",4,"<button type=button class=butRotate onclick='recipeHopWhen(this)'></button>",""]};
var metaRecipeYeast={RY_RYID:["int",0,"<input type=hidden />",""],RY_REID:["int",0,"<input type=hidden />",""],RY_YEAST:["varchar",25,"<input type=text maxlength=25 />",""],RY_MFG:["varchar",20,"<input type=text maxlength=20 />",""],RY_MFGNO:["varchar",10,"<input type=text maxlength=10 />",""],RY_DATE:["date",10,"<input type=text maxlength=11 class=date />",""],RY_NOTE:["varchar",2E3,"<input type=text maxlength=2000 />",""]};
var metaRecipeDates={RD_RDID:["int",0,"<input type=hidden />",""],RD_REID:["int",0,"<input type=hidden />",""],RD_DATE:["date",10,"<input type=text maxlength=11 class=date />",""],RD_TYPE:["varchar",10,"<button type=button class=butRotate onclick='rotateDateType(this)'></button>",""],RD_GRAVITY:["decimal",1.3,"<input type=text maxlength=5 class=decimal />",""],RD_TEMP:["decimal",3.1,"<input type=text maxlength=5 class=decimal />",""],RD_NOTE:["varchar",2E3,"<input type=text readonly=readonly maxlength=2000 />",""]};
var metaRecipeMisc={RM_RMID:["int",0,"<input type=hidden />",""],RM_REID:["int",0,"<input type=hidden />",""],RM_TYPE:["varchar",25,"<input type=text maxlength=25 />",""],RM_AMOUNT:["decimal",4.2,"<input type=text maxlength=7 class=decimal />",""],RM_UNIT:["varchar",12,"<select></select>",""],RM_UTYPE:["varchar",1,"<input type=hidden />",""],RM_NOTE:["varchar",25,"<input type=text maxlength=25 />",""],RM_PHASE:["varchar",8,"<button type=button class=butRotate onclick='recipeMiscPhase(this)'></button>", ""],RM_ACTION:["varchar",12,"<button type=button class=butRotate onclick='rotateMiscAction(this)'></button>",""],RM_OFFSET:["tinyint",3,"<input type=text maxlength=3 class=integer />",""],RM_ADDED:["varchar",15,"<button type=button class=butRotate onclick='rotateMiscAdded(this)'></button>",""],RM_SORT:["varchar",8,"<input type=hidden />",""]};
var $note_data;
var $note_edit;
var $Recipe = new Object();
var $RecipeDates = new Array();
var $RecipeGrains = new Array();
var $RecipeHops = new Array();
var $RecipeMisc = new Array();
var $RecipeYeast = new Array();
var frm;
var idxTabs = new Object();

calc2rcpGravity = function() {
	var units = "";
	if (selectedRow.tab=="tabRecipeDates") {
		var $gravity = $("#rd_gravity"+selectedRow.row);
		units = $Recipe.re_eunits.html();
		var $temp = $("#rd_temp"+selectedRow.row);
		var tunits = $Recipe.re_tunits.val();
		var temp = $("#gravity_temp").val();
		var tcunits = $("#gravity_tunits").val();
		$temp.val(convertTemp(tcunits, temp, tunits).toFixed(1));
	}
	if (units=="") {
		showStatusWindow("No Gravity field selected.");
		return;
	}
	var grav = (units=="SG") ? parseFloat($("#hc_sg").val()).toFixed(3) : parseFloat($("#hc_plato").val()).toFixed(1);
	$gravity.val(grav).select().focus();
}
calc2rcpTemp = function() {
	var units = "";
	if (selectedRow.tab=="tabRecipeDates") {
		var $temp = $("#rd_temp"+selectedRow.row);
		units = $Recipe.re_tunits.val();
	}
	if (units=="") {
		showStatusWindow("No temperature field selected.");
		return;
	}
	var temp = (units=="F") ? $("#temp_f").val() : $("#temp_c").val();
	$temp.val(parseFloat(temp).toFixed(2)).select().focus();
}
calc2rcpVolume = function() {
	var units = "";
	if (selectedRow.tab=="tabRecipe") {
		if (selectedRow.row=="re_volume") {
			var $amount = $Recipe.re_volume;
			units = $Recipe.re_vunits.val();
		}
	}
	if (units=="") {
		showStatusWindow("No volume field selected.");
		return;
	}
	var liters = $(".convertLiters").val();
	$amount.val(convertVolume("Liters", liters, units).toFixed(2)).select().focus();
}
calc2rcpWeight = function() {
	var units = "";
	if (selectedRow.tab=="tabRecipeGrains") {
		var $amount = $("#rg_amount"+selectedRow.row);
		units = $Recipe.re_munits.val();
	} else if (selectedRow.tab=="tabRecipeHops") {
		var $amount = $("#rh_amount"+selectedRow.row);
		units = $Recipe.re_hunits.val();
	}
	if (units=="") {
		showStatusWindow("No weight field selected.");
		return;
	}
	var grams = $(".convertGrams").val();
	$amount.val(convertWeight("Grams", grams, units).toFixed(2)).select().focus();
}
rcp2calcGravity = function() {
	if (!window["calcClear"] || isEmpty(selectedRow.tab || "")) return;
	var units;
	if (selectedRow.tab=="tabRecipeDates") {
		var grav = $RecipeDates[selectedRow.row].rd_gravity[0].value;
		units = $Recipe.re_eunits.text();
		var temp = $RecipeDates[selectedRow.row].rd_temp[0].value;
		var tunits = $Recipe.re_tunits.val();
		var tcunits = document.getElementById("gravity_tunits").value;
		document.getElementById("gravity_temp").value = convertTemp(tunits, temp, tcunits).toFixed(1);
	}
	var sg = convertGravity(units, grav, "SG");
	document.getElementById("gravity_sg").value = sg.toFixed(3);
	document.getElementById("gravity_plato").value = convertGravity(units, grav, "Plato").toFixed(1);
	gravityCalc(sg);
}
rcp2calcTemp = function() {
	if (!window["calcClear"] || isEmpty(selectedRow.tab || "")) return;
	var units;
	if (selectedRow.tab=="tabRecipeDates") {
		units = $Recipe.re_tunits.val();
		var temp = $RecipeDates[selectedRow.row].rd_temp[0].value;
	}
	document.getElementById("temp_f").value = convertTemp(units, temp, "F").toFixed(1);
	document.getElementById("temp_c").value = convertTemp(units, temp, "C").toFixed(1);
}
rcp2calcVolume = function() {
	if (!window["calcClear"] || isEmpty(selectedRow.tab || "")) return;
	var amount;
	var units;
	if (selectedRow.tab=="tabRecipe") {
		if (selectedRow.row=="re_volume") {
			units = $Recipe.re_vunits.val();
			amount =  $Recipe.re_volume[0].value;
		}
	} else if (selectedRow.tab=="tabRecipeMisc") {
		units = $RecipeMisc[selectedRow.row].rm_unit.val();
		if (LitersConvert[units]==undefined) return;
		amount = $RecipeMisc[selectedRow.row].rm_amount[0].value;
	}
	calcClear("v", units, parseFloat(amount) || 0);
	ucalcCalc("v");
}
rcp2calcWeight = function() {
	if (!window["calcClear"] || isEmpty(selectedRow.tab || "")) return;
	var amount;
	var units;
	if (selectedRow.tab=="tabRecipeGrains") {
		units = $Recipe.re_munits.val();
		amount = $RecipeGrains[selectedRow.row].rg_amount[0].value;
	} else if (selectedRow.tab=="tabRecipeHops") {
		units = $Recipe.re_hunits.val();
		amount = $RecipeHops[selectedRow.row].rh_amount[0].value;
	} else if (selectedRow.tab=="tabRecipeMisc") {
		units = $RecipeMisc[selectedRow.row].rm_unit.val();
		if (GramsConvert[units]==undefined) return;
		amount = $RecipeMisc[selectedRow.row].rm_amount[0].value;
	}
	calcClear("w", units, parseFloat(amount) || 0);
	ucalcCalc("w");
}
recipeAutoSource = function(request, response, qryData, arrFlds) {
	var matchers = trim(request.term).split(" ");
	for (var i=0;i<matchers.length;i++) matchers[i] = new RegExp($.ui.autocomplete.escapeRegex(matchers[i]), "i");
	response($.grep(qryData,
		function(ROW) {
			for (var i=0;i<matchers.length;i++) {
				var match = false;
				for (var j=0;j<arrFlds.length;j++) match = matchers[i].test(ROW[arrFlds[j]]) || match;
				if (!match) return false;
			}
			return true;
		}
	));
}
recipeCalendarSelect = function(d, inst) {
	if (selectedRow.tab!="tabRecipeDates") return false;
	$RecipeDates[selectedRow.row].rd_date[0].value = d;
	inst.input[0].value="Date";
}
recipeCalendarShow = function(inp, inst) {
	if (selectedRow.tab!="tabRecipeDates") {
		showStatusWindow("No date field selected.");;
		return false;
	}
	var d = $RecipeDates[selectedRow.row].rd_date[0].value;
	$("#rd_datepick").datepicker("setDate", d);
}
recipeCallBack = function(response) {
	var msg;
	if (!response.SUCCESS) {
		cbErrors(response);
	} else {
		if (response.DATA.METHOD=="Invalid") {
			showStatusWindow(response.DATA.message, 500, true);
		} else if (response.DATA.METHOD=="Fetch") {
			recipeHashable(response.DATA.RCP);
			RCP = response.DATA.RCP;
			if (response.DATA.COPY==undefined) {
				recipeDataLoad();
			} else {
				recipeCopy(response.DATA);
			}
		} else if (response.DATA.METHOD=="ParseXML") {
			recipeImportLoad(response.DATA.Recipes);
		} else if (response.DATA.METHOD=="Delete") {
			showStatusWindow("Recipe Deleted.");
			if (window["qryBrewLog"]) $("#bl_reid"+key).fadeOut();
			recipeFetch(0);
		} else if (response.DATA.METHOD=="Insert") {
			showStatusWindow("Recipe Added.");
			RCP = recipeHashable(response.DATA.RCP);
			recipeDataLoad();
		} else if (response.DATA.METHOD=="Update") {
			showStatusWindow("Recipe Saved.");
			RCP = recipeHashable(response.DATA.RCP);
			recipeDataLoad();
		}
	}
}
recipeChildLoad = function(qry, meta, tabId, fnNew) {
	var arr = new Array();
	var $cols = $(tabId).find("tbody").find("td").empty();
	var fldidx = 0;
	for (var i=0; i<qry.DATA.length; i++) {
		var flds = new Object();
		$cols.each(
			function() {
				var $col = $(this);
				flds[$col.attr("id")] = recipeCreateInput($col, fldidx, meta);
			}
		);
		if (typeof fnNew=="function") fnNew(fldidx);
		loadRowToForm(qry.DATA[i], frm, meta, fldidx);
		arr[fldidx++] = flds;
	}
	return arr;
}
recipeChildSave = function($flds, qry, fnNew) {
	var rowidx = 0;
	$.each($flds,
		function(fldidx, $row) {
			if (typeof $row=="object") {
				if (qry.DATA.length-1 < rowidx) {
					queryAddRow(qry);
					if (typeof fnNew=="function") fnNew(qry.DATA[rowidx]);
				}
				loadFormToRow(frm, qry.DATA[rowidx], fldidx);
				qry.DATA[rowidx]._DELETED = false;
				rowidx++;
			}
		}
	);
	for (var row = rowidx; row < qry.DATA.length; row++) {
		qry.DATA[row]._DELETED = true;
	}
	return rowidx;
}
recipeCopy = function(DATA) {
	DATA.RCP._ADD = true;
	if (DATA.COPY.incHeader) loadRowToForm(DATA.RCP.qryRecipe.DATA[0], frm, metaRecipe);
	if (DATA.COPY.incGrains) $RecipeGrains = recipeChildLoad(DATA.RCP.qryRecipeGrains, metaRecipeGrains, "#tabRecipeGrains");
	if (DATA.COPY.incHops) $RecipeHops = recipeChildLoad(DATA.RCP.qryRecipeHops, metaRecipeHops, "#tabRecipeHops");
	if (DATA.COPY.incYeast) $RecipeYeast = recipeChildLoad(DATA.RCP.qryRecipeYeast, metaRecipeYeast, "#tabRecipeYeast");
	if (DATA.COPY.incMisc) $RecipeMisc = recipeChildLoad(DATA.RCP.qryRecipeMisc, metaRecipeMisc, "#tabRecipeMisc", recipeMiscRowInit);
	if (DATA.COPY.incDates) $RecipeDates = recipeChildLoad(DATA.RCP.qryRecipeDates, metaRecipeDates, "#tabRecipeDates");
	if (DATA.COPY["forced"]!=undefined) showStatusWindow("You are working with a <i>copy</i> of this recipe.<br>Clicking save will added it to your recipe database.<br>To track it without saving, add it as a favorite.",6000);
}
recipeCopyAnswer = function(btn) {
	var $btn = $(btn);
	var reid = $btn.closest("tbody").data("reid");
	$winModal.dialog("close");
	if ($btn.text()=="Open") {
		return recipeFetch(reid);
	}
	var DATA = new Object();
	DATA.re_reid = reid;
	DATA.copy = new Object();
	$(document.frmCopy).find("input").each(function() { DATA.copy[this.name] = this.checked; });
	remoteCall("Recipe.Fetch", DATA, recipeCallBack);
}
recipeCopyShow = function(reid) {
	document.frmCopy.reset()
	var $copyBody = $("#tabCopy").find("tbody");
	$copyBody.data("reid", reid);
	$winModal.bind("dialogclose", function(event) { $("#tabCopy").append($("#tabModal").find("tbody")); } );
	$winModal.dialog("option", "buttons", {
		"Cancel": function() { $(this).dialog("close"); }
	});
	$("#tabModal").append($copyBody);
	$winModal.dialog("option", "title", "Open or Copy?");
	$winModal.dialog("open");
}
recipeCreateInput = function(col, row, meta) {
	var name = col.attr("id");
	if (col.attr("class")=="icon") {
		var htm = "<button class='ui-button-icon-tiny liveHover juiButton-icon-only ui-state-default ui-widget ui-button ui-button-icon-only' onclick='recipeRowDelete(this)' title='Delete' type='button'><span class='ui-button-icon-primary ui-icon ui-icon-trash'></span><span class='ui-button-text '>&nbsp;</span></button>";
		var $htm = $(htm).attr("name", name+row).attr("id", name+row).val(row);
	} else {
		var htm = meta[name.toUpperCase()][metaInput];
		var $htm = $(htm).attr("name", name+row).attr("id", name+row).addClass(name);
	}
	$htm.data("row", row);
	var $rtn = $htm;
	if (name=="ry_note") {
		$rtn = $("<div class='editNote'><button class='ui-button-icon-tiny liveHover juiButton-icon-only ui-state-default ui-widget ui-button ui-button-icon-only' onclick='recipeYeastNote(this)' title='Edit' type='button'><span class='ui-button-icon-primary ui-icon ui-icon-script'></span><span class='ui-button-text '>&nbsp;</span></button></div>").append($htm);
		$rtn.attr("id", "div"+name+row);
	}
	$rtn.addClass("rcpinp"+row);
	col.append($rtn);
	return $htm;
}
recipeDataAdd = function() {
	if (recipeIsChanged() && !confirm("You are currently editing a recipe. Do you want to discard the changes and add a new recipe?")) return false;
	recipeFetch(-1);
}
recipeDataCalcSave = function(jqSel, ROW, key) {
	var $inp = $(jqSel).find("input, select, button.butRotate");
	if (!$inp.length) return;
	var obj = {};
	$inp.each( function() { obj[this.id] = $(this).val()});
	ROW[key] = JSON.stringify(obj);
}
recipeDataCancel = function() {
	recipeDataLoad();
}
recipeDataDelete = function() {
	if (!confirm("Are you sure you want to delete this Recipe?")) return;
	if (RCP._ADD) return recipeFetch(-1);
	if (RCP._LOCAL) return recipeDataDeleteLS();
	if (!isLoggedIn()) return;
	RCP.qryRecipe.DATA[0]._DELETED = true;
	var ROW = new Object();
	ROW.qryRecipe = RCP.qryRecipe;
	remoteCall("Recipe.Process", ROW, recipeCallBack);
}
recipeDataDeleteLS = function() {
	var key = RCP.qryRecipe.DATA[0].RE_REID;
	bihStorage.removeItem("BIHDETAIL"+key.toString());
	var rcpList = bihStorage.getItem("BIHLIST");
	rcpList = (rcpList) ? rcpList.split(",") : [];
	rcpList = $.grep(rcpList, function(value) { return value != key; });
	bihStorage.setItem("BIHLIST", rcpList.join(","));
	showStatusWindow("Recipe Deleted from Local Storage.");
	if (window["qryBrewLog"]) $("#bl_reid"+key).fadeOut();
	recipeFetch();
}
recipeDataLoad = function() {
	selectedRow = {tab: "", row: 0, rowid: 0};
	loadRowToForm(RCP.qryRecipe.DATA[0], frm, metaRecipe);
	$RecipeGrains = recipeChildLoad(RCP.qryRecipeGrains, metaRecipeGrains, "#tabRecipeGrains");
	$RecipeHops = recipeChildLoad(RCP.qryRecipeHops, metaRecipeHops, "#tabRecipeHops");
	$RecipeYeast = recipeChildLoad(RCP.qryRecipeYeast, metaRecipeYeast, "#tabRecipeYeast");
	$RecipeMisc = recipeChildLoad(RCP.qryRecipeMisc, metaRecipeMisc, "#tabRecipeMisc", recipeMiscRowInit);
	$RecipeDates = recipeChildLoad(RCP.qryRecipeDates, metaRecipeDates, "#tabRecipeDates");
	$rd_noteedit.val("").attr("disabled","disabled");
	recipeShowBrewed();
	recipeShowMash($Recipe.re_mashtype);
	if (RCP.qryRecipe.DATA[0].RE_REID==0) { // ADD
		RCP._ADD = true;
		$(".tabRowData").find("tbody").unbind("focusin");
		selectedRow = {tab: "", row: 0, rowid: 0};
		for (var i=0; i<3;i++) recipeRowAdd(metaRecipeGrains, "#tabRecipeGrains", $RecipeGrains);
		for (var i=0; i<3;i++) recipeRowAdd(metaRecipeHops, "#tabRecipeHops", $RecipeHops);
		recipeRowAdd(metaRecipeYeast, "#tabRecipeYeast", $RecipeYeast);
		recipeRowAdd(metaRecipeMisc, "#tabRecipeMisc", $RecipeMisc);
		recipeRowAdd(metaRecipeDates, "#tabRecipeDates", $RecipeDates);
		$note_edit[0].value = "";
		$(".tabRowData").find("tbody").focusin(recipeRowEdit);
		frm.re_name.focus();
	} else {
		recipeSumGrains();
		recipeGravityFromEff();
		recipeSRM();
		recipeSumHops();
		recipeIBUs("IBU");
	}
	calcClear("m");
	calcClear("k");
	calcClear("c");
	calcClear("a");
	recipeFieldOrder();
}
recipeDataSave = function() {
	if (!recipeIsValid()) return;
	loadFormToRow(frm, RCP.qryRecipe.DATA[0]);
	var reid = RCP.qryRecipe.DATA[0].RE_REID;
	RCP.qryRecipe.DATA[0].RE_GRNCNT = recipeChildSave($RecipeGrains, RCP.qryRecipeGrains, function(newRow) {newRow.RG_REID = reid; newRow.RG_RGID = 0;});
	RCP.qryRecipe.DATA[0].RE_HOPCNT = recipeChildSave($RecipeHops, RCP.qryRecipeHops, function(newRow) {newRow.RH_REID = reid; newRow.RH_RHID = 0;});
	recipeChildSave($RecipeYeast, RCP.qryRecipeYeast, function(newRow) {newRow.RY_REID = reid; newRow.RY_RYID = 0;});
	recipeChildSave($RecipeMisc, RCP.qryRecipeMisc, function(newRow) {newRow.RM_REID = reid; newRow.RM_RMID = 0;});
	recipeChildSave($RecipeDates, RCP.qryRecipeDates, function(newRow) {newRow.RD_REID = reid; newRow.RD_RDID = 0;});
	recipeDataCalcSave("#tabMash", RCP.qryRecipe.DATA[0], "RE_MASH");
	recipeDataCalcSave("#tabCarb", RCP.qryRecipe.DATA[0], "RE_PRIME");
	if (isLoggedIn()) {
		RCP.qryRecipe.DATA[0].RE_USID = bihUser.USID;
		remoteCall("Recipe.Process", RCP, recipeCallBack);
	} else {
		recipeDataSaveLS();
		recipeDataLoad();
	}
}
recipeDataSaveLS = function(Recipe) {
	if (!bihStorage) return alert("Your browser does not support HTML5 local storage. Please create an account to save recipes.");
	if (RCP._ADD) {
		var seq = toInt(bihStorage.getItem("BIHSEQ"),1e7);
		bihStorage.setItem("BIHSEQ", ++seq);
		var rcpList = bihStorage.getItem("BIHLIST");
		rcpList = (rcpList) ? rcpList.split(",") : [];
		rcpList.push(seq);
		bihStorage.setItem("BIHLIST", rcpList.join(","));
		RCP.qryRecipe.DATA[0].RE_REID = seq;
		RCP._LOCAL = true;
		RCP._ADD = false;
	}
	bihStorage.setItem("BIHDETAIL"+seq.toString(), JSON.stringify(RCP));
	bihStorage.setItem("BIHLAST", seq);
	showStatusWindow("Recipe Saved in Local Storage.");
}
recipeEffFromGravity = function() {
	var grv = parseFloat($Recipe.re_expgrv[0].value) || 0;
	if (grv < 1) return;
	var mashed = 0;
	var unmashed = 0;
	for (var i=0; i<$RecipeGrains.length; i++) {
		if ($RecipeGrains[i]) {
			var sgc = parseFloat($RecipeGrains[i].rg_sgc[0].value) || 1;
			var amt = parseFloat($RecipeGrains[i].rg_amount[0].value) || 0;
			if ($RecipeGrains[i].rg_mash[0].checked) {
				mashed += (sgc-1) * amt;
			} else {
				unmashed += (sgc-1) * amt;
			}
		}
	}
	var v_in_gallons = convertVolume($Recipe.re_vunits.val(), $Recipe.re_volume[0].value, "Gallons");
	var munits = $Recipe.re_munits.val();
	mashed = convertWeight(munits, mashed, "Lbs") / v_in_gallons;
	unmashed = convertWeight(munits, unmashed, "Lbs") / v_in_gallons;
	var eff = (grv - unmashed - 1) / mashed * 100;
	if (eff > 100) {
		showStatusWindow("Gravity entered would require > 100 % efficency");
		$Recipe.re_eff[0].value = 100;
		recipeGravityFromEff();
	} else if (eff < 0) {
		showStatusWindow("Gravity entered would require < 0 % efficency");
		$Recipe.re_eff[0].value = 1;
		recipeGravityFromEff();
	} else {
		$Recipe.re_eff[0].value = eff.toFixed(0);
	}
}
recipeEventGrain = function(event) {
	if (event.type=="change") event.which=13;
	spinnerInc(event);
	if (!event.data.changed) return true;
	var fld = event.target.name;
	if (fld.starts("rg_amount")) {
		recipeSumGrains();
		recipeGravityFromEff();
		recipeSRM();
		recipeIBUs("IBU");
	} else if (fld.starts("rg_sgc") || fld=="re_eff") {
		recipeGravityFromEff();
		recipeIBUs("IBU");
	} else if (fld.starts("rg_lvb")) {
		recipeSRM();
	} else if (fld.starts("re_expgrv")) {
		recipeEffFromGravity();
	}
}
recipeEventHop = function(event) {
	if (event.type=="change") event.which=13;
	spinnerInc(event);
	if (!event.data.changed) return true;
	var fld = event.target.name;
	var row = event.target.getAttribute("row");
	if (fld.starts("rh_amount")) {
		recipeIBUs("IBU");
	} else if (fld.starts("rh_aau") || fld.starts("rh_time")) {
		recipeIBUs("IBU");
	} else if (fld.starts("rh_ibu")) {
		recipeIBUs("Amount", row);
	}
	recipeSumHops();
}
recipeEventVolume = function(event) {
	if (event.type=="change") event.which=13;
	spinnerInc(event);
	if (!event.data.changed) return true;
	recipeGravityFromEff();
	recipeSRM();
	recipeIBUs("IBU");
}
recipeFetch = function(reid) {
	if (!isLoggedIn() || reid > 1e7) {
		if (recipeFetchLS(reid)) return;
	}
	var DATA = new Object();
	DATA.re_reid = reid;
	remoteCall("Recipe.Fetch", DATA, recipeCallBack);
}
recipeFetchLS = function(reid, copy) {
	if (!reid) {
		reid = bihStorage.getItem("BIHLAST") || 0;
		var rcpList = bihStorage.getItem("BIHLIST");
		rcpList = (rcpList) ? rcpList.split(",") : [];
		if ($.inArray(reid, rcpList)==-1) reid = (!rcpList.length) ? 0 : rcpList.pop();
	}
	if (reid!=0) {
		RCP = JSON.parse(bihStorage.getItem("BIHDETAIL"+reid));
		if (RCP) {
			var response = {"SUCCESS":true,"LOGGEDIN":false,"ERRORS":[],"DATA":{"RCP": RCP,"METHOD":"Fetch"}};
			recipeCallBack(response);
			return true;
		}
	}
	return false;
}
recipeFieldOrder = function() {
	var tabIdx = 4;
	var arr = "rg_type,rg_maltster,rg_mash,rg_amount,rg_sgc,rg_lvb".split(",");
	$.each($RecipeGrains, function(fldidx, $row) { if (typeof $row=="object") { for (var i=0;i<arr.length;i++) { $row[arr[i]].attr("tabIndex", tabIdx++);	 } } } );
	$Recipe.re_eff.attr("tabIndex", tabIdx++);
	$Recipe.re_expgrv.attr("tabIndex", tabIdx++);
	arr = "rh_hop,rh_grown,rh_form,rh_aau,rh_amount,rh_when,rh_time,rh_ibu".split(",");
	$.each($RecipeHops, function(fldidx, $row) { if (typeof $row=="object") { for (var i=0;i<arr.length;i++) { $row[arr[i]].attr("tabIndex", tabIdx++);	 } } } );
	$Recipe.re_boilvol.attr("tabIndex", tabIdx++);
	arr = "ry_yeast,ry_mfg,ry_mfgno,ry_note".split(",");
	$.each($RecipeYeast, function(fldidx, $row) { if (typeof $row=="object") { for (var i=0;i<arr.length;i++) { $row[arr[i]].attr("tabIndex", tabIdx++);	 } } } );
	arr = "rm_type,rm_amount,rm_unit,rm_phase,rm_offset,rm_added,rm_action".split(",");
	$.each($RecipeMisc, function(fldidx, $row) { if (typeof $row=="object") { for (var i=0;i<arr.length;i++) { $row[arr[i]].attr("tabIndex", tabIdx++);	 } } } );
	arr = "rd_date,rd_type,rd_gravity,rd_temp,rd_note".split(",");
	$.each($RecipeDates, function(fldidx, $row) { if (typeof $row=="object") { for (var i=0;i<arr.length;i++) { $row[arr[i]].attr("tabIndex", tabIdx++);	 } } } );
}
recipeGrainsAuto = function() {
	var $rg_type = $RecipeGrains[selectedRow.row].rg_type;
	if ($rg_type.attr("autocomplete")) return; // ALREADY THERE
	$rg_type.autocomplete({
		source: function(request, response) { return recipeAutoSource(request, response, qryGrains.DATA, ["GR_TYPE","GR_MALTSTER"]) },
		focus: function(event, ui) { return false },
		select:
			function(event, ui) {
				recipeGrainsFill(ui.item);
				grainsScatter(ui.item, $("#infoGrains"));
				grainsScrollTo();
				return false;
			}
	});
	$rg_type.autocomplete("widget").addClass("ac_results");
	$rg_type.data("autocomplete")._renderItem = function(ul, ROW) {
		return $("<li></li>").data("item.autocomplete", ROW).append("<a>" + ROW.GR_TYPE + ", " + ROW.GR_MALTSTER + "</a>").appendTo(ul);
	}
}
recipeGrainsFill = function(ROW) {
	$RecipeGrains[selectedRow.row].rg_type[0].value = ROW.GR_TYPE;
	$RecipeGrains[selectedRow.row].rg_maltster[0].value = ROW.GR_MALTSTER;
	$RecipeGrains[selectedRow.row].rg_mash.attr("checked", ROW.GR_MASH);
	$RecipeGrains[selectedRow.row].rg_sgc[0].value = ROW.GR_SGC.toFixed(3);
	$RecipeGrains[selectedRow.row].rg_lvb[0].value = ROW.GR_LVB;
	$RecipeGrains[selectedRow.row].rg_amount[0].focus();
	if (toFloatMin($RecipeGrains[selectedRow.row].rg_amount[0].value,0)) {
		recipeGravityFromEff();
		recipeSRM();
	}
	selectedRow.rowid = ROW._ROWID;
}
recipeGrainsFind = function() {
	if (!$RecipeGrains.length) return;
	var editrow = 0;
	if (selectedRow.tab=="tabRecipeGrains") {
		editrow=selectedRow.row;
		recipeGrainsAuto();
	}
	var rg_type = $RecipeGrains[editrow].rg_type[0].value
	var rg_maltster = $RecipeGrains[editrow].rg_maltster[0].value
	var rowid = querySearchIdx(qryGrains, idxGrains, "GR_TYPE", rg_type, "GR_MALTSTER", rg_maltster);
	if (rowid!=-1) {
		selectedRow.rowid = rowid;
		grainsScatter(qryGrains.DATA[rowid], $("#infoGrains"));
		grainsScrollTo();
	}
}
recipeGrainsPick = function(btn) {
	if (selectedRow.tab!="tabRecipeGrains") return;
	var $tr = $(btn).parents("tr")
	var rowid = $tr.data("rowid") || 0;
	recipeGrainsFill(qryGrains.DATA[rowid]);
}
recipeGravityFromEff = function () {
	var ExpSG = 0;
	var MashEff = parseInt($Recipe.re_eff[0].value);
	var munits = $Recipe.re_munits.val();
	for (var i=0; i<$RecipeGrains.length; i++) {
		if ($RecipeGrains[i]) {
			var sgc = parseFloat($RecipeGrains[i].rg_sgc[0].value) || 1.000;
			var amt = parseFloat($RecipeGrains[i].rg_amount[0].value) || 0;
			var eff = $RecipeGrains[i].rg_mash[0].checked ? MashEff/100 : 1;
			ExpSG = ExpSG + (sgc - 1) * amt * eff;
		}
	}
	ExpSG = 1 + convertWeight(munits, ExpSG, "Lbs") / convertVolume($Recipe.re_vunits.val(), $Recipe.re_volume[0].value, "Gallons")
	var eunits = $Recipe.re_eunits.text()
	$Recipe.re_expgrv[0].value = formatGravity(convertGravity("SG", ExpSG, eunits), eunits);
	getById("re_expgrv2").value = $Recipe.re_expgrv[0].value;
}
recipeHashable = function(rcpHash) {
	queryMakeHashable(rcpHash.qryRecipe);
	queryMakeHashable(rcpHash.qryRecipeGrains);
	queryMakeHashable(rcpHash.qryRecipeHops);
	queryMakeHashable(rcpHash.qryRecipeYeast);
	queryMakeHashable(rcpHash.qryRecipeMisc);
	queryMakeHashable(rcpHash.qryRecipeDates);
	return rcpHash;
}
recipeHopForm = function(btn) {
	rotateHopForm(btn);
	recipeIBUs("IBU");
}
recipeHopsAuto = function() {
	var $rh_hop = $RecipeHops[selectedRow.row].rh_hop;
	if ($rh_hop.attr("autocomplete")) return; // ALREADY THERE
	$rh_hop.autocomplete({
		source: function(request, response) { return recipeAutoSource(request, response, qryHops.DATA, ["HP_HOP","HP_GROWN"]) },
		focus: function(event, ui) { return false },
		select:
			function(event, ui) {
				recipeHopsFill(ui.item);
				hopsScatter(ui.item, $("#infoHops"));
				hopsScrollTo();
				return false;
			}
	});
	$rh_hop.autocomplete("widget").addClass("ac_results");
	$rh_hop.data("autocomplete")._renderItem = function(ul, ROW) {
		return $("<li></li>").data("item.autocomplete", ROW).append("<a>" + ROW.HP_HOP + ", " + ROW.HP_GROWN + "</a>").appendTo(ul);
	}
}
recipeHopsFill = function(ROW) {
	$RecipeHops[selectedRow.row].rh_hop[0].value = ROW.HP_HOP;
	$RecipeHops[selectedRow.row].rh_grown[0].value = ROW.HP_GROWN;
	$RecipeHops[selectedRow.row].rh_aau[0].value = ROW.HP_AALOW;
	$RecipeHops[selectedRow.row].rh_aau[0].focus();
	if (selectedRow.row>0) {
		var prevRow = selectedRow.row-1;
		var prevHop = $RecipeHops[prevRow].rh_hop[0].value || ""
		if (prevHop==ROW.HP_HOP) {
			$RecipeHops[selectedRow.row].rh_aau[0].value = $RecipeHops[prevRow].rh_aau[0].value;
			rotateSetVal($RecipeHops[selectedRow.row].rh_form[0], $RecipeHops[prevRow].rh_form[0].value);
			rotateSetVal($RecipeHops[selectedRow.row].rh_when[0], $RecipeHops[prevRow].rh_when[0].value);
		}
	}
	selectedRow.rowid = ROW._ROWID;
}
recipeHopsFind = function() {
	if (!$RecipeHops.length) return;
	var editrow = 0;
	if (selectedRow.tab=="tabRecipeHops") {
		editrow=selectedRow.row;
		recipeHopsAuto();
	}
	var rh_hop = $RecipeHops[editrow].rh_hop[0].value;
	var rh_grown = $RecipeHops[editrow].rh_grown[0].value;
	var rowid = querySearchIdx(qryHops, idxHops, "HP_HOP", rh_hop, "HP_GROWN", rh_grown);
	if (rowid!=-1) {
		selectedRow.rowid = rowid;
		hopsScatter(qryHops.DATA[rowid], $("#infoHops"));
		hopsScrollTo();
	}
}
recipeHopsPick = function(btn) {
	if (selectedRow.tab!="tabRecipeHops") return;
	var $tr = $(btn).parents("tr")
	var rowid = $tr.data("rowid") || 0;
	recipeHopsFill(qryHops.DATA[rowid]);
}
recipeHopWhen = function(btn) {
	rotateHopWhen(btn);
	recipeIBUs("IBU");
}
recipeIBUs = function(mode, row) {
	var expibu = 0;
	var total = 0;
	var vunits = $Recipe.re_vunits.val();
	var volume = $Recipe.re_volume[0].value;
	var boilvol = $Recipe.re_boilvol[0].value;
	var eunits = $Recipe.re_eunits.text();
	var expgrv = $Recipe.re_expgrv[0].value;
	var hunits = $Recipe.re_hunits.val();
	var start = 0;
	var len = $RecipeHops.length;
	if (row!=undefined) {
		start = parseInt(row);
		len = start+1;
	}
	for (var i=start; i<len; i++) {
		if ($RecipeHops[i]) {
			var form = $RecipeHops[i].rh_form[0].value;
			var aau = $RecipeHops[i].rh_aau[0].value;
			var amount = $RecipeHops[i].rh_amount[0].value;
			var when = $RecipeHops[i].rh_when[0].value;
			var time = $RecipeHops[i].rh_time[0].value;
			if (mode=="Amount") {
				var ibu = $RecipeHops[i].rh_ibu[0].value;
				amount = ibuAmountFromIBU(vunits, volume, eunits, expgrv, hunits, ibu, aau, form, time, when, boilvol)
				$RecipeHops[i].rh_amount[0].value = amount.toFixed(2);
			} else {
				var ibu = ibuIBUFromAmount(vunits, volume, eunits, expgrv, hunits, amount, aau, form, time, when, boilvol);
				$RecipeHops[i].rh_ibu[0].value = ibu.toFixed(1);
			}
			expibu += ibu;
			total += parseFloat(amount) || 0;
		}
	}
	if (row!=undefined) return;
	$Recipe.re_hopamt[0].value = total.toFixed(2);
	$Recipe.re_expibu[0].value = expibu.toFixed(0);
	getById("re_expibu2").value = $Recipe.re_expibu[0].value;
}
recipeImport = function() {
	if (recipeIsChanged() && !confirm("You are currently editing a recipe. Do you want to discard the changes and import a recipe?")) return false;
	var $impBody = $("#tabImport").find("tbody");
	$winModal.bind("dialogclose", function(event) { $("#tabImport").append($("#tabModal").find("tbody")); } );
	$winModal.dialog("option", "buttons", {
		"Import": function() { recipeImportValidate(); },
		"Cancel": function() { $(this).dialog("close"); }
	});
	$("#tabModal").append($impBody);
	$("#xml_text").val("");
	var title  = "Beer.xml Import";
	$winModal.dialog("option", "title", title);
	$winModal.dialog("open");
}
recipeImportLoad = function(Recipes) {
	var rows = Recipes.length;
	if (!rows) {
		return showStatusWindow("A beer recipe was not found in the provided XML.");
	} else if (rows>1) {
		if (bihStorage) {
			qryBrewLog = {DATA:[]};
			for (var i=1;i<rows;i++) { // SKIP THE FIRST ROW SINCE WE'LL PRESENT IT THE USER
				recipeHashable(Recipes[i]);
				var seq = toInt(bihStorage.getItem("BIHSEQ"));
				bihStorage.setItem("BIHSEQ", ++seq);
				var rcpList = bihStorage.getItem("BIHLIST");
				rcpList = (rcpList) ? rcpList.split(",") : [];
				rcpList.push(seq);
				bihStorage.setItem("BIHLIST", rcpList.join(","));
				Recipes[i].qryRecipe.DATA[0].RE_REID = -seq;
				bihStorage.setItem("BIHDETAIL"+seq.toString(), JSON.stringify(Recipes[i]));
				bihStorage.setItem("BIHLAST", seq);
				qryBrewLog.DATA.push(Recipes[i].qryRecipe.DATA[0]);
			}
			rows--;
			$divToolbarTabs.tabs("load", idxTabs["Recipes"]);
			showStatusWindow(rows+" additional beer recipes were imported and saved to local storage. They can be viewed and saved from the Brew Log.");
		} else {
			alert("Your browser does not support HTML5 local storage.");
		}
	}
	recipeHashable(Recipes[0]);
	RCP = Recipes[0];
	recipeDataLoad();
	$winModal.dialog("close");
}
recipeImportValidate = function() {
	var $xml = $("#xml_text");
	var xml = $xml.val();
	if (isEmpty($xml[0], "You must paste valid xml.")) return;
	try {
		var xmlDoc = $.parseXML(xml);
	} catch (err) {
		return alert("Please provide only valid xml data.");
	}
	var recipes = xmlDoc.getElementsByTagName("RECIPE");
	if (!recipes.length) return alert("A beer recipe was not found in the provided XML.");
	if (recipes.length==1) {
		var msg =recipes[0].getElementsByTagName("NAME")[0].textContent;
	} else {
		var msg = recipes.length + addS(" recipe", recipes.length);
	}
	remoteCall("BeerXML.ParseXML", { xml:xml }, recipeCallBack);
	showStatusWindow("Importing " + msg + "...");
}
recipeInit = function() {
	frm = document.frmRecipe;
	popUnitSelect(".vunits", LitersConvert);
	popUnitSelect(".wunits", GramsConvert);
	$note_edit = $("#note_edit");
	$rd_noteedit = $("#rd_noteedit");
	var $rd_datepick = $("#rd_datepick");
	$rd_datepick.datepicker({showOn: "button", buttonImageOnly: true, buttonImage: bihPath.img+"/trans.gif", beforeShow: recipeCalendarShow, onSelect: recipeCalendarSelect});
	$("#tabRecipeDates").find(".ui-datepicker-trigger").addClass("bih-icon bih-icon-calendar");
	$("[name^='re_']").focus(recipeRowEdit);
	$(".tabRowData").find("tbody").focusin(recipeRowEdit);
	$divRecipeTabs = $("#divRecipeTabs").tabs({ show: recipeTabShow, cache: true, spinner: "<span class=font7>Brewing&#8230;</span>" });
	$divToolbarTabs = $("#divToolbarTabs").tabs({ load: recipeTabLoadedTB, select: recipeTabSelectedTB, cache: true, spinner: "<span class=font7>Brewing&#8230;</span>", ajaxOptions: { cache: false } });
	$divToolbarTabs.find("li").each(
		function(idx) {
			var $this = $(this);
			var txt = $(this).find("a").text();
			idxTabs[txt] = idx;
			$this.removeClass("ui-corner-top").addClass("ui-corner-all");
			$this.find("a").attr("title", txt);
		}
	);
	$divToolbarTabs.find("ul").removeClass("ui-widget-header");
	$("#ulToolbarTabs").removeClass("ui-corner-all").addClass("ui-corner-bl");
	var $div = $("<div>").attr("id", "divToolbarTabWrap").addClass("toolbarIn");
	$divToolbarTabs.find(">div").each( function() { $div.append(this); } ); // PUT ALL TABS IN NEW CONTAINER
	$divToolbarTabs.append($div);
	$("#divToolbarConvert").removeClass("ui-tabs-hide");
	$divToolbarTabs.find("button").click(
		function() {
			var $this = $(this);
			$divToolbarTabs.tabs("select", idxTabs[this.title]);
			recipeToolbarToggle();
		}
	)
	$divToolbarTabs.find("a").click(function() { recipeToolbarToggle(); });
	$Recipe.re_style = $("#re_style");
	$Recipe.re_mashtype = $("#re_mashtype");
	$Recipe.re_vunits = $("#re_vunits");
	$Recipe.re_munits = $("#re_munits");
	$Recipe.re_tunits = $("#re_tunits");
	$Recipe.re_eunits = $("#re_eunits");
	$Recipe.re_hunits = $("#re_hunits");
	$Recipe.re_expsrm = $("#re_expsrm");
	$Recipe.re_expibu = $("#re_expibu");
	$Recipe.re_brewed = $("#re_brewed");
	$Recipe.re_grnamt = $("#re_grnamt");
	$Recipe.re_hopamt = $("#re_hopamt");
	$Recipe.re_eff = spinnerBind($("#re_eff"), incPct, recipeEventGrain);
	$Recipe.re_volume = spinnerBind($("#re_volume"), incAmt, recipeEventVolume);
	$Recipe.re_boilvol = spinnerBind($("#re_boilvol"), incAmt, recipeEventHop);
	$Recipe.re_expgrv = spinnerBindGravity($("#re_expgrv"), bihDefaults.EUNITS, recipeEventGrain);

	$("#rg_mash").on("change", recipeGravityFromEff);
	spinnerBind($("#rg_amount"),	incAmt,	recipeEventGrain);
	spinnerBind($("#rg_sgc"),		incSGC,	recipeEventGrain);
	spinnerBind($("#rg_lvb"),		incLvb,	recipeEventGrain);
	spinnerBind($("#rh_aau"),		incAAU,	recipeEventHop);
	spinnerBind($("#rh_amount"),	incAmt,	recipeEventHop);
	spinnerBind($("#rh_time"),		incTime,	recipeEventHop);
	spinnerBind($("#rh_ibu"),		incIBU,	recipeEventHop);
	spinnerBind($("#rm_amount"),	incAmt,	spinnerInc);
	spinnerBind($("#rm_offset"),	incTime,	spinnerInc);
	spinnerBindGravity($("#rd_gravity"), bihDefaults.EUNITS, spinnerInc);
	spinnerBindTemp($("#rd_temp"), bihDefaults.TUNITS, spinnerInc);
	$(document).on("focus", ".rd_note", function() {
	$rd_noteedit.focus()});
	$winModal = $("#winModal").dialog({ autoOpen: false, width: "auto", modal: true });
	$("#divToolbar").draggable({
		grid: [20,20],
		distance: 20,
		handle: $("#btnDragger"),
		start: function(event, ui) { $(this).removeClass("easing"); },
		stop: function(event, ui) { $(this).addClass("easing"); }
	});
	recipeFetch(REID);
}
recipeIsChanged = function() {
	if (RCP.qryRecipe.DATA[0].RE_REID==0) return !(isEmpty(frm.re_name) && isEmpty(frm.re_style) && isZero(frm.re_grmamt) &&  isZero(frm.re_hopamt)); // ADD
	if (!queryIsFormEqualRow(frm, RCP.qryRecipe.DATA[0],"",["re_expgrv","re_expibu","re_expsrm"])) return true;
	if ($RecipeGrains.length!=RCP.qryRecipeGrains.DATA.length) return true;
	if ($RecipeHops.length!=RCP.qryRecipeHops.DATA.length) return true;
	if ($RecipeYeast.length!=RCP.qryRecipeYeast.DATA.length) return true;
	if ($RecipeMisc.length!=RCP.qryRecipeMisc.DATA.length) return true;
	if ($RecipeDates.length!=RCP.qryRecipeDates.DATA.length) return true;
	var isSame = true;
	if (isSame) $.each($RecipeGrains, function(idx, $row) { return isSame = (typeof $row=="object" && queryIsFormEqualRow(frm, RCP.qryRecipeGrains.DATA[idx], idx)); }); // RETURN FALSE BREAKS OUT OF $EACH
	if (isSame) $.each($RecipeHops, function(idx, $row) { return isSame = (typeof $row=="object" && queryIsFormEqualRow(frm, RCP.qryRecipeHops.DATA[idx], idx, ["rh_ibu"])); });
	if (isSame) $.each($RecipeYeast, function(idx, $row) { return isSame = (typeof $row=="object" && queryIsFormEqualRow(frm, RCP.qryRecipeYeast.DATA[idx], idx)); });
	if (isSame) $.each($RecipeMisc, function(idx, $row) { return isSame = (typeof $row=="object" && queryIsFormEqualRow(frm, RCP.qryRecipeMisc.DATA[idx], idx)); });
	if (isSame) $.each($RecipeDates, function(idx, $row) { return isSame = (typeof $row=="object" && queryIsFormEqualRow(frm, RCP.qryRecipeDates.DATA[idx], idx)); });
	return !isSame;
}
recipeIsValid = function() {
	if (isEmpty(frm.re_name, "Recipe Name is required.")) return false;
	if (isZero(frm.re_volume, "Volume is required.")) return false;
	if (isEmpty(frm.re_style, "Style is required.")) return false;
	var valid = true;
	$.each($RecipeGrains,
		function(idx, $row) {
			if (typeof $row=="object") {
				if (isEmpty($row.rg_type[0]) && isZero($row.rg_amount[0])) {
					$row.rg_delete.parents("table").find(".rcpinp"+idx).fadeOut();
					$RecipeGrains[idx] = false;
				} else {
					if (isEmpty($row.rg_type[0],"Malt/Fermentable Type is required.")) return valid = false;
					if (isZero($row.rg_amount[0],"Malt/Fermentable Amount is required.")) return valid = false;
					if (isZero($row.rg_sgc[0],"Malt/Fermentable SGC is required.")) return valid = false;
					if (isZero($row.rg_lvb[0],"Malt/Fermentable SRM is required.")) return valid = false;
				}
			}
		}
	);
	if (!valid) return false;
	$.each($RecipeHops,
		function(idx, $row) {
			if (typeof $row=="object") {
				if (isEmpty($row.rh_hop[0]) && isZero($row.rh_amount[0]) && isZero($row.rh_aau[0])) {
					$row.rh_delete.parents("table").find(".rcpinp"+idx).fadeOut();
					$RecipeHops[idx] = false;
				} else {
					if (isEmpty($row.rh_hop[0],"Hop is required.")) return valid = false;
					if (isZero($row.rh_aau[0],"Hop AAU is required.")) return valid = false;
					if (isZero($row.rh_amount[0],"Hop Amount is required.")) return valid = false;
					if (isEmpty($row.rh_time[0],"Hop Time is required.")) return valid = false;
				}
			}
		}
	);
	if (!valid) return false;
	$.each($RecipeYeast,
		function(idx, $row) {
			if (typeof $row=="object") {
				if (isEmpty($row.ry_yeast[0]) && isEmpty($row.ry_note[0])) {
					$row.ry_delete.parents("table").find(".rcpinp"+idx).fadeOut();
					$RecipeYeast[idx] = false;
				} else {
					if (isEmpty($row.ry_yeast[0],"Yeast is required.")) return valid = false;
				}
			}
		}
	);
	if (!valid) return false;
	$.each($RecipeMisc,
		function(idx, $row) {
			if (typeof $row=="object") {
				if (isEmpty($row.rm_type[0]) && isZero($row.rm_amount[0])) {
					$row.rm_delete.parents("table").find(".rcpinp"+idx).fadeOut();
					$RecipeMisc[idx] = false;
				} else {
					if (isEmpty($row.rm_type[0],"Misc Ingredient is required.")) return valid = false;
					if (isZero($row.rm_amount[0],"Misc Ingredient Amount is required.")) return valid = false;
				}
			}
		}
	);
	if (!valid) return false;
	$.each($RecipeDates,
		function(idx, $row) {
			if (typeof $row=="object") {
				if (isEmpty($row.rd_date[0]) && isEmpty($row.rd_note[0])) {
					$row.rd_delete.parents("table").find(".rcpinp"+idx).fadeOut();
					$RecipeDates[idx] = false;
				} else {
					if (isEmpty($row.rd_date[0],"Notebook Date is required.")) return valid = false;
					if (!validateDate($row.rd_date[0])) return false;
				}
			}
		}
	);
	return valid;
}
recipeMiscAuto = function() {
	var $rm_type = $RecipeMisc[selectedRow.row].rm_type;
	if ($rm_type.attr("autocomplete")) return; // ALREADY THERE
	$rm_type.autocomplete({
		source: function(request, response) { return recipeAutoSource(request, response, qryMisc.DATA, ["MI_TYPE","MI_USE"]) },
		focus: function(event, ui) { return false },
		select:
			function(event, ui) {
				recipeMiscFill(ui.item);
				miscScatter(ui.item, $("#infoMisc"));
				miscScrollTo();
				return false;
			}
	});
	$rm_type.autocomplete("widget").addClass("ac_results");
	$rm_type.data("autocomplete")._renderItem = function(ul, ROW) {
		return $("<li></li>").data("item.autocomplete", ROW).append("<a>" + ROW.MI_TYPE + ", " + ROW.MI_USE + "</a>").appendTo(ul);
	}
}
recipeMiscFill = function(ROW) {
	$RecipeMisc[selectedRow.row].rm_type[0].value = ROW.MI_TYPE;
	$RecipeMisc[selectedRow.row].rm_unit.val(ROW.MI_UNIT);
	var phs = ROW.MI_PHASE;
	$RecipeMisc[selectedRow.row].rm_phase[0].innerHTML = phs;
	$RecipeMisc[selectedRow.row].rm_added[0].innerHTML = Added[phs] || Added["Default"];
	$RecipeMisc[selectedRow.row].rm_action[0].innerHTML = Action[phs];
	$RecipeMisc[selectedRow.row].rm_amount[0].focus();
	selectedRow.rowid = ROW._ROWID;
}
recipeMiscFind = function() {
	if (!$RecipeMisc.length) return;
	var editrow = 0;
	if (selectedRow.tab=="tabRecipeMisc") {
		editrow=selectedRow.row;
		recipeMiscAuto();
	}
	var rm_type = $RecipeMisc[editrow].rm_type[0].value;
	var rowid = querySearchIdx(qryMisc, idxMisc, "MI_TYPE", rm_type);
	if (rowid!=-1) {
		selectedRow.rowid = rowid;
		miscScatter(qryMisc.DATA[rowid], $("#infoMisc"));
		miscScrollTo();
	}
}
recipeMiscPhase = function(btn) {
	var row = $(btn).data("row");
	rotateMiscPhase(btn, $RecipeMisc[row].rm_added[0], $RecipeMisc[row].rm_action[0]);
}
recipeMiscPick = function(btn) {
	if (selectedRow.tab!="tabRecipeMisc") return;
	var $tr = $(btn).parents("tr")
	var rowid = $tr.data("rowid") || 0;
	recipeMiscFill(qryMisc.DATA[rowid]);
}
recipeMiscRowInit = function(fldidx) {
	popUnitSelect("#rm_unit"+fldidx, GramsConvert);
	popUnitSelect("#rm_unit"+fldidx, LitersConvert);
}
recipeNoteSave = function() {
	var noCR = $rd_noteedit.val().pipeCRLF(1);
	$RecipeDates[selectedRow.row].rd_note.val(noCR);
}
recipeOpen = function(btn) {
	var reid = (btn.title=="Add") ? -1 : $(btn).parents("tr").data("pk") || 0;
	if (recipeIsChanged()) {
		recipeCopyShow(reid);
		return;
	}
	recipeFetch(reid);
}
recipeRowAdd = function(meta, id, $arr, setFocus) {
	var $tab = $(id);
	var $icon = $tab.find(".ui-icon-arrowthickstop-1-s").parent();
	if ($icon.length) tbodyHide($icon[0]); // IF DIV IS HIDDEN, UNHIDE IT TO ADD A ROW
	var section = id.right(id.length-10);
	var fldidx = recipeRowAddMeta(meta, $tab, $arr, setFocus);
	if (section=="Misc") {
		popUnitSelect("#rm_unit"+fldidx, GramsConvert);
		popUnitSelect("#rm_unit"+fldidx, LitersConvert);
		$RecipeMisc[fldidx].rm_unit.val(bihDefaults.HUNITS);
		$RecipeMisc[fldidx].rm_phase.html("Mash");
		recipeMiscPhase($RecipeMisc[fldidx].rm_phase[0]);
	} else if (section=="Hops") {
		rotateSetVal($RecipeHops[fldidx].rh_form[0], bihDefaults.HOPFORM);
		rotateSetVal($RecipeHops[fldidx].rh_when[0], HopWhen["Default"]);
	} else if (section=="Dates") {
		var type = DateType["Default"];
		var grav = $Recipe.re_expgrv[0].value;
		var tunits = $Recipe.re_tunits[0].value;
		var temp = formatTemp(convertTemp("F", 60, tunits), tunits);
		if (fldidx>0 && $RecipeDates[fldidx-1]) {
			type = DateType[$RecipeDates[fldidx-1].rd_type.html()];
			if (type=="Brewed") type="Note";
			grav = $RecipeDates[fldidx-1].rd_gravity[0].value;
			temp = $RecipeDates[fldidx-1].rd_temp[0].value;
		}
		rotateSetVal($RecipeDates[fldidx].rd_type[0], type);
		$RecipeDates[fldidx].rd_date[0].value = jsDateFormat(new Date(), bihDefaults.DATEMASK);
		$RecipeDates[fldidx].rd_gravity[0].value = grav;
		$RecipeDates[fldidx].rd_temp[0].value = temp;
	}
	if (setFocus) recipeFieldOrder();
}
recipeRowAddMeta = function(meta, $tab, $arr, setFocus) {
	var $cols = $tab.find("tbody").find("td");
	var fldidx = $cols[0].childNodes.length;
	var focus;
	var flds = new Object();
	$cols.each(
		function(idx) {
			var $col = $(this);
			flds[$col.attr("id")] = recipeCreateInput($col, fldidx, meta);
			if (idx==1) focus = $col.attr("id");
		}
	);
	$arr[fldidx] = flds;
	if (setFocus) {
		flds[focus].focus();
		recipeRowEdit();
	}
	return fldidx;
}
recipeRowDelete = function(btn) {
	var $btn = $(btn);
	var row = $btn.data("row");
	$btn.parents("table").find(".rcpinp"+row).fadeOut();
	var tab = left(btn.id,2);
	if (tab=="rg")			$RecipeGrains[row] = false;
	else if (tab=="rh")	$RecipeHops[row] = false;
	else if (tab=="ry")	$RecipeYeast[row] = false;
	else if (tab=="rm")	$RecipeMisc[row] = false;
	else if (tab=="rd")	$RecipeDates[row] = false;
}
recipeRowEdit = function() {
	var fld = document.activeElement.id || "";
	if (!fld || fld.right(8)=="menuitem" || fld.right(3)=="add") return;
	var $this = $(document.activeElement);
	if (fld.left(3)=="re_") {
		var $tab = $this;
		var id = "tabRecipe";
		var row = fld;
	} else {
		var $tab = $this.parents("table");
		var id = $tab.attr("id");
		var row = $this.data("row");
	}
	if (selectedRow.tab!="") {
		if (selectedRow.tab==id && selectedRow.row==row) return; // ALREADY THERE
		var curTab = selectedRow.tab;
		if (selectedRow.row.left) curTab = selectedRow.row; // IF .left TELLS ME IT'S A STRING
		recipeToggleBorders($("#"+curTab));
	}
	selectedRow.tab = id;
	selectedRow.row = row;
	recipeToggleBorders($tab);
	var goConvert = false;
	if (selectedRow.tab=="tabRecipe") {
		if (selectedRow.row=="re_style") {
			$divToolbarTabs.tabs("select", idxTabs["Styles"]);
			if (window["qryBJCPStyles"]==undefined) return;
			recipeStylesFind();
		} else if (selectedRow.row=="re_volume") {
			$divToolbarTabs.tabs("select", idxTabs["Convert"]);
			if (!window["convertInit"]) return; // Not loaded yet, waiting on tab
			rcp2calcVolume();
		}
	} else if (selectedRow.tab=="tabRecipeDates") {
		$rd_noteedit.val($RecipeDates[selectedRow.row].rd_note.val().pipeCRLF(0));
		$rd_noteedit.removeAttr("disabled");
		rcp2calcTemp();
		rcp2calcGravity();
	} else {
		if (selectedRow.tab=="tabRecipeYeast") {
			$note_edit.data("maxlen", metaRecipeYeast["RY_NOTE"][metaSize]);
		} else if (selectedRow.tab=="tabRecipeGrains") {
			rcp2calcWeight();
			goConvert = ($this.hasClass("rg_amount"));
		} else if  (selectedRow.tab=="tabRecipeHops") {
			rcp2calcWeight();
		} else if  (selectedRow.tab=="tabRecipeMisc") {
			rcp2calcVolume();
			rcp2calcWeight();
		}
		var section = String(selectedRow.tab);
		section = section.right(section.length-9);
		$divToolbarTabs.tabs("select", idxTabs[section]);
		if (window["qry"+section]==undefined) return;
		window["recipe"+section+"Find"]();
		if (goConvert) $divToolbarTabs.tabs("select", idxTabs["Convert"]);
	}
}
recipeScale = function() {
	var newVolume = parseFloat($("#to_v"+$Recipe.re_vunits[0].selectedIndex.toString()).val());
	if (newVolume==0) return;
	var oldVolume = parseFloat($Recipe.re_volume.val());
	var ratio = newVolume / oldVolume;
	var total = 0;
	$Recipe.re_volume.val(newVolume);
	newVolume = parseFloat($Recipe.re_boilvol.val()) * ratio;
	$Recipe.re_boilvol.val(newVolume.toFixed(2));
	total = 0;
	$.each($RecipeGrains,
		function(fldidx, $row) {
			if (typeof $row=="object") {
				var oAmt = parseFloat($row.rg_amount.val()) || 0;
				var nAmt = (oAmt * ratio).toFixed(2);
				$row.rg_amount.val(nAmt);
				total += parseFloat(nAmt);
			}
		}
	);
	$Recipe.re_grnamt.val(total.toFixed(2));
	total = 0;
	$.each($RecipeHops,
		function(fldidx, $row) {
			if (typeof $row=="object") {
				var oAmt = parseFloat($row.rh_amount.val()) || 0;
				var nAmt = (oAmt * ratio).toFixed(2);
				$row.rh_amount.val(nAmt);
				total += parseFloat(nAmt);
			}
		}
	);
	$Recipe.re_hopamt.val(total.toFixed(2));
	total = 0;
	$.each($RecipeMisc,
		function(fldidx, $row) {
			if (typeof $row=="object") {
				var oAmt = parseFloat($row.rm_amount.val()) || 0;
				var nAmt = (oAmt * ratio).toFixed(2);
				$row.rm_amount.val(nAmt);
				total += parseFloat(nAmt);
			}
		}
	);
}
recipeScaleShow = function() {
	calcClear("v", $Recipe.re_vunits.val(), parseFloat($Recipe.re_volume[0].value) || 0);
	ucalcCalc("v");
	var $unitBody = $("#tabVolume").find("tbody");
	$unitBody.find("tr:gt(5)").hide();
	$winModal.dialog("option", "title", "Scale Recipe");
	$winModal.bind("dialogclose",
		function(event) {
			var $ub = $("#tabModal").find("tbody");
			$ub.find("tr:gt(5)").show();
			$("#tabVolume").append($ub);
		}
	);
	$winModal.dialog("option", "buttons", {
		"Scale": function() { $(this).dialog("close"); recipeScale(); },
		"Clear": function() { calcClear("v"); },
		"Cancel": function() { $(this).dialog("close"); }
	});
	$("#tabModal").append($unitBody);
	$winModal.dialog("open");
}
recipeShowBrewed = function() {
	if (RCP.qryRecipe.DATA[0].RE_BREWED) {
		$("#trBrewed").show();
		var d = new Date(RCP.qryRecipe.DATA[0].RE_BREWED);
		$Recipe.re_brewed[0].value = jsDateFormat(d);
	} else {
		$("#trBrewed").hide();
		$Recipe.re_brewed[0].value = "";
	}
}
recipeShowMash = function(btn, rotate) {
	var type = rotate ? rotateMashType(btn) : btn.innerHTML;
	if (type=="Extract") {
		$("#RecipeTabMash").hide();
	} else {
		$("#RecipeTabMash").show();
	}
}
recipeSRM = function () {
	var HCU = 0;
	var munits = $Recipe.re_munits.val();
	for (var i=0; i<$RecipeGrains.length; i++) {
		if ($RecipeGrains[i]) {
			var amt = parseFloat($RecipeGrains[i].rg_amount[0].value);
			var lvb = parseFloat($RecipeGrains[i].rg_lvb[0].value);
			HCU = HCU + lvb * amt;
		}
	}
	HCU = convertWeight(munits, HCU, "Lbs") / convertVolume($Recipe.re_vunits.val(), $Recipe.re_volume[0].value, "Gallons")
	$Recipe.re_expsrm[0].value = convertSRM(HCU);
	getById("re_expsrm2").value = $Recipe.re_expsrm[0].value;
}
recipeStylesAuto = function() {
	if ($Recipe.re_style.attr("autocomplete")) return; // ALREADY THERE
	$Recipe.re_style.autocomplete({
		source: function(request, response) { return recipeAutoSource(request, response, qryBJCPStyles.DATA, ["ST_SUBSTYLE"]) },
		focus: function(event, ui) { return false },
		select:
			function(event, ui) {
				recipeStylesFill(ui.item);
				stylesScatter(ui.item, $("#infoMisc"));
				stylesScrollTo();
				return false;
			}
	});
	$Recipe.re_style.autocomplete("widget").addClass("ac_results");
	$Recipe.re_style.data("autocomplete")._renderItem = function(ul, ROW) {
		return $("<li></li>").data("item.autocomplete", ROW).append("<a>" + ROW.ST_SUBSTYLE + "</a>").appendTo(ul);
	}
}
recipeStylesFill = function(ROW) {
	$Recipe.re_style.val(ROW.ST_SUBSTYLE);
	selectedRow.rowid = ROW._ROWID;
}
recipeStylesFind = function() {
	var re_style = $Recipe.re_style.val() || "";
	var rowid = querySearchIdx(qryBJCPStyles, idxBJCPStyles, "ST_SUBSTYLE", re_style);
	if (rowid!=-1) {
		selectedRow.rowid = rowid;
		stylesScatter(qryBJCPStyles.DATA[rowid], $("#infoBJCPStyles"));
		stylesScrollTo();
	}
	recipeStylesAuto();
}
recipeStylesPick = function(btn) {
	var $tr = $(btn).parents("tr")
	var rowid = $tr.data("rowid") || 0;
	recipeStylesFill(qryBJCPStyles.DATA[rowid]);
}
recipeSumGrains = function() {
	var total = 0;
	for (var i=0; i<$RecipeGrains.length; i++) {
		if ($RecipeGrains[i]) {
			total += parseFloat($RecipeGrains[i].rg_amount[0].value) || 0;
		}
	}
	for (var i=0; i<$RecipeGrains.length; i++) {
		if ($RecipeGrains[i]) {
			$RecipeGrains[i].rg_pct[0].value = ((parseFloat($RecipeGrains[i].rg_amount[0].value) || 0) / total * 100).toFixed(1);
		}
	}
	$Recipe.re_grnamt[0].value = total.toFixed(2);
}
recipeSumHops = function() {
	var total = 0;
	var expibu = 0;
	for (var i=0; i<$RecipeHops.length; i++) {
		if ($RecipeHops[i]) {
			total += parseFloat($RecipeHops[i].rh_amount[0].value) || 0;
			expibu += parseFloat($RecipeHops[i].rh_ibu[0].value);
		}
	}
	$Recipe.re_hopamt[0].value = total.toFixed(2);
	$Recipe.re_expibu[0].value = expibu.toFixed(0);
	getById("re_expibu2").value = $Recipe.re_expibu[0].value;
}
recipeTabLoadedTB = function(event,ui) {
	var tab = ui.tab.text;
	if (tab=="Grains")			recipeGrainsFind();
	else if (tab=="Hops")		recipeHopsFind();
	else if (tab=="Yeast")		recipeYeastFind();
	else if (tab=="Misc")		recipeMiscFind();
	else if (tab=="Styles")		recipeStylesFind();
//	else if (tab=="Recipes")	recipeFind();
	var $panel = $(ui.panel).show();
	recipeTabSetMode($panel, true);
}
recipeTabSelectedTB = function(event,ui) {
	var tab = ui.tab.text;
	if (ui.panel.childElementCount) return;
	var $panel = $(ui.panel).show();
	recipeTabSetMode($panel);
}
recipeTabSetMode = function($panel, remove) {
	if (remove) {
		$("#divToolbarLoading").fadeOut(2300);
		$panel.hide();
		$panel.css({position: "static", left: 0});
		$panel.fadeIn(1500);
	} else {
		$panel.css({position: "relative", left: "-9999px"});
		$("#divToolbarLoading").show().attr("class","").addClass($panel[0].id.replace("divToolbar","").toLowerCase());
	}
}
recipeTabShow = function(event,ui) {
	var tab = ui.tab.text;
	if (tab=="Notebook") {
		if (selectedRow.tab!="RecipeDates") {
			if ($RecipeDates[0]) {
				$RecipeDates[0].rd_date.focus();
				recipeRowEdit();
			}
		}
	}
}
recipeToggleBorders = function($tab) {
	if (selectedRow.tab=="tabRecipe") {
		$tab.toggleClass("edit");
		return;
	}
	$tab.find("tbody").find("tr").find("td").each(
		function() {
			var $el = $("#"+this.id+selectedRow.row);
			var type = $el[0].type;
			if (!($el.attr("readOnly") || false)) {
				if (type=="button") type = $el.hasClass("butRotate") ? "button" : "nope";
				if (type=="text" || type=="select-one" || type=="button") $el.toggleClass("edit");
			}
		}
	);
}
recipeToolbarDock = function() {
	$("#divToolbar").css("left", "");
}
recipeToolbarToggle = function(back) {
	var add = (!back) ? "toolbarOut" : "toolbarIn";
	var rem = (!back) ? "toolbarIn" : "toolbarOut";
	$("#divRight").removeClass(rem).addClass(add);
	$divToolbarTabs.removeClass(rem).addClass(add);
	$("#divToolbarTabWrap").removeClass(rem).addClass(add);
	$("#ulToolbarTabs").removeClass(rem).addClass(add);
	$("#divToolbarButtons").removeClass(rem).addClass(add);
}
recipeUnitsGrains = function() {
	var units = $Recipe.re_munits.val();
	var old = $Recipe.re_munits[0]["oldvalue"] || units;
	$Recipe.re_munits[0]["oldvalue"] = units;
	var total = 0;
	for (var i=0; i<$RecipeGrains.length; i++) {
		if ($RecipeGrains[i]) {
			$RecipeGrains[i].rg_amount[0].value = convertWeight(old, $RecipeGrains[i].rg_amount[0].value, units).toFixed(2);
			total += parseFloat($RecipeGrains[i].rg_amount[0].value);
		}
	}
	$Recipe.re_grnamt[0].value = total.toFixed(2);
}
recipeUnitsGravity = function(btn) {
	var old = btn.value;
	var units = rotateGravity(btn);
	$Recipe.re_expgrv[0].value = formatGravity(convertGravity(old, $Recipe.re_expgrv[0].value, units), units);
	getById("re_expgrv2").value = $Recipe.re_expgrv[0].value;
	for (var i=0; i<$RecipeDates.length; i++) {
		if ($RecipeDates[i]) {
			$RecipeDates[i].rd_gravity[0].value = formatGravity(convertGravity(old, $RecipeDates[i].rd_gravity[0].value, units), units);
		}
	}
	$("#disp_eunits").html(units);
	spinnerBindGravity($("#rd_gravity"), units, spinnerInc);
}
recipeUnitsHops = function() {
	var units = $Recipe.re_hunits.val();
	var old = $Recipe.re_hunits[0]["oldvalue"] || units;
	$Recipe.re_hunits[0]["oldvalue"] = units;
	var total = 0;
	for (var i=0; i<$RecipeHops.length; i++) {
		if ($RecipeHops[i]) {
			$RecipeHops[i].rh_amount[0].value = convertWeight(old, $RecipeHops[i].rh_amount[0].value, units).toFixed(2);
			total += parseFloat($RecipeHops[i].rh_amount[0].value);
		}
	}
	$Recipe.re_hopamt[0].value = total.toFixed(2);
}
recipeUnitsTemp = function(btn) {
	var units = rotateTemp(btn);
	var old = (units=="F") ? "C" : "F";
	for (var i=0; i<$RecipeDates.length; i++) {
		if ($RecipeDates[i]) {
			$RecipeDates[i].rd_temp[0].value = formatTemp(convertTemp(old, $RecipeDates[i].rd_temp[0].value, units), units);
		}
	}
	var e = $("#rd_temp").data("events");
	var data;
	if (units=="F") {
		data = { inc: 1, maxVal: 212.0, minInc: 0.5, maxInc: 10.0, decimals: 0, minVal: 0};
	} else {
		data = { inc: 1, maxVal: 100.0, minInc: 0.5, maxInc: 5.0, decimals: 1, minVal: -10};
	}
	e.change[0].data = data;
	e.keydown[0].data = data;
}
recipeVolumeUnits = function() {
	var units = $Recipe.re_vunits.val();
	var old = $Recipe.re_vunits[0]["oldvalue"] || units;
	$Recipe.re_vunits[0]["oldvalue"] = units;
	$Recipe.re_volume[0].value = convertVolume(old, $Recipe.re_volume[0].value, units).toFixed(2);
	$Recipe.re_boilvol[0].value = convertVolume(old, $Recipe.re_boilvol[0].value, units).toFixed(2);
}
recipeYeastAuto = function() {
	var $ry_yeast = $RecipeYeast[selectedRow.row].ry_yeast;
	if ($ry_yeast.attr("autocomplete")) return; // ALREADY THERE
	$ry_yeast.autocomplete({
		source: function(request, response) { return recipeAutoSource(request, response, qryYeast.DATA, ["YE_YEAST","YE_MFGNO","YE_MFG"]) },
		focus: function(event, ui) { return false },
		select:
			function(event, ui) {
				recipeYeastFill(ui.item);
				yeastScatter(ui.item, $("#infoYeast"));
				yeastScrollTo();
				return false;
			}
	});
	$ry_yeast.autocomplete("widget").addClass("ac_results");
	$ry_yeast.data("autocomplete")._renderItem = function(ul, ROW) {
		return $("<li></li>").data("item.autocomplete", ROW).append("<a>" + ROW.YE_YEAST + ", " + ROW.YE_MFGNO + " - " + ROW.YE_MFG + "</a>").appendTo(ul);
	}
}
recipeYeastFill = function(ROW) {
	$RecipeYeast[selectedRow.row].ry_yeast[0].value = ROW.YE_YEAST;
	$RecipeYeast[selectedRow.row].ry_mfgno[0].value = ROW.YE_MFGNO;
	$RecipeYeast[selectedRow.row].ry_mfg[0].value = ROW.YE_MFG;
	$RecipeYeast[selectedRow.row].ry_note[0].focus();
	selectedRow.rowid = ROW._ROWID;
}
recipeYeastFind = function() {
	if (!$RecipeYeast.length) return;
	var editrow = 0;
	if (selectedRow.tab=="tabRecipeYeast") {
		editrow=selectedRow.row;
		recipeYeastAuto();
	}
	var ry_yeast = $("#ry_yeast"+editrow).val();
	var ry_mfgno = $("#ry_mfgno"+editrow).val();
	var rowid = querySearchIdx(qryYeast, idxYeast, "YE_YEAST", ry_yeast, "YE_MFGNO", ry_mfgno);
	if (rowid!=-1) {
		selectedRow.rowid = rowid;
		yeastScatter(qryYeast.DATA[rowid], $("#infoYeast"));
		yeastScrollTo();
	}
}
recipeYeastNote = function(btn) {
	var $noteBody = $("#tabNotes").find("tbody");
	$winModal.bind("dialogclose", function(event) { $("#tabNotes").append($("#tabModal").find("tbody")); } );
	$winModal.dialog("option", "buttons", {
		"Save": function() { $(this).dialog("close"); $note_data.val($note_edit.val().pipeCRLF(1)) },
		"Cancel": function() { $(this).dialog("close"); }
	});
	$("#tabModal").append($noteBody);
	$note_data = $(btn).siblings("input");
	$note_data.focus();
	$note_edit.val($note_data.val().pipeCRLF(0));
	var row = $note_data.data("row");
	var title  = "Yeast Notes: " + $RecipeYeast[row].ry_yeast.val() + " " + $RecipeYeast[row].ry_mfg.val() + " " + $RecipeYeast[row].ry_mfgno.val();
	$winModal.dialog("option", "title", title);
	textareaMaxLen($note_edit[0]);
	$winModal.dialog("open");
}
recipeYeastPick = function(btn) {
	if (selectedRow.tab!="tabRecipeYeast") return;
	var $tr = $(btn).parents("tr");
	var rowid = $tr.data("rowid") || 0;
	recipeYeastFill(qryYeast.DATA[rowid]);
}
getPrivacyImg = function(cur) {
	var img = (cur==2) ? "red" : (cur==1) ? "yellow" : "green";
	var txt = (cur==2) ? "Private" : (cur==1) ? "Public Headers" : "Public";
	return "<img src='"+bihPath.img+"/trans.gif' class='fleft bih-icon bih-icon-ball"+img+"'>&nbsp;" + txt;
}
rotatePrivacy = function(btn) {
	var cur = parseInt(btn.value);
	cur = ++cur % 3 || 0
	img = getPrivacyImg(cur);
	return rotateSetVal(btn, img, cur);
}
