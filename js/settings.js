optsAvatar = function(which) {
	if (which=="g") {
		$("#imgAvatar").attr("src", bihPath.img+"/trans.gif");
		$("#imgGravatar").attr("src", src_gravatar);
		$btnAvatar.addClass("ui-state-disabled");
		$btnAvatar.find(".ui-button-icon-primary").removeClass("bih-icon-checked1").addClass("bih-icon-checked0");
		$btnGravatar.removeClass("ui-state-disabled");
		$btnGravatar.find(".ui-button-icon-primary").removeClass("bih-icon-checked0").addClass("bih-icon-checked1");
	} else {
		$("#imgAvatar").attr("src", "usercontent/avatars/"+src_avatar);
		$("#imgGravatar").attr("src",  bihPath.img+"/trans.gif");
		$btnAvatar.removeClass("ui-state-disabled");
		$btnAvatar.find(".ui-button-icon-primary").removeClass("bih-icon-checked0").addClass("bih-icon-checked1");
		$btnGravatar.addClass("ui-state-disabled");
		$btnGravatar.find(".ui-button-icon-primary").removeClass("bih-icon-checked1").addClass("bih-icon-checked0");
	}
}
optsCallBack = function(response) {
	if (!response.SUCCESS) {
		cbErrors(response);
	} else {
		if (response.DATA.METHOD=="Avatar") {
			if (response.DATA.ERRORS) {
				return showStatusWindow(response.DATA.ERRORS, 500, true);
			}
			src_avatar = response.DATA.AVATAR;
			optsAvatar("a");
			showStatusWindow("Profile picture updated.");
		} else {
			showStatusWindow("Settings Updated.");
		}
	}
}
optsChangePwd = function(cbx) {
	if (cbx.checked) $("#tabChgPwd").fadeIn(); else $("#tabChgPwd").fadeOut();
}
optsInit = function() {
	$divOptsTabs = $("#divOptsTabs").tabs({ show: optsTabShow, cache: true, spinner: "<span class=font7>Brewing&#8230;</span>" });
	$us_disptunits = $("#us_disptunits");
	$us_dispvunits = $("#us_dispvunits");
	$us_dispvunits2 = $("#us_dispvunits2");
	$us_eff = spinnerBind($("#us_eff"), incPct, spinnerInc);
	$us_hunits = popUnitSelect("#us_hunits", GramsConvert);
	$us_hydrotemp = spinnerBindTemp($("#us_hydrotemp"), bihDefaults.TUNITS, spinnerInc);
	$us_munits = popUnitSelect("#us_munits", GramsConvert);
	$us_primer = popPrimer("#us_primer");
	$us_viunits = popUnitSelect("#us_viunits", LitersConvert);
	$us_volume = spinnerBind($("#us_volume"), incAmt, spinnerInc);
	$us_boilvol = spinnerBind($("#us_boilvol"), incAmt, spinnerInc);
	$us_vunits = popUnitSelect("#us_vunits", LitersConvert);
	$us_maltcap = $("#us_maltcap").bind("keydown change",			{	inc: 0.001,		maxVal: 1.0,		minInc: 0.001,	maxInc: 0.01,	decimals: 3, 	minVal: 0},			spinnerInc);
	$us_ratio = $("#us_ratio").bind("keydown change",				{	inc: 0.01,		maxVal: 5.0,		minInc: 0.01,	maxInc: 0.1,	decimals: 2, 	minVal: 0},			spinnerInc);
	$us_ratiounits = $("#us_ratiounits");
	unitselInit(document.getElementById("us_eunits"), bihDefaults.EUNITS);
	unitselInit(document.getElementById("us_vunits"), bihDefaults.VUNITS);
	unitselInit(document.getElementById("us_viunits"), bihDefaults.VIUNITS);
	optsLoad();
	$("#frmOptions").fileupload(
		{
			dataType: "json",
			url: (bihPath.cfc + "/proxy.cfc"),
			formData: {method: "call", args: JSON.stringify({meth: "Users.SetAvatar", data: {}})},
			done: function(e, data) {optsCallBack(data.result)},
			submit: function(e, data) { $("#imgAvatar").attr("src", bihPath.img+"/ani_ajaxrun.gif"); }
		}
	).find(".fileinput-button").each(
		function () {
			var $input = $(this).find("input:file").detach();
			$(this).button({icons: {primary: "bih-icon bih-icon-checked0"}}).append($input);
		}
	);
	$btnAvatar = $(".fileinput-button");
	$btnGravatar = $("#btnGravatar");
	optsAvatar("a");
}
optsLoad = function() {
	loadRowToForm(qryUser, document.frmOptions);
	$us_vunits.attr("oldvalue", qryUser.US_VUNITS);
	$us_viunits.attr("oldvalue", qryUser.US_VIUNITS);
	$us_munits.attr("oldvalue", qryUser.US_MUNITS);
	$us_dispvunits.html(qryUser.US_VUNITS);
	$us_dispvunits2.html(qryUser.US_VUNITS);
	$us_disptunits.html(qryUser.US_TUNITS);
	$us_ratiounits.html(qryUser.US_VIUNITS + "/" + qryUser.US_MUNITS);
}
optsReset = function() {
	optsLoad();
}
optsSave = function() {
	var frm = document.frmOptions;
	if (isEmpty(frm.us_first, "First Name is required.")) return false;
	if (isEmpty(frm.us_last, "Last Name is required.")) return false;
	if (isEmpty(frm.us_email, "Email is required.")) return false;
	if (isNotEmail(frm.us_email, "Email is invalid.")) return false;
	if (frm.chg_password.checked) {
		if (isEmpty(frm.password, "Password is required.")) return false;
		if (isNotREMatch(frm.password, /^.{5,}/, "Password must be at least 5 characters.")) return false;
		if (isEmpty(frm.password2, "Confirmed Password is required.")) return false;
		if (isNotEqual(frm.password.value, frm.password2.value, "Passwords do not match.")) return false;
		qryUser.US_PWD = frm.password.value;
	}
	if (!frm.us_volume.onblur()) return false;
	if (!frm.us_boilvol.onblur()) return false;
	if (!frm.us_hydrotemp.onblur()) return false;
	if (!frm.us_eff.onblur()) return false;
	if (!frm.us_ratio.onblur()) return false;
	if (!frm.us_maltcap.onblur()) return false;
	if (!frm.us_thermal.onblur()) return false;
	loadFormToRow(frm, qryUser);
	remoteCall("Users.Process", qryUser, optsCallBack);
}
optsTabShow = function() {}
optsUnitsGravity = function(btn) {
	rotateGravity(btn);
}
optsUnitsInfusion = function(sel) {
	var ratio = $us_ratio.val();
	var units = $us_viunits.val();
	var old = $us_viunits.attr("oldvalue") || units;
	$us_viunits.attr("oldvalue", units);
	ratio = ratio * convertVolume(old, 1, units);
	$us_ratio.val(ratio.toFixed(2));
	$us_ratiounits.html($us_viunits.val() + "/" + $us_munits.val());
}
optsUnitsMash = function(sel) {
	var ratio = $us_ratio.val();
	var units = $us_munits.val();
	var old = $us_munits.attr("oldvalue") || units;
	$us_munits.attr("oldvalue", units);
	ratio = ratio / convertWeight(old, 1, units);
	$us_ratio.val(ratio.toFixed(2));
	$us_ratiounits.html($us_viunits.val() + "/" + $us_munits.val());
}
optsUnitsTemp = function(btn) {
	var old = btn.value;
	var units = rotateTemp(btn);
	$us_hydrotemp.val(formatTemp(convertTemp(old, $us_hydrotemp.val(), units), units));
	$us_disptunits.html(units);
}
optsUnitsVolume = function(sel) {
	var units = $us_vunits.val();
	var old = $us_vunits.attr("oldvalue") || units;
	$us_vunits.attr("oldvalue", units);
	$us_volume.val(convertVolume(old, $us_volume.val(), units).toFixed(2));
	$us_boilvol.val(convertVolume(old, $us_boilvol.val(), units).toFixed(2));
	$us_dispvunits.html(units);
	$us_dispvunits2.html(units);
}
//optsChangeMash = function(btn) {	if (rotateMashType(btn)!="Extract") $("#divOptsMashData").fadeIn(); else $("#divOptsMashData").fadeOut(); }
