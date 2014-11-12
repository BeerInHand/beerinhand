// COLLECTION OF HELPFUL FUNCTIONS
String.prototype.left=function(cnt) {return left(this,cnt)};
String.prototype.right=function(cnt) {return right(this,cnt)};
String.prototype.starts=function(str) {return starts(this,str)};
String.prototype.toInt=function(def) {return toInt(this,def)};
String.prototype.toFloat=function(def) {return toFloat(this,def)};
String.prototype.pipeCRLF=function(remove) {return pipeCRLF(this,remove)};
String.prototype.convCR2BR=function() { return convCR2BR(this)};
String.prototype.spacesPlus=function() {return this.replace(/\s/g, "+")};
String.prototype.spacesNone=function() {return this.replace(/\s/g, "")};

addS = function(sIn, cnt, s) {
	if (!s) s="s";
	if (cnt==1) return sIn;
	return sIn+s;
}
cbErrors = function(response) {
	var strMsg = "";
	$.each(response.ERRORS,
		function(idx, objError) {
			strMsg += (objError.ERROR + "\n");
		}
	);
	showStatusWindow(strMsg, 0, true);
}
pipeCRLF = function(str, remove) {
	if (remove) return str.toString().replace(/(\r\n|[\r\n])/g,"|");
	return str.toString().replace(/\|/g,"\n");
}
convCR2BR = function(str) {
	return convCR2(str, "<br>");
}
convCR2 = function(str, to) {
	if (to==undefined) to = " ";
	return str.toString().replace(/(\r\n|[\r\n])/g, to);
}

datemaskStrip = function(fld) {
	$(fld).removeClass("hasmask");
}
datemaskToggle = function(fld) {
	if (!isEmpty(fld)) {
		datemaskStrip(fld);
	} else {
		$(fld).addClass("hasmask");
	}
}
fieldHint = function(fld, add) {
	if (add) { // BLUR
		if (isEmpty(fld)) fld.value = fld.defaultValue;
	} else { // FOCUS
		if (fld.value==fld.defaultValue) fld.value = "";
	}
	return fld.value;
}
fieldHintIsEmpty = function(fld) {
	return (isEmpty(fld) || fld.value==fld.defaultValue);
}
filterCnt = function(rows, cnt) {
	return (rows!=cnt ? "Filtered " + cnt + " of " : "") + rows + addS(" record",rows)
}
focusSelect = function(fld, doit) {
	if (doit) {
		fld.focus();
		if (fld.type=="text" || fld.type=="textarea") fld.select();
	} else {
		tmpfld = fld;
		setTimeout("focusSelect(tmpfld, 1)",0);
	}
}
getAvatarSrc = function(avatar, gravatar) {
	if (avatar=="@gravatar") {
		return "http://www.gravatar.com/avatar.php?gravatar_id="+gravatar+"&amp;rating=PG&amp;size=150&amp;default="+bihPath.root+"/usercontent/avatars/zombatar.jpg";
	}
	return bihPath.root+"/usercontent/avatars/"+avatar;
}
getBrowser = function() {
	var ua = navigator.userAgent;
	var ver = $.browser.version.split(".")[0];
	var out = "";
	if ($.browser.msie) {
		out = "MSIE " + ver;
	} else if (/Chrome/i.test(ua)) {
		ver = ua.substring(ua.indexOf('Chrome/') +7).split(".")[0];
		out = "Chrome " + ver;
	} else if ($.browser.opera) {
		out = "Opera " + ver;
	} else if ($.browser.safari) {
		ver = ua.substring(ua.indexOf('Version/') +8).split(".")[0];
		out = "Safari " + ver;
	} else if (/Firefox/i.test(ua)) {
		ver = ua.substring(ua.indexOf('Firefox/') +8).split(".")[0];
		out = "Firefox " + ver;
	} else if (/BlackBerry/i.test(ua)) {
		ver = ua.substring(ua.indexOf('/') +1).split(".")[0];
		out = "BlackBerry " + ver;
	} else if (/NetFront/i.test(ua)) {
		ver = ua.substring(ua.indexOf('NetFront/') +9).split(".")[0];
		out = "NetFront " + ver;
	}
	if (out=="") {
		out = "?"+ua;
	} else {
		if (/iPhone/i.test(ua)) {
			out = "iPhone " + out;
		} else if (/Android/i.test(ua)) {
			out = "Android " + out;
		}
	}
	return out;
}
getCheckImg = function(chk, yesText, noText) {
	chk = parseInt(chk) ? "1" : "0";
	var title = chk=="1" ? yesText || "Yes" : noText || "No";
	return "<img title='"+yesText+"' src='"+bihPath.img+"/trans.gif' class='bih-icon bih-icon-checked"+chk+"' />";
}
getById = function(id) {
	return document.getElementById(id);
}
getFlagImg = function(flag) {
	return "<img class='flagSM flag"+flag.replace(/\s/g,"")+"' src='"+bihPath.img+"/trans.gif' />";
}
getPopOutImg = function(url) {
	return "<img onclick=popOut('"+url+"') class='bih-icon bih-icon-popout' src='"+bihPath.img+"/trans.gif' />";
}
iif = function(bool, val1, val2) {
	return (bool) ? val1 : val2;
}
inQs = function(fld) {
	return "'"+fld+"'";
}
isDefined = function(variable) {
	return (typeof window[variable]!="undefined");
}
isEmpty = function(fld, msg) {
	var val = trim(fld);
	var bad = (val.length==0);
	if (bad && msg) {
		alert(msg);
		if (typeof(fld)=="object") focusSelect(fld);
	}
	return bad;
}
isField = function(fld) {
	return (typeof(fld)=="object");
}
isLenValid = function(fld, maxlen, msg) {
	var val = trim(fld);
	if (!msg) msg="Field";
	if (val.length > maxlen) {
		window.alert(msg + " cannot be longer than " + maxlen + " characters.");
		if (typeof(fld)=="object") focusSelect(fld);
		return false;
	}
	return true;
}
isNotEmail = function(fld, msg) {
	var RE = /^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name))$/
	var isFld = (typeof(fld)=="object");
	if (isFld) fld.value = fld.value.toLowerCase();
	return isNotREMatch(fld, RE, msg);
}
isNotEqual = function(fld1, fld2, msg) {
	var bad = (fld1!=fld2);
	if (bad && msg) {
		alert(msg);
	}
	return bad;
}
isNotREMatch = function(fld, RE, msg) {
	var val = trim(fld);
	var bad = !RE.test(val);
	if (bad && msg) {
		alert(msg);
		if (typeof(fld)=="object") focusSelect(fld);
	}
	return bad;
}
isNotSelected = function(sel, msg) {
	var bad = (sel.options[sel.selectedIndex].value==0);
	if (bad) {
		alert(msg);
		focusSelect(sel);
	}
	return bad;
}
isNumber = function(n) {
	return !isNaN(parseFloat(n)) && isFinite(n);
}
isURL = function(fld, msg) {
	var val = trim(fld);
	if (!val.length) return true;
	if (msg) msg = "'" + val + "' is not a valid URL.";
	if (!val.starts("http")) val = "http://".concat(val);
	var RE = /^(https?):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i;
	var valid = RE.test(val); //	!isNotREMatch(val, RE, msg);
	if (!valid && msg) alert(msg);
	if (isField(fld)) {
		if (valid) {
			fld.value = val;
		} else {
			focusselect(fld);
		}
	}
	return valid;
}
isZero = function(fld, msg) {
	var val = trim(fld);
	var bad = (toFloatMin(val,0)==0);
	if (bad && msg) {
		alert(msg);
		if (typeof(fld)=="object") focusSelect(fld);
	}
	return bad;
}
jsDateFormat = function(jsDate, mask) {
	if (!mask) mask="mm/dd/yyyy";
	var year = String(jsDate.getFullYear());
	var mon = String(jsDate.getMonth()+1);
	var day = String(jsDate.getDate());
	var delim = (mask.indexOf("-")>=0) ? "-" : "/";
	var parts = mask.split(delim);
	if (parts[0]) newDate = nextDatePart(parts[0], mon, day, year);
	if (parts[1]) newDate = newDate.concat(delim, nextDatePart(parts[1], mon, day, year));
	if (parts[2]) newDate = newDate.concat(delim, nextDatePart(parts[2], mon, day, year));
	return newDate;
}
left = function(str, cnt){
	if (cnt<=0)	return "";
	if (cnt>String(str).length) return String(str);
	return String(str).substring(0,cnt);
}
liveHover = function() {
	$(document).on("mouseover mouseout",".liveHover", {},
		function(event) {
			if (event.type=="mouseover") {
				$(this).addClass("ui-state-hover");
			} else if (event.type=="mouseout") {
				$(this).removeClass("ui-state-hover");
			}
		}
	);
}
loadFieldToRow = function(fld, row) { // MOVES A SINGLE FORM.FIELD TO CORRESPONDING ROW.DATA
	row.DATA[fld.name.toUpperCase()] = fld.value;
}
loadFormToRow = function(frm, ROW, fldidx) { // MOVES DATA FROM FORM.FIELD TO CORRESPONDING ROW.DATA IF FOUND IN FORM
	if (typeof fldidx=="undefined") fldidx = "";
	for (var col in ROW) {
		fld = frm[col.toLowerCase()+fldidx.toString()]; // EXPECTS frm FIELDS IN LOWER CASE
		if (fld) {
			if (/select/.test(fld.type)) { // SELECT
				ROW[col] = (fld.selectedIndex==-1) ? 0 : fld.options[fld.selectedIndex].value;
			} else if (fld.type=="checkbox") {
				ROW[col] = (fld.checked) ? 1 : 0;
			} else if (fld.type=="button") {
				ROW[col] = fld.value;
			} else { // INPUT
				if (/currency/.test(fld.className)) {
					ROW[col] = parseFloat(cleannumber(fld.value));
				} else if (/decimal/.test(fld.className)) {
					ROW[col] = parseFloat(fld.value);
				} else if (/integer/.test(fld.className)) {
					ROW[col] = parseInt(fld.value);
				} else if (fld.type=="textarea") {
					ROW[col] = fld.value;
				} else {
					ROW[col] = fld.value;
				}
			}
		}
	}
}
loadRowToForm = function(ROW, frm, meta, fldidx) { // MOVES DATA FROM ROW.DATA TO CORRESPONDING FORM.FIELD IF FOUND IN FORM
	if (typeof fldidx=="undefined") fldidx = "";
	for (var col in ROW) {
		var fld = frm[col.toLowerCase()+fldidx]; // EXPECTS frm FIELDS IN LOWER CASE
		if (fld) {
			var len = fld.length;
			fld.idx = fldidx;
			if (/bihDateMM/.test(fld.className)) { // DATE FIELD
				queryFixDate(ROW, col);
			}
			if (fld.type=="select-multiple") {
				var val = ROW[col];
				var ary = val.toString().split(",");
				for (var i=0; i<len; i++) {
					for (var j=0; j<ary.length; j++) if (fld.options[i].value==ary[j]) fld.options[i].selected = true;
				}
			} else if (/select/.test(fld.type)) { // SELECT
				selectValue(fld, ROW[col]);
				fld.oldvalue = ROW[col];
			} else if (fld.type=="checkbox") {
				fld.checked = (ROW[col]!=0);
			} else if (len && fld[0].type=="radio") {
				for (var i=0; i<len; i++) fld[i].checked = (fld[i].value==ROW[col]);
			} else if (fld.type=="button") {
				var txt = ROW[col];
				if (meta && typeof meta[col][metaFormat]=="function") txt = meta[col][metaFormat](txt);
				rotateSetVal(fld, txt, ROW[col]);
			} else if (fld.type=="textarea") {
				var val = ROW[col] || "";
				fld.value = val.toString(); //.replace(new RegExp("<br\\s*(/>|>)", "ig"), String.fromCharCode(13));
			} else { // INPUT
				fld.value = ROW[col];
				if (/currency/.test(fld.className)) {
					fld.value = dollarFormat(ROW[col], true);
				} else if (/date/.test(fld.className)) {
					if (ROW[col]) {
						var d = new Date(ROW[col]);
						fld.value = jsDateFormat(d);
					}
				} else if (/decimal/.test(fld.className)) {
					if (meta) {
						var mask = meta[col][metaSize].toString().split(".")[1];
					} else {
						var mask = 2;
					}
					fld.value = parseFloat(ROW[col] || 0).toFixed(mask);
				} else {
					fld.value = ROW[col];
				}
			}
		}
	}
}
ltrim = function(str, chars) {
	chars = chars || "\\s";
	return str.replace(new RegExp("^[" + chars + "]+", "g"), "");
}
nextDatePart = function(part, mon, day, year) {
	if (part.match(/dd/gi)) return zeroPad(day, 2);
	if (part.match(/d/gi)) return day;
	if (part.match(/yyyy/gi)) return year;
	if (part.match(/yy/gi)) return year.slice(2);
	if (part.match(/mmm/gi)) return "JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC".substr((mon-1)*3,3);
	if (part.match(/mon/gi)) return "JanFebMarAprMayJunJulAugSepOctNovDec".substr((mon-1)*3,3);
	if (part.match(/mm/gi)) return zeroPad(mon, 2);
	if (part.match(/m/gi)) return mon;
	return "??";
}
now = function() {
	return jsDateFormat(new Date());
}
openURL = function(fld) {
	if (!isURL(fld, true)) return false;
	var isFld = isField(fld);
	var url = (isFld) ? fld.value : fld;
	if (url=="") {
		showStatusWindow("Please enter a URL to open.");
		if (isFld) focusselect(fld);
		return false;
	}
	popOut(url, '_blank');
}
parseDate = function(val, mask) {
	if (!mask) mask=cfDateMask;
	var obj = new Object();
	var parts;
	var mons = "JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC";
	var months = "January,February,March,April,May,June,July,August,September,October,November,December";
	var reDDMMMYY= /^([1-9]|[0-9][0-9])\/(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\/(\d{2}|\d{4})$/i;
	var reMMDDYY= /^([1-9]|0[1-9]|1[0-2])\/([1-9]|[0-9][0-9])\/(\d{2}|\d{4})$/;
	var reDDMMYY= /^([1-9]|[0-9][0-9])\/([1-9]|0[1-9]|1[0-2])\/(\d{2}|\d{4})$/;
	var test = val.replace(/-/g, '/').toUpperCase(); // replace "-" with "/"
	if (parts = test.match(reDDMMMYY)) {
		obj.dd = parseInt(parts[1],10);
		obj.mon = parts[2];
		obj.mm = mons.search(RegExp(obj.mon,"i"))/3+1;
		obj.yy = parseInt(parts[3],10);
	} else {
		if (mask=="dd/mm/yyyy") {
			if (parts = test.match(reDDMMYY)) {
				obj.dd = parseInt(parts[1],10);
				obj.mm = parseInt(parts[2],10);
				obj.yy = parseInt(parts[3],10);
			}
		} else if (mask=="mm/dd/yyyy") {
			if (parts = test.match(reMMDDYY)) {
				obj.mm = parseInt(parts[1],10);
				obj.dd = parseInt(parts[2],10);
				obj.yy = parseInt(parts[3],10);
			}
		}
	}
	obj.valid = (obj.yy) ? true : false;
	if (obj.valid) {
		obj.month = months.split(",")[obj.mm-1];
		if (obj.yy<100) {
			var yif = obj.yy - (new Date().getFullYear()-2000);
			obj.yy += (yif<20) ? 2000 : 1900; // IF 2 DIGIT IS YEAR MORE THAN 20 YEARS FROM TODAY CONSIDER LAST CENTURY
		}
		obj.valid = (obj.dd<32 && obj.dd>0);
		if (!obj.valid) {
			var th = "";
			if (obj.dd!=0) th = (obj.dd>3 && obj.dd<21) ? "th" : "th,st,nd,rd,th,th,th,th,th,th".split(",")[obj.dd%10];
			obj.error = "The " + String(obj.dd) + th + " is not a valid day of the month.";
		} else {
			switch (obj.mm) {
				case 2:
					obj.valid = (obj.dd<29) || (obj.dd==29 && obj.yy%4==0);
					if (!obj.valid) obj.error = "February 29th is not a valid day in the year " + String(obj.yy) + ".";
					break;
				case 4: case 6: case 9: case 11:
					obj.valid = (obj.dd<31);
					if (!obj.valid) obj.error = "The 31st is not a valid day in " + obj.month + ".";
					break;
			}
		}
	} else {
		var thisyear=new Date().getFullYear().toString();
		if (mask=="dd/mm/yyyy") {
			obj.error = "31/12/";
		} else if (mask=="mm/dd/yyyy") {
			obj.error = "12/31/";
		} else {
			obj.error = "31-DEC-";
		}
		obj.error = "Date is not in the format '" + mask + "'.\n\nFor example, '"+obj.error+thisyear+"' is December 31st "+thisyear+".";
	}
	if (obj.valid) {
		obj.mon = mons.substr((obj.mm-1)*3,3);
		obj.date = new Date(obj.yy, obj.mm-1, obj.dd);
		obj.UTC = Date.UTC(obj.yy, obj.mm-1, obj.dd);
		obj.dd = zeroPad(obj.dd,2);
		obj.mm = zeroPad(obj.mm,2);
		obj.yy = String(obj.yy);
		obj.error = "";
	}
	return obj;
}
popOut = function(url,name,width,height) {
	if (!width) var width = 1024;
	if (!height)  var height = 768;
	if (!name) var name = "_blank";
	var args = "width="+width+",height="+height+",titlebar=0,toolbar=0,menubar=0,location=1,status=0,scrollbars=1,resizable=1,personalbar=0,directories=0,dependent=true";
	return window.open(url, name, args);
}
queryAddRow = function(qry) {
	var ADD = new Object();
	var len = qry.DATA.length;
	for (var i = 0; i < qry.COLUMNS.length; i++) {
		ADD[qry.COLUMNS[i]]="";
	}
	qry.DATA[len] = ADD;
	return len;
}
queryFixDate = function(ROW, col) { //
	val = ROW[col];
	if (val==null || val=="") {
		ROW[col]="";
	} else {
		d = new Date(val);
		if (!isNaN(d.getTime())) ROW[col] = jsDateFormat(d, cfDateMask);
	}
}
queryIsFormEqualRow = function(frm, ROW, fldidx, arrSkipFlds) {
	var fld;
	if (typeof fldidx=="undefined") fldidx = "";
	for (var col in ROW) {
		if (ROW.hasOwnProperty(col)) {
			if (arrSkipFlds && $.inArray(col.toLowerCase(), arrSkipFlds)!=-1) continue;
			fld = frm[col.toLowerCase()+fldidx]; // EXPECTS frm FIELDS IN LOWER CASE
			if (fld && !fld.disabled) {
				if (/select/.test(fld.type)) { // SELECT
					if (ROW[col]!=fld.options[fld.selectedIndex].value) return false;
				} else if (fld.type=="checkbox") {
					if (ROW[col]!=fld.checked) return false;
				} else if (fld.type=="button") {
					if (iif(ROW[col]==null,"",ROW[col])!=fld.value) return false;
				} else { // INPUT
					if (/currency/.test(fld.className)) {
						if (dollarFormat(ROW[col]||0, false)!=dollarFormat(fld.value, false)) return false;
					} else if (/date/.test(fld.className)) {
						var rd = jsDateFormat(new Date(ROW[col]));
						if (rd!=fld.value) return false;
					} else if (/decimal/.test(fld.className)) {
						if ((ROW[col]||0)!=fld.value) return false;
					} else {
						if (iif(ROW[col]==null,"",ROW[col])!=fld.value) return false;
					}
				}
			}
		}
	}
	return true;
}
queryMakeHashable = function(qry) { // MAKES A MULTI-ROW QUERY CREATED VIA SerializeJSON ACCESSIBLE BY COLUMN NAME ie qryTest.DATA[0]["TE_TEST"]
	if (!qry.DATA.length || qry.DATA[0]._ROWID!=undefined) return;
	var rx = new RegExp("^[\\s]+", "g");
	for (var j = 0; j < qry.DATA.length; j++) {
		var ROW = new Object();
		ROW._DELETED = false;
		ROW._ROWID = j;
		for (var i = 0; i < qry.COLUMNS.length; i++) {
			var val = qry.DATA[j][i];
			if (val!=null && val.length) val=val.replace(rx, "");
			ROW[qry.COLUMNS[i]]=val;
		}
		qry.DATA[j] = ROW;
	}
}
querySearch = function(qry, col, val) {
	if (!qry.DATA.length) return -1;
	if (qry.DATA[0][col]==undefined) return -1;
	for (var j = 0; j < qry.DATA.length; j++) {
		if (qry.DATA[j][col]==val) return j;
	}
	return -1;
}
querySearchIdx = function(qry, idx, key1, find1, key2, find2) {
	var first = find1.left(1);
	var more = key2 && find2 && find2!="";
	var mA = -1, m1 = -1, m3 = -1, m5 = -1, mS = -1;
	var irow = idx[first] || 0; // FIND THE FIRST ROW STARTING WITH THIS LETTER FROM THE ALPHA IDX
	for (var j = irow; j < qry.DATA.length; j++) {
		var val1 = qry.DATA[j][key1];
		if (val1.left(1)==first) {
			m1 = j;
			if (val1==find1) {
				mA = j;
				if (more) {
					var val2 = qry.DATA[j][key2];
 					if (val2==find2) break;
 				} else { // NO MORE TO DO, SO EXIT WITH THE EXACT HIT ON KEY1
 					break;
 				}
			} else {
				if (mA!=-1) break; // HIT ON KEY1 BUT NOT KEY2 AND KEY1 CHANGED SO ACCEPT HIT
				if (val1.starts(find1)) mS=j; else if (val1.left(5)==find1.left(5)) m5=j; else if (val1.left(3)==find1.left(3)) m3=j;
			}
		} else {
			if (m1!=-1) { // MOVED PAST 1 LETTER MATCH
				mA = (mS!=-1) ? mS : (m5!=-1) ? m5 : (m3!=-1) ? m3 : m1;
			 	break; // FOUND A MATCH ON KEY1 BUT NOT KEY2 AND KEY1 CHANGED SO WE GOOD WITH THE PARTIAL MATCH
			}
		}
	}
	return mA;
}
remoteCall = function(method, data, fnCallback, async) {
	var cbRemoteCall = function(data, textStatus, $XHR) {
		if (fnCallback) fnCallback(data);
	}
	$.ajax({
		async: async || false,
		type: "post",
		data: {method: "call", args: JSON.stringify({meth: method, data: data})},
		dataType: "JSON",
		url: (bihPath.cfc + "/proxy.cfc"),
		success: cbRemoteCall,
		error: cbRemoteCall,
		cache: false
	});
}
right = function(str, cnt){
	str = String(str);
	if (cnt<=0)	return "";
	if (cnt>str.length) return str;
	var iLen = str.length;
	return str.substring(str.length, str.length - cnt);
}
rowHighlight = function($tab, prefix, rowid) {
	var currRow = $tab.data("rowid");
	if (currRow!="") $("#"+prefix+currRow).toggleClass("blue");
	$tab.data("rowid", rowid);
	$("#"+prefix+rowid).toggleClass("blue");
}
rtrim = function(str, chars) {
	chars = chars || "\\s";
	return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
}
selectAddOption = function(sel, val, txt, isSelected) {
	sel.options[sel.options.length] = new Option(txt, val, false, isSelected);
}
selectFill = function(sel, opts) {
	for (var label in opts) sel.options[sel.options.length] = new Option(label, opts[label], false);
}
selectedOption = function(sel) {
	return sel.options[sel.selectedIndex].text;
}
selectedValue = function(sel) {
	return sel.options[sel.selectedIndex].value;
}
selectOption = function(sel, val) {
	for (var i = 0; i < sel.length; i++) {
		if (sel.options[i].text == val) {
			sel.options[i].selected = true;
			return true;
		}
	}
	return false;
}
selectValue = function(sel, val) {
	for (var i = 0; i < sel.length; i++) {
		if (sel.options[i].value == val) {
			sel.options[i].selected = true;
			return true;
		}
	}
	return false;
}
spacesPlus = function(str) {
	return str.replace(/\s/g, "+");
}
rotateSetVal = function(btn, txt, val) {
	btn.innerHTML = txt;
	btn.value = val==undefined ? txt : val;
	return btn.value;
}
setTD = function ($tr, content, selector, cls) {
	var $td = $tr.find("td."+selector);
	if (!$td.length) {
		selector += (cls) ? " " + cls : "";
		var $td = $("<td>").addClass(selector);
		$tr.append($td);
	}
	return $td.html(content);
}
setWaitImg = function(id, src) {
	var el = document.getElementById(id);
	if (el) {
		if (!src) src="icon_blank.png";
		else if (src=="run") src="ani_ajaxrun.gif";
		else if (src=="error") src="ani_ajaxerror.gif";
		else if (src=="done") {
			setTimeout('setWaitImg("'+id+'")',5000); // clear done after 5 seconds
			src="ani_ajaxdone.gif";
		}
		el.src = "./images/"+src;
	}
}
showStatusWindow = function(msg, disp, error) {
	var $sts = $("#divStatus");
	if (!disp) disp = 3000;
	if (!$sts.length) {
		$sts = $("<div id=divStatus class='statusWindow'></div>").appendTo($("body"));
		$sts.click(function() {$(this).stop(true,true).fadeOut(600);});
	}
	$sts.stop(true,true); // END ANY PENDING ANI
	$sts.html(msg);
	if (error) {
		$sts.append("<div class='statusWindowCloseBtn ui-icon ui-icon-close'></div>")
		$sts.addClass("ui-state-error");
		$sts.fadeIn(disp);
	} else {
		$sts.removeClass("ui-state-error");
		if (disp == -1) {
			$sts.show();
		} else {
			$sts.fadeIn(750).delay(disp).fadeOut(1500);
		}
	}
	return $sts;
}
spinnerInc = function(event) {
	var inc = (event.shiftKey ? event.data.maxInc : (event.ctrlKey || event.metaKey) ? event.data.minInc : event.data.inc);
	var val = parseFloat(event.target.value) || 0.0;
	event.data.changed = false;
	event.data.minVal = event.data.minVal || 0.0;
	if (event.which==38)	{
		if (val>=event.data.maxVal) return false; // over maximum
		val += inc;
	} else if (event.which==40) {
		if (val<=event.data.minVal) return false; // below minimum
		val -= inc;
	} else if (event.which==13) { // allow return true for enter for formating/processing purposes
	} else {
		return true;
	}
	val = Math.max(Math.min(val, event.data.maxVal), event.data.minVal);
	event.target.value = val.toFixed(event.data.decimals);
	event.target.select();
	event.data.changed = true;
	return true;
}
starts = function(str, sub) {
	return (left(str, String(sub).length)==sub);
}
getStorage = function() {
	var uid = new Date, storage, result;
	try {
		(storage = window.localStorage).setItem(uid, uid);
		result = storage.getItem(uid)==uid;
		storage.removeItem(uid);
		return result && storage;
	} catch(e) {}
}
tbodyHide = function(btn) {
	$btn = $(btn);
	var $tbody = $btn.parents("table").find("tbody");
	if ($tbody.is(":visible")) {
		$tbody.fadeOut(800);
		$btn.find(".ui-icon").removeClass("ui-icon-arrowthickstop-1-n").addClass("ui-icon-arrowthickstop-1-s");
	} else {
		$tbody.fadeIn(1000);
		$btn.find(".ui-icon").removeClass("ui-icon-arrowthickstop-1-s").addClass("ui-icon-arrowthickstop-1-n");
	}
}
textareaMaxLen = function(fld, clr) {
	var $lenfld = $("#"+fld.name+"_len");
	if (!$lenfld.length) return true;
	if (clr) {
		$lenfld.fadeOut(500);
		return true;
	}
	$lenfld.show();
	if (fld.readOnly) {
		$lenfld.html("read only");
		$lenfld.css("background-color","#FFFFAA");
		return true;
	}
	var len = fld.value.length;
	var max = parseInt($(fld).data("maxlen"));
	len = Math.max(max - fld.value.length,0);
	$lenfld.html(len.toString());
	if (!len) {
		fld.value = fld.value.substring(0,max);
		$lenfld.css("background-color","#FFAAAA");
		return false;
	}
	$lenfld.css("background-color","");
	return true;;
}
toFloat = function(val, def) {
	return (val==undefined || isNaN(parseFloat(val))) ? def || 0 : parseFloat(val);
}
toFloatMax = function(val, max) {
	if (val==undefined || isNaN(parseFloat(val))) return max;
	return Math.min(parseFloat(val), max);
}
toFloatMin = function(val, min) {
	if (val==undefined || isNaN(parseFloat(val))) return min;
	return Math.max(parseFloat(val), min);
}
toInt = function(val, def) {
	return (val==undefined || isNaN(parseInt(val))) ? def || 0 : parseInt(val);
}
toIntMax = function(val, max) {
	if (val==undefined || isNaN(parseInt(val))) return max;
	return Math.min(parseInt(val), max);
}
toIntMin = function(val, min) {
	if (val==undefined || isNaN(parseInt(val))) return min;
	return Math.max(parseInt(val), min);
}
trapKeypress = function(e,regEx) {
	var keynum;
	if (window.event) { // IE
		keynum = window.event.keyCode;//keypressed.keyCode
	} else { // Netscape/Firefox/Opera
		keynum = e.which;
		if (keynum==0 || keynum==8 || keynum==9) return; //ALLOW USER TO BACKUP, ARROW AROUND, TAB, etc
	}
	return regEx.test(String.fromCharCode(keynum));
}
trim = function(fld, chars) { // THIS FUNCTION MODIFIES THE VALUE OF FIELDS, PASS IN FLD.VALUE IF THIS IS NOT DESIRED
	var isFld = (typeof(fld)=="object");
	str = (isFld) ? fld.value : fld;
	str = ltrim(rtrim(str+"", chars), chars)
	if (isFld) fld.value = str;
	return str;
}
tryJSON = function(json) {
	var obj = {success: true};
	try {
		obj.data = $.parseJSON(json);
	} catch (err) { obj.success = false; }
	return obj;
}
validateDate = function(fld, nomsg, newmask) {
	var val = trim(fld);
	if (!val.length) return true;
	var isFld = (typeof(fld)=="object");
	if (!nomsg) nomsg = false;
	if (!newmask) newmask=cfDateMask;
	var oDate = parseDate(val, cfDateMask);
	if (oDate.valid) {
		if (oDate.yy < 1900) {
			oDate.error = "For years prior to 1900, please contact the Help Desk.";
			oDate.valid = false;
		} else if (oDate.yy > 2078) { // smalldatetime max value is 6/6/2079
			oDate.error = "For dates beyond 2078, please contact the Help Desk.";
			oDate.valid = false;
		}
	}
	if (isFld && oDate.valid) { // if we are working with form field, change the value to the supplied mask
		if (newmask=="dd/mm/yyyy") {
			fld.value = oDate.dd + "/" + oDate.mm + "/" + oDate.yy;
		} else if (newmask=="mm/dd/yyyy") {
			fld.value = oDate.mm + "/" + oDate.dd + "/" + oDate.yy;
		} else { // dd-mmm-yyyy
			fld.value = oDate.dd + "-" + oDate.mon + "-" + oDate.yy;
		}
		fld.title = newmask;
	}
	if (nomsg) {
		return oDate.error;
	} else if (!oDate.valid) {
		alert(oDate.error);
		if (isFld) focusSelect(fld);
	}
	return oDate.valid;
}
validateRange = function(val, min, max, fld) {
	if (isField(fld)) fld.value = val;
	if (val<min || val>max) {
		alert("The number entered is invalid. The value must be between " + min + " and " + max + ".");
		if (isField(fld)) focusSelect(fld);
		return false;
	}
	return true;
}
validateFloat = function(fld, max, min) {
	max = toFloatMax(max, 2147483647);
	min = toFloatMin(min, -max);
	return validateFloatRange(fld, min, max);
}
validateFloatRange = function(fld, min, max, def) {
	min = toFloat(min);
	max = toFloat(max);
	def = toFloat(def, min);
	var val = toFloat(trim(fld), def);
	return validateRange(val, min, max, fld);
}
validateIntRange = function(fld, min, max, def) {
	min = toInt(min);
	max = toInt(max);
	def = toInt(def, min);
	var val = toInt(trim(fld), def);
	return validateRange(val, min, max, fld);
}
validateInt = function(fld, max, min, def) {
	max = toIntMax(max, 2147483647);
	min = toIntMin(min, -max);
	return validateIntRange(fld, min, max, def);
}
validateSmallInt = function(fld, max, min, def) {
	max = toIntMax(max, 32767);
	min = toIntMin(min, -max);
	return validateIntRange(fld, min, max, def);
}
validateTinyInt = function(fld, max, min, def) {
	max = toIntMax(max, 255);
	min = toIntMin(min, 0);
	return validateIntRange(fld, min, max, def);
}
zeroPad = function(num, width) {
	num = num.toString();
	while (num.length < width)  num = "0" + num;
	return num;
}