sum = { cnt: 0, vol: 0, grv: 0, srm: 0, eff: 0, ibu: 0 };

brewlogInit = function() {
	if (!window["qryBrewLog"]) brewlogLoadLS();
	var cnt = qryBrewLog.DATA.length;
	$tabBrewLog = $("#tabBrewLog");
	var $tbBrewLog = $tabBrewLog.find("tbody");
	var $trBrewLog = $tbBrewLog.find("tr");
	for (var j = 0; j < qryBrewLog.DATA.length; j++) {
		var $trAdd = $trBrewLog.clone();
		var ROW = qryBrewLog.DATA[j];
		brewlogScatter(ROW, $trAdd);
		$trAdd.attr("id", "bl_rowid"+ROW._ROWID);
		$trAdd.data("rowid", ROW._ROWID);
		$trAdd.data("pk", ROW.RE_REID);
		$tbBrewLog.append($trAdd);
	}
	$trBrewLog.remove();
	$tabBrewLog.removeClass("hide");
	$tabBrewLog.tablescroller({ id: "BrewLog", height: 610, sort: true, print: false, borderWidth: 1, borderColor: "#979F97" });
	$expCap = $("#divCaptionBrewLog");
	$expTab = $("#tabScrollBodyBrewLog");
	if (!cnt) return;
	brewLogSetSum();
}
brewlogLoad = function(node, filter) {
	var title = "";
	var cnt = 0;
	if (!filter) {
		filter = new Object();
		var key = node.data.key.split("!");
		if (key.length>1) {
			filter[key[0]]=key[1];
			if (key[0]=="trMonth") {
				var val = dataHelper("trMonth").val(key[1]);
				val.d = parseDate(val.mon+"/01/"+val.year,"mm/dd/yyyy");
				title = " : " + val.d.month + " " + val.year;
			} else {
				title = " : " + key[1];
			}
		}
	}
	sum = { cnt: 0, vol: 0, grv: 0, srm: 0, eff: 0, ibu: 0 };
	for (var j = 0; j < qryBrewLog.DATA.length; j++) if (treeFilterRow($("#bl_rowid"+j), dataMatch(filter, qryBrewLog.DATA[j]))) brewlogSum(qryBrewLog.DATA[j]);
	brewLogSetSum();
	$.tablesorter.applyWidget($expTab[0]);
	$.tablescroller.resizeControl($tabBrewLog, true);
	$expCap.html(defcap + title);
}
brewlogLoadLS = function() {
	var rcpList = localStorage.getItem("BIHLIST");
	qryBrewLog = {DATA:[]};
	if (!rcpList) return $("#brewlogMsg").html("There are no recipes stored locally on this computer.");
	rcpList = rcpList.split(",");
	while (rcpList.length) {
		var reid = rcpList.pop();
		var RCP = JSON.parse(localStorage.getItem("BIHDETAIL"+reid));
		qryBrewLog.DATA.push(RCP.qryRecipe.DATA[0]);
	}
}
brewlogScatter = function(ROW, $row) {
	$row.find(".bl_brewer").html(ROW.RE_BREWER);
	$row.find(".bl_name").html(ROW.RE_NAME);
	$row.find(".bl_style").html(ROW.RE_STYLE);
	$row.find(".bl_brewed").html(jsDateFormat(new Date(ROW.RE_BREWED), cfDateMask));
	var volume = convertVolume(ROW.RE_VUNITS, ROW.RE_VOLUME, bihDefaults.VUNITS);
	$row.find(".bl_volume").html(volume.toFixed(2));
	var expgrv = convertGravity(ROW.RE_EUNITS, ROW.RE_EXPGRV, bihDefaults.EUNITS);
	$row.find(".bl_expgrv").html(formatGravity(expgrv, bihDefaults.EUNITS));
	$row.find(".bl_expibu").html(ROW.RE_EXPIBU.toFixed(1));
	$row.find(".bl_expsrm").html(ROW.RE_EXPSRM.toFixed(1));
	$row.find(".bl_eff").html(ROW.RE_EFF.toFixed(0));
	if (ROW.RE_PRIVACY) {
		$row.find(".iconedit").find(".ui-button-icon-primary").removeClass("ui-icon-pencil").addClass("ui-icon-locked");
	}
	brewlogSum(ROW);
}
brewlogSearch = function() {
	var frm = document.frmDataSrc;
	if (isEmpty(frm.dataSrcVal)) return showStatusWindow("Search value is required.");
	var obj = new Object();
	obj[selectedValue(frm.dataSrcFld)] = trim(frm.dataSrcVal);
	brewlogLoad(null, obj);
	return false;
}
brewLogSetSum = function() {
	if (!sum.cnt) {
//		$title.html("Your glass is empty.");
	}
	$("#bl_cnt").html(sum.cnt + addS(" record",sum.cnt));
	$("#bl_total").html(sum.vol.toFixed(2) + " " + bihDefaults.VUNITS);
	$("#bl_avgvolume").html((sum.vol / sum.cnt).toFixed(2));
	$("#bl_avggrv").html((sum.grv / sum.cnt).toFixed(3));
	$("#bl_avgibu").html((sum.ibu / sum.cnt).toFixed(0));
	$("#bl_avgsrm").html((sum.srm / sum.cnt).toFixed(1));
	$("#bl_avgeff").html((sum.eff / sum.cnt).toFixed(0));
}
brewlogSum = function(ROW) {
	sum.cnt++;
	sum.vol += convertVolume(ROW.RE_VUNITS, ROW.RE_VOLUME, bihDefaults.VUNITS);
	sum.grv += convertGravity(ROW.RE_EUNITS, ROW.RE_EXPGRV, bihDefaults.EUNITS);
	sum.srm += ROW.RE_EXPSRM;
	sum.ibu += ROW.RE_EXPIBU;
	sum.eff += ROW.RE_EFF;
}
brewlogTree = function() {
	defcap = $expCap.text();
	var $sideTree = $("#dataTree");
	var $tree = $sideTree.find("div").detach();
	if (nodesBrewLog) {
		for (var j = 0; j < nodesBrewLog.length; j++) {
			$tree.clone().prepend(nodesBrewLog[j].TITLE).appendTo($sideTree);
			var $div = $("<div>").attr("id", "tree"+j).appendTo($sideTree).dynatree({ title: nodesBrewLog[j].TITLE, onActivate: brewlogLoad, children: nodesBrewLog[j].NODES });
		}
	}
	selectFill(getById("dataSrcFld"), { Name:"RE_NAME", Style:"RE_STYLE", Year:"trYear" });
}

