proc univariate data=stsm.forecasting_finalproject;
  var Precipitation;
  output out=outliers pctlpre=p_ pctlpts=25 50 75;
run;
