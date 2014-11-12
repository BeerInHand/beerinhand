<cfsetting enablecfoutputonly = true />
<!--- Number of items per page and tracker variable. --->
<cfparam name="ATTRIBUTES.mode" default="na"><!--- used to determine if we show thread buttons --->
<cfparam name="ATTRIBUTES.canpost" default="true"><!--- used to determine if we show a new topic --->
<cfparam name="ATTRIBUTES.showbuttons" default="true"><!--- used to determine if we show buttons --->
<cfparam name="URL.page" default=1><!--- what page am I on? --->
<cfif not isNumeric(URL.page) or URL.page lte 0>
	<cfset URL.page = 1>
</cfif>
<cfparam name="ATTRIBUTES.pages"><!--- how many pages do I have? --->
<cfoutput>
<!-- Pages and Button Start -->
<div id="pages_btn">
	<cfif ATTRIBUTES.showbuttons>
		<div class="top_btn"><!-- Top Button Start -->
			<cfif (ATTRIBUTES.mode is "threads" or ATTRIBUTES.mode is "messages") and ATTRIBUTES.canpost>
				<a href="f.newpost.cfm?forumid=#REQUEST.forum.id#"><img src="forum/images/btn_new_topic.gif" alt="New Topic" title="New Topic"/></a>
				<cfif ATTRIBUTES.mode is "messages">
					<cfif not SESSION.LoggedIn>
						<cfset thisPage = CGI.script_name & "?" & CGI.query_string & "&##newpost">
						<cfset link = "login.cfm?ref=#urlEncodedFormat(thisPage)#">
						<a href="#link#"><img src="forum/images/btn_reply.gif" alt="Reply" title="Reply"/></a>
					<cfelse>
						<a href="##newpost"><img src="forum/images/btn_reply.gif" alt="Reply" title="Reply"/></a>
					</cfif>
				</cfif>
			</cfif>
			<cfif SESSION.LoggedIn and ATTRIBUTES.mode is not "na">
				<a href="f.subscriptions.cfm?#CGI.query_string#&s=1"><img src="forum/images/btn_subscribe.gif" alt="Subscribe" title="Subscribe"/></a>
			</cfif>
		</div>
		<!-- Top Button Ender -->
		</cfif>

		<!-- Pages Start -->
		<div class="pages">
			<cfset qs = reReplaceNoCase(CGI.query_string,"\&*page=[^&]*","")>
			<cfif URL.page is ATTRIBUTES.pages>
				<img src="forum/images/arrow_right_grey.gif" alt="Next Page"/>
			<cfelse>
				<a href="#CGI.script_name#?#qs#&page=#URL.page+1#"><img src="forum/images/arrow_right_active.gif" alt="Next Page"/></a>
			</cfif>
			<p>
				<cfif ATTRIBUTES.pages gt 10>
					<select onChange="document.location.href=this.options[this.selectedIndex].value">
						<cfloop index="x" from=1 to="#ATTRIBUTES.pages#">
							<option value="#CGI.script_name#?#qs#&page=#x#" <cfif URL.page is x>selected</cfif>>Page #x#</option>
						</cfloop>
					</select>
				<cfelse>
				<cfloop index="x" from=1 to="#ATTRIBUTES.pages#">
					<cfif URL.page is not x><a href="#CGI.script_name#?#qs#&page=#x#">#x#</a><cfelse>#x#</cfif>
				</cfloop>
				</cfif>
			</p>
			<cfif URL.page is 1>
				<img src="forum/images/arrow_left_grey.gif" alt="Previous Page"/>
			<cfelse>
				<a href="#CGI.script_name#?#qs#&page=#URL.page-1#"><img src="forum/images/arrow_left_active.gif" alt="Previous Page"/></a>
			</cfif>
		</div>
		<!-- Pages Ender -->

	</div>
<!-- Pages and Button Ender -->

</cfoutput>

<cfsetting enablecfoutputonly = false />

<cfexit method="EXITTAG">