/* Adapted from Project/OutlierDetection.sas
   Original reads/writes stsm.forecasting_finalproject (a local SAS library
   pointed at the author's forecasting_finalproject.sas7bdat). Substituted
   here with a 24-row inline slice of the repo's own Project/Rainfall_data.csv
   (Dec 2004 - Nov 2006), matching the bounds the author derived from the
   full 21-year series (0.395 / 355.900). */

data work.forecasting_finalproject;
   informat Date mmddyy10.;
   format Date mmddyy10.;
   input Date SpecificHumidity RelativeHumidity Temperature Precipitation;
   datalines;
12/01/2004 9.34 54.44 18.29 0.01
01/01/2005 8.00 49.50 22.85 3.47
02/01/2005 8.54 46.69 26.70 0
03/01/2005 10.19 48.50 24.38 0.41
04/01/2005 11.96 48.50 23.25 13.56
05/01/2005 15.87 59.81 18.37 15.65
06/01/2005 19.17 76.12 12.55 799.32
07/01/2005 20.14 91.12 4.91 1095.38
08/01/2005 19.17 90.19 6.21 432.24
09/01/2005 19.47 92.06 9.00 776.41
10/01/2005 15.62 76.81 16.19 75.44
11/01/2005 11.54 66.81 17.23 0
12/01/2005 9.46 58.50 19.30 0
01/01/2006 8.24 49.38 23.38 0
02/01/2006 7.87 38.50 24.25 0
03/01/2006 10.38 48.25 23.80 9.61
04/01/2006 13.37 56.88 19.78 0.01
05/01/2006 16.66 63.94 16.48 187.67
06/01/2006 19.59 81.62 8.96 441.71
07/01/2006 19.41 91.12 4.73 1122.56
08/01/2006 18.86 91.56 5.13 1052.65
09/01/2006 19.29 90.44 8.38 389.08
10/01/2006 17.03 79.38 14.12 142.46
11/01/2006 14.34 74.56 13.64 24.05
;
run;

/* --- unmodified from OutlierDetection.sas below --- */
data work.forecasting_finalproject;
     set work.forecasting_finalproject;
   /* Assuming your_variable contains the data you want to analyze */

   /* Calculate lower and upper bounds for Precipitation based on quantiles */
   lower_bound_Precipitation = 0.395; /* 0% quantile */
   upper_bound_Precipitation = 355.900; /* 100% quantile */

   /* Flag outliers for Precipitation */
   if Precipitation < lower_bound_Precipitation or Precipitation > upper_bound_Precipitation then
      outlier_flag_Precipitation = 1;
   else
      outlier_flag_Precipitation = 0;
run;

proc print data=work.forecasting_finalproject;
   var Date Precipitation outlier_flag_Precipitation;
run;
