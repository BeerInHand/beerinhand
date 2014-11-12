<cfcomponent output="false" extends="explorer">

	<cfset init() />

	<cffunction name="init" returntype="bjcpstyles" output="false">
		<cfargument name="dsn" type="string" required="false" default="#APPLICATION.DSN.MAIN#" />
		<cfset THIS.dsn = ARGUMENTS.dsn />
		<cfset THIS.table = "bjcpstyles" />
		<cfreturn THIS />
	</cffunction>

	<cffunction name="QueryBJCPStyles" access="public" returnType="query" output="false">
		<cfargument name="st_stid" type="numeric" required="false" />
		<cfargument name="st_substyle" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.qryBJCPStyles" datasource="#THIS.dsn#">
			SELECT st_stid, st_category, st_style, st_subcategory, st_substyle, st_type, st_og_min, st_og_max, st_og_gap, st_fg_min, st_fg_max, st_fg_gap, st_ibu_min, st_ibu_max, st_ibu_gap, st_srm_min, st_srm_max, st_srm_gap, st_abv_min, st_abv_max, st_abv_gap, st_co2_min, st_co2_max, st_co2_gap, st_aroma, st_appearance, st_flavor, st_mouthfeel, st_impression, st_ingredients, st_examples, st_history, st_comments, st_varieties, st_exceptions
			  FROM bjcpstyles
			 WHERE 0=0
			<cfif isDefined("ARGUMENTS.st_stid")>
				AND st_stid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.st_stid#" />
			</cfif>
			<cfif isDefined("ARGUMENTS.st_substyle")>
				AND st_substyle = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_substyle#" />
			</cfif>
			 ORDER BY st_substyle
		</cfquery>
		<cfreturn LOCAL.qryBJCPStyles />
	</cffunction>

	<cffunction name="InsertBJCPStyles" access="public" returnType="numeric" output="false">
		<cfargument name="st_category" type="string" required="false" />
		<cfargument name="st_style" type="string" required="false" />
		<cfargument name="st_subcategory" type="string" required="false" />
		<cfargument name="st_substyle" type="string" required="false" />
		<cfargument name="st_type" type="string" required="false" />
		<cfargument name="st_og_min" type="numeric" required="false" />
		<cfargument name="st_og_max" type="numeric" required="false" />
		<cfargument name="st_og_gap" type="numeric" required="false" />
		<cfargument name="st_fg_min" type="numeric" required="false" />
		<cfargument name="st_fg_max" type="numeric" required="false" />
		<cfargument name="st_fg_gap" type="numeric" required="false" />
		<cfargument name="st_ibu_min" type="numeric" required="false" />
		<cfargument name="st_ibu_max" type="numeric" required="false" />
		<cfargument name="st_ibu_gap" type="numeric" required="false" />
		<cfargument name="st_srm_min" type="numeric" required="false" />
		<cfargument name="st_srm_max" type="numeric" required="false" />
		<cfargument name="st_srm_gap" type="numeric" required="false" />
		<cfargument name="st_abv_min" type="numeric" required="false" />
		<cfargument name="st_abv_max" type="numeric" required="false" />
		<cfargument name="st_abv_gap" type="numeric" required="false" />
		<cfargument name="st_co2_min" type="numeric" required="false" />
		<cfargument name="st_co2_max" type="numeric" required="false" />
		<cfargument name="st_co2_gap" type="numeric" required="false" />
		<cfargument name="st_aroma" type="string" required="false" />
		<cfargument name="st_appearance" type="string" required="false" />
		<cfargument name="st_flavor" type="string" required="false" />
		<cfargument name="st_mouthfeel" type="string" required="false" />
		<cfargument name="st_impression" type="string" required="false" />
		<cfargument name="st_ingredients" type="string" required="false" />
		<cfargument name="st_examples" type="string" required="false" />
		<cfargument name="st_history" type="string" required="false" />
		<cfargument name="st_comments" type="string" required="false" />
		<cfargument name="st_varieties" type="string" required="false" />
		<cfargument name="st_exceptions" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.insBJCPStyles" datasource="#THIS.dsn#" result="LOCAL.insRtn">
			INSERT INTO bjcpstyles (
				<cfif isDefined("ARGUMENTS.st_category")>st_category,</cfif>
				<cfif isDefined("ARGUMENTS.st_style")>st_style,</cfif>
				<cfif isDefined("ARGUMENTS.st_subcategory")>st_subcategory,</cfif>
				<cfif isDefined("ARGUMENTS.st_substyle")>st_substyle,</cfif>
				<cfif isDefined("ARGUMENTS.st_type")>st_type,</cfif>
				<cfif isDefined("ARGUMENTS.st_og_min")>st_og_min,</cfif>
				<cfif isDefined("ARGUMENTS.st_og_max")>st_og_max,</cfif>
				<cfif isDefined("ARGUMENTS.st_og_gap")>st_og_gap,</cfif>
				<cfif isDefined("ARGUMENTS.st_fg_min")>st_fg_min,</cfif>
				<cfif isDefined("ARGUMENTS.st_fg_max")>st_fg_max,</cfif>
				<cfif isDefined("ARGUMENTS.st_fg_gap")>st_fg_gap,</cfif>
				<cfif isDefined("ARGUMENTS.st_ibu_min")>st_ibu_min,</cfif>
				<cfif isDefined("ARGUMENTS.st_ibu_max")>st_ibu_max,</cfif>
				<cfif isDefined("ARGUMENTS.st_ibu_gap")>st_ibu_gap,</cfif>
				<cfif isDefined("ARGUMENTS.st_srm_min")>st_srm_min,</cfif>
				<cfif isDefined("ARGUMENTS.st_srm_max")>st_srm_max,</cfif>
				<cfif isDefined("ARGUMENTS.st_srm_gap")>st_srm_gap,</cfif>
				<cfif isDefined("ARGUMENTS.st_abv_min")>st_abv_min,</cfif>
				<cfif isDefined("ARGUMENTS.st_abv_max")>st_abv_max,</cfif>
				<cfif isDefined("ARGUMENTS.st_abv_gap")>st_abv_gap,</cfif>
				<cfif isDefined("ARGUMENTS.st_co2_min")>st_co2_min,</cfif>
				<cfif isDefined("ARGUMENTS.st_co2_max")>st_co2_max,</cfif>
				<cfif isDefined("ARGUMENTS.st_co2_gap")>st_co2_gap,</cfif>
				<cfif isDefined("ARGUMENTS.st_aroma")>st_aroma,</cfif>
				<cfif isDefined("ARGUMENTS.st_appearance")>st_appearance,</cfif>
				<cfif isDefined("ARGUMENTS.st_flavor")>st_flavor,</cfif>
				<cfif isDefined("ARGUMENTS.st_mouthfeel")>st_mouthfeel,</cfif>
				<cfif isDefined("ARGUMENTS.st_impression")>st_impression,</cfif>
				<cfif isDefined("ARGUMENTS.st_ingredients")>st_ingredients,</cfif>
				<cfif isDefined("ARGUMENTS.st_examples")>st_examples,</cfif>
				<cfif isDefined("ARGUMENTS.st_history")>st_history,</cfif>
				<cfif isDefined("ARGUMENTS.st_comments")>st_comments,</cfif>
				<cfif isDefined("ARGUMENTS.st_varieties")>st_varieties,</cfif>
				<cfif isDefined("ARGUMENTS.st_exceptions")>st_exceptions,</cfif>

			) VALUES (
				<cfif isDefined("ARGUMENTS.st_category")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_category#" maxlength="2" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_style")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_style#" maxlength="35" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_subcategory")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_subcategory#" maxlength="3" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_substyle")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_substyle#" maxlength="50" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_type")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_type#" maxlength="10" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_og_min")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_og_min#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_og_max")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_og_max#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_og_gap")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_og_gap#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_fg_min")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_fg_min#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_fg_max")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_fg_max#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_fg_gap")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_fg_gap#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_ibu_min")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_ibu_min#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_ibu_max")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_ibu_max#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_ibu_gap")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_ibu_gap#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_srm_min")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_srm_min#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_srm_max")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_srm_max#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_srm_gap")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_srm_gap#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_abv_min")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_abv_min#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_abv_max")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_abv_max#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_abv_gap")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_abv_gap#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_co2_min")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_co2_min#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_co2_max")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_co2_max#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_co2_gap")><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_co2_gap#" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_aroma")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_aroma#" maxlength="5000" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_appearance")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_appearance#" maxlength="5000" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_flavor")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_flavor#" maxlength="5000" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_mouthfeel")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_mouthfeel#" maxlength="5000" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_impression")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_impression#" maxlength="5000" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_ingredients")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_ingredients#" maxlength="5000" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_examples")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_examples#" maxlength="5000" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_history")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_history#" maxlength="5000" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_comments")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_comments#" maxlength="5000" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_varieties")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_varieties#" maxlength="5000" />,</cfif>
				<cfif isDefined("ARGUMENTS.st_exceptions")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_exceptions#" maxlength="5000" />,</cfif>

			)
		</cfquery>
		<cfreturn LOCAL.insRtn.GENERATED_KEY />
	</cffunction>

	<cffunction name="UpdateBJCPStyles" access="public" returnType="numeric" output="false">
		<cfargument name="st_stid" type="numeric" required="true" />
		<cfargument name="st_category" type="string" required="false" />
		<cfargument name="st_style" type="string" required="false" />
		<cfargument name="st_subcategory" type="string" required="false" />
		<cfargument name="st_substyle" type="string" required="false" />
		<cfargument name="st_type" type="string" required="false" />
		<cfargument name="st_og_min" type="numeric" required="false" />
		<cfargument name="st_og_max" type="numeric" required="false" />
		<cfargument name="st_og_gap" type="numeric" required="false" />
		<cfargument name="st_fg_min" type="numeric" required="false" />
		<cfargument name="st_fg_max" type="numeric" required="false" />
		<cfargument name="st_fg_gap" type="numeric" required="false" />
		<cfargument name="st_ibu_min" type="numeric" required="false" />
		<cfargument name="st_ibu_max" type="numeric" required="false" />
		<cfargument name="st_ibu_gap" type="numeric" required="false" />
		<cfargument name="st_srm_min" type="numeric" required="false" />
		<cfargument name="st_srm_max" type="numeric" required="false" />
		<cfargument name="st_srm_gap" type="numeric" required="false" />
		<cfargument name="st_abv_min" type="numeric" required="false" />
		<cfargument name="st_abv_max" type="numeric" required="false" />
		<cfargument name="st_abv_gap" type="numeric" required="false" />
		<cfargument name="st_co2_min" type="numeric" required="false" />
		<cfargument name="st_co2_max" type="numeric" required="false" />
		<cfargument name="st_co2_gap" type="numeric" required="false" />
		<cfargument name="st_aroma" type="string" required="false" />
		<cfargument name="st_appearance" type="string" required="false" />
		<cfargument name="st_flavor" type="string" required="false" />
		<cfargument name="st_mouthfeel" type="string" required="false" />
		<cfargument name="st_impression" type="string" required="false" />
		<cfargument name="st_ingredients" type="string" required="false" />
		<cfargument name="st_examples" type="string" required="false" />
		<cfargument name="st_history" type="string" required="false" />
		<cfargument name="st_comments" type="string" required="false" />
		<cfargument name="st_varieties" type="string" required="false" />
		<cfargument name="st_exceptions" type="string" required="false" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.updBJCPStyles" datasource="#THIS.dsn#" result="LOCAL.updRtn">
			UPDATE bjcpstyles
				SET <cfif isDefined("ARGUMENTS.st_category")>st_category = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_category#" maxlength="2" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_style")>st_style = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_style#" maxlength="35" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_subcategory")>st_subcategory = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_subcategory#" maxlength="3" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_substyle")>st_substyle = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_substyle#" maxlength="50" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_type")>st_type = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_type#" maxlength="10" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_og_min")>st_og_min = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_og_min#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_og_max")>st_og_max = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_og_max#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_og_gap")>st_og_gap = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_og_gap#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_fg_min")>st_fg_min = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_fg_min#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_fg_max")>st_fg_max = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_fg_max#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_fg_gap")>st_fg_gap = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_fg_gap#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_ibu_min")>st_ibu_min = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_ibu_min#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_ibu_max")>st_ibu_max = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_ibu_max#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_ibu_gap")>st_ibu_gap = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_ibu_gap#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_srm_min")>st_srm_min = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_srm_min#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_srm_max")>st_srm_max = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_srm_max#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_srm_gap")>st_srm_gap = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_srm_gap#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_abv_min")>st_abv_min = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_abv_min#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_abv_max")>st_abv_max = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_abv_max#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_abv_gap")>st_abv_gap = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_abv_gap#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_co2_min")>st_co2_min = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_co2_min#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_co2_max")>st_co2_max = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_co2_max#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_co2_gap")>st_co2_gap = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#ARGUMENTS.st_co2_gap#" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_aroma")>st_aroma = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_aroma#" maxlength="5000" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_appearance")>st_appearance = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_appearance#" maxlength="5000" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_flavor")>st_flavor = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_flavor#" maxlength="5000" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_mouthfeel")>st_mouthfeel = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_mouthfeel#" maxlength="5000" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_impression")>st_impression = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_impression#" maxlength="5000" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_ingredients")>st_ingredients = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_ingredients#" maxlength="5000" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_examples")>st_examples = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_examples#" maxlength="5000" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_history")>st_history = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_history#" maxlength="5000" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_comments")>st_comments = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_comments#" maxlength="5000" />,</cfif>
					 <cfif isDefined("ARGUMENTS.st_varieties")>st_varieties = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_varieties#" maxlength="5000" />,</cfif>
					 st_exceptions = <cfif isDefined("ARGUMENTS.st_exceptions")><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.st_exceptions#" maxlength="5000" /><cfelse>st_exceptions</cfif>
			 WHERE st_stid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.st_stid#" />
		</cfquery>
		<cfreturn LOCAL.updRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="DeleteBJCPStyles" access="public" returnType="numeric" output="false">
		<cfargument name="st_stid" type="numeric" required="true" />
		<cfset var LOCAL = StructNew() />

		<cfquery name="LOCAL.delBJCPStyles" datasource="#THIS.dsn#" result="LOCAL.delRtn">
			DELETE
			  FROM bjcpstyles
			 WHERE st_stid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.st_stid#" />
		</cfquery>
		<cfreturn LOCAL.delRtn.RECORDCOUNT />
	</cffunction>

	<cffunction name="Process" access="public" returnType="struct">
		<cfset var LOCAL = StructNew() />
		<cfset LOCAL.Response.st_stid = JavaCast("int", ARGUMENTS.st_stid) />
		<cfif IsDefined("ARGUMENTS.kill")>
			<cfset LOCAL.Response.method="Delete" />
		<cfelseif LOCAL.Response.st_stid neq 0>
			<cfset LOCAL.Response.method="Update" />
		<cfelse>
			<cfset LOCAL.Response.method="Insert" />
		</cfif>
		<cfinvoke method="#LOCAL.Response.method#BJCPStyles" returnvariable="LOCAL.rtn">
			<cfloop collection="#ARGUMENTS#" item="LOCAL.key">
				<cfif ARGUMENTS[LOCAL.key] neq "null">
					<cfinvokeargument name="#LOCAL.key#" value="#ARGUMENTS[LOCAL.key]#" />
				</cfif>
			</cfloop>
		</cfinvoke>
		<cfif LOCAL.Response.method eq "Insert">
			<cfset LOCAL.Response.st_stid = JavaCast("int", LOCAL.rtn) />
		</cfif>
		<cfreturn LOCAL.Response />
	</cffunction>

	<cffunction name="GetTreeNodes" access="public" returntype="array">
		<cfset LOCAL.tree = ArrayNew(1) />
		<cfset LOCAL.branch = ArrayNew(1) />
		<cfset LOCAL.qry = THIS.QueryDataGroup("ST_STYLE, ST_SUBSTYLE") />
		<cfoutput query="LOCAL.qry" group="ST_STYLE">
			<cfset LOCAL.leaf = ArrayNew(1) />
			<cfset LOCAL.sumRows = 0 />
			<cfoutput>
				<cfset LOCAL.sumRows = LOCAL.sumRows + cntRows />
				<cfset ArrayAppend(LOCAL.leaf, THIS.AddNode("ST_SUBSTYLE!#ST_SUBSTYLE#", "#ST_SUBSTYLE#<i>#cntRows#</i>", "nodeEnd", false, [])) />
			</cfoutput>
			<cfset ArrayAppend(LOCAL.branch, THIS.AddNode("ST_STYLE!#ST_STYLE#", "#ST_STYLE#<i>#sumRows#</i>", "nodeEnd", false, LOCAL.leaf)) />
		</cfoutput>
		<cfset ArrayAppend(LOCAL.tree, { title="Style", nodes=LOCAL.branch }) />
		<cfreturn LOCAL.tree />
	</cffunction>

</cfcomponent>
