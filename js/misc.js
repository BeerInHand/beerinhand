miscClickRow = function() {
	var rowid = $(this).data("rowid") || 0;
	var $tab = $("#infoMisc");
	miscScatter(qryMisc.DATA[rowid], $tab);
}
miscInit = function() {
	queryMakeHashable(qryMisc);
	var $tabMisc = $("#tabMisc");
	var $tbMisc = $tabMisc.find("tbody");
	var $trMisc = $tbMisc.find("tr");
	var nots = (window["isExplorer"]=="undefined" && filterData["Misc"]);
	for (var j = 0; j < qryMisc.DATA.length; j++) {
		var $trAdd = $trMisc.clone();
		var ROW = qryMisc.DATA[j];
		if (skipNots(nots, ROW)) continue;
		miscScatter(ROW, $trAdd);
		$trAdd.attr("id", "mi_rowid"+ROW._ROWID);
		$trAdd.data("rowid", ROW._ROWID);
		$tbMisc.append($trAdd);
	}
	$trMisc.remove();
	$tabMisc.parent().removeClass("hide");
	$tabMisc.tablescroller({id: "Misc", height: 330, sort: true, print: false, borderWidth: 1, borderColor: "#979F97"});
	$tbMisc.find("tr").click(miscClickRow);
	miscClickRow();
}
miscScatter = function(ROW, $Obj) {
	$Obj.find(".mi_type").html(ROW.MI_TYPE);
	$Obj.find(".mi_use").html(ROW.MI_USE);
	$Obj.find(".mi_phase").html(ROW.MI_PHASE);
	if ($Obj.attr("id")=="infoMisc") {
		$Obj.find(".mi_unit").html(ROW.MI_UNIT);
		$Obj.find("div.mi_info").html(ROW.MI_INFO);
		rowHighlight($Obj, "mi_rowid", ROW._ROWID);
	} else {
		$Obj.find("div.mi_info").html(left(ROW.MI_INFO,50));
	}
}
miscScrollTo = function() {
	var $tr = $("#tabScrollBodyMisc").find("tbody").find("#mi_rowid"+selectedRow.rowid);
	if (!$tr.length) return;
	var $div = $("#divScrollBodyMisc");
	$div.scrollTo($tr, 800);
}
