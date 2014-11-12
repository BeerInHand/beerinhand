userexpClickRow = function() {
	var rowid = $(this).data("rowid") || 0;
	var $tab = $("#infoUsers");
	userexpScatter(qryUsers.DATA[rowid], $tab);
}
userexpPick = function(btn) {
	var $tr = $(btn).closest("tr");
	var rowid = $tr.data("rowid");
	var ROW = qryUsers.DATA[rowid];
	window.location = bihPath.root + "/" + ROW.US_USER + "/p.brewer.cfm";
}
userexpInit = function() {
	var $tabUsers = $("#tabUsers");
	queryMakeHashable(qryUsers);
	var $tbUsers = $tabUsers.find("tbody");
	var $trUsers = $tbUsers.find("tr");
	for (var j = 0; j < qryUsers.DATA.length; j++) {
		var ROW = qryUsers.DATA[j];
		var $trAdd = $trUsers.clone();
		userexpScatter(ROW, $trAdd);
		$trAdd.attr("id", "us_rowid"+ROW._ROWID);
		$trAdd.data("rowid", j);
		$tbUsers.append($trAdd);
	}
	$trUsers.remove();
	$tabUsers.parent().removeClass("hide");
	$tabUsers.tablescroller({id: "Users", height: 330, sort: true, print: false, borderWidth: 1, borderColor: "#979F97"});
	$tbUsers.find("tr").click(userexpClickRow);
	$tbUsers.find("tr:first").click();
}
userexpScatter = function(ROW, $Obj) {
	$Obj.find(".us_name").html(ROW.US_LAST + " " + ROW.US_FIRST);
	$Obj.find(".us_mashtype").html(ROW.US_MASHTYPE);
	$Obj.find(".us_postal").html(ROW.US_POSTAL);
	$Obj.find(".us_added").html(jsDateFormat(new Date(ROW.US_ADDED), cfDateMask));
	$Obj.find(".us_dla").html(jsDateFormat(new Date(ROW.US_DLA), cfDateMask));
	$Obj.find(".us_volume").html(ROW.US_VOLUME.toFixed(1));
	$Obj.find(".us_vunits").html(ROW.US_VUNITS);
	$Obj.find(".us_brewcnt").html(ROW.US_BREWCNT);
	$Obj.find(".us_recipecnt").html(ROW.US_RECIPECNT);
	if ($Obj.attr("id")!="infoUsers") {
		$Obj.find(".us_user").html(ROW.US_USER);
		$Obj.find(".us_brewamt").html(ROW.US_BREWAMT.toFixed(0));
		$Obj.find(".us_volume").html(ROW.US_VOLUME.toFixed(1));
		$Obj.find(".us_vunits").html(ROW.US_VUNITS);
	} else {
		$Obj.find(".us_user").html(ROW.US_USER).attr("href", bihPath.root+"/"+ROW.US_USER+"/p.brewer.cfm");
		$Obj.find(".avatar").attr("src", getAvatarSrc(ROW.AVATAR,ROW.GRAVATAR));
		$Obj.find(".us_volume").html(ROW.US_VOLUME.toFixed(1) + " " + ROW.US_VUNITS);
		$Obj.find(".us_brewamt").html(ROW.US_BREWAMT.toFixed(2) + " " + ROW.US_VUNITS);
		$Obj.find(".us_munits").html(ROW.US_MUNITS);
		$Obj.find(".us_hunits").html(ROW.US_HUNITS);
		$Obj.find(".us_tunits").html(ROW.US_TUNITS);
		$Obj.find(".us_eunits").html(ROW.US_EUNITS);
		$Obj.find(".us_hopform").html(ROW.US_HOPFORM);
		$Obj.find(".us_eff").html(ROW.US_EFF);
		$Obj.find(".us_primer").html(ROW.US_PRIMER);
		rowHighlight($Obj, "us_rowid", ROW._ROWID);
	}
}