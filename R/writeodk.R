#' Write an ODK object back to XLS form
#'
#' Outputs form modified in R back to an XLS form
#' @param obj R object
#' @param file location to write new XLS form
#' @keywords write ODK form
#' @importFrom openxlsx write.xlsx
#' @export
#' @examples
#' #Form<-read.odk("data/EvaluationQuestionnaire2018.xlsx")
#' #write.odk(Form,"data/EvaluationQuestionnaire2018.xlsx")
write.odk<-function(obj,file){


  if(class(obj)!="odkxls"){
    stop("Input object an imported XLS form of class odkxls")
  }

  if(substr(file,nchar(file)-3,nchar(file))!="xlsx"){
    file<-paste(file,"xlsx",sep=".")
  }

  class(obj)<-"list"

  require(openxlsx)
  suppressMessages(write.xlsx(obj,file))
}
