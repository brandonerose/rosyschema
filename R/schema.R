load_schema <-function(S){
  S<-list()
  for(NAME in c("tables",  "columns", "choices")){
    S[[NAME]] <- read.csv(file.path(get_dir(),"output",paste0(NAME,".csv")))
  }
  S
}

save_schema <-function(S){
  for(NAME in names(S)){
    S[[NAME]] %>% write.csv(file.path(get_dir(),"output",paste0(NAME,".csv")),row.names=F)
  }
}
