data stsm.forecasting_finalproject;
     set stsm.forecasting_finalproject;
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
