library(readxl)
library(haven)

## Ця функція читає файл даних і мета-даних за специфікацією XLSForm
xlsform_read <- function(file_name, data_sheet = 'data', from = 'label::English (en)') {
  data <- read_xlsx(file_name, sheet = data_sheet)
  survey <- read_xlsx(file_name, sheet = "survey")
  choices <- read_xlsx(file_name, sheet = "choices")

  for (varname in names(data)) {
    found <- survey$name == varname
    if (any(found)) {
      variable <- survey[found, ]
      varlab <- variable[[from]]
      if (!is.na(varlab)) attr(data[[varname]], 'label') <- varlab
      u <- unlist(strsplit(variable$type, ' '))
      if (length(u) > 1) {
        labs <- subset(choices, list_name == u[2])
        attr(data[[varname]], 'labels') <- sort(
          setNames(object = labs$name, nm = labs[[from]])
        )
      }
      attr(data[[varname]], 'measure') <- variable$measure
    }
  }
  return(data)
}

## Функція, яка категоріальну змінну перетворює на фактор
to_factor <- function(variable, drop.levels = FALSE) {
  values <- attr(variable, 'labels')
  vlabel <- attr(variable, 'label')
  measure <- tolower(attr(variable, 'measure'))

  if (is.null(measure)) measure <- 'scale'
  
  if (is.numeric(variable) & measure == 'nominal' | measure == 'ordinal') {
    variable <- factor(
      x = variable, levels = values, labels = names(values),
      ordered = measure == 'ordinal'
    )
    if (drop.levels) variable <- droplevels(variable)
    attr(variable, 'label') <- vlabel
  }

  return(variable)
}
