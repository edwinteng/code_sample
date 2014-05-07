Options helpbrowser=sas ;
%let path=C:\Users\edwin\Desktop\SCA_data;

libname sca 'C:\Users\edwin\Desktop\SCA_data';

/*hw1 problem1: when phline=0 then use # of cellphone*/

data smp2012_1;
set sca.smp2012;
keep sampid phline phlnkid numadt phcell phclkid AGE6BKT SEX RACE;
if phlnkid=. then phlnkid=0;
if phclkid=. then phclkid=0;
run;

data smp2012_2;
set smp2012_1;
phlnad=phline-phlnkid;
cellad=phcell-phclkid;
if phlnad=0 then phlnad=cellad;
run;

proc freq data=smp2012_2;
tables phlnad;
run;

proc freq data=smp2012_1;
tables numadt*phlnad;
run;

data smp2012_3(rename=(AGE6BKT=age));
set smp2012_2;
paii=phlnad;
w1i=1/phlnad;
w1i3=numadt;
w1i4=numadt/paii;
run;

proc freq data=smp2012_3;
tables w1i4*numadt*phlnad/list missing;
run;

PROC IMPORT OUT= sca.census DATAFILE= "C:\Users\yanhuier\Desktop\uspro.xls" 
            DBMS=xls REPLACE;
     SHEET="finalcensus"; 
     GETNAMES=YES;
RUN;

proc freq data=smp2012_3;
tables age6bkt*sex*race/missing list;
run;

proc format;
value race 1= "RWN"
		   2= "RBT"
		   3= "RWH"
		   4= "ROT"
		   5= "RAT";
value sex 1= "M"
			 2= "F";
value age 1 = "18-24"
			  2 = "25-34"
			  3 = "35-44"
			  4 = "45-54"
			  5 = "55-64"
			  6 = "65+";
run;

ods html file= "&path\sca_demographics.html";
proc freq data=smp2012_3;
tables race*sex*age/missing list;
run;
ods html close;

/*try to impute--conditional distribution*/
ods html file="&path\conditional distribution.html";
proc freq data=smp2012_3;
tables age/list;
where race=1 and sex=2;
run;

proc freq data=smp2012_3;
tables age/list;
where race=3 and sex=2;
run;

proc freq data=smp2012_3;
tables race/list;
where sex=1 and age=3;
run;

proc freq data=smp2012_3;
tables race/list;
where sex=2 and age=1;
run;

proc freq data=smp2012_3;
tables race/list;
where sex=2 and age=4;
run;

proc freq data=smp2012_3;
tables race/list;
where sex=1 and age=5;
run;

proc freq data=smp2012_3;
tables race/list;
where sex=1 and age=6;
run;

proc freq data=smp2012_3;
tables race/list;
where sex=2 and age=2;
run;

proc freq data=smp2012_3;
tables race/list;
where sex=2 and age=3;
run;

proc freq data=smp2012_3;
tables race/list;
where sex=2 and age=5;
run;

proc freq data=smp2012_3;
tables race/list;
where sex=2 and age=6;
run;
ods html close;

ods html file="&path\lost two.html";
proc freq data=smp2012_3;
tables age /list;
where sex=2;
run;
ods html close;
/*end of the conditional distribution*/

ods html file="&path/excel.html";
proc print data=smp2012_3;
format race race.
	   sex sex.
	   age age.;
run;
ods html close;
/*generate excel file and populate the numbers manually*/

/*get the final data*/

PROC IMPORT OUT= sca.finaldata DATAFILE= "&path\impute\final_data.xls" 
            DBMS=xls REPLACE;
     SHEET="final"; 
     GETNAMES=YES;
RUN;

/*double check on the distribution*/
data smp2012_4;
set sca.finaldata;
run;

ods html file="&path\sca_distribution after imputation.html";
proc freq data=smp2012_4;
table sex*age*race/list missing;
run;
ods html close;

/*begin to collapse*/
data smp2012_5;
set smp2012_4;
race2="       ";
age2="     ";
if race="RAT" then  race2= "RAT+ROT";
else if race="ROT" then race2= "RAT+ROT";
else if race="RWH" then race2= "RWH";
else if race="RWN" then race2="RWN";
else if race="RBT" then race2="RBT";
if age="18-24" then age2= "18-34";
else if age="25-34" then age2= "18-34";
else if age="35-44" then age2= "35-54";
else if age="45-54" then age2= "35-54";
else if age="55-64" then age2= "55-64";
else if age="65+" then age2= "65+";
run;

ods html file="&path\collapsed distribtuion.html";
title2 "sca";
proc freq data=smp2012_5;
tables sex*race2*age2/list missing;
weight w1i4;
run;
ods html close;