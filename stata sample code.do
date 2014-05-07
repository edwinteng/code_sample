************Stata Sample Code**************
set more off
cap log close 
log using "C:\Users\Edwin\Desktop\cams01\analysis.log", replace
cd C:\Users\Edwin\Desktop\cams01

infile using CAMS01_R.dct
save C:\Users\Edwin\Desktop\cams01\CAMS01_R.dta

/*sleeping & napping*/
gen sleep_time = A5_01
summarize sleep_time, detail
histogram sleep_time, xtitle(hours/week) title(Hours Spend on Sleep and Napping)


/*Physical Activities= walking + participating in sports or other exercise activities*/
egen phyact_time = rsum(A6_01 A7_01)
summarize phyact_time, detail
histogram phyact_time, xtitle(hours/week) title(Hours Spend on Physical Activities)


/*Exercise*/
gen exe_time = A7_01
summarize exe_time
histogram exe_time, xtitile(hours/week) title(Hours Spend on Exercise)

/*Social engagement: A21-Help Others, A22-Volunteer work, A23-Religious attendance, A24-Attend meetings (original for LAST MONTH)*/
egen social_time_month = rsum(A21_01-A24_01)
gen social_time = social_time_month/4
summarize social_time, detail
histogram social_time, xtitile(hours/week) title(Hours Spend on Social Engagement)


/*treating or managing medical conditions: IN MUNITES*/
gen medical_time = (A26_01/4)*60 
summarize medical_time, detail
histogram medical_time, title(Hours Spend on Treating or Managing Medical Conditions)


/*working status*/
gen working = 1 if C2M1_01==1|C2M2_01==1|C2M3_01==1
gen retired = 1 if C2M1_01==5|C2M2_01==5|C2M3_01==5
gen homemaker = 1 if C2M1_01==6|C2M2_01==6|C2M3_01==6
gen others = 1 if working != 1 & retired != 1 & homemaker != 1 & C2M1_01 !=. | C2M2_01 !=.|C2M3_01 !=.

gen workstatus = .
replace workstatus = 1 if working == 1
replace workstatus = 2 if working != 1 & retired == 1
replace workstatus = 3 if working != 1 & retired != 1 & others != 1 & homemaker == 1
replace workstatus = 4 if working != 1 & retired != 1 & homemaker != 1 & others == 1 
tab workstatus

label define workstatus 1 "working" 2 "retired" 3 "homemaker" 4"others"

/*working vs. retired*/
gen workretired=.
replace workretired = 1 if workstatus == 1
replace workretired = 0 if workstatus == 2
tab workretired

/*Marital status*/
gen marital = .
replace marital = 1 if C1_01 == 1 | C1_01 == 2 
replace marital = 2 if C1_01 == 5
replace marital = 3 if C1_01 == 3 | C1_01 == 4 |C1_01 == 6 | C1_01 ==7

label variable marital "Marital Status"
label define maritalstatus 1 "married or living with a partner" 2 "widowed" 3 "separated, divorced, never married,and other"

tab marital


/*working vs. retired: time spend*/
ttest sleep_time, by(workretired)
ttest phyact_time, by(workretired)
ttest exe_time, by(workretired)
ttest social_time, by(workretired)
ttest medical_time, by(workretired)

/*in order to merge with RAND-HRS dataset, create hhidpn*/
gen hhidpn = (HHID + PN)
destring (hhidpn), replace

save C:\Users\Edwin\Desktop\cams01\CAMS01_R_formerge.dta

merge 1:m hhidpn using "C:\Users\Edwin\Desktop\randMstataSE\rndhrs_m.dta"
keep if _merge == 3

save C:\Users\Edwin\Desktop\cams01\CAMS01hrs.dta

/*2000HRS-W5*/

gen age = r5agey_b
gen edu_years = raedyrs

gen edu_degree = .
replace edu_degree = 1 if raedegrm <=2
replace edu_degree = 2 if raedegrm >=3 & raedegrm != .
tab edu_degree
label define edu_degree 1 "low-less than HS" 2 "high-more than HS"

gen female = .
replace female = 1 if ragender == 2
replace female = 0 if ragender == 1


gen healthstatus = .
replace healthstatus = 1 if r5shlt == 1
replace healthstatus = 2 if r5shlt == 2
replace healthstatus = 3 if r5shlt == 3
replace healthstatus = 4 if r5shlt == 4 |r5shlt==5

label define healthstatus 1 "excellent" 2 "very good" 3 "good" 4 "fair or poor"

/*sum of conditions ever had*/
gen condition = .
replace condition = 0 if r5conde == 0
replace condition = 1 if r5conde == 1
replace condition = 2 if r5conde == 2
replace condition = 3 if r5conde >=3 & r5conde != .

label define condition 0 "no" 1 "only one" 2 "two conditions" 3 "more than two"
tab condition


/*regression models*/
nbreg sleep_time age i.female i.edu_degree i.marital i.workstatus i.healthstatus i.condition [pweight = r5wtresp]
nbreg exe_time age i.female i.edu_degree i.marital i.workstatus i.healthstatus i.condition [pweight = r5wtresp]
nbreg social_time age i.female i.edu_degree i.marital i.workstatus i.healthstatus i.condition [pweight = r5wtresp]
nbreg medical_time age i.female i.edu_degree i.marital i.workstatus i.healthstatus i.condition [pweight = r5wtresp]


save  C:\Users\Edwin\Desktop\cams01\CAMS01hrs_v1.dta
