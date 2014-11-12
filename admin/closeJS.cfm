<!---
<cfset allbih = "" />
<cfset fileList = "bih.js,bjcpstyles.js,brewlog.js,calc.js,explorer.js,grains.js,helper.js,hops.js,login.js,misc.js,recipe.js,settings.js,yeast.js" />
<cfloop list="#fileList#" index="idx">
	<cffile action="read" file="C:\Inetpub\wwwroot\beerinhand\js\#idx#" variable="js" />
	<cfset allbih = allbih & chr(13) & js />
</cfloop>
<cffile action="write" file="C:\Inetpub\wwwroot\beerinhand\js\all.js" output="#allbih#">
--->

<cfhttp method="post" url="http://closure-compiler.appspot.com/compile" result="RTN">
	<cfhttpparam type="header" name="Content-type" value="application/x-www-form-urlencoded">
	<cfhttpparam type="url" name="code_url" value="http://www.beerinhand.com/js/helper.js">
	<cfhttpparam type="url" name="code_url" value="http://www.beerinhand.com/js/bih.js">
	<cfhttpparam type="url" name="code_url" value="http://www.beerinhand.com/js/bjcpstyles.js">
	<cfhttpparam type="url" name="code_url" value="http://www.beerinhand.com/js/brewlog.js">
	<cfhttpparam type="url" name="code_url" value="http://www.beerinhand.com/js/calc.js">
	<cfhttpparam type="url" name="code_url" value="http://www.beerinhand.com/js/explorer.js">
	<cfhttpparam type="url" name="code_url" value="http://www.beerinhand.com/js/grains.js">
	<cfhttpparam type="url" name="code_url" value="http://www.beerinhand.com/js/hops.js">
	<cfhttpparam type="url" name="code_url" value="http://www.beerinhand.com/js/misc.js">
	<cfhttpparam type="url" name="code_url" value="http://www.beerinhand.com/js/recipe.js">
	<cfhttpparam type="url" name="code_url" value="http://www.beerinhand.com/js/settings.js">
	<cfhttpparam type="url" name="code_url" value="http://www.beerinhand.com/js/yeast.js">
	<cfhttpparam type="url" name="output_info" value="compiled_code">
	<cfhttpparam type="url" name="output_info" value="errors">
	<cfhttpparam type="url" name="output_info" value="statistics">
	<cfhttpparam type="url" name="output_info" value="warnings">
	<cfhttpparam type="url" name="compilation_level" value="SIMPLE_OPTIMIZATIONS">
	<cfhttpparam type="url" name="warning_level" value="VERBOSE">
	<cfhttpparam type="url" name="output_format" value="JSON">
	<cfhttpparam type="url" name="externs_url" value="http://closure-compiler.googlecode.com/svn/trunk/contrib/externs/jquery-1.7.js">
</cfhttp>
<cfdump var="#RTN#">
<cfset JSON = DeSerializeJSON(RTN.filecontent) />
<cfdump var="#JSON#">
<cffile action="write" file="C:\Inetpub\wwwroot\beerinhand\js\all.js" output="#JSON.compiledCode#">
