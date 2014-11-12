<script>
	$(document).ready(
		function() {
			spinnerBindTemp($("#temp_f"), "F", tempEvent);
			spinnerBindTemp($("#temp_c"), "C", tempEvent);
		}
	);
</script>
<table id="tabTemp" class="datagrid calculator" cellspacing="0">
	<caption>
		<div class="bih-grid-caption ui-widget-header">
			<span class="icons"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-arrowthick-1-w" onclick="calc2rcpTemp(this)" title="Select" style="display:none" /><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" src="ui-icon-trash" onclick="calcClear('t')" title="Clear Calculator"/></span>
			Temperature
		</div>
	</caption>
	<tbody class="bih-grid-form nobevel">
		<tr>
			<td class="unitlabel label" width="100">Fahrenheit</td>
			<td class="unitinput"><input type="text" value="32.0" class="decimal unit" maxlength="5" id="temp_f"></td>
		</tr>
		<tr>
			<td class="unitlabel label">Celsius</td>
			<td class="unitinput"><input type="text" value="0.0" class="decimal unit" maxlength="5" id="temp_c"></td>
		</tr>
	</tbody>
</table>