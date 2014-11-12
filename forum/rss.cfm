<cfsetting enablecfoutputonly=true showdebugoutput=false>
<!---
	Name         : rss.cfm
	Author       : Raymond Camden
	Created      : July 5, 2004
	Last Updated : November 10, 2007
	History      : Reset for V2
				 : security fix (rkc 11/10/07)
	Purpose		 : Displays RSS for a Conference
--->

<cfif not isDefined("URL.conferenceid") or not len(URL.conferenceid)>
	<cflocation url="f.index.cfm" addToken="false">
</cfif>

<!--- get parent conference --->
<cftry>
	<cfset REQUEST.conference = APPLICATION.FORUM.Conference.getConference(URL.conferenceid)>
	<cfcatch>
		<cflocation url="f.index.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfif not APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, URL.conferenceid, REQUEST.udf.getGroups())>
	<cfabort>
</cfif>

<cfif structKeyExists(APPLICATION.FORUM.rssCache, URL.conferenceid) and dateCompare(APPLICATION.FORUM.rssCache[URL.conferenceid].created, REQUEST.conference.lastpostcreated) is 1>
	<cfcontent type="text/xml"><cfoutput>#APPLICATION.FORUM.rssCache[URL.conferenceid].content#</cfoutput><cfabort>
</cfif>

<!--- get my latest posts --->
<cfset data = APPLICATION.FORUM.Conference.getLatestPosts(conferenceid=URL.conferenceid)>

<cfsavecontent variable="rss">
<cfoutput><?xml version="1.0" encoding="iso-8859-1"?>

<rdf:RDF
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##"
	xmlns:dc="http://pURL.org/dc/elements/1.1/"
	xmlns="http://pURL.org/rss/1.0/"
>

	<channel rdf:about="#APPLICATION.PATH.ROOT#/forum">
	<title>#APPLICATION.FORUM.SETTING.title# : Conference : #REQUEST.conference.name#</title>
	<description>Conference : #REQUEST.conference.name# : #REQUEST.conference.description#</description>
	<link>#APPLICATION.PATH.ROOT#/forum</link>

	<items>
		<rdf:Seq>
			<cfloop query="data">
				<cfif APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, forumidfk, REQUEST.udf.getGroups()) and
					  APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, conferenceidfk, REQUEST.udf.getGroups())>
				<rdf:li rdf:resource="#APPLICATION.PATH.ROOT#/f.messages.cfm?#xmlFormat("threadid=#threadid#")##xmlFormat("&r=#currentRow#")#" />
				</cfif>
			</cfloop>
		</rdf:Seq>
	</items>

	</channel>

	<cfloop query="data">
		<cfif APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, forumidfk, REQUEST.udf.getGroups()) and
			  APPLICATION.FORUM.Permission.allowed(APPLICATION.FORUM.Rights.CANVIEW, conferenceidfk, REQUEST.udf.getGroups())>

			<cfset dateStr = dateFormat(posted,"yyyy-mm-dd")>
			<cfset z = getTimeZoneInfo()>
			<cfset dateStr = dateStr & "T" & timeFormat(posted,"HH:mm:ss") & "-" & numberFormat(z.utcHourOffset,"00") & ":00">

			<item rdf:about="#APPLICATION.PATH.ROOT#/f.messages.cfm?#xmlFormat("threadid=#threadid#")##xmlFormat("&r=#currentRow#")#">
			<title>#xmlFormat(title)#</title>
			<description>#xmlFormat(body)#</description>
			<link>#APPLICATION.PATH.ROOT#/f.messages.cfm?#xmlFormat("threadid=#threadid#")##xmlFormat("&r=#currentRow#")#</link>
			<dc:date>#dateStr#</dc:date>
			<dc:subject>#thread#</dc:subject>
			</item>

		</cfif>

	</cfloop>

</rdf:RDF>
</cfoutput>
</cfsavecontent>

<cfset APPLICATION.FORUM.rssCache[URL.conferenceid] = structNew()>
<cfset APPLICATION.FORUM.rssCache[URL.conferenceid].created = now()>
<cfset APPLICATION.FORUM.rssCache[URL.conferenceid].content = rss>

<cfcontent type="text/xml"><cfoutput>#rss#</cfoutput>

<cfsetting enablecfoutputonly=false>
