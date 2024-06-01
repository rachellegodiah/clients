
FILENAME REFFILE '/home/rachelleflick0/senic HW5.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.senic;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.senic; RUN;


%web_open_table(WORK.IMPORT);
 
proc reg data=senic;
model LOS = infection/clb; 
run;
 
proc reg data=senic;
model LOS = facilities/clb; 
run; 
 
proc gplot data=senic;
plot LOS*facilities; 
run;
  
proc reg data=senic;
model LOS = XRAY/clb; 
run; 
 
proc reg data=senic;
model LOS = infection facilities xray/clb; 
run;  

proc sgscatter data=senic;
matrix infection facilities xray los;
run; 
proc reg data=senic;
model LOS = infection facilities xray school/clb; 
run;  
  
proc reg data=senic;
model LOS = school/clb;  
 
 proc gplot data=senic;
plot school*los; 
run;

run; 
 proc reg data=senic;
model LOS = age census culture infection nurses xray/clb; 
run; 
  
proc reg data=senic;
model los= age census culture infection nurses xray
/selection=backward slstay=0.05
details;
run;
quit; 
 
proc reg data=senic;
model los= age census culture infection nurses xray
/selection=forward slentry=0.05
details;
run;
quit;
  
proc reg data=senic;
model los= age census culture infection nurses xray
/selection=stepwise slstay=0.05 slentry=0.05
details;
run;
quit;