/* Generated Code (IMPORT) */
/* Source File: RUN_0147_STEP1_MAG.csv */
/* Source Path: /home/rachelleflick0/my_content */
/* Code generated on: 12/13/23, 1:09 PM */

%web_drop_table(WORK.IMPORT2);


FILENAME REFFILE '/home/rachelleflick0/my_content/RUN_0147_STEP1_MAG.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT2;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT2; RUN;


%web_open_table(WORK.IMPORT2); 

data inh3; 
set import2;  
run; 
 
data inh4; 
set inh3; 
if MEASURE_LABEL= 'Donut_Area' and expt_timepoint= '48H';
run;  

 
proc glm data=inh4; 
class group_detail; 
model measure_mag_value= group_detail;  
run;  

proc glm data=inh4; 
class group_detail expt_timepoint; 
model measure_mag_value= group_detail expt_timepoint /solution e; 
lsmeans group_detail / stderr tdiff e; 
lsmeans group_detail/ stderr tdiff e om;
run;