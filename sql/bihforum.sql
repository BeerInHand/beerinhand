
SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for forum_conferences
-- ----------------------------
CREATE TABLE `forum_conferences` (
  `Id` varchar(35) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `active` tinyint(1) DEFAULT NULL,
  `messages` int(11) DEFAULT NULL,
  `lastpost` varchar(35) DEFAULT NULL,
  `lastpostuseridfk` varchar(35) DEFAULT NULL,
  `lastpostcreated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for forum_forums
-- ----------------------------
CREATE TABLE `forum_forums` (
  `id` varchar(35) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `attachments` tinyint(1) NOT NULL DEFAULT '0',
  `conferenceidfk` varchar(35) NOT NULL DEFAULT '',
  `messages` int(11) DEFAULT NULL,
  `lastpost` varchar(35) DEFAULT NULL,
  `lastpostuseridfk` varchar(35) DEFAULT NULL,
  `lastpostcreated` timestamp NULL DEFAULT NULL,
  `rank` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `forum_forums_conferenceidfk` (`conferenceidfk`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for forum_groups
-- ----------------------------
CREATE TABLE `forum_groups` (
  `Id` varchar(35) NOT NULL DEFAULT '',
  `group` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for forum_messages
-- ----------------------------
CREATE TABLE `forum_messages` (
  `Id` varchar(35) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  `posted` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` datetime DEFAULT NULL,
  `updatedby` varchar(20) NOT NULL DEFAULT '',
  `useridfk` varchar(35) NOT NULL DEFAULT '',
  `threadidfk` varchar(35) NOT NULL DEFAULT '',
  `attachment` varchar(255) NOT NULL DEFAULT '',
  `filename` varchar(255) NOT NULL DEFAULT '',
  `deleteid` varchar(35) DEFAULT '',
  PRIMARY KEY (`Id`),
  KEY `forum_messages_useridfk` (`useridfk`),
  KEY `forum_messages_threadidfk` (`threadidfk`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for forum_permissions
-- ----------------------------
CREATE TABLE `forum_permissions` (
  `id` varchar(35) NOT NULL,
  `rightidfk` varchar(35) NOT NULL,
  `resourceidfk` varchar(35) NOT NULL,
  `groupidfk` varchar(35) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for forum_privatemessages
-- ----------------------------
CREATE TABLE `forum_privatemessages` (
  `Id` varchar(35) NOT NULL DEFAULT '',
  `fromuseridfk` varchar(35) NOT NULL DEFAULT '',
  `touseridfk` varchar(35) NOT NULL DEFAULT '',
  `sent` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `body` text NOT NULL,
  `subject` varchar(255) NOT NULL DEFAULT '',
  `unread` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for forum_ranks
-- ----------------------------
CREATE TABLE `forum_ranks` (
  `Id` varchar(35) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL DEFAULT '',
  `minposts` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for forum_rights
-- ----------------------------
CREATE TABLE `forum_rights` (
  `id` varchar(35) NOT NULL,
  `right` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for forum_search_log
-- ----------------------------
CREATE TABLE `forum_search_log` (
  `searchterms` varchar(255) NOT NULL DEFAULT '',
  `datesearched` datetime NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for forum_subscriptions
-- ----------------------------
CREATE TABLE `forum_subscriptions` (
  `Id` varchar(35) NOT NULL DEFAULT '',
  `useridfk` varchar(35) DEFAULT NULL,
  `threadidfk` varchar(35) DEFAULT NULL,
  `forumidfk` varchar(35) DEFAULT NULL,
  `conferenceidfk` varchar(35) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `forum_subscriptions_useridfk` (`useridfk`),
  KEY `forum_subscriptions_threadidfk` (`threadidfk`),
  KEY `forum_subscriptions_forumidfk` (`forumidfk`),
  KEY `forum_subscriptions_conferenceidfk` (`conferenceidfk`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for forum_threads
-- ----------------------------
CREATE TABLE `forum_threads` (
  `Id` varchar(35) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '',
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `useridfk` varchar(35) NOT NULL DEFAULT '',
  `forumidfk` varchar(35) NOT NULL DEFAULT '',
  `datecreated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `sticky` tinyint(1) NOT NULL DEFAULT '0',
  `messages` int(11) DEFAULT NULL,
  `lastpostuseridfk` varchar(35) DEFAULT NULL,
  `lastpostcreated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `forum_threads_useridfk` (`useridfk`),
  KEY `forum_threads_forumidfk` (`forumidfk`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for forum_users
-- ----------------------------
CREATE TABLE `forum_users` (
  `Id` varchar(35) NOT NULL DEFAULT '',
  `username` varchar(50) NOT NULL DEFAULT '',
  `password` varchar(50) NOT NULL DEFAULT '',
  `emailaddress` varchar(255) NOT NULL DEFAULT '',
  `signature` text NOT NULL,
  `datecreated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `confirmed` tinyint(1) NOT NULL DEFAULT '0',
  `avatar` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for forum_users_groups
-- ----------------------------
CREATE TABLE `forum_users_groups` (
  `useridfk` varchar(35) NOT NULL DEFAULT '',
  `groupidfk` varchar(35) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for tblblogcategories
-- ----------------------------
CREATE TABLE `tblblogcategories` (
  `categoryid` varchar(35) NOT NULL,
  `categoryname` varchar(50) DEFAULT NULL,
  `categoryalias` varchar(50) DEFAULT NULL,
  `blog` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`categoryid`),
  KEY `blogCategories_categoryalias` (`categoryalias`),
  KEY `blogCategories_categoryname` (`categoryname`),
  KEY `blogCategories_blog` (`blog`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tblblogcomments
-- ----------------------------
CREATE TABLE `tblblogcomments` (
  `id` varchar(35) NOT NULL,
  `entryidfk` varchar(35) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `comment` text,
  `posted` datetime DEFAULT NULL,
  `subscribe` tinyint(1) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `moderated` tinyint(1) DEFAULT NULL,
  `subscribeonly` tinyint(1) DEFAULT NULL,
  `killcomment` varchar(35) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `blogComments_entryid` (`entryidfk`),
  KEY `blogComments_posted` (`posted`),
  KEY `blogComments_moderated` (`moderated`),
  KEY `blogComments_email` (`email`),
  KEY `blogComments_name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tblblogentries
-- ----------------------------
CREATE TABLE `tblblogentries` (
  `id` varchar(35) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `body` longtext,
  `posted` datetime DEFAULT NULL,
  `morebody` longtext,
  `alias` varchar(100) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `blog` varchar(50) DEFAULT NULL,
  `allowcomments` tinyint(1) DEFAULT NULL,
  `enclosure` varchar(255) DEFAULT NULL,
  `filesize` int(11) unsigned DEFAULT NULL,
  `mimetype` varchar(255) DEFAULT NULL,
  `views` int(11) unsigned DEFAULT NULL,
  `released` tinyint(1) DEFAULT NULL,
  `mailed` tinyint(1) DEFAULT NULL,
  `summary` varchar(255) DEFAULT NULL,
  `subtitle` varchar(100) DEFAULT NULL,
  `keywords` varchar(100) DEFAULT NULL,
  `duration` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `blogEntries_blog` (`blog`),
  KEY `blogEntries_released` (`released`),
  KEY `blogEntries_posted` (`posted`),
  KEY `blogEntries_title` (`title`),
  KEY `blogEntries_username` (`username`),
  KEY `blogEntries_alias` (`alias`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tblblogentriescategories
-- ----------------------------
CREATE TABLE `tblblogentriescategories` (
  `categoryidfk` varchar(35) DEFAULT NULL,
  `entryidfk` varchar(35) DEFAULT NULL,
  KEY `blogEntriesCategories_entryidfk` (`entryidfk`,`categoryidfk`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tblblogentriesrelated
-- ----------------------------
CREATE TABLE `tblblogentriesrelated` (
  `entryid` varchar(35) DEFAULT NULL,
  `relatedid` varchar(35) DEFAULT NULL,
  KEY `blogEntriesRelated_entryid` (`entryid`),
  KEY `blogEntriesRelated_relatedid` (`relatedid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tblblogpages
-- ----------------------------
CREATE TABLE `tblblogpages` (
  `id` varchar(35) NOT NULL,
  `blog` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `alias` varchar(100) DEFAULT NULL,
  `body` longtext,
  `showlayout` tinyint(1) NOT NULL,
  KEY `blogPages_blog` (`blog`),
  KEY `blogPages_alias` (`alias`),
  KEY `blogPages_title` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tblblogpagescategories
-- ----------------------------
CREATE TABLE `tblblogpagescategories` (
  `categoryidfk` varchar(35) DEFAULT NULL,
  `pageidfk` varchar(35) DEFAULT NULL,
  KEY `blogEntriesCategories_entryidfk` (`pageidfk`,`categoryidfk`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tblblogroles
-- ----------------------------
CREATE TABLE `tblblogroles` (
  `id` varchar(35) NOT NULL,
  `role` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `blogRoles_role` (`role`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tblblogsearchstats
-- ----------------------------
CREATE TABLE `tblblogsearchstats` (
  `searchterm` varchar(255) DEFAULT NULL,
  `searched` datetime DEFAULT NULL,
  `blog` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tblblogsubscribers
-- ----------------------------
CREATE TABLE `tblblogsubscribers` (
  `email` varchar(50) DEFAULT NULL,
  `token` varchar(35) DEFAULT NULL,
  `blog` varchar(50) DEFAULT NULL,
  `verified` tinyint(1) DEFAULT NULL,
  KEY `blogSubscribers_blog` (`blog`),
  KEY `blogSubscribers_verified` (`verified`),
  KEY `blogSubscribers_email` (`email`),
  KEY `blogSubscribers_token` (`token`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tblblogtextblocks
-- ----------------------------
CREATE TABLE `tblblogtextblocks` (
  `id` varchar(35) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `body` longtext,
  `blog` varchar(50) DEFAULT NULL,
  KEY `blogTextBlocks_blog` (`blog`),
  KEY `blogTextBlocks_label` (`label`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tblblogtrackbacks
-- ----------------------------
CREATE TABLE `tblblogtrackbacks` (
  `id` varchar(35) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `blogname` varchar(255) DEFAULT NULL,
  `posturl` varchar(255) DEFAULT NULL,
  `excerpt` text,
  `created` datetime DEFAULT NULL,
  `entryid` varchar(35) DEFAULT NULL,
  `blog` varchar(50) DEFAULT NULL,
  KEY `blogTrackBacks_entryid` (`entryid`),
  KEY `blogTrackBacks_blog` (`blog`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tbluserroles
-- ----------------------------
CREATE TABLE `tbluserroles` (
  `username` varchar(50) DEFAULT NULL,
  `roleidfk` varchar(35) DEFAULT NULL,
  `blog` varchar(50) DEFAULT NULL,
  KEY `blogUserRoles_blog` (`blog`),
  KEY `blogUserRoles_username` (`username`),
  KEY `blogUserRoles_roleidfk` (`roleidfk`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tblusers
-- ----------------------------
CREATE TABLE `tblusers` (
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(256) DEFAULT NULL,
  `salt` varchar(256) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `blog` varchar(255) DEFAULT NULL,
  KEY `blogUsers_username` (`username`),
  KEY `blogUsers_blog` (`blog`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `forum_conferences` VALUES ('ECB9ECD8-0353-0CB4-A3442B06553ED4FF', 'BeerInHand Forums', 'Welcome to the BeerInHand Forums!', '1', '6', '59973011-DA2B-CCBA-29B9F82E0A662872', '590015C4-9359-9A18-337612B2B213FE00', '2012-04-16 12:17:26');
INSERT INTO `forum_forums` VALUES ('ED26E68C-DE04-8BF8-7B0D59C59E40296D', 'The Brewer\'s Apprentice', 'Hand holding for the novice brewer.', '1', '1', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', '3', 'FAF1705C-D678-4832-328C45DA890AB047', 'C41F2092-C251-86FE-56A2A7C27B02CC13', '2012-03-01 20:30:10', '100');
INSERT INTO `forum_forums` VALUES ('ED32E09A-B3C0-D687-B2B5B5AC65FE5909', 'Mashing', 'Discussions related to the mashing of malt.', '1', '0', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', '0', null, null, null, '200');
INSERT INTO `forum_forums` VALUES ('ED7E3F46-DD8E-871F-4F32B10E3C0CC5D3', 'Boiling', 'Discussions related to wort boiling process.', '1', '0', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', '0', null, null, null, '300');
INSERT INTO `forum_forums` VALUES ('EF3A5273-EFC3-8D0E-174F385303E377D3', 'Chilling', 'Discussions related to the wort chilling process.', '1', '0', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', '0', null, null, null, '400');
INSERT INTO `forum_forums` VALUES ('EFBC7158-CE90-88A5-42ED1794F5FB074B', 'Fermentation', 'Discussions related to the fermentation of beer.', '1', '0', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', '0', null, null, null, '500');
INSERT INTO `forum_forums` VALUES ('EFCCB843-0C51-094B-17EC83E736DAF34F', 'Bottling', 'Discussions related to the bottling of beer.', '1', '0', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', '0', null, null, null, '600');
INSERT INTO `forum_forums` VALUES ('EFF0CFF6-DAFC-57F1-83193226EF3D5418', 'Website Bugs', 'Please report any website bugs here.', '1', '0', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', '2', '59973011-DA2B-CCBA-29B9F82E0A662872', '590015C4-9359-9A18-337612B2B213FE00', '2012-04-16 12:17:26', '10000');
INSERT INTO `forum_forums` VALUES ('F258C5F6-A17F-B17B-F6A03A166ABCDB3F', 'Kegging', 'Discussions related to the kegging of beer.', '1', '0', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', '0', null, null, null, '700');
INSERT INTO `forum_forums` VALUES ('AD20C16C-0BA6-D62D-750D47D95071BC48', 'BeerInHand User Guide', 'Documentation on using the website', '1', '0', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', '1', '543B0D4C-F1B7-3056-EE2F97D87DE2E868', 'C41F2092-C251-86FE-56A2A7C27B02CC13', '2012-04-16 09:47:34', '800');
INSERT INTO `forum_groups` VALUES ('AD0F29B5-BEED-B8BD-CAA9379711EBF168', 'forumsmember');
INSERT INTO `forum_groups` VALUES ('AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2', 'forumsmoderator');
INSERT INTO `forum_groups` VALUES ('C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D', 'forumsadmin');
INSERT INTO `forum_messages` VALUES ('FAF16EF1-F2CE-86DF-A368A17594EA4A32', 'Welcome to the Forums!', 'If you are new to brewing and need some help, post questions here.', '2012-02-29 22:26:25', '2012-03-01 13:47:24', 'BeerInHand', 'C41F2092-C251-86FE-56A2A7C27B02CC13', 'FAF1705C-D678-4832-328C45DA890AB047', 'specialty.jpg', '133BB9D9-9B2F-7C99-6AD16E485DD7AB08.jpg', 'FAF16EF2-FE89-4637-D4770CA7D4D4B278');
INSERT INTO `forum_messages` VALUES ('1EA307BF-F6B0-F839-CDD3C6E60C1885B6', 'RE: Welcome to the Forums!', 'Thanks so [i]much[/i], it means a lot to me.', '2012-03-01 15:04:32', '2012-03-01 16:56:41', 'BeerInHand', 'C41F2092-C251-86FE-56A2A7C27B02CC13', 'FAF1705C-D678-4832-328C45DA890AB047', '', '', '1EA307C0-D636-F9B6-10108BE7B9139954');
INSERT INTO `forum_messages` VALUES ('2A4830E0-EFB4-BC98-B973043601ACC79F', 'RE: Welcome to the Forums!', 'Another post?', '2012-03-01 20:30:10', null, '', 'C41F2092-C251-86FE-56A2A7C27B02CC13', 'FAF1705C-D678-4832-328C45DA890AB047', '', '', '2A4830E1-BE1F-D494-50A1692A5F98FFC8');
INSERT INTO `forum_messages` VALUES ('543B0BE6-B323-45F7-297552AC00C45D2C', 'BeerInHand Site Overview', '[b]What is BeerInHand?[/b]\r\nIt\'s a beer blog. It\'s a beer recipe calculator.  It\'s a social network for brewers.  It\'s an online database to store your brewing sessions and tasting notes.  It\'s a place to network with friends and share thoughts and recipes.\r\n\r\n[b]How it works[/b]\r\nThere are 6 main sections to BIH. Visitors to BIH that are not logged in can see [u]most[/u] of the content on BIH and have access to the beer calculation portions of the site but cannot save data or post new content.\r\n\r\n[size=5][i]<PICTURE OF MENU HERE>[/i][/size]\r\n\r\n[b]THE MILL[/b] \r\n\r\nIf not logged in, this page will show a brief description of site, # of batch brewed this past week, gallons of beer, etc, link to sign up / login. If you are logged in, “The Mill” is the main page of the BIH web site. It serves as an aggregator for all your activities as well as those of any brewers whose grist you have added to your mill.\r\n\r\n[b]BLOG[/b]\r\n\r\nThe BIH blog page serves as an aggregator for the most interesting blog entries posted by the users of BIH. The blog entries most recommended by other users can be promoted by the site admin to the main BIH blog.\r\n\r\n[b]FORUM[/b]\r\n\r\nThis section is a traditional web forum consisting of several topical sections. User can post topics and comment on existing topics related to beer and brewing.\r\n\r\n[b]RECIPE CALC[/b]\r\n\r\nThis section is a beer recipe calculator.\r\n\r\n[b]BREW CALC[/b]\r\n\r\nThis section contains many calculators useful for beer brewing.\r\n\r\n[b]EXPLORER[/b]\r\n\r\nThis section allows users to navigate through the various data centers stored on BIH, such as grains, hops, yeast, etc.\r\n\r\n[b]MY BIH[/b]\r\n\r\nThis section only appears when a brewer is logged in. This serves as the main hub to maintain brewing records, post blog entries, track followed brewers and favorite recipes, and maintain profile data.\r\n\r\nEach brewer has a \"MY BIH\" section within BIH. This section consists of several pages:\r\n\r\n[b]GRIST[/b] - This page displays a brewer\'s \"grist\", which is an aggregate of their brewing and other site activities such as new blog entries, posting in the forums, following another brewer, et al.\r\n\r\n[b]BREWS[/b] - This section shows all the recipes a brewer has stored on BIH. It allows a brewer to view their recipes by Date, Name, and Style and provides quick summary level reporting of totals and averages.\r\n\r\n[b]FAVORITES[/b] - This section shows all the recipes a brewer has Favorited.\r\n\r\n[b]STATS[/b] - This section shows a breakdown of a user\'s brewing stats such as top ten styles, malts, hops, yeast, etc.\r\n\r\n[b]BLOG[/b] - This optional section allows each brewer to maintain a blog. Blogs can be recommended by other brewers and with enough recommendations might be elevated to the BIH main blog page.\r\n\r\n[b]SETTINGS[/b] - This section allows a user to maintian profile settings.', '2012-04-16 09:47:34', '2012-04-16 09:53:32', 'BeerInHand', 'C41F2092-C251-86FE-56A2A7C27B02CC13', '543B0D4C-F1B7-3056-EE2F97D87DE2E868', '', '', '543B0BE7-98DA-947C-06A764E9B57C31B8');
INSERT INTO `forum_messages` VALUES ('590E7284-911C-6B36-E8C5CD199FF603EB', 'No bug...just curious', 'Hey,\r\n\r\nI\'m wondering what your determining factor was to build it for ColdFussion?\r\n\r\nI\'ve been working on the layout of a site myself and was trying to find the best platform to build it on.\r\n\r\nThanks!', '2012-04-16 12:02:30', null, '', '590015C4-9359-9A18-337612B2B213FE00', '590E729E-B099-6923-D46C17EF433D285F', '', '', '590E7285-F72F-F6D2-1CA5B121787745F9');
INSERT INTO `forum_messages` VALUES ('59972FBD-90DC-BD0F-F03A71BDAF8D96DA', 'Recipe Creation', 'It has a few popup errors when creating a brew.\r\n\r\nI think it looks for requirements before you can even enter the info.', '2012-04-16 12:17:26', null, '', '590015C4-9359-9A18-337612B2B213FE00', '59973011-DA2B-CCBA-29B9F82E0A662872', '', '', '59972FBE-FD9E-5053-60E37DBC61DCD8C3');
INSERT INTO `forum_permissions` VALUES ('F86AD673-C710-C324-9A3F1CCAF7F752D8', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_permissions` VALUES ('F86AD6A8-BCCB-C0F7-024533C126046039', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F86AD697-F20C-07CC-EEA498475B7BB7C9', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_permissions` VALUES ('F86AD6A0-A8EA-7530-7A54F6EF00E83296', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('1338CE22-BEA4-F693-22E91A9B03C1A709', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'ED26E68C-DE04-8BF8-7B0D59C59E40296D', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('1338CE1B-EBBE-0932-B744C91F985CFD2A', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'ED26E68C-DE04-8BF8-7B0D59C59E40296D', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F89E5AAD-D2C0-874C-195B0CF2339051CC', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'ED32E09A-B3C0-D687-B2B5B5AC65FE5909', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F89E5AC9-EA8D-6844-925CA2ADD51ED404', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'ED32E09A-B3C0-D687-B2B5B5AC65FE5909', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F89E5AC1-BB7C-2DA1-4677FCEEF77EB800', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'ED32E09A-B3C0-D687-B2B5B5AC65FE5909', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F89F1034-A3D8-725F-46E9B607D19AB8B5', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'ED7E3F46-DD8E-871F-4F32B10E3C0CC5D3', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F89F1090-C5E2-FB83-D972873592297797', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'ED7E3F46-DD8E-871F-4F32B10E3C0CC5D3', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F89F1083-9441-72BA-CA17F269EA2F15FF', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'ED7E3F46-DD8E-871F-4F32B10E3C0CC5D3', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('EF75D9A1-03DE-B6F5-E4A2069397F0C3F6', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'EF1A0FD5-95D3-61EE-D694F99D1FA396E9', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_permissions` VALUES ('EF75DA1E-B52C-8963-1275B5F5C32ECDB7', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'EF1A0FD5-95D3-61EE-D694F99D1FA396E9', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('EF75DA15-FB8F-52A8-8BA89E1A301EBAA4', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'EF1A0FD5-95D3-61EE-D694F99D1FA396E9', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F7A386ED-9ABA-5634-D9EBC7B3C20EB036', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'EF3A5273-EFC3-8D0E-174F385303E377D3', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_permissions` VALUES ('F7A387BF-AB59-DB19-BAD1CD0BD858D1BC', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'EF3A5273-EFC3-8D0E-174F385303E377D3', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F7A387B7-E4ED-349D-5A477152A43DE0FD', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'EF3A5273-EFC3-8D0E-174F385303E377D3', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F7A45A8B-C3CE-11C7-E5D6E69754869A3C', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'EFBC7158-CE90-88A5-42ED1794F5FB074B', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_permissions` VALUES ('F7A45AB6-FD6C-A29F-4DC057C65B88D944', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'EFBC7158-CE90-88A5-42ED1794F5FB074B', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F7A45AAE-D166-F8CA-F6FA35F5AF36F954', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'EFBC7158-CE90-88A5-42ED1794F5FB074B', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F7A526CF-0532-6C09-43F257C24F400FDA', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'EFCCB843-0C51-094B-17EC83E736DAF34F', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_permissions` VALUES ('F7A52708-B18F-02A8-5C50CDDE1422E356', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'EFCCB843-0C51-094B-17EC83E736DAF34F', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F7A52700-B011-2FD8-2142DDBB11C299CA', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'EFCCB843-0C51-094B-17EC83E736DAF34F', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F7A78B93-9BA6-DC11-33BA1F68E991D12B', '7EA5070B-9774-E11E-96E727122408C03C', 'EFF0CFF6-DAFC-57F1-83193226EF3D5418', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_permissions` VALUES ('F7A78BAB-97DA-1225-AFB97EC4565149AF', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'EFF0CFF6-DAFC-57F1-83193226EF3D5418', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_permissions` VALUES ('F7A78C88-FFD8-A010-9552EAF2C84CDBB8', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'EFF0CFF6-DAFC-57F1-83193226EF3D5418', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F7A78BDC-0872-6DDE-2A12EF12016B6F75', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'EFF0CFF6-DAFC-57F1-83193226EF3D5418', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F7A6DBAF-C978-91B9-EDAE334F8892CB54', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'F258C5F6-A17F-B17B-F6A03A166ABCDB3F', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_permissions` VALUES ('F7A6DBE7-0184-AC87-FD4E048101E55AB9', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'F258C5F6-A17F-B17B-F6A03A166ABCDB3F', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F7A6DBDF-E84F-3833-1E57B2208BAAA46A', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'F258C5F6-A17F-B17B-F6A03A166ABCDB3F', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F86AD684-ED1A-429A-DF3820F860160FFD', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F86AD67C-E31C-80A2-1D72C6D810408E1C', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F89E5AA5-CC07-DCEF-1133D1F9E8259CD5', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'ED32E09A-B3C0-D687-B2B5B5AC65FE5909', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F89E5A9D-BCE7-D7C3-2F0640F749E98301', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'ED32E09A-B3C0-D687-B2B5B5AC65FE5909', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_permissions` VALUES ('F89F102A-B176-9F85-2420A2EBE680E0C2', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'ED7E3F46-DD8E-871F-4F32B10E3C0CC5D3', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F89F1020-9611-137D-B780557CD271F7FE', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'ED7E3F46-DD8E-871F-4F32B10E3C0CC5D3', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_permissions` VALUES ('F7A386F7-E40A-2C29-6F8FBE511F511EB4', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'EF3A5273-EFC3-8D0E-174F385303E377D3', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F7A38700-ACB8-2829-5164527EB0F74803', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'EF3A5273-EFC3-8D0E-174F385303E377D3', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F7A45A93-0A5A-7625-C517655E15951492', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'EFBC7158-CE90-88A5-42ED1794F5FB074B', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F7A45A9B-DBF7-8D21-D24292B81DCD8A5D', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'EFBC7158-CE90-88A5-42ED1794F5FB074B', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F7A526DC-CB9E-28BB-D0C5D86874D969A3', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'EFCCB843-0C51-094B-17EC83E736DAF34F', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F7A526EA-0093-1271-885FCA981C763B6F', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'EFCCB843-0C51-094B-17EC83E736DAF34F', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F7A6DBBE-C86C-9BB1-EF59E00E7D8BCFE7', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'F258C5F6-A17F-B17B-F6A03A166ABCDB3F', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F7A6DBCA-E2B0-215A-47A574D9AA2629D8', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'F258C5F6-A17F-B17B-F6A03A166ABCDB3F', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('F7A78BB7-A045-B67A-04553E6B1A3955DF', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'EFF0CFF6-DAFC-57F1-83193226EF3D5418', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('F7A78BC5-DB3B-FEEE-8415BB358CD1828C', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'EFF0CFF6-DAFC-57F1-83193226EF3D5418', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('1338CE07-CBC7-396F-334B389EFCEB56CF', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'ED26E68C-DE04-8BF8-7B0D59C59E40296D', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('1338CDFF-9119-2B8B-9B82B6F33E4FCCCA', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'ED26E68C-DE04-8BF8-7B0D59C59E40296D', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('1338CD9C-A2D3-ABA7-F74F7C08794951CA', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'ED26E68C-DE04-8BF8-7B0D59C59E40296D', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_permissions` VALUES ('AD20C220-B093-F8EB-E8A8AF8333D3D4BD', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'AD20C16C-0BA6-D62D-750D47D95071BC48', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_permissions` VALUES ('AD20C22F-DC86-E4A1-9E030B998DC79255', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'AD20C16C-0BA6-D62D-750D47D95071BC48', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('AD20C234-EC2B-FA4C-72945296FAA317E5', '7EA5070C-E788-7378-8930FA15EF58BBD2', 'AD20C16C-0BA6-D62D-750D47D95071BC48', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_permissions` VALUES ('AD20C23F-A933-3EFA-4C23486637382E72', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'AD20C16C-0BA6-D62D-750D47D95071BC48', 'AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2');
INSERT INTO `forum_permissions` VALUES ('AD20C243-D9B1-2C0E-CD81FE283829484B', '7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'AD20C16C-0BA6-D62D-750D47D95071BC48', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_privatemessages` VALUES ('55537F57-CB11-2B3F-A6BA6CC779ECBB6A', '2D309961-FF1B-6C7A-4B722F376841E075', 'C41F2092-C251-86FE-56A2A7C27B02CC13', '2012-03-02 16:33:51', 'Thanks.', 'Hey', '0');
INSERT INTO `forum_ranks` VALUES ('0E6C13A6-0FD0-3785-9B48754C3E8D7408', 'Pot Scrubber', '0');
INSERT INTO `forum_rights` VALUES ('7EA5070B-9774-E11E-96E727122408C03C', 'CanView');
INSERT INTO `forum_rights` VALUES ('7EA5070C-E788-7378-8930FA15EF58BBD2', 'CanPost');
INSERT INTO `forum_rights` VALUES ('7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'CanEdit');
INSERT INTO `forum_search_log` VALUES ('much', '2012-03-01 22:32:15');
INSERT INTO `forum_search_log` VALUES ('much', '2012-03-01 22:32:48');
INSERT INTO `forum_search_log` VALUES ('much', '2012-03-01 22:33:13');
INSERT INTO `forum_search_log` VALUES ('much', '2012-03-01 22:34:15');
INSERT INTO `forum_search_log` VALUES ('much', '2012-03-01 22:34:41');
INSERT INTO `forum_search_log` VALUES ('much', '2012-03-01 22:35:51');
INSERT INTO `forum_search_log` VALUES ('much', '2012-03-01 22:36:47');
INSERT INTO `forum_search_log` VALUES ('much', '2012-03-01 22:37:30');
INSERT INTO `forum_search_log` VALUES ('much', '2012-03-01 22:37:54');
INSERT INTO `forum_search_log` VALUES ('much', '2012-03-01 22:39:23');
INSERT INTO `forum_search_log` VALUES ('much', '2012-03-01 22:39:37');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:39:46');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:42:02');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:43:01');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:43:27');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:44:29');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:45:08');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:46:17');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:46:34');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:46:53');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:47:35');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:48:18');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:49:05');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:50:02');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:50:42');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:52:37');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:53:01');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:54:04');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:54:31');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:54:50');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:55:12');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:55:24');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:56:41');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:57:06');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:57:28');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:57:47');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:58:00');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:58:39');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:58:48');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-01 22:59:03');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-02 17:03:52');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-02 17:05:15');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-02 17:05:44');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-02 17:06:37');
INSERT INTO `forum_search_log` VALUES ('to', '2012-03-02 17:07:02');
INSERT INTO `forum_subscriptions` VALUES ('C6468F65-F5C4-D038-939A9745D4F9085C', '77F9833E-C8AC-2F31-9A80617D3EB8FEA2', 'FAF1705C-D678-4832-328C45DA890AB047', null, null);
INSERT INTO `forum_subscriptions` VALUES ('C6508206-EE95-6F9A-E348B72AD971441F', '77F9833E-C8AC-2F31-9A80617D3EB8FEA2', null, null, 'ECB9ECD8-0353-0CB4-A3442B06553ED4FF');
INSERT INTO `forum_threads` VALUES ('FAF1705C-D678-4832-328C45DA890AB047', 'Welcome to the Forums!', '1', 'C41F2092-C251-86FE-56A2A7C27B02CC13', 'ED26E68C-DE04-8BF8-7B0D59C59E40296D', '2012-02-29 22:26:25', '0', '3', 'C41F2092-C251-86FE-56A2A7C27B02CC13', '2012-03-01 20:30:10');
INSERT INTO `forum_threads` VALUES ('543B0D4C-F1B7-3056-EE2F97D87DE2E868', 'BeerInHand Site Overview', '1', 'C41F2092-C251-86FE-56A2A7C27B02CC13', 'AD20C16C-0BA6-D62D-750D47D95071BC48', '2012-04-16 09:47:34', '1', '1', 'C41F2092-C251-86FE-56A2A7C27B02CC13', '2012-04-16 09:47:34');
INSERT INTO `forum_threads` VALUES ('590E729E-B099-6923-D46C17EF433D285F', 'No bug...just curious', '1', '590015C4-9359-9A18-337612B2B213FE00', 'EFF0CFF6-DAFC-57F1-83193226EF3D5418', '2012-04-16 12:02:30', '0', '1', '590015C4-9359-9A18-337612B2B213FE00', '2012-04-16 12:02:30');
INSERT INTO `forum_threads` VALUES ('59973011-DA2B-CCBA-29B9F82E0A662872', 'Recipe Creation', '1', '590015C4-9359-9A18-337612B2B213FE00', 'EFF0CFF6-DAFC-57F1-83193226EF3D5418', '2012-04-16 12:17:26', '0', '1', '590015C4-9359-9A18-337612B2B213FE00', '2012-04-16 12:17:26');
INSERT INTO `forum_users` VALUES ('C41F2092-C251-86FE-56A2A7C27B02CC13', 'BeerInHand', '21232F297A57A5A743894A0E4A801FC3', 'support@beerinhand.com', 'I got Hand.', '2012-02-28 20:54:03', '0', 'siteadmin.png');
INSERT INTO `forum_users` VALUES ('5189C939-A114-353B-E9FF4F9D6F5F77FF', 'pmichael', '', 'pmgerholdt@hotmail.com', '', '2012-03-22 12:00:53', '1', '');
INSERT INTO `forum_users` VALUES ('5189C975-06E1-98C6-888F0C237790D714', 'BarNay42', '', 'tomconville@hotmail.com', '', '2012-03-22 12:00:53', '1', '');
INSERT INTO `forum_users` VALUES ('51796381-E0B7-C8CF-7F3A4DD277DAC3A1', 'Boneyard', '', 'rust1d@usa.net', 'Hop to it.', '2012-02-28 20:54:03', '0', 'ECD21323-AF0D-0622-803842B0539B7426.jpg');
INSERT INTO `forum_users` VALUES ('54D47CA1-0457-45C6-41CD36F5504CFC67', 'MaltMan', '', 'rust1d@usa.net', 'Malt Me.', '2012-02-28 20:54:03', '1', '');
INSERT INTO `forum_users` VALUES ('F766979D-B7A5-239F-5C5FA4323A44804C', 'stevelogan', '', 'steve.logan@gmail.com', '', '2012-04-14 14:32:49', '1', '');
INSERT INTO `forum_users` VALUES ('FF73BAD9-BD82-06AC-C08DD225937E4B23', 'jflebano', '', 'jflebano@verizon.net', '', '2012-04-14 18:17:57', '1', '');
INSERT INTO `forum_users` VALUES ('04E31E49-B2A6-A08E-57471A0BE0BAFB7B', 'eveneon', '', 'evehoyt@usa.net', '', '2012-04-14 20:49:55', '1', '');
INSERT INTO `forum_users` VALUES ('209CD46E-E46A-87E0-104D82E2149A3750', 'coachscrubby', '', 'patackroyd@verizon.net', '', '2012-04-15 09:44:13', '1', '');
INSERT INTO `forum_users` VALUES ('239572F8-F995-E581-77F8D1A45BC51A76', 'Nr3254111', '', 'nr3254111@netscape.net', '', '2012-04-15 11:07:18', '1', '');
INSERT INTO `forum_users` VALUES ('23D8252C-C89F-E69C-84B383E4CC12374D', 'rickfrothingham', '', 'rickfrothingham@gmail.com', '', '2012-04-15 11:14:35', '1', '');
INSERT INTO `forum_users` VALUES ('2450FDD0-A7F9-6716-60CF13481DD36F88', 'Nokeypu', '', 'mike.malaney@gmail.com', '', '2012-04-15 11:27:47', '1', '');
INSERT INTO `forum_users` VALUES ('590015C4-9359-9A18-337612B2B213FE00', 'JayInJersey', '', 'jrovner_receipts@comcast.net', '', '2012-04-16 12:00:56', '0', '');
INSERT INTO `forum_users_groups` VALUES ('C189C5AC-7E9B-AEC8-1DAEEEA03A562CF0', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_users_groups` VALUES ('C41F2092-C251-86FE-56A2A7C27B02CC13', 'C18B1118-7E9B-AEC8-14E8DB3C21EFCA1D');
INSERT INTO `forum_users_groups` VALUES ('2D309961-FF1B-6C7A-4B722F376841E075', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('72A67454-082B-1823-2D0D70A2C207FBB8', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('756B70F1-0B8E-0ED6-514A300AC26F6CD8', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('1137BC50-C10C-BC47-53C003822762D396', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('51796381-E0B7-C8CF-7F3A4DD277DAC3A1', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('5189C939-A114-353B-E9FF4F9D6F5F77FF', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('5189C975-06E1-98C6-888F0C237790D714', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('F766979D-B7A5-239F-5C5FA4323A44804C', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('FF73BAD9-BD82-06AC-C08DD225937E4B23', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('04E31E49-B2A6-A08E-57471A0BE0BAFB7B', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('209CD46E-E46A-87E0-104D82E2149A3750', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('239572F8-F995-E581-77F8D1A45BC51A76', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('23D8252C-C89F-E69C-84B383E4CC12374D', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('2450FDD0-A7F9-6716-60CF13481DD36F88', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `forum_users_groups` VALUES ('590015C4-9359-9A18-337612B2B213FE00', 'AD0F29B5-BEED-B8BD-CAA9379711EBF168');
INSERT INTO `tblblogcategories` VALUES ('7A8EB00B-C39B-435E-23467B5A5FA3FDFE', 'Test', 'Test', 'BeerInHand');
INSERT INTO `tblblogentries` VALUES ('7A8EAF23-AA37-31E2-7E4DAE2BD4D056BE', 'Is this thing on?', 'Welcome to BeerInHand! Things are dusty around here, but we\'re sweeping up and hope to have this place presentable real soon. In the meantime, create a user account, check out the Recipe Calculator, and drop on by the forums and introduce yourself.', '2012-02-12 12:41:00', null, 'test', 'BeerInHand', 'BeerInHand', '1', '', '0', '', '20', '1', '1', '', '', '', '');
INSERT INTO `tblblogentriescategories` VALUES ('7A8EB00B-C39B-435E-23467B5A5FA3FDFE', '7A8EAF23-AA37-31E2-7E4DAE2BD4D056BE');
INSERT INTO `tblblogroles` VALUES ('7F183B27-FEDE-0D6F-E2E9C35DBC7BFF19', 'AddCategory', 'The ability to create a new category when editing a blog entry.');
INSERT INTO `tblblogroles` VALUES ('7F197F53-CFF7-18C8-53D0C85FCC2CA3F9', 'ManageCategories', 'The ability to manage blog categories.');
INSERT INTO `tblblogroles` VALUES ('7F25A20B-EE6D-612D-24A7C0CEE6483EC2', 'Admin', 'A special role for the admin. Allows all functionality.');
INSERT INTO `tblblogroles` VALUES ('7F26DA6C-9F03-567F-ACFD34F62FB77199', 'ManageUsers', 'The ability to manage blog users.');
INSERT INTO `tblblogroles` VALUES ('800CA7AA-0190-5329-D3C7753A59EA2589', 'ReleaseEntries', 'The ability to both release a new entry and edit any released entry.');
INSERT INTO `tblblogsubscribers` VALUES ('jac@jac.com', 'D71BBF82-BAD8-B0A0-7F22F791D02B631F', 'Default', '0');
INSERT INTO `tbluserroles` VALUES ('BeerInHand', '7F25A20B-EE6D-612D-24A7C0CEE6483EC2', 'BeerInHand');
INSERT INTO `tblusers` VALUES ('BeerInHand', '6920E2B6FC86925FF4ED4A4532A10D0F8FFDB117EA9B5300A4B6CDE3FF0E1B677DFAAA65C94813AE99421D13B8F93891683C0F78A80299A6D0CE53D032666857', 'tcuz00zltlc7YL0sdvUQ1jZx/n0DQU8D1xzLt+lcKUw=', 'John Varady', 'BeerInHand');