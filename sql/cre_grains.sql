﻿DROP TABLE grains;

CREATE TABLE grains (
  gr_grid              INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  gr_type              VARCHAR(25) NOT NULL,
  gr_lvb              DECIMAL(4,1) DEFAULT '0.0',
  gr_sgc              DECIMAL(4,3) DEFAULT '0.000',
  gr_lintner            DOUBLE DEFAULT '0',
  gr_mash              TINYINT(1) DEFAULT '0',
  gr_cgdb              TINYINT(3) UNSIGNED DEFAULT '0',
  gr_mc                DECIMAL(4,3) DEFAULT '0.000',
  gr_fgdb              TINYINT(3) UNSIGNED DEFAULT '0',
  gr_fcdif              TINYINT(4) DEFAULT '0',
  gr_maltster            VARCHAR(25) DEFAULT '',
  gr_country            VARCHAR(15) DEFAULT NULL,
  gr_info              VARCHAR(1000) DEFAULT NULL,
  gr_url              VARCHAR(100) DEFAULT '',
  gr_dla              TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (gr_grid),
  UNIQUE KEY gr_type (gr_type, gr_maltster)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;


INSERT INTO `grains` VALUES ('1', 'Aromatic', '26.0', '1.036', '30', '-1', '78', '0.400', '3', '0', 'Dewolf Cosyns', 'Belgium', 'Used at rates of up to 10%, Aromatic malt will lend a distinct, almost exaggerated malt aroma and flavor to the finished Ales and Lagers. Aromatic malt also has a rich color and is high in diastatic power for aid in starch conversion. D/C Aromatic malt. As the name suggests, adds aromatics to a beer. At 25 Lovi, it is grouped in the upper end of the \"Munich Malts\" category. It shows conversion by itself, with a diastatic power of 29, as compared to D/C munich with a DP of 50 and Pils with a DP of 105. When', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('2', 'Barley, Flaked', '2.0', '1.030', '0', '-1', '65', '0.000', '0', '0', 'Briess', 'USA', 'Aids head retention. Protein rest recommended.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('3', 'Barley, Pearled', '2.0', '1.030', '0', '-1', '65', '0.000', '0', '0', 'Briess', 'USA', 'Aids head retention. Protein rest recommended.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('4', 'Barley, Raw', '2.0', '1.030', '0', '-1', '65', '0.000', '0', '0', 'Briess', 'USA', 'Aids head retention. Protein rest recommended.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('5', 'Barley, Roasted', '325.0', '1.023', '0', '-1', '50', '0.000', '0', '0', 'Briess', 'USA', 'Unmalted, Use 10 to 12% to impart a distinct, roasted flavor to Stouts. Other dark beers also benefit from smaller quantities (2 - 6%). Essential ingrediant in Stouts. Small amounts are OK in Porters, provided they dont overpower the chocolate/caramel notes. Rarely used in any Belgian ales or German Lagers.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('6', 'Biscuit Malt', '23.0', '1.035', '6', '-1', '76', '0.000', '0', '0', 'Dewolf Cosyns', 'Belgium', 'Biscuit is a unique malt thats lightly roasted, lending the subtle properties of black and chocolate malts. Used at the rate of 3 to 15 %, it is designed to improve the bread & biscuits, or toasted flavor and aroma characteristics to Lagers and Ales. Nice. I like this.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('7', 'Black Patent', '0.0', '1.023', '0', '-1', '50', '0.000', '0', '0', 'Briess', 'USA', 'The darkest of all malts, use sparingly to add deep color and roast-charcoal flavor. Use no more than 1 to 3%. Best used in trace amounts only, for color. Almost any contribution that Black Patent gives to beer can be obtained from using another malt with less harsh flavor imp€', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('8', 'Black Roast', '675.0', '1.023', '0', '-1', '50', '0.000', '0', '0', 'Munton\'s', 'England', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('9', 'Black Roast Barley', '600.0', '1.020', '12', '-1', '65', '0.000', '0', '0', 'Munton\'s ', 'England', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('10', 'Brown/Amber', '65.0', '1.032', '432', '-1', '69', '0.000', '0', '0', 'Munton\'s', 'England', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('11', 'CaraMunich', '72.0', '1.033', '8', '-1', '71', '0.000', '0', '0', 'Dewolf Cosyns', 'Belgium', 'Use CaraMunich for a deeper color in Ales and Lagers, and in small amounts in Lagers. 5 to 15% will also lend a fuller flavor, contribute to foam stability, add unfermentable, caramelized sugars and contribute a rich malt aroma. Excellent malt to use as a suplement to other caramel malts.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('12', 'Cara-pils', '2.0', '1.033', '0', '-1', '71', '0.000', '0', '0', 'Briess', 'USA', 'Added foam and head retention. Dextrins lend body, mouthfeel and palate fullness to beers, as well as foam stability. Carapils must be mashed with pale malt, due to its lack of enzymes. Use 5 to 20% for these properties without adding color or having to mash at higher temperatures. Some brewers dislike the almost cloying sweetness that high amounts (10%) of Dextrin malt contributes.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('13', 'Cara-pils', '9.0', '1.034', '9', '-1', '73', '0.000', '0', '0', 'Dewolf Cosyns', 'Belgium', 'Added foam and head retention. Dextrins lend body, mouthfeel and palate fullness to beers, as well as foam stability. Carapils must be mashed with pale malt, due to its lack of enzymes. Use 5 to 20% for these properties without adding color or having to mash at higher temperatures. Some brewers dislike the almost cloying sweetness that high amounts (10%) of Dextrin malt contributes.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('14', 'Carastan', '37.0', '1.035', '0', '-1', '76', '0.000', '0', '0', 'Crisp', 'England', 'use 5 to 20% English Crystal to add color and a full, toffee/sweet flavor to Bitters, Pale Ales and Porters.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('15', 'Caravienne', '22.0', '1.034', '8', '-1', '73', '0.000', '0', '0', 'Dewolf Cosyns', 'Belgium', 'As with normal Crystal malts CaraVienne is non-enzymatic. It does, however, impart a rich, caramel-sweet aroma to the wort and promotes a fuller flavored beer at rates of 5 to 20 % of grist total. D/C: CaraVienna, ~22 Lovi. Another excellent all purpose caramel malt. Can be used in high percentages (up to 15%) wothout leaving the beer too caramel/sweet. Good to use in conjunction with Munich malts and Pils malt for a Maerzen base. Also good for use in many Belgian style ales, in conjunction with other Belgian color malts.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('16', 'Chocolate', '375.0', '1.023', '0', '-1', '50', '0.000', '0', '0', 'Briess', 'USA', 'Being the least roasted of the black malts, Chocolate malt will add a dark color and pleasant roast flavor. Small quantities lend a nutty flavor and deep, ruby red color while higher amounts lend a black color and smooth, roasted flavor. Use 3 to 12%. Chocolate is an essential ingrediant in Porters, along with Caramel malts. Used in smaller quantities in Brown ales, old ales and some Barleywines.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('17', 'Chocolate', '500.0', '1.030', '0', '-1', '65', '0.000', '0', '0', 'Dewolf Cosyns', 'Belgium', 'Being the least roasted of the black malts, Chocolate malt will add a dark color and pleasant roast flavor. Small quantities lend a nutty flavor and deep, ruby red color while higher amounts lend a black color and smooth, roasted flavor. Use 3 to 12%. Chocolate is an essential ingrediant in Porters, along with Caramel malts. Used in smaller quantities in Brown ales, old ales and some Barleywines.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('18', 'Chocolate', '400.0', '1.034', '0', '-1', '73', '0.000', '0', '0', 'Munton\'s', 'England', 'Being the least roasted of the black malts, Chocolate malt will add a dark color and pleasant roast flavor. Small quantities lend a nutty flavor and deep, ruby red color while higher amounts lend a black color and smooth, roasted flavor. Use 3 to 12%. Chocolate is an essential ingrediant in Porters, along with Caramel malts. Used in smaller quantities in Brown ales, old ales and some Barleywines. British Chocolate malt is ideal for British Porters and Brown or Mild Ales and even Stouts. It\'s a little darker than domestic Chocolate malt yet it has a slightly smoother character in the roast flav', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('19', 'Corn, Flaked', '1.0', '1.039', '0', '-1', '84', '0.000', '0', '0', 'Generic', 'USA', 'Hardly used due to high prices (malt is cheaper).', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('20', 'Corn, Grits', '1.0', '1.037', '0', '-1', '80', '0.200', '0', '0', 'Generic', 'USA', 'Need to be cooked in a ceral mash.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('21', 'Crystal', '200.0', '1.035', '0', '-1', '76', '0.000', '0', '0', 'Munton\'s', 'England', 'this is a test, this is only a test had this been a real emergency, you would have been notified.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('22', 'Crystal 10', '10.0', '1.035', '0', '-1', '76', '0.000', '0', '0', 'Briess', 'USA', '5 to 20% will lend body and mouthfeel with a minimum of color, much like Carapils, but with a light crystal sweetness. Also sold as CaraPils from the Dewolf-Cosyns maltster.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('23', 'Crystal 120', '120.0', '1.033', '0', '-1', '71', '0.000', '0', '0', 'Briess', 'USA', '5 to 15% will lend a complex bitter/sweet caramel flavor and aroma to beers. Used in smaller quantities this malt will add color and slight sweetness to beers, while heavier concentrations are well suited to strong beers such as Barley Wines and Old Ales.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('24', 'Crystal 20', '20.0', '1.035', '0', '-1', '76', '0.000', '0', '0', 'Briess', 'USA', 'Light Crystal', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('25', 'Crystal 40', '40.0', '1.034', '0', '-1', '73', '0.000', '0', '0', 'Briess', 'USA', 'As with all Crystal malts, the character of this malt is contributed by unfermentable crystallized sugars produced by a special process Called \"stewing\". 5 to 20 % Pale Crystal will lend a balance of light caramel color, flavor, and body to Ales and Lagers. Caramel 40 is a mainstay malt in brewing of all types of ales. It can be used in British and American ales, and in conjunction with other malts in Belgian ales and German lagers. Hugh Baird Maltings in Witham , Essex, England make very fine high grade caramel malts. US domestic specialties are made from 6 row malt, whereas the European vesi', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('26', 'Crystal 60', '60.0', '1.034', '0', '-1', '73', '0.000', '0', '0', 'Briess', 'USA', 'This Crystal malt is well suited to all beer recipes calling for crystal malt and is a good choice if you\'re not sure which variety to use. 5 to 15% of 60 L Crystal malt will lend a well rounded caramel flavor, color and sweetness to your finest Ales.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('27', 'Crystal 80', '80.0', '1.034', '0', '-1', '73', '0.000', '0', '0', 'Briess', 'USA', 'Dark Crystal', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('28', 'Crystal Dark', '65.0', '1.037', '0', '-1', '80', '0.000', '0', '0', 'Weyermann', 'Germany', 'Use 3 to 20% of German Caramel malt to add color, sweetness and body to European lagers Viennas and Marzen/Oktoberfest lagers.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('29', 'Crystal Light', '3.0', '1.037', '20', '-1', '80', '0.000', '0', '0', 'Ireks', 'Germany', 'Added foam and head retention. Yes maam.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('30', 'Crystal Scottish', '90.0', '1.032', '0', '-1', '69', '0.000', '0', '0', 'Kilts', 'Scotland', 'Will lend a deep amber to red color and a full bodied, toasted/caramel like flavor to the finest Scottish and European ales.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('31', 'Dried Malt Extract', '0.0', '1.042', '0', '0', '91', '0.000', '0', '0', 'Generic', 'USA', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('32', 'Honey', '0.0', '1.033', '0', '-1', '71', '0.000', '0', '0', 'Generic', 'USA', 'ALmost 100% fermentable. Lightens body and flavor.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('33', 'Honeysuckle', '0.0', '0.000', '0', '0', '0', '0.000', '0', '0', 'Generic', 'USA', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('34', 'Lager, 2 Row', '1.0', '1.038', '75', '-1', '82', '0.000', '0', '0', 'Munton\'s', 'England', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('35', 'Liquid Malt Extract', '0.0', '1.037', '0', '0', '80', '0.000', '0', '0', 'Generic', 'USA', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('36', 'Maple Sap', '0.0', '1.009', '12', '0', '19', '0.000', '0', '0', 'Generic', 'USA', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('37', 'Maple Syrups', '0.0', '1.030', '32', '0', '65', '0.000', '0', '0', 'Generic', 'USA', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('38', 'Melanoidin', '40.0', '1.034', '0', '-1', '73', '0.000', '0', '0', 'Weyermann', 'Germany', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('39', 'Mild', '4.0', '1.037', '53', '-1', '80', '0.000', '0', '0', 'Crisp', 'England', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('40', 'Millet', '1.0', '1.037', '0', '-1', '80', '0.000', '0', '0', 'Generic', 'USA', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('41', 'Molasses', '0.0', '1.036', '0', '0', '78', '0.000', '0', '0', 'Generic', 'USA', 'Can contribute butterlike or winelike flavors if used in excess.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('42', 'Munich', '12.0', '1.034', '50', '-1', '73', '0.000', '0', '0', 'Briess', 'USA', 'Use Munich to add a deeper color and fuller malt profile. An excellent choice for Dark and amber lagers, blend Munich with German Pils or Klages at the rate of 10 to 60% of the total grist. Darker grades of Munich are available from contential maltsters. Essential ingrediant in German Bock beers.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('43', 'Munich', '8.0', '1.038', '50', '-1', '82', '0.000', '0', '0', 'Dewolf Cosyns', 'Belgium', 'Use Munich to add a deeper color and fuller malt profile. An excellent choice for Dark and amber lagers, blend Munich with German Pils or Klages at the rate of 10 to 60% of the total grist. Darker grades of Munich are available from contential maltsters. Essential ingrediant in German Bock beers.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('44', 'Munich', '10.0', '1.037', '72', '-1', '80', '0.000', '0', '0', 'Weyermann', 'Germany', '(Munchener) Use Munich to add a deeper color and fuller malt profile. An excellent choice for Dark and amber lagers, blend Munich with German Pils or Klages at the rate of 10 to 60% of the total grist. Darker grades of Munich are available from contential maltsters. Essential ingrediant in German Bock beers. A true Munich variety that has undergone higher kilning than the pale malt. German Munich still retains sufficient enzymes for 100% of the grist, or it can be used at the rate of 20 to 75 % of the total malt content in Lagers for its full, malty flavor and aroma.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('45', 'Munich Dark', '30.0', '1.038', '50', '-1', '82', '0.000', '0', '0', 'Ireks', 'Germany', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('46', 'Munich, 2 Row', '8.0', '1.037', '40', '-1', '80', '0.000', '0', '0', 'Crisp', 'England', 'Use Munich to add a deeper color and fuller malt profile. An excellent choice for Dark and amber lagers, blend Munich with German Pils or Klages at the rate of 10 to 60% of the total grist. Darker grades of Munich are available from contential maltsters. Essential ingrediant in German Bock beers.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('47', 'Oats, Flaked', '2.0', '1.033', '0', '-1', '71', '0.000', '0', '0', 'Generic', 'USA', 'Adds mouthfeel and head retention. Protein rest recommended.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('48', 'Oats, Raw', '2.0', '1.033', '0', '-1', '71', '0.000', '0', '0', 'Generic', 'USA', 'Adds mouthfeel and head retention. Protein rest recommended.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('49', 'Pale, 2 Row', '2.0', '1.037', '140', '-1', '80', '0.000', '0', '0', 'Briess', 'USA', 'Base Malt for all beers', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('50', 'Pale, 2 Row', '2.0', '1.038', '45', '-1', '82', '0.000', '0', '0', 'Crisp', 'England', 'Fully modified British malt, easily converted by a single temperature mash. Preferred by many brewers for full flavored ales. Pale Ale malt has undergone higher kilning than Klages and is lower in diastatic power so keep adjuncts to 15 % or less.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('51', 'Pale, 2 Row', '3.0', '1.037', '60', '-1', '80', '0.000', '0', '0', 'Dewolf Cosyns', 'Belgium', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('52', 'Pale, 2 Row', '3.0', '1.037', '140', '-1', '80', '0.000', '0', '0', 'Gambrinus', 'Canada', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('53', 'Pale, 6 Row', '2.0', '1.035', '150', '-1', '76', '0.000', '0', '0', 'Briess', 'USA', 'Base Malt for many beer', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('54', 'Pils, 2 Row', '3.0', '1.036', '60', '-1', '78', '0.000', '0', '0', 'Crisp', 'England', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('55', 'Pils, 2 Row', '2.0', '1.037', '105', '-1', '80', '0.000', '0', '0', 'Dewolf Cosyns', 'Belgium', 'This is an excellent base malt for many styles, including full flavored Lagers, Belgian Ales and European Wheat beers.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('56', 'Pils, 2 Row', '2.0', '1.038', '110', '-1', '82', '0.000', '0', '0', 'Weyermann', 'Germany', 'A quality German two row malt. Produces a smooth, grainy flavor. Use in your finest German Lagers and Alt Beers.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('57', 'Rice, Extract', '1.0', '1.036', '0', '0', '78', '0.000', '0', '0', 'Generic', 'USA', 'Lightens flavor.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('58', 'Rice, Flaked', '1.0', '1.038', '0', '-1', '82', '0.000', '0', '0', 'Generic', 'USA', 'Adds alcohol without affect taste. Tends to promote dry, crisp, and snappy flavors.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('59', 'Rice, Raw', '1.0', '1.036', '0', '-1', '78', '0.000', '0', '0', 'Generic', 'USA', 'Adds alcohol without affect taste.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('60', 'Rye, Flaked', '4.0', '1.038', '0', '-1', '82', '0.000', '0', '0', 'Generic', 'USA', 'Small contribution to robust flavor. Finished crisp, clean. Protein rest recommended.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('61', 'Rye, Malt', '5.0', '1.029', '75', '-1', '63', '0.000', '0', '0', 'Briess', 'USA', 'Malted Rye', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('62', 'Rye, Raw', '4.0', '1.036', '0', '-1', '78', '0.000', '0', '0', 'Generic', 'USA', 'Small contribution to robust flavor. Finished crisp, clean. Protein rest recommended.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('63', 'Smoked Malt', '12.0', '1.037', '0', '-1', '80', '0.000', '0', '0', 'Weyermann', 'Germany', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('64', 'Special \"B\"', '221.0', '1.030', '0', '-1', '65', '0.000', '0', '0', 'Dewolf Cosyns', 'Belgium', 'Specially Good.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('65', 'Sugar, Candy', '1.0', '1.036', '0', '0', '78', '0.000', '0', '0', 'Dewolf Cosyns', 'Belgium', 'Lightens flavor and body. Used in full-flavored ales to lighten or enhance character and drinkablity.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('66', 'Sugar, Cane', '1.0', '1.046', '0', '0', '99', '0.000', '0', '0', 'Generic', 'USA', 'Lightens flavor', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('67', 'Sugar, Corn', '1.0', '1.037', '0', '0', '80', '0.000', '0', '0', 'Generic', 'USA', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('68', 'Victory', '30.0', '1.034', '50', '-1', '73', '0.000', '0', '0', 'Briess', 'USA', 'A unique, lightly roasted malt that provides a warm \"biscuity \" character to Ales and Lagers. Use 5 to 15 % to add a fuller flavor and aroma to Ales, Porters and full flavored, dark Lagers where a bigger malt character is desired without crystal malt sweetness. D/C Biscuit malt fits in here also. Biscuity/toasted flavors and aromas result from the use of this malt.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('69', 'Vienna', '4.0', '1.035', '130', '-1', '76', '0.000', '0', '0', 'Briess', 'USA', 'Vienna malt is kiln dried at a higher temperature than pale malt yet still retains sufficient enzyme power for use as 60 to 100% of total mash grist. Vienna is a rich, aromatic malt that will lend a deep color and full flavor to your finest Vienna or Marzen beers.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('70', 'Vienna', '3.0', '1.037', '95', '-1', '80', '0.000', '0', '0', 'Weyermann', 'Germany', '(Weiner) Vienna malt is kiln dried at a higher temperature than pale malt yet still retains sufficient enzyme power for use as 60 to 100% of total mash grist. Vienna is a rich, aromatic malt that will lend a deep color and full flavor to your finest Vienna or Marzen beers. German Vienna is high in diastatic power, meaning you can use it as 100% of the total grist for a fuller, deeper malt flavor and aroma.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('71', 'Vienna, 2 Row', '4.0', '1.036', '50', '-1', '78', '0.000', '0', '0', 'Crisp', 'England', 'Vienna malt is kiln dried at a higher temperature than pale malt yet still retains sufficient enzyme power for use as 60 to 100% of total mash grist. Vienna is a rich, aromatic malt that will lend a deep color and full flavor to your finest Vienna or Marzen beers.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('72', 'Wheat, Bulgar', '2.0', '1.036', '0', '-1', '78', '0.000', '0', '0', 'Generic', 'USA', '', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('73', 'Wheat, Flaked', '2.0', '1.036', '0', '-1', '78', '0.000', '0', '0', 'Generic', 'USA', 'Foam promoting proteins. Protein rest recommended. Malted Wheat is preferred because proteins will be partially degraded.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('74', 'Wheat, Malted', '2.0', '1.038', '74', '-1', '82', '0.000', '0', '0', 'Dewolf Cosyns', 'Belgium', 'Small amounts (3-6 %) aid in head retention to any beer without altering final flavor. Use 5 to 70 % in the mash, 40 to 70 % being the norm for wheat beers, combined with a high enzyme malt such as Klages.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('75', 'Wheat, Malted', '2.0', '1.039', '95', '-1', '84', '0.000', '0', '0', 'Ireks', 'Germany', '(Weizen) Small amounts (3-6 %) aid in head retention to any beer without altering final flavor. Use 5 to 70 % in the mash, 40 to 70 % being the norm for wheat beers, combined with a high enzyme malt such as Klages. German Wheat malt is the perfect ingredient for Weiss, Weizen and Berliner Weiss beers. Blended in proportions of 20 to 70% with pale malts, weizen malt is the perfect companion for German wheat strains for a full flavored, classic wheat beer.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('76', 'Wheat, Malted', '3.0', '1.037', '70', '-1', '80', '0.000', '0', '0', 'Munton\'s', 'England', 'Small amounts (3-6 %) aid in head retention to any beer without altering final flavor. Use 5 to 70 % in the mash, 40 to 70 % being the norm for wheat beers, combined with a high enzyme malt such as Klages.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('77', 'Wheat, Midwest Malt', '2.0', '1.037', '155', '-1', '80', '0.000', '0', '0', 'Briess', 'USA', 'Small amounts (3-6 %) aid in head retention to any beer without altering final flavor. Use 5 to 70 % in the mash, 40 to 70 % being the norm for wheat beers, combined with a high enzyme malt such as Klages.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('78', 'Wheat, Pacific NW Malt', '4.0', '1.040', '160', '0', '86', '0.000', '0', '0', 'Briess', 'USA', 'Small amounts (3-6 %) aid in head retention to any beer without altering final flavor. Use 5 to 70 % in the mash, 40 to 70 % being the norm for wheat beers, combined with a high enzyme malt such as Klages.', '', '0000-00-00 00:00:00');
INSERT INTO `grains` VALUES ('79', 'Wheat, Raw', '2.0', '1.036', '0', '-1', '78', '0.000', '0', '0', 'Generic', 'USA', 'Foam promoting proteins. Protein rest recommended. used in Wit biers at 45% of grist and in Lambics at 30%. Contributes a permenant starch haze to the beer.', '', '0000-00-00 00:00:00');
