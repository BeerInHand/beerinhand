grainsClickRow = function() {
	var rowid = $(this).data("rowid") || 0;
	var $tab = $("#infoGrains");
	grainsScatter(qryGrains.DATA[rowid], $tab);
}
grainsInit = function() {
	var $tabGrains = $("#tabGrains");
	queryMakeHashable(qryGrains);
	var $tbGrains = $tabGrains.find("tbody");
	var $trGrains = $tbGrains.find("tr");
	var nots = (window["isExplorer"]=="undefined" && filterData["Grains"]);
	for (var j = 0; j < qryGrains.DATA.length; j++) {
		var ROW = qryGrains.DATA[j];
		if (skipNots(nots, ROW)) continue;
		var $trAdd = $trGrains.clone();
		grainsScatter(ROW, $trAdd);
		$trAdd.attr("id", "gr_rowid"+ROW._ROWID);
		$trAdd.data("rowid", j);
		$tbGrains.append($trAdd);
	}
	$trGrains.remove();
	$tabGrains.parent().removeClass("hide");
	$tabGrains.tablescroller({id: "Grains", height: 330, sort: true, print: false, borderWidth: 1, borderColor: "#979F97"});
	$tbGrains.find("tr").click(grainsClickRow);
	$tbGrains.find("tr:first").click();
}
grainsScatter = function(ROW, $Obj) {
	$Obj.find(".gr_type").html(ROW.GR_TYPE);
	$Obj.find(".gr_maltster").html(ROW.GR_MALTSTER);
	$Obj.find(".gr_country").find("img").attr("class", "flagSM flag"+ROW.GR_COUNTRY).attr("title",ROW.GR_COUNTRY);
	$Obj.find(".gr_country").find("span").html(ROW.GR_COUNTRY);
	$Obj.find(".gr_lvb").html(ROW.GR_LVB);
	$Obj.find(".gr_sgc").html(ROW.GR_SGC.toFixed(3));
	$Obj.find(".gr_mash").find("img").attr("class", "bih-icon bih-icon-checked"+iif(ROW.GR_MASH,"1","0"));
	$Obj.find(".gr_cat").html(ROW.GR_CAT);
	$Obj.find(".gr_url").html(getPopOutImg(ROW.GR_URL));
	if ($Obj.attr("id")=="infoGrains") {
		$Obj.find(".gr_info").html(ROW.GR_INFO);
		rowHighlight($Obj, "gr_rowid", ROW._ROWID);
	} else {
		$Obj.find("div.gr_info").html(ROW.GR_INFO.left(50));
	}
}
grainsScrollTo = function() {
	var $tr = $("#tabScrollBodyGrains").find("tbody").find("#gr_rowid"+selectedRow.rowid);
	if (!$tr.length) return;
	var $div = $("#divScrollBodyGrains");
	$div.scrollTo($tr, 800);
}

