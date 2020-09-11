#!/usr/bin/env Rscript
library(dplyr)

fixdate<-function(x) {
   if (stringr::str_length(x) == 7) x <- paste0(0, x)
   lubridate::mdy(x) %>% format("%Y%m%d")
}

d <- read.table("bart.txt", sep="\t")
names(d) <- c("lunaid", "date", "auto", "pump", "value", "action")

d <- d %>%
   # remove empty action. one trial for 10826, 1, 11595
   filter(action != "") %>%
   # fix date -- this takes surprisingly long
   mutate(date=Vectorize(fixdate)(date))

# only take full runs
d.full <-
   d %>%
   # get tally of all runs
   group_by(lunaid, date) %>%
   summarise(n=n(), npop=length(which(action=="popped")))%>%
   # add back to data
   inner_join(d) %>%
   # remove incomplete or extra
   filter(n==20)

d.out <-
   d.full %>% filter(value>0) %>%
   group_by(lunaid, date, npop) %>%
   summarise(meanval=mean(value), sdval=sd(value),
             meansize=mean(auto+pump),
             meanauto=mean(auto),
             meanpump=mean(pump),
             totalval=sum(value))

write.csv(d.out, "bart_mean.csv", row.names=F)

library(ggplot2)
ggplot(d.out) +
   aes(x=npop, y=totalval) +
   geom_point() +
   theme_bw() + ggtitle("number popped verse total value")
