<cfcomponent displayname="objectFactory">
	<cffunction name="init" access="public" output="No" returntype="objectFactory">
		<cfscript>
			// persistance of objects
			VARIABLES.com = structNew();
			VARIABLES.settings = structNew();
		</cfscript>
		<cfreturn THIS />
	</cffunction>
	<cffunction name="get" access="public" output="No" returntype="any">
		<cfargument name="objName" required="false" type="string" />
		<cfargument name="singleton" required="false" type="boolean" default="true" />
		<cfscript>
			var obj = "";
			var key = "";
			if (ARGUMENTS.singleton and singletonExists(ARGUMENTS.objName)) {
				return getSingleton(ARGUMENTS.objName);
			}
			switch(ARGUMENTS.objName) {
				case "beerxml":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.beerxml");
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "explorer":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.explorer");
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "favoriterecipe":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.favoriterecipe").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "followuser":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.followuser").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "grains":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.grains").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "hops":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.hops").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "misc":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.misc").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "recipe":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.recipe").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "recipedates":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.recipedates").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "recipegrains":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.recipegrains").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "recipehops":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.recipehops").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "recipemisc":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.recipemisc").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "recipeyeast":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.recipeyeast").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "useredit":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.useredit").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "userprefs":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.userprefs").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "users":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.users").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "yeast":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.yeast").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "datafiles":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.data.datafiles").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					obj.setCFC("Grains", THIS.Get("Grains"));
					obj.setCFC("Hops", THIS.Get("Hops"));
					obj.setCFC("Misc", THIS.Get("Misc"));
					obj.setCFC("Yeast", THIS.Get("Yeast"));
					return obj;
				break;
				case "controls":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.util.controls");
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "globalUDF":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.util.globalUDF");
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "javascript":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.util.javascript");
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					obj.setCFC("datafiles", THIS.Get("datafiles"));
					return obj;
				break;
				case "UDF":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.util.UDF");
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "CFFP":
					obj = CreateObject("component","cfformprotect.cffpVerify").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "conference":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.forum.conference").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					obj.setSettings(THIS.Get("galleonSettings", ARGUMENTS.singleton));
					obj.setForum(THIS.Get("forum", ARGUMENTS.singleton));
					obj.setUtils(THIS.Get("utils", ARGUMENTS.singleton));
					return obj;
				break;
				case "forum":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.forum.forum").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					obj.setSettings(THIS.Get("galleonSettings", ARGUMENTS.singleton));
					obj.setThread(THIS.Get("thread", ARGUMENTS.singleton));
					obj.setConference(THIS.Get("conference", ARGUMENTS.singleton));
					obj.setUtils(THIS.Get("utils", ARGUMENTS.singleton));
					return obj;
				break;
				case "galleonSettings":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.forum.galleon");
					obj.loadSettings();
					for(key in VARIABLES.settings) {
						obj.addSetting(key, VARIABLES.settings[key]);
					}
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "mailService":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.forum.mailService");
					obj.setSettings(THIS.Get("galleonSettings", ARGUMENTS.singleton));
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "message":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.forum.message").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					obj.setSettings(THIS.Get("galleonSettings", ARGUMENTS.singleton));
					obj.setThread(THIS.Get("thread", ARGUMENTS.singleton));
					obj.setForum(THIS.Get("forum", ARGUMENTS.singleton));
					obj.setConference(THIS.Get("conference", ARGUMENTS.singleton));
					obj.setUser(THIS.Get("user", ARGUMENTS.singleton));
					obj.setUtils(THIS.Get("utils", ARGUMENTS.singleton));
					obj.setMailService(THIS.Get("mailService", ARGUMENTS.singleton));
					return obj;
				break;
				case "permission":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.forum.permission").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					obj.setSettings(THIS.Get("galleonSettings", ARGUMENTS.singleton));
					return obj;
				break;
				case "rank":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.forum.rank").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					obj.setSettings(THIS.Get("galleonSettings", ARGUMENTS.singleton));
					obj.setUtils(THIS.Get("utils", ARGUMENTS.singleton));
					return obj;
				break;
				case "thread":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.forum.thread").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					obj.setSettings(THIS.Get("galleonSettings", ARGUMENTS.singleton));
					obj.setUtils(THIS.Get("utils", ARGUMENTS.singleton));
					obj.setForum(THIS.Get("forum", ARGUMENTS.singleton));
					obj.setMessage(THIS.Get("message", ARGUMENTS.singleton));
					return obj;
				break;
				case "user":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.forum.user").init();
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					obj.setSettings(THIS.Get("galleonSettings", ARGUMENTS.singleton));
					obj.setUtils(THIS.Get("utils", ARGUMENTS.singleton));
					obj.setMailService(THIS.Get("mailService", ARGUMENTS.singleton));
					return obj;
				break;
				case "utils":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.forum.utils");
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
				case "image":
					obj = CreateObject("component","#APPLICATION.MAP.CFC#.forum.image");
					if (ARGUMENTS.singleton) addSingleton(ARGUMENTS.objName, obj);
					return obj;
				break;
			}
		</cfscript>
		<cfreturn false />
	</cffunction>
	<cffunction name="singletonExists" access="public" output="No" returntype="boolean">
		<cfargument name="objName" required="Yes" type="string" />
		<cfreturn StructKeyExists(VARIABLES.com, ARGUMENTS.objName) />
	</cffunction>
	<cffunction name="addSingleton" access="public" output="No" returntype="void">
		<cfargument name="objName" required="Yes" type="string" />
		<cfargument name="obj" required="Yes" />
		<cfset VARIABLES.com[ARGUMENTS.objName] = ARGUMENTS.obj />
	</cffunction>
	<cffunction name="getSingleton" access="public" output="No" returntype="any">
		<cfargument name="objName" required="Yes" type="string" />
		<cfreturn VARIABLES.com[ARGUMENTS.objName] />
	</cffunction>
	<cffunction name="removeSingleton" access="public" output="No" returntype="void">
		<cfargument name="objName" required="Yes" />
		<cfscript>
			if (StructKeyExists(VARIABLES.com, ARGUMENTS.objName)){
				StructDelete(VARIABLES.com, ARGUMENTS.objName);
			}
		</cfscript>
	</cffunction>
</cfcomponent>