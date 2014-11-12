<cfinvoke component="#APPLICATION.CFC.Users#" method="QueryUsers" us_usid="#SESSION.USER.usid#" returnvariable="qryUser" />
<cfset qryFUser = APPLICATION.FORUM.User.getUser(SESSION.USER.user) />
<cfset qryFSubs = APPLICATION.FORUM.User.getSubscriptions(SESSION.USER.user) />

<cfoutput>
<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="#APPLICATION.PATH.ROOT#/js/jquery.fileupload.js"></script>

<script>
	var qryUser = #SerializeJSON(qryUser)#;
	queryMakeHashable(qryUser);
	qryUser = qryUser.DATA[0];
	qryUser.US_SIG = "#qryFUser.SIGNATURE#";
	src_which = "<cfif qryFUser.avatar is "@gravatar">g<cfelse>a</cfif>";
	src_avatar = "#qryFUser.avatar#";
	src_gravatar = "http://www.gravatar.com/avatar.php?gravatar_id=#lcase(hash(SESSION.USER.email))#&amp;rating=PG&amp;size=150&amp;default=#APPLICATION.PATH.AVATARS#/zombatar.jpg";
	$(document).ready(optsInit);
</script>
</cfoutput>

<h1>User Setttings</h1>
<p>
<div class="ui-widget ui-widget-content ui-corner-all post_buttons">
	<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-pencilpad" onclick="optsSave(this)" text="Save Changes"/>
</div>
</p>
<form id="frmOptions" name="frmOptions" action="?" method="POST" enctype="multipart/form-data">
<div id="divOptsTabs">
	<ul id="ulOptsTabs">
		<li>
			<a href="#divOptsUser" title="divOptsUser"><span>User Info</span></a>
		</li>
		<li>
			<a href="#divOptsDefaults" title="divOptsDefaults"><span>Defaults</span></a>
		</li>
		<li>
			<a href="#divOptsMash" title="divOptsMash"><span>Mash Setup</span></a>
		</li>
		<li>
			<a href="#divOptsProfile" title="divOptsProfile"><span>Profile</span></a>
		</li>
		<li>
			<a href="#divOptsBlog" title="divOptsBlog"><span>Blog</span></a>
		</li>
	</ul>
	<div id="divOptsUser">
		<p><div class="ui-widget ui-widget-header ui-corner-all pad5">User Info</div></p>
		<table id="tabDefaultBrewer" class="tabOptions">
			<tbody>
				<tr>
					<td class="label" width="150">Username:</td>
					<td width="190" class="bold"><cfoutput>#qryUser.us_user#</cfoutput></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td class="label required" width="150">First Name:</td>
					<td><input type="text" class="brewer" name="us_first" value="" maxlength="15" required="required" /></td>
					<td>Your first name.</td>
				</tr>
				<tr>
					<td class="label required">Last Name:</td>
					<td><input type="text" class="brewer" name="us_last" value="" maxlength="15" required="required" /></td>
					<td>Your last name.</td>
				</tr>
				<tr>
					<td class="label required">Email:</td>
					<td><input type="email" class="brewer" name="us_email" value="" maxlength="15" required="required" /></td>
					<td>Changing your email will require you to revalidate your account.</td>
				</tr>
				<tr>
					<td class="label">Zip Code:</td>
					<td><input type="text" class="brewer" name="us_postal" value="" maxlength="15" /></td>
					<td>Your zip / postal code. This is used for Google mapping brew day locations.</td>
				</tr>
				<tr>
					<td class="label">Date Format:</td>
					<td><select class="dunits bold" name="us_datemask" id="us_datemask"><option value="mm/dd/yyyy">mm/dd/yyyy</option><option value="dd-mmm-yyyy">dd-mmm-yyyy</option></select></td>
					<td>This is the date format that will be used when displaying and collecting dates.</td>
				</tr>
				<tr>
					<td class="label">Change Password:</td>
					<td><input type="checkbox" name="chg_password" id="chg_password" onclick="optsChangePwd(this)" /></td>
					<td>Check this box if you wish to change your password.</td>
				</tr>
			</tbody>
		</table>
		<table id="tabChgPwd" class="tabOptions" style="display: none";>
			<tbody>
				<tr>
					<td class="label required" width="150">Password:</td>
					<td width="190"><input type="password" id="password" name="password" /></td>
				</tr>
				<tr>
					<td class="label required">Confirm Password:</td>
					<td><input type="password" id="password2" name="password2" /></td>
				</tr>
		</table>
	</div>
	<div id="divOptsDefaults">
		<p><div class="ui-widget ui-widget-header ui-corner-all pad5">Unit Defaults</div></p>
		<table id="tabDefaultUnits" class="tabOptions">
			<tbody>
				<tr>
					<td class="label" width="140">Volume Units:</td>
					<td width="90"><select class="units" name="us_vunits" id="us_vunits" onchange="optsUnitsVolume(this)"></select></td>
					<td width="100">&nbsp;</td>
					<td>This is the default volume unit that will be used when creating a new recipe.</td>
				</tr>
				<tr>
					<td class="label">Grain/Malt Units:</td>
					<td><select class="units" name="us_munits" id="us_munits" onchange="optsUnitsMash(this)"></select></td>
					<td>&nbsp;</td>
					<td>This is the default weight unit that will used for Fermentables such as Malt and Extracts when creating a new recipe.</td>
				</tr>
				<tr>
					<td class="label">Hop Units:</td>
					<td><select class="units" name="us_hunits" id="us_hunits"></select></td>
					<td>&nbsp;</td>
					<td>This is the default weight unit that will used for Hops when creating a new recipe.</td>
				</tr>
				<tr>
					<td class="label">Temperature Units:</td>
					<td><button id="us_tunits" class="butRotateBig units" type="button" onclick="optsUnitsTemp(this)" value="F">&deg;F</button></td>
					<td>&nbsp;</td>
					<td>This is the default temperature unit that will used when creating a new recipe.</td>
				</tr>
				<tr>
					<td class="label">Gravity Scale:</td>
					<td><button id="us_eunits" class="butRotateBig units" type="button" onclick="optsUnitsGravity(this)">SG</button></td>
					<td>&nbsp;</td>
					<td>This is the default scale that will used for measuring fermentablitiy when creating a new recipe.</td>
				</tr>
			</tbody>
		</table>
		<p><div class="ui-widget ui-widget-header ui-corner-all pad5">Recipe Defaults</div></p>
		<table id="tabDefaultRecipe" class="tabOptions">
			<tbody>
				<tr>
					<td class="label required" width="140">Volume:</td>
					<td width="90"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="float" id="us_volume" min="0" max="10000" required="required" /></td>
					<td width="100" id="us_dispvunits" class="dunits"></td>
					<td>This is the default volume that will be used when creating a new recipe.</td>
				</tr>
				<tr>
					<td class="label required">Boil Volume:</td>
					<td><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="float" id="us_boilvol" min="0" max="10000" required="required" /></td>
					<td id="us_dispvunits2" class="dunits"></td>
					<td>This is the  volume of wort that you typically boil when brewing. A value of zero is assumes a full wort boil.</td>
				</tr>
				<tr>
					<td class="label" required>Mash Type:</td>
					<td><button id="us_mashtype" type="button" class="butRotateBig mashtype" onclick="rotateMashType(this)">All Grain</button></td>
					<td>&nbsp;</td>
					<td>This is the default Mash Type selected when creating a new recipe.</td>
				</tr>
				<tr>
					<td class="label">Hop Form:</td>
					<td><button id="us_hopform" type="button" class="butRotateBig units" onclick="rotateHopForm(this)">Pellet</button></td>
					<td>&nbsp;</td>
					<td>This is the default Hop Form selected when adding a Hop to a recipe.</td>
				</tr>
				<tr>
					<td class="label">Priming Sugar:</td>
					<td><select class="primer units" name="us_primer" id="us_primer"></select></td>
					<td>&nbsp;</td>
					<td>This is the type of sugar that you typically use to prime uncarbonated beer before packaging.</td>
				</tr>
				<tr>
					<td class="label">Privacy:</td>
					<td colspan="2">
						<select class="selectwithicon bold" name="us_privacy" id="us_privacy">
							<option value="0" class="bih-icon-ballgreen">Public</option>
							<option value="1" class="bih-icon-ballyellow">Public Headers</option>
							<option value="2" class="bih-icon-ballred">Private</option>
						</select>
					</td>
					<td>This is the default privacy setting that will be used when creating a new recipe. We encourage you to use the public settings for all recipes, but we also understand the desire to keep some things secret.<br/>
						<cfoutput>
						<ul>
							<li onclick="document.frmOptions.us_privacy.selectedIndex=0" /><img src="#APPLICATION.PATH.IMG#/trans.gif" class="fleft bih-icon bih-icon-ballgreen"><strong>&nbsp;Public</strong><br/>All details of the recipe are displayed.</li>
							<li onclick="document.frmOptions.us_privacy.selectedIndex=1" /><img src="#APPLICATION.PATH.IMG#/trans.gif" class="fleft bih-icon bih-icon-ballyellow"><strong>&nbsp;Public Headers</strong><br/>General recipe information is displayed such as name, style and batch size as well as the dates various events take place like brewing, racking and packaging. The recipe details are hidden so no ingredients or procedures are revealed. This setting allows brewing activities to be displayed in the grist without divulging trade secrets.</li>
							<li onclick="document.frmOptions.us_privacy.selectedIndex=2" /><img src="#APPLICATION.PATH.IMG#/trans.gif" class="fleft bih-icon bih-icon-ballred"><strong>&nbsp;Private</strong><br/>The recipe is private and only you can see it.</td>
						</ul>
						</cfoutput>
				</tr>
			</tbody>
		</table>
		<p><div class="ui-widget ui-widget-header ui-corner-all pad5">Hydrometer</div></p>
		<table id="tabDefaultHydro" class="tabOptions">
			<tbody>
				<tr>
					<td class="label required" width="140">Calibration Temp:</td>
					<td width="90"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="smallint" id="us_hydrotemp" min="0" max="100" required="required" /></td>
					<td width="100" id="us_disptunits" class="dunits"></td>
					<td>This is the temperature your hydrometer is calibrated for (usually 60F or 68F).</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div id="divOptsMash">
		<p><div class="ui-widget ui-widget-header ui-corner-all pad5">Mash Defaults &nbsp;&nbsp;&nbsp;<span class="normal">(Extract brewers may skip this section)</span></div></p>
		<table id="tabDefaultMash" class="tabOptions">
			<tbody>
				<tr>
					<td class="label required" width="175">Mash Efficency:</td>
					<td width="100"><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="tinyint" id="us_eff" min="10" max="100" required="required" /></td>
					<td width="100" class="font10 bold padl10">%</td>
					<td>This is the default mash efficency used when creating a new recipe</td>
				</tr>
				<tr>
					<td class="label">Infusion Volume Units:</td>
					<td><select class="units" name="us_viunits" id="us_viunits" onchange="optsUnitsInfusion()"></select></td>
					<td>&nbsp;</td>
					<td>This is the default infusion volume unit that will be used when initializing the Mash Temperature Calcuator.</td>
				</tr>
				<tr>
					<td class="label required">Water To Grist Ratio:</td>
					<td><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="float" id="us_ratio" min="0" max="10" required="required" /></td>
					<td id="us_ratiounits" class="dunits padl10">&nbsp;</td>
					<td>This is default water to grist ratio that will be used when initializing the Mash Temperature Calcuator.</td>
				</tr>
				<tr>
					<td class="label required">Malt Heat Capacity:</td>
					<td><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="float" id="us_maltcap" min="0" max="1" required="required" /></td>
					<td>&nbsp;</td>
					<td>
						This is the default malt heat capacity that will be used when initializing the Mash Temperature Calcuator. The heat capacity of the crushed malt is typically .4 and varies depending on the moisture content of the malt:
<p><pre>
% moisture      MHC in Btu/lb/degF
  0                     0.38
  2                     0.39
  4                     0.40
  6                     0.41
</pre></p>
					</td>
				</tr>
				<tr>
					<td class="label">Mash Tun Thermal Mass:</td>
					<td><cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="float" id="us_thermal" min="0" max="100" /></td>
					<td>&nbsp;</td>
					<td>This is how much heat your Mash Tun will absorb when hot water is added.</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div id="divOptsProfile">
		<p><div class="ui-widget ui-widget-header ui-corner-all pad5">Profile</div></p>
		<cfoutput>
		<table class="tabOptions">
			<tbody>
				<tr>
					<td class="label">Profile Picture:</td>
					<td width="150">
						<img id="imgAvatar">
					</td>
					<td width="60">&nbsp;</td>
					<td width="225">
						<img id="imgGravatar" src="#APPLICATION.PATH.AVATARS#/zombatar.jpg">
					</td>
					<td>This is your profile image.</td>
				</tr>
				<tr>
					<td class="label">Image Options:</td>
					<td>
						<span class="btn btn-success fileinput-button">
							<span>Upload Image</span>
							<input id="fileupload" type="file" name="newavatar">
						</span>
					</td>
					<td class="font14 bold middle">-- OR --</td>
					<td class="top">
						<cfinvoke component="#APPLICATION.CFC.CONTROLS#" id="btnGravatar" method="create" type="juiButton" src="bih-icon bih-icon-checked0" onclick="optsAvatar('g')" text="Use Gravatar" />
					</td>
					<td>You can upload an image or use the <a href="http://www.gravatar.com" target="_new">Gravatar</a> web service.</td>
				</tr>
				<tr>
					<td class="label">Tag Line:</td>
					<td colspan="3">
						<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="textarea" name="us_sig" id="us_sig" maxlen="500" width="400px" rows="3" />
					</td>
					<td>Your tag line will be displayed beneath your profile picture and include in various places within the website.</td>
				</tr>
			</tbody>
		</table>
		</cfoutput>
	</div>
	<div id="divOptsBlog">
		<p><div class="ui-widget ui-widget-header ui-corner-all pad5">Blog Settings</div></p>
		<cfoutput>
		<table class="tabOptions">
			<tbody>
				<tr>
					<td class="label" width="150">Moderate Comments:</td>
					<td width="190"><input type="checkbox" name="us_moderate" id="us_moderate" /></td>
					<td>
						When non-BeerInHand users post to your blog, you can choose to moderate their comments. When comments are moderated, they do not appear on your blog page until you approve them. You can approve them from either the embedded link in the notification email sent or via the blog admin section.
					</td>
				</tr>
				<tr>
					<td class="label">Use Tweetbacks:</td>
					<td width="190"><input type="checkbox" name="us_tweetback" id="us_tweetback" /></td>
					<td>Determines if TweetBacks should be enabled for your blog posts. BeerInHand will search Twitter for mentions of each blog entry. This results in a slight delay on the first hit to your blog post, but the results will be cached for a few minutes.</td>
				</tr>
			</tbody>
		</table>
		</cfoutput>
	</div>
</div>
<p>
<div class="ui-widget ui-widget-content ui-corner-all post_buttons">
	<cfinvoke component="#APPLICATION.CFC.CONTROLS#" method="create" type="juiButton" class="ui-button-text-tiny" src="bih-icon bih-icon-pencilpad" onclick="optsSave(this)" text="Save Changes"/>
</div>
</p>

</form>