brewerCallBack = function(response) {
	if (!response.SUCCESS) {
		cbErrors(response);
	} else {
		if (response.DATA.METHOD=="FollowInsert") {
			showStatusWindow("Brewer added to Grist.");
			setTimeout("setFollowIcon(0)",1000);
		} else if (response.DATA.METHOD=="FollowDelete") {
			showStatusWindow("Brewer removed from Grist.");
			setTimeout("setFollowIcon(1)",1000);
		} else if (response.DATA.METHOD=="FavoriteInsert") {
			showStatusWindow("Recipe added to favorites.");
			setTimeout("setFavoriteIcon(0)",1000);
		} else if (response.DATA.METHOD=="FavoriteDelete") {
			showStatusWindow("Recipe removed from favorites.");
			setTimeout("setFavoriteIcon(1)",1000);
		}
	}
}
brewerFavorite = function(btn) {
	var $btn = $("#btnFavorite").attr("disabled","disabled").addClass("ui-state-disabled");
	btnChange($btn, "bih-icon bih-icon-ajax");
	remoteCall("FavoriteRecipe.Process", { recipe: recipeID }, brewerCallBack);
}
brewerFilter = function(e) {
	var rowid = $(this).parent().data("rowid");
	if (rowid==null) return; // NOTHING TO DO
	var fld = $("##tabScrollHeadBrewLog").find("th:eq(" + this.cellIndex + ")").data("filter");
	var filter = new Object();
	filter[fld] = qryBrewLog.DATA[rowid][fld]
	brewlogLoad(null, filter);
}
brewerFollow = function(btn) {
	var $btn = $("#btnFollow").attr("disabled","disabled").addClass("ui-state-disabled");
	btnChange($btn, "bih-icon bih-icon-ajax");
	remoteCall("FollowUser.Process", { brewer: brewerID }, brewerCallBack);
}
brewerOpen = function(btn) {
	var rowid = $(btn).parents("tr").data("rowid");
	if (rowid==null) {
		window.location.href = bihPath.root + "/p.recipe.cfm?reid=-1";
	} else {
		var ROW = qryBrewLog.DATA[rowid];
		if (ROW.RE_PRIVACY && !isUserBrewer) return showStatusWindow("This recipe is marked PRIVATE and it cannot be copied.");
		window.location.href = bihPath.root + "/p.recipe.cfm?reid="+ROW.RE_REID;
	}
}
brewerView = function(btn) {
	var rowid = $(btn).parents("tr").data("rowid");
	var ROW = qryBrewLog.DATA[rowid];
	if (ROW.RE_PRIVACY && !isUserBrewer) return showStatusWindow("This recipe is marked PRIVATE and it cannot be viewed.");
	window.location.href = bihPath.root + "/" + ROW.RE_BREWER + "/recipe/" + ROW.RE_REID + "/p.brewer.cfm";
}
brewerRecipes = function(btn) {
	var rowid = $(btn).parents("tr").data("rowid");
	var ROW = qryBrewLog.DATA[rowid];
	if (ROW.RE_PRIVACY && !isUserBrewer) return showStatusWindow("This recipe is marked PRIVATE and it cannot be viewed.");
	window.location.href = bihPath.root + "/" + ROW.RE_BREWER + "/recipes/p.brewer.cfm";
}
btnChange = function($btn, icon, title) {
	if (!$btn.length) return;
	var $icon = $btn.find("span.ui-icon");
	if ($icon.length) $icon.attr("class", "ui-button-icon-primary ui-icon " + icon);
	if (!title) return;
	var $text = $btn.find("span.ui-button-text");
	if ($text.length) $text.html(title);
	$btn.attr("title", title);
	return $btn;
}
setFavoriteIcon = function(act) {
	var $btn = $("#btnFavorite").removeAttr("disabled").removeClass("ui-state-disabled");
	if (act) {
		btnChange($btn, "ui-icon-star", "Favorite");
	} else {
		btnChange($btn, "ui-icon-circle-minus", "Favorite");
	}
}
setFollowIcon = function(act) {
	var $btn = $("#btnFollow").removeAttr("disabled").removeClass("ui-state-disabled");
	if (act) {
		btnChange($btn, "ui-icon-circle-plus", "Add to my Grist");
	} else {
		btnChange($btn, "ui-icon-circle-minus", "Remove from Grist");
	}
}
