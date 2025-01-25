## Переконайтеся, що в поточному проєкті RSudio інсталбовані пакети haven і readxl
## Підключимо до сеансу скрипт з визначенням двох функцій
source("export XLSForm.R")

## Здійснити імпорт даних з файлу "MRMT XLSForm.xlsx", який містить дані і мета-дані
## дослідження R.M. Furr
x <- xlsform_read(
  file_name = "MRMT XLSForm.xlsx",
  from = 'label::Ukrainian (uk)'
)

## Зберегти дані у внутрішньому форматі R
saveRDS(x, file = "MRMT-UA.rds")

## Усі категоріальні змінні перетворити на фактори для експорту в SPSS
u <- x
u[] <- lapply(x[], FUN = to_factor)

## Експортувати дані в форматі IBM SPSS Statistics
haven::write_sav(
  data = u, path = "MRMT-UA.sav",
  compress = "zsav"
)
