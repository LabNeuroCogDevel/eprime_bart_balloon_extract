# Bart Task
extracting task events from eprime log file.
N.B. trials have 2 phases: (1) auto-inflate and then (2) manual inflate.

## 20180718 
using `extract.bash` to run a perl oneliner and parse with `parse.R` on all Bart data in `bea_res`

## 20200911 
would like to use `eptxt` from lncdtools. but 2 part trial makes this cumbersome.
instead perl oneliner is expanded to extract more info as `extract_all.pl`. It now includes a nested RT column w/vals like `pump#=RT,pump#=RT,....`

`pump#` is size of ballon.  manual pumps might start at any level of influated (eg. pump# = 5, or pump# = 21)
