library(data.table)
library(purrr)
library(stargazer)
library(vioplot)
library(corrplot)
library(MASS)
library(car)
library(nortest)
                                        #Working with data!
##We have a file with 2012 presidential election results in Russia
elec_file <- "47130-8314.csv"

##Load this file into R (data.table)
##The file is UTF-8 encoded and contains cyrillic, expect problems on Windows
##Fread accepts "encoding" paramenter
all_data <- fread(elec_file, encoding = "UTF-8")

##Select columns "kom1", "kom2", "kom3", "1", "9", "10", "19", "20", "21", "22", "23" from the data
##Rename them to "region", "tik", "uik", "total", "invalid", "valid", "Zh", "Zu", "Mi", "Pr", "Pu"
dt_1 <- all_data[,c("kom1", "kom2", "kom3", "1", "9", "10", "19", "20", "21", "22", "23")]
colnames(dt_1) <- c("region", "tik", "uik", "total", "invalid", "valid", "Zh", "Zu", "Mi", "Pr", "Pu")

##Add a variable called turnout (valid + invalid) (total number of voters)
##Add a variable called turnout_p (turnout / total * 100) (voter turnout percentage)

dt_1$turnout <- dt_1$valid + dt_1$invalid
dt_1[,turnout := valid + invalid]

dt_1$turnout_p <- (dt_1$turnout/dt_1$total) * 100
dt_1[,turnout_p := (turnout / total) * 100]

##Remove Baikonur and voters outside Russia from the data
##"Территория за пределами РФ"
##"Город Байконур (Республика Казахстан)"

dt_1_c <- dt_1[
   !grepl("Территория за пределами РФ", region, fixed = TRUE)
  ][
   !grepl("Город Байконур (Республика Казахстан)", region, fixed = TRUE)
  ]

##Remove rows with missing data
dt_1_c_nona <- na.omit(dt_1_c)

##Display descriptives of the data
summary(dt_1_c_nona)

##Aggregate columns turnout, total, invalid, valid, Zh, Zu, Mi, Pr, Pu by region
##(by summing them)
dt_2 <- dt_1_c_nona[, .(
  turnout = sum(turnout),
  total = sum(total),
  invalid = sum(invalid),
  valid = sum(valid),
  Zh = sum(Zh),
  Zu = sum(Zu),
  Mi = sum(Mi),
  Pr = sum(Pr),
  Pu  = sum(Pu)
), by = region]

##Recompute turnout percentage for each region
dt_2[,turnout_p := (turnout / total) * 100]

##Create a factor variable with the region type
##“область”, “республика”, “край”, “округ”, “город”
##"oblast", "respublika", "krai", "okrug", "gorod"
##HINT: Use grepl and data.table subsetting

dt_2[grepl("область", tolower(region), fixed = TRUE), RegType := 1]
dt_2[grepl("республика", tolower(region), fixed = TRUE), RegType := 2]
dt_2[grepl("край", tolower(region), fixed = TRUE), RegType := 3]
dt_2[grepl("округ", tolower(region), fixed = TRUE), RegType := 4]
dt_2[grepl("город", tolower(region), fixed = TRUE), RegType := 5]
#We use tolower here so that the case of the words does not matter

dt_2[,RegType := factor(RegType)]
levels(dt_2$RegType) <- c("oblast", "respublika", "krai", "okrug", "gorod")
#Convert into factor, then assign readable names for levels

##Display a (fancy) barplot with the number of regions of different types
#We use ylim here to force the height of the y axis, so the percentage for the
#highest bar does not get cut off
reg_percent_table <- table(dt_2$RegType) * 100 / sum(table(dt_2$RegType))
reg_percent_table %>%
  barplot(main = "Russia regions by type",
          col = "indianred",
          ylab = "% Regions",
          xlab = "Type",
          ylim = c(0,60)) %>%
  text(x = ., y = reg_percent_table + 1, labels = paste(round(reg_percent_table, 2), "%"))

##Display a pie chart with the same information

#I use https://colorbrewer2.org/ for palettes
color_palette_reg_types <- c('#e41a1c','#377eb8','#4daf4a','#984ea3','#ff7f00')

#Make a vector of labels with percentages (\n is the newline symbol)
reg_types_labels <- paste(names(reg_percent_table), "\n",
                          round(reg_percent_table, 2), "%", sep="")

pie(reg_percent_table,
    main = "Observations by month",
    col=color_palette_reg_types,
    labels = reg_types_labels)

##Display a (fancy) histogram of turnout percentage
hist(dt_2$turnout_p,
     col = "darkorchid1",
     main = "% Turnout",
     xlab = "% Turnout",
     ylab = "Probability",
     breaks=15,
     freq = F)

##Compute vote percentage for each of the candidates (number_of_voted / valid)
dt_2[, Zh_p := Zh / valid * 100]
dt_2[, Zu_p := Zu / valid * 100]
dt_2[, Mi_p := Mi / valid * 100]
dt_2[, Pr_p := Pr / valid * 100]
dt_2[, Pu_p := Pu / valid * 100]

##Use stargazer to make a summary table that we can use in Word (for the
##seminar, we will use the text format)
dt_2 %>% stargazer(type = "text")

#Or we can select the columns we need
dt_2[, c("Zh_p","Zu_p","Mi_p","Pr_p","Pu_p", "turnout_p")] %>%
  stargazer(covariate.labels = c("% Zhirinovsky",
                                                "% Zuganov",
                                                "% Mironov",
                                                "% Prokhorov",
                                                "% Putin",
                                                "% Turnout"),
            title="Summary statistics for 2012 presidential elections",
            type = "html", out="election_table.html")

##Display a boxplot of percentage vote for Zuganov
boxplot(dt_2$Zu_p, col = "cadetblue")

##Display a violin plot of percentage vote for Mironov
vioplot(dt_2$Mi_p, col = "cadetblue")

##Display a density plot of valid percentage
#We need to compute %valid
dt_2[,valid_p := valid / turnout * 100]

plot(density(dt_2$valid_p),
     main = "% Valid votes distribution",
     xlab = "% Valid votes",
     lwd = 3,
     col = "olivedrab")


##Display a scatterplot where X = percentage vote for Putin and Y = percentage
##turnout
reg_colors <- dt_2$RegType %>%
              as.character %>%
              replace(., . == "oblast", "#e41a1c") %>%
              replace(., . == "respublika", "#377eb8") %>%
              replace(., . == "krai", "#4daf4a") %>%
              replace(., . == "okrug", "#984ea3") %>%
              replace(., . == "gorod", "#ff7f00")
plot(x = dt_2$Pu_p, y = dt_2$turnout_p,
     main = "% Turnout vs % Putin",
     xlab = "% Putin",
     ylab = "% Turnout",
     pch = 19,
     col = reg_colors
     )

##Display a correlation matrix and a fancy correlation table for votes for
##different candidates and percentage turnout
cor.mat <- cor(dt_2[, c("Zh_p","Zu_p","Mi_p","Pr_p","Pu_p", "turnout_p")])
#Rename columns and rows to something readable
rownames(cor.mat) <-  c("% Zhirinovsky",
                        "% Zuganov",
                        "% Mironov",
                        "% Prokhorov",
                        "% Putin",
                        "% Turnout")
colnames(cor.mat) <-  c("% Zhirinovsky",
                        "% Zuganov",
                        "% Mironov",
                        "% Prokhorov",
                        "% Putin",
                        "% Turnout")
print(cor.mat)

corrplot(cor.mat,
         method = "color",
         type = "lower",
         addCoef.col = "black")

##Use stargazer to make a correlation table that we can use in Word (for the
##seminar, we will use the text format)

cor.mat %>% stargazer(type = "html", out = "election_correlations.html")

##Display 5 regions with the most and the least votes for Putin

#Most votes
dt_2[order(-Pu_p)][1:5] %>% View()

#Least votes
dt_2[order(Pu_p)][1:5] %>% View()

##Display a heatmap (or maybe a 3d plot) of percentage for Putin vs Percentage
##turnout

el_2d_den <- MASS::kde2d(dt_2$Pu_p, dt_2$turnout_p)
filled.contour(el_2d_den, color.palette = heat.colors)
contour(el_2d_den, add = TRUE)


##Test the valid percentage and votes for Putin for normality
##density plots

mean_pu <- dt_2$Pu_p %>% mean()
sd_pu <- dt_2$Pu_p %>% sd()

plot(density(dt_2$Pu_p),
     main = "% Putin distribution",
     xlab = "% Putin",
     lwd = 3,
     col = "olivedrab")

curve(dnorm(x, mean = mean_pu, sd = sd_pu),
      col = "red",
      lwd = 3,
      add = TRUE,
)

##QQ plot

qqPlot(dt_2$Pu_p)

##Anderson-Darling test

ad.test(dt_2$Pu_p)

