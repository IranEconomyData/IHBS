library(gh)
library(rio)
library(usethis)
owner = "Elaheh-Elahi"
repo = "IHBS_data_"
directory = "data/97"
branch = "main"
files <- gh("/repos/:owner/:repo/contents/:path", owner = owner, repo = repo, path = directory, ref = branch)

for (file in files){
  file_url <- paste0("https://github.com/Elaheh-Elahi/IHBS_data_/raw/main/data/97/", file$name)
  df <- import(file_url)
  filename <- gsub(".rda$", "", file$name)
  assign(filename , df)
  do.call("use_data", list(as.name(filename), overwrite = TRUE))
}

# rm(df, file, files)

