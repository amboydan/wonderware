# pull daily data
source('./scada_query.R');

cyclesDate <- seq.Date(
  from = as.Date('2014-12-01'),
  to = as.Date('2025-05-01'),
  by = '10 days'
)

tagName <- 'AK_4118_Well_KU_1217.TBG_PT'
wellName <- 'KU 12-17'

parameters$tag_name <- tagName
parameters$well_name <- wellName

for (i in 1:(length(cyclesDate)-1)) {
  
  parameters = params(st = paste0(cyclesDate[i], ' AKDT'), 
                      sp = paste0(cyclesDate[i] + 1, ' AKDT'))
  df <- getValues(params = parameters)
  
  if(max(df$Value, na.rm = T) < 1900 | min(df$Value, na.rm = T) > 1700) next
  
  write.csv(
    df,
    file = paste0('./pressure/ku1217/', wellName, ' ', cyclesDate[i], ' ', '.csv')
  )
  
  p <- ggplot(df, aes(as.POSIXct(DateTime), Value)) + 
    geom_point(shape = 21, fill = 'red') +
    labs(x = 'time',
         y = 'Tbg Press (psig)\n',
         title = paste0(wellName, ' ', cyclesDate[i])) +
    theme_bw() +
    theme(
      plot.title = element_text(hjust = 0.5)
    )
  
  png(filename = paste0('./pressure/ku1217/', wellName, ' ', cyclesDate[i], ' ', '.png'), 
      width = 480, height = 480,
      units = "px", pointsize = 3, bg = "white", res = NA,
      restoreConsole = TRUE)
  print(p)
  dev.off()
}
