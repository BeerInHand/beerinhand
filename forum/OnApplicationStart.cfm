<cfset APPLICATION.FORUM = StructNew() />
<cfset APPLICATION.FORUM.rssCache = StructNew() />
<!--- Get main settings --->
<cfset APPLICATION.CFC.Factory.Get("galleonSettings").addSetting("mailserver", APPLICATION.EMAIL.smtp) />
<cfset APPLICATION.CFC.Factory.Get("galleonSettings").addSetting("mailusername", APPLICATION.EMAIL.user) />
<cfset APPLICATION.CFC.Factory.Get("galleonSettings").addSetting("mailpassword", APPLICATION.EMAIL.pwd) />
<cfset APPLICATION.FORUM.SETTING = APPLICATION.CFC.Factory.Get("galleonSettings").getSettings() />
<!--- get mail service --->
<cfset APPLICATION.FORUM.MailService = APPLICATION.CFC.Factory.Get("mailService") />
<!--- get user CFC --->
<cfset APPLICATION.FORUM.User = APPLICATION.CFC.Factory.Get("user") />
<!--- get utils CFC --->
<cfset APPLICATION.FORUM.Utils = APPLICATION.CFC.Factory.Get("utils") />
<!--- get conference CFC --->
<cfset APPLICATION.FORUM.Conference = APPLICATION.CFC.Factory.Get("conference") />
<!--- get forum CFC --->
<cfset APPLICATION.FORUM.Forums = APPLICATION.CFC.Factory.Get("forum") />
<!--- get thread CFC --->
<cfset APPLICATION.FORUM.Thread = APPLICATION.CFC.Factory.Get("thread") />
<!--- get message CFC --->
<cfset APPLICATION.FORUM.Message = APPLICATION.CFC.Factory.Get("message") />
<!--- get rank CFC --->
<cfset APPLICATION.FORUM.Rank = APPLICATION.CFC.Factory.Get("rank") />
<!--- get security CFC --->
<cfset APPLICATION.FORUM.Permission = APPLICATION.CFC.Factory.Get("permission") />
<!--- hard coded rights for now --->
<cfset APPLICATION.FORUM.Rights.CANVIEW = "7EA5070B-9774-E11E-96E727122408C03C" />
<cfset APPLICATION.FORUM.Rights.CANPOST = "7EA5070C-E788-7378-8930FA15EF58BBD2" />
<cfset APPLICATION.FORUM.Rights.CANEDIT = "7EA5070D-CB58-72BA-2E4A3DFC0AE35F35" />

