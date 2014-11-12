yeastClickRow = function() {
	var rowid = $(this).data("rowid") || 0;
	var $tab = $("#infoYeast");
	yeastScatter(qryYeast.DATA[rowid], $tab);
}
yeastInit = function() {
	queryMakeHashable(qryYeast);
	var $tabYeast = $("#tabYeast");
	var $tbYeast = $tabYeast.find("tbody");
	var $trYeast = $tbYeast.find("tr");
	var nots = (window["isExplorer"]=="undefined" && filterData["Yeast"]);
	for (var j = 0; j < qryYeast.DATA.length; j++) {
		var $trAdd = $trYeast.clone();
		var ROW = qryYeast.DATA[j];
		if (skipNots(nots, ROW)) continue;
		yeastScatter(ROW, $trAdd);
		$trAdd.attr("id", "ye_rowid"+ROW._ROWID);
		$trAdd.data("rowid", ROW._ROWID);
		$tbYeast.append($trAdd);
	}
	$trYeast.remove();
	$tabYeast.parent().removeClass("hide");
	$tabYeast.tablescroller({id: "Yeast", height: 380, sort: true, print: false, borderWidth: 1, borderColor: "#979F97"});
	$tbYeast.find("tr").click(yeastClickRow);
	yeastClickRow();
//	if (typeof $RecipeYeast!="undefined" && typeof $RecipeYeast[0]!="undefined") recipeYeastFind();
}
yeastScatter = function(ROW, $Obj) {
	$Obj.find(".ye_yeast").html(ROW.YE_YEAST);
	$Obj.find(".ye_mfgno").html(ROW.YE_MFGNO);
	$Obj.find(".ye_mfg").html(ROW.YE_MFG);
	$Obj.find(".ye_type").html(ROW.YE_TYPE);
	var uTL = formatTemp(convertTemp(ROW.YE_TEMPUNITS, ROW.YE_TEMPLOW, bihDefaults.TUNITS));
	var uTH = formatTemp(convertTemp(ROW.YE_TEMPUNITS, ROW.YE_TEMPHIGH, bihDefaults.TUNITS));
	if ($Obj.attr("id")=="infoYeast") {
		$Obj.find(".ye_floc").html(ROW.YE_FLOC);
		$Obj.find(".ye_at").html(ROW.YE_ATLOW + " - " + ROW.YE_ATHIGH + " %");
		$Obj.find(".ye_temp").html(uTL + " - " + uTH + " &deg;" + ROW.YE_TEMPUNITS.left(1));
		$Obj.find("div.ye_info").html(ROW.YE_INFO);
		rowHighlight($Obj, "ye_rowid", ROW._ROWID);
	} else {
		$Obj.find(".ye_atlow").html(ROW.YE_ATLOW);
		$Obj.find(".ye_athigh").html(ROW.YE_ATHIGH);
		$Obj.find(".ye_templow").html(uTL);
		$Obj.find(".ye_temphigh").html(uTH);
	}
}
yeastScrollTo = function() {
	var $tr = $("#tabScrollBodyYeast").find("tbody").find("#ye_rowid"+selectedRow.rowid);
	var $div = $("#divScrollBodyYeast");
	$div.scrollTo($tr, 800);
}