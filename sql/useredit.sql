DROP TABLE IF EXISTS useredit;

CREATE TABLE useredit (
	ue_ueid					INT(11) NOT NULL AUTO_INCREMENT,
	ue_usid					INT(11) UNSIGNED NOT NULL,
	ue_pkid					INT(11) UNSIGNED NOT NULL,
	ue_table					VARCHAR(20) DEFAULT '',
	ue_data					text,
	ue_reason				VARCHAR(500) DEFAULT '',
	ue_dla					TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
	PRIMARY KEY (ue_ueid),
	KEY ue_usid (ue_usid),
	KEY ue_pkid (ue_pkid)
) ENGINE=MYISAM;
