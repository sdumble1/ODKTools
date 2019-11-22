#' summary function for class type odkxls
#' @param object imported xls form
#' @keywords ODK Question Number XLSForm
#' @importFrom openxlsx read.xlsx
#' @importFrom dplyr summarise filter group_by mutate select full_join arrange
#' @export
#' @examples
#' #Form<-read.odk("data/EvaluationQuestionnaire2018.xlsx")
#' #summary(Form)
summary.odkxls<-function(object){
  if(class(object)!="odkxls"){
    stop("Input object an imported XLS form of class odkxls")
  }
  survey<-object$survey

  survey$groupname<-""

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

  survey$groupname[survey$groupname==""]<-"[no group]"
  survey$groupname<-factor(survey$groupname,levels=unique(survey$groupname))

  out<-survey %>% group_by(Group=groupname) %>%
    dplyr::filter(!type%in%c("begin group","end group","begin repeat","end repeat","begin_group",
                             "end_group","begin_repeat","end_repeat")) %>%
    dplyr::summarise(TotalFields=n())

  groups<-dplyr::filter(survey,type%in%c("begin group","begin repeat","begin_group","begin_repeat")) %>%
    dplyr::mutate(Type=ifelse(grepl("group",type),"Group","Repeat"),Group=groupname) %>%
    dplyr::select(Group,Type)%>%
    dplyr::full_join(out,by="Group") %>%
    dplyr::arrange(Group)

  return(groups)
}
