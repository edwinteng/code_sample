%let path=C:\Users\edwin\Desktop\SCA_data;

libname sca 'C:\Users\edwin\Desktop\SCA_data';

/*when phline=0 then use # of cellphone*/
/* keep subset of dataset */
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

/* check and summarize the variable phlnad*/
proc freq data=smp2012_2;
tables phlnad;
run;

/* see two-way table */
proc freq data=smp2012_1;
tables numadt*phlnad;
run;



/* label data*/
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
proc freq data=smp2012_2;
tables race*sex*age/missing list;
run;


