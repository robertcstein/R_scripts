#only need to install once
#install.packages("RSQLite")
#install.packages("GGally")
#install.packages("HH")
#install.packages("plotly")


getwd()
setwd("C:/Users/Stein_Wang/Documents/Local_Personal/Cornell/NBA6550 Intro to Stat Progrming SQL/Programming_R/R_Scripts")
getwd()

#must load each time
library("RSQLite")
library("HH")
library(plotly)
#library("GGally")

#storing the connection -- must store the connection in memory!
db <- dbConnect(SQLite(), dbname="yelp_reduced_rcs369.sqlite")

#Lists the tables in the db connection and stores in tbs
tbs <- dbListTables(db)

#prints the tables in the database
print(tbs)

query <- "select b.stars, b.review_count, count(p.business_id) as photo_count, b.stars*b.review_count as popularity
	from business as b
    		left join photos as p
        		on p.business_id = b.business_id
	group by b.business_id
	order by photo_count desc"
result <- dbGetQuery(conn = db, query)

# Numerical Summaries
summary(result) 

##################  LONG!!! Prints the SQL query result
print(result)

help(lm)

linreg_results <- lm(result$popularity ~ result$photo_count)

anova(linreg_results)
summary(linreg_results)
#print(result$popularity ~ result$photo_count)

#plot_ly scatterplot
p <- plot_ly(x = ~result$photo_count, y = ~result$popularity, color = ~result$photo_count, size = ~result$popularity, type = "scatter") %>%
	layout(title = 'Relationship b/t Popularity Score with # of Photos',
		xaxis = list(title = '# of Photos'),
		yaxis = list (title = 'Popularity Score (Review Count * Star Rating)'))
p

#Regular_R scatterplot
plot(result$popularity ~ result$photo_count, xlab = "photo_count", ylab = "popularity", main = "Relationship b/t Popularity Score (Review*Stars) with # of Photos") 
#creates a scatterplot of y versus x
abline(linreg_results)

