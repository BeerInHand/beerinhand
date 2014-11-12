<cfsetting enablecfoutputonly = true />

<cfif structKeyExists(form, "didit")>
	<cfset threads = APPLICATION.FORUM.Thread.getThreads()>
	<cfloop query="threads.data">
		<cfset APPLICATION.FORUM.Thread.updateStats(id)>
	</cfloop>
</cfif>


<cfmodule template="../tags/layout.cfm" templatename="admin" title="Reset Stats">

<cfoutput>
<div class="clearer"></div>
<div class="bubbleHead">
	<p class="red bold">
	<cfif not structKeyExists(form, "didit")>
		Galleon keeps track of stats for threads, forums, and conferences in simple columns to help minimize the amount of work necessary to track stats. (I.e., the number of messages in a thread, last poster to a thread, etc.)
		It is possible that these stats could become corrupt and not accurately reflect the true values in the database. Clicking the button below will cause Galleon to rescan the database and update everything to it's most
		up to date value. <b>This can be slow and should only be used when necessary.</b>
	<cfelse>
		Values have been updated.
	</cfif>
	</p>
<div class="clearer"></div>
</div>

<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<div class="row_0">
<p>
<input type="submit" name="didit" value="Begin Reset">
</p>
</div>

</form>
</cfoutput>


</cfmodule>

<cfsetting enablecfoutputonly = false />
