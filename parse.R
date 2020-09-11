#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(dplyr))

fixdate<-function(x) {
   if (stringr::str_length(x) == 7) x <- paste0(0, x)
   lubridate::mdy(x) %>% format("%Y%m%d")
}

d <- read.table("bart.txt", sep="\t", header=T)

# 20200911WF - update to extract_all. has headers. reanme them back to what we were using
# my @header = id,vdate,qw/3TrialCount 3Numpumps 4Numpumps 3Value 3Status 3PumpCollect.RT 4PumpAgain.RT 3PumpDur allRTs/;
names(d)[1:7] <- c("lunaid", "vdate", "trialnum", "auto", "pump", "value", "action")

d <- d %>%
   # remove empty action. one trial for 10826, 1, 11595
   filter(action != "", !is.na(lunaid)) 
   # 20200911WF - no longer need to fix date. extract all does this for us
   # fix date -- this takes surprisingly long
   #mutate(vdate=Vectorize(fixdate)(vdate))

# only take full runs
d.full <-
   d %>%
   # get tally of all runs
   group_by(lunaid, vdate) %>%
   summarise(n=n(), npop=length(which(action=="popped")))%>%
   # add back to data
   inner_join(d) %>%
   # remove incomplete or extra
   filter(n==20)

d.out <-
   d.full %>% filter(value>0) %>%
   group_by(lunaid, vdate, npop) %>%
   summarise(meanval=mean(value), sdval=sd(value),
             meansize=mean(auto+pump),
             meanauto=mean(auto),
             meanpump=mean(pump),
             totalval=sum(value))

write.csv(d.out, "bart_mean.csv", row.names=F)

# dont need to plot when running from Rscript
quit(save='no')
library(ggplot2)
ggplot(d.out) +
   aes(x=npop, y=totalval) +
   geom_point() +
   theme_bw() + ggtitle("number popped verse total value")
