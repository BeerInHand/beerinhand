dataHelper = function(key, defcap) {
	defcap = defcap || (key.match(/INFO/g) ? "Information" : key.split("_").slice(1).join(" ").toLowerCase());
	var helpers = {
		trMonth: {
			hit: function(ROW, val) {
				var d = new Date(ROW.RE_BREWED);
				return brewlogSumRow(ROW, (d.getFullYear()==val.year) &&  (d.getMonth()+1==val.mon));
			},
			val: function(val) {
				var parts = val.split("_");
				return {
					year: parseInt(parts[0],10),
					mon: (parseInt(parts[1],10))
				}
			},
			cap: "Month"
		},
		trYear: {
			hit: function(ROW, val) { var d = new Date(ROW.RE_BREWED); return brewlogSumRow(ROW, d.getFullYear()==val.year) },
			val: function(val) {
				return {year: parseInt(val,10).toString() };
			},
			cap: "Year"
		},
		BL_ALL : {
			hit: function(ROW, val) { return brewlogSumRow(ROW, true) }
		},
		DEFAULT: {
			hit: function(ROW, val, key) { return brewlogSumRow(ROW, isNumber(val) ? ROW[key]==val : RegExp(val,"gi").test(ROW[key])) },
			cap: defcap,
			val: function(val) { return val }
		}
	}
	if (helpers[key]) {
		if (helpers[key].hit==undefined) helpers[key].hit = helpers["DEFAULT"].hit;
		if (helpers[key].cap==undefined) helpers[key].cap = helpers["DEFAULT"].cap;
		if (helpers[key].val==undefined) helpers[key].val = helpers["DEFAULT"].val;
		return helpers[key];
	}
	return helpers["DEFAULT"];
}
brewlogSumRow = function(ROW, hit) {
	if (!hit) return false;
	sum.cnt++;
	sum.vol += convertVolume(ROW.RE_VUNITS, ROW.RE_VOLUME, bihDefaults.VUNITS);
	sum.grv += convertGravity(ROW.RE_EUNITS, ROW.RE_EXPGRV, bihDefaults.EUNITS);
	sum.srm += ROW.RE_EXPSRM;
	sum.ibu += ROW.RE_EXPIBU;
	sum.eff += ROW.RE_EFF;
	return true;
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
		} else {
			filter["BL_ALL"] = "";
		}
	}
	sum = { cnt: 0, vol: 0, grv: 0, srm: 0, eff: 0, ibu: 0 };
	for (var j = 0; j < qryBrewLog.DATA.length; j++) {
		if (treeFilterRow($("#bl_rowid"+j), dataMatch(filter, qryBrewLog.DATA[j]))) cnt++;
	}
	$("#bl_cnt").html(sum.cnt + addS(" record",sum.cnt));
	$("#bl_total").html(sum.vol.toFixed(2) + " " + bihDefaults.VUNITS);
	$("#bl_avgvolume").html((sum.vol / sum.cnt).toFixed(2));
	$("#bl_avggrv").html((sum.grv / sum.cnt).toFixed(3));
	$("#bl_avgibu").html((sum.ibu / sum.cnt).toFixed(0));
	$("#bl_avgsrm").html((sum.srm / sum.cnt).toFixed(1));
	$("#bl_avgeff").html((sum.eff / sum.cnt).toFixed(0));
	
	if (cnt==0) {
//		$title.html("Your glass is empty.");
	}
	$.tablesorter.applyWidget($expTab[0]);
	$.tablescroller.resizeControl($tabBrewLog, true);
	$expCap.html(defcap + title);
//	$content.find("a").off("click").on("click", dataClick);
}
brewlogSearch = function() {
	var frm = document.frmDataSrc;
	if (isEmpty(frm.dataSrcVal)) return showStatusWindow("Search value is required.");
	var obj = new Object();
	obj[selectedValue(frm.dataSrcFld)] = trim(frm.dataSrcVal);
	brewlogLoad(null, obj);
	return false;
}
breelogTree = function() {
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
