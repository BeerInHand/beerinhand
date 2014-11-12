<cffunction name="setDefault" access="public" returntype="string" output="false">
	<cfargument name="inVal" type="string" required="true" />
	<cfargument name="inDef" type="string" required="false" default="&nbsp;" />
	<cfif Trim(ARGUMENTS.inVal) is ""><cfreturn ARGUMENTS.inDef /></cfif>
	<cfreturn ARGUMENTS.inVal />
</cffunction>
<cffunction name="convertTemp" access="public" returntype="string" output="false">
	<cfargument name="inU" type="string" required="true" />
	<cfargument name="inT" type="numeric" required="true" />
	<cfargument name="outU" type="string" required="true" />
	<cfif ARGUMENTS.inU eq ARGUMENTS.outU><cfreturn ARGUMENTS.inT /></cfif>
	<cfif ARGUMENTS.inU eq "f"><cfreturn (ARGUMENTS.inT-32)/1.8 /></cfif>
	<cfreturn ARGUMENTS.inT * 1.8 + 32 />
</cffunction>
<cffunction name="convertVolume" access="public" returntype="string" output="false">
	<cfargument name="UnitsIn" type="string" required="true" />
	<cfargument name="VolumeIn" type="numeric" required="true" />
	<cfargument name="UnitsOut" type="string" required="true" />
	<cfset LOCAL.LitersConvert = {Barrels=117.347772,Hectoliters=100,"Imp Gallons"=4.54609,Gallons=3.785412,Liters=1,Quarts=0.946353,Pints=0.4731765,Cups=0.2365883,Ounces=0.0295735,"Imp Ounces"=0.0284131,Tablespoons=0.0147868,Teaspoons=0.0049289} />
	<cfif ARGUMENTS.UnitsIn eq ARGUMENTS.UnitsOut><cfreturn ARGUMENTS.VolumeIn /></cfif>
	<cfreturn ARGUMENTS.VolumeIn * LOCAL.LitersConvert[ARGUMENTS.UnitsIn] / LOCAL.LitersConvert[ARGUMENTS.UnitsOut] />
</cffunction>
<cffunction name="convertWeight" access="public" returntype="string" output="false">
	<cfargument name="UnitsIn" type="string" required="true" />
	<cfargument name="WeightIn" type="numeric" required="true" />
	<cfargument name="UnitsOut" type="string" required="true" />
	<cfset LOCAL.GramsConvert={Kg=1000,Lbs=453.59237,Ounces=28.3495231,Grams=1} />
	<cfif ARGUMENTS.UnitsIn eq ARGUMENTS.UnitsOut><cfreturn ARGUMENTS.WeightIn /></cfif>
	<cfreturn ARGUMENTS.WeightIn * LOCAL.GramsConvert[ARGUMENTS.UnitsIn] / LOCAL.GramsConvert[ARGUMENTS.UnitsOut] />
</cffunction>
<cffunction name="convertGravity" access="public" returntype="string" output="false">
	<cfargument name="UnitsIn" type="string" required="true" />
	<cfargument name="GravityIn" type="numeric" required="true" />
	<cfargument name="UnitsOut" type="string" required="true" />
	<cfif ARGUMENTS.UnitsIn eq ARGUMENTS.UnitsOut || ARGUMENTS.GravityIn EQ 0><cfreturn ARGUMENTS.GravityIn /></cfif>
	<cfif ARGUMENTS.UnitsIn eq "SG"><cfreturn (260 - 260 / ARGUMENTS.GravityIn) /></cfif>
	<cfreturn (260 / (260 - ARGUMENTS.GravityIn)) />
</cffunction>
<cffunction name="fixUnitsW" access="public" returntype="string" output="false">
	<cfargument name="inUnit" type="string" required="true" />
	<cfif ARGUMENTS.inUnit eq "kg"><cfreturn "Kg"/></cfif>
	<cfif ARGUMENTS.inUnit eq "lb"><cfreturn "Lbs"/></cfif>
	<cfif ARGUMENTS.inUnit eq "oz"><cfreturn "Ounces"/></cfif>
	<cfif ARGUMENTS.inUnit eq "g"><cfreturn "Grams"/></cfif>
	<cfreturn "Kg" />
</cffunction>
<cffunction name="fixUnitsV" access="public" returntype="string" output="false">
	<cfargument name="inUnit" type="string" required="true" />
	<cfif ARGUMENTS.inUnit eq "gal"><cfreturn "Gallons"/></cfif>
	<cfif ARGUMENTS.inUnit eq "l"><cfreturn "Liters"/></cfif>
	<cfif ARGUMENTS.inUnit eq "qt"><cfreturn "Quarts"/></cfif>
	<cfif ARGUMENTS.inUnit eq "pt"><cfreturn "Pints"/></cfif>
	<cfif ARGUMENTS.inUnit eq "cup"><cfreturn "Cups"/></cfif>
	<cfif ARGUMENTS.inUnit eq "oz"><cfreturn "Ounces"/></cfif>
	<cfif ARGUMENTS.inUnit eq "tblsp"><cfreturn "Tablespoons"/></cfif>
	<cfif ARGUMENTS.inUnit eq "tsp"><cfreturn "Teaspoons"/></cfif>
	<cfif ARGUMENTS.inUnit eq "ml"><cfreturn "Milliliters"/></cfif>
	<cfreturn "Liters" />
</cffunction>
<cffunction name="ReadKey" access="public" returntype="string" output="false">
	<cfargument name="inS" type="any" required="true" />
	<cfargument name="inK" type="string" required="true" />
	<cfargument name="inDef" type="any" required="false" default="" />
	<cfif StructKeyExists(ARGUMENTS.inS, ARGUMENTS.inK)><cfreturn setDefault(ARGUMENTS.inS[ARGUMENTS.inK].xmlText,ARGUMENTS.inDef) /></cfif>
	<cfreturn ARGUMENTS.inDef />
</cffunction>
<cffunction name="fixHopWhen" access="public" returntype="string" output="false">
	<cfargument name="inWhen" type="string" required="true" />
	<cfif ARGUMENTS.inWhen eq "Dry Hop"><cfreturn "Dry"/></cfif>
	<cfif ARGUMENTS.inWhen eq "First Wort"><cfreturn "Fwh"/></cfif>
	<cfif ARGUMENTS.inWhen eq "Aroma"><cfreturn "Boil"/></cfif>
	<cfreturn ARGUMENTS.inWhen />
</cffunction>
<cffunction name="fixHopForm" access="public" returntype="string" output="false">
	<cfargument name="inForm" type="string" required="true" />
	<cfif ARGUMENTS.inForm eq "Leaf"><cfreturn "Whole"/></cfif>
	<cfreturn ARGUMENTS.inForm />
</cffunction>
<cffunction name="fixMiscUse" access="public" returntype="string" output="false">
	<cfargument name="inUse" type="string" required="true" />
	<cfif ARGUMENTS.inUse eq "Boil"><cfreturn "Boil"/></cfif>
	<cfif ARGUMENTS.inUse eq "Mash"><cfreturn "Mash"/></cfif>
	<cfif ARGUMENTS.inUse eq "Bottling"><cfreturn "Package"/></cfif>
	<cfreturn "Ferment" />
</cffunction>
<cffunction name="fixYeastFloc" access="public" returntype="string" output="false">
	<cfargument name="inS" type="string" required="true" />
	<cfif ARGUMENTS.inS eq "0"><cfreturn "Low"/></cfif>
	<cfif ARGUMENTS.inS eq "1"><cfreturn "Medium"/></cfif>
	<cfif ARGUMENTS.inS eq "2"><cfreturn "High"/></cfif>
	<cfif ARGUMENTS.inS eq "3"><cfreturn "Very High"/></cfif>
	<cfreturn ARGUMENTS.inS />
</cffunction>
<cffunction name="fixYeastType" access="public" returntype="string" output="false">
	<cfargument name="inS" type="string" required="true" />
	<cfif ARGUMENTS.inS eq "0"><cfreturn "Ale"/></cfif>
	<cfif ARGUMENTS.inS eq "1"><cfreturn "Lager"/></cfif>
	<cfif ARGUMENTS.inS eq "2"><cfreturn "Wine"/></cfif>
	<cfif ARGUMENTS.inS eq "3"><cfreturn "Champagne"/></cfif>
	<cfif ARGUMENTS.inS eq "4"><cfreturn "Wheat"/></cfif>
	<cfreturn ARGUMENTS.inS />
</cffunction>
<cffunction name="fixYeastForm" access="public" returntype="string" output="false">
	<cfargument name="inS" type="string" required="true" />
	<cfif ARGUMENTS.inS eq "0"><cfreturn "Liquid"/></cfif>
	<cfif ARGUMENTS.inS eq "1"><cfreturn "Dry"/></cfif>
	<cfif ARGUMENTS.inS eq "2"><cfreturn "Slant"/></cfif>
	<cfif ARGUMENTS.inS eq "3"><cfreturn "Culture"/></cfif>
	<cfreturn ARGUMENTS.inS />
</cffunction>