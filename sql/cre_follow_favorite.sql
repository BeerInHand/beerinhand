DROP TABLE IF EXISTS followuser;

CREATE TABLE followuser (
	fu_usid					INT(11) UNSIGNED NOT NULL,
	fu_usid2					INT(11) UNSIGNED NOT NULL,
	fu_dla					TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
	KEY fu_usid (fu_usid),
	KEY fu_usid2 (fu_usid2)
) ENGINE=MYISAM;


DROP TABLE IF EXISTS favoriterecipe;

CREATE TABLE favoriterecipe (
	fr_usid					INT(11) UNSIGNED NOT NULL,
	fr_reid					INT(11) UNSIGNED NOT NULL,
	fr_dla					TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
	KEY fr_usid (fr_usid),
	KEY fr_reid (fr_reid)
) ENGINE=MYISAM;


