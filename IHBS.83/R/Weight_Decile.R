getwd()
setwd("C:/Users/Dell/IHBS/IHBS.83/data")
# Load the necessary packages
library(dplyr)
library(stringr)

# Load the data
load("R83P3S01.rda")
load("R83P3S02.rda")
load("R83P3S03.rda")
load("R83P3S04.rda")
load("R83P3S05.rda")
load("R83P3S06.rda")
load("R83P3S07.rda")
load("R83P3S08.rda")
load("R83P3S09.rda")
load("R83P3S10.rda")
load("R83P3S11.rda")
load("R83P3S12.rda")
load("R83P1.rda")
load("HHWeights83.rda")

# Summarize expenditure categories
summarize_expenditure <- function(data, col, new_col_name) {
  data %>%
    group_by(ADDRESS) %>%
    summarize(!!new_col_name := sum(!!sym(col), na.rm = TRUE))
}

# Create summaries for each expenditure category
Foods_Tobaccos_EXP <- summarize_expenditure(R83P3S01, "COL7", "Foods_Tobaccos_EXP")
Beverages_EXP <- summarize_expenditure(R83P3S02, "COL7", "Beverages_EXP")
Clothing_EXP <- summarize_expenditure(R83P3S03, "COL4", "Clothing_EXP")
Housing_EXP <- summarize_expenditure(R83P3S04, "COL4", "Housing_EXP")
Furniture_Appliance_EXP <- summarize_expenditure(R83P3S05, "COL4", "Furniture_Appliance_EXP")
Health_EXP <- summarize_expenditure(R83P3S06, "COL4", "Health_EXP")
Transport_EXP <- summarize_expenditure(R83P3S07, "COL4", "Transport_EXP")
Communication_EXP <- summarize_expenditure(R83P3S08, "COL4", "Communication_EXP")
Recreation_EXP <- summarize_expenditure(R83P3S09, "COL4", "Recreation_EXP")
Education_EXP <- summarize_expenditure(R83P3S10, "COL4", "Education_EXP")
Restaurants_EXP <- summarize_expenditure(R83P3S11, "COL4", "Restaurants_EXP")
Other_EXP <- summarize_expenditure(R83P3S12, "COL4", "Other_EXP")

# Combine all expenditure summaries into one dataframe
total_expenditure <- list(Foods_Tobaccos_EXP, Beverages_EXP, Clothing_EXP, Housing_EXP,
                          Furniture_Appliance_EXP, Health_EXP, Transport_EXP, Communication_EXP,
                          Recreation_EXP, Education_EXP, Restaurants_EXP, Other_EXP) %>%
  Reduce(function(x, y) left_join(x, y, by = "ADDRESS"), .) %>%
  mutate(Total = rowSums(across(ends_with("_EXP")), na.rm = TRUE))

# Load household size data and calculate OECD size
household_size <- R83P1 %>%
  group_by(ADDRESS) %>%
  summarize(Size = max(COL01))

OECD_size <- R83P1 %>%
  group_by(ADDRESS) %>%
  summarize(OECD = sum(case_when(
    COL01 == 1 ~ 1,
    COL01 > 1 & as.integer(COL05) >= 14 ~ 0.7,
    TRUE ~ 0.5
  )))

# Remove leading zeros from the ADDRESS column in total_expenditure
total_expenditure <- total_expenditure %>%
  mutate(ADDRESS = str_remove_all(ADDRESS, "^0+"))

# Remove leading zeros from the HHID column in HHWeights83
HHWeights83 <- HHWeights83 %>%
  mutate(HHID = str_remove_all(as.character(HHID), "^0+"))

# Join the data frames based on the standardized ADDRESS and HHID
total_expenditure <- total_expenditure %>%
  left_join(HHWeights83, by = c("ADDRESS" = "HHID"))

# Arrange the data by the Total column
total_expenditure <- total_expenditure %>%
  arrange(Total)

# Calculate cumulative weight
total_expenditure <- total_expenditure %>%
  mutate(Cumulative_Weight = cumsum(Weight))

# Calculate total weight
total_weight <- max(total_expenditure$Cumulative_Weight, na.rm = TRUE)

# Calculate boundary values for weight deciles
boundary_values <- (1:9) * (total_weight / 10)

# Create an empty dataframe to store the final results
final_results <- data.frame()

# Initialize the starting index for processing rows
start_index <- 1

# Iterate through each boundary value and split the rows accordingly
for (i in seq_along(boundary_values)) {
  boundary <- boundary_values[i]

  while (start_index <= nrow(total_expenditure) && total_expenditure$Cumulative_Weight[start_index] < boundary) {
    total_expenditure$Weight_Decile[start_index] <- i
    start_index <- start_index + 1
  }

  if (start_index <= nrow(total_expenditure) && total_expenditure$Cumulative_Weight[start_index - 1] < boundary && total_expenditure$Cumulative_Weight[start_index] >= boundary) {
    boundary_row <- total_expenditure[start_index, ]
    previous_row <- total_expenditure[start_index - 1, ]

    diff <- boundary - previous_row$Cumulative_Weight

    row1 <- boundary_row
    row2 <- boundary_row

    row1$Weight <- diff
    row1$Cumulative_Weight <- previous_row$Cumulative_Weight + diff
    row2$Weight <- boundary_row$Weight - diff
    row2$Cumulative_Weight <- row1$Cumulative_Weight + row2$Weight

    row1$Weight_Decile <- i
    row2$Weight_Decile <- i + 1

    total_expenditure <- bind_rows(total_expenditure[1:(start_index - 1), ], row1, row2, total_expenditure[(start_index + 1):nrow(total_expenditure), ])

    # Update the cumulative weights for the rows after the split
    total_expenditure <- total_expenditure %>%
      mutate(Cumulative_Weight = cumsum(Weight))

    start_index <- start_index + 1
  }
}

total_expenditure$Weight_Decile[total_expenditure$Cumulative_Weight > boundary_values[9]] <- 10

final_output <- total_expenditure %>%
  select(ADDRESS, Total, Weight,Cumulative_Weight, Weight_Decile)








