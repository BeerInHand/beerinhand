	<cfset APPLICATION.CFC.Factory = CreateObject("component","#APPLICATION.MAP.CFC#.objectfactory").init() />
	<!--- DATA DRIVEN CFCS --->
	<cfset APPLICATION.CFC.Users = APPLICATION.CFC.Factory.get("Users") />
	<cfset APPLICATION.CFC.Recipe = APPLICATION.CFC.Factory.get("Recipe") />
	<cfset APPLICATION.CFC.RecipeGrains = APPLICATION.CFC.Factory.get("RecipeGrains") />
	<cfset APPLICATION.CFC.RecipeHops = APPLICATION.CFC.Factory.get("RecipeHops") />
	<cfset APPLICATION.CFC.RecipeYeast = APPLICATION.CFC.Factory.get("RecipeYeast") />
	<cfset APPLICATION.CFC.RecipeMisc = APPLICATION.CFC.Factory.get("RecipeMisc") />
	<cfset APPLICATION.CFC.RecipeDates = APPLICATION.CFC.Factory.get("RecipeDates") />
	<!--- UTILITY PROVIDING CFCS --->
	<cfset APPLICATION.CFC.GlobalUDF = APPLICATION.CFC.Factory.get("globalUDF") />
	<cfset APPLICATION.CFC.Controls = APPLICATION.CFC.Factory.get("controls") />
	<cfset APPLICATION.CFC.Javascript = APPLICATION.CFC.Factory.get("javascript") />