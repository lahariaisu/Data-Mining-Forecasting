/* Adapted from Project/METRIC_CALC_WINTER.sas
   Original reads work.outown, the RESIDUAL-bearing dataset that
   Project/InverseLog.sas produces (see t005_inverselog_forecast_reversal in
   this bundle set). Substituted here by inlining the same InverseLog
   reversal step so work.outown exists standalone, built from the same
   12-row mock forecast dataset used in t005. The RMSE/MAE/MAPE metric
   calculation itself is unmodified. */

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

data work.outown;
    set work.OUT_ARIMAX_FORECAST;
    OriginalForecast = exp(FORECAST);
    Original = exp(log_precipitation);
    RESIDUAL = Original - OriginalForecast;
run;

/* --- unmodified from METRIC_CALC_WINTER.sas below --- */
data WORK.Metric_new;
    set work.outown;

    /* Residual squared */
    sqe = RESIDUAL* RESIDUAL;

    /* Absolute error */
    ae = abs(RESIDUAL);

    /* Absolute Percentage Error */
    ape = abs((RESIDUAL / Original) * 100);
run;

proc means data=WORK.Metric_new noprint;
    var sqe ae ape;
    output out= metrics_data
           mean(sqe)=mse
           mean(ae)=mae
           mean(ape)=mape;
run;

data metrics;
    set metrics_data;
    rmse = sqrt(mse);
run;

proc print data=metrics;
    var rmse mae mape;
run;
