<cfset APPLICATION.CFC.DataFiles.WriteDataFile("Grains", "gr_type", "gr_dla", "GR_GRID") />
<cfset APPLICATION.CFC.DataFiles.WriteDataFile("Hops", "hp_hop", "hp_dla", "HP_HPID") />
<cfset APPLICATION.CFC.DataFiles.WriteDataFile("Misc", "mi_type", "mi_dla", "MI_MIID") />
<cfset APPLICATION.CFC.DataFiles.WriteDataFile("Yeast", "ye_yeast", "ye_dla", "YE_YEID") />
<cfset cfcBJCP = CreateObject("component","#APPLICATION.MAP.CFC#.data.bjcpstyles").init() />
<cfset APPLICATION.CFC.DataFiles.SetCFC("BJCPStyles", cfcBJCP) />
<cfset APPLICATION.CFC.DataFiles.WriteDataFile("BJCPStyles", "st_substyle", "2008", "ST_STID") />
