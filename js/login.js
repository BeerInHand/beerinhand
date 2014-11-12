var validUser = "";
var autoProcess = false;

forgotProcess = function() {
	var frm = document.frmUser;
	if (isEmpty(frm.username,"Username is required.")) return true;
	frm.submit();
}

loginCallBack = function(response) {
	if (!response.SUCCESS) {
		cbErrors(response);
	} else {
		if (!response.DATA.VALIDATED) {
			showStatusWindow("Login Failed. " + response.DATA.LOGINMSG, 0, true);
		} else {
			window.location = "p.brewer.cfm";
		}
	}
	$("#btnLogin").find("span").html("Log In");
}
loginClearMsg = function(msgid) {
	if (msgid) {
		var $loginmsg = $("#"+msgid);
		if ($loginmsg.length) {
			$loginmsg.fadeOut(800,function() {$(this).html("&nbsp;").show()});
		}
	}
}
loginProcess = function(btn) {
	var frm = document.frmLogin;
	if (isEmpty(frm.username)) {
		showStatusWindow("Login Failed. User Name is required.", 0, true);
		frm.username.focus();
		return false;
	}
	if (isEmpty(frm.password)) {
		showStatusWindow("Login Failed. Password is required.", 0, true);
		frm.password.focus();
		return false;
	}
	$("#btnLogin").find("span").html(imgAjaxRunSm);
	remoteCall("Users.Login", {user: frm.username.value, pwd: frm.password.value, rem: frm.remember.checked}, loginCallBack);
}
loginShowMsg = function(msg, msgid) {
	if (msgid) {
		var $loginmsg = $("#"+msgid);
		if ($loginmsg.length) {
			$loginmsg.html(msg);
			setTimeout("loginClearMsg('"+msgid+"')",5000);
			return;
		}
	}
	showStatusWindow(msg);
}
verifyCallBack = function(response) {
	if (!response.SUCCESS) {
		cbErrors(response);
	} else {
		if (response.DATA.EXISTS) {
			loginShowMsg("Username already exists...", "loginmsg");
			verifySetIcon("ui-icon-alert", "ui-state-error");
		} else if (!response.DATA.VALID) {
			loginShowMsg("Username is invalid...", "loginmsg");
			verifySetIcon("ui-icon-alert", "ui-state-error");
		} else if (response.DATA.METHOD=="Exists") {
			loginShowMsg("Username Available!", "loginmsg");
			verifySetIcon("ui-icon-check");
			validUser = response.DATA.USER;
			if (autoProcess) signupProcess();
			autoProcess = false;
		} else if (response.DATA.METHOD=="SignUp") {
			window.location = "p.signup.cfm?done=0";
		}
	}
}
verifyClear = function() {
	verifySetIcon("ui-icon-bullet");
}
verifyProcess = function() {
	var frm = document.frmUser;
	if (isEmpty(frm.username,"Username is required.")) return true;
	if (isNotREMatch(frm.username, /^[A-Za-z0-9]{4,20}$/, "Username must be at least 4 characters and contain only letters and numbers.")) return false;
	if (isNotEqual(validUser, frm.username.value)) return verifyUser(true);
	if (isEmpty(frm.password, "Password is required.")) return false;
	if (isNotREMatch(frm.password, /^[A-Za-z0-9!@#$%^&*()_]{5,20}$/, "Password must be at least 5 characters.")) return false;
	if (isEmpty(frm.password2, "Confirmed Password is required.")) return false;
	if (isNotEqual(frm.password.value, frm.password2.value, "Passwords do not match.")) return false;
	if (isEmpty(frm.email, "Email is required.")) return false;
	if (isNotEmail(frm.email, "Email is invalid.")) return false;
	if (isEmpty(frm.email2, "Confirmed Email is required.")) return false;
	if (isNotEqual(frm.email.value, frm.email2.value, "Emails do not match.")) return false;
	var ROW = new Object();
	ROW.user = validUser;
	ROW.pwd = frm.password.value;
	ROW.email = frm.email.value;
	remoteCall("Users.SignUp", ROW, verifyCallBack);
}
verifySetIcon = function(icon, span) {
	var $ico = $("#icoVerify").attr("class", span || "").find("img").attr("class", "ui-icon " + icon);
}
verifyUser = function(callProcess) {
	var frm = document.frmUser;
	if (isEmpty(frm.username)) {
		loginShowMsg("Username required...", "loginmsg");
		verifySetIcon("ui-icon-alert", "ui-state-error");
		return true;
	}
	if (isNotREMatch(frm.username, /^[A-Za-z0-9]{4,20}$/)) {
		loginShowMsg("Username Invalid...", "loginmsg");
		verifySetIcon("ui-icon-alert", "ui-state-error");
		return true;
	}
	loginShowMsg(imgAjaxRunSm, "loginmsg");
	validUser = "";
	autoProcess = callProcess;
	remoteCall("Users.CheckExists", {user: frm.username.value}, verifyCallBack);
}