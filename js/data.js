var links = { cnt: 0, title: "", list: {}, filter: {} };

dataCallback = function(response) {
	var ROW;
	if (!response.SUCCESS) {
		cbErrors(response);
	} else {
		if (response.DATA.METHOD=="Delete") {
			return showStatusWindow("Row Deleted");
		} else if (response.DATA.METHOD=="Insert") {
			showStatusWindow("Row Inserted");
		} else if (response.DATA.METHOD=="Update") {
			showStatusWindow("Row Updated");
		}
		qryUserEdit = response.DATA.qryUserEdit;
		queryMakeHashable(qryUserEdit);
		dataLoadEdits();
	}
}
dataClick = function(event) {
	if (event.currentTarget.target!="") return; // ALLOW DEFAULT
	event.preventDefault();
	dataLoad(null, $(event.currentTarget).data());
}
dataEditDelete = function(btn) {
	var rowid = $(btn).closest("tr").data("rowid");
	var ROW = qryUserEdit.DATA[rowid];
	if (!confirm("Are you sure you want to delete this record?")) return false;
	remoteCall("UserEdit.Process", {kill: 1, UE_UEID: ROW.UE_UEID}, cbRemote);
}
dataEditView = function(btn) {
	dataShowEdit("v");
	var rowid = $sheet.data("rowid");
	var ROW = dataOpts.qry.DATA[rowid];
	if ($sheet.data("edit")==rowid) {
		$sheet.data("edit","");
		return dataOpts.scatter(ROW, $sheet, 1);
	}
	$sheet.data("edit",rowid);
	var editid = $(btn).closest("tr").data("rowid");
	var ROWEDIT = $.parseJSON(qryUserEdit.DATA[editid].UE_DATA);
	ROWEDIT._ROWID = rowid; // BE SURE THAT THE ROWID MATCHES TO THE CURRENT DATA
	dataOpts.scatter(ROWEDIT, $sheet, 1);
	for (var col in ROW) {
		if (ROW[col]!=ROWEDIT[col]) {
			$sheet.find("."+col.toLowerCase()).closest("tr").addClass("modified");
		}
	}
}
dataHelper = function(key, defcap) {
	defcap = defcap || (key.match(/INFO/g) ? "Information" : key.split("_").slice(1).join(" ").toLowerCase());
	var helpers = {
		trMonth: {
			hit: function(ROW, val) {
				var d = new Date(ROW.RE_BREWED);
				return d.getFullYear()==val.year && d.getMonth()+1==val.mon;
			},
			val: function(val) {
				var parts = val.split("_");
				return {
					year: parseInt(parts[0],10),
					mon: parseInt(parts[1],10)
				}
			}
		},
		trYear: {
			hit: function(ROW, val) { var d = new Date(ROW.RE_BREWED); return d.getFullYear()==val.year },
			val: function(val) {
				return {year: parseInt(val,10).toString() };
			}
		},
		RE_NAME: { cap: "" },
		RE_STYLE: { cap: "" },
		RE_VOLUME: { cap: bihDefaults.VUNITS },
		RE_EXPGRV: { cap: bihDefaults.EUNITS },
		RE_EXPIBU: { cap: "IBU" },
		RE_EXPSRM: { cap: "SRM" },
		RE_EFF: { cap: "Efficiency" },
		GR_CAT: {
			cap: "Category"
		},
		GR_LVB: {
			hit: function(ROW, val) { return ROW.GR_LVB>=val[0] && ROW.GR_LVB<val[1]+1},
			cap: "Average SRM Between",
			val: function(val) { return treeRange(val, "5000") }
		},
		GR_SRM: {
			hit: function(ROW, val) { return Math.abs(parseFloat(ROW.GR_LVB||1)-parseFloat(val||1))<=(parseInt(val/10)+1) },
			cap: "SRM &#8776;"
		},
		HP_AAU: {
			hit: function(ROW, val) { var avg=(ROW.HP_AALOW+ROW.HP_AAHIGH)/2; return (avg>=val[0] && avg<val[1]+1) },
			cap: "Average AAU Between",
			val: function(val) { return treeRange(val, "50") }
		},
		HP_AALOW: { cap: "AAU Low"},
		HP_AAHIGH: { cap: "AAU High"},
		HP_USE: {
			hit: function(ROW, val) { return (val=="Bittering") ? ROW.HP_BITTER!=0 : (val=="Aroma") ? ROW.HP_AROMA!=0 : ROW.HP_DRY!=0 },
			cap: "Used For"
		},
		YE_AT: {
			hit: function(ROW, val) { var avg=(ROW.YE_ATLOW+ROW.YE_ATHIGH)/2; return (avg>=val[0] && avg<val[1]+1) },
			cap: "Average Attenuation Between",
			val: function(val) { return treeRange(val, "100") }
		},
		YE_ATLOW: { cap: "Attenuation Low"},
		YE_ATHIGH: { cap: "Attenuation High"},
		YE_ATTEN: { cap: "Attenuation"},
		YE_FLOC: { cap: "Floculation"},
		YE_TEMP: {
			hit: function(ROW, val) { var avg=(ROW.YE_TEMPLOW+ROW.YE_TEMPHIGH)/2; return (avg>=val[0] && avg<val[1]+1) },
			cap: "Average Temperature",
			val: function(val) { return treeRange(val, "100") }
		},
		YE_TEMPLOW: { cap: "Temperature Low"},
		YE_TEMPHIGH: { cap: "Temperature High"},
		YE_ATTEN: {
			hit: function(ROW, val) { return ROW[key]==val }
		},
		ST_OG: {
			hit: function(ROW, val) { var avg=(ROW.ST_OG_MIN+ROW.ST_OG_MAX)/2; return (avg>=val[0] && avg<val[1]+.001) },
			cap: "Average OG Between",
			val: function(val) { return treeRange(val, "1.150", 1) }
		},
		ST_FG: {
			hit: function(ROW, val) { var avg=(ROW.ST_FG_MIN+ROW.ST_FG_MAX)/2; return (avg>=val[0] && avg<val[1]+.001) },
			cap: "Average FG Between",
			val: function(val) { return treeRange(val, "1.150", 1) }
		},
		ST_SRM: {
			hit: function(ROW, val) { var avg=(ROW.ST_SRM_MIN+ROW.ST_SRM_MAX)/2; return (avg>=val[0] && avg<val[1]+1) },
			cap: "Average SRM Between",
			val: function(val) { return treeRange(val, "1000") }
		},
		ST_IBU: {
			hit: function(ROW, val) { var avg=(ROW.ST_IBU_MIN+ROW.ST_IBU_MAX)/2; return (avg>=val[0] && avg<val[1]+1) },
			cap: "Average IBU Between",
			val: function(val) { return treeRange(val, "150") }
		},
		ST_ABV: {
			hit: function(ROW, val) { var avg=(ROW.ST_ABV_MIN+ROW.ST_ABV_MAX)/2; return (avg>=val[0] && avg<val[1]+1) },
			cap: "Average ABV Between",
			val: function(val) { return treeRange(val, "15") }
		},
		ST_CO2: {
			hit: function(ROW, val) { var avg=(ROW.ST_CO2_MIN+ROW.ST_CO2_MAX)/2; return (avg>=val[0] && avg<val[1]+.1) },
			cap: "Average CO2 Between",
			val: function(val) { return treeRange(val, "4.0", 1) }
		},
		_EDIT: {
			hit: function(ROW, val, key) { return ROW[key]!=0 },
			cap: "Pending Edits",
			val: function(val) { "" }
		},
		DEFAULT: {
			hit: function(ROW, val, key) { return isNumber(val) ? ROW[key]==val : RegExp(val,"gi").test(ROW[key]) },
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
dataInit = function(table, title, pkid, filter, edits) {
	dataOpts = {
		table: table,
		title: title,
		pkid: pkid,
		qry: window["qry"+table],
		scatter: window["dataScatter"+table],
		validate: window["dataValidate"+table],
		trees: window["nodes"+table]
	}
	$content = $("#dataContent");
	$content.find(".edit,.single").hide()
	$container = $("#dataView");
	$edits = $("#dataEdits").hide();
	$editsTR = $edits.find("tr").detach();
	$sheet = $("#dataSheet").detach();
	$template = $container.find("li").detach();
	$title = $("#dataTitle");
	$nav = $("#dataNav");
	var $sideTree = $("#dataTree");
	var $tree = $sideTree.find("div").detach();
	if (dataOpts.trees) {
		for (var j = 0; j < dataOpts.trees.length; j++) {
			$tree.clone().prepend(dataOpts.trees[j].TITLE).appendTo($sideTree);
			var $div = $("<div>").attr("id", "tree"+j).appendTo($sideTree).dynatree({ title: dataOpts.trees[j].TITLE, onActivate: dataLoad, children: dataOpts.trees[j].NODES });
		}
	}
	$("#dataPEdit").find("a").on("click", dataClick).each( function() { $(this).data("_EDIT", this.title).attr("title","") });
	if (edits.length) for (var j = 0; j < dataOpts.qry.DATA.length; j++) dataOpts.qry.DATA[j]._EDIT = ($.inArray(dataOpts.qry.DATA[j][pkid], edits)!=-1); // MARKS PENDING EDITS
	$content.removeClass("hide");
	if (filter) dataLoad(null, filter);
}
dataLoad = function(node, filter) {
	$sheet.detach();
	$container.empty();
	if (filter && filter.ROWID!=undefined) {
		links.show = (filter.ROWID < dataOpts.qry.DATA.length) ? filter.ROWID : false;
	} else {
		if (node || filter) {
			dataMakeLinks(node, filter);
		} else { // REUSE EXISTING LIST
			links.show = false;
		}
	}
	if (links.cnt==0) {
		$title.html("Your glass is empty.");
		$(".single").hide();
	} else if (links.show!==false && $sheet.length) {
		$(".single").fadeIn();
		$container.empty().append(dataOpts.scatter(dataOpts.qry.DATA[links.show], $sheet, 1));
		dataShowEdit("v");
		if (document["frmEdit"]) {
			loadRowToForm(dataOpts.qry.DATA[links.show], document.frmEdit);
			// fetch edits
			if (dataOpts.qry.DATA[links.show]._EDIT) {
				remoteCall("UserEdit.Process", { fetch: dataOpts.table, pkid: dataOpts.qry.DATA[links.show][dataOpts.pkid] }, dataCallback);
			} else {
				$edits.hide().find("tbody").empty();
			}
		}
	} else {
		for (var rowid in links.list) $container.append(dataOpts.scatter(dataOpts.qry.DATA[rowid], $template.clone().attr("id", "rowid"+rowid).data("ROWID", rowid)));
		$(".single").hide();
	}
	$content.find("a").off("click").on("click", dataClick);
}
dataLoadEdits = function(btn) {
	var $tb = $edits.find("tbody").empty();
	if (!qryUserEdit.DATA.length) {
		$edits.hide();
	} else {
		$edits.fadeIn();
		for (var j = 0; j < qryUserEdit.DATA.length; j++) {
			var ROW = qryUserEdit.DATA[j];
			var $tr = $editsTR.clone().data("rowid", j);
			if (!bihLoggedIn || ROW.UE_USID!=bihUser.USID) $tr.find(".btnDel").html("&nbsp;");
			$tr.find(".ue_dla").html(ROW.UE_DLA);
			$tr.find(".ue_user").html(ROW.UE_USER);
			$tr.find(".ue_reason").html(ROW.UE_REASON.left(100));
			$tb.append($tr);
		}
	}
}
dataMakeLinks = function(node, filter) {
	var hitFirst = null, hitLast = null, isPE = false;
	var datarows = dataOpts.qry.DATA.length;
	var defcap = node ? node.tree.options.title : "";
	links = {cnt: 0, title: "", show: false, list: {} };
	if (!filter) {
		filter = new Object();
		var key = node.data.key.split("!");
		filter[key[0]]=key[1];
		if (node.parent.parent) {
			links.title = dataHelper(key[0]).cap + " : " + key[1];
			key = node.parent.data.key.split("!");
			filter[key[0]]=key[1];
			links.title = node.tree.options.title + " : " + key[1] + " / " + links.title;
		} else {
			links.title = node.tree.options.title + " : " + key[1];
		}
	} else {
		for (var key in filter) {
			if (key=="_EDIT") isPE = true;
			var cap = key==dataOpts.pkid ? dataOpts.title : dataHelper(key, defcap).cap + (!isPE && filter[key]!=="" ? " : " + filter[key] : "");
			links.title = cap + (links.title ? " / " + links.title : links.title);
			defcap = "";
		}
	}
	links.filter = filter;
	for (var j = 0; j < dataOpts.qry.DATA.length; j++) {
		if (dataMatch(filter, dataOpts.qry.DATA[j])) {
			//links.cnt++;
			if (hitFirst==null) hitFirst = j;
			links.list[j] = {}; // CURRENT NODE
			links.list[j].key = j;
			links.list[j].pos = ++links.cnt;
			if (hitLast!=null) {
				links.list[hitLast].next = j; // PREV NODE NOW POINTS TO THIS NODE
				links.list[j].prev = hitLast; // THIS NODE POINTS BACK TO PREV NODE
			}
			hitLast = j;
			if (isPE===true && dataOpts.qry.DATA[j][dataOpts.pkid]==filter._EDIT) links.show = j;
		}
	}
	if (links.cnt) {
		links.list[hitFirst].prev = hitLast;
		links.list[hitLast].next = hitFirst;
		$title.html(links.title).siblings(".rowcnt").html(filterCnt(datarows, links.cnt));
		links.title = links.title + " : " + filterCnt(datarows, links.cnt);
		if (links.cnt==1) links.show = hitFirst;
	}
	return hitFirst;
}
dataMatch = function(filter, ROW) {
	for (var key in filter) {
		var matcher = dataHelper(key);
		if (!matcher.hit(ROW, matcher.val(filter[key]), key)) return false;
	}
	return true;
}
dataSave = function() {
	var frm = document.frmEdit;
	if (!dataOpts.validate(frm)) return false;
	var ROW = new Object();
	for (var i = 0; i < dataOpts.qry.COLUMNS.length; i++) ROW[dataOpts.qry.COLUMNS[i]]="";
	ROW.UE_REASON = "";
	loadFormToRow(frm, ROW);
	remoteCall("UserEdit.Process", ROW, dataCallback);
	dataShowEdit("v");
}
dataScatterBJCPStyles = function(ROW, $row, full) {
	var href = bihPath.root+"/bjcpstyles/p.data.cfm";
	$row.find(".st_style").html(ROW.ST_STYLE).attr("href", bihPath.root+"/bjcpstyles/"+spacesPlus(ROW.ST_STYLE)+"/p.data.cfm").data("ST_STYLE", ROW.ST_STYLE);
	$row.find(".st_substyle").html(ROW.ST_SUBSTYLE).attr("href",bihPath.root+"/bjcpstyles/"+ROW.ST_STID.toString()+"/"+spacesPlus(ROW.ST_STYLE+"/"+ROW.ST_SUBSTYLE)+"/p.data.cfm").data("ROWID", ROW._ROWID);
	$row.find(".st_type").html(ROW.ST_TYPE).attr("href", bihPath.root+"/bjcpstyles/type/"+spacesPlus(ROW.ST_TYPE)+"/p.data.cfm").data("ST_TYPE", ROW.ST_TYPE);
	$row.find(".st_og_min").html(ROW.ST_OG_MIN.toFixed(3)).attr("href", href).data("ST_OG_MIN", ROW.ST_OG_MIN.toFixed(3));
	$row.find(".st_og_max").html(ROW.ST_OG_MAX.toFixed(3)).attr("href", href).data("ST_OG_MAX", ROW.ST_OG_MAX.toFixed(3));
	$row.find(".st_fg_min").html(ROW.ST_FG_MIN.toFixed(3)).attr("href", href).data("ST_FG_MIN", ROW.ST_FG_MIN.toFixed(3));
	$row.find(".st_fg_max").html(ROW.ST_FG_MAX.toFixed(3)).attr("href", href).data("ST_FG_MAX", ROW.ST_FG_MAX.toFixed(3));
	$row.find(".st_ibu_min").html(ROW.ST_IBU_MIN).attr("href", href).data("ST_IBU_MIN", ROW.ST_IBU_MIN);
	$row.find(".st_ibu_max").html(ROW.ST_IBU_MAX).attr("href", href).data("ST_IBU_MAX", ROW.ST_IBU_MAX);
	$row.find(".st_srm_min").html(ROW.ST_SRM_MIN).attr("href", href).data("ST_SRM_MIN", ROW.ST_SRM_MIN);
	$row.find(".st_srm_max").html(ROW.ST_SRM_MAX).attr("href", href).data("ST_SRM_MAX", ROW.ST_SRM_MAX);
	$row.find(".st_abv_min").html(ROW.ST_ABV_MIN).attr("href", href).data("ST_ABV_MIN", ROW.ST_ABV_MIN);
	$row.find(".st_abv_max").html(ROW.ST_ABV_MAX).attr("href", href).data("ST_ABV_MAX", ROW.ST_ABV_MAX);
	$row.find(".st_co2_min").html(ROW.ST_CO2_MIN).attr("href", href).data("ST_CO2_MIN", ROW.ST_CO2_MIN);
	$row.find(".st_co2_max").html(ROW.ST_CO2_MAX).attr("href", href).data("ST_CO2_MAX", ROW.ST_CO2_MAX);
	$row.find(".st_og").data("ST_OG", ROW.ST_OG_MIN.toFixed(3) + " - " + ROW.ST_OG_MAX.toFixed(3));
	$row.find(".st_fg").data("ST_FG", ROW.ST_FG_MIN.toFixed(3) + " - " + ROW.ST_FG_MAX.toFixed(3));
	$row.find(".st_ibu").data("ST_IBU", ROW.ST_IBU_MIN + " - " + ROW.ST_IBU_MAX);
	$row.find(".st_srm").data("ST_SRM", ROW.ST_SRM_MIN + " - " + ROW.ST_SRM_MAX);
	$row.find(".st_abv").data("ST_ABV", ROW.ST_ABV_MIN + " - " + ROW.ST_ABV_MAX);
	$row.find(".st_co2").data("ST_CO2", ROW.ST_CO2_MIN + " - " + ROW.ST_CO2_MAX);
	if (full) {
		dataSetNav(ROW._ROWID, function(ROW) { return { html: ROW.ST_SUBSTYLE, url: ROW.ST_STID.toString()+"/"+spacesPlus(ROW.ST_SUBSTYLE)}});
		$row.find(".infoStyle li").each(function() {
			var data = ROW[this.className.toUpperCase()] || "";
			var show = data.length > 0;
			var $this = $(this).toggle(show);
			$this.find("div").html(data);
		});
	}
	return $row;
}
dataScatterGrains = function(ROW, $row, full) {
	$row.find(".gr_type").html(ROW.GR_TYPE).attr("href",bihPath.root+"/grains/"+ROW.GR_GRID.toString()+"/"+spacesPlus(ROW.GR_MALTSTER+"/"+ROW.GR_TYPE)+"/p.data.cfm").data("ROWID", ROW._ROWID);
	$row.find(".gr_maltster").html(ROW.GR_MALTSTER).attr("href", bihPath.root+"/grains/maltster/"+spacesPlus(ROW.GR_MALTSTER)+"/p.data.cfm").data("GR_MALTSTER", ROW.GR_MALTSTER);
	$row.find(".gr_country").attr("href", bihPath.root+"/grains/country/"+spacesPlus(ROW.GR_COUNTRY)+"/p.data.cfm").data("GR_COUNTRY", ROW.GR_COUNTRY).find("img").attr("class", "flagLG flag"+ROW.GR_COUNTRY.spacesNone()).attr("title",ROW.GR_COUNTRY).parent().find("span").html(" " + ROW.GR_COUNTRY);
	$row.find(".gr_cat").html(ROW.GR_CAT).attr("href", bihPath.root+"/grains/category/"+spacesPlus(ROW.GR_CAT)+"/p.data.cfm").data("GR_CAT", ROW.GR_CAT);
	$row.find(".gr_info").html(ROW.GR_INFO.convCR2BR());
	$row.find(".gr_lvb").html((full ? "" : "SRM ")+ROW.GR_LVB.toFixed(1)).data("GR_SRM", ROW.GR_LVB);
	$row.find(".gr_sgc").html((full ? "" : "SGC ")+ROW.GR_SGC.toFixed(3)).data("GR_SGC", ROW.GR_SGC);
	$row.find(".gr_lintner").html((full ? "" : "DP ")+ ROW.GR_LINTNER.toString()).data("GR_LINTNER", ROW.GR_LINTNER);
	if (full) {
		dataSetNav(ROW._ROWID, function(ROW) { return { html: ROW.GR_MALTSTER + " " + ROW.GR_TYPE, url: ROW.GR_GRID.toString()+"/"+spacesPlus(ROW.GR_MALTSTER+"/"+ROW.GR_TYPE)}});
		$row.data("rowid", ROW._ROWID);
		$row.find(".gr_mash").addClass("bih-icon bih-icon-checked"+iif(ROW.GR_MASH,"1","0"));
		$row.find(".gr_cgdb").html(ROW.GR_CGDB).data("GR_CGDB", ROW.GR_CGDB);
		$row.find(".gr_fcdif").html(ROW.GR_FCDIF).data("GR_FCDIF", ROW.GR_FCDIF);
		$row.find(".gr_fgdb").html(ROW.GR_FGDB).data("GR_FGDB", ROW.GR_FGDB);
		$row.find(".gr_mc").html(ROW.GR_MC).data("GR_MC", ROW.GR_MC);
		$row.find(".gr_protein").html(ROW.GR_PROTEIN).data("GR_PROTEIN", ROW.GR_PROTEIN);
		$row.find(".gr_url").attr("href", ROW.GR_URL).html(ROW.GR_URL);
	} else {
	}
	return $row;
}
dataScatterHops = function(ROW, $row, full) {
	$row.find(".hp_hop").html(ROW.HP_HOP).attr("href",bihPath.root+"/hops/"+ROW.HP_HPID.toString()+"/"+spacesPlus(ROW.HP_GROWN+"/"+ROW.HP_HOP)+"/p.data.cfm").data("ROWID", ROW._ROWID);
	$row.find(".hp_grown").attr("href", bihPath.root+"/hops/grown/"+spacesPlus(ROW.HP_GROWN)+"/p.data.cfm").data("HP_GROWN", ROW.HP_GROWN).find("img").attr("class", "flagLG flag"+ROW.HP_GROWN.spacesNone()).attr("title",ROW.HP_GROWN).parent().find("span").html(" " + ROW.HP_GROWN);
	$row.find(".hp_aalow").html(ROW.HP_AALOW).data("HP_AALOW", ROW.HP_AALOW);
	$row.find(".hp_aahigh").html(ROW.HP_AAHIGH).data("HP_AAHIGH", ROW.HP_AAHIGH);
	$row.find(".hp_aau").data("HP_AAU", ROW.HP_AALOW + " - " + ROW.HP_AAHIGH);
	$row.find(".hp_info").html(ROW.HP_INFO.convCR2BR());
	if (full) {
		dataSetNav(ROW._ROWID, function(ROW) { return { html: ROW.HP_HOP + " " + ROW.HP_GROWN, url: ROW.HP_HPID.toString()+"/"+spacesPlus(ROW.HP_GROWN+"/"+ROW.HP_HOP)}});
		$row.data("rowid", ROW._ROWID);
		$row.find(".hp_dry").toggle(ROW.HP_DRY==1);
		$row.find(".hp_aroma").toggle(ROW.HP_AROMA==1);
		$row.find(".hp_bitter").toggle(ROW.HP_BITTER==1);
		$row.find(".hp_hsi").html(ROW.HP_HSI).data("HP_HSI", ROW.HP_HSI);
		$row.find(".hp_profile").html(ROW.HP_PROFILE);
		$row.find(".hp_use").html(ROW.HP_USE);
		$row.find(".hp_example").html(ROW.HP_EXAMPLE);
		$row.find(".hp_sub").html(ROW.HP_SUB);
		$row.find(".hp_url").attr("href", ROW.HP_URL).html(ROW.HP_URL);
	}
	return $row;
}
dataScatterMisc = function(ROW, $row, full) {
	$row.find(".mi_type").html(ROW.MI_TYPE).attr("href",bihPath.root+"/misc/"+ROW.MI_MIID.toString()+"/"+spacesPlus(ROW.MI_PHASE+"/"+ROW.MI_USE+"/"+ROW.MI_TYPE)+"/p.data.cfm").data("ROWID", ROW._ROWID);
	$row.find(".mi_use").html(ROW.MI_USE).attr("href", bihPath.root+"/misc/use/"+spacesPlus(ROW.MI_USE)+"/p.data.cfm").data("MI_USE", ROW.MI_USE);
	$row.find(".mi_phase").html(ROW.MI_PHASE).attr("href", bihPath.root+"/misc/phase/"+spacesPlus(ROW.MI_PHASE)+"/p.data.cfm").data("MI_PHASE", ROW.MI_PHASE);
	$row.find(".mi_info").html(ROW.MI_INFO.convCR2BR());
	if (full) {
		dataSetNav(ROW._ROWID, function(ROW) { return { html: ROW.MI_TYPE, url: ROW.MI_MIID.toString()+"/"+spacesPlus(ROW.MI_PHASE+"/"+ROW.MI_USE+"/"+ROW.MI_TYPE)}});
		$row.data("rowid", ROW._ROWID);
		$row.find(".mi_unit").html(ROW.MI_UNIT);
		$row.find(".mi_url").attr("href", ROW.MI_URL).html(ROW.MI_URL);
	}
	return $row;
}
dataScatterUsers = function(ROW, $row, full) {
	$row.find(".us_user").attr("href", bihPath.root+"/"+ROW.US_USER+"/p.brewer.cfm").find("span").html(ROW.US_USER);
	$row.find(".avatar").attr("src", getAvatarSrc(ROW.AVATAR,ROW.GRAVATAR));
	$row.find(".us_name").html(ROW.US_FIRST + " " + ROW.US_LAST);
	$row.find(".us_mashtype").html(ROW.US_MASHTYPE).data("US_MASHTYPE", ROW.US_MASHTYPE);
	$row.find(".us_postal").html(ROW.US_POSTAL).data("US_POSTAL", ROW.US_POSTAL);
	$row.find(".us_added").html(jsDateFormat(new Date(ROW.US_ADDED), cfDateMask));
	$row.find(".us_dla").html(jsDateFormat(new Date(ROW.US_DLA), cfDateMask));
	$row.find(".us_volume").html(ROW.US_VOLUME.toFixed(1) + " " + ROW.US_VUNITS).data("US_VOLUME", ROW.US_VOLUME);
	$row.find(".us_brewcnt").html(ROW.US_BREWCNT);
	$row.find(".us_recipecnt").html(ROW.US_RECIPECNT);
	$row.find(".us_brewamt").html(ROW.US_BREWAMT + " " + ROW.US_VUNITS);
	$row.find(".us_munits").html(ROW.US_MUNITS).data("US_MUNITS", ROW.US_MUNITS);
	$row.find(".us_hunits").html(ROW.US_HUNITS).data("US_HUNITS", ROW.US_HUNITS);
	$row.find(".us_tunits").html(ROW.US_TUNITS).data("US_TUNITS", ROW.US_TUNITS);
	$row.find(".us_eunits").html(ROW.US_EUNITS).data("US_EUNITS", ROW.US_EUNITS);
	$row.find(".us_hopform").html(ROW.US_HOPFORM).data("US_HOPFORM", ROW.US_HOPFORM);
	$row.find(".us_eff").html(ROW.US_EFF).data("US_EFF", ROW.US_EFF);
	$row.find(".us_primer").html(ROW.US_PRIMER).data("US_PRIMER", ROW.US_PRIMER);
	return $row;
}
dataScatterYeast = function(ROW, $row, full) {
	var temp = formatTemp(convertTemp("F", ROW.YE_TEMPLOW, bihDefaults.TUNITS), bihDefaults.TUNITS) + " - " + formatTemp(convertTemp("F", ROW.YE_TEMPHIGH, bihDefaults.TUNITS), bihDefaults.TUNITS);
	$row.find(".ye_yeast").html(ROW.YE_YEAST).attr("href",bihPath.root+"/yeast/"+ROW.YE_YEID.toString()+"/"+spacesPlus(ROW.YE_MFG+"/"+ROW.YE_MFGNO+"/"+ROW.YE_YEAST)+"/p.data.cfm").data("ROWID", ROW._ROWID);
	$row.find(".ye_mfg").html(ROW.YE_MFG).attr("href", bihPath.root+"/yeast/mfg/"+spacesPlus(ROW.YE_MFG)+"/p.data.cfm").data("YE_MFG", ROW.YE_MFG);
	$row.find(".ye_type").html(ROW.YE_TYPE).attr("href", bihPath.root+"/yeast/type/"+spacesPlus(ROW.YE_TYPE)+"/p.data.cfm").data("YE_TYPE", ROW.YE_TYPE);
	$row.find(".ye_form").html(ROW.YE_FORM).attr("href", bihPath.root+"/yeast/form/"+spacesPlus(ROW.YE_FORM)+"/p.data.cfm").data("YE_FORM", ROW.YE_FORM);
	$row.find(".ye_mfgno").html(ROW.YE_MFGNO);
	$row.find(".ye_atlow").html(ROW.YE_ATLOW).data("YE_ATLOW", ROW.YE_ATLOW);
	$row.find(".ye_athigh").html(ROW.YE_ATHIGH).data("YE_ATHIGH", ROW.YE_ATHIGH);
	$row.find(".ye_at").data("HP_AAU", ROW.YE_ATLOW + " - " + ROW.YE_ATHIGH);
	var tempL = formatTemp(convertTemp("F", ROW.YE_TEMPLOW, bihDefaults.TUNITS), bihDefaults.TUNITS);
	var tempH = formatTemp(convertTemp("F", ROW.YE_TEMPHIGH, bihDefaults.TUNITS), bihDefaults.TUNITS);
	$row.find(".ye_templow").html(tempL).data("YE_TEMPLOW", ROW.YE_TEMPLOW);
	$row.find(".ye_temphigh").html(tempH).data("YE_TEMPHIGH", ROW.YE_TEMPHIGH);
	$row.find(".ye_temp").data("YE_TEMP", tempL + " - " + tempH);
	$row.find(".ye_info").html(ROW.YE_INFO.convCR2BR());
	if (full) {
		dataSetNav(ROW._ROWID, function(ROW) { return { html: ROW.YE_YEAST + " " + ROW.YE_MFG, url: ROW.YE_YEID.toString()+"/"+spacesPlus(ROW.YE_MFG+"/"+ROW.YE_YEAST)}});
		$row.data("rowid", ROW._ROWID);
		$row.find(".ye_atten").html(ROW.YE_ATTEN).data("YE_ATTEN", ROW.YE_ATTEN);
		$row.find(".ye_floc").html(ROW.YE_FLOC).data("YE_FLOC", ROW.YE_FLOC);
		$row.find(".ye_tolerance").html(ROW.YE_TOLERANCE).data("YE_FLOC", ROW.YE_FLOC);
		$row.find(".ye_url").attr("href", ROW.YE_URL).html(ROW.YE_URL);
	}
	return $row;
}
dataSearch = function() {
	var frm = document.frmDataSrc;
	if (isEmpty(frm.dataSrcVal)) return showStatusWindow("Search value is required.");
	var obj = new Object();
	obj[selectedValue(frm.dataSrcFld)] = trim(frm.dataSrcVal);
	dataLoad(null, obj);
	return false;
}
dataSetNav = function(currow, fxFormat) {
	if (links.cnt) { // IF WE HAVE A LINK LIST, USE IT TO NAVIGATE
		$nav.find(".cnt").html(links.list[currow].pos + " of " + links.cnt).attr("title",links.title);
		var rtn = fxFormat(dataOpts.qry.DATA[links.list[currow].prev]);
		$nav.find(".prev").show().attr("href", bihPath.root+"/"+dataOpts.table+"/"+rtn.url+"/p.data.cfm").data("ROWID", links.list[currow].prev).find("span").html(rtn.html);
		rtn = fxFormat(dataOpts.qry.DATA[links.list[currow].next]);
		$nav.find(".next").show().attr("href", bihPath.root+"/"+dataOpts.table+"/"+rtn.url+"/p.data.cfm").data("ROWID", links.list[currow].next).find("span").html(rtn.html);
		return;
	}
	$nav.find(".cnt").html(currow + " of " + dataOpts.qry.DATA.length);
	var pos = (currow > 0) ? currow-1 : dataOpts.qry.DATA.length-1;
	var rtn = fxFormat(dataOpts.qry.DATA[pos]);
	$nav.find(".prev").show().attr("href", bihPath.root+"/"+dataOpts.table+"/"+rtn.url+"/p.data.cfm").data("ROWID", dataOpts.qry.DATA[pos]._ROWID).find("span").html(rtn.html);
	pos = currow+1<dataOpts.qry.DATA.length ? currow+1 : 0;
	var rtn = fxFormat(dataOpts.qry.DATA[pos]);
	$nav.find(".next").show().attr("href", bihPath.root+"/"+dataOpts.table+"/"+rtn.url+"/p.data.cfm").data("ROWID", dataOpts.qry.DATA[pos]._ROWID).find("span").html(rtn.html);
}
dataShowEdit = function(mode) {
	if (mode=="v" || $content.data("mode")=="e") {
		$content.data("mode", "v");
		$content.find(".edit").hide();
		$content.find(".disp").show();
		$content.find(".modified").removeClass("modified");
	} else {
		$content.data("mode", "e");
		$content.find(".disp").hide();
		$content.find(".edit").fadeIn(800);
	}
	return false;
}
// ****** TABLE SPECIFIC
dataScatterBJCPStyles = function(ROW, $row, full) {
	var href = bihPath.root+"/bjcpstyles/p.data.cfm";
	$row.find(".st_style").html(ROW.ST_STYLE).attr("href", bihPath.root+"/bjcpstyles/"+spacesPlus(ROW.ST_STYLE)+"/p.data.cfm").data("ST_STYLE", ROW.ST_STYLE);
	$row.find(".st_substyle").html(ROW.ST_SUBSTYLE).attr("href",bihPath.root+"/bjcpstyles/"+ROW.ST_STID.toString()+"/"+spacesPlus(ROW.ST_STYLE+"/"+ROW.ST_SUBSTYLE)+"/p.data.cfm").data("ROWID", ROW._ROWID);
	$row.find(".st_type").html(ROW.ST_TYPE).attr("href", bihPath.root+"/bjcpstyles/type/"+spacesPlus(ROW.ST_TYPE)+"/p.data.cfm").data("ST_TYPE", ROW.ST_TYPE);
	$row.find(".st_og_min").html(ROW.ST_OG_MIN.toFixed(3)).attr("href", href).data("ST_OG_MIN", ROW.ST_OG_MIN.toFixed(3));
	$row.find(".st_og_max").html(ROW.ST_OG_MAX.toFixed(3)).attr("href", href).data("ST_OG_MAX", ROW.ST_OG_MAX.toFixed(3));
	$row.find(".st_fg_min").html(ROW.ST_FG_MIN.toFixed(3)).attr("href", href).data("ST_FG_MIN", ROW.ST_FG_MIN.toFixed(3));
	$row.find(".st_fg_max").html(ROW.ST_FG_MAX.toFixed(3)).attr("href", href).data("ST_FG_MAX", ROW.ST_FG_MAX.toFixed(3));
	$row.find(".st_ibu_min").html(ROW.ST_IBU_MIN).attr("href", href).data("ST_IBU_MIN", ROW.ST_IBU_MIN);
	$row.find(".st_ibu_max").html(ROW.ST_IBU_MAX).attr("href", href).data("ST_IBU_MAX", ROW.ST_IBU_MAX);
	$row.find(".st_srm_min").html(ROW.ST_SRM_MIN).attr("href", href).data("ST_SRM_MIN", ROW.ST_SRM_MIN);
	$row.find(".st_srm_max").html(ROW.ST_SRM_MAX).attr("href", href).data("ST_SRM_MAX", ROW.ST_SRM_MAX);
	$row.find(".st_abv_min").html(ROW.ST_ABV_MIN).attr("href", href).data("ST_ABV_MIN", ROW.ST_ABV_MIN);
	$row.find(".st_abv_max").html(ROW.ST_ABV_MAX).attr("href", href).data("ST_ABV_MAX", ROW.ST_ABV_MAX);
	$row.find(".st_co2_min").html(ROW.ST_CO2_MIN).attr("href", href).data("ST_CO2_MIN", ROW.ST_CO2_MIN);
	$row.find(".st_co2_max").html(ROW.ST_CO2_MAX).attr("href", href).data("ST_CO2_MAX", ROW.ST_CO2_MAX);
	$row.find(".st_og").data("ST_OG", ROW.ST_OG_MIN.toFixed(3) + " - " + ROW.ST_OG_MAX.toFixed(3));
	$row.find(".st_fg").data("ST_FG", ROW.ST_FG_MIN.toFixed(3) + " - " + ROW.ST_FG_MAX.toFixed(3));
	$row.find(".st_ibu").data("ST_IBU", ROW.ST_IBU_MIN + " - " + ROW.ST_IBU_MAX);
	$row.find(".st_srm").data("ST_SRM", ROW.ST_SRM_MIN + " - " + ROW.ST_SRM_MAX);
	$row.find(".st_abv").data("ST_ABV", ROW.ST_ABV_MIN + " - " + ROW.ST_ABV_MAX);
	$row.find(".st_co2").data("ST_CO2", ROW.ST_CO2_MIN + " - " + ROW.ST_CO2_MAX);
	if (full) {
		dataSetNav(ROW._ROWID, function(ROW) { return { html: ROW.ST_SUBSTYLE, url: ROW.ST_STID.toString()+"/"+spacesPlus(ROW.ST_SUBSTYLE)}});
		$row.find(".infoStyle li").each(function() {
			var data = ROW[this.className.toUpperCase()] || "";
			var show = data.length > 0;
			var $this = $(this).toggle(show);
			$this.find("div").html(data);
		});
	}
	return $row;
}
dataScatterGrains = function(ROW, $row, full) {
	$row.find(".gr_type").html(ROW.GR_TYPE).attr("href",bihPath.root+"/grains/"+ROW.GR_GRID.toString()+"/"+spacesPlus(ROW.GR_MALTSTER+"/"+ROW.GR_TYPE)+"/p.data.cfm").data("ROWID", ROW._ROWID);
	$row.find(".gr_maltster").html(ROW.GR_MALTSTER).attr("href", bihPath.root+"/grains/maltster/"+spacesPlus(ROW.GR_MALTSTER)+"/p.data.cfm").data("GR_MALTSTER", ROW.GR_MALTSTER);
	$row.find(".gr_country").attr("href", bihPath.root+"/grains/country/"+spacesPlus(ROW.GR_COUNTRY)+"/p.data.cfm").data("GR_COUNTRY", ROW.GR_COUNTRY).find("img").attr("class", "flagLG flag"+ROW.GR_COUNTRY.spacesNone()).attr("title",ROW.GR_COUNTRY).parent().find("span").html(" " + ROW.GR_COUNTRY);
	$row.find(".gr_cat").html(ROW.GR_CAT).attr("href", bihPath.root+"/grains/category/"+spacesPlus(ROW.GR_CAT)+"/p.data.cfm").data("GR_CAT", ROW.GR_CAT);
	$row.find(".gr_info").html(ROW.GR_INFO.convCR2BR());
	$row.find(".gr_lvb").html((full ? "" : "SRM ")+ROW.GR_LVB.toFixed(1)).data("GR_SRM", ROW.GR_LVB);
	$row.find(".gr_sgc").html((full ? "" : "SGC ")+ROW.GR_SGC.toFixed(3)).data("GR_SGC", ROW.GR_SGC);
	$row.find(".gr_lintner").html((full ? "" : "DP ")+ ROW.GR_LINTNER.toString()).data("GR_LINTNER", ROW.GR_LINTNER);
	if (full) {
		dataSetNav(ROW._ROWID, function(ROW) { return { html: ROW.GR_MALTSTER + " " + ROW.GR_TYPE, url: ROW.GR_GRID.toString()+"/"+spacesPlus(ROW.GR_MALTSTER+"/"+ROW.GR_TYPE)}});
		$row.data("rowid", ROW._ROWID);
		$row.find(".gr_mash").addClass("bih-icon bih-icon-checked"+iif(ROW.GR_MASH,"1","0"));
		$row.find(".gr_cgdb").html(ROW.GR_CGDB).data("GR_CGDB", ROW.GR_CGDB);
		$row.find(".gr_fcdif").html(ROW.GR_FCDIF).data("GR_FCDIF", ROW.GR_FCDIF);
		$row.find(".gr_fgdb").html(ROW.GR_FGDB).data("GR_FGDB", ROW.GR_FGDB);
		$row.find(".gr_mc").html(ROW.GR_MC).data("GR_MC", ROW.GR_MC);
		$row.find(".gr_protein").html(ROW.GR_PROTEIN).data("GR_PROTEIN", ROW.GR_PROTEIN);
		$row.find(".gr_url").attr("href", ROW.GR_URL).html(ROW.GR_URL);
	} else {
	}
	return $row;
}
dataScatterHops = function(ROW, $row, full) {
	$row.find(".hp_hop").html(ROW.HP_HOP).attr("href",bihPath.root+"/hops/"+ROW.HP_HPID.toString()+"/"+spacesPlus(ROW.HP_GROWN+"/"+ROW.HP_HOP)+"/p.data.cfm").data("ROWID", ROW._ROWID);
	$row.find(".hp_grown").attr("href", bihPath.root+"/hops/grown/"+spacesPlus(ROW.HP_GROWN)+"/p.data.cfm").data("HP_GROWN", ROW.HP_GROWN).find("img").attr("class", "flagLG flag"+ROW.HP_GROWN.spacesNone()).attr("title",ROW.HP_GROWN).parent().find("span").html(" " + ROW.HP_GROWN);
	$row.find(".hp_aalow").html(ROW.HP_AALOW).data("HP_AALOW", ROW.HP_AALOW);
	$row.find(".hp_aahigh").html(ROW.HP_AAHIGH).data("HP_AAHIGH", ROW.HP_AAHIGH);
	$row.find(".hp_aau").data("HP_AAU", ROW.HP_AALOW + " - " + ROW.HP_AAHIGH);
	$row.find(".hp_info").html(ROW.HP_INFO.convCR2BR());
	if (full) {
		dataSetNav(ROW._ROWID, function(ROW) { return { html: ROW.HP_HOP + " " + ROW.HP_GROWN, url: ROW.HP_HPID.toString()+"/"+spacesPlus(ROW.HP_GROWN+"/"+ROW.HP_HOP)}});
		$row.data("rowid", ROW._ROWID);
		$row.find(".hp_dry").toggle(ROW.HP_DRY==1);
		$row.find(".hp_aroma").toggle(ROW.HP_AROMA==1);
		$row.find(".hp_bitter").toggle(ROW.HP_BITTER==1);
		$row.find(".hp_hsi").html(ROW.HP_HSI).data("HP_HSI", ROW.HP_HSI);
		$row.find(".hp_profile").html(ROW.HP_PROFILE);
		$row.find(".hp_use").html(ROW.HP_USE);
		$row.find(".hp_example").html(ROW.HP_EXAMPLE);
		$row.find(".hp_sub").html(ROW.HP_SUB);
		$row.find(".hp_url").attr("href", ROW.HP_URL).html(ROW.HP_URL);
	}
	return $row;
}
dataScatterMisc = function(ROW, $row, full) {
	$row.find(".mi_type").html(ROW.MI_TYPE).attr("href",bihPath.root+"/misc/"+ROW.MI_MIID.toString()+"/"+spacesPlus(ROW.MI_PHASE+"/"+ROW.MI_USE+"/"+ROW.MI_TYPE)+"/p.data.cfm").data("ROWID", ROW._ROWID);
	$row.find(".mi_use").html(ROW.MI_USE).attr("href", bihPath.root+"/misc/use/"+spacesPlus(ROW.MI_USE)+"/p.data.cfm").data("MI_USE", ROW.MI_USE);
	$row.find(".mi_phase").html(ROW.MI_PHASE).attr("href", bihPath.root+"/misc/phase/"+spacesPlus(ROW.MI_PHASE)+"/p.data.cfm").data("MI_PHASE", ROW.MI_PHASE);
	$row.find(".mi_info").html(ROW.MI_INFO.convCR2BR());
	if (full) {
		dataSetNav(ROW._ROWID, function(ROW) { return { html: ROW.MI_TYPE, url: ROW.MI_MIID.toString()+"/"+spacesPlus(ROW.MI_PHASE+"/"+ROW.MI_USE+"/"+ROW.MI_TYPE)}});
		$row.data("rowid", ROW._ROWID);
		$row.find(".mi_unit").html(ROW.MI_UNIT);
		$row.find(".mi_url").attr("href", ROW.MI_URL).html(ROW.MI_URL);
	}
	return $row;
}
dataScatterUsers = function(ROW, $row, full) {
	$row.find(".us_user").attr("href", bihPath.root+"/"+ROW.US_USER+"/p.brewer.cfm").find("span").html(ROW.US_USER);
	$row.find(".avatar").attr("src", getAvatarSrc(ROW.AVATAR,ROW.GRAVATAR));
	$row.find(".us_name").html(ROW.US_FIRST + " " + ROW.US_LAST);
	$row.find(".us_mashtype").html(ROW.US_MASHTYPE).data("US_MASHTYPE", ROW.US_MASHTYPE);
	$row.find(".us_postal").html(ROW.US_POSTAL).data("US_POSTAL", ROW.US_POSTAL);
	$row.find(".us_added").html(jsDateFormat(new Date(ROW.US_ADDED), cfDateMask));
	$row.find(".us_dla").html(jsDateFormat(new Date(ROW.US_DLA), cfDateMask));
	$row.find(".us_volume").html(ROW.US_VOLUME.toFixed(1) + " " + ROW.US_VUNITS).data("US_VOLUME", ROW.US_VOLUME);
	$row.find(".us_brewcnt").html(ROW.US_BREWCNT);
	$row.find(".us_recipecnt").html(ROW.US_RECIPECNT);
	$row.find(".us_brewamt").html(ROW.US_BREWAMT + " " + ROW.US_VUNITS);
	$row.find(".us_munits").html(ROW.US_MUNITS).data("US_MUNITS", ROW.US_MUNITS);
	$row.find(".us_hunits").html(ROW.US_HUNITS).data("US_HUNITS", ROW.US_HUNITS);
	$row.find(".us_tunits").html(ROW.US_TUNITS).data("US_TUNITS", ROW.US_TUNITS);
	$row.find(".us_eunits").html(ROW.US_EUNITS).data("US_EUNITS", ROW.US_EUNITS);
	$row.find(".us_hopform").html(ROW.US_HOPFORM).data("US_HOPFORM", ROW.US_HOPFORM);
	$row.find(".us_eff").html(ROW.US_EFF).data("US_EFF", ROW.US_EFF);
	$row.find(".us_primer").html(ROW.US_PRIMER).data("US_PRIMER", ROW.US_PRIMER);
	return $row;
}
dataScatterYeast = function(ROW, $row, full) {
	var temp = formatTemp(convertTemp("F", ROW.YE_TEMPLOW, bihDefaults.TUNITS), bihDefaults.TUNITS) + " - " + formatTemp(convertTemp("F", ROW.YE_TEMPHIGH, bihDefaults.TUNITS), bihDefaults.TUNITS);
	$row.find(".ye_yeast").html(ROW.YE_YEAST).attr("href",bihPath.root+"/yeast/"+ROW.YE_YEID.toString()+"/"+spacesPlus(ROW.YE_MFG+"/"+ROW.YE_MFGNO+"/"+ROW.YE_YEAST)+"/p.data.cfm").data("ROWID", ROW._ROWID);
	$row.find(".ye_mfg").html(ROW.YE_MFG).attr("href", bihPath.root+"/yeast/mfg/"+spacesPlus(ROW.YE_MFG)+"/p.data.cfm").data("YE_MFG", ROW.YE_MFG);
	$row.find(".ye_type").html(ROW.YE_TYPE).attr("href", bihPath.root+"/yeast/type/"+spacesPlus(ROW.YE_TYPE)+"/p.data.cfm").data("YE_TYPE", ROW.YE_TYPE);
	$row.find(".ye_form").html(ROW.YE_FORM).attr("href", bihPath.root+"/yeast/form/"+spacesPlus(ROW.YE_FORM)+"/p.data.cfm").data("YE_FORM", ROW.YE_FORM);
	$row.find(".ye_mfgno").html(ROW.YE_MFGNO);
	$row.find(".ye_atlow").html(ROW.YE_ATLOW).data("YE_ATLOW", ROW.YE_ATLOW);
	$row.find(".ye_athigh").html(ROW.YE_ATHIGH).data("YE_ATHIGH", ROW.YE_ATHIGH);
	$row.find(".ye_at").data("HP_AAU", ROW.YE_ATLOW + " - " + ROW.YE_ATHIGH);
	var tempL = formatTemp(convertTemp("F", ROW.YE_TEMPLOW, bihDefaults.TUNITS), bihDefaults.TUNITS);
	var tempH = formatTemp(convertTemp("F", ROW.YE_TEMPHIGH, bihDefaults.TUNITS), bihDefaults.TUNITS);
	$row.find(".ye_templow").html(tempL).data("YE_TEMPLOW", ROW.YE_TEMPLOW);
	$row.find(".ye_temphigh").html(tempH).data("YE_TEMPHIGH", ROW.YE_TEMPHIGH);
	$row.find(".ye_temp").data("YE_TEMP", tempL + " - " + tempH);
	$row.find(".ye_info").html(ROW.YE_INFO.convCR2BR());
	if (full) {
		dataSetNav(ROW._ROWID, function(ROW) { return { html: ROW.YE_YEAST + " " + ROW.YE_MFG, url: ROW.YE_YEID.toString()+"/"+spacesPlus(ROW.YE_MFG+"/"+ROW.YE_YEAST)}});
		$row.data("rowid", ROW._ROWID);
		$row.find(".ye_atten").html(ROW.YE_ATTEN).data("YE_ATTEN", ROW.YE_ATTEN);
		$row.find(".ye_floc").html(ROW.YE_FLOC).data("YE_FLOC", ROW.YE_FLOC);
		$row.find(".ye_tolerance").html(ROW.YE_TOLERANCE).data("YE_FLOC", ROW.YE_FLOC);
		$row.find(".ye_url").attr("href", ROW.YE_URL).html(ROW.YE_URL);
	}
	return $row;
}
dataValidateGrains = function(frm) {
	if (isEmpty(frm.gr_type, "Malt/Fermentable is required.")) return false;
	if (isEmpty(frm.gr_maltster, "Maltster is required.")) return false;
	if (isEmpty(frm.gr_country, "Country is required.")) return false;
	if (isEmpty(frm.gr_cat, "Category is required.")) return false;
	if (isEmpty(frm.gr_sgc, "Extract Potential (SGC) is required.")) return false;
	if (isEmpty(frm.gr_lvb, "Color (SRM) is required.")) return false;
	if (!frm.gr_lvb.onblur()) return false;
	if (!frm.gr_sgc.onblur()) return false;
	if (!frm.gr_lintner.onblur()) return false;
	if (!frm.gr_mc.onblur()) return false;
	if (!frm.gr_fgdb.onblur()) return false;
	if (!frm.gr_cgdb.onblur()) return false;
	if (!frm.gr_fcdif.onblur()) return false;
	if (!frm.gr_protein.onblur()) return false;
	return true;
}
dataValidateHops = function(frm) {
	if (isEmpty(frm.hp_hop, "Hop is required.")) return false;
	if (isEmpty(frm.hp_grown, "Grown is required.")) return false;
	if (isEmpty(frm.hp_aalow, "AAU Low is required.")) return false;
	if (!frm.hp_aalow.onblur()) return false;
	if (isEmpty(frm.hp_aahigh, "AAU High is required.")) return false;
	if (!frm.hp_aahigh.onblur()) return false;
	if (!frm.hp_hsi.onblur()) return false;
	return true;
}
dataValidateMisc = function(frm) {
	if (isEmpty(mi_type, "Type is required.")) return false;
	if (isEmpty(mi_use, "Use is required.")) return false;
	return true;
}
dataValidateYeast = function(frm) {
	if (isEmpty(frm.ye_yeast, "Yeast is required.")) return false;
	if (isEmpty(frm.ye_mfg, "Manufacturer is required.")) return false;
	if (isEmpty(frm.ye_mfgno, "Manufacturer number is required.")) return false;
	if (isEmpty(frm.ye_type, "Yeast Type is required.")) return false;
	if (isEmpty(frm.ye_form, "Yeast Form is required.")) return false;
	if (!frm.ye_atlow.onblur()) return false;
	if (!frm.ye_athigh.onblur()) return false;
	if (!frm.ye_templow.onblur()) return false;
	if (!frm.ye_temphigh.onblur()) return false;
	return true;
}

