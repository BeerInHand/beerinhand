DELIMITER //

DROP FUNCTION IF EXISTS ConvertVolume //

CREATE FUNCTION ConvertVolume(UnitsIn varchar(12), VolumeIn float, UnitsOut varchar(12)) RETURNS float DETERMINISTIC
BEGIN
	DECLARE Barrels float DEFAULT 117.347772;
	DECLARE Hectoliters float DEFAULT 100;
	DECLARE ImpGallons float DEFAULT 4.54609;
	DECLARE Gallons float DEFAULT 3.785412;
	DECLARE Liters float DEFAULT 1;
	DECLARE Quarts float DEFAULT 0.946353;
	DECLARE Pints float DEFAULT 0.4731765;
	DECLARE Cups float DEFAULT 0.2365883;
	DECLARE Ounces float DEFAULT 0.0295735;
	DECLARE ImpOunces float DEFAULT 0.0295735;
	DECLARE Tablespoons float DEFAULT 0.0147868;
	DECLARE Teaspoons float DEFAULT 0.0049289;	
	DECLARE VolumeOut float; 
	DECLARE cIn float;
	DECLARE cOut float;
	SET VolumeIn = IFNULL(VolumeIn,0);
	IF UnitsIn = UnitsOut OR VolumeIn = 0 THEN RETURN VolumeIn; END IF;
	IF UnitsIn = "Barrels" THEN SET cIn = Barrels;
	ELSEIF UnitsIn = "Hectoliters" THEN SET cIn = Hectoliters;
	ELSEIF UnitsIn = "Imp Gallons" THEN SET cIn = ImpGallons;
	ELSEIF UnitsIn = "Gallons" THEN SET cIn = Gallons;
	ELSEIF UnitsIn = "Liters" THEN SET cIn = Liters;
	ELSEIF UnitsIn = "Quarts" THEN SET cIn = Quarts;
	ELSEIF UnitsIn = "Pints" THEN SET cIn = Pints;
	ELSEIF UnitsIn = "Cups" THEN SET cIn = Cups;
	ELSEIF UnitsIn = "Ounces" THEN SET cIn = Ounces;
	ELSEIF UnitsIn = "Imp Ounces" THEN SET cIn = ImpOunces;
	ELSEIF UnitsIn = "Tablespoons" THEN SET cIn = Tablespoons;
	ELSEIF UnitsIn = "Teaspoons" THEN SET cIn = Teaspoons;
	END IF;	
	IF UnitsOut = "Barrels" THEN SET cOut = Barrels;
	ELSEIF UnitsOut = "Hectoliters" THEN SET cOut = Hectoliters;
	ELSEIF UnitsOut = "Imp Gallons" THEN SET cOut = ImpGallons;
	ELSEIF UnitsOut = "Gallons" THEN SET cOut = Gallons;
	ELSEIF UnitsOut = "Liters" THEN SET cOut = Liters;
	ELSEIF UnitsOut = "Quarts" THEN SET cOut = Quarts;
	ELSEIF UnitsOut = "Pints" THEN SET cOut = Pints;
	ELSEIF UnitsOut = "Cups" THEN SET cOut = Cups;
	ELSEIF UnitsOut = "Ounces" THEN SET cOut = Ounces;
	ELSEIF UnitsOut = "Imp Ounces" THEN SET cOut = ImpOunces;
	ELSEIF UnitsOut = "Tablespoons" THEN SET cOut = Tablespoons;
	ELSEIF UnitsOut = "Teaspoons" THEN SET cOut = Teaspoons;	
	END IF;
	RETURN VolumeIn * cIn / cOut;	
END //

DROP FUNCTION IF EXISTS ConvertWeight //

CREATE FUNCTION ConvertWeight (UnitsIn varchar(12), WeightIn float, UnitsOut varchar(12)) RETURNS float DETERMINISTIC
BEGIN
	DECLARE Kg float DEFAULT 1000;
	DECLARE Lbs float DEFAULT 453.59237;
	DECLARE Ounces float DEFAULT 28.3495231;
	DECLARE Grams float DEFAULT 1;
	DECLARE WeightOut float; 
	DECLARE cIn float;
	DECLARE cOut float;
	SET WeightIn = IFNULL(WeightIn,0);
	IF UnitsIn = UnitsOut OR WeightIn = 0 THEN RETURN WeightIn; END IF;
	IF UnitsIn = "Kg" THEN SET cIn = Kg;
	ELSEIF UnitsIn = "Lbs" THEN SET cIn = Lbs;
	ELSEIF UnitsIn = "Ounces" THEN SET cIn = Ounces;
	ELSEIF UnitsIn = "Grams" THEN SET cIn = Grams;
	END IF;	
	IF UnitsOut = "Kg" THEN SET cOut = Kg;
	ELSEIF UnitsOut = "Lbs" THEN SET cOut = Lbs;
	ELSEIF UnitsOut = "Ounces" THEN SET cOut = Ounces;
	ELSEIF UnitsOut = "Grams" THEN SET cOut = Grams;
	END IF;
	RETURN WeightIn * cIn / cOut;
END //

DROP FUNCTION IF EXISTS ConvertPressure //

CREATE FUNCTION ConvertPressure (UnitsIn varchar(12), PressureIn float, UnitsOut varchar(12)) RETURNS decimal(5,3) DETERMINISTIC
BEGIN
  DECLARE PressureOut float; 
  DECLARE cIn float;
  DECLARE cOut float;
  SET PressureIn = IFNULL(PressureIn,0);
  IF UnitsIn = UnitsOut THEN RETURN PressureIn; END IF;
  IF UnitsIn = "PSI" THEN
    RETURN Round(6.89475729316836 * PressureIn, 1);
  END IF;
  RETURN Round(PressureIn / 6.89475729316836, 1);
END //


DROP FUNCTION IF EXISTS ConvertTemp //

CREATE FUNCTION ConvertTemp (UnitsIn varchar(12), TempIn float, UnitsOut varchar(12)) RETURNS decimal(5,3) DETERMINISTIC
BEGIN
  DECLARE TempOut float; 
  DECLARE cIn float;
  DECLARE cOut float;
  SET TempIn = IFNULL(TempIn,0);
  IF UnitsIn = UnitsOut THEN RETURN TempIn; END IF;
  IF UnitsIn = "F" THEN
    RETURN (TempIn - 32) / 1.8;
  END IF;
  RETURN (TempIn * 1.8) + 32;
END //


DROP FUNCTION IF EXISTS ConvertGravity //

CREATE FUNCTION ConvertGravity (UnitsIn varchar(12), GravityIn decimal(5,3), UnitsOut varchar(12)) RETURNS decimal(5,3) DETERMINISTIC
BEGIN
  DECLARE GravityOut decimal(5,3);
  DECLARE cIn float;
  DECLARE cOut float;
  SET GravityIn = IF(UnitsIn = "SG", IFNULL(GravityIn,1.000), IFNULL(GravityIn,0));
  IF UnitsIn = UnitsOut THEN RETURN GravityIn; END IF;
  IF UnitsIn = "SG" THEN
    IF GravityIn = 0 THEN RETURN 0; END IF;
    RETURN Round(260 - 260 / GravityIn,1);
  END IF;
  RETURN (260 / (260 - GravityIn));
END //



DROP FUNCTION IF EXISTS CalculateABV //

CREATE FUNCTION CalculateABV (GravityUnitsIn varchar(8), OG decimal(5,3), FG decimal(5,3)) RETURNS decimal(3,1) DETERMINISTIC
BEGIN
  DECLARE OGinSG decimal(5,3);
  DECLARE FGinSG decimal(5,3);

  SET OGinSG = Round(ConvertGravity(GravityUnitsIn, OG, "SG"),3);
  IF FG = 0 THEN
    SET FGinSG = Round(1 + (OGinSG - 1) / 4,3);
  ELSE
    SET FGinSG = Round(ConvertGravity(GravityUnitsIn, FG, "SG"),3);
  END IF;
  RETURN Round((OGinSG - FGinSG) * 131,1);
END //