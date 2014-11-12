update recipe, bjcpstyles
  set re_type = st_type
where re_style = st_substyle;

update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style = 'Barley Wine'
  and st_stid = 73


update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style = 'India Pale Ale'
  and st_stid = 49


update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style = 'Imperial Stout'
  and st_stid = 47


update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style = 'Düsseldorf-style Altbier'
  and st_stid = 24


update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style in ('CAP','Pre-pro')
  and st_stid =  8


update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style = 'White'
  and st_stid = 55


update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style in ('Pale', 'Honey Pale Ale')
  and st_stid = 33

update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style = 'Tripel'
  and st_stid = 68

update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style = 'Cider'
  and st_stid = 95

update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style = 'English Brown Ale'
  and st_stid = 37

update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style = 'Imperial India Pale Ale'
  and st_stid = 50


update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style in ('Classic English Pale Ale', 'English Extra Special')
  and st_stid = 27

update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style = 'Mead'
  and st_stid = 81

update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style in ('Dubbel', 'Abdij Beer')
  and st_stid = 67

update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_style = 'German-style Weizen'
  and st_stid = 51

update recipe, bjcpstyles
  set re_type = st_type, re_style = st_substyle
where re_name in ('Citra','Gbier','Green Flash','Medulla Slap') and re_style is null
  and st_stid = 49


insert into bjcpstyles (st_category, st_style, st_subcategory, st_substyle, st_og_min, st_og_max, st_fg_min, st_fg_max, st_ibu_min, st_ibu_max, st_srm_min, st_srm_max, st_abv_min, st_abv_max, st_aroma, st_appearance, st_flavor, st_mouthfeel, st_impression, st_ingredients, st_examples, st_history, st_comments, st_varieties, st_exceptions)
select st_category, st_style, st_subcategory, 'American Rye Beer',
              st_og_min, st_og_max, st_fg_min, st_fg_max, st_ibu_min, st_ibu_max, st_srm_min, st_srm_max, st_abv_min, st_abv_max,
              st_aroma, st_appearance, st_flavor, st_mouthfeel, st_impression, st_ingredients, st_examples, st_history, st_comments, st_varieties, st_exceptions)
from bjcpstyles
where st_stid = 21


delete FROM recipedates
where rd_date is null and rd_gravity=0 and rd_temp=0 and rd_note is null

update recipedates, recipe
set rd_date = AddDate(re_brewed, if(rd_type='Racked',7, 21))
where re_reid=rd_reid
and rd_date is null and re_brewed is not null






delete from recipeyeast where ry_yeast is null and ry_mfg is null


update recipeyeast, yeast
  set ry_yeast = ye_yeast, ry_mfg = ye_mfg, ry_mfgno = ye_mfgno
where ry_yeast like '%1056%'
  and ye_yeid = 2

update recipeyeast, yeast
  set ry_yeast = ye_yeast, ry_mfg = ye_mfg, ry_mfgno = ye_mfgno
where ry_yeast like 'American Ale%' and ry_mfg is null
  and ye_yeid = 2

update recipeyeast, yeast
  set ry_yeast = ye_yeast, ry_mfg = ye_mfg, ry_mfgno = ye_mfgno
where ry_yeast like 'German Ale%' and ry_mfg is null
  and ye_yeid = 78

update recipeyeast, yeast
  set ry_yeast = ye_yeast, ry_mfg = ye_mfg, ry_mfgno = ye_mfgno
where ry_yeast like '%Bavarian%' and ry_mfg is null
  and ye_yeid = 18
  
update recipeyeast, yeast
  set ry_yeast = ye_yeast, ry_mfg = ye_mfg, ry_mfgno = ye_mfgno
where ry_yeast like '%Baravian%' and ry_mfg is null
  and ye_yeid = 18
  
 update recipeyeast, yeast
   set ry_yeast = ye_yeast, ry_mfg = ye_mfg, ry_mfgno = ye_mfgno
 where ry_yeast like '%Bohemian%' and ry_mfg is null
  and ye_yeid = 40
  
update recipeyeast, yeast
  set ry_yeast = ye_yeast, ry_mfg = ye_mfg, ry_mfgno = ye_mfgno
where ry_yeast like '%1084%' and ry_mfg is null
  and ye_yeid = 89 
  
 
 update recipeyeast, yeast
   set ry_yeast = ye_yeast, ry_mfg = ye_mfg, ry_mfgno = ye_mfgno
 where ry_yeast like '%3944%' and ry_mfg is null
  and ye_yeid = 39

 update recipeyeast, yeast
   set ry_yeast = ye_yeast, ry_mfg = ye_mfg, ry_mfgno = ye_mfgno
 where (
 	ry_yeast like '%Northwest Ale%'
 	or
 	ry_yeast like '%Northwestern Ale%'
 	or
 	ry_yeast like '%Nw Ale%'
 	or
 	ry_yeast like '%Nw Esb%'
 )
 and ry_mfg is null
  and ye_yeid = 104

update recipeyeast, yeast
  set ry_yeast = ye_yeast, ry_mfg = ye_mfg, ry_mfgno = ye_mfgno
where ry_yeast like '%2278%' and ry_mfg is null
  and ye_yeid = 65

update recipeyeast, yeast
  set ry_yeast = ye_yeast, ry_mfg = ye_mfg, ry_mfgno = ye_mfgno
where (
	ry_yeast like '%1338%'
	or
	ry_yeast like '%European Ale%'
)
and ry_mfg is null
  and ye_yeid = 75
  