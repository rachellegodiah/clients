/* Generated Code (IMPORT) */
/* Source File: all clients.xlsx */
/* Source Path: /home/rachelleflick0/my_content */
/* Code generated on: 7/8/21, 2:10 PM */

%web_drop_table(WORK.clients);


FILENAME REFFILE '/home/rachelleflick0/my_content/all clients.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.clients;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.clients; RUN;


%web_open_table(WORK.clients);
 
proc contents data= clients;
run; 

*identifying clients with blank entries for columns 'i' and 'j' (PCP and medmanagement);
data clients2;
set clients (drop=M);
run;

data clients2;
set clients2; 
if  (PCP='.') and (med='.') then discharge= 'yes'; 
else do discharge= 'no'; 
end;  
run; 
  
proc freq data=clients2;
tables discharge;
run;

Proc sort data=clients2;
by discharge;
run; 

proc print data=clients2; 
by discharge;
ID client;
run;
 
*removing clients who need discharge;

data clients3;
set clients2;
if (discharge='yes') then delete; 
run; 
  
*identifying clients who need eye exam, A1C, or statin;

data clients3;
set clients3;
if (eye='.') then needeye='yes'; 
else do needeye='no'; 
end; 
run; 

data clients3;
set clients3;
if (A1C='.') then needA1C='yes';
else do needA1C='no';
end;
run;

data clients3;
set clients3;
if (hyperlipidemia='Yes') and (onstatin='no') then needstatin='yes';
else do needstatin='no';
end;
run;
 
proc freq data=clients3;
tables needstatin;
run; 

proc freq data=clients3;
tables needeye;
run;  

proc freq data=clients3;
tables needA1C;
run; 

proc freq data=clients3;
tables diabetes;
run; 

proc freq data=clients2;
tables diabetes;
run; 

proc freq data=clients3;
run;

proc print data=clients3;
ID Client;
run;
 





