<table id="tabWeight" class="datagrid calculator" cellspacing="0">
	<caption>
		<div class="bih-grid-caption ui-widget-header">
			<span class="icons"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-arrowthick-1-w" onclick="calc2rcpWeight(this)" title="Select" style="display:none" /><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-trash" onclick="calcClear('w')" title="Clear Calculator"/></span>
			Weight
		</div>
	</caption>
	<tbody class="bih-grid-form nobevel"><tr><td class="unitlabel label" width="100"></td><td class="unitinput"></td><td class="unittotal"></td></tr></tbody>
</table>
<script>ucalcBuild("tabWeight", "w", GramsConvert);</script>