<cfcomponent output="false" extends="explorer">

	<cfset init() />

	<cffunction name="init" returntype="recipe" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfset THIS.table = "recipe" />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryRecipe" access="public" returnType="query" output="false">
		<cfargument name="re_reid" type="numeric" required="false" />
		<cfargument name="re_usid" type="numeric" required="false" />
		<cfargument name="list_reid" type="string" required="false" />
		<cfargument name="sort" type="string" default="re_dla" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryRecipe" datasource="#THIS.dsn#">
			SELECT re_reid, re_usid, re_name, re_volume, re_boilvol, re_style, re_eff, re_expgrv, re_expsrm, re_expibu, re_vunits, re_munits, re_hunits, re_tunits, re_brewed, re_type, re_mashtype, re_notes, re_mash, re_prime, re_grnamt, re_mashamt, re_hopamt, re_hopcnt, re_grncnt, re_eunits, re_privacy, re_dla,
					 CalculateABV(re_eunits, re_expgrv, 0) AS re_expabv
			  FROM recipe
			 WHERE 0=0
			<cfif StructKeyExists(ARGUMENTS, "re_reid")>
				AND re_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_reid#" />
			<cfelseif isDefined("ARGUMENTS.list_reid")>
				AND re_reid IN (<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.list_reid#" list="true" />)
			</cfif>
			<cfif StructKeyExists(ARGUMENTS, "re_usid")>
				AND re_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
			</cfif>
			 ORDER BY <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.sort#" />
		</cfquery>
		<cfreturn LOCAL.qryRecipe />
	</cffunction>

	<cffunction name="QueryBrewLog" access="public" returntype="query">
		<cfargument name="re_usid" type="numeric" default="0" />
		<cfset var LOCAL = StructNew() />
		<cfquery name="LOCAL.qryBrewLog" datasource="#THIS.dsn#">
			SELECT re_reid, re_name, re_style, re_brewed, re_volume, re_vunits, re_expgrv, re_eunits, re_privacy, re_expsrm, re_expibu, re_eff, re_munits, re_hunits
			  FROM recipe
			 WHERE re_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
			 	AND IF(re_usid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#udfIfDefined('SESSION.USER.usid',0)#" />, 0, re_privacy) < 2
			 ORDER BY IFNULL(re_brewed,re_dla) DESC, re_name
		</cfquery>
		<cfreturn LOCAL.qryBrewLog />
	</cffunction>

	<cffunction name="QueryFavorites" access="public" returntype="query">
		<cfargument name="re_usid" type="numeric" default="0" />
		<cfset var LOCAL = StructNew() />
		<cfquery name="LOCAL.qryFavorites" datasource="#THIS.dsn#">
			SELECT *
			  FROM FavoriteLog
			 WHERE fr_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
			 ORDER BY fr_dla DESC, re_brewer
		</cfquery>
		<cfreturn LOCAL.qryFavorites />
	</cffunction>

	<cffunction name="QueryDateGrouping" access="public" returntype="query">
		<cfargument name="re_usid" type="numeric" required="true" />
		<cfquery name="LOCAL.qryDateGroups" datasource="#THIS.dsn#">
			SELECT YEAR(re_brewed) AS re_year,LPAD(CONVERT(MONTH(re_brewed),CHAR),2,"0") AS re_month, COUNT(*) AS cntRows
			  FROM recipe
			 WHERE re_brewed IS NOT NULL
				AND re_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
				AND IF(re_usid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#udfIfDefined('SESSION.USER.usid',0)#" />, 0, re_privacy) < 2
			 GROUP BY YEAR(re_brewed),LPAD(MONTH(re_brewed),2,"0")
			 ORDER BY re_year DESC
		</cfquery>
		<cfreturn LOCAL.qryDateGroups />
	</cffunction>

	<cffunction name="QueryRecipeWithDates" access="public" returnType="query" output="false">
		<cfargument name="re_reid" type="numeric" required="false" />
		<cfargument name="re_usid" type="numeric" required="false" />
		<cfargument name="exclude_reid" type="string" required="false" />
		<cfargument name="list_reid" type="string" required="false" />

		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryRecipe" datasource="#THIS.dsn#">
			SELECT re_reid, re_name, re_volume, re_style, re_expgrv, re_expsrm, re_expibu, re_vunits, re_munits, re_eunits, re_hunits, re_tunits, re_brewed, re_grnamt, re_mashamt, re_hopamt,
					 rd_rdid, rd_date, rd_type, rd_gravity, rd_temp, rd_note
			  FROM recipe
					 INNER JOIN recipedates ON rd_reid = re_reid
			 WHERE 0=0
			<cfif StructKeyExists(ARGUMENTS, "re_reid")>
				AND re_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_reid#" />
			<cfelseif isDefined("ARGUMENTS.list_reid")>
				AND re_reid IN (<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.list_reid#" list="true" />)
			</cfif>
			<cfif StructKeyExists(ARGUMENTS, "exclude_reid")>
				AND re_reid NOT IN (<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.exclude_reid#" list="true" />)
			</cfif>
			<cfif StructKeyExists(ARGUMENTS, "re_usid")>
				AND re_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
			</cfif>
			 ORDER BY re_brewed DESC, rd_date DESC
		</cfquery>
		<cfreturn LOCAL.qryRecipe />
	</cffunction>

	<cffunction name="QueryUnpackaged" access="public" returnType="query" output="false">
		<cfargument name="re_usid" type="numeric" required="true" />
		<cfquery name="LOCAL.qryRecipeUnpackaged" datasource="#THIS.dsn#">
			SELECT brewed.*
			  FROM (
						SELECT rd_reid,rd_date
						  FROM recipedates
						 WHERE rd_type = 'Brewed'
							AND rd_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
					 ) AS brewed
						LEFT OUTER JOIN
					 (
						SELECT rd_reid
						  FROM recipedates
						 WHERE rd_type = 'Packaged'
							AND rd_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
					 ) AS packaged
						ON brewed.rd_reid = packaged.rd_reid
			WHERE packaged.rd_reid IS NULL
			ORDER BY rd_date DESC
		</cfquery>
		<cfreturn LOCAL.qryRecipeUnpackaged />
	</cffunction>

	<cffunction name="InsertRecipe" access="public" returnType="numeric" output="false">
		<cfargument name="re_usid" type="numeric" required="true" />
		<cfargument name="re_name" type="string" required="false" />
		<cfargument name="re_volume" type="numeric" required="false" />
		<cfargument name="re_boilvol" type="numeric" required="false" />
		<cfargument name="re_style" type="string" required="false" />
		<cfargument name="re_eff" type="numeric" required="false" />
		<cfargument name="re_expgrv" type="numeric" required="false" />
		<cfargument name="re_expsrm" type="numeric" required="false" />
		<cfargument name="re_expibu" type="numeric" required="false" />
		<cfargument name="re_vunits" type="string" required="false" />
		<cfargument name="re_munits" type="string" required="false" />
		<cfargument name="re_hunits" type="string" required="false" />
		<cfargument name="re_tunits" type="string" required="false" />
		<cfargument name="re_type" type="string" required="false" />
		<cfargument name="re_mashtype" type="string" required="false" />
		<cfargument name="re_notes" type="string" required="false" />
		<cfargument name="re_mash" type="string" required="false" />
		<cfargument name="re_prime" type="string" required="false" />
		<cfargument name="re_grnamt" type="numeric" required="false" />
		<cfargument name="re_mashamt" type="numeric" required="false" />
		<cfargument name="re_hopamt" type="numeric" required="false" />
		<cfargument name="re_hopcnt" type="numeric" required="false" />
		<cfargument name="re_grncnt" type="numeric" required="false" />
		<cfargument name="re_privacy" type="numeric" required="false" />
		<cfargument name="re_eunits" type="string" required="false" />
		<cfargument name="re_brewed" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insRecipe" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO recipe (
				<cfif StructKeyExists(ARGUMENTS, "re_name")>re_name,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_volume")>re_volume,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_boilvol")>re_boilvol,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_style")>re_style,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_eff")>re_eff,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_expgrv")>re_expgrv,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_expsrm")>re_expsrm,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_expibu")>re_expibu,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_vunits")>re_vunits,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_munits")>re_munits,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_hunits")>re_hunits,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_tunits")>re_tunits,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_type")>re_type,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_mashtype")>re_mashtype,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_notes")>re_notes,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_mash")>re_mash,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_prime")>re_prime,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_grnamt")>re_grnamt,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_mashamt")>re_mashamt,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_hopamt")>re_hopamt,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_hopcnt")>re_hopcnt,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_grncnt")>re_grncnt,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_eunits")>re_eunits,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_privacy")>re_privacy,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_brewed")>re_brewed,</cfif>
				re_usid, re_dla
			) VALUES (
				<cfif StructKeyExists(ARGUMENTS, "re_name")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_name,35)#" maxlength="35" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_volume")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_volume#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_boilvol")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_boilvol#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_style")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_style,35)#" maxlength="35" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_eff")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.re_eff#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_expgrv")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_expgrv#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_expsrm")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_expsrm#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_expibu")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_expibu#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_vunits")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_vunits,12)#" maxlength="12" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_munits")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_munits,12)#" maxlength="12" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_hunits")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_hunits,12)#" maxlength="12" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_tunits")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_tunits,10)#" maxlength="10" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_type")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_type,10)#" maxlength="10" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_mashtype")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_mashtype,12)#" maxlength="12" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_notes")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_notes,5000)#" maxlength="5000" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_mash")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_mash,2000)#" maxlength="2000" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_prime")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_prime,500)#" maxlength="500" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_grnamt")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_grnamt#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_mashamt")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_mashamt#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_hopamt")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_hopamt#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_hopcnt")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.re_hopcnt#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_grncnt")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.re_grncnt#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_eunits")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_eunits,5)#" maxlength="5" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_privacy")><cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.re_privacy#" />,</cfif>
				<cfif StructKeyExists(ARGUMENTS, "re_brewed")><cfqueryparam cfsqltype="CF_SQL_DATE" value="#ARGUMENTS.re_brewed#" null="#not IsDate(ARGUMENTS.re_brewed)#" />,</cfif>
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />,
				NOW()
			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="UpdateRecipe" access="public" returnType="numeric" output="false">
		<cfargument name="re_reid" type="numeric" required="true" />
		<cfargument name="re_usid" type="numeric" required="true" />
		<cfargument name="re_name" type="string" required="false" />
		<cfargument name="re_volume" type="numeric" required="false" />
		<cfargument name="re_boilvol" type="numeric" required="false" />
		<cfargument name="re_style" type="string" required="false" />
		<cfargument name="re_eff" type="numeric" required="false" />
		<cfargument name="re_expgrv" type="numeric" required="false" />
		<cfargument name="re_expsrm" type="numeric" required="false" />
		<cfargument name="re_expibu" type="numeric" required="false" />
		<cfargument name="re_vunits" type="string" required="false" />
		<cfargument name="re_munits" type="string" required="false" />
		<cfargument name="re_hunits" type="string" required="false" />
		<cfargument name="re_tunits" type="string" required="false" />
		<cfargument name="re_type" type="string" required="false" />
		<cfargument name="re_mashtype" type="string" required="false" />
		<cfargument name="re_notes" type="string" required="false" />
		<cfargument name="re_mash" type="string" required="false" />
		<cfargument name="re_prime" type="string" required="false" />
		<cfargument name="re_grnamt" type="numeric" required="false" />
		<cfargument name="re_mashamt" type="numeric" required="false" />
		<cfargument name="re_hopamt" type="numeric" required="false" />
		<cfargument name="re_hopcnt" type="numeric" required="false" />
		<cfargument name="re_grncnt" type="numeric" required="false" />
		<cfargument name="re_eunits" type="string" required="false" />
		<cfargument name="re_privacy" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updRecipe" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE recipe
				SET <cfif StructKeyExists(ARGUMENTS, "re_name")>re_name = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_name,35)#" maxlength="35" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_volume")>re_volume = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_volume#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_boilvol")>re_boilvol = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_boilvol#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_style")>re_style = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_style,35)#" maxlength="35" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_eff")>re_eff = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.re_eff#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_expgrv")>re_expgrv = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_expgrv#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_expsrm")>re_expsrm = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_expsrm#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_expibu")>re_expibu = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_expibu#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_vunits")>re_vunits = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_vunits,12)#" maxlength="12" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_munits")>re_munits = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_munits,12)#" maxlength="12" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_hunits")>re_hunits = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_hunits,12)#" maxlength="12" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_tunits")>re_tunits = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_tunits,10)#" maxlength="10" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_brewed")>re_brewed = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#ARGUMENTS.re_brewed#" null="#not IsDate(ARGUMENTS.re_brewed)#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_type")>re_type = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_type,10)#" maxlength="10" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_mashtype")>re_mashtype = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_mashtype,12)#" maxlength="12" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_notes")>re_notes = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_notes,5000)#" maxlength="5000" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_mash")>re_mash = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_mash,2000)#" maxlength="2000" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_prime")>re_prime = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_prime,500)#" maxlength="500" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_grnamt")>re_grnamt = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_grnamt#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_mashamt")>re_mashamt = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_mashamt#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_hopamt")>re_hopamt = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.re_hopamt#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_hopcnt")>re_hopcnt = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.re_hopcnt#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_grncnt")>re_grncnt = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.re_grncnt#" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_eunits")>re_eunits = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#LEFT(ARGUMENTS.re_eunits,5)#" maxlength="5" />,</cfif>
					 <cfif StructKeyExists(ARGUMENTS, "re_privacy")>re_privacy = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#ARGUMENTS.re_privacy#" />,</cfif>
					 re_dla = NOW()
			 WHERE re_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_reid#" />
			<cfif StructKeyExists(ARGUMENTS, "re_usid")>
				AND re_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
			</cfif>
		</cfquery>
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="DeleteRecipe" access="public" returnType="numeric" output="false">
		<cfargument name="re_reid" type="numeric" required="true" />
		<cfargument name="re_usid" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delRecipe" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM recipe
			 WHERE re_reid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_reid#" />
			<cfif StructKeyExists(ARGUMENTS, "re_usid")>
				AND re_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
			</cfif>
		</cfquery>
		<cfreturn LOCAL.delRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="DeleteRecipeEntity" access="public" returnType="struct" output="false">
		<cfargument name="re_reid" type="numeric" required="true" />
		<cfargument name="re_usid" type="numeric" required="true" />
		<cfset var RTN = StructNew() />
		<cfset RTN.delRecipeGrains = APPLICATION.CFC.RecipeGrains.DeleteRecipeGrains(rg_reid = ARGUMENTS.re_reid, rg_usid = ARGUMENTS.re_usid) />
		<cfset RTN.delRecipeHops = APPLICATION.CFC.RecipeHops.DeleteRecipeHops(rh_reid = ARGUMENTS.re_reid, rh_usid = ARGUMENTS.re_usid) />
		<cfset RTN.delRecipeYeast = APPLICATION.CFC.RecipeYeast.DeleteRecipeYeast(ry_reid = ARGUMENTS.re_reid, ry_usid = ARGUMENTS.re_usid) />
		<cfset RTN.delRecipeMisc = APPLICATION.CFC.RecipeMisc.DeleteRecipeMisc(rm_reid = ARGUMENTS.re_reid, rm_usid = ARGUMENTS.re_usid) />
		<cfset RTN.delRecipeDates = APPLICATION.CFC.RecipeDates.DeleteRecipeDates(rd_reid = ARGUMENTS.re_reid, rd_usid = ARGUMENTS.re_usid) />
		<cfset RTN.delRecipe = THIS.DeleteRecipe(re_reid = ARGUMENTS.re_reid, re_usid = ARGUMENTS.re_usid) />
		<cfreturn RTN />
	</cffunction>

	<cffunction name="GetLastRecipe" access="public" returnType="numeric" output="false">
		<cfargument name="re_usid" type="numeric" required="No" />
		<cfset var LOCAL = StructNew() />
		<cfquery name="LOCAL.qry" datasource="#THIS.dsn#">
		 SELECT IFNULL(MAX(re_reid),0) AS lastreid
			FROM recipe
		  WHERE re_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
		</cfquery>
		<cfreturn LOCAL.qry.lastreid />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfif NOT SESSION.LoggedIn><cfthrow message="User not logged in." /></cfif>
		<cfset ARGUMENTS.qryRecipe = ARGUMENTS.qryRecipe.DATA[1] />
		<cfset LOCAL.Response.re_reid = JavaCast("int", ARGUMENTS.qryRecipe.re_reid) />
		<cfset LOCAL.Response.re_usid = JavaCast("int", ARGUMENTS.qryRecipe.re_usid) />
		<cfif LOCAL.Response.re_usid NEQ SESSION.USER.usid>
			<cfset LOCAL.Response.method = "Invalid" />
			<cfreturn LOCAL.Response />
		</cfif>
		<cfif ARGUMENTS.qryRecipe._DELETED>
			<cfset LOCAL.Response.method = "Delete" />
			<cfset LOCAL.Response.Delete = THIS.DeleteRecipeEntity(argumentcollection = LOCAL.Response) />
		<cfelse>
			<cfset ARGUMENTS.qryRecipe.re_mashamt = ARGUMENTS.qryRecipe.re_grnamt />
			<cfset ARGUMENTS.qryRecipeGrains = ARGUMENTS.qryRecipeGrains.DATA />
			<cfset ARGUMENTS.qryRecipeHops = ARGUMENTS.qryRecipeHops.DATA />
			<cfset ARGUMENTS.qryRecipeYeast = ARGUMENTS.qryRecipeYeast.DATA />
			<cfset ARGUMENTS.qryRecipeMisc = ARGUMENTS.qryRecipeMisc.DATA />
			<cfset ARGUMENTS.qryRecipeDates = ARGUMENTS.qryRecipeDates.DATA />
			<cfloop array="#ARGUMENTS.qryRecipeDates#" index="ROW"> <!--- FIND THE BREW DATE AND PUT IT ON THE MAIN RECORD FOR DISPLAY PURPOSES --->
				<cfif ROW.rd_type EQ "Brewed" AND NOT ROW._DELETED>
					<cfset ARGUMENTS.qryRecipe.re_brewed = ROW.rd_date />
				</cfif>
			</cfloop>
			<cfif LOCAL.Response.re_reid EQ 0>
				<cfset LOCAL.Response.re_reid = THIS.InsertRecipe(argumentcollection=ARGUMENTS.qryRecipe) />
				<cfset LOCAL.Response.method = "Insert" />
			<cfelse>
				<cfset THIS.UpdateRecipe(argumentcollection=ARGUMENTS.qryRecipe) />
				<cfset LOCAL.Response.method = "Update" />
			</cfif>
			<cfloop array="#ARGUMENTS.qryRecipeGrains#" index="ROW">
				<cfif LOCAL.Response.method EQ "Insert"><cfset ROW.rg_rgid = 0 /></cfif>
				<cfset ROW.rg_reid = LOCAL.Response.re_reid />
				<cfset ROW.rg_usid = LOCAL.Response.re_usid />
				<cfif ROW.rg_rgid EQ 0 AND NOT ROW._DELETED>
					<cfset ROW.rg_rgid = APPLICATION.CFC.RecipeGrains.InsertRecipeGrains(argumentcollection=ROW) />
				<cfelse>
					<cfif ROW._DELETED>
						<cfset APPLICATION.CFC.RecipeGrains.DeleteRecipeGrains(argumentcollection=ROW) />
					<cfelse>
						<cfset APPLICATION.CFC.RecipeGrains.UpdateRecipeGrains(argumentcollection=ROW) />
				</cfif>
				</cfif>
			</cfloop>
			<cfloop array="#ARGUMENTS.qryRecipeHops#" index="ROW">
				<cfif LOCAL.Response.method EQ "Insert"><cfset ROW.rh_rhid = 0 /></cfif>
				<cfset ROW.rh_reid = LOCAL.Response.re_reid />
				<cfset ROW.rh_usid = LOCAL.Response.re_usid />
				<cfif ROW.rh_rhid EQ 0 AND NOT ROW._DELETED>
					<cfset ROW.rh_rhid = APPLICATION.CFC.RecipeHops.InsertRecipeHops(argumentcollection=ROW) />
				<cfelse>
					<cfif ROW._DELETED>
						<cfset APPLICATION.CFC.RecipeHops.DeleteRecipeHops(argumentcollection=ROW) />
					<cfelse>
						<cfset APPLICATION.CFC.RecipeHops.UpdateRecipeHops(argumentcollection=ROW) />
				</cfif>
				</cfif>
			</cfloop>
			<cfloop array="#ARGUMENTS.qryRecipeYeast#" index="ROW">
				<cfif LOCAL.Response.method EQ "Insert"><cfset ROW.ry_ryid = 0 /></cfif>
				<cfset ROW.ry_reid = LOCAL.Response.re_reid />
				<cfset ROW.ry_usid = LOCAL.Response.re_usid />
				<cfif ROW.ry_ryid EQ 0 AND NOT ROW._DELETED>
					<cfset ROW.ry_ryid = APPLICATION.CFC.RecipeYeast.InsertRecipeYeast(argumentcollection=ROW) />
				<cfelse>
					<cfif ROW._DELETED>
						<cfset APPLICATION.CFC.RecipeYeast.DeleteRecipeYeast(argumentcollection=ROW) />
					<cfelse>
						<cfset APPLICATION.CFC.RecipeYeast.UpdateRecipeYeast(argumentcollection=ROW) />
				</cfif>
				</cfif>
			</cfloop>
			<cfloop array="#ARGUMENTS.qryRecipeMisc#" index="ROW">
				<cfif LOCAL.Response.method EQ "Insert"><cfset ROW.rm_rmid = 0 /></cfif>
				<cfset ROW.rm_reid = LOCAL.Response.re_reid />
				<cfset ROW.rm_usid = LOCAL.Response.re_usid />
				<cfif ROW.rm_rmid EQ 0 AND NOT ROW._DELETED>
					<cfset ROW.rm_rmid = APPLICATION.CFC.RecipeMisc.InsertRecipeMisc(argumentcollection=ROW) />
				<cfelse>
					<cfif ROW._DELETED>
						<cfset APPLICATION.CFC.RecipeMisc.DeleteRecipeMisc(argumentcollection=ROW) />
					<cfelse>
						<cfset APPLICATION.CFC.RecipeMisc.UpdateRecipeMisc(argumentcollection=ROW) />
				</cfif>
				</cfif>
			</cfloop>
			<cfloop array="#ARGUMENTS.qryRecipeDates#" index="ROW">
				<cfif LOCAL.Response.method EQ "Insert"><cfset ROW.rd_rdid = 0 /></cfif>
				<cfset ROW.rd_reid = LOCAL.Response.re_reid />
				<cfset ROW.rd_usid = LOCAL.Response.re_usid />
				<cfif ROW.rd_rdid EQ 0 AND NOT ROW._DELETED>
					<cfset ROW.rd_rdid = APPLICATION.CFC.RecipeDates.InsertRecipeDates(argumentcollection=ROW) />
				<cfelse>
					<cfif ROW._DELETED>
						<cfset APPLICATION.CFC.RecipeDates.DeleteRecipeDates(argumentcollection=ROW) />
					<cfelse>
						<cfset APPLICATION.CFC.RecipeDates.UpdateRecipeDates(argumentcollection=ROW) />
				</cfif>
				</cfif>
			</cfloop>
			<cfset LOCAL.Response.RCP = THIS.Fetch(LOCAL.Response.re_reid).RCP />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="Fetch" access="public" returnType="struct">
		<cfargument name="re_reid" type="string" default="0" />
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.method = "Fetch" />

		<cfif StructKeyExists(ARGUMENTS, "copy")><cfset LOCAL.Response.copy = ARGUMENTS.copy /></cfif>
		<cfset LOCAL.Response.RCP = StructNew() />
		<cfif isNumeric(ARGUMENTS.re_reid)>
			<cfset LOCAL.reid = ARGUMENTS.re_reid/>
		<cfelse>
			<cfset LOCAL.reid = 0 />
		</cfif>
		<cfif SESSION.LoggedIn AND LOCAL.reid EQ 0>
			<cfset LOCAL.reid = APPLICATION.CFC.Factory.get("UserPrefs").GetUserPrefs("lastreid", "0") />
			<cfif LOCAL.reid EQ 0>
				<cfinvoke component="#APPLICATION.CFC.Recipe#" method="GetLastRecipe" returnvariable="re_reid" re_usid="#SESSION.USER.usid#" />
			</cfif>
		</cfif>

		<cfset LOCAL.qryRecipe = THIS.QueryRecipe(re_reid=LOCAL.reid) />

		<cfif LOCAL.qryRecipe.RecordCount> <!--- FETCHED A RECIPE, NOW CHECK PERMISSIONS --->
			<cfif SESSION.LoggedIn AND SESSION.USER.usid EQ LOCAL.qryRecipe.re_usid> <!--- OK - LOGGED IN USER OWNS RECORD --->
				<!--- NULL BRANCH --->
			<cfelseif LOCAL.qryRecipe.re_privacy NEQ 0> <!--- ERR - I CAN'T VIEW THIS RECORD --->
				<cfset LOCAL.reid = -1 />
				<cfset LOCAL.qryRecipe = THIS.QueryRecipe(re_reid=LOCAL.reid) />
			<cfelse>	<!--- OK - OPENING A PUBLIC RECORD THAT IS NOT MINE, FORCE INTO COPY MODE --->
				<cfset ARGUMENTS.copy = StructNew() />
				<cfset ARGUMENTS.copy["incHeader"] = 1 />
				<cfset ARGUMENTS.copy["incGrains"] = 1 />
				<cfset ARGUMENTS.copy["incHops"] = 1 />
				<cfset ARGUMENTS.copy["incYeast"] = 1 />
				<cfset ARGUMENTS.copy["incMisc"] = 1 />
				<cfset ARGUMENTS.copy["incDates"] = 0 />
				<cfset ARGUMENTS.copy["forced"] = 1 />
			</cfif>
		</cfif>

		<cfset LOCAL.Response.RCP["qryRecipe"] = LOCAL.qryRecipe />
		<cfset LOCAL.Response.RCP["qryRecipeGrains"] = APPLICATION.CFC.RecipeGrains.QueryRecipeGrains(rg_reid=LOCAL.reid) />
		<cfset LOCAL.Response.RCP["qryRecipeHops"] = APPLICATION.CFC.RecipeHops.QueryRecipeHops(rh_reid=LOCAL.reid) />
		<cfset LOCAL.Response.RCP["qryRecipeYeast"] = APPLICATION.CFC.RecipeYeast.QueryRecipeYeast(ry_reid=LOCAL.reid) />
		<cfset LOCAL.Response.RCP["qryRecipeMisc"] = APPLICATION.CFC.RecipeMisc.QueryRecipeMisc(rm_reid=LOCAL.reid) />
		<cfset LOCAL.Response.RCP["qryRecipeDates"] = APPLICATION.CFC.RecipeDates.QueryRecipeDates(rd_reid=LOCAL.reid) />
		<cfif NOT LOCAL.Response.RCP.qryRecipe.RecordCount>
			<cfset QueryAddRow(LOCAL.Response.RCP.qryRecipe) />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_reid", 0) />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_name", "") />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_style", "") />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_eff", SESSION.SETTING.EFF) />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_eunits", SESSION.SETTING.EUNITS) />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_hunits", SESSION.SETTING.HUNITS) />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_munits", SESSION.SETTING.MUNITS) />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_tunits", SESSION.SETTING.TUNITS) />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_vunits", SESSION.SETTING.VUNITS) />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_volume", SESSION.SETTING.VOLUME) />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_boilvol", SESSION.SETTING.BOILVOL) />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_mashtype", SESSION.SETTING.MASHTYPE) />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_privacy", SESSION.SETTING.PRIVACY) />

		<cfelseif StructKeyExists(ARGUMENTS, "copy")>
			<cfset LOCAL.Response.copy = ARGUMENTS.copy />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_reid", 0) />
			<cfset QuerySetCell(LOCAL.Response.RCP.qryRecipe, "re_brewed", "") />
		<cfelseif LOCAL.Response.RCP.qryRecipe.re_reid NEQ 0>
			<cfset APPLICATION.CFC.Factory.get("UserPrefs").SetUserPrefs("lastreid", LOCAL.Response.RCP.qryRecipe.re_reid) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="QueryUserStats" access="public" returnType="struct" output="false">
		<cfargument name="re_usid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.RTN = StructNew() />
		<cfquery name="LOCAL.qryRecipe" datasource="#THIS.dsn#">
			SELECT us_vunits, COUNT(*) AS us_recipecnt,
					SUM(ConvertVolume(re_vunits, IF(re_brewed IS NOT NULL, re_volume, 0), us_vunits)) AS us_brewamt,
					SUM(IF(re_brewed IS NOT NULL, 1, 0)) AS us_brewcnt
			  FROM recipe
					 INNER JOIN users ON us_usid = re_usid	AND re_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
			 WHERE re_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
			 	AND IF(re_usid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#udfIfDefined('SESSION.USER.usid',0)#" />, 0, re_privacy) < 2
			GROUP BY us_vunits
		</cfquery>
		<cfset LOCAL.RTN.CountRecipe = udfDefault(LOCAL.qryRecipe.us_recipecnt, 0) />
		<cfset LOCAL.RTN.CountBrewed = udfDefault(LOCAL.qryRecipe.us_brewcnt, 0) />
		<cfset LOCAL.RTN.VolumeBrewed = udfDefault(LOCAL.qryRecipe.us_brewamt, 0) />
		<cfset LOCAL.RTN.VolumeUnits = udfDefault(LOCAL.qryRecipe.us_vunits, SESSION.SETTING.vunits) />
		<cfset LOCAL.qryUnPack = QueryUnpackaged(re_usid = ARGUMENTS.re_usid) />
		<cfset LOCAL.RTN.RecipeUnpackCount = LOCAL.qryUnPack.RecordCount />
		<cfset RTN.listUnPack = "" />
		<cfloop query="LOCAL.qryUnPack" startrow="1" endrow="10"><cfset RTN.listUnPack = ListAppend(RTN.listUnPack, rd_reid) /></cfloop>
		<cfreturn LOCAL.RTN />
	</cffunction>

	<cffunction name="QueryStatistics" access="public" returnType="struct" output="false">
		<cfargument name="re_usid" type="numeric" required="false" />
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.RTN = StructNew() />
		<cfquery name="LOCAL.RTN.qryFavStyle" datasource="#THIS.dsn#" maxrows="10">
			SELECT re_style, us_vunits, SUM(ConvertVolume(re_vunits, re_volume, us_vunits)) AS amtStyle, COUNT(*) AS cntStyle, MAX(re_brewed) AS lastStyle
			  FROM recipe
					 INNER JOIN users ON us_usid = re_usid
						AND re_brewed IS NOT NULL
						AND re_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
			 GROUP BY re_style, us_vunits
			 ORDER BY cntStyle DESC
		</cfquery>
		<cfquery name="LOCAL.RTN.qryFavGrains" datasource="#THIS.dsn#" maxrows="10">
			SELECT rg_type, rg_maltster, us_munits, SUM(ConvertWeight(re_munits, rg_amount, us_munits)) AS amtGrain, COUNT(DISTINCT re_reid) AS cntGrain, MAX(re_brewed) AS lastGrain
			  FROM recipegrains
					 INNER JOIN recipe ON re_reid = rg_reid
						AND re_brewed IS NOT NULL
					 INNER JOIN users ON us_usid = rg_usid
						AND rg_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
			 GROUP BY rg_type, rg_maltster, us_munits
			 ORDER BY cntGrain DESC
		</cfquery>
		<cfquery name="LOCAL.RTN.qryFavHops" datasource="#THIS.dsn#" maxrows="10">
			SELECT rh_hop, rh_grown, us_munits, SUM(ConvertWeight(re_hunits, rh_amount, us_munits)) AS amtHop, COUNT(DISTINCT re_reid) AS cntHop, MAX(re_brewed) AS lastHop
			  FROM recipehops
					 INNER JOIN recipe ON re_reid = rh_reid
						AND re_brewed IS NOT NULL
					 INNER JOIN users ON us_usid = rh_usid
						AND rh_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
			 GROUP BY rh_hop, rh_grown, us_munits
			 ORDER BY cntHop DESC
		</cfquery>
		<cfquery name="LOCAL.RTN.qryFavYeast" datasource="#THIS.dsn#" maxrows="10">
			SELECT ry_yeast, ry_mfg, ry_mfgno, us_vunits, SUM(ConvertVolume(re_vunits, re_volume, us_vunits)) AS amtYeast, COUNT(DISTINCT re_reid) AS cntYeast, MAX(re_brewed) AS lastYeast
			  FROM recipeyeast
					 INNER JOIN recipe ON re_reid = ry_reid
						AND re_brewed IS NOT NULL
					 INNER JOIN users ON us_usid = ry_usid
						AND ry_usid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.re_usid#" />
			 GROUP BY ry_yeast, ry_mfg, ry_mfgno, us_vunits
			 ORDER BY cntYeast DESC
		</cfquery>
		<cfreturn LOCAL.RTN />
	</cffunction>

	<cffunction name="GetTreeNodes" access="public" returntype="array">
		<cfargument name="re_usid" type="numeric" required="true" />
		<cfset LOCAL.tree = ArrayNew(1) />
		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QueryDateGrouping(ARGUMENTS.re_usid) />
		<cfoutput query="LOCAL.qry" group="re_year">
			<cfset LOCAL.leaf = ArrayNew(1) />
			<cfset LOCAL.sumRows = 0 />
			<cfoutput>
				<cfset LOCAL.sumRows = LOCAL.sumRows + cntRows />
				<cfset ArrayAppend(LOCAL.leaf, THIS.AddNode("trMonth!#re_year#_#re_month#", "#MonthAsString(re_month)#<i>#cntRows#</i>", "nodeEnd", false, [])) />
			</cfoutput>
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("trYear!#re_year#", "#re_year#<i>#LOCAL.sumRows#</i>", "nodeEnd", false, LOCAL.leaf)) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, AddNode("trYear", "Brewed By Year", "nodeRoot", true, LOCAL.branch)) />
		<cfset LOCAL.branch = GetNodeChildren(tab="recipe", fld="re_style", id="RE_STYLE", qry=false, brewerID = ARGUMENTS.re_usid) />
		<cfset ArrayAppend(LOCAL.tree, AddNode("RE_STYLE", "Style", "nodeRoot", false, LOCAL.branch)) />
		<cfset LOCAL.branch = GetNodeChildren(tab="recipe", fld="re_name", id="RE_NAME", qry=false, brewerID = ARGUMENTS.re_usid) />
		<cfset ArrayAppend(LOCAL.tree, AddNode("RE_NAME", "Name", "nodeRoot", false, LOCAL.branch)) />
		<cfreturn [ { title="Recipes", nodes=LOCAL.tree } ] />
	</cffunction>

</cfcomponent>
