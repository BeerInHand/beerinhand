stylesClickRow = function() {
	var rowid = $(this).data("rowid") || 0;
	var $tab = $("#infoBJCPStyles");
	stylesScatter(qryBJCPStyles.DATA[rowid], $tab);
}
stylesInit = function() {
	queryMakeHashable(qryBJCPStyles);
	var $tabBJCPStyles = $("#tabBJCPStyles");
	var $tbBJCPStyles = $tabBJCPStyles.find("tbody");
	var $trBJCPStyles = $tbBJCPStyles.find("tr");
	for (var j = 0; j < qryBJCPStyles.DATA.length; j++) {
		var $trAdd = $trBJCPStyles.clone();
		var ROW = qryBJCPStyles.DATA[j];
		stylesScatter(ROW, $trAdd);
		$trAdd.attr("id", "st_rowid"+ROW._ROWID);
		$trAdd.data("rowid", ROW._ROWID);
		$tbBJCPStyles.append($trAdd);
	}
	$trBJCPStyles.remove();
	$tabBJCPStyles.parent().removeClass("hide");
	var divw = $("#divtabsToolsStyles").width() || 500;
	$tabBJCPStyles.tablescroller({id: "BJCPStyles", height: 327, sort: true, print: false, borderWidth: 1, borderColor: "#979F97"});
	$tbBJCPStyles.find("tr").click(stylesClickRow);
	var $divStylesTabs = $("#divStylesTabs").tabs({ selected: 0 });
	stylesClickRow();
}
stylesScatter = function(ROW, $Obj) {
	if ($Obj.attr("id")=="infoBJCPStyles") {
		$Obj.find(".st_subcategory").html(right("0" + ROW.ST_SUBCATEGORY, 3) + " " + ROW.ST_STYLE);
		$Obj.find(".st_substyle").html(ROW.ST_SUBSTYLE);
		$Obj.find(".st_type").html(ROW.ST_TYPE);
		$Obj.find(".st_og").html(ROW.ST_OG_MIN.toFixed(3) + " - " + ROW.ST_OG_MAX.toFixed(3));
		$Obj.find(".st_fg").html(ROW.ST_FG_MIN.toFixed(3) + " - " + ROW.ST_FG_MAX.toFixed(3));
		$Obj.find(".st_ibu").html(ROW.ST_IBU_MIN + " - " + ROW.ST_IBU_MAX);
		$Obj.find(".st_srm").html(ROW.ST_SRM_MIN + " - " + ROW.ST_SRM_MAX);
		$Obj.find(".st_abv").html(ROW.ST_ABV_MIN + " - " + ROW.ST_ABV_MAX);
		$Obj.find(".st_co2").html(ROW.ST_CO2_MIN + " - " + ROW.ST_CO2_MAX);
		$Obj.find(".st_aroma").html(ROW.ST_AROMA);
		$Obj.find(".st_appearance").html(ROW.ST_APPEARANCE);
		$Obj.find(".st_flavor").html(ROW.ST_FLAVOR);
		$Obj.find(".st_mouthfeel").html(ROW.ST_MOUTHFEEL);
		$Obj.find(".st_impression").html(ROW.ST_IMPRESSION);
		$Obj.find(".st_comments").html(ROW.ST_COMMENTS);
		$Obj.find(".st_history").html(ROW.ST_HISTORY);
		$Obj.find(".st_ingredients").html(ROW.ST_INGREDIENTS);
		$Obj.find(".st_varieties").html(ROW.ST_VARIETIES);
		$Obj.find(".st_exceptions").html(ROW.ST_EXCEPTIONS);
		$Obj.find(".st_examples").html(ROW.ST_EXAMPLES);
		var $divStylesTabs = $("#divStylesTabs");
		stylesTabsDisplay(ROW.ST_AROMA, $divStylesTabs, "#tabsStylesAroma");
		stylesTabsDisplay(ROW.ST_APPEARANCE, $divStylesTabs, "#tabsStylesAppearance");
		stylesTabsDisplay(ROW.ST_FLAVOR, $divStylesTabs, "#tabsStylesFlavor");
		stylesTabsDisplay(ROW.ST_MOUTHFEEL, $divStylesTabs, "#tabsStylesMouthfeel");
		stylesTabsDisplay(ROW.ST_IMPRESSION, $divStylesTabs, "#tabsStylesImpression");
		stylesTabsDisplay(ROW.ST_COMMENTS, $divStylesTabs, "#tabsStylesComments");
		stylesTabsDisplay(ROW.ST_HISTORY, $divStylesTabs, "#tabsStylesHistory");
		stylesTabsDisplay(ROW.ST_INGREDIENTS, $divStylesTabs, "#tabsStylesIngredients");
		stylesTabsDisplay(ROW.ST_VARIETIES, $divStylesTabs, "#tabsStylesVarieties");
		stylesTabsDisplay(ROW.ST_EXCEPTIONS, $divStylesTabs, "#tabsStylesExceptions");
		stylesTabsDisplay(ROW.ST_EXAMPLES, $divStylesTabs, "#tabsStylesExamples");
		rowHighlight($Obj, "st_rowid", ROW._ROWID);
	} else {
		$Obj.find(".st_subcategory").html(right("0" + ROW.ST_SUBCATEGORY, 3));
		$Obj.find(".st_substyle").html(ROW.ST_SUBSTYLE);
		$Obj.find(".st_type").html(ROW.ST_TYPE);
		$Obj.find(".st_og_min").html(ROW.ST_OG_MIN.toFixed(3));
		$Obj.find(".st_og_max").html(ROW.ST_OG_MAX.toFixed(3));
		$Obj.find(".st_fg_min").html(ROW.ST_FG_MIN.toFixed(3));
		$Obj.find(".st_fg_max").html(ROW.ST_FG_MAX.toFixed(3));
		$Obj.find(".st_ibu_min").html(ROW.ST_IBU_MIN);
		$Obj.find(".st_ibu_max").html(ROW.ST_IBU_MAX);
		$Obj.find(".st_srm_min").html(ROW.ST_SRM_MIN);
		$Obj.find(".st_srm_max").html(ROW.ST_SRM_MAX);
		$Obj.find(".st_abv_min").html(ROW.ST_ABV_MIN.toFixed(1));
		$Obj.find(".st_abv_max").html(ROW.ST_ABV_MAX.toFixed(1));
	}
}
stylesScrollTo = function() {
	var $tr = $("#tabScrollBodyBJCPStyles").find("tbody").find("#st_rowid"+selectedRow.rowid);
	var $div = $("#divScrollBodyBJCPStyles");
	$div.scrollTo($tr, 800);
}
stylesTabsDisplay = function(val, $div, tab) {
	var $tab = $div.find(tab);
	var isHid = $tab.hasClass("tabHide");
	if (isEmpty(val)) {
		if (!isHid) $div.find("#"+tab).removeClass("tabShow").addClass("tabHide");
	} else {
		if (isHid) $div.find("#"+tab).removeClass("tabHide").addClass("tabShow");
	}
}