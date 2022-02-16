---
output: md_document
---


# Visualising COVID-19 (Project by DataCamp)

# [LINK TO PROJECT](https://projects.datacamp.com/projects/870)


# This R environment comes with many helpful analytics packages installed
# It is defined by the kaggle/rstats Docker image: https://github.com/kaggle/docker-rstats
# For example, here's a helpful package to load

library(tidyverse) # metapackage of all tidyverse packages

# Input data files are available in the read-only "../input/" directory
# For example, running this (by clicking run or pressing Shift+Enter) will list all files under the input directory

# list.files(path = "../input") # to read files in the interface

# You can write up to 5GB to the current directory (/kaggle/working/) that gets preserved as output when you create a version using "Save & Run All" 
# You can also write temporary files to /kaggle/temp/, but they won't be saved outside of the current session




confirmed_cases_worldwide <- read_csv("visualizing-covid-19-datasets/confirmed_cases_worldwide.csv")

# Analyzing confirmed cases worldwide
glimpse(confirmed_cases_worldwide)



# Drawing line plot of cumulative cases vs. date
ggplot(data = confirmed_cases_worldwide, mapping = aes(x = date, y = cum_cases)) + 
    geom_line() + 
    labs(y = "Cumulative confirmed cases", x = "Time", title = "Coronavirus cases")




# Reading confirmed_cases_china_vs_world.csv 
confirmed_cases_china_vs_world <- read_csv("visualizing-covid-19-datasets/confirmed_cases_china_vs_world.csv")

# Glimpse of data
glimpse(confirmed_cases_china_vs_world)


# A line plot of cumulative cases vs. date, grouped and colored by is_china
plt_cum_confirmed_cases_china_vs_world <- ggplot(confirmed_cases_china_vs_world) +
  geom_line(aes(date, cum_cases, color=is_china)) +
  ylab("Cumulative confirmed cases")

# Plotting
plt_cum_confirmed_cases_china_vs_world



who_events <- tribble(
  ~ date, ~ event,
  "2020-01-30", "Global health\nemergency declared",
  "2020-03-11", "Pandemic\ndeclared",
  "2020-02-13", "China reporting\nchange"
) %>%
  mutate(date = as.Date(date))

# Using who_events, adding vertical dashed lines with an xintercept at date, and text at date, labeled by event, and at 100000 on the y-axis
plt_cum_confirmed_cases_china_vs_world + geom_vline(aes(xintercept = date), data = who_events, linetype = "dashed") + geom_text(aes(x = date, label = event), data = who_events, y = 1e5)    



# Filtering for China, from Feb 15
china_after_feb15 <- confirmed_cases_china_vs_world %>% filter(is_china == "China", date >= "2020-02-15")

# Using china_after_feb15, drawing a line plot cum_cases vs. date and adding a smooth trend line using linear regression with no error bars
ggplot(data = china_after_feb15, mapping = aes(x = date, y = cum_cases)) + geom_line() + geom_smooth(method = "lm", se = FALSE) + ylab("Cumulative confirmed cases")




# Filtering confirmed_cases_china_vs_world for not China
not_china <- filter(confirmed_cases_china_vs_world, is_china == "Not China")

# Using not_china, drawing a line plot cum_cases vs. date, adding a smooth trend line using linear regression, no error bars
plt_not_china_trend_lin <- ggplot(data = not_china, aes(x = date, y = cum_cases)) + geom_line() + geom_smooth(method = "lm", se = FALSE) + ylab("Cumulative confirmed cases")

# Plotting
plt_not_china_trend_lin 



# Modifying the plot to use a logarithmic scale on the y-axis
plt_not_china_trend_lin + scale_y_log10()



# Reading confirmed cases by country
confirmed_cases_by_country <- read_csv("visualizing-covid-19-datasets/confirmed_cases_by_country.csv")
glimpse(confirmed_cases_by_country)

# Grouping by country, summarizing to calculate total cases for top 7 countries
top_countries_by_total_cases <- confirmed_cases_by_country %>%
  group_by(country) %>%
  summarize(total_cases = max(cum_cases)) %>%
  top_n(n = 7)

# Plotting
top_countries_by_total_cases



# Reading data for top 7 countries
confirmed_cases_top7_outside_china <- read_csv("visualizing-covid-19-datasets/confirmed_cases_top7_outside_china.csv")

# Glimpse
glimpse(confirmed_cases_top7_outside_china)

# Using confirmed_cases_top7_outside_china, drawing a line plot of cum_cases vs. date, grouped and colored by country
ggplot(data = confirmed_cases_top7_outside_china, aes(x = date, y = cum_cases)) + 
    geom_line(mapping = aes(x = date, y = cum_cases, color = country)) + 
    ylab("Cumulative confirmed cases") + xlab("Date")


