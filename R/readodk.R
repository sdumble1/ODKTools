#' Read in an ODK XLS form into R
#'
#' Converts ODK form into list data frame of survey, choices and settings, for use in this package
#' @param ODKFile file location where XLSForm is saved
#' @keywords ODK Question Number XLSForm
#' @importFrom openxlsx read.xlsx
#' @export
#' @examples
#' #Form<-read.odk("data/EvaluationQuestionnaire2018.xlsx")
#' #write.odk(Form,"data/EvaluationQuestionnaire2018_modified.xlsx")

read.odk<-function(ODKFile){
  require(openxlsx)

  if(substr(ODKFile,nchar(ODKFile)-3,nchar(ODKFile))!="xlsx"){
    stop("File is not saved in Excel (2003 or later) .xlsx format.")
  }

  SN<-getSheetNames(ODKFile)

  if(any(c("survey","choices")%in%SN)==FALSE){
    stop("Input file does not contain tabs called 'survey' and 'choices'. Please check input file is a valid XLS Form")
  }

  survey<-read.xlsx(ODKFile,"survey")

  choices<-read.xlsx(ODKFile,"choices")

  if("settings"%in%SN){
  settings<-read.xlsx(ODKFile,"settings")
  }
  else{
    settings<-data.frame(language="")
  }


  out<-list(survey=survey,choices=choices,settings=settings)
  class(out)<-"odkxls"
 return(out)
}


