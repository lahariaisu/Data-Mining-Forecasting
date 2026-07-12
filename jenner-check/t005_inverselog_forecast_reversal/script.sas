/* Adapted from Project/InverseLog.sas
   Original reads work.OUT_ARIMAX_FORECAST, the FORECAST OUT= dataset that
   Project/"ARIMAX Modeling Program 2.sas" (see t004_arimax_modeling in this
   bundle set) produces when run against the author's full 21-year series.
   Substituted here with a small mock forecast dataset built from twelve of
   the repo's own Project/Rainfall_data.csv Precipitation values (their
   log_precipitation) paired with a nearby simulated FORECAST column, in the
   same shape PROC ARIMA's FORECAST OUT= produces. The reversal logic itself
   is unmodified. */

data work.OUT_ARIMAX_FORECAST;
   informat Date mmddyy10.;
   format Date mmddyy10.;
   input Date log_precipitation FORECAST;
   datalines;
01/01/2000 0.000000 0.150000
02/01/2000 0.104360 0.243924
03/01/2000 0.009950 0.158955
04/01/2000 0.019803 0.167822
05/01/2000 5.606317 5.195685
06/01/2000 5.751524 5.326372
07/01/2000 6.711071 6.189964
08/01/2000 5.895449 5.455904
09/01/2000 4.593604 4.284243
10/01/2000 4.165269 3.898742
11/01/2000 1.680828 1.662745
12/01/2000 2.505526 2.404973
;
run;

/* --- unmodified from InverseLog.sas below --- */
data work.OUTown;
    set work.OUT_ARIMAX_FORECAST;

    /* Replace 'LogForecast' with the name of your log-transformed variable */
    OriginalForecast = exp(FORECAST); /* Use EXP function to reverse log transformation */
    Original = exp(log_precipitation);
    RESIDUAL = Original - OriginalForecast;
    /* Keep other variables as-is */

run;

proc print data=work.OUTown;
run;
