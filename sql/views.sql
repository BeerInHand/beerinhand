drop view FavoriteLog;

CREATE VIEW FavoriteLog AS
SELECT re_reid, re_name, re_style, re_brewed, re_volume, re_vunits, re_expgrv, re_eunits, re_privacy, re_expsrm, re_expibu, re_eff,
           re_munits, re_hunits, us_user AS re_brewer, fr_usid, fr_dla
        FROM recipe
           INNER JOIN users ON us_usid = re_usid
           INNER JOIN favoriterecipe ON fr_reid = re_reid
       WHERE re_privacy < 2
;
