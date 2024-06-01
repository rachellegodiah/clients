data automobile;
input seatbelt$ ejected$ Injury$ count;
datalines;
1 1 0 1105
1 1 1 14
1 0 0 411111
1 0 1 483
0 1 0 4624
0 1 1 497
0 0 0 157342
0 0 1 1008 
;
run; 
 
*7.10a;
proc genmod data= automobile;
class seatbelt (ref="0") ejected (ref="0") injury (ref="0")/ param=ref;
model count= seatbelt | ejected | injury @2/dist=poi link=log;
title "7.10a";
run;

*7.10b;

proc logistic data= automobile;
class seatbelt (ref="0") ejected (ref="0") injury (ref="0")/ param=ref;
model injury= seatbelt | ejected;
freq count;
title "7.10b";
run;

*7.10c;
proc genmod data= automobile;
class seatbelt (ref="0") ejected (ref="0") injury (ref="0")/ param=ref;
model count= seatbelt | ejected | injury @2/dist=poi link=log obstats;
title "7.10c";
run;
