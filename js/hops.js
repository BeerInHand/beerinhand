hopsClickRow = function() {
	var rowid = $(this).data("rowid") || 0;
	var $tab = $("#infoHops");
	hopsScatter(qryHops.DATA[rowid], $tab);
}
hopsInit = function() {
	queryMakeHashable(qryHops);
	var $tabHops = $("#tabHops");
	var $tbHops = $tabHops.find("tbody");
	var $trHops = $tbHops.find("tr");
	var nots = (window["isExplorer"]=="undefined" && filterData["Hops"]);
	for (var j = 0; j < qryHops.DATA.length; j++) {
		var $trAdd = $trHops.clone();
		var ROW = qryHops.DATA[j];
		if (skipNots(nots, ROW)) continue;
		hopsScatter(ROW, $trAdd);
		$trAdd.attr("id", "hp_rowid"+ROW._ROWID);
		$trAdd.data("rowid", ROW._ROWID);
		$tbHops.append($trAdd);
	}
	$trHops.remove();
	$tabHops.parent().removeClass("hide");
	$tabHops.tablescroller({id: "Hops", height: 330, sort: true, print: false, borderWidth: 1, borderColor: "#979F97"});
	$tbHops.find("tr").click(hopsClickRow);
	hopsClickRow();
//	if (typeof $RecipeHops!="undefined" && typeof $RecipeHops[0]!="undefined") recipeHopsFind();
}
hopsMakeInfo = function(lab, fld, ROW) {
	if (ROW[fld]=="") return "";
	return "<span class='normal smallcaps'>"+lab+":</span> " + ROW[fld] + "<br><br>";
}
hopsScatter = function(ROW, $Obj) {
	$Obj.find(".hp_hop").html(ROW.HP_HOP);
	$Obj.find(".hp_grown").find("img").attr("class", "flagSM flag"+ROW.HP_GROWN.replace(" ","")).attr("title",ROW.HP_GROWN);
	$Obj.find(".hp_grown").find("span").html(ROW.HP_GROWN);
	$Obj.find(".hp_lvb").html(ROW.HP_LVB);
	$Obj.find(".hp_aalow").html(ROW.HP_AALOW.toFixed(1));
	$Obj.find(".hp_aahigh").html(ROW.HP_AAHIGH.toFixed(1));
	$Obj.find(".hp_dry").find("img").attr("class", "bih-icon bih-icon-checked"+iif(ROW.HP_DRY,"1","0"));
	$Obj.find(".hp_aroma").find("img").attr("class", "bih-icon bih-icon-checked"+iif(ROW.HP_AROMA,"1","0"));
	$Obj.find(".hp_bitter").find("img").attr("class", "bih-icon bih-icon-checked"+iif(ROW.HP_BITTER,"1","0"));
	$Obj.find(".hp_finish").find("img").attr("class", "bih-icon bih-icon-checked"+iif(ROW.HP_FINISH,"1","0"));
	if ($Obj.attr("id")=="infoHops") {
		$Obj.find(".hp_aa").html(ROW.HP_AALOW.toFixed(1) + " - " + ROW.HP_AAHIGH.toFixed(1));
		var info = hopsMakeInfo("Profile", "HP_PROFILE", ROW);
		info += hopsMakeInfo("Use", "HP_USE", ROW);
		info += hopsMakeInfo("Substitute", "HP_SUB", ROW);
		info += hopsMakeInfo("Examples", "HP_EXAMPLE", ROW);
		info += hopsMakeInfo("Info", "HP_INFO", ROW);
		$Obj.find("div.hp_info").html(info);
		rowHighlight($Obj, "hp_rowid", ROW._ROWID);
	} else {
		$Obj.find(".hp_aalow").html(ROW.HP_AALOW.toFixed(1));
		$Obj.find(".hp_aahigh").html(ROW.HP_AAHIGH.toFixed(1));
		$Obj.find("div.hp_profile").html(ROW.HP_PROFILE.left(50));
	}
}
hopsScrollTo = function() {
	var $tr = $("#tabScrollBodyHops").find("tbody").find("#hp_rowid"+selectedRow.rowid);
	var $div = $("#divScrollBodyHops");
	$div.scrollTo($tr, 800);
}
