ALTER TABLE `bih`.`grains` ENGINE = InnoDB , CHANGE COLUMN `gr_mc` `gr_mc` DECIMAL(4,3) NULL DEFAULT '0.000'  AFTER `gr_url` , CHANGE COLUMN `gr_fgdb` `gr_fgdb` DECIMAL(3,1) UNSIGNED NULL DEFAULT '0.0'  AFTER `gr_mc` , CHANGE COLUMN `gr_cgdb` `gr_cgdb` DECIMAL(3,1) UNSIGNED NULL DEFAULT '0.0'  AFTER `gr_fgdb` , CHANGE COLUMN `gr_fcdif` `gr_fcdif` DECIMAL(3,1) NULL DEFAULT '0.0'  AFTER `gr_cgdb` , CHANGE COLUMN `gr_lintner` `gr_lintner` TINYINT UNSIGNED NULL DEFAULT '0'  ;

ALTER TABLE `bih`.`grains` CHANGE COLUMN `gr_country` `gr_country` VARCHAR(15) NULL DEFAULT ''  , CHANGE COLUMN `gr_info` `gr_info` VARCHAR(1000) NULL DEFAULT ''  ;

ALTER TABLE `bih`.`grains` CHANGE COLUMN `gr_lvb` `gr_lvb` DECIMAL(4,1) UNSIGNED NULL DEFAULT '0.0'  , CHANGE COLUMN `gr_sgc` `gr_sgc` DECIMAL(4,3) UNSIGNED NULL DEFAULT '0.000'  , CHANGE COLUMN `gr_mc` `gr_mc` DECIMAL(4,3) UNSIGNED NULL DEFAULT '0.000'  ;

update grains set gr_mash = 1 where gr_mash <> 0

ALTER TABLE `bih`.`grains` CHANGE COLUMN `gr_mash` `gr_mash` TINYINT(1) UNSIGNED NULL DEFAULT '0'  ;