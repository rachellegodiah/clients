/* Generated Code (IMPORT) */
/* Source File: realtime.csv */
/* Source Path: /home/rachelleflick0/my_content */
/* Code generated on: 4/5/23, 2:50 PM */

%web_drop_table(WORK.IMPORT1);


FILENAME REFFILE '/home/rachelleflick0/my_content/realtime.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT1; RUN;


%web_open_table(WORK.IMPORT1); 

data rt; 
set import1; 
run;  
 
*create new variable, lRNA (logRNA), from beginning RNA concentration;

data rt2; 
set rt;
lrna=log(rna)/log(10);
Proc print data=rt2; 
run;   
 
 
*Estimation of PCR Efficiency for Each Gene and Sample Combination- 
 Obtaining fixed effects equation for CT;

Proc mixed Data= rt2;
Model Ct=lrna /Cl Alpha=0.05;
Run;  

Proc Glm Data=rt2 Order=Data;
Model Ct = lrna;
Run; 
  
Proc mixed Data=rt2 Order=Data;
model Ct = lrna /CL solution Alpha=0.05;
Run; 
 
 
 
*Estimation of TargetRNA after obtaining fixed effects equation; 

data target; 
input ct; 
datalines; 
31.94 
32.16 
31.41 
30.759 
31.02 
32.44 
; 
run; 

data targetrna; 
set target; 
top =(ct-40.72844); 
bottom=(-4.203); 
targetrna= 10**(top/bottom);
run; 

proc print data=targetrna; 
run;
 
 
*Calculating average Ct values for CT fixed effects equation;

Data av; 
input sample $1-2 ct 4-8; 
datalines; 
c1 23.71 
c1 23.50 
c1 23.23 
c2 25.96 
c2 26.25
c2 26.10 
; 
run;
 
proc print data=av; 
run; 

ods excel file="/home/rachelleflick0/my_content/ctav.csv"; 

proc means data=av; 
var ct; 
class sample; 
output out=s mean=avg; 
run;  

ods excel close;
 
*Inputing RNA, log RNA;  

data rtav; 
input sample $1-2 ct 4-8; 
datalines; 
c1 23.48 
c2 26.10 
; 
run;
 
data rtav1; 
set rtav; 
if sample= 'c1' then rna='8300'; 
if sample='c2' then rna='1660'; 
lrna=log(rna)/log(10);
run; 
 
proc print data= rtav1; 
run; 
 
 
