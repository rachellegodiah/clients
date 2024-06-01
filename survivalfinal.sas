data heart; 
set'/home/rachelleflick0/my_content/whas500.sas7bdat'; 
run;  
 
*1.i; 
proc print data=heart; 

run; 

*1.ii;
proc univariate data = heart(where=(fstat=1));
var lenfol;
cdfplot lenfol;

run;
proc corr data = heart plots(maxpoints=none)=matrix(histogram);
var lenfol id age gender hr sysbp bmi chf miord year los;
run;

*1.iii & 1.iv;  
proc lifetest data=heart(where=(fstat=1)) plots=survival(atrisk);
time lenfol*fstat(0);
run;   
 
*1.v; 
 
proc univariate data = heart(where=(fstat=1));
var lenfol;
histogram lenfol / kernel;
run;  

*1.vi;  
proc lifetest data=heart(where=(fstat=1)) plots=hazard(bw=200);  
strata hr (100);
time lenfol*fstat(0);
run;  
 
*2.i; 

proc phreg data = heart plots(overlay)=(survival);
model lenfol*fstat(0) = id age gender hr sysbp bmi chf;
run;  
 
*2.ii; 
Proc phreg data=heart;  
model lenfol*fstat(0)=id age gender hr sysbp bmi chf/rl;  
baseline out=a survival=s;   
run;   
ODS GRAPHICS ON;  
proc gplot data=a;  
symbol1 interpol=stepLJ color=black line=1;   
plot s*lenfol;    
run;   
ods graphics off; 
 
 *2.iii; 
 PROC PHREG DATA=heart;  
 MODEL lenfol*fstat(0)=id age gender hr sysbp bmi chf;  
 baseline out=a 
 survival=s 
 logsurv=logs 
 covariates=pred 
 loglogs=lls;  
 run;
 
title 'Log-log Survival plot'; 
proc gplot data=a;  
symbol1 interpol=stepLJ color=red line=1;  
symbol2 interpol=join color=blue line=2;  
plot s*lenfol=gender; 
run;     
ods graphics off;
 
proc phreg data=heart; 
model lenfol*fstat(0)=id age gender gender*age hr sysbp bmi chf;  
run; 
 
 *2xi;  
 ODS GRAPHICS ON; 
 proc phreg data = heart;
class gender;
model lenfol*fstat(0) = ;
output out=residuals resmart=martingale;
run;

proc loess data = residuals plots=ResidualsBySmooth(smooth);
model martingale = age / smooth=0.2 0.4 0.6 0.8;
run;   
ods graphics off; 
 
*3.xii; 
proc sort DATA=heart; 
by gender; 
run; 
proc phreg data=heart; 
model lenfol*fstat(0)=id age gender hr sysbp bmi chf; 
by gender; 
baseline out=a survival=s2 loglogs=lls; 
run;/***-log-logsurvival***/ 
data sym; 
set a; 
nlls=-lls; 
run; 
 
ODS GRAPHICS ON; 
title'Adjusted Log-log Survival plot'; 
proc gplot data=sym; 
label nlls='Negative Log-Log survival' time='Time'; 
symbol1 interpol=stepLJ color=red line=1; 
symbol2 interpol=stepLJ color=blue line=2; 
plot nlls*lenfol=gender/haxis=0 to 1000 by 100 vaxis=-1 to 5 by 1; 
run; 
ods graphics off;
