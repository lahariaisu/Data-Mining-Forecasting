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
