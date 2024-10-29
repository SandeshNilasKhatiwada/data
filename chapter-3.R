library(tidycensus)
library(tidyverse)

# here we setup the api key to the env variable
census_api_key("b1e6dc0c0004c799ebb0b596f8f8234437279396", install = TRUE)

# here we used the api key from the env variable
readRenviron("~/.Renviron")

# I choosed the state texas
state_name <- "Texas"
acs_data <- get_acs(
  geography = "county",
  variables = "DP02_0068P",
  state = state_name,
  year = 2019,
  survey = "acs5",
  cache_table = TRUE
)

# County with the highest percentage
highest_county <- acs_data %>%
  filter(estimate == max(estimate))

# County with the lowest percentage
lowest_county <- acs_data %>%
  filter(estimate == min(estimate))

# Median value for the counties
median_value <- median(acs_data$estimate, na.rm = TRUE)



# Display results
highest_county
lowest_county
median_value
