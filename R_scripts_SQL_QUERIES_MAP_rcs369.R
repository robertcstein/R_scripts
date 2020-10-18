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
#ggpairs(linreg_results)


#storing the connection -- must store the connection in memory!
db <- dbConnect(SQLite(), dbname="yelp_reduced_rcs369.sqlite")

#Lists the tables in the db connection and stores in tbs
tbs <- dbListTables(db)

#prints the tables in the database
print(tbs)

df <- "select state, count(business_id) as biz_count, avg(review_count) as avg_review, avg(stars) as avg_stars, avg(review_count)*avg(stars) as popularity
	from business
	where length(state) < 3
	group by state
	order by biz_count desc, popularity desc
	limit 10"
geo_result <- dbGetQuery(conn = db, df)
df$hover <- with(geo_result, paste(state,
                           '<br>', "business count - ", biz_count,
				   '<br>', "avg # of reviews - ", avg_review,
				   '<br>', "avg stars - ", avg_stars,
				   '<br>', "popularity - ", popularity))
#print(geo_result)
# give state boundaries a white border
l <- list(color = toRGB("white"), width = 2)
# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)
geo_p <- plot_geo(geo_result, locationmode = 'USA-states') %>%
	add_trace(
	    z = ~popularity, text = ~df$hover, locations = ~state,
	    color = ~popularity, colors = 'Purples'
	) %>%  
	colorbar(title = "Popularity Rating") %>%
	layout(
	title = 'Yelp Top 10 Penetration by State',
	geo = g
  )
geo_p