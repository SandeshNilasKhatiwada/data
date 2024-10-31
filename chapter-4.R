library(tidycensus)
library(tidyverse)
library(scales)
library(stringr)
library(ggplot2)

census_api_key("b1e6dc0c0004c799ebb0b596f8f8234437279396", install = TRUE)

# here we used the api key from the env variable
readRenviron("~/.Renviron")

# getting the dataset of california
california <- get_estimates(
  geography = "state",
  state = "CA",
  product = "characteristics",
  breakdown = c("SEX", "AGEGROUP"),
  breakdown_labels = TRUE,
  year = 2019
)

# since the data is not cleaned changing the value such that 
# Sex will have onlu male and female 
# and value range form - to + if there are other than that then ignoring the value and created the new table 
california_filtered <- filter(california, str_detect(AGEGROUP, "^Age"), 
                        SEX != "Both sexes") %>%
  mutate(value = ifelse(SEX == "Male", -value, value))



max_val <- max(abs(california_filtered$value), na.rm = TRUE)  
california_pyramid <- ggplot(california_filtered, 
                             aes(x = value, 
                                 y = AGEGROUP, 
                                 fill = SEX)) + 
  geom_col(width = 0.95, alpha = 0.75) + 
  theme_minimal(base_family = "Verdana", 
                base_size = 12) + 
  scale_x_continuous(
    labels = scales::number_format(scale = .001, suffix = "k"),
    limits = max_val * c(-1, 1) 
  ) + 
  scale_y_discrete(labels = ~ stringr::str_remove_all(.x, "Age\\s|\\syears")) + 
  scale_fill_manual(values = c("darkred", "navy")) + 
  labs(x = "", 
       y = "2019 Census Bureau population estimate", 
       title = "Population structure in California", 
       fill = "", 
       caption = "Data source: US Census Bureau population estimates & tidycensus R package")

print(california_pyramid)

