<cfinvoke component="#APPLICATION.CFC.Javascript#" method="IncludeExplorerJS" which="Users" />
<cfoutput><link href="#APPLICATION.PATH.ROOT#/css/ui.dynatree.css" rel="stylesheet" type="text/css"></cfoutput>
<div id="divExpMain">
	<div id="divExpLeft" class="dynatree-invert">
		<div id="divExpAcc">
			<h4 data-src="Users"><a href="#">Brewers</a></h4>
			<div id="divTreeUsers"></div>
			<h4 data-src="Grains"><a href="#">Grains</a></h4>
			<div id="divTreeGrains"></div>
			<h4 data-src="Hops"><a href="#">Hops</a></h4>
			<div id="divTreeHops"></div>
			<h4 data-src="Yeast"><a href="#">Yeast</a></h4>
			<div id="divTreeYeast"></div>
			<h4 data-src="Misc"><a href="#">Miscellaneous Ingredients</a></h4>
			<div id="divTreeMisc"></div>
		</div>
	</div>
	<div id="divExpRight">
		<div id="divExpUsers"></div>
		<div id="divExpGrains"></div>
		<div id="divExpHops"></div>
		<div id="divExpYeast"></div>
		<div id="divExpMisc"></div>
	</div>
</div>
<cfif SESSION.LoggedIn>
	<div id="divExpSave" style="display:none; position:absolute; bottom: 0; text-align:center; padding: 5px;">
		<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" id="btnTreeSave" class="ui-button-text-tiny" src="bih-icon-disk" onclick="treeSave(this)" text="Save Filter" />
	</div>
</cfif>
