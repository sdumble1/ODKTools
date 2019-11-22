#' Add acknowledgement fields at end of each question group to indicate if any
#' of the questions have been left blank
#'
#' This is useful if you do not want to force all questions to be required, but
#' still want to make sure that all questions are being addressed and not left
#' blank accidentally
#' @param ODKFile ODK form read in using read.odk
#' @param language language of hint column to add trigger hint
#' @param groups add triggers to "all" groups (default) or to user specified list of groups
#' @param hinttext text that will appear in trigger messages
#' @keywords ODK Question Number XLSForm
#' @importFrom openxlsx read.xlsx
#' @importFrom dplyr summarise mutate arrange filter select %>%
#' @export
#' @examples
#' #Form<-read.odk("data/EvaluationQuestionnaire2018.xlsx")
#' #Form %>% trigger_blanks()


trigger_blanks<-function(ODKFile,groups="all",language=NULL,
                         hinttext="At least one question within this section has been left blank. Select OK if this has been skipped intentionally; otherwise please check responses"){


  if(class(ODKFile)!="odkxls"){
    stop("Input object an imported XLS form of class odkxls")
  }
  if(is.null(language)){
    language<-ODKFile$settings$default_language
  }
  survey<-ODKFile$survey

  survey$statement<-ifelse(survey$relevant==""|is.na(survey$relevant),paste0("${",survey$name,"}=''"),
                           paste0("((",survey$relevant,") and ${",survey$name,"}='')"))

  survey$groupname<-""
  survey$Sortnum<-1:nrow(survey)


  grp<-NULL
  for(i in 1:nrow(survey)){

    if(survey$type[i]=="begin group"|survey$type[i]=="begin repeat"|survey$type[i]=="begin_group"|survey$type[i]=="begin_repeat"){
      grp<-c(grp,survey$name[i])
    }
    if(survey$type[i]=="end group"|survey$type[i]=="end repeat"|survey$type[i]=="end_group"|survey$type[i]=="end_repeat"){
      grp<-grp[-length(grp)]
    }
    survey$groupname[i]<-paste(grp,collapse=".")
  }


  addons<-survey %>% group_by(groupname) %>%
    dplyr::filter(groupname!="") %>%
    dplyr::filter(!type%in%c("begin group","end group","begin repeat","end repeat","begin_group","end_group","begin_repeat","end_repeat",
                    "trigger","calculate","text","start","end","today","subscriberid",
                    "note","phonenumber","imei","deviceid")) %>%
    dplyr::summarise(relevant=paste(statement,collapse=" or "),Sortnum=max(Sortnum)+0.5) %>%
    dplyr::mutate(name=paste0(groupname,"_chk"),type="trigger", required="yes",hint=hinttext) %>%
    select(-groupname,-statement)
  if(language!=""){colnames(addons)[colnames(addons)=="hint"]<-paste0("hint::",language)}


  form2<-filter(survey,!name%in%addons$name)
  form2$relevant<-as.character(form2$relevant)
  if(language!=""){form2[,paste0("hint::",language)]<-as.character( form2[,paste0("hint::",language)])}
  if(language==""){form2[,"hint"]<-as.character( form2[,"hint"])}

  ODKFile$survey<-suppressMessages(full_join(form2,addons)) %>%
    arrange(Sortnum) %>%
    select(-Sortnum)

  return(ODKFile)

}
