<div id="dataTree" class="brewer_sidebox ui-widget-content ui-corner-all">
	<div class="brewer_sidehead bih-grid-caption ui-widget-header ui-corner-all">
		<img class="toggler bih-icon bih-icon-collapse" src="#APPLICATION.PATH.IMG#/trans.gif" onclick="sidebarToggle(this)" title="Show/Hide" />
	</div>
</div>
<div id="dataSearch" class="brewer_sidebox ui-widget-content ui-corner-all">
	<div class="brewer_sidehead bih-grid-caption ui-widget-header ui-corner-all">
		Search
		<img class="toggler bih-icon bih-icon-collapse" src="#APPLICATION.PATH.IMG#/trans.gif" onclick="sidebarToggle(this)" title="Show/Hide" />
	</div>
	<div class="pad10">
		<form name="frmDataSrc" onsubmit="return brewlogSearch();">
		<select name="dataSrcFld" id="dataSrcFld"></select>
		<input type="text" name="dataSrcVal" id="dataSrcVal" placeholder="Search" title="regex is ok" />
		<cfinvoke component="#APPLICATION.CFC.Controls#" method="Create" type="juiButton" src="ui-icon-search" class="ui-button-icon-tiny" onclick="brewlogSearch()" title="Search" />
		</form>
	</div>
</div>

