Proc report compute after grouped summarizations not easy;

github
https://tinyurl.com/yb3oym6q
https://github.com/rogerjdeangelis/utl-proc-report-compute-after-grouped-summarizations-not-easy

I produce an 'ods' output datasets instead of a static printout.

I was surprised how difficult this was

   Two 'proc report' solutions;

       a. Prep data for proc report best solution? reates a single total group.
       b. Single proc report

SAS Forum
https://communities.sas.com/t5/SAS-Programming/Proc-report/m-p/642879

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|                   _       _
  __ _     _ __  _ __ ___ _ __     __| | __ _| |_ __ _
 / _` |   | '_ \| '__/ _ \ '_ \   / _` |/ _` | __/ _` |
| (_| |_  | |_) | | |  __/ |_) | | (_| | (_| | || (_| |
 \__,_(_) | .__/|_|  \___| .__/   \__,_|\__,_|\__\__,_|
          |_|            |_|
;

 WANT_DATFIX total obs=6

  NAME     GENDER    COUNT

  A          F         1
  A          M         1
  J          F         4
  J          M         3
  Total      F         5
  Total      M         4

* easy to print with ordered name;

* note 'proc print' cannot produce 'ods' daatsets;
* it can reproduce the ops report;
* better not to have missing cells?.

proc print data=want_datfix;
by name;
id name;
run;quit;

*_
| |__     _ __   ___        _ __  _ __ ___ _ __
| '_ \   | '_ \ / _ \ _____| '_ \| '__/ _ \ '_ \
| |_) |  | | | | (_) |_____| |_) | | |  __/ |_) |
|_.__(_) |_| |_|\___/      | .__/|_|  \___| .__/
                           |_|            |_|
;

Up to 40 obs from WANT_RPT total obs=6

   NAME    GENDER    COUNT

   A         F         1
             M         1
   J         F         4
             M         3
   All       F         5
             M         4

 *_                   _
(_)_ __  _ __  _   _| |_ ___
| | '_ \| '_ \| | | | __/ __|
| | | | | |_) | |_| | |_\__ \
|_|_| |_| .__/ \__,_|\__|___/
        |_|                           _       _
  __ _     _ __  _ __ ___ _ __     __| | __ _| |_ __ _
 / _` |   | '_ \| '__/ _ \ '_ \   / _` |/ _` | __/ _` |
| (_| |_  | |_) | | |  __/ |_) | | (_| | (_| | || (_| |
 \__,_(_) | .__/|_|  \___| .__/   \__,_|\__,_|\__\__,_|
          |_|            |_|
;
;

* Output all obs
data havFix/view=havfix;
  set sashelp.class(keep=name sex where=(name in:('J','A')));
  name=substr(name,1,1);;
  output;
  name="Total";
  output;
run;quit;


VIEW.HAVFIX total obs=18

  NAME     SEX

  J         F
  Total     F
  A         F
  Total     F
  J         M
  Total     M
  J         M
  Total     M
  J         F
  Total     F



*_
| |__     _ __   ___        _ __  _ __ ___ _ __
| '_ \   | '_ \ / _ \ _____| '_ \| '__/ _ \ '_ \
| |_) |  | | | | (_) |_____| |_) | | |  __/ |_) |
|_.__(_) |_| |_|\___/      | .__/|_|  \___| .__/
                           |_|            |_|
;

data have/view=have;
  length name $1;
  set sashelp.class(keep=name sex where=(name in:('J','A')));
run;quit;


WORK.HAVE total obs=9

   NAME    SEX

    J       F
    A       F
    J       M
    J       M
    J       F
    J       F
    J       M
    J       F
    A       M

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __  ___
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
\__ \ (_) | | |_| | |_| | (_) | | | \__ \
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/
                                      _       _
  __ _     _ __  _ __ ___ _ __     __| | __ _| |_ __ _
 / _` |   | '_ \| '__/ _ \ '_ \   / _` |/ _` | __/ _` |
| (_| |_  | |_) | | |  __/ |_) | | (_| | (_| | || (_| |
 \__,_(_) | .__/|_|  \___| .__/   \__,_|\__,_|\__\__,_|
          |_|            |_|
;


%utl_odsrpt(setup);
proc report data=havFix nowd box formchar="|" noheader missing out=tst;
title "|Name|Gender|Count|";
columns name  namSav sex n;
define name/group noprint;
define sex/group;
define namSav/computed;
define n/ "Count";
compute namSav/ character length=5;
 if name ne "" then hold=name;
 namSav=hold;
endcomp;
run;quit;
%utl_odsrpt(outdsn=want_datfix);

 *_
| |__     _ __   ___        _ __  _ __ ___ _ __
| '_ \   | '_ \ / _ \ _____| '_ \| '__/ _ \ '_ \
| |_) |  | | | | (_) |_____| |_) | | |  __/ |_) |
|_.__(_) |_| |_|\___/      | .__/|_|  \___| .__/
                           |_|            |_|
;


%utl_odsrpt(setup);
proc report data=have noheader box formchar='|';
title "|Name|Gender|Count|";
format name $1.;
column  name sex  n m f;
define m     /  computed noprint;
define f     /  computed noprint;
define name  /  group  format=$1.;
define sex   /  group;
define n     /   'Total';
compute m;
  s = sum(s, (SEX eq "M")*n);
  m=s;
endcomp;
compute f;
  t = sum(t, (SEX eq "F")*n);
  f=t;
endcomp;
compute after;
  cat="M";
  sep="|";
  str_f=catx("|","All|F",f);
  str_m=catx("|","|M",m);
  line str_f $32.;
  line str_m $32.;
endcomp;
run;quit;
%utl_odsrpt(outdsn=want_rpt);


