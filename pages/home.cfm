<div style="width: 520px;" class="fleft">
	<h1>What is BeerInHand?</h1>
	<p>It's a beer blog. It's a beer recipe calculator.  It's a social network for brewers.  It's an online database to store your brewing sessions and tasting notes.  It's your brew home on the internet.</p>

	<p>Signing up for BeerInHand makes you part of an exciting online brewing community. When you sign up, you'll get a personal BIH page where you can create and share beer recipes, blog about beer and brewing, and network with like-minded brewers.</p>

	<h3>Dive Right In</h3>
	<p>In a hurry to see some recipes? <a href="http://www.beerinhand.com/Boneyard/recipes/p.brewer.cfm">Here's a link to an active account.</a></p>

	<h3>This Past Week</h3>
	<cfoutput>
		<cfquery name="qryStats" datasource="#APPLICATION.DSN.MAIN#">
			SELECT COUNT(*) AS cnt
			  FROM users
			 WHERE us_added > DATE_SUB(NOW(), INTERVAL 90 DAY)
		</cfquery>
	<p>#udfAddSWithCnt("new Brewer", qryStats.cnt)# have signed up for BeerInHand.</p>
		<cfquery name="qryStats" datasource="#APPLICATION.DSN.MAIN#">
			SELECT COUNT(*) AS cntRcp, COUNT(DISTINCT re_style) AS cntStyle, COUNT(DISTINCT re_usid) AS cntBrewer
			  FROM recipe
			 WHERE re_added > DATE_SUB(NOW(), INTERVAL 90 DAY)
		</cfquery>
	<p>#udfAddSWithCnt("new Recipe", qryStats.cntRcp)# have been added to #udfAddSWithCnt("Style Category", qryStats.cntStyle)# by #udfAddSWithCnt("Brewer", qryStats.cntBrewer)#.</p>
		<cfquery name="qryStats" datasource="#APPLICATION.DSN.MAIN#">
			SELECT COUNT(*) AS cntRcp, COUNT(DISTINCT re_style) AS cntStyle, COUNT(DISTINCT re_usid) AS cntBrewer, SUM(ConvertVolume(re_vunits, re_volume, "Gallons")) AS amtBrewed
			  FROM recipe
			 WHERE re_brewed > DATE_SUB(NOW(), INTERVAL 90 DAY)
		</cfquery>
	<p>#udfAddSWithCnt("Gallon", qryStats.amtBrewed)# of beer were brewed in #udfAddSWithCnt("Style Category", qryStats.cntStyle)# by #udfAddSWithCnt("Brewer", qryStats.cntBrewer)# in #udfAddSWithCnt("Batch", qryStats.cntRcp, "es")#.</p>
	</cfoutput>
</div>
<div class="fright">
	<br>
	<cfinclude template="signup.cfm">
</div>