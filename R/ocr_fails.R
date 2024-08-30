# Delete duplicate images from the OCR fails folder
delete_dup_ocr_fails <- function() {
  cat("Starting delete_dup_ocr_fails", "\n")
  fnames <- list.files("./images/ocr/tesseract_fails/")
  unique_files <- fnames[grepl("unique", fnames)]
  unique_images <- lapply(
    unique_files,
    function(x) {
      magick::image_read(paste0("./images/ocr/tesseract_fails/",x))})
  non_unique_files <- setdiff(fnames, unique_files)
  iii <- 0
  while (length(non_unique_files) > 0 && iii < 1e3) {
    iii <- iii + 1
    imgnu <- magick::image_read(paste0("./images/ocr/tesseract_fails/",
                                       non_unique_files[[1]]))
    is_unique <- TRUE
    
    # Loop over unique images to check for match
    for (iu in 1:length(unique_files)) {
      imgu <- unique_images[[iu]]
      
      # Most matches are around 0-0.02
      # "96" matched "90" with mean abs 2.48
      if (mean(abs(as.integer(imgu[[1]][1:3,,]) -
                   as.integer(imgnu[[1]][1:3,,]))) < 0.2) {
        # browser()
        is_unique <- FALSE
        cat("Found dup, difference was", 
            mean(abs(as.integer(imgu[[1]][1:3,,]) -
                       as.integer(imgnu[[1]][1:3,,]))), "\n")
        break
      }
    }
    if (is_unique) {
      # If unique, add to unique list with new name, save new file name
      new_file_name <-  paste0(substr(non_unique_files[1], 1, 
                                      nchar(non_unique_files[1]) - 4),
                               "_unique.png")
      magick::image_write(imgnu, paste0("./images/ocr/tesseract_fails/",
                                        new_file_name))
      unique_files <- c(unique_files, new_file_name)
      unique_images <- c(unique_images, imgnu)
    } else {
      # If not unique, delete file, delete from list
      # dup_files <- c(dup_files, non_unique_files[1])
      print('found dup')
    }
    # Either way, the file gets deleted (either b/c dup or it was copied as unique)
    file.remove(paste0("./images/ocr/tesseract_fails/",
                       non_unique_files[[1]]))
    non_unique_files <- non_unique_files[-1]
  }
  cat("Finished delete_dup_ocr_fails", "\n")
}
if (T) {
  delete_dup_ocr_fails()
}

# label unlabeled images
label_ocr_fails <- function() {
  cat("Starting label_ocr_fails", "\n")
  fnames <- list.files("./images/ocr/tesseract_fails/")
  unlabeled_files <- fnames[grepl("unique", fnames) & !grepl("label", fnames)]
  for (i in seq_along(unlabeled_files)) {
    img <- magick::image_read(paste0("./images/ocr/tesseract_fails/",unlabeled_files[i]))
    plot(1:10)
    plot(img)
    input <- readline(prompt = "Enter number shown on image: ")
    if (input == "delete") { # Some screenshots are errors
      file.remove(paste0("./images/ocr/tesseract_fails/",unlabeled_files[i]))
    } else {
      stopifnot(input != "", nchar(input) <= 3, !is.na(as.integer(input)))
      # Change file name
      new_file_name <- paste0(substr(unlabeled_files[i], 1, 
                                     nchar(unlabeled_files[i]) - 4),
                              "_label=",input,".png")
      magick::image_write(img,  paste0("./images/ocr/tesseract_fails/",
                                       new_file_name))
      # Delete old file
      file.remove(paste0("./images/ocr/tesseract_fails/",unlabeled_files[i]))
    }
  }
  cat("Finished label_ocr_fails", "\n")
}
if (T) {
  label_ocr_fails()
}


fnames <- list.files("./images/ocr/tesseract_fails/")
unique_labeled_file_names <-  fnames[
  grepl("unique", fnames) & grepl("label", fnames)]
unique_labeled_images <- lapply(
  unique_labeled_file_names,
  function(x) {
    magick::image_read(paste0("./images/ocr/tesseract_fails/",x))})

matching_image_label <- function(image) {#browser()
  # Use larger tolerance here than when finding uniques
  # A "96" matched a "90" with mean abs 2.48
  mindiff <- Inf
  minindex <- NA
  for (i in seq_along(unique_labeled_images)) {
    diff <- mean(abs(as.integer(unique_labeled_images[[i]][[1]][1:3,,]) -
                       as.integer(image[[1]][1:3,,])))
    if (diff < mindiff) {
      mindiff <- diff
      minindex <- i
    }
    if (diff < 1) {
      # return(TRUE)
      # Return label from file name
      label <- unique_labeled_file_names[[i]] %>%
        stringr::str_split("=") %>% .[[1]] %>% .[2] %>% substr(1, nchar(.)-4)
      return(label)
    }
  }
  # browser()
  # Otherwise return NA
  NA
}
if (F) {
  matching_image_label(unique_labeled_images[[1]])
  matching_image_label(unique_labeled_images[[2]])
  matching_image_label(unique_labeled_images[[3]])
  matching_image_label(unique_labeled_images[[4]])
  matching_image_label(unique_labeled_images[[18]])
  matching_image_label(unique_labeled_images[[28]])
  matching_image_label(damon90)
}

