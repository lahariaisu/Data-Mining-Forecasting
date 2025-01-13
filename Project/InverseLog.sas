/* Assuming your dataset is named 'YourDataset' */
data work.OUTown;
    set work.OUT_ARIMAX_FORECAST;

    /* Replace 'LogForecast' with the name of your log-transformed variable */
    OriginalForecast = exp(FORECAST); /* Use EXP function to reverse log transformation */
    Original = exp(log_precipitation);
    RESIDUAL = Original - OriginalForecast;
    /* Keep other variables as-is */

run;

