#' Add question numbers to ODK XLS Form
#'
#' Take existing labels from an ODK XLS form and attach automatically generated
#' question numbers based on groups and questions within groups New numbers will
#' be generated for each new section (group or repeat) - nesting of sections not
#' currently implemented Questions will be assigned to the following ODK
#' elements: "integer","decimal", "select_one",
#' "select_multiple","text","date","datetime","time", "image","geopoint"
#' @param ODKFile ODK form read in using read.odk
#' @param language language of label column to add numbers into
#' @param maintype how to label sections. Defaults to "numbers". Also can have
#'   "LETTERS" or "letters"
#' @param subtype how to label questions within sections. Defaults to
#'   "numbers". Also can have "LETTERS" or "letters"
#' @keywords ODK Question Number XLSForm
#' @importFrom openxlsx read.xlsx
#' @export
#' @examples
#' #Form<-read.odk("data/EvaluationQuestionnaire2018.xlsx")
#' #Form %>% add_question_numbers()
add_question_numbers<-function(ODKFile,language="English",maintype="numbers",subtype="numbers"){
  require(openxlsx)
  Qs<-ODKFile$survey

  hds<-substr(Qs$type,1,3)
  len<-nrow(Qs)
  Qs$ID<-1:len

  Class<-rep("",len)
  Class[hds%in%c("int","sel","tex","geo","dec","dat","ima","tim","str")]<-"Question"
  Class[hds%in%c("beg")]<-"Open"
  Class[hds%in%c("end")]<-"Close"
  Class[Qs$type=="end"]<-""

  Class[Qs$appearance=="label"]<-""

  Num<-rep(0,len)
  sub<-rep(0,len)

  if(Class[1]=="Open"){
    Num<-rep(1,len)
  }


  for(i in 2:nrow(Qs)){
    if(Class[i]=="Open"&Class[i-1]!="Open"){
      Num[i:nrow(Qs)]<-Num[i-1]+1
    }


  }
  Q_only<-data.frame(Num,ID=Qs$ID)[Class=="Question",]

  Q_only$sub<-1

  if(nrow(Q_only)>1){
  for(i in 2:nrow(Q_only)){
    if(Q_only$Num[i]>Q_only$Num[i-1]){
      Q_only$sub[i]<-1
    }
    else{
      Q_only$sub[i]<-Q_only$sub[i-1]+1
    }
  }
  }
  else{
    Q_only$Num<-1
  }

  merge_nums<-data.frame(Num=unique(Q_only$Num),NewNum=1:length(unique(Q_only$Num)))

  Q_only<-merge(Q_only,merge_nums,all=TRUE)

  if(maintype=="LETTERS"){
    Q_only$NewNum<-LETTERS[Q_only$NewNum]
  }
  if(maintype=="letters"){
    Q_only$NewNum<-letters[Q_only$NewNum]
  }
  if(subtype=="LETTERS"){
    Q_only$sub<-LETTERS[Q_only$sub]
  }
  if(subtype=="letters"){
    Q_only$sub<-letters[Q_only$sub]
  }

  Q_only$QuestNo<-paste(Q_only$NewNum,Q_only$sub,sep=".")

  Qs2<-merge(Qs,Q_only[,c("ID","QuestNo")],all=T,sort = F)
  Qs2<-Qs2[order(Qs2$ID),]
  if(language!=""){
  lab<-paste("label",language,sep="::")
  }
  else{
    lab<-"label"
  }
  Qs2$OldLabel<-ifelse(is.na(Qs2[,lab]),"",as.character(Qs2[,lab]))

  Qs2[,lab]<-paste(Qs2$QuestNo,Qs2$OldLabel)
  Qs2[,lab][is.na(Qs2$QuestNo)]<-as.character(Qs2$OldLabel)[is.na(Qs2$QuestNo)]

  ODKFile$survey<-Qs2

  return(ODKFile)
}


