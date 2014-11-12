var sch_40_60_70={"0":{ratio:1,f:40,d:30},1:{t:0,f:60,d:30},2:{t:0,f:70,d:30},3:{t:0,f:75,d:10}};
var sch_40_50_60_70={"0":{ratio:1,f:40,d:30},1:{t:0,f:50,d:30},2:{t:0,f:60,d:30},3:{t:0,f:70,d:30},4:{t:0,f:75,d:10}};
alcEvent = function(event) {
	if (event.type=="change") event.which=13;
	spinnerInc(event);
	if (!event.data.changed) return true;
	alcCalc();
}
alcCalc = function() {
	var eunits = getById("alc_eunits").value;
	var fOG = getById("alc_expgrv_i").value;
	var fFG = getById("alc_expgrv_f").value;
	getById("alc_abv").value = alcABV(eunits, fOG, fFG).toFixed(1);
	getById("alc_abw").value = alcABW(eunits, fOG, fFG).toFixed(1);
	getById("alc_calories").value = alcCalories(eunits, fOG, fFG).toFixed(1);
}
alcUnitsGravity = function(btn) {
	var oUnits = unitbtnFromTo(btn, GravityUnits);
	var $fld = $("#alc_expgrv_i");
	fldChangeEUnits($fld[0], oUnits);
	spinnerBindGravity($fld, oUnits.to, alcEvent);
	$fld = $("#alc_expgrv_f");
	fldChangeEUnits($fld[0], oUnits);
	spinnerBindGravity($fld, oUnits.to, alcEvent);
	getById("alc_feunits").innerHTML = oUnits.to;
}
calcScatter = function(ROW) {
	for (var col in ROW) {
		var $inp = $("#"+col.toLowerCase());
		if (!$inp.length) {alert("col n/f = " + col); continue;}
		if ($inp.hasClass("tunits")) {
			rotateSetVal($inp[0], TempUnits[ROW[col]], ROW[col]);
		} else if ($inp.hasClass("butRotate")) {
			rotateSetVal($inp[0], ROW[col], ROW[col]);
		} else if ($inp.hasClass("vunits") || $inp.hasClass("wunits") || $inp.hasClass("eunits")) {
			unitselInit($inp[0], ROW[col]);
		} else {
			$inp[$inp[0].value==undefined ? "html" : "val"](ROW[col]);
		}
	}	
}
calcClear = function(which, units, val) {
	var noRCP = (typeof $Recipe.re_volume=="undefined");
	var vol = noRCP ? bihDefaults.VOLUME : $Recipe.re_volume.val().toFloat(bihDefaults.VOLUME);
	var vunits = noRCP ? bihDefaults.VUNITS : $Recipe.re_vunits.val();
	var eunits = noRCP ? bihDefaults.EUNITS : $Recipe.re_eunits.val();
	var expgrv = noRCP ? 0 : $Recipe.re_expgrv.val().toFloat();
	var sg = convertGravity(eunits, expgrv, "SG") || 1.048;
	var plato = convertGravity(eunits, expgrv, "Plato") || 12;
	var defaults = {};
	if (which=="a") {
		if (!getById("alc_abv")) return false; // CALC NOT LOADED
		defaults.alc_expgrv_i = formatGravity(convertGravity("SG", sg, eunits), eunits);
		sg = 1 + (sg-1.0) * 0.25;
		defaults.alc_expgrv_f = formatGravity(convertGravity("SG", sg, eunits), eunits);
		defaults.alc_eunits = eunits;
		defaults.alc_feunits = eunits;
		spinnerBindGravity($("#alc_expgrv_i"), defaults.alc_eunits, alcEvent);
		spinnerBindGravity($("#alc_expgrv_f"), defaults.alc_eunits, alcEvent);
		calcScatter(defaults);
		alcCalc();
	} else if (which=="c") {
		if (!getById("carb_temp")) return false; // CALC NOT LOADED
		defaults.carb_style = noRCP ? "Beer" : $Recipe.re_style.val() || "Beer";
		defaults.carb_co2range = "2.25 - 2.75";
		defaults.carb_co2_f = "2.25";
		defaults.carb_volume = vol.toFixed(2);
		defaults.carb_vunits = vunits;
		defaults.carb_wunits = bihDefaults.HUNITS;
		defaults.carb_tunits = bihDefaults.TUNITS;
		defaults.carb_temp = formatTemp(convertTemp("F", 68, defaults.carb_tunits), defaults.carb_tunits);
		defaults.carb_co2_i = co2AtTemp(defaults.carb_temp, defaults.carb_tunits).toFixed(2);
		if (!noRCP) {
			var primer = tryJSON(RCP.qryRecipe.DATA[0].RE_PRIME);
			if (primer.success) $.extend(defaults, primer.data);
		}
		spinnerBindTemp($("#carb_temp"), defaults.carb_tunits, carbEvent);
		calcScatter(defaults);
		carbCalc();
	} else if (which=="g") {
		defaults.gravity_sg = sg.toFixed(3);
		defaults.gravity_plato = plato.toFixed(1);
		defaults.gravity_tunits = bihDefaults.TUNITS;
		defaults.gravity_temp = formatTemp(convertTemp("F", 68, defaults.gravity_tunits), defaults.gravity_tunits);
		calcScatter(defaults);
		gravityCalc(sg);
	} else if (which=="i") {
		defaults.ibu_hop = "Hop";
		defaults.ibu_aarange = "3.0 - 7.0";
		defaults.ibu_aau = "5.0";
		defaults.ibu_volume = vol.toFixed(2);
		defaults.ibu_boillen = "0";
		defaults.ibu_util = "0";
		defaults.ibu_expgrv = sg.toFixed(3);
		defaults.ibu_vunits = vunits;
		defaults.ibu_wunits = bihDefaults.HUNITS;
		defaults.ibu_eunits = eunits;
		defaults.ibu_form = bihDefaults.HOPFORM;
		defaults.ibu_amount = "0.00";
		defaults.ibu_ibu = "0.0";
		spinnerBindGravity($("#ibu_expgrv"), defaults.ibu_eunits, ibuEvent);
		calcScatter(defaults);
	} else if (which=="k") {
		if (!getById("kettle_boillen")) return false; // CALC NOT LOADED
		var bvol = (noRCP ? bihDefaults.BOILVOL : $Recipe.re_boilvol.val().toFloat(bihDefaults.BOILVOL)) || vol;
		defaults.kettle_volume_i = bvol.toFixed(2);
		defaults.kettle_volume_f = vol.toFixed(2);
		defaults.kettle_expgrv_f = formatGravity(convertGravity("SG", sg, eunits), eunits);
		defaults.kettle_expgrv_i = formatGravity(1 + (defaults.kettle_volume_f * (defaults.kettle_expgrv_f - 1)) / defaults.kettle_volume_i, eunits);
		defaults.kettle_boillen = "90";
		defaults.kettle_vunits = vunits;
		defaults.kettle_eunits = eunits;
		defaults.kettle_feunits = eunits;
		defaults.kettle_fvunits = vunits;
		defaults.kettle_brunits = vunits + " / Hour";
		spinnerBindGravity($("#kettle_expgrv_i"), defaults.kettle_eunits, kettleEvent);
		spinnerBindGravity($("#kettle_expgrv_f"), defaults.kettle_eunits, kettleEvent);
		calcScatter(defaults);
		kettleCalc();
	} else if (which=="m") {
		if (!getById("mash_malt")) return false; // CALC NOT LOADED
		var munits = noRCP ? bihDefaults.MUNITS : $Recipe.re_munits.val();
		var malt = noRCP ? toInt(convertWeight("Lbs", convertVolume(vunits, vol, "Gallons") * 3.5, munits))/2.0 : $Recipe.re_grnamt.val().toFloat(0);
		var strike = convertWeight(munits, malt, bihDefaults.MUNITS) * bihDefaults.RATIO;
		defaults.mash_vunits = vunits;
		defaults.mash_viunits = bihDefaults.VIUNITS;
		defaults.mash_munits = munits;
		defaults.mash_tunits = bihDefaults.TUNITS;
		defaults.mash_malt = malt.toFixed(2);
		defaults.mash_volume0 = convertVolume(bihDefaults.VIUNITS, strike, bihDefaults.VUNITS);
		defaults.mash_maltcap = bihDefaults.MALTCAP;
		defaults.mash_infuse0 = strike.toFixed(2);
		defaults.mash_duration0 = "60";
		defaults.mash_temp_f0 = formatTemp(convertTemp("F", 154, defaults.mash_tunits), defaults.mash_tunits);
		defaults.mash_temp_i0 = formatTemp(convertTemp("F", 60, defaults.mash_tunits), defaults.mash_tunits);
		defaults.mash_temp_i1 = formatTemp(convertTemp("F", 154, defaults.mash_tunits), defaults.mash_tunits);
		defaults.mash_temp_f1 = formatTemp(convertTemp("F", 168, defaults.mash_tunits), defaults.mash_tunits);
		defaults.mash_temp_a1 = formatTemp(convertTemp("F", 212, defaults.mash_tunits), defaults.mash_tunits);
		defaults.mash_duration1 = "10";
		defaults.mash_ratio0 = bihDefaults.RATIO.toFixed(2);
		if (!noRCP) {
			var mash = tryJSON(RCP.qryRecipe.DATA[0].RE_MASH);
			if (mash.success) $.extend(defaults, mash.data);
		}
		mashRatioLabel(defaults.mash_viunits, defaults.mash_munits);
		calcScatter(defaults);
		mashDurationTotal();
		mashCalc("Infusion",0);
	} else if (which=="t") {
		defaults.temp_f = "68.0";
		defaults.temp_c = "20.0";
		calcScatter(defaults);
	} else {
		var collection = (which=="v") ? LitersConvert : (which=="w") ?  GramsConvert : ScaleConvert;
		var cnt = 0;
		for (var unit in collection) {
			getById("un_"+which+cnt).value = ((units==unit) ? val.toFixed(2) : "0.00");
			getById("to_"+which+cnt).value = "0.00";
			cnt++;
		}
	}
}
calcInit = function() {
	$("#divCalcTabs").tabs({ cache: true, spinner: "<span class=font7>Brewing&#8230;</span>" });
}
carbCalc = function() {
	var wunits = selectedValue(getById("carb_wunits"));
	var co2f = getById("carb_co2_f").value.toFloat(2.2);
	var co2i = getById("carb_co2_i").value.toFloat(1.0);
	var vunits = selectedValue(getById("carb_vunits"));
	var volume = getById("carb_volume").value.toFloat(0);
	var primer = selectedValue(getById("carb_primer"));
	var amt = co2SugarFromCO2(wunits, co2f - co2i, vunits, volume, primer);
	getById("carb_amount").value = amt.toFixed(2);
	var tunits = getById("carb_tunits").value;
	var temp = getById("carb_temp").value.toFloat(0);
	var psi = co2ForceCarbonation(tunits, temp, "PSI", co2f);
	getById("carb_psi").value = psi.toFixed(2);
}
carbEvent = function(event) {
	if (event.type=="change") event.which=13;
	spinnerInc(event);
	if (!event.data.changed) return true;
	var val = event.target.value.toFloat(0);
	if (event.target.id=="carb_temp") {
		getById("carb_co2_i").value = co2AtTemp(val, $("#carb_tunits").val()).toFixed(2);
	} else if (event.target.id=="carb_amount") {
		var wunits = selectedValue(getById("carb_wunits"));
		var weight = getById("carb_amount").value.toFloat();
		var vunits = selectedValue(getById("carb_vunits"));
		var volume = getById("carb_volume").value.toFloat();
		var primer = selectedValue(getById("carb_primer"));
		var co2i = getById("carb_co2_i").value.toFloat(1.0);
		var co2f = co2i + co2CO2FromSugar(wunits, weight, vunits, volume, primer);
		getById("carb_co2_f").value = co2f.toFixed(2);
	} else {
	}
	carbCalc();
}
carbStylesAuto = function() {
	var $carb_style = $("#carb_style").autocomplete({
		source: function(request, response) { return recipeAutoSource(request, response, qryBJCPStyles.DATA, ["ST_SUBSTYLE"]) },
		focus: function(event, ui) { return false },
		select:
			function(event, ui) {
				var ROW = ui.item;
				var low = (ROW.ST_CO2_MIN || 2.25).toFixed(2);
				var high = (ROW.ST_CO2_MIN && ROW.ST_CO2_MAX) ? " - " + ROW.ST_CO2_MAX.toFixed(2) : "";
				getById("carb_co2range").value = low + high;
				getById("carb_co2_f").value = low;
				return false;
			}
	});
	$carb_style.autocomplete("widget").addClass("ac_results");
	$carb_style.data("autocomplete")._renderItem = function(ul, ROW) {
		return $("<li></li>").data("item.autocomplete", ROW).append("<a>" + ROW.ST_SUBSTYLE + "</a>").appendTo(ul);
	}
}
carbUnitsTemp = function(event) {
	var $fld = $(event.data.fld);
	var tunits = rotateTemp(event.target);
	spinnerBindTemp($fld, tunits, carbEvent);
	var def = (tunits=="F") ? 60.0 : 15.6;
	var val = $fld.val().toFloat(def);
	val = (tunits=="F") ? convertTemp("C", val, "F") : convertTemp("F", val, "C");
	$fld.val(val.toFixed(1));
}
carbUnitsVolume = function(sel) {
	var oUnits = unitselFromTo(sel);
	fldChangeVUnits(getById("carb_volume"), oUnits);
}
carbUnitsWeight = function(sel) {
	var oUnits = unitselFromTo(sel);
	fldChangeWUnits(getById("carb_amount"), oUnits);
}
convertInit = function() {
	$("table.calculator caption button").show();
	rcp2calcVolume();
	rcp2calcWeight();
}
gravityCalc = function(sg) {
	var tunits = $("#gravity_tunits").val();
	var temp = getById("gravity_temp").value.toFloat();
	sg = correctGravity("SG", sg, tunits, temp, 59);
	getById("hc_sg").value = sg.toFixed(3);
	getById("hc_plato").value  = convertGravity("SG", sg, "Plato").toFixed(1);
}
gravityEvent = function(event) {
	if (event.type=="change") event.which=13;
	spinnerInc(event);
	if (!event.data.changed) return true;
	var val = event.target.value.toFloat();
	var sg = 0;
	if (event.target.id=="gravity_temp") {
		sg = getById("gravity_sg").value.toFloat(1.0);
	} else if (event.target.id=="gravity_sg") {
		sg = val;
		getById("gravity_plato").value = convertGravity("SG", val, "Plato").toFixed(1);
	} else {
		sg = convertGravity("Plato", val, "SG");
		getById("gravity_sg").value = sg.toFixed(3);
	}
	gravityCalc(sg);
}
gravityUnitsTemp = function(event) {
	var $fld = $(event.data.fld);
	var tunits = rotateTemp(event.target);
	spinnerBindTemp($fld, tunits, gravityEvent);
	var def = (tunits=="F") ? 60.0 : 15.6;
	var val = $fld.val().toFloat(def);
	val = (tunits=="F") ? convertTemp("C", val, "F") : convertTemp("F", val, "C");
	$fld.val(val.toFixed(1));
}
ibuCalc = function(mode) {
	var eunits = getById("ibu_eunits").value;
	var wunits = selectedValue(getById("ibu_wunits"));
	var vunits = selectedValue(getById("ibu_vunits"));
	var volume = getById("ibu_volume").value.toFloat();
	var expgrv = getById("ibu_expgrv").value.toFloat();
	var form = getById("ibu_form").value;
	var aau = getById("ibu_aau").value.toFloat();
	var amount = getById("ibu_amount").value.toFloat();
	var time = getById("ibu_boillen").value.toFloat();
	var when = "Boil";
	var util = ibuGetUtilization(form, time, when);
	getById("ibu_util").value = util.toFixed(0);
	if (mode=="Amount") {
		var ibu = getById("ibu_ibu").value.toFloat();
		amount = ibuAmountFromIBU(vunits, volume, eunits, expgrv, wunits, ibu, aau, form, time, when, volume)
		getById("ibu_amount").value = amount.toFixed(2);
	} else {
		var ibu = ibuIBUFromAmount(vunits, volume, eunits, expgrv, wunits, amount, aau, form, time, when, volume);
		getById("ibu_ibu").value = ibu.toFixed(1);
	}
}
ibuEvent = function(event) {
	if (event.type=="change") event.which=13;
	spinnerInc(event);
	if (!event.data.changed) return true;
	var val = event.target.value.toFloat();
	if (event.target.id=="ibu_ibu") {
		ibuCalc("Amount");
	} else {
		ibuCalc("IBU");
	}
}
ibuHopForm = function(btn) {
	rotateSetVal(btn, HopForm[btn.innerHTML] || bihDefaults.HOPFORM);
	ibuCalc("IBU");
}
ibuHopsAuto = function() {
	var $ibu_hop = $("#ibu_hop").autocomplete({
		source: function(request, response) { return recipeAutoSource(request, response, qryHops.DATA, ["HP_HOP","HP_GROWN"]) },
		focus: function(event, ui) { return false },
		select:
			function(event, ui) {
				var low = (ui.item.HP_AALOW || 5.0).toFixed(1);
				var high = (ui.item.HP_AALOW && ui.item.HP_AAHIGH) ? " - " + ui.item.HP_AAHIGH.toFixed(1) : "";
				getById("ibu_hop").value = ui.item.HP_HOP;
				getById("ibu_aarange").value = low + high;
				getById("ibu_aau").value = low;
				return false;
			}
	});
	$ibu_hop.autocomplete("widget").addClass("ac_results");
	$ibu_hop.data("autocomplete")._renderItem = function(ul, ROW) {
		return $("<li></li>").data("item.autocomplete", ROW).append("<a>" + ROW.HP_HOP + ", " + ROW.HP_GROWN + "</a>").appendTo(ul);
	}
}
ibuUnitsGravity = function(btn) {
	var oUnits = unitbtnFromTo(btn, GravityUnits);
	var $fld = $("#ibu_expgrv");
	fldChangeEUnits($fld[0], oUnits);
	spinnerBindGravity($fld, oUnits.to, ibuEvent);
}
ibuUnitsVolume = function(sel) {
	var oUnits = unitselFromTo(sel);
	fldChangeVUnits(getById("ibu_volume"), oUnits);
}
ibuUnitsWeight = function(sel) {
	var oUnits = unitselFromTo(sel);
	fldChangeWUnits(getById("ibu_amount"), oUnits);
}
kettleCalc = function(which) {
	which = which || "";
	var eunits = getById("kettle_eunits").value;
	var fkvi = getById("kettle_volume_i");
	var fkvf = getById("kettle_volume_f");
	var fgrvi = getById("kettle_expgrv_i");
	var fgrvf = getById("kettle_expgrv_f");
	var fbl = getById("kettle_boillen");
	var kvi = fkvi.value.toFloat();
	var kvf = fkvf.value.toFloat();
	var sgi = convertGravity(eunits, fgrvi.value, "SG");
	var sgf = convertGravity(eunits, fgrvf.value, "SG");
	var len = fbl.value.toFloat();
	if (which=="kettle_expgrv_f") {
		kvf = kvi * (sgi - 1) / (sgf - 1);
	} else if (which.starts("kettle_boilpct")) {
		kvf = kvi - kvi * val / 100 / 60 * len;
	} else if (which.starts("kettle_boilrate")) {
		kvf = kvi - val / 60 * len;
	}
	sgf = 1 + (kvi * (sgi - 1)) / kvf;
	var rate = (len==0) ? 0 : ((kvi - kvf) / len * 60);
	var pct = rate / kvi * 100;
	fgrvf.value = formatGravity(convertGravity("SG", sgf, eunits), eunits);
	fkvf.value = kvf.toFixed(2);
	getById("kettle_boilrate").value = rate.toFixed(2);
	getById("kettle_boilpct").value = pct.toFixed(2);
}
kettleEvent = function(event) {
	if (event.type=="change") event.which=13;
	spinnerInc(event);
	if (!event.data.changed) return true;
	kettleCalc(event.target.id);
}
kettleUnitsGravity = function(btn) {
	var oUnits = unitbtnFromTo(btn, GravityUnits);
	var $fld = $("#kettle_expgrv_i");
	fldChangeEUnits($fld[0], oUnits);
	spinnerBindGravity($fld, oUnits.to, kettleEvent);
	$fld = $("#kettle_expgrv_f");
	fldChangeEUnits($fld[0], oUnits);
	spinnerBindGravity($fld, oUnits.to, kettleEvent);
	getById("kettle_feunits").innerHTML = oUnits.to;
}
kettleUnitsVolume = function(sel) {
	var oUnits = unitselFromTo(sel);
	fldChangeVUnits(getById("kettle_volume_i"), oUnits);
	fldChangeVUnits(getById("kettle_volume_f"), oUnits);
	fldChangeVUnits(getById("kettle_boilrate"), oUnits);
	getById("kettle_fvunits").innerHTML = oUnits.to;
	getById("kettle_brunits").innerHTML = oUnits.to + " / Hour";
}
mashCalc = function(which, startRow) {
	which = which || "";
	startRow = startRow || 0;
	var txtInfuseF = getById("mash_infuse_f");
	var infuse_f = 0;
	var selStep = 0;
	var cUnits = mashUnits();
	var maltcap = getById("mash_maltcap").value.toFloat(0.4);
	var malt = getById("mash_malt").value.toFloat();
	var strike = convertVolume(cUnits.vunits, getById("mash_volume0").value.toFloat(), cUnits.viunits);
	var endRow = $("#mash_steps_rows")[0].rows.length;
	for (var idx=startRow; idx<=endRow; idx++) {
		var txtInfuse = getById("mash_infuse"+idx);
		var txtDecoct = getById("mash_decoct"+idx);
		var txtTempA = getById("mash_temp_a"+idx);
		var tempF = getById("mash_temp_f"+idx).value.toFloat();
		var tempI = getById("mash_temp_i"+idx).value.toFloat(tempF);
		var tempA = txtTempA.value.toFloat(tempF);
		var infuse = txtInfuse.value.toFloat();
		var decoct = (txtDecoct) ? txtDecoct.value.toFloat() : 0;
		if (idx==0) {
			infuse = strike;
			volume = 0;
		} else {
			infuse_f = mashInfusionTotal(idx);
			volume = strike + infuse_f; // IN VIUNITS
			selStep = getById("mash_steptype"+idx).selectedIndex;
		}
		if (which=="Infusion") {
			tempA = mashInfusionTemp(cUnits.viunits, volume, infuse, cUnits.munits, malt, tempI, tempF, maltcap);
			txtTempA.value = formatTemp(tempA, cUnits.tunits);
			if (idx!=0) {
				decoct = mashDecoctionWeight(cUnits.viunits, volume, cUnits.munits, malt, tempA, tempI, tempF, maltcap);
				txtDecoct.value = decoct.toFixed(2);
			}
		} else if (which=="Decoction") {
			tempA = mashDecoctionTemp(cUnits.viunits, volume, cUnits.munits, malt, decoct, tempI, tempF, maltcap);
			infuse = mashInfusionVolume(cUnits.viunits, volume, cUnits.munits, malt, tempA, tempI, tempF, maltcap);
			txtTempA.value = formatTemp(tempA, cUnits.tunits);
			txtInfuse.value = infuse.toFixed(2);
		} else {
			infuse = (selStep==0) ? mashInfusionVolume(cUnits.viunits, volume, cUnits.munits, malt, tempA, tempI, tempF, maltcap) : 0;
			txtInfuse.value = infuse.toFixed(2);
			if (idx!=0) {
				decoct = mashDecoctionWeight(cUnits.viunits, volume, cUnits.munits, malt, tempA, tempI, tempF, maltcap);
				txtDecoct.value = decoct.toFixed(2);
			}
		}
		var ratio = (volume+infuse) / malt;
		getById("mash_volume"+idx).value = convertVolume(cUnits.viunits, volume+infuse, cUnits.vunits).toFixed(2);
		getById("mash_ratio"+idx).value = ratio.toFixed(2);
		which = "";
	}
	txtInfuseF.value = (infuse + infuse_f).toFixed(2);
}
mashDurationTotal = function(row) {
	var sum = 0;
	$("#mash_steps tbody input.duration").each( function() { sum += this.value.toFloat()});
	getById("mash_length").value = sum.toFixed(0);
}
mashEvent = function(event) {
	if (event.type=="change") event.which=13;
	spinnerInc(event);
	if (!event.data.changed) return true;
	var row = event.target.id.right(1).toInt();
	var cUnits = mashUnits();
	if (event.target.id.starts("mash_duration")) {
		return mashDurationTotal();
	} else if (event.target.id=="mash_infuse0") {
		getById("mash_volume0").value = convertVolume(cUnits.viunits, event.target.value.toFloat(), cUnits.vunits).toFixed(2);
	}
	if (event.target.id=="mash_volume0") {
		getById("mash_infuse0").value = convertVolume(cUnits.vunits, event.target.value.toFloat(), cUnits.viunits).toFixed(2);
	}
	if (event.target.id=="mash_ratio0") {
		var infuse = getById("mash_malt").value.toFloat() * event.target.value.toFloat();
		getById("mash_infuse0").value = infuse.toFixed(2);
		getById("mash_volume0").value = convertVolume(cUnits.viunits, infuse, cUnits.vunits).toFixed(2);
	}
	if (row==0 && event.target.id!="mash_temp_a0") {
		mashCalc("Infusion", row);
	} else if (event.target.id.starts("mash_infuse")) {
		mashCalc("Infusion", row);
	} else if (event.target.id.starts("mash_decoct")) {
		mashCalc("Decoction", row);
	} else {
		mashCalc("Both", row);
	}
}
mashInfusionTotal = function(row) {
	var vol = 0;
	$("#mash_steps input.units_vi").slice(1,row).each(
		function(idx) {
			var sel = getById("mash_steptype"+row).selectedIndex;
			if (!sel) vol += this.value.toFloat(); // !sel = infusion
		}
	);
	return vol;
}
mashProgram = function(sch) {
	var $msrBody = $("#mash_steps_rows").empty();
	var cUnits = mashUnits();
	var ratio = sch[0].ratio;
	var strike = getById("mash_malt").value.toFloat() * ratio;
	var tempF = formatTemp(convertTemp("C", sch[0].f, cUnits.tunits), cUnits.tunits);
	var tempA = formatTemp(convertTemp("F", 210, cUnits.tunits), cUnits.tunits);
	var tempI = 0;
	getById("mash_temp_f0").value = tempF;
	getById("mash_infuse0").value = strike.toFixed(2);
	getById("mash_volume0").value = convertVolume(cUnits.viunits, strike, cUnits.vunits);
	mashCalc("Infusion", 0);
	for (step in sch) {
		if (step==0) continue;
		tempI = tempF;
		tempF = formatTemp(convertTemp("C", sch[step].f, cUnits.tunits), cUnits.tunits);
		mashStepAdd(sch[step].t,tempF,tempI,tempA);
	}
}
mashRatioLabel = function(viunits, munits) {
	if (!viunits) viunits = getById("mash_viunits").value;
	if (!munits) munits = getById("mash_munits").value;
	$("#mash_steps .mash_ratio_units").html(viunits + " / " + munits);
}
mashStepAdd = function(stepType,tempF,tempI,tempA) {
	var cUnits = mashUnits();
	var $msrBody = $("#mash_steps_rows");
	var row = $msrBody[0].rows.length+1;
	var $add = $("#mash_stepAdd tr:first").clone().data("row", row);
	$("#btnMashStepDelete").replaceWith("&nbsp;");
	$add.find("input, select").each( function() { this.id = this.name + row; });
	spinnerBind($add.find("input.units_m, input.units_vi"), incAmt, mashEvent);
	spinnerBindTemp($add.find("input.units_t"), cUnits.tunits, mashEvent);
	$msrBody.append($add);
	var prv = row - 1;
	var prvVal = getById("mash_temp_f"+prv).value;
	getById("mash_temp_f"+row).value = tempF || prvVal;
	getById("mash_temp_i"+row).value = tempI || prvVal;
	getById("mash_temp_a"+row).value = tempA || getById("mash_temp_a"+prv).value;
	var sel = getById("mash_steptype"+row);
	sel.selectedIndex = (stepType) ? stepType : getById("mash_steptype"+prv).selectedIndex;
	mashStepTypeShow(sel.selectedIndex, row);
	mashCalc("Both", row);
}
mashStepDelete = function() {
	var $btnDel = $("#btnMashStepDelete");
	var $msrBody = $("#mash_steps_rows");
	$msrBody.find("tr:last").remove();
	$msrBody.find("tr:last").find(".icon").html($btnDel);
}
mashStepType = function(sel) {
	var row = sel.id.right(1).toInt();
	mashStepTypeShow(sel.selectedIndex, row);
	mashCalc("Both", row);
}
mashStepTypeShow = function(which, row) {
	if (which!=0) $("#mash_infuse"+row).fadeOut(); else $("#mash_infuse"+row).fadeIn();
	if (which!=1) $("#mash_decoct"+row).fadeOut(); else $("#mash_decoct"+row).fadeIn();
	if (which==2) $("#mash_temp_a"+row).fadeOut(); else $("#mash_temp_a"+row).fadeIn();
}
mashUnits =  function() {
	var cUnits = {};
	cUnits.tunits = getById("mash_tunits").value;
	cUnits.munits = getById("mash_munits").value;
	cUnits.vunits = getById("mash_vunits").value;
	cUnits.viunits = getById("mash_viunits").value;
	return cUnits;
}
mashUnitsTemp = function(event) {
	var old = event.target.value;
	var tunits = rotateTemp(event.target);
	var $i = spinnerBindTemp($("#tabMash input.units_t"), tunits, mashEvent);
	$i.each(function() { this.value = formatTemp(convertTemp(old, this.value.toFloat(), tunits), tunits) });
}
mashUnitsVolume = function(sel) {
	var oUnits = unitselFromTo(sel);
	var cUnits = mashUnits();
	if (sel.id=="mash_vunits") {
		$("#tabMash input.units_v").each(function() { fldChangeVUnits(this, oUnits) });
	} else {
		$("#tabMash input.units_vi").each(function() { fldChangeVUnits(this, oUnits) });
		mashRatioLabel(oUnits.to, false);
	}
}
mashUnitsWeight = function(sel) {
	var oUnits = unitselFromTo(sel);
	$("#tabMash input.units_m").each(function() { fldChangeWUnits(this, oUnits) });
	mashRatioLabel(false, oUnits.to);
}
tempEvent = function(event) {
	if (event.type=="change") event.which=13;
	spinnerInc(event);
	if (!event.data.changed) return true;
	var val = event.target.value.toFloat();
	if (event.target.id=="temp_f") {
		getById("temp_c").value = convertTemp("F", val, "C").toFixed(1);
	} else {
		getById("temp_f").value = convertTemp("C", val, "F").toFixed(1);
	}
}
ucalcBuild = function(tab, which, collection) {
	var $tab = $("#"+tab+" tbody");
	var $tr = $tab.find("tr");
	var cnt = 0;
	for (var unit in collection) {
		var $trc = $tr.clone();
		$trc.find("td.unitlabel").append(unit);
		var $inp = $("<input type=text maxlength=7 class=decimal value=0.00>").attr("id", "un_"+which+cnt).addClass("unit");
		$trc.find("td.unitinput").append($inp);
		$inp = $("<input type=text class=decimal readonly=readonly value=0.00>").attr("id", "to_"+which+cnt).addClass("unittotal");
		if (collection[unit]==1) $inp.addClass("convert"+unit);
		$trc.find("td.unittotal").append($inp);
		$tab.append($trc);
		cnt += 1;
	}
	$tr.remove();
	spinnerBind($tab, $.extend({calc:which}, incAmt), ucalcEvent);
}
ucalcCalc = function(which) {
	var collection = (which=="v") ? LitersConvert : (which=="w") ?  GramsConvert : ScaleConvert;
	var cnt = 0;
	var tot = 0;
	for (var unit in collection) {
		var inp = getById("un_"+which+cnt);
		tot += inp.value.toFloat() * collection[unit];
		cnt++;
	}
	cnt = 0;
	for (var unit in collection) {		
		getById("to_"+which+cnt).value = (tot / collection[unit]).toFixed(2);
		cnt++;
	}
}
ucalcEvent = function(event) {
	if (event.type=="change") event.which=13;
	spinnerInc(event);
	if (!event.data.changed) return true;
	ucalcCalc(event.data.calc);
}

