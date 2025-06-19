library(magrittr); library(dplyr); library(ggplot2)

params <- function(st = "2021-01-01 AKDT", sp = "2025-03-15 AKDT") {
  params = data.frame(
    well_name = "",
    tag_name = "",
    tag_type = "",
    divisions = '30 minutes',
    jank = 1,
    hist_string = paste0("driver={SQL Server};server=KEN353INSQL1;", 
                         "database=Runtime;Uid=wwUser;Pwd=wwUser"),
    start_time = as.POSIXct(st),
    stop_time = as.POSIXct(sp)
  )
  
  return(params);
}

parameters = params()

# get_values <- function(params = parameters) {
#   
#   # Parameters
#   Historian = RODBC::odbcDriverConnect(params$hist_string)
#   time = round(as.numeric(params$stop_time - params$start_time), 4)/params$jank
#   divisions = params$divisions
#   tag = params$tag_name
#   
#   # Calculate the number of points
#   calc_points = function(time, divisions) {
#     tm = divisions
#     div = data.frame(div=c("seconds","30 seconds", "minutes","5 minutes", "10 minutes","30 minutes",
#                            "hours","4 hours", "12 hours","1 day", "5 days","15 days","30 days"),
#                      #seconds and 30 seconds
#                      divby=c(0.000011574,.00034722, 
#                              #min and 5 min
#                              .00069444,.00347222,
#                              #10 min and 30 min
#                              .0069444,.0208333,
#                              #hour and 4 hours
#                              .041666,.166664,
#                              #12 hours and 1 day
#                              .5,1,
#                              #5 days and 15 days and 30 days
#                              5,15,30))
#     div <- div %>% filter(div == tm) %>% select(divby)
#     return(round(time / div$divby, 0))
#   }
#   num_points = calc_points(time, divisions)
#   
#   # query
#   query = RODBC::sqlQuery(Historian,
#                           paste0("SELECT Well = '", params$well_name,"', Tag = '", 
#                                  params$tag_type,"', ",
#                                  " DateTime, Value FROM History",
#                                  " WHERE TagName = '",params$tag_name,"'",
#                                  " AND DateTime >= '",params$start_time,"'",
#                                  " AND DateTime <= '",params$stop_time,"'",
#                                  " AND wwRetrievalMode = 'Max' AND wwCycleCount = ",num_points,
#                                  " AND wwTimeStampRule = 'Start'"))
#   return(query)
# }