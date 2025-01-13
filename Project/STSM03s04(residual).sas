/* STSM03s04a.sas */
ods graphics / tipmax=600;

proc arima data=STSM.FORECASTING_FINALPROJECT plots(only)=forecast(forecast forecastonly);
    identify var=log_Precipitation;
    estimate p=(1 2) (12) q=(1 2) (12) method=ML;
    forecast lead=12 back=12 id=DATE out=work.out interval=month;
    run;

    /* STSM03s04b.sas */
	identify var=log_Precipitation crosscorr=(RelativeHumidity Temperature SpecificHumidity);
	estimate p=(1 2) (12) q=(1 2) (12) input=(RelativeHumidity Temperature SpecificHumidity) method=ML;
    forecast lead=12 back=12 id=DATE out=work.out1 interval=month;
    run;
quit;

ods graphics / reset;

/* STSM03s04c.sas */


%let nhold=12;
%include "&programloc/Macros2.sas" / source2;
%accuracy_prep(indsn=STSM.FORECASTING_FINALPROJECT, series=log_Precipitation, timeid=Date, 
    numholdback=&nhold);

/* STSM03s04d.sas */
ods select none;

proc arima data=WORK._TEMP plots=none;
    identify var=_y_fit crosscorr=(RelativeHumidity Temperature SpecificHumidity);
    estimate p=(1 2) (12) q=(1 2) (12) method=ML;
    forecast lead=&nhold id=DATE interval=month out=work.out nooutall;
    run;
    estimate p=(1 2) (12) q=(1 2) (12) input=(RelativeHumidity Temperature SpecificHumidity) method=ML;
    forecast lead=&nhold id=DATE interval=month out=work.out1 nooutall;
    run;
quit;

ods select all;

/* STSM03s04e.sas */


%accuracy(indsn=work.out1, timeid=date, series=log_precipitation, 
    numholdback=&nhold);


/* STSM03s04f.sas */
proc arima data=STSM.FORECASTING_FINALPROJECT_F plots(only)=(forecast(forecast forecastonly));
    identify var=log_precipitation crosscorr=(RelativeHumidity Temperature SpecificHumidity);
    estimate p=(1 2) (12) q=(1 2) (12) input=(RelativeHumidity Temperature SpecificHumidity) method=ML;
    forecast lead=12 back=12 id=DATE interval=month nooutall;
quit;