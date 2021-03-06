library(rvest)
library(readr)

male_100_html <- read_html("http://www.alltime-athletics.com/m_100ok.htm")


male_100_pres <- male_100_html %>%
  html_nodes(xpath = "//pre")
head(male_100_pres)

male_100_htext <- male_100_pres %>%
  html_text()

male_100_htext <- male_100_htext[[1]]

male_100 <- read_fwf(male_100_htext, skip = 0, n_max = 3204,
                            col_types = cols(.default = col_character()),
                            col_positions = fwf_positions(
                              c(1, 16, 27, 35, 66, 74, 86, 93, 123),
                              c(15, 26, 34, 65, 73, 85, 92, 122, 132)
                            ))
head(male_100)
tail(male_100)

library(dplyr)
male_100 <- male_100 %>%
  select(X2, X4)
colnames(male_100) <- c("timing", "runner")
head(male_100)

male_100 <- male_100 %>%
  mutate(timing = gsub("A", "", timing),
         timing = as.numeric(timing))
male_100

n_distinct(male_100$runner)

runner_cnt <- male_100 %>%
  group_by(runner) %>%
  summarise(n_rec = n()) %>%
  arrange(desc(n_rec))
runner_cnt

library(ggplot2)
ggplot(runner_cnt, aes(n_rec)) +
  geom_histogram(binwidth = 5, fill = "lightblue", colour = "black") +
  xlab(NULL) +
  ylab(NULL) +
  ggtitle("Distribution of number of records by runner") +
  theme_bw() +
  theme(
    panel.border = element_blank(),
    plot.title = element_text(hjust = 0.5, vjust = 0.5)
  )

male_100_2 <- male_100 %>%
  inner_join(
    select(filter(runner_cnt, n_rec >= 50), runner),
    by = c("runner" = "runner")
  )
male_100_2

ggplot(male_100_2, aes(timing)) +
  geom_density() +
  facet_wrap(~runner, nrow = 4, ncol = 4) +
  xlab(NULL) +
  ylab(NULL) +
  ggtitle("Distribution of race timings by runner") +
  theme_bw() +
  theme(
    panel.border = element_blank(),
    plot.title = element_text(hjust = 0.5, vjust = 0.5)
  )

male_100_means <- male_100_2 %>%
  group_by(runner) %>%
  summarise(mean_timing = mean(timing)) %>%
  arrange(mean_timing)
male_100_means

male_100_medians <- male_100_2 %>%
  group_by(runner) %>%
  summarise(median_timing = median(timing)) %>%
  arrange(median_timing)
male_100_medians

male_100_3 <- male_100_2 %>%
  filter(runner %in% c("Usain Bolt", "Asafa Powell", "Yohan Blake",
                       "Justin Gatlin", "Maurice Greene", "Tyson Gay"))
male_100_3
