DROP TABLE hops;

CREATE TABLE hops (
  hp_hpid              INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  hp_hop              VARCHAR(25) NOT NULL DEFAULT '',
  hp_aalow              DECIMAL(3,1) UNSIGNED DEFAULT '0.0',
  hp_aahigh            DECIMAL(3,1) UNSIGNED DEFAULT '0.0',
  hp_grown              VARCHAR(15) DEFAULT '',
  hp_profile            VARCHAR(100) DEFAULT '',
  hp_use              VARCHAR(100) DEFAULT '',
  hp_example            VARCHAR(100) DEFAULT '',
  hp_sub              VARCHAR(100) DEFAULT '',
  hp_info              VARCHAR(1000) DEFAULT '',
  hp_dry              TINYINT(1) DEFAULT '0',
  hp_aroma              TINYINT(1) DEFAULT '0',
  hp_bitter            TINYINT(1) DEFAULT '0',
  hp_finish            TINYINT(1) DEFAULT '0',
  hp_dla              TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (hp_hpid),
  UNIQUE KEY hp_type (hp_hop, hp_grown)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;


INSERT INTO `hops` VALUES ('1', 'Bramling Cross', '2.0', '12.0', 'England', 'Thre is no information to enter.', '', '', 'There is none.', 'This is where the information would go. I guess I\'d have to type a good bit of information into this field if I want to test it out right.\r\n', '0', '-1', '0', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('2', 'Brewer\'s Gold', '8.0', '9.0', 'England', 'poor aroma;  sharp bittering hop', 'bittering for ales', '', 'Bullion', '', '0', '0', '-1', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('3', 'Bullion', '8.0', '11.0', 'England', 'poor aroma;  sharp bittering and blackcurrant flavor when used in the boil', 'bittering hop for British style ales, perhaps some finishing', '', 'Brewer\'s Gold', '', '0', '0', '-1', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('4', 'Cascade', '6.6', '6.6', 'USA', 'strong spicy, floral, citrus (especially grapefruit) aroma', 'bittering, finishing, dry hopping for American style ales', 'Sierra Nevada Pale Ale, Anchor Liberty Ale & Old Foghorn', 'Centennial', '', '-1', '0', '-1', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('5', 'Centennial', '9.9', '10.3', 'USA', 'spicy, floral, citrus aroma;  clean bittering hop (Super Cascade?)', 'general purpose bittering, aroma, some dry hopping', 'Sierra Nevada Celebration Ale, Sierra Nevada Bigfoot Ale', 'Cascade', '', '-1', '-1', '-1', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('6', 'Chinook', '12.0', '14.0', 'USA', 'heavy spicy aroma; strong versatile bittering hop, astringent in large quantitie', '', 'Sierra Nevada Celebration Ale, Sierra Nevada Stout', 'Galena, Eroica, Brewer\'s Gold, Nugget, Bullion', '', '0', '0', '-1', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('7', 'Cluster', '5.5', '8.5', 'USA', 'poor, sharp aroma;  sharp bittering hop', 'general purpose bittering (Aussie version used as finishing hop)', 'Winterhook Christmas Ale', 'Galena, Cascade, Eroica', '', '0', '0', '-1', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('8', 'Columbus', '14.0', '16.0', 'USA', '', '', '', '', '', '0', '0', '-1', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('9', 'Comets', '0.0', '0.0', 'USA', '', '', '', '', '', '0', '0', '0', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('10', 'Crystal', '2.0', '5.0', 'USA', 'mild, pleasant, slightly spicy', '', '', 'Mittelfrueh, Hersbrucker, Liberty, Mt Hood', '', '0', '-1', '0', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('11', 'East Kent Goldings', '4.3', '4.3', 'England', 'spicy/floral, earthy, rounded, mild aroma; spicy (candy-like?) flavor', 'bittering, finishing, dry hopping for British style ales', 'Young\'s Special London Ale, Samuel Smith\'s Pale Ale, Fuller\'s ESB', 'BC Goldings', '', '-1', '0', '-1', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('12', 'Eroica', '12.1', '12.1', 'USA', 'clean bittering hop', 'general purpose bittering', 'Ballard Bitter, Blackhook Porter, Anderson Valley Boont Amber', 'Northern Brewer, Galena', '', '0', '0', '-1', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('13', 'Fuggles', '3.5', '5.5', 'England', 'mild, soft, grassy, floral aroma', 'finishing / dry hopping for all ales, dark lagers', 'Samuel Smith\'s Pale Ale, Old Peculier, Thomas Hardy\'s Ale', 'East Kent Goldings, Willamette', '', '-1', '0', '0', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('14', 'Galena', '11.5', '11.5', 'USA', 'strong, clean bittering hop', 'gen eral purpose bittering', '', 'Northern Brewer, Eroica, Cluster', '', '0', '0', '-1', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('15', 'Green Bullet', '12.0', '12.0', 'New Zealand', '', '', '', '', '', '0', '0', '0', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('16', 'Hallertauer', '0.0', '0.0', 'Germany', '', '', '', 'Mittelfrueh, Hersbrucker', '', '0', '0', '-1', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('17', 'Hersbrucker', '1.9', '1.9', 'Germany', 'pleasant, spicy/mild, noble, earthy aroma', 'finishing for German style lagers', 'Wheathook Wheaten Ale', 'Hallertauer Mittelfrueh, Mt. Hood, Liberty, Crystal', '', '0', '0', '0', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('19', 'Liberty', '3.8', '3.8', 'USA', 'fine, very mild aroma', 'finishing for German style lagers', 'Pete\'s Wicked Lager', 'Mittelfrueh, Hersbrucker, Crystal, Mt. Hood', '', '0', '0', '0', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('20', 'Lublin', '2.0', '4.0', 'Poland', 'reported to be a substitute for noble varieties.', '', '', 'Saaz, Mittelfrueh, Hersbrucker, Tettnang, Mount Hood, Liberty, Crystal', '', '0', '-1', '0', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('21', 'Mittelfrueh', '3.0', '5.0', 'Germany', 'pleasant, spicy, noble, mild herbal aroma', 'finishing for German style lagers', 'Sam Adams Boston Lager, Sam Adams Boston Lightship', 'Hersbrucker, Mt. Hood, Liberty, Crystal', '', '0', '0', '0', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('22', 'Mt. Hood', '3.5', '8.0', 'USA', 'mild, clean aroma', 'finishing for German style lagers', 'Anderson Valley High Rollers Wheat Beer', 'Mittelfrueh, Hersbrucker, Liberty, Tettnang', '', '0', '0', '0', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('25', 'Northern Brewer', '8.0', '8.0', 'England', 'fine, fragrant aroma;  dry, clean bittering hop', '', 'Old Peculier (bit), Anchor Liberty (bit), Anchor Steam (bit, flav, aroma)', 'Mittelfrueh', '', '0', '0', '-1', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('26', 'Nugget', '12.0', '14.0', 'USA', 'heavy, spicy, herbal aroma;  strong bittering hop', 'strong bittering, some aroma uses', 'Sierra Nevada Porter & Bigfoot Ale, Anderson Valley ESB', 'Chinook', '', '0', '-1', '-1', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('27', 'Olympic', '0.0', '0.0', 'USA', '', '', '', '', '', '0', '0', '0', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('28', 'Perle', '7.2', '7.2', 'Germany', 'pleasant aroma; slightly spicy, almost minty bittering hop', 'general purpose bittering for all lagers except pilsener', 'Sierra Nevada Summerfest', 'dkdlks;ldfksd', '', '0', '0', '-1', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('29', 'Pride of Ringwood', '9.0', '11.0', 'Australia', 'citric aroma; clean bittering hop', 'general purpose bittering', 'Foster Lager', '', '', '0', '0', '-1', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('30', 'Saaz', '3.0', '3.0', 'Czech Republic', 'delicate, mild, floral aroma', 'finishing for Bohemian style lagers', 'Pilsener Urquell', 'tettnang', '', '0', '0', '0', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('31', 'Spalt', '3.5', '3.5', 'Germany', 'mild, pleasant, slightly spicy', '', '', 'Saaz, Tettnang', '', '0', '-1', '-1', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('32', 'Strisselsplat', '3.0', '5.0', 'France', '', '', '', '', '', '0', '0', '0', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('33', 'Styrian Goldings', '3.6', '3.6', 'Slovenia', 'mild, soft, grassy, floral aroma', 'bittering/finishing/dry hopping for a wide variety of beers,  popular in Europe', 'Ind Coope\'s Burton Ale, Timothy Taylor\'s Landlord', 'Fuggles, Willamette', '', '-1', '0', '-1', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('34', 'Super Alpha', '12.0', '12.0', 'New Zealand', '', '', 'lksdfjlksjl', '', '', '0', '0', '0', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('35', 'Talisman', '0.0', '0.0', 'England', '', '', '', '', '', '0', '0', '0', '0', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('36', 'Tettnanger', '5.8', '5.8', 'Germany', 'fine, spicy aroma', 'finishing for German style beers', 'Gulpener Pilsener, Sam Adams Octoberfest, Anderson Valley ESB', 'Saaz, Spalt', '', '0', '0', '0', '-1', '0000-00-00 00:00:00');
INSERT INTO `hops` VALUES ('37', 'Willamette', '4.0', '7.0', 'USA', 'mild, spicy, grassy, floral aroma', 'finishing / dry hopping for American / British style ales', 'Sierra Nevada Porter, Ballard Bitter, Anderson Valley Boont Amber', 'Fuggles', '', '-1', '0', '0', '-1', '0000-00-00 00:00:00');
