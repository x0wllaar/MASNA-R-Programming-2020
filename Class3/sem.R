library(data.table)
library(purrr)
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
##?????????? ???????????????? (???????????????????? ??????????????????)
##???????????????????? ???? ?????????????????? ????

dt_1_c <- dt_1[
   !grepl("????????????????", region, fixed = TRUE)
  ][
   !grepl("???????????????????? ???? ?????????????????? ????", region, fixed = TRUE) 
  ]

##Remove rows with missing data
dt_1_c_nona <- na.omit(dt_1_c)

##Display descriptives of the data
summary(dt_1_c_nona)

##Aggregate columns turnout, total, invalid, valid, Zh, Zu, Mi, Pr, Pu by region
##(by summing them)
##Recompute turnout percentage for each region
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


##Create a factor variable with the region type
##“область”, “республика”, “край”, “округ”, “город”
##??????????????, ????????????????????, ????????, ??????????, "?????????? "
##"oblast", "respublika", "krai", "okrug", "gorod"
##HINT: Use grepl and data.table subsetting

##Display a (fancy) barplot with the number of regions of different types

##Display a pie char with the same information

##Display a (fancy) histogram of turnout percentage

##Compute vote percentage for each of the candidates (number_of_voted / valid)

##Display a boxplot of percentage vote for Zuganov

##Display a violin plot of percentage vote for Mironov

##Display a density plot of valid percentage

##Display a scatterplot where X = percentage vote for Putin and Y = percentage
##turnout

##Display a scatterplot matrix for votes for different candidates and percentage
##turnout

##Display a correlation matrix and a fancy correlation table for votes for
##different candidates and percentage turnout

##Display 5 regions with the most and the least votes for Putin

##Display a heatmap (or maybe a 3d plot) of percentage for Putin vs Percentage
##turnout

##Test the valid percentage and votes for Putin for normality
##density plots
##QQ plot
##Anderson-Darling test
