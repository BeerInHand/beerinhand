<cfset filter = StructNew() />
<cfif ArrayLen(REQUEST.URLTokens) GTE 2>
	<cfset toke = 2 />
	<cfif isNumeric(REQUEST.URLTokens[toke])>
		<cfset filter.US_USID = REQUEST.URLTokens[toke] />
		<cfset toke = toke + 1 />
	<cfelse>
		<cfif REQUEST.URLTokens[toke] EQ "brewer">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.US_USER = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelseif REQUEST.URLTokens[toke] EQ "name">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.US_NAME = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelseif REQUEST.URLTokens[toke] EQ "mashtype">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.US_MASHTYPE = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelseif REQUEST.URLTokens[toke] EQ "postal">
			<cfset toke = toke + 1 />
			<cfif ArrayLen(REQUEST.URLTokens) GTE toke>
				<cfset filter.US_POSTAL = REQUEST.URLTokens[toke] />
			</cfif>
		<cfelse>
			<cfset filter.US_USER = REQUEST.URLTokens[toke] />
		</cfif>
	</cfif>
</cfif>
<cfif NOT Len(StructKeyList(filter))><cfset filter = false /></cfif>

<cfset qryUsers = APPLICATION.CFC.Users.QueryUsersSafe() />
<cfset nodesUsers = APPLICATION.CFC.Users.GetTreeNodes() />
<cfoutput>
<script>
qryUsers = #udfQueryToJSON(qryUsers)#;
qryUsers.PKID = "US_USID";
nodesUsers = #SerializeJSON(nodesUsers)#;
$(document).ready(
	function() {
		selectFill(getById("dataSrcFld"), { User:"US_USER", Name:"US_LAST", Postal:"US_POSTAL" });
		dataInit("Users", "Brewers", "US_USID", #SerializeJSON(filter)#, []);
	}
);
</script>
<ul id="dataView">
	<li class="ui-widget-content ui-corner-all">
		<table id="dataTable" cellspacing="10">
			<tbody class="bih-grid-form nobevel">
				<tr>
					<td width="150" class="profile center">
						<h2>
						<a class="us_user" target="_blank">
						<span></span>
						<img class="avatar" src="#udfAvatarSrc()#" />
						</a>
						</h2>
					</td>
					<td class="bottom">
						<table width="310">
							<tr><td class="label" width="115">Name:</td><td><h3 class="us_name"></h3></td></tr>
							<tr><td class="label">Where:</td><td><h3><a class="us_postal"></a></h3></td></tr>
							<tr><td class="label">Mash Type:</td><td><h3><a class="us_mashtype"></a></h3></td></tr>
							<tr><td class="label">Batch Size:</td><td><h3><a class="us_volume"></a></h3></td></tr>
							<tr><td class="label">Recipe Count:</td><td><h3 class="us_recipecnt"></h3></td></tr>
							<tr><td class="label">Batches Brewed:</td><td><h3 class="us_brewcnt"></h3></td></tr>
							<tr><td class="label">Amount Brewed:</td><td><h3 class="us_brewamt"></h3></td></tr>
						</table>
					</td>
					<td class="bottom">
						<table width="230">
							<tr><td class="label" width="100">Gravity Units:</td><td><h3><a class="us_eunits"></a></h3></td></tr>
							<tr><td class="label">Temp Units:</td><td><h3><a class="us_tunits"></a></h3></td></tr>
							<tr><td class="label">Grain Units:</td><td><h3><a class="us_munits"></a></h3></td></tr>
							<tr><td class="label">Hop Units:</td><td><h3><a class="us_hunits"></a></h3></td></tr>
							<tr><td class="label">Primer:</td><td><h3><a class="us_primer"></a></h3></td></tr>
							<tr><td class="label">Joined:</td><td><h5 class="us_added"></h5></td></tr>
							<tr><td class="label">DLA:</td><td><h5 class="us_dla"></h5></td></tr>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
	</li>
</ul>
</cfoutput>
