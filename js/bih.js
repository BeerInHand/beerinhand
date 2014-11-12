var metaType = 0, metaSize = 1, metaInput = 2, metaFormat = 3;
var LitersConvert={Barrels:117.347772,Hectoliters:100,"Imp Gallons":4.54609,Gallons:3.785412,Liters:1,Quarts:0.946353,Pints:0.4731765,Cups:0.2365883,Ounces:0.0295735,"Imp Ounces":0.0284131,Tablespoons:0.0147868,Teaspoons:0.0049289};
var ScaleConvert={Barrels:117.347772,Hectoliters:100,"Imp Gallons":4.54609,Gallons:3.785412,Liters:1,Quarts:0.946353,Pints:0.4731765};
var GramsConvert={Kg:1000,Lbs:453.59237,Ounces:28.3495231,Grams:1};
var TempUnits={F:"&deg;F",C:"&deg;C"};
var GravityUnits={SG:"SG","Plato":"&deg;Plato"};
var Primer={Cane:0.286,Corn:0.27027,DME:0.135318};
var HopForm={Pellet:"Leaf",Leaf:"Plug",Plug:"Pellet"};
var HopWhen={Default:"Boil",Mash:"Fwh",Fwh:"Boil",Boil:"Dry",Dry:"Mash"};
var MashType={"All Grain":"Partial Mash","Partial Mash":"Extract","Extract":"All Grain"};
var Phase={Default:"Setup",Setup:"Mash",Mash:"Boil",Boil:"Chill",Chill:"Ferment",Ferment:"Package",Package:"Setup"};
var Added={Default:"Mins After",Setup:"During",Package:"During",Ferment:"Days After", During:"During","Mins Before":"Mins After","Mins After":"Mins Before","Days Before":"Days After","Days After":"Days Before"};
var Action={Setup:"Water Prep","Water Prep":"Water Prep",Mash:"Mash In","Mash In":"Mash Out","Mash Out":"Sparge",Sparge:"Mash In",Boil:"Boil Start","Boil Start":"Boil End","Boil End":"Boil Start",Chill:"Chill Start","Chill Start":"Chill End","Chill End":"Chill Start",Ferment:"Pitching",Pitching:"Racking",Racking:"Packaging",Packaging:"Pitching",Package:"Bottling",Bottling:"Kegging", Kegging:"Bottling"};
var DateType={Default:"Note",Brewed:"Racked",Racked:"Packaged",Packaged:"Sampled",Sampled:"Note",Note:"Brewed"};
var bihDefaults={RATIO:0.4,VIUNITS:"Quarts",HOPFORM:"Pellet",VUNITS:"Gallons",HYDROTEMP:60,PRIMER:"Corn",EUNITS:"SG",HUNITS:"Grams",TUNITS:"F",BOILVOL:0,EFF:75,DATEMASK:"MM/DD/YY",MALTCAP:0.4,VOLUME:10,MUNITS:"Lbs"};
var incSG={inc:0.001,minInc:0.001,maxInc:0.01,minVal:0.99,maxVal:1.25,decimals:3};
var incSGC={inc:0.001,maxVal:1.05,minInc:0.001,maxInc:0.01,decimals:3,minVal:0};
var incLvb={inc:10,maxVal:999.9,minInc:1,maxInc:100,decimals:1,minVal:0};
var incAAU={inc:1,maxVal:20,minInc:0.1,maxInc:10,decimals:1,minVal:0};
var incIBU={inc:1,maxVal:200,minInc:0.1,maxInc:10,decimals:1,minVal:0};
var incPlato={inc:1,minInc:0.1,maxInc:10,minVal:-2.6,maxVal:52,decimals:1};
var incF={inc:1,minInc:0.1,maxInc:10,minVal:0,maxVal:212,decimals:0};
var incC={inc:1,minInc:0.1,maxInc:10,minVal:-17.8,maxVal:100,decimals:1};
var incAmt={inc:1,maxVal:9999.99,minInc:0.25,maxInc:10,decimals:2,minVal:0};
var incPct={inc:1,maxVal:100,minInc:1,maxInc:5,decimals:0,minVal:0};
var incTime={inc:5,maxVal:360,minInc:1,maxInc:30,decimals:0,minVal:0};
var incCO2={inc:0.25,minInc:0.05,maxInc:1,minVal:0,maxVal:4,decimals:2};

alcABV = function(GravityUnitsIn, OG, FG) {
	var OGinSG = convertGravity(GravityUnitsIn, OG, "SG");
	var FGinSG = (!FG) ? 1 + (OGinSG - 1) / 4 : convertGravity(GravityUnitsIn, FG, "SG");
	return (OGinSG - FGinSG) * 131;
}
alcABW = function(GravityUnitsIn, OG, FG) {
	var OGinSG = convertGravity(GravityUnitsIn, OG, "SG");
	var FGinSG = (!FG) ? 1 + (OGinSG - 1) / 4 : convertGravity(GravityUnitsIn, FG, "SG");
	return (OGinSG - FGinSG) * 105;
}
alcCalories = function(GravityUnitsIn, OG, FG) {
	var FGinSG = (!FG) ? 1 + (OGinSG - 1) / 4 : convertGravity(GravityUnitsIn, FG, "SG");
	var ABW = alcABW(GravityUnitsIn, OG, FG);
	var RE = alcRE(GravityUnitsIn, OG, FG);
	return ((6.9 * ABW) + 4.0 * (RE - 0.1)) * FGinSG * 3.55;
}
alcRE = function(GravityUnitsIn, OG, FG) {
	var OGinP = convertGravity(GravityUnitsIn, OG, "P");
	var FGinP = (!FG) ? OGinP / 4 : convertGravity(GravityUnitsIn, FG, "P");
	return (0.1808 * OGinP) + (0.8192 * FGinP);
}
co2AtTemp = function(temp, tunits) {
	var c = convertTemp(tunits, temp, "C");
	if (c< 2) return 1.70;
	if (c< 3) return 1.65;
	if (c< 4) return 1.60;
	if (c< 5) return 1.55;
	if (c< 6) return 1.50;
	if (c< 7) return 1.45;
	if (c< 8) return 1.40;
	if (c< 9) return 1.35;
	if (c<10) return 1.30;
	if (c<11) return 1.25;
	if (c<12) return 1.20;
	if (c<13) return 1.16;
	if (c<14) return 1.12;
	if (c<15) return 1.08;
	if (c<16) return 1.05;
	if (c<17) return 1.02;
	if (c<18) return 0.99;
	if (c<19) return 0.96;
	if (c<20) return 0.93;
	if (c<21) return 0.90;
	if (c<22) return 0.88;
	return 0.83;
}
co2CO2FromSugar = function(WeightUnits, WeightIn, VolumeUnits, VolumeIn, PrimerType) {
// Returns the increase in the co2 level of the brew by adding the amount of the sugar type indicated.
	var WeightInGrams = convertWeight(WeightUnits, WeightIn, "Grams")
	var VolumeInLiters = convertVolume(VolumeUnits, VolumeIn, "Liters")
	return WeightInGrams * Primer[PrimerType] / VolumeInLiters
}
co2ForceCarbonation = function(TempUnits, TempIn, PressureUnits, DesiredCO2) {
	var TempInF = convertTemp(TempUnits, TempIn, "F")
	var PresInPSI = -16.6999 - 0.0101059 * TempInF + 0.00116512 * TempInF * TempInF + 0.173354 * TempInF * DesiredCO2 + 4.24267 * DesiredCO2 - 0.0684226 * DesiredCO2 * DesiredCO2;
	return convertPressure("PSI", PresInPSI, PressureUnits);
}
co2SugarFromCO2 = function(WeightUnits, CO2In, VolumeUnits, VolumeIn, PrimerType) {
// Returns the Amount of the sugar type required to increase the co2 level by CO2In.
// Does not take into account the current saturation co2 levels based on temp.
	var VolumeInLiters = convertVolume(VolumeUnits, VolumeIn, "Liters");
	var WeightInGrams = CO2In / Primer[PrimerType] * VolumeInLiters;
	return convertWeight("Grams", WeightInGrams, WeightUnits);
}
convertGravity = function(UnitsIn, GravityIn, UnitsOut) {
	GravityIn = parseFloat(GravityIn) || 0;
	if (UnitsIn==UnitsOut || GravityIn==0) return GravityIn;
	if (UnitsIn=="SG") return (260 - 260 / GravityIn);
	return (260 / (260 - GravityIn));
}
convertPressure = function(UnitsIn, PressureIn, UnitsOut) {
	PressureIn = parseFloat(PressureIn) || 0;
	if (UnitsIn==UnitsOut) return PressureIn;
	if (UnitsIn=="PSI") return 6.89475729316836 * PressureIn;
	return PressureIn / 6.89475729316836;
}
convertSRM = function(MCU) { // Formula from Dan A. Morey
	return (1.4922 * Math.pow(MCU , 0.6859)).toFixed(1);
}
convertTemp = function(UnitsIn, TempIn, UnitsOut) {
	TempIn = parseFloat(TempIn) || 0;
	UnitsIn = UnitsIn.left(1);
	UnitsOut = UnitsOut.left(1);
	if (UnitsIn==UnitsOut) return TempIn;
	if (UnitsIn=="F") return (TempIn - 32) / 1.8;
	return (TempIn * 1.8) + 32;
}
convertVolume = function (UnitsIn, VolumeIn, UnitsOut) {
	VolumeIn = parseFloat(VolumeIn) || 0;
	if (UnitsIn==UnitsOut) return VolumeIn;
	return VolumeIn * LitersConvert[UnitsIn] / LitersConvert[UnitsOut];
}
convertWeight = function(UnitsIn, WeightIn, UnitsOut) {
	WeightIn = parseFloat(WeightIn) || 0;
	if (UnitsIn==UnitsOut) return WeightIn;
	return WeightIn * GramsConvert[UnitsIn] / GramsConvert[UnitsOut];
}
correctGravity = function(GravityUnits, GravityIn, TempUnitsIn, TempIn, CalibrationTempInF) {
	var TempInF = convertTemp(TempUnitsIn, TempIn, "F");
	var GravityInSG = convertGravity(GravityUnits, GravityIn, "SG");
	var At59 = (1.313454) + (-0.132674) * CalibrationTempInF + (0.002057793) * CalibrationTempInF * CalibrationTempInF + (-0.000002627634) * CalibrationTempInF * CalibrationTempInF * CalibrationTempInF;
	GravityInSG = GravityInSG + ((1.313454 - (0.132674 * TempInF) + 0.002067793 * TempInF * TempInF - 0.000002627634 * TempInF * TempInF * TempInF) - At59) / 1000;
	return convertGravity("SG", GravityInSG, GravityUnits);
}
fldChangeEUnits = function(fld, oUnits) {
	var val = convertGravity(oUnits.from, fld.value, oUnits.to);
	fld.value = formatGravity(val, oUnits.to);
	return val;
}
fldChangeVUnits = function(fld, oUnits) {
	var val = convertVolume(oUnits.from, fld.value, oUnits.to);
	fld.value = val.toFixed(2);
	return val;
}
fldChangeWUnits = function(fld, oUnits) {
	var val = convertWeight(oUnits.from, fld.value, oUnits.to);
	fld.value = val.toFixed(2);
	return val;
}
formatGravity = function(val, units) {
	if (units=="SG") return val.toFixed(3);
	return val.toFixed(1);
}
formatTemp = function(val, units) {
	if (units=="F") return val.toFixed(0);
	return val.toFixed(1);
}
ibuAmountFromIBU = function(VolumeUnits, VolumeIn, GravityUnits, GravityIn, WeightUnits, IBUs, HopAAU, HopForm, BoilLength, When, BoilVolumeIn) {
	VolumeIn = parseFloat(VolumeIn) || 0;
	GravityIn = parseFloat(GravityIn) || 1;
	IBUs = parseFloat(IBUs) || 0;
	HopAAU = parseFloat(HopAAU) || 0;
	BoilLength = parseFloat(BoilLength) || 0;
	BoilVolumeIn = parseFloat(BoilVolumeIn) || 0;
	var UtilPCT = ibuGetUtilization(HopForm, BoilLength, When);
	if (VolumeIn==0 || IBUs==0 || HopAAU==0 || UtilPCT==0) return 0;
	var VolumeInLiters = convertVolume(VolumeUnits, VolumeIn, "Liters");
	var GravityCorrection = ibuCorrectionForGravity(GravityUnits, GravityIn, VolumeIn, BoilVolumeIn);
	var WeightInGrams = ((VolumeInLiters * GravityCorrection * IBUs) / (UtilPCT / 100 * HopAAU / 100 * 1000));
	return convertWeight("Grams", WeightInGrams, WeightUnits);
}
ibuCorrectionForGravity = function(GravityUnits, GravityIn, VolumeIn, BoilVolumeIn) {
	var GravityInSG = convertGravity(GravityUnits, GravityIn, "SG");
	if (BoilVolumeIn>0 && BoilVolumeIn!=VolumeIn) {
		GravityInSG = 1 + (VolumeIn / BoilVolumeIn) * (GravityInSG - 1);
	}
	if (GravityInSG>1.05) return 1 + (GravityInSG - 1.05) / 0.2;
	return 1;
}
ibuGetUtilization = function(HopForm, BoilLength, When) {
	if (When=="FWH") return (HopForm=="Pellet" ? 32 : 30);
	if (When=="Dry") return 0;
	if (When=="Mash") return 15;
	if (BoilLength <= 15) return BoilLength / 15 * (HopForm=="Pellet" ? 12 : 10);
	if (BoilLength <= 30) return BoilLength / 30 * (HopForm=="Pellet" ? 22 : 20);
	if (BoilLength <= 45) return BoilLength / 45 * (HopForm=="Pellet" ? 26 : 24);
	if (BoilLength <= 60) return BoilLength / 60 * (HopForm=="Pellet" ? 28 : 26);
	if (BoilLength <= 90) return BoilLength / 90 * (HopForm=="Pellet" ? 32 : 30);
	return (HopForm=="Pellet" ? 32 : 30);
}
ibuIBUFromAmount = function(VolumeUnits, VolumeIn, GravityUnits, GravityIn, WeightUnits, HopWeight, HopAAU, HopForm, BoilLength, When, BoilVolumeIn) {
	VolumeIn = parseFloat(VolumeIn) || 0;
	GravityIn = parseFloat(GravityIn) || 1;
	HopWeight = parseFloat(HopWeight) || 0;
	HopAAU = parseFloat(HopAAU) || 0;
	BoilLength = parseFloat(BoilLength) || 0;
	BoilVolumeIn = parseFloat(BoilVolumeIn) || 0;
	if (VolumeIn==0 || HopWeight==0 || HopAAU==0) return 0;
	var VolumeInLiters = convertVolume(VolumeUnits, VolumeIn, "Liters");
	var GravityCorrection = ibuCorrectionForGravity(GravityUnits, GravityIn, VolumeIn, BoilVolumeIn);
	var WeightInGrams = convertWeight(WeightUnits, HopWeight, "Grams");
	var UtilPCT = ibuGetUtilization(HopForm, BoilLength, When);
	return (WeightInGrams * UtilPCT / 100 * HopAAU / 100 * 1000) / (VolumeInLiters * GravityCorrection);
}
isLoggedIn = function() {
	return bihLoggedIn;
}
maltCapFromMoisture = function(mc) {
	return 0.38 + (mc / 2 / 100);
}
mashDecoctionTemp = function(VolumeUnits, VolumeIn, WeightUnits, MaltWeight, WeightDecocted, TempStart, TempFinal, MaltHeatCap) {
	if (WeightDecocted==0) return TempStart;
	var VolumeInLiters = convertVolume(VolumeUnits, VolumeIn, "Liters");
	var WeightInKg = convertWeight(WeightUnits, MaltWeight, "Kg");
	var DecoctionInKg = convertWeight(WeightUnits, WeightDecocted, "Kg");
	var vm = WeightInKg + VolumeInLiters;
	var mc = (MaltHeatCap * WeightInKg + VolumeInLiters) / (WeightInKg + VolumeInLiters);
	return -(mc * vm / DecoctionInKg * (TempStart - TempFinal) - TempStart);
}
mashDecoctionWeight = function(VolumeUnits, VolumeIn, WeightUnits, MaltWeight, TempAdded, TempStart, TempFinal, MaltHeatCap) {
	if (TempStart==TempFinal || (VolumeIn + MaltWeight)==0) return 0;
	var VolumeInLiters = convertVolume(VolumeUnits, VolumeIn, "Liters");
	var WeightInKg = convertWeight(WeightUnits, MaltWeight, "Kg");
	//var bothalf = (1 + ((TempFinal - TempAdded) / (TempStart - TempFinal)));	bothalf = iif(bothalf==0, 0.001, bothalf);
	var DecoctionInKg = (MaltHeatCap * WeightInKg + VolumeInLiters) / (1 + ((TempFinal - TempAdded) / (TempStart - TempFinal)));
	return convertWeight("Kg", DecoctionInKg, WeightUnits);
}
mashInfusionTemp = function(VolumeUnits, VolumeIn, VolumeInfused, WeightUnits, MaltWeight, TempStart, TempFinal, MaltHeatCap) {
	if (VolumeInfused==0) return TempStart;
	var VolumeInLiters = convertVolume(VolumeUnits, VolumeIn, "Liters");
	var InfusionInLiters = convertVolume(VolumeUnits, VolumeInfused, "Liters");
	var WeightInKg = convertWeight(WeightUnits, MaltWeight, "Kg");
	var vm = WeightInKg + VolumeInLiters;
	var mc = (MaltHeatCap * WeightInKg + VolumeInLiters) / (WeightInKg + VolumeInLiters);
	return -(mc * vm * (TempStart - TempFinal) - InfusionInLiters * TempFinal) / InfusionInLiters;
}
mashInfusionVolume = function(VolumeUnits, VolumeIn, WeightUnits, MaltWeight, TempAdded, TempStart, TempFinal, MaltHeatCap) {
	if (TempStart==TempFinal || (VolumeIn + MaltWeight)==0) return 0;
	var VolumeInLiters = convertVolume(VolumeUnits, VolumeIn, "Liters");
	var WeightInKg = convertWeight(WeightUnits, MaltWeight, "Kg");
	var vm = WeightInKg + VolumeInLiters;
	var mc = (MaltHeatCap * WeightInKg + VolumeInLiters) / (WeightInKg + VolumeInLiters);
	var InfusionInLiters = mc * vm * (TempStart - TempFinal) / iif((TempFinal - TempAdded)==0, 0.001, TempFinal - TempAdded);
	return convertVolume("Liters", InfusionInLiters, VolumeUnits);
}
pctExtractFromSGC = function(SGC) {
	return (SGC - 1) * 1000 / 0.4631;
}
popPrimer = function(selector) {
	return $(selector).each(
		function() {
			var $this = $(this);
			for (var type in Primer) {
				var $opt = $("<option></option>").attr("value",type).text(type);
				$this.append($opt);
			}
		}
	);
}
popStepType = function(selector) {
	var arr = "Infusion,Decoction,Heat".split(",");
	return $(selector).each(
		function() {
			var $this = $(this);
			for (var i=0;i<arr.length;i++) $this.append($("<option></option>").attr("value",arr[i]).text(arr[i]));
		}
	);
}
popUnitSelect = function(selector, collection) {
	return $(selector).each(
		function() {
			var $this = $(this);
			for (var unit in collection) {
				var $opt = $("<option></option>").attr("value",unit).text(unit);
				$this.append($opt);
			}
		}
	);
}
rotateDateType = function(btn) {
	return rotateSetVal(btn, DateType[btn.innerHTML] || DateType["Default"]);
}
rotateGravity = function(btn) {
	var next = (btn.value=="SG") ? "Plato" : "SG";
	return rotateSetVal(btn, GravityUnits[next], next);
}
rotateHopForm = function(btn) {
	return rotateSetVal(btn, HopForm[btn.innerHTML] || bihDefaults.HOPFORM);
}
rotateHopWhen = function(btn) {
	return rotateSetVal(btn, HopWhen[btn.innerHTML] || HopWhen["Default"]);
}
rotateMashType = function(btn) {
	return rotateSetVal(btn, MashType[btn.innerHTML] || bihDefaults.MASHTYPE);
}
rotateMiscAction = function(btn) {
	return rotateSetVal(btn, Action[btn.innerHTML] || Action["Default"]);
}
rotateMiscAdded = function(btn) {
	return rotateSetVal(btn, Added[btn.innerHTML] || Added["Default"]);
}
rotateMiscPhase = function(btnPhase, btnAdded, btnAction) {
	var phs = rotateSetVal(btnPhase, Phase[btnPhase.innerHTML] || Phase["Default"]);
	rotateSetVal(btnAdded, Added[phs] || Added["Default"]);
	rotateSetVal(btnAction, Action[phs]);
	return phs;
}
rotateTemp = function(btn) {
	var next = (btn.value=="F") ? "C" : "F";
	return rotateSetVal(btn, TempUnits[next], next);
}
sgcFromPctExtract = function(CGDB, MoistureContent, FGDB, FCDifference) {
	if (CGDB==0) CGDB = FGDB - FCDifference;
	return ((1.0 - MoistureContent / 100) * CGDB * (0.4631) / 1000) + 1;
	// also SGC = "1.0"+(((FGDB * (100-MC)/100) - FCDiff)/100 * 46.31).toFixed(0);
}
sidebarToggle = function(img) {
	var $info = $(img).parent().next("div");
	var isVis = $info.css("display")!="none";
	img.className = "toggler bih-icon bih-icon bih-icon-" + (isVis ? "expand" : "collapse");
	$info.slideToggle();
}
spinnerBind = function($dom, inc, fn) {
	return $dom.on("keydown change", inc, fn);
}
spinnerBindGravity = function($dom, eunits, fn) {
	return $dom.off("keydown change").on("keydown change", (eunits=="SG") ? incSG : incPlato, fn);
}
spinnerBindTemp = function($dom, tunits, fn) {
	return $dom.off("keydown change").on("keydown change", (tunits=="F") ? incF : incC, fn);
}
unitbtnFromTo = function(btn, Rotater) {
	var units = new Object();
	units.from = btn.innerHTML;
	units.to = rotateSetVal(btn, Rotater[units.from] || Rotater["Default"]);
	return units;
}
unitselFromTo = function(sel) {
	var units = new Object();
	units.to = (sel.type=="button") ? sel.value : selectedValue(sel);
	units.from = sel["oldvalue"] || units.to;
	sel["oldvalue"] = units.to;
	return units;
}
unitselInit = function(sel, val) {
	sel.value = val; //selectValue(sel, val) :
	sel["oldvalue"] = val;
}
popInfoURL = function(img, which) {
	var idx = $(img).closest("tr").data("rowid");
	var url;
	if (which=="g") url = qryGrains.DATA[idx].GR_URL || "http://www.google.com/search?q="+ qryGrains.DATA[idx].GR_MALTSTER + "+" + qryGrains.DATA[idx].GR_TYPE;
	else if (which=="h") url = qryHops.DATA[idx].HP_URL || "http://www.google.com/search?q="+ qryHops.DATA[idx].HP_HOP + "+" + qryHops.DATA[idx].GR_GROWN;
	popOut(url, which+"PopOut");
}
skipNots = function(NOTS, ROW) {
	var skip = false;
	if (NOTS) for (var key in NOTS) if (skip = ($.inArray(ROW[key], NOTS[key])!=-1)) break;
	return skip;
}
