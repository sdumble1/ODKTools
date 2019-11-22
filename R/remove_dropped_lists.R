#' Remove any lists from the choices tabs that do not appear in the main survey
#'
#' These will be moved into a new tab called unused_choices. Standard ODK
#' validations check if all lists from survey are in choices but not the other
#' way around. The reverse is useful to prevent translation of obsolete lists
#' and for form checking
#'
#' @param ODKFile ODK form read in using read.odk
#' @param verbose return message indicating whether to show message or just
#'   return object
#' @keywords ODK lists unsused
#' @importFrom openxlsx read.xlsx
#' @importFrom dplyr filter
#' @export
#' @examples
#' #Form<-read.odk("data/EvaluationQuestionnaire2018.xlsx")
#' #Form %>% remove_dropped_lists()
remove_dropped_lists<-function(ODKFile,verbose=TRUE){

  if(class(ODKFile)!="odkxls"){
    stop("Input object an imported XLS form of class odkxls")
  }

  survey<-ODKFile$survey
  choices<-ODKFile$choices

  selects<-survey$type[grep("select_one|select_multiple",survey$type)]

  survey_lists<-trimws(gsub("select_one|select_multiple|or_other","",selects))

  if("list.name"%in%colnames(choices)){
    colnames(choices)[colnames(choices)=="list.name"]<-"list_name"
  }

  choices2<-dplyr::filter(choices,list_name%in%unique(choices$list_name)[unique(choices$list_name)%in%survey_lists])

  dropped<-dplyr::filter(choices,!list_name%in%unique(choices$list_name)[unique(choices$list_name)%in%survey_lists])
  if(nrow(dropped)>0){
    if(verbose==T){message(paste0(nrow(dropped)," unreferenced lists removed from choices sheet: ",paste(unique(dropped$list_name),collapse="; ")))}

    ODKFile$choices<-choices2
    ODKFile$unused_choices<-dropped
     return(ODKFile)
  }
  else{
    if(verbose==T){ message("No unreferenced lists found in choices tab. No changes made")}
    return(ODKFile)
  }
}
