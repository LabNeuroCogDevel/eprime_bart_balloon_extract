# Bart Task
extracting task events from eprime log file.
N.B. trials have 2 phases: (1) auto-inflate and then (2) manual inflate.

## 20180718 
using `extract.bash` to run a perl oneliner and parse with `parse.R` on all Bart data in `bea_res`

## 20200911 
extract more info with `extract_all.pl`. include nested RT column like `pump#=RT,pump#=RT,....`

`pump#` is size of ballon.  manual pumps might start at any level of influated (eg. pump# = 5, or pump# = 21)
