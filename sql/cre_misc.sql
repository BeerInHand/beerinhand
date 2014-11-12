DROP TABLE misc;

CREATE TABLE misc (
  mi_miid              INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  mi_type              VARCHAR(25) NOT NULL,
  mi_use              VARCHAR(25) DEFAULT NULL,
  mi_utype              VARCHAR(1) DEFAULT 'V',
  mi_unit              VARCHAR(12) DEFAULT NULL,
  mi_phase              VARCHAR(8) DEFAULT NULL,
  mi_info              VARCHAR(1000) DEFAULT NULL,
  mi_dla              TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (mi_miid),
  UNIQUE KEY mi_type (mi_type, mi_utype)
) ENGINE=MYISAM;

INSERT INTO `misc` VALUES ('1', 'Alpha-amylase', 'Enzyme', 'W', 'Teaspoons', 'Ferment', 'Enzymatically converts starches to glucose at temperature less than 140F.  1 teaspoon (per 5 gallons) should influence conversion..', '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('2', 'Ascorbic Acid', 'Antioxidant', 'W', 'Grams', 'Ferment', 'Aka Vitamin C.  Gives something for oxygen in the beer to react with rather than the beer itself.  1/2 teaspoon (per 5 gallons) dissolved in boiled water will help prevent oxidation.', '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('3', 'Break Brite', 'Clarifier', 'V', 'Grams', 'Boil', 'Super Irish Moss', '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('4', 'Calcium Carbonate', 'Water Treatment', 'W', 'Grams', 'Setup', 'Food grade calcium carbonate (CaCO3), also known as chalk is used by grain brewers to adjust mash pH upward and also used to simulate the waters found where great stouts and porters are brewed.', '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('5', 'Calcium Chloride', 'Water Treatment', 'W', 'Grams', 'Setup', 'Food grade calcium chloride (CaCl) is used to add chloride content and/or lower mash pH without increasing sodium as would be the case if sodium chloride or gypsum was used.', '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('6', 'Citric Acid', 'Flavor', 'W', 'Grams', 'Ferment', 'Used in meads to add a desirable acid flavor.', '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('7', 'Gelatin', 'Clarifying Aid', 'W', 'Grams', 'Ferment', 'Attracts and settles out suspended yeast after fermentation. Used mainly in kegging where there is a longer distanct for the yeast to settle. Add 1 tablespoon in 1 pint water and gently heat (no boiling) to disolve and add with priming sugar.', '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('8', 'Gypsum', 'Water Treatment', 'W', 'Grams', 'Setup', 'Food grade gypsum (calcium sulfate - CaSO4), sometimes called \"Burton Salts\" is used by grain brewers to insure proper mash pH and improve extraction. Also used to simulate the highly gypseous water found in Burton-on-Trent, the birthplace of pale ales. Note that gypsum only lowers pH when mashed with grain.', '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('9', 'Iodophor', 'Sanitizer', 'V', 'Teaspoons', 'Setup', 'We recommend iodophor for sanitizing over all other sanitizers. When used in the recommended dilution (1/2 oz in 5 gallons) it is the safest and fastest sanitizer we know of, requiring only two minutes of contact time. Unlike chlorine, it does not need to be rinsed since it is odorless and tasteless and will not combine with beer to produce off-flavors (like chlorine). (However, we do recommend rinsing or air-drying bottles due to the relatively high ratio of surface area to volume as compared to a fermente', '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('10', 'Irish Moss', 'Clarifying Aid', 'W', 'Grams', 'Boil', 'Actually a blend of select seaweeds, Irish Moss is used during the boil as a \"kettle coagulant\" to help proteins precipitate, resulting in clearer, haze-free beer. Contrary to popular belief, Irish Moss should be rehydrated for 30 minutes before adding to the boil if added in the last 30 minutes. An easier alternative is to add it with the first bittering hops so that it is boiled at least 60 minutes, eliminating the need for rehydration. We recommend 1 tbs in a five gallon boil.', '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('11', 'Koji', 'Enzyme', 'W', 'Grams', 'Ferment', 'Enzymatically converts starches to glucose at temperatures between 100 and 120F.  1 teaspoon (per 5 gallons) should influence conversion.  Used to make sake.', '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('12', 'Oat Hulls', 'Filter Medium', 'W', 'Lbs', 'Mash', null, '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('13', 'Polycar', 'Clarifying Aid', 'W', 'Grams', 'Ferment', 'This used to be called Polyclar AT or VT and is used in the last few days of fermentation to cause the proteins responsible for chill haze to precipitate. It needs to be rehydrated by soaking in sterile water for 1 hour and then gently stirred into the beer. Use 1 gm per gallon of beer. Then let the beer settle for a few days before bottling/kegging, racking off the sediment.', '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('14', 'Silca Gel', 'Clarifying Aid', 'W', 'Grams', 'Ferment', 'Brewery grade silica gel is used in a similar manner to and for the same purpose as Polyclar, to remove haze causing proteins, but our tests show it works much better. Gently stir into the beer, then let the beer settle for a few days before bottling/kegging, racking off the  sediment. Use 2 to 4 gms per gallon of beer.', '0000-00-00 00:00:00');
INSERT INTO `misc` VALUES ('15', 'Yeast Nutrient Crystals', 'Fermentation Aid', 'W', 'Grams', 'Ferment', 'Food grade di-ammonium phosphate acts like \"yeast fertilizer\" and is great for yeast starters (use 1/2 tsp) and for meads and ciders where natural yeast nutrients may be deficient.', '0000-00-00 00:00:00');
