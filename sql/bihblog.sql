/*
MySQL Data Transfer
Source Host: localhost
Source Database: bihblog
Target Host: localhost
Target Database: bihblog
Date: 3/9/2012 5:27:54 PM
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for tblblogcategories
-- ----------------------------
CREATE TABLE `tblblogcategories` (
  `categoryid` varchar(35) NOT NULL,
  `categoryname` varchar(50) default NULL,
  `categoryalias` varchar(50) default NULL,
  `blog` varchar(50) default NULL,
  PRIMARY KEY  (`categoryid`),
  KEY `blogCategories_categoryalias` (`categoryalias`),
  KEY `blogCategories_categoryname` (`categoryname`),
  KEY `blogCategories_blog` (`blog`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tblblogcomments
-- ----------------------------
CREATE TABLE `tblblogcomments` (
  `id` varchar(35) NOT NULL,
  `entryidfk` varchar(35) default NULL,
  `name` varchar(50) default NULL,
  `email` varchar(50) default NULL,
  `comment` text,
  `posted` datetime default NULL,
  `subscribe` tinyint(1) default NULL,
  `website` varchar(255) default NULL,
  `moderated` tinyint(1) default NULL,
  `subscribeonly` tinyint(1) default NULL,
  `killcomment` varchar(35) default NULL,
  PRIMARY KEY  (`id`),
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
  `title` varchar(100) default NULL,
  `body` longtext,
  `posted` datetime default NULL,
  `morebody` longtext,
  `alias` varchar(100) default NULL,
  `username` varchar(50) default NULL,
  `blog` varchar(50) default NULL,
  `allowcomments` tinyint(1) default NULL,
  `enclosure` varchar(255) default NULL,
  `filesize` int(11) unsigned default NULL,
  `mimetype` varchar(255) default NULL,
  `views` int(11) unsigned default NULL,
  `released` tinyint(1) default NULL,
  `mailed` tinyint(1) default NULL,
  `summary` varchar(255) default NULL,
  `subtitle` varchar(100) default NULL,
  `keywords` varchar(100) default NULL,
  `duration` varchar(10) default NULL,
  PRIMARY KEY  (`id`),
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
  `categoryidfk` varchar(35) default NULL,
  `entryidfk` varchar(35) default NULL,
  KEY `blogEntriesCategories_entryidfk` (`entryidfk`,`categoryidfk`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tblblogentriesrelated
-- ----------------------------
CREATE TABLE `tblblogentriesrelated` (
  `entryid` varchar(35) default NULL,
  `relatedid` varchar(35) default NULL,
  KEY `blogEntriesRelated_entryid` (`entryid`),
  KEY `blogEntriesRelated_relatedid` (`relatedid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tblblogpages
-- ----------------------------
CREATE TABLE `tblblogpages` (
  `id` varchar(35) NOT NULL,
  `blog` varchar(50) default NULL,
  `title` varchar(255) default NULL,
  `alias` varchar(100) default NULL,
  `body` longtext,
  `showlayout` tinyint(1) NOT NULL,
  KEY `blogPages_blog` (`blog`),
  KEY `blogPages_alias` (`alias`),
  KEY `blogPages_title` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tblblogroles
-- ----------------------------
CREATE TABLE `tblblogroles` (
  `id` varchar(35) NOT NULL,
  `role` varchar(50) default NULL,
  `description` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `blogRoles_role` (`role`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tblblogsearchstats
-- ----------------------------
CREATE TABLE `tblblogsearchstats` (
  `searchterm` varchar(255) default NULL,
  `searched` datetime default NULL,
  `blog` varchar(50) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tblblogsubscribers
-- ----------------------------
CREATE TABLE `tblblogsubscribers` (
  `email` varchar(50) default NULL,
  `token` varchar(35) default NULL,
  `blog` varchar(50) default NULL,
  `verified` tinyint(1) default NULL,
  KEY `blogSubscribers_blog` (`blog`),
  KEY `blogSubscribers_verified` (`verified`),
  KEY `blogSubscribers_email` (`email`),
  KEY `blogSubscribers_token` (`token`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tblblogtextblocks
-- ----------------------------
CREATE TABLE `tblblogtextblocks` (
  `id` varchar(35) default NULL,
  `label` varchar(255) default NULL,
  `body` longtext,
  `blog` varchar(50) default NULL,
  KEY `blogTextBlocks_blog` (`blog`),
  KEY `blogTextBlocks_label` (`label`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tblblogtrackbacks
-- ----------------------------
CREATE TABLE `tblblogtrackbacks` (
  `id` varchar(35) default NULL,
  `title` varchar(255) default NULL,
  `blogname` varchar(255) default NULL,
  `posturl` varchar(255) default NULL,
  `excerpt` text,
  `created` datetime default NULL,
  `entryid` varchar(35) default NULL,
  `blog` varchar(50) default NULL,
  KEY `blogTrackBacks_entryid` (`entryid`),
  KEY `blogTrackBacks_blog` (`blog`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tbluserroles
-- ----------------------------
CREATE TABLE `tbluserroles` (
  `username` varchar(50) default NULL,
  `roleidfk` varchar(35) default NULL,
  `blog` varchar(50) default NULL,
  KEY `blogUserRoles_blog` (`blog`),
  KEY `blogUserRoles_username` (`username`),
  KEY `blogUserRoles_roleidfk` (`roleidfk`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tblusers
-- ----------------------------
CREATE TABLE `tblusers` (
  `username` varchar(50) default NULL,
  `password` varchar(256) default NULL,
  `salt` varchar(256) default NULL,
  `name` varchar(50) default NULL,
  `blog` varchar(255) default NULL,
  KEY `blogUsers_username` (`username`),
  KEY `blogUsers_blog` (`blog`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `tblblogcategories` VALUES ('7A8EB00B-C39B-435E-23467B5A5FA3FDFE', 'Test', 'Test', 'Default');
INSERT INTO `tblblogcomments` VALUES ('801D9E30-0E17-FD62-34E2C00BC4AB3306', '7A8EAF23-AA37-31E2-7E4DAE2BD4D056BE', 'Me', 'rust1d@usa.net', 'Hello', '2012-02-12 17:17:04', '0', '', '1', '0', '801D9E31-0CAE-8CFB-D8761A8655C11D51');
INSERT INTO `tblblogcomments` VALUES ('8667EB0F-01DD-996F-78569E9058F9E2FE', '7A8EAF23-AA37-31E2-7E4DAE2BD4D056BE', 'Sam', 'chimpeach@gmail.com', 'Do you do windows?', '2012-02-12 20:12:59', '0', '', '1', '0', '8667EB10-DCC3-5B2B-C2A49CBE9D2FCE83');
INSERT INTO `tblblogentries` VALUES ('7A8EAF23-AA37-31E2-7E4DAE2BD4D056BE', 'test', 'This is a test\r\n<img src=\"http://192.168.1.102/beerinhand/blog/images/darkbelgian.jpg\" />', '2012-02-12 12:41:00', null, 'test', 'admin', 'Default', '1', '', '0', '', '8', '1', '1', '', '', '', '');
INSERT INTO `tblblogentriescategories` VALUES ('7A8EB00B-C39B-435E-23467B5A5FA3FDFE', '7A8EAF23-AA37-31E2-7E4DAE2BD4D056BE');
INSERT INTO `tblblogroles` VALUES ('7F183B27-FEDE-0D6F-E2E9C35DBC7BFF19', 'AddCategory', 'The ability to create a new category when editing a blog entry.');
INSERT INTO `tblblogroles` VALUES ('7F197F53-CFF7-18C8-53D0C85FCC2CA3F9', 'ManageCategories', 'The ability to manage blog categories.');
INSERT INTO `tblblogroles` VALUES ('7F25A20B-EE6D-612D-24A7C0CEE6483EC2', 'Admin', 'A special role for the admin. Allows all functionality.');
INSERT INTO `tblblogroles` VALUES ('7F26DA6C-9F03-567F-ACFD34F62FB77199', 'ManageUsers', 'The ability to manage blog users.');
INSERT INTO `tblblogroles` VALUES ('800CA7AA-0190-5329-D3C7753A59EA2589', 'ReleaseEntries', 'The ability to both release a new entry and edit any released entry.');
INSERT INTO `tblblogsubscribers` VALUES ('jac@jac.com', 'D71BBF82-BAD8-B0A0-7F22F791D02B631F', 'Default', '0');
INSERT INTO `tbluserroles` VALUES ('admin', '7F25A20B-EE6D-612D-24A7C0CEE6483EC2', 'Default');
INSERT INTO `tblusers` VALUES ('admin', '74FAE06F4B7BB31F16FA3CB4C873C88FB3669E413603CD103D714CC8C6B153188CEE84D3172F60027D96BAB4A79F275543865C80A927312D5CF00F7DD3F1753A', '2XlAbs2fFEESboQCMue3N7yATpwT1QKAFNGIU0hZ35g=', 'Admin', 'Default');
