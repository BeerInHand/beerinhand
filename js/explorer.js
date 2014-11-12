treeCallBack = function(response) {
	var msg;
	if (!response.SUCCESS) {
		cbErrors(response);
	} else {
		if (response.DATA.METHOD=="Set") {
			showStatusWindow("Filter Saved");
		}
	}
}
treeFilterData = function(node, filter, qry, formatter) {
	var rows = qry.DATA.length;
	var cnt = 0;
	if (node.data.isRoot) {
		filter.nots = treeNots(node.tree);
	} else if (node.data.isFolder) {
		filter.nots = treeNots(node.tree, node.data.key);
	} else {
		filter.field = node.data.key.split("!")[0];
		if (typeof formatter=="object" && formatter[filter.field] && formatter[filter.field].val) {
			formatter[filter.field].val(filter);
		} else {
			filter.val = node.data.title;
			filter.caption += " for " + filter.val;
		}
	}
	for (var j=0; j<rows; j++) {
		var hit = true;
		var ROW = qry.DATA[j];
		if (node.data.isRoot || node.data.isFolder) {
			hit = !treeNodeInNots(ROW, filter.nots);
			if (hit && node.data.isRoot && typeof formatter=="object" && formatter["ROOT"]) formatter["ROOT"].hit(ROW);
		} else {
			if (typeof formatter=="object" && formatter[filter.field]) {
				hit = formatter[filter.field].hit(ROW, filter.val);
			} else {
				hit = (ROW[filter.field]==filter.val);
			}
		}
		if (treeFilterRow($(filter.rowid+j), hit)) cnt++;
	}
	filter.caption += treeRowCnt(rows, cnt);
	$.tablesorter.applyWidget($expTab[0]);
	$expCap.html(filter.caption);
}
treeFilterGrains = function(node) {
	treeFilterData(node, {caption: "Grains", rowid: "#gr_rowid", val: node.data.title}, qryGrains, {
		GR_LVB: {
			hit: function(ROW, val) {return ROW.GR_LVB>=val[0] && ROW.GR_LVB<=val[1]},
			val: function(filter) { filter.caption+=" for SRM "+ filter.val; filter.val=treeRange(filter.val, "5000") }
		}
	});
}
treeFilterHops = function(node) {
	treeFilterData(node, {caption: "Hops", rowid: "#hp_rowid", val: node.data.title}, qryHops, {
		HP_AAU: {
			hit: function(ROW, val) { var avg=(ROW.HP_AALOW+ROW.HP_AAHIGH)/2; return (avg>=val[0] && avg<=val[1]) },
			val: function(filter) { filter.caption+=" for AAU "+ filter.val; filter.val=treeRange(filter.val, "50") }
		},
		HP_USE: {
			hit: function(ROW, val) { return (val=="Bittering") ? ROW.HP_BITTER!=0 : (val=="Aroma") ? ROW.HP_AROMA!=0 : ROW.HP_DRY!=0 }
		}
	});
}
treeFilterMisc = function(node) {
	treeFilterData(node, {caption: "Miscellaneous Ingredients", rowid: "#mi_rowid", val: node.data.title}, qryMisc);
}
treeFilterRow = function($tr, show) {
	if (show) {
		$tr.show();
	} else {
		$tr.hide();
	}
	return show;
}
treeFilterUsers = function(node) {
	treeFilterData(node, {caption: "Brewers", rowid: "#us_rowid", val: node.data.title}, qryUsers, {
		US_ALPHA: {
			hit: function(ROW, val) {return ROW.US_USER.left(1)==val },
			val: function(filter) { filter.caption+=" starting with "+ filter.val }
		},
		US_MASHTYPE: {
			hit: function(ROW, val) { return ROW.US_MASHTYPE==val },
			val: function(filter) { filter.caption = filter.val + " Brewers"; }
		}
	});
}
treeFilterYeast = function(node) {
	treeFilterData(node, {caption: "Yeast Strains", rowid: "#ye_rowid", val: node.data.title}, qryYeast);
}
treeInit = function(which) {
	which = which || "Grains";
	$divExpAcc = $("#divExpAcc").accordion({
		fillSpace:true,
		changestart:function(event, ui) { treeLoad(ui.newHeader.data("src")) },
		animated:false
	});
	treeLoad(which);
	$divExpSave = $("#divExpSave");
}
treeLazyData = function(which, param) {
	var data = { root: param || "source" };
	if (window["brewerID"]!=undefined) data.brewerID = brewerID;
	return { url: (bihPath.cfc + "/proxy.cfc"), data: {method: "call", args: JSON.stringify({meth: which+".GetExplorerNodes", data: data})}, postProcess: treeLazyLoaded }
}
treeLazyLoaded = function(data, type) {
	if (bihLoggedIn) {
		var which = $divTree.data("which");
		if (treeShowSave(which)) {
			$divTree.append($divExpSave.hide().fadeIn());
			treeSetFiltered(data, filterData[which]);
		}
	}
	return data;
}
treeLoad = function(which) {
	treeFilter = window["treeFilter"+which];
	$("#divExpRight").find(">div").hide();
	var $divExp = $("#divExp"+which).show();
	$divTree = $("#divTree"+which);
	if ($divTree.data("loaded")) {
		$expCap = $("#divCaption"+which);
		$expTab = $("#tabScrollBody"+which);
		if (treeShowSave(which)) $divTree.append($divExpSave.hide().fadeIn());
		return;
	}
	$divTree.data("loaded", true).data("which", which);
	$divTree.html("<ul id='tree"+which+"'></ul>");
	$divTree.dynatree({
		idPrefix: "tree"+which,
		cookieId: "tree"+which,
		checkbox: treeShowChecks(which),
		selectMode: 3,
		minExpandLevel: 1,
		autoCollapse: false,
		fx: { height: "toggle", duration: 800 },
		initAjax: treeLazyData(which),
		onLazyRead: function(node) { node.appendAjax(treeLazyData(which, node.data.key)) },
		onActivate: treeFilter,
		onSelect: treeSelect,
		onDblClick: function(node, event) { node.toggleSelect() },
		onKeydown: function(node, event) { if (event.which==32) { node.toggleSelect(); return false; }}
	});
	pageURL = "e."+which+".cfm";
	$divExp.load(pageURL,
		function() {
			$expTab = $("#tabScrollBody"+which);
			if (!$expTab.length) return;
			$expCap = $("#divCaption"+which);
		}
	);
}
treeNodeInNots = function(ROW, nots) {
	for (var key in nots) if ($.inArray(ROW[key], nots[key])!=-1) return true;
	return false;
}
treeNots = function(tree, branch) {
	branch = branch || false;
	var nots = {};
	$.each(tree.getSelectedNodes(), function(idx){
		var parts = this.data.key.split("!");
		if (!branch || branch==parts[0]) {
			if (nots[parts[0]]==undefined) nots[parts[0]] = [];
			nots[parts[0]].push(parts[1]);
		}
	});
	return nots;
}
treeRange = function(val, max, f) {
	if (isNumber(val)) return [val,val];
	val = val.split("-");
	val[0] = f ? parseFloat(val[0]) : parseInt(val[0]);
	val[1] = f ? parseFloat(val[1] || max) : parseInt(val[1] || max);
	return val;
}
treeRowCnt = function(rows, cnt) {
	return "<span class=rowcnt>" + filterCnt(rows,cnt) + "</span>";
}
treeSave = function() {
	var which = $divTree.data("which");
	var val = treeNots($divTree.dynatree("getTree"));
	filterData[which] = val;
	var DATA = { set: "filter" + which, value: val };
	remoteCall("UserPrefs.Process", DATA, treeCallBack);
}
treeSelect = function(select, node) {
	if (select && node.data.isFolder) {
		node.toggleSelect(false);
		treeFilter(node);
	}
	if (node.getParent().isActive()) {
		treeFilter(node.getParent());
	} else if (node.getParent().getParent().isActive()) {
		treeFilter(node.getParent().getParent());
	}
}
treeSetFiltered = function(nodes, filter) {
	if (nodes.length!=undefined) {
		for (var j=0; j<nodes.length; j++) {
			if (nodes[j].children==undefined) {
				var which = nodes[j].key.split("!")[0];
				if (filter[which]==undefined) return; // IF WE DON'T HAVE A FILTER FOR THIS NODE, WE CAN SKIP IT AND IT'S SIBS
				if ($.inArray(nodes[j].title, filter[which])!=-1) nodes[j].select = true;
			} else {
				treeSetFiltered(nodes[j].children, filter);
			}
		}
	}
}
treeShowChecks = function(which) {
	return "Users".match(which)==null;
}
treeShowSave = function(which) {
	return "Users".match(which)==null;
}
