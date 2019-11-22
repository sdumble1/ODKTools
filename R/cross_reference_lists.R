#' cross reference the choices tab with information from the survey tab
#'
#' This is useful for checking and translation purposes to have the question
#' text next to the answer text to provide additional context and make sure
#' wording is appropriate. Multiple questions mapping to same list set will be concatenated
#' @param ODKFile ODK form read in using read.odk
#' @param by which column from survey tab to use as cross reference
#' @param language language of column (can be "" if no languages referred to in from)
#' @keywords ODK lists unsused
#' @importFrom dplyr group_by summarise right_join select %>% mutate
#' @export
#' @examples
#' #Form<-read.odk("data/EvaluationQuestionnaire2018.xlsx")
#' #Form %>% cross_reference_lists()
cross_reference_lists<-function(ODKFile,by="label",language="English"){

  if(class(ODKFile)!="odkxls"){
    stop("Input object an imported XLS form of class odkxls")
  }

  survey<-ODKFile$survey
  choices<-ODKFile$choices

  selects<-survey[grep("select_one|select_multiple",survey$type),] %>%
    mutate(list_name=trimws(gsub("select_one|select_multiple|or_other","",type)))

  if("list.name"%in%colnames(choices)){
    colnames(choices)[colnames(choices)=="list.name"]<-"list_name"
  }

  if(language!="" & by%in%c("hint","label")){
    by=paste(by,language,sep="::")
  }

  selects$by<-selects[,by]

  ODKFile$choices<- selects %>%
    select("list_name","by") %>%
    group_by(list_name) %>%
    summarise(question=paste(by,collapse=";\n")) %>%
    suppressMessages(right_join(choices))

  return(ODKFile)
}
