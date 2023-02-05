cache<-NULL
.onLoad<-function(libname, pkgname){
  x<-hoardr::hoard()
  x$cache_path_set(.packageName,type="user_cache_dir")
  cache<<-x
}

save_cache <- function(schema){
  cache$mkdir()
  cache_path <- suppressWarnings(
    normalizePath(
      file.path(cache$cache_path_get())
    )
  )
  saveRDS(schema, file = file.path(cache_path,"schema.rds"))
  message("saved to cache (",file.path(cache_path,"schema.rds"),")")
}

load_cache <- function(){
  cache$mkdir()
  cache_path <- suppressWarnings(
    normalizePath(
      file.path(cache$cache_path_get())
    )
  )
  message("loaded schema from cache")
  readRDS(file.path(cache_path,"schema.rds"))
}


set_dir <- function(dir_path){
  #param check
  if ( ! is.character(dir_path)) stop("dir must be a character string")
  #function
  dir_path <- trimws(dir_path)

  dir_path <- normalizePath(dir_path, winslash = "/",mustWork = F)
  if(!file.exists(dir_path)){
    if(menu(choices = c("Yes","No"),title = "No file path found, create?")==1){
      dir.create(file.path(dir_path))
    }
  }
  if ( ! file.exists(dir_path)) {
    stop("Path not found. Use absolute path or choose one within R project working directory.")
  }
  cache$mkdir()
  cache_path <- suppressWarnings(
    normalizePath(
      file.path(cache$cache_path_get())
    )
  )
  if (file.exists(file.path(cache_path,"dir_path.rds"))){
    if (file.exists(readRDS(file.path(cache_path,"dir_path.rds")))){
      if (dir_path!=readRDS(file.path(cache_path,"dir_path.rds"))){
        answer<-utils::menu(c("Yes","No"),title = paste0("There is already a cached path at '",readRDS(file.path(cache_path,"dir_path.rds")),"'. Would you like to continue?"))
        if (answer == 2){
          readRDS(file.path(cache_path,"dir_path.rds"))
          stop("You chose to stop because there is already an exsisting directory.")
        }
      }
    }
  }
  dir.create(file.path(dir_path,"R_objects"),showWarnings = F)
  dir.create(file.path(dir_path,"output"),showWarnings = F)

  # validate_dir(dir_path,silent=F)
  saveRDS(dir_path, file = file.path(cache_path,"dir_path.rds"))
  message("saved to cache")
}
#' @title get your FCI directory
#' @export

get_dir <- function(){
  cache$mkdir()
  cache_path <- suppressWarnings(
    normalizePath(
      file.path(cache$cache_path_get())
    )
  )
  stop_mes<-"Did you use `set_dir()`?"
  if ( ! file.exists(cache_path)) stop(paste0("No cache. ", stop_mes))
  if ( ! file.exists(file.path(cache_path,"dir_path.rds"))) stop(paste0("No directory stored in cache. ", stop_mes))
  dir_path<-readRDS(file.path(cache_path,"dir_path.rds"))
  if ( ! file.exists(dir_path)) {
    warning("Searched for cached directory --> '",dir_path,"' ...")
    stop(paste0("Does not exist. ", stop_mes))
  }
  dir_path
}
