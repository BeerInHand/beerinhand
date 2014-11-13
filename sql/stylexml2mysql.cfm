<cffunction name="nodeexists" returntype="string" output="false">
	<cfargument name="node" type="any" required="true">
	<cfargument name="fld" type="string" required="true">
	<cfif structKeyExists(node, fld)>
		<cfreturn node[fld].xmltext>
	</cfif>
	<cfreturn "">
</cffunction>
<cffunction name="subnodeexists" returntype="string" output="false">
	<cfargument name="node" type="any" required="true">
	<cfargument name="subnode" type="any" required="true">
	<cfargument name="fld" type="string" required="true">
	<cfif structKeyExists(node, subnode)>
		<cfif structKeyExists(node[subnode], fld)>
			<cfreturn node[subnode][fld].xmltext>
		</cfif>
	</cfif>
	<cfreturn 0>
</cffunction>

<cfif isDefined("url.rebuild")>
	<cffile action="READ" file="C:\Inetpub\wwwroot\beerinhand\styleguide2008.xml" variable="xmlcontent"/>
	<cfset LOCAL = {}>
	<cfset REC = {}>
	<cfset LOCAL.doc = XMLParse(xmlcontent)/>
	<!--- <cfdump var="#LOCAL.doc#">
	<cfabort>--->
	<cfoutput>
	<cfloop from="1" to="#arrayLen(LOCAL.doc.styleguide.class)#" index="LOCAL.loopH">
		<cfset LOCAL.class = LOCAL.doc.styleguide.class[LOCAL.loopH]>
		<cfloop from="1" to="#arrayLen(LOCAL.class.category)#" index="LOCAL.loopI">
			<cfset LOCAL.category = LOCAL.class.category[LOCAL.loopI]>
			<cfloop from="1" to="#arrayLen(LOCAL.category.subcategory)#" index="LOCAL.loopJ">
				<cfset LOCAL.subcategory = LOCAL.category.subcategory[LOCAL.loopJ]>
				#LOCAL.category.name.XmlText# &nbsp;&nbsp;&nbsp; #LOCAL.subcategory.name.xmltext# <br>
				<cfset REC.style = LOCAL.category.name.XmlText>
				<cfset REC.id = LOCAL.category.xmlattributes.id>
				<cfset REC.substyle = LOCAL.subcategory.name.XmlText>
				<cfset REC.subid = LOCAL.subcategory.xmlattributes.id>
				<cfset REC.aroma = nodeexists(LOCAL.subcategory, "aroma")>
				<cfset REC.appearance = nodeexists(LOCAL.subcategory, "appearance")>
				<cfset REC.flavor = nodeexists(LOCAL.subcategory, "flavor")>
				<cfset REC.mouthfeel = nodeexists(LOCAL.subcategory, "mouthfeel")>
				<cfset REC.impression = nodeexists(LOCAL.subcategory, "impression")>
				<cfset REC.ingredients = nodeexists(LOCAL.subcategory, "ingredients")>
				<cfset REC.examples = nodeexists(LOCAL.subcategory, "examples")>
				<cfset REC.history = nodeexists(LOCAL.subcategory, "history")>
				<cfset REC.comments = nodeexists(LOCAL.subcategory, "comments")>
				<cfset REC.varieties = nodeexists(LOCAL.subcategory, "varieties")>
				<cfset REC.exceptions = nodeexists(LOCAL.subcategory, "exceptions")>

				<cfset LOCAL.stats = LOCAL.subcategory.stats>

				<cfset REC.og_min = subnodeexists(LOCAL.stats, "og", "low")>
				<cfset REC.og_max = subnodeexists(LOCAL.stats, "og", "high")>

				<cfset REC.fg_min = subnodeexists(LOCAL.stats, "fg", "low")>
				<cfset REC.fg_max = subnodeexists(LOCAL.stats, "fg", "high")>

				<cfset REC.ibu_max = subnodeexists(LOCAL.stats, "ibu", "high")>
				<cfset REC.ibu_min = subnodeexists(LOCAL.stats, "ibu", "low")>

				<cfset REC.srm_max = subnodeexists(LOCAL.stats, "srm", "high")>
				<cfset REC.srm_min = subnodeexists(LOCAL.stats, "srm", "low")>

				<cfset REC.abv_max = subnodeexists(LOCAL.stats, "abv", "high")>
				<cfset REC.abv_min = subnodeexists(LOCAL.stats, "abv", "low")>

				<cfquery name="insStyle" datasource="bih">
					insert into bjcpstyles (st_category, st_style, st_subcategory, st_substyle,
							st_og_min, st_og_max, st_fg_min, st_fg_max, st_ibu_min, st_ibu_max, st_srm_min, st_srm_max, st_abv_min, st_abv_max,
							st_aroma, st_appearance, st_flavor, st_mouthfeel, st_impression, st_ingredients, st_examples, st_history, st_comments, st_varieties, st_exceptions)
					values (
						'#rec.id#','#REC.style#','#REC.subid#','#REC.substyle#',
						'#REC.og_min#','#REC.og_max#','#REC.fg_min#','#REC.fg_max#','#REC.ibu_min#','#REC.ibu_max#','#REC.srm_min#','#REC.srm_max#','#REC.abv_min#','#REC.abv_max#',
						'#REC.aroma#','#REC.appearance#','#REC.flavor#','#REC.mouthfeel#','#REC.impression#','#REC.ingredients#',
						'#REC.examples#','#REC.history#','#REC.comments#','#REC.varieties#','#REC.exceptions#'
					)
				</cfquery>
				#rec.id# #rec.subid#<br />
			</cfloop>
		</cfloop>
	</cfloop>
	</cfoutput>
</cfif>
<cfquery name="qryBJCPStyles" datasource="bih">
   select * from bjcpstyles order by st_substyle
</cfquery>
<cfinvoke component="#APPLICATION.MAP.CFC#.util.UDF" method="makeIndex" returnvariable="idxBJCPStyles" qry="#qryBJCPStyles#" fld="st_substyle"/>
<cfoutput>
<script>
	qryBJCPStyles = #SerializeJSON(qryBJCPStyles)#;
	idxBJCPStyles = #idxBJCPStyles#;
</script>
</cfoutput>

update bjcpstyles set st_type = 'Lager' where st_category in (1,2,3,4,5)
update bjcpstyles set st_type = 'Ale' where st_type = ''
update bjcpstyles set st_substyle = 'Düsseldorf Altbier' where st_stid = 24
update bjcpstyles set st_style = 'India Pale Ale' where st_category  = 14
update bjcpstyles set st_substyle = 'Winter Spiced Beer' where st_stid = 76
update bjcpstyles set st_substyle = 'Weizen' where st_stid = 51

update bjcpstyles set st_substyle = 'Ordinary Bitter' where st_stid = 25
update bjcpstyles set st_substyle = 'Best Bitter' where st_stid = 26
update bjcpstyles set st_substyle = 'Extra Special Bitter' where st_stid = 27


insert into bjcpstyles (st_category, st_style, st_subcategory, st_substyle, st_og_min, st_og_max, st_fg_min, st_fg_max, st_ibu_min, st_ibu_max, st_srm_min, st_srm_max, st_abv_min, st_abv_max, st_aroma, st_appearance, st_flavor, st_mouthfeel, st_impression, st_ingredients, st_examples, st_history, st_comments, st_varieties, st_exceptions)
select st_category, st_style, st_subcategory, 'American Rye', st_og_min, st_og_max, st_fg_min, st_fg_max, st_ibu_min, st_ibu_max, st_srm_min, st_srm_max, st_abv_min, st_abv_max, st_aroma, st_appearance, st_flavor, st_mouthfeel, st_impression, st_ingredients, st_examples, st_history, st_comments, st_varieties, st_exceptions
from bjcpstyles
where st_stid = 21

update bjcpstyles set st_substyle = 'American Wheat' where st_stid = 21

insert into bjcpstyles (st_category, st_style, st_subcategory, st_substyle, st_og_min, st_og_max, st_fg_min, st_fg_max, st_ibu_min, st_ibu_max, st_srm_min, st_srm_max, st_abv_min, st_abv_max, st_aroma, st_appearance, st_flavor, st_mouthfeel, st_impression, st_ingredients, st_examples, st_history, st_comments, st_varieties, st_exceptions)
select st_category, st_style, st_subcategory, 'Märzen', st_og_min, st_og_max, st_fg_min, st_fg_max, st_ibu_min, st_ibu_max, st_srm_min, st_srm_max, st_abv_min, st_abv_max, st_aroma, st_appearance, st_flavor, st_mouthfeel, st_impression, st_ingredients, st_examples, st_history, st_comments, st_varieties, st_exceptions
from bjcpstyles
where st_stid = 10

update bjcpstyles set st_substyle = 'Oktoberfest' where st_stid = 10

insert into bjcpstyles (st_category, st_style, st_subcategory, st_substyle, st_og_min, st_og_max, st_fg_min, st_fg_max, st_ibu_min, st_ibu_max, st_srm_min, st_srm_max, st_abv_min, st_abv_max, st_aroma, st_appearance, st_flavor, st_mouthfeel, st_impression, st_ingredients, st_examples, st_history, st_comments, st_varieties, st_exceptions)
select st_category, st_style, st_subcategory, 'Maibock', st_og_min, st_og_max, st_fg_min, st_fg_max, st_ibu_min, st_ibu_max, st_srm_min, st_srm_max, st_abv_min, st_abv_max, st_aroma, st_appearance, st_flavor, st_mouthfeel, st_impression, st_ingredients, st_examples, st_history, st_comments, st_varieties, st_exceptions
from bjcpstyles
where st_stid = 14

update bjcpstyles set st_substyle = 'Helles Bock' where st_stid = 14

