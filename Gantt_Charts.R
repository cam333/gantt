 library(openxlsx)
 library(ggplot2)
 library(dplyr)
 library(lubridate)
 library(scales)
 
#raw tasks downloaded to csv from Jira 
raw <- read.xlsx("gantt_chart_data.xlsx", startRow = 4,detectDates = TRUE) 


processed_data <- raw %>% 
  data.frame(.) %>%  
  select(Project,Summary,Priority,Planned.Start,Planned.End,Assignee) %>%
  na.omit() %>%
#Converting excel DateTime serial number to R DateTime
  mutate(start = ymd_hms(as.POSIXct(Planned.Start * (60*60*24), origin="1899-12-30", tz="GMT")),
         end = ymd_hms(as.POSIXct(Planned.End * (60*60*24), origin="1899-12-30", tz="GMT")),
         short_summary = substr(Summary,0,50),
         Priority = as.factor(Priority)) %>%
  select(-c(Planned.Start, Planned.End)) %>%
  na.omit() %>%
  ungroup() %>%
  filter(end <= today() + weeks(6)) %>% 
  arrange(desc(start), short_summary) %>% 
  mutate(short_summary = factor(short_summary, levels = unique(short_summary)))


today_df <- data.frame(val = as.numeric(force_tz(ymd_hms("2017-02-23 16:33:15"),tzone = "America/New_York")), 
                       Current_Day = paste0(force_tz(ymd("2017-02-23"),tzone = "America/New_York")))

#needed to highlight the days that are weeekends
weekends <- data.frame(date = seq(floor_date(min(processed_data$start),unit = "day"), 
                                  ceiling_date(max(processed_data$end),unit = "day"), by = "hour")) %>%
  mutate(weekend = ifelse(wday(date) %in% c(1,7), "yes","no"),
         month = month(date),
         day = day(date)) %>%
  group_by(day,month, weekend) %>%
  summarize(start = min(date), end = max(date) + minutes(60))


# tasks by developer
ggplot(data = processed_data) +
  geom_segment(aes(y = short_summary, yend = short_summary, 
                   x = start, xend = end, color = Project),size=3) +
  geom_vline(data = today_df, aes(xintercept = val, linetype = Current_Day), color = "blue") +
  geom_rect(data = weekends, aes(NULL, NULL, xmin = start, xmax = end, fill = weekend), ymin=-Inf,ymax= Inf) +
  scale_fill_manual(values = alpha(c("gray", 'blue'), c(0.0, .05)))  + 
  scale_x_datetime(date_labels = "%b %d", date_breaks = "1 day", minor_breaks = NULL ) +
  facet_wrap(~Assignee, ncol = 1, scales = "free_y") +
  theme_bw() +
  scale_linetype_manual(values = c(2)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Tasks By Developer", y = "Task Desc", x = "Date")

# tasks by Projects
ggplot(data = processed_data) +
  geom_segment(aes(y = short_summary, 
                   yend = short_summary, 
                   x = start, xend = end, 
                   color = Assignee),size=3) +
  geom_vline(data = today_df, aes(xintercept = val, linetype = Current_Day), color = 'blue') +
  geom_rect(data = weekends, aes(NULL, NULL,xmin = start, xmax = end, fill = weekend),
            ymin=-Inf,ymax= Inf) +
  scale_fill_manual(values = alpha(c("gray", 'blue'), c(0.0, .05)))  + 
  scale_x_datetime(date_labels = "%b %d", date_breaks = "2 day", minor_breaks = NULL ) +
  facet_wrap(~Project, ncol = 1, scales = "free_y") +
  theme_bw() +
  scale_linetype_manual(values = c(2)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Tasks By Project", y = "Task Desc", x = "Date")


