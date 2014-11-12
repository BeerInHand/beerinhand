<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>markItUp! Preview Template</title>
	<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/css/orange/bih-ui.css" />
	<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/css/jquery.autocomplete.css" />
	<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/css/style.css" />
	<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/forum/css/forum.css" />
	<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/forum/markitup/skins/markitup/style.css" />
	<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/forum/markitup/sets/default/style.css" />
</head>
<cfmodule template="tags/DP_ParseBBML.cfm" input="#form.data#" outputvar="result" convertsmilies="true" usecf_coloredcode="true" smileypath="images/Smilies/Default/">
<style>
##divForum { width: auto;}
</style>
<body>
<div id="divForum">
	<div class="ui-widget-content">
		<div class="forum_post">
			<div class="">
				<div class="forum_post_content">
					#result.output#
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
</cfoutput>