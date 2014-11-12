<cfprocessingdirective pageencoding="utf-8" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<cfoutput>
	<title>BeerInHand</title>
	<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/css/orange/bih-ui.css" media="screen,print"/>
	<link rel="stylesheet" type="text/css" href="#APPLICATION.PATH.ROOT#/css/style.css" media="screen,print" />
	<cfinvoke component="#APPLICATION.CFC.Javascript#" method="IncludeCommonJS" />
	</cfoutput>
</head>
<body>
<cfoutput>
<div id="pageWrapper">
	<div id="divHeader">
		<div id="divHeaderMast">
			<h1><a href="#APPLICATION.PATH.FULL#">BeerInHand.com</a></h1>
			<img id="beerme" src="#udfGlassSrc()#" />
			<cfif SESSION.LoggedIn>
				<h2>Malt, Hops, Yeast, Happiness</h2>
			<cfelse>
				<div class="login_container ui-corner-all ui-widget-content">
					<cfinclude template="pages/login.cfm">
				</div>
			</cfif>
		</div>
		<div id="divHeaderNav">
			<div id="divHeaderNavMenu">
				<ul>
				<cfif SESSION.LoggedIn>
					<li><a href="#APPLICATION.PATH.ROOT#/#SESSION.USER.user#/p.brewer.cfm">MY BIH</a></li>
				<cfelse>
					<li><a href="#APPLICATION.PATH.ROOT#/p.home.cfm">HOME</a></li>
				</cfif>
					<li><a href="#APPLICATION.PATH.ROOT#/b.index.cfm">BLOG</a></li>
					<li><a href="#APPLICATION.PATH.ROOT#/f.index.cfm">FORUM</a></li>
					<li><a href="#APPLICATION.PATH.ROOT#/p.recipe.cfm">RECIPE CALC</a></li>
					<li><a href="#APPLICATION.PATH.ROOT#/p.calc.cfm">BREW CALC</a></li>
					<li><a href="#APPLICATION.PATH.ROOT#/p.data.cfm">EXPLORER</a></li>
				</ul>
			</div>
			<div id="divHeaderNavAuth">
				<cfif SESSION.LoggedIn>
					<a style="display: inline !important;" href="#APPLICATION.PATH.ROOT#/u.settings.cfm" id="header-user">Settings</a> |
					<a style="display: inline !important;" href="#APPLICATION.PATH.ROOT#/p.logout.cfm" id="header-logout">Log Out</a> |
				<cfelse>
<!--- 					<a style="display: inline !important;" href="#APPLICATION.PATH.ROOT#/p.login.cfm" id="header-login">Log In</a> | <a href="#APPLICATION.PATH.ROOT#/p.signup.cfm">Sign Up</a> | --->
				</cfif>
				<a href="p.help.cfm">Help</a>
			</div>
		</div>
	</div>
	<div id="divContent">
		<cftry>
			<cfinclude template="#REQUEST.LoadPage#" />
			<cfcatch type="any">
				<cfinclude template="error\error.cfm" />
			</cfcatch>
		</cftry>
	</div>
	<div id="divFooter">
		<div id="divFooterCredits"></div>
		<div id="divFooterNav">
			<ul>
				<li><a href="#APPLICATION.PATH.ROOT#/grains/p.data.cfm">Grains</a></li>
				<li><a href="#APPLICATION.PATH.ROOT#/hops/p.data.cfm">Hops</a></li>
				<li><a href="#APPLICATION.PATH.ROOT#/yeast/p.data.cfm">Yeast</a></li>
				<li><a href="#APPLICATION.PATH.ROOT#/misc/p.data.cfm">Miscellaneous</a></li>
				<li><a href="#APPLICATION.PATH.ROOT#/bjcpstyles/p.data.cfm">BJCP Styles</a></li>
			</ul>
		</div>
	</div>
</div>
</cfoutput>
</body>
</html>
<cfif StructKeyExists(url,"dumpit")>
	<cfdump var="#SESSION#"/>
	<cfdump var="#APPLICATION#"/>
	<cfdump var="#LOCAL#"/>
</cfif>