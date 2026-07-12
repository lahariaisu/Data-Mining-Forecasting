/* Adapted from Project/ARIMAX Modeling Program 2.sas
   Original reads/writes STSM.FORECASTING_FINALPROJECT (a local SAS library
   pointed at the author's forecasting_finalproject.sas7bdat) and stores its
   ARIMA residuals to STSM.RESIDUALS_OUT. Substituted here with a 60-row
   inline slice of the repo's own Project/Rainfall_data.csv (Jan 2000 -
   Dec 2004, five full years so the seasonal lag=12 terms below have enough
   history) and a WORK library in place of STSM. The IDENTIFY/ESTIMATE/
   FORECAST statements -- the actual model the author fit -- are byte-for-byte
   unchanged from their script. */

data work.forecasting_finalproject;
   informat Date mmddyy10.;
   format Date mmddyy10.;
   input Date SpecificHumidity RelativeHumidity Temperature Precipitation;
   log_Precipitation = log(Precipitation + 1);
   datalines;
01/01/2000 8.06 48.25 23.93 0
02/01/2000 8.73 50.81 25.83 0.11
03/01/2000 8.48 42.88 26.68 0.01
04/01/2000 13.79 55.69 22.49 0.02
05/01/2000 17.4 70.88 19.07 271.14
06/01/2000 19.53 84.19 7.91 313.67
07/01/2000 18.8 88.5 6.67 820.45
08/01/2000 18.86 88.44 7.07 362.38
09/01/2000 18.43 86.12 10.63 97.85
10/01/2000 16.72 78.38 15.38 63.41
11/01/2000 12.02 63.69 17.48 4.37
12/01/2000 7.39 44.56 20.09 11.25
01/01/2001 8.06 45.81 22.94 0
02/01/2001 7.57 41.56 22.7 0
03/01/2001 11.29 55.56 20.97 0.03
04/01/2001 12.27 49.69 22.73 1.57
05/01/2001 16.6 62.44 16.03 29.11
06/01/2001 19.1 81.94 9.83 510.09
07/01/2001 19.23 89 5.98 622.31
08/01/2001 18.92 90.94 5.47 429.62
09/01/2001 18.68 87.69 10.91 155.88
10/01/2001 16.72 80.19 14.76 120.24
11/01/2001 12.51 66.56 18.25 6.15
12/01/2001 9.83 56.44 17.97 0
01/01/2002 8.18 51.06 23.58 0.03
02/01/2002 7.75 39.31 25.44 0.11
03/01/2002 9.77 43.44 23.32 0.47
04/01/2002 12.88 50.12 21.04 2.06
05/01/2002 16.85 60.44 19.38 8.63
06/01/2002 19.17 78.06 13.12 498.92
07/01/2002 18.92 85.12 6.26 126.77
08/01/2002 18.86 89.88 6.24 581.79
09/01/2002 17.88 85.75 12.04 87.71
10/01/2002 15.81 71.75 17.16 17.29
11/01/2002 11.17 57 18.57 2.59
12/01/2002 8.67 48.75 23.45 0.21
01/01/2003 8.48 43.25 25.19 0.03
02/01/2003 9.34 48.12 21.83 8.41
03/01/2003 9.09 42.19 23.27 0.11
04/01/2003 13.24 52.44 21.49 0.76
05/01/2003 15.69 58.44 20.51 0.01
06/01/2003 19.53 79.75 14.93 710.1
07/01/2003 20.2 89.81 5.22 584.85
08/01/2003 19.23 89.5 5.56 380.55
09/01/2003 18.68 88.94 7.65 233.14
10/01/2003 15.87 76 15.73 50.96
11/01/2003 13.43 69.81 16.23 1.1
12/01/2003 9.64 56.44 20.71 0.16
01/01/2004 8.67 51.94 22.16 0.37
02/01/2004 7.51 38.88 24.88 0.03
03/01/2004 8.73 37.19 23.07 0
04/01/2004 14.04 57.25 18.28 0.06
05/01/2004 16.91 62.81 21.23 92.28
06/01/2004 19.23 81.31 11.2 376.96
07/01/2004 19.35 87.25 6.24 663.26
08/01/2004 18.98 90.62 5.7 949.59
09/01/2004 18.86 87 10.34 225.06
10/01/2004 15.2 76.69 14.52 27.3
11/01/2004 13.06 66.5 16.66 4.29
12/01/2004 9.34 54.44 18.29 0.01
;
run;

/* --- from ARIMAX Modeling Program 2.sas below (STSM -> WORK). The IDENTIFY/
   ESTIMATE/FORECAST statements -- the actual ARIMAX model the author fit
   (crosscorr against three regressors, seasonal lag=12 terms) -- are
   byte-for-byte unchanged. ODS Graphics is off for the same rendering
   reason as t005; ESTIMATE's OUTSTAT= is dropped since it isn't shipping
   in this Jenner build yet, keeping OUTEST=/OUTMODEL= which are. */
ods noproctitle;
ods graphics off;

proc sort data=Work.forecasting_finalproject out=Work.preProcessedData;
	by Date;
run;

proc arima data=Work.preProcessedData out=Work.RESIDUALS_OUT;
	identify var=log_Precipitation(12 12) crosscorr=(SpecificHumidity(12 12)
		RelativeHumidity(12 12) Temperature(12 12) ) outcov=work.outcov;
	estimate p=(1 2) (12) q=(1 2) (12) input=(SpecificHumidity RelativeHumidity
		Temperature) method=ML outest=work.outest
		outmodel=work.outmodel;
	forecast lead=12 back=0 alpha=0.05 id=Date interval=month;
	outlier;
	run;
quit;

proc delete data=Work.preProcessedData;
run;
