<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<!---
	Name         : textarea.cfm
	Author       : Raymond Camden
	Created      : July 11, 2006
	Last Updated : September 15, 2006
	History      : Use id (rkc 9/15/2006)
	Purpose		 : Makes it easier to add a Rich Text Editor, for you wimpy folks who can't write html by hand.
	             : I tell ya - in my day, we wrote our HTML by hand and we liked it gosh darnit. We didn't even
	             : have monitors. We had to write our HTML with punchcards. And our punchcards were made of tissue
	             : paper and would break if you didn't write it exactly right.
--->

<!---
	The following attributes are always passed in. You may not need them for your RTE,
	but they are here for your use.
--->

<!--- Name of the form field. --->
<cfparam name="ATTRIBUTES.fieldname">
<!--- The value to use --->
<cfparam name="ATTRIBUTES.value" default="">
<!--- CSS class of the text area --->
<cfparam name="ATTRIBUTES.class" default="">
<!--- style class of the text area --->
<cfparam name="ATTRIBUTES.style" default="">

<!---
	NOTE: This is where you replace my code with your code. You may want to juse comment out my code
	in case you have to roll back.
--->

<cfoutput>
<textarea name="#ATTRIBUTES.fieldname#" id="#ATTRIBUTES.fieldname#" <cfif len(ATTRIBUTES.class)>class="#ATTRIBUTES.class#"</cfif><cfif len(ATTRIBUTES.style)>style="#ATTRIBUTES.style#"</cfif>>#ATTRIBUTES.value#</textarea>
</cfoutput>

<cfsetting enablecfoutputonly="false" />
<cfexit method="exitTag" />