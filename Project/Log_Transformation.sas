data stsm.forecasting_finalproject;
   set stsm.forecasting_finalproject;

   /* Log transformation for Precipitation */
   log_Precipitation = log(Precipitation + 1);

run;

