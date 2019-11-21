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
  survey<-read.xlsx(ODKFile,"survey")
  choices<-read.xlsx(ODKFile,"choices")
  settings<-read.xlsx(ODKFile,"settings")

 return(list(survey=survey,choices=choices,settings=settings))
}
