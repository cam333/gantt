 library(openxlsx)
 library(ggplot2)
 library(dplyr)
 library(lubridate)
 library(scales)
 
# raw tasks downloaded to csv from Jira 
 # https://confluence.atlassian.com/jira064/exporting-search-results-to-microsoft-excel-720416693.html
raw <- read.xlsx("gantt_chart_data.xlsx", startRow = 4, detectDates = TRUE) 


processed_data <- raw %>% 
  data.frame(.) %>%  
  select(Project, Summary, Planned.Start, Planned.End, Assignee) %>%
  na.omit() %>%
# Converting excel DateTime serial number to R DateTime
  # https://stackoverflow.com/questions/19172632/converting-excel-datetime-serial-number-to-r-datetime
  mutate(start = ymd_hms(as.POSIXct(Planned.Start * (60*60*24), origin = "1899-12-30", tz = "GMT")),
         end = ymd_hms(as.POSIXct(Planned.End * (60*60*24), origin = "1899-12-30", tz = "GMT")),
         short_sum = substr(Summary, 0, 20)) %>%
  select(-c(Planned.Start, Planned.End, Summary)) %>%
  arrange(desc(start), short_sum) %>% 
  mutate(short_sum = factor(short_sum, levels = unique(short_sum)))


today_df <- data.frame(val = as.numeric(force_tz(ymd_hms("2017-02-23 16:33:15"), tzone = "America/New_York")), 
                       current_day = "Now")

#needed to highlight the days that are weeekends
weekends <- data.frame(date = seq(floor_date(min(processed_data$start),unit = "day"), 
                                  ceiling_date(max(processed_data$end),unit = "day"), 
                                  by = "hour")) %>%
  mutate(weekend = ifelse(wday(date) %in% c(1,7), "yes","no"),
         month = month(date),
         day = day(date)) %>%
  group_by(day, month, weekend) %>%
  summarize(start = min(date), end = max(date) + minutes(60))

# tasks by developer
ggplot(data = processed_data) +
  geom_segment(aes(y = short_sum, yend = short_sum, 
                   x = start, 
                   xend = end, 
                   color = Project),size=3) +
  geom_vline(data = today_df, aes(xintercept = val, linetype = current_day), color = "blue") +
  scale_linetype_manual(values = 'dashed') +
  geom_rect(data = weekends, aes(xmin = start, xmax = end, fill = weekend), ymin=-Inf,ymax= Inf) +
  scale_fill_manual(values = alpha(c("gray", 'blue'), c(0.0, .05)))  + 
  scale_x_datetime(date_labels = "%b %d", date_breaks = "1 day", minor_breaks = NULL ) +
  facet_wrap(~Assignee, ncol = 1, scales = "free_y") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Tasks By Developer", y = "Task Desc", x = "Date")

# tasks by Projects
ggplot(data = processed_data) +
  geom_segment(aes(y = short_sum, yend = short_sum, 
                   x = start, xend = end, 
                   color = Assignee),size=3) +
  geom_vline(data = today_df, aes(xintercept = val, linetype = current_day), color = "blue") +
  scale_linetype_manual(values = 2) +
  geom_rect(data = weekends, aes(xmin = start, xmax = end, fill = weekend), ymin=-Inf,ymax= Inf) +
  scale_fill_manual(values = alpha(c("gray", 'blue'), c(0.0, .05)))  + 
  scale_x_datetime(date_labels = "%b %d", date_breaks = "2 day", minor_breaks = NULL ) +
  facet_wrap(~Project, ncol = 1, scales = "free_y") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Tasks By Project", y = "Task Desc", x = "Date")


