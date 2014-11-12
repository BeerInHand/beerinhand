<cfcomponent output="false">

<cffunction name="Create" output="true" access="public">
	<cfargument name="type" type="string" default="date" />
	<cfargument name="value" type="string" default="" />
	<cfargument name="class" type="string" default="" />
	<cfargument name="onblur" type="string" default="" />

	<cfset var LOCAL = StructNew()>
	<cfset LOCAL.params = "" />
	<cfset LOCAL.ReadOnly = false />
	<cfset LOCAL.exclude = "type" />
	<cfset LOCAL.wrap_pre ="" />
	<cfset LOCAL.wrap_post ="" />
	<cfif ARGUMENTS.type is "date">
		<cfset LOCAL.exclude = LOCAL.exclude & ",value,onblur" />
	<cfelseif ARGUMENTS.type is "displaycheck">
		<cfset LOCAL.exclude = LOCAL.exclude & ",src,title,radio,yesText,noText" />
	<cfelseif ARGUMENTS.type is "juiButton">
		<cfset LOCAL.exclude = LOCAL.exclude & ",src,text,textclass,width,class,href" />
	<cfelseif ARGUMENTS.type is "juiIcon">
		<cfset LOCAL.exclude = LOCAL.exclude & ",src,title,class,href" />
	<cfelseif ARGUMENTS.type is "textarea">
		<cfset LOCAL.exclude = LOCAL.exclude & ",width,value,maxlen,desc" />
	<cfelseif ARGUMENTS.type is "time">
		<cfset LOCAL.exclude = LOCAL.exclude & ",value,onblur" />
	<cfelseif ListFindNoCase("juiText,url,email", ARGUMENTS.type)>
		<cfset LOCAL.exclude = LOCAL.exclude & ",value,style" />
	<cfelseif ListFindNoCase("integer,smallint,tinyint,float", ARGUMENTS.type)>
		<cfset LOCAL.exclude = LOCAL.exclude & ",onblur,min,max,title" />
	<cfelseif ARGUMENTS.type is "abbr">
		<cfset LOCAL.exclude = LOCAL.exclude & ",title" />
	</cfif>
	<cfif StructKeyExists(ARGUMENTS, "id") AND NOT StructKeyExists(ARGUMENTS, "name")>
		<cfset ARGUMENTS.name = ARGUMENTS.id />
	</cfif>
	<cfloop collection="#ARGUMENTS#" item="LOCAL.key">
		<cfif not ListFindNoCase(LOCAL.exclude, LOCAL.key) and len(ARGUMENTS[LOCAL.key])>
			<cfif LOCAL.key eq "readonly">
				<cfset ARGUMENTS.ReadOnly = "readonly" />
				<cfset LOCAL.ReadOnly = true />
			</cfif>
			<cfset LOCAL.params = LOCAL.params & lcase(LOCAL.key) & "=#CHR(34)##ARGUMENTS[LOCAL.key]##CHR(34)# ">
		</cfif>
	</cfloop>

	<!---ABBR--->
	<cfif ARGUMENTS.type is "abbr">
		<cfif ARGUMENTS.value neq "">
			<cfoutput><abbr title="#ARGUMENTS.title#" #LOCAL.params#>#ARGUMENTS.value#</abbr></cfoutput>
		</cfif>

	<!---DATE CONTROL--->
	<cfelseif ARGUMENTS.type is "date">
		<cfset dateclass = iif(LEN(SESSION.SETTING.datemask) eq 11, DE("bihDateMMM"), DE("bihDateMM"))>
		<cfset ARGUMENTS.class = ListAppend(ARGUMENTS.class, dateclass, " ")>
		<cfset ARGUMENTS.value = udfUserDateFormat(ARGUMENTS.value)>
		<cfif ARGUMENTS.value eq "" and not LOCAL.ReadOnly>
			<cfset LOCAL.params = LOCAL.params & " onfocus='datemaskStrip(this)'">
			<cfset ARGUMENTS.class = ListAppend(ARGUMENTS.class, "hasmask", " ")>
		</cfif>
		<cfoutput><input type="text" class="#ARGUMENTS.class#" #LOCAL.params# value="#ARGUMENTS.value#" maxlength="#LEN(SESSION.SETTING.datemask)#" title="#SESSION.SETTING.datemask#" onblur="#ARGUMENTS.onblur#; return validateDate(this)" /></cfoutput>

	<!---DISPLAYCHECK--->
	<cfelseif ARGUMENTS.type is "displaycheck">
		<cfparam name="ARGUMENTS.yesText" default="Yes" type="string" />
		<cfparam name="ARGUMENTS.noText" default="No" type="string" />
		<cfif ARGUMENTS.value eq 1>
			<cfset title = ARGUMENTS.yesText/>
			<cfset ARGUMENTS.class = ListAppend(ARGUMENTS.class, "bih-icon bih-icon-checked1", " ") />
		<cfelse>
			<cfset title = ARGUMENTS.noText/>
			<cfset ARGUMENTS.class = ListAppend(ARGUMENTS.class, "bih-icon bih-icon-checked0", " ") />
		</cfif>
		<cfoutput><img class="#ARGUMENTS.class#" #LOCAL.params# src="#APPLICATION.PATH.IMG#/trans.gif" title="#title#" /></cfoutput>

	<!---EMAIL LINK--->
	<cfelseif ARGUMENTS.type is "emaillink">
		<cfset ARGUMENTS.value = trim(ARGUMENTS.value)>
		<cfif ARGUMENTS.value neq "" and udfIsEmail(ARGUMENTS.value)>
			<cfoutput><a class="email" href="mailto:#ARGUMENTS.value#">#ARGUMENTS.value#</a></cfoutput>
		</cfif>

	<!--- JQUERY UI BUTTON --->
	<cfelseif ARGUMENTS.type is "juiButton">
		<cfparam name="ARGUMENTS.text" default="" type="string" />
		<cfparam name="ARGUMENTS.textclass" default="" type="string" />
		<cfparam name="ARGUMENTS.src" default="" type="string" />
		<cfif isDefined("ARGUMENTS.href")>
			<cfset LOCAL.params = LOCAL.params & " onclick=""window.location='#ARGUMENTS.href#'""" />
		</cfif>
		<cfset type = IIF(isDefined("ARGUMENTS.submit"), DE("submit"), DE("button")) />
		<cfif ARGUMENTS.text neq "">
			<cfif ARGUMENTS.src neq "">
				<cfoutput><button type="#type#" #LOCAL.params# class="#ARGUMENTS.class# liveHover juiButton-text-icon ui-state-default ui-widget ui-corner-all ui-button ui-button-text-icon-primary"><span class="ui-button-icon-primary ui-icon <cfif Left(ARGUMENTS.src, 8) eq "bih-icon">bih-icon </cfif>#ARGUMENTS.src#"></span><span class="ui-button-text #ARGUMENTS.textclass#">#ARGUMENTS.text#</span></button></cfoutput>
			<cfelse>
				<cfoutput><button type="#type#" #LOCAL.params# class="#ARGUMENTS.class# liveHover juiButton-text-only ui-state-default ui-widget ui-corner-all ui-button ui-button-text-only"><span class="ui-button-text #ARGUMENTS.textclass#">#ARGUMENTS.text#</span></button></cfoutput>
			</cfif>
		<cfelse>
			<cfoutput><button type="#type#" #LOCAL.params# class="#ARGUMENTS.class# liveHover juiButton-icon-only ui-state-default ui-widget ui-corner-all ui-button ui-button-icon-only" title="#ARGUMENTS.text#" ><span class="ui-button-icon-primary ui-icon <cfif Left(ARGUMENTS.src, 8) eq "bih-icon">bih-icon </cfif>#ARGUMENTS.src#"></span><span class="ui-button-text #ARGUMENTS.textclass#">&nbsp;</span></button></cfoutput>
		</cfif>

	<!--- JQUERY UI ICON --->
	<cfelseif ARGUMENTS.type is "juiIcon">
		<cfparam name="ARGUMENTS.src" default="" type="string" />
		<cfif left(ARGUMENTS.src,9) eq "bih-icon-">
			<cfset ARGUMENTS.src = "bih-icon #ARGUMENTS.src#" />
		<cfelseif left(ARGUMENTS.src,8) eq "ui-icon-">
			<cfset ARGUMENTS.src = "ui-icon #ARGUMENTS.src#" />
		</cfif>
		<cfif ARGUMENTS.class neq "">
			<cfset ARGUMENTS.src = "#ARGUMENTS.src# #ARGUMENTS.class#" />
		</cfif>
		<cfif isDefined("ARGUMENTS.href") or  isDefined("ARGUMENTS.onclick")>
			<cfif isDefined("ARGUMENTS.onclick")>
				<cfset LOCAL.wrap_pre = " onclick=""#ARGUMENTS.onclick#;return false;""" />
			<cfelseif ARGUMENTS.href neq "">
				<cfset LOCAL.wrap_pre = " onclick=""window.location='#ARGUMENTS.href#'""" />
			</cfif>
			<cfset LOCAL.wrap_pre ="<a#LOCAL.wrap_pre#>" />
			<cfset LOCAL.wrap_post ="</a>" />
		</cfif>
		<cfoutput>
		#LOCAL.wrap_pre#<img src="#APPLICATION.PATH.IMG#/trans.gif" class="#ARGUMENTS.src#"<cfif isDefined("ARGUMENTS.title")> title="#ARGUMENTS.title#"</cfif><cfif isDefined("ARGUMENTS.id")> id="#ARGUMENTS.id#"</cfif> <cfif isDefined("ARGUMENTS.style")> style="#ARGUMENTS.style#"</cfif> />#LOCAL.wrap_post#
		</cfoutput>

	<!--- NUMERIC FIELD: TINYINT--->
	<cfelseif ARGUMENTS.type is "tinyint">
		<cfparam name="ARGUMENTS.max" type="numeric" default="255" />
		<cfparam name="ARGUMENTS.min" type="numeric" default="0" />
		<cfparam name="ARGUMENTS.default" default="" />
		<cfparam name="ARGUMENTS.title" type="string" default="Value must be between #ARGUMENTS.min# and #ARGUMENTS.max#" />
		<cfoutput><input type="text" #LOCAL.params# style="text-align: right" onkeypress="return trapKeypress(event, /\d/);" maxlength="3" size="1" title="#ARGUMENTS.title#" onblur="return validateTinyInt(this,#ARGUMENTS.max#,#ARGUMENTS.min#,'#ARGUMENTS.default#');#ARGUMENTS.onblur#" /></cfoutput>
	<!--- NUMERIC FIELD: SMALLINT--->
	<cfelseif ARGUMENTS.type is "smallint">
		<cfparam name="ARGUMENTS.max" type="numeric" default="32767" />
		<cfparam name="ARGUMENTS.min" type="numeric" default="-32767" />
		<cfparam name="ARGUMENTS.default" default="" />
		<cfparam name="ARGUMENTS.title" type="string" default="Value must be between #ARGUMENTS.min# and #ARGUMENTS.max#" />
		<cfoutput><input type="text" #LOCAL.params# style="text-align: right" onkeypress="return trapKeypress(event, /\d/);" maxlength="5" size="2" title="#ARGUMENTS.title#" onblur="return validateSmallInt(this,#ARGUMENTS.max#,#ARGUMENTS.min#,'#ARGUMENTS.default#');#ARGUMENTS.onblur#" /></cfoutput>
	<!--- NUMERIC FIELD: INTEGER--->
	<cfelseif ARGUMENTS.type is "int">
		<cfparam name="ARGUMENTS.max" type="numeric" default="2147483647" />
		<cfparam name="ARGUMENTS.min" type="numeric" default="-2147483647" />
		<cfparam name="ARGUMENTS.default" default="" />
		<cfparam name="ARGUMENTS.title" type="string" default="Value must be between #ARGUMENTS.min# and #ARGUMENTS.max#" />
		<cfoutput><input type="text" #LOCAL.params# style="text-align: right" onkeypress="return trapKeypress(event, /\d/);" maxlength="10" size="6" title="#ARGUMENTS.title#" onblur="return validateInt(this,#ARGUMENTS.max#,#ARGUMENTS.min#,'#ARGUMENTS.default#');#ARGUMENTS.onblur#" /></cfoutput>
	<!--- NUMERIC FIELD: FLOAT--->
	<cfelseif ARGUMENTS.type is "float">
		<cfparam name="ARGUMENTS.max" type="numeric" default="2147483647" />
		<cfparam name="ARGUMENTS.min" type="numeric" default="-2147483647" />
		<cfparam name="ARGUMENTS.title" type="string" default="Value must be between #ARGUMENTS.min# and #ARGUMENTS.max#" />
		<cfif ARGUMENTS.onblur neq "">
			<cfset ARGUMENTS.onblur = "return !validateFloat(this,#ARGUMENTS.max#,#ARGUMENTS.min#) ? false : #ARGUMENTS.onblur#;" />
		<cfelse>
			<cfset ARGUMENTS.onblur = "return validateFloat(this,#ARGUMENTS.max#,#ARGUMENTS.min#)" />
		</cfif>
		<cfoutput><input type="text" #LOCAL.params# style="text-align: right" onkeypress="return trapKeypress(event, /[\d.]/);" maxlength="10" size="6" title="#ARGUMENTS.title#" onblur="#ARGUMENTS.onblur#" /></cfoutput>

	<!---PAGEHEAD--->
	<cfelseif ARGUMENTS.type is "pagehead">
		<cfoutput><div class="bih-pagehead"><img class="bih-pagehead-img" src="#APPLICATION.PATH.IMG#/#ARGUMENTS.src#" /></div></cfoutput>

	<cfelseif ARGUMENTS.type is "pageheadold">
		<cfoutput><img class="pagehead" src="#APPLICATION.PATH.IMG#/#ARGUMENTS.src#" /></cfoutput>

	<!---TEXTAREA--->
	<cfelseif ARGUMENTS.type is "textarea">
		<cfif isDefined("ARGUMENTS.width")>
			<cfset style = "style=#chr(34)#width: #ARGUMENTS.width##chr(34)#">
			<cfset LOCAL.params = LOCAL.params & style>
		<cfelse>
			<cfset style = "">
		</cfif>
		<cfoutput>
		<span style="position:relative">
		<textarea #LOCAL.params# id="#ARGUMENTS.name#"<cfif isDefined("ARGUMENTS.maxlen")>data-maxlen="#ARGUMENTS.maxlen#"  onfocus="textareaMaxLen(this)" onkeyup="textareaMaxLen(this)" onblur="textareaMaxLen(this,1)"</cfif>>#ARGUMENTS.value#</textarea>
		<cfif isDefined("ARGUMENTS.maxlen")>
		<div id="#ARGUMENTS.name#_len" class="textareaMaxLen" style="display:none"></div>
		</cfif>
		</span>
		</cfoutput>

	<!---TIME CONTROL--->
	<cfelseif ARGUMENTS.type is "time">
		<cfoutput><input type="text" #LOCAL.params# value="#udfUserTimeFormat(ARGUMENTS.value)#" size="5" maxlength="#LEN(SESSION.USER.TimeMask)+1#" title="#SESSION.USER.TimeMask#" onblur="return validateTime(this);#ARGUMENTS.onblur#" /></cfoutput>

	<!---TEXT FIELD WITH JUI-ICON BUTTON AT RIGHT--->
	<cfelseif ListFindNoCase("juiText,url,email", ARGUMENTS.type)>
		<cfparam name="ARGUMENTS.name" default="" type="string" />
		<cfparam name="ARGUMENTS.id" default="#ARGUMENTS.name#" type="string" />
		<cfif ARGUMENTS.type is "url">
			<cfparam name="ARGUMENTS.src" default="bih-icon-popout" type="string" />
			<cfparam name="ARGUMENTS.title" default="Open URL" type="string" />
			<cfparam name="ARGUMENTS.onclick" default="openURL(document.getElementById('#ARGUMENTS.id#'));return false;" type="string" />
		</cfif>
		<cfparam name="ARGUMENTS.onclick" default="" type="string" />
		<cfif isDefined("ARGUMENTS.style") and FindNoCase("width",ARGUMENTS.style)>
			<cfset arr = ListToArray(ARGUMENTS.style, ";") />
			<cfloop index="x" from="1" to="#arrayLen(arr)#">
				<cfif trim(ListFirst(arr[x], ":")) eq "width">
					<cfset wide = val(ListLast(arr[x],":"))-16 />
					<cfset arr[x] = "width: #wide#px" />
				</cfif>
			</cfloop>
			<cfset ARGUMENTS.style=ArrayToList(arr, ";") />
		</cfif>
		<cfoutput><span class="bih-icon-field"><input type="text" id="#ARGUMENTS.id#" value="#ARGUMENTS.value#"<cfif isDefined("ARGUMENTS.style")> style="#ARGUMENTS.style#"</cfif> #LOCAL.params# /><img class="bih-icon #ARGUMENTS.src#" src="#APPLICATION.PATH.IMG#/trans.gif" onclick="#ARGUMENTS.onclick#"<cfif isDefined("ARGUMENTS.title")> title="#ARGUMENTS.title#"</cfif> /></span></cfoutput>

	<!---SPACER--->
	<cfelseif ARGUMENTS.type is "spacer">
		<cfoutput><img class="spacer" src="#APPLICATION.PATH.IMG#/trans.gif"/></cfoutput>
	<cfelse>
		<cfoutput><a href="##">udfControl(#ARGUMENTS.type#)</a></cfoutput>
	</cfif>

</cffunction>
</cfcomponent>