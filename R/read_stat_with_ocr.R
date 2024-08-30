if (!exists("matching_image_label")) {
  source('./R/ocr_fails.R')
}

# Use OCR to parse attribute number from given location of screenshot
read_stat_with_ocr <- function(img, y, x=1263, width=85, height=65,
                               is_discrete=FALSE) {
  attempt <- 0
  for (x_i in c(0,-1,1)) {
    for (y_i in c(0,-1,1)) {
      for (use_thresh in c(T,F)) {
        attempt <- attempt + 1
        cat("ocr attempt", attempt, "\n")
        # print(y_i)
        img_crop <- magick::image_crop(
          img,
          geometry=paste(width, "x", height,
                         "+",x + 3*x_i, "+", y + 3*y_i),
          gravity="NorthWest",repage=TRUE)
        # if (attempt <= 2) {
        #   plot(img_crop)
        # }
        # print(img_crop)
        if (use_thresh) {
          imgthresh <- magick::image_threshold(img_crop)
          stat_ocr <- stringr::str_trim(tesseract::ocr(imgthresh))
          # if (attempt <= 2) {
          plot(imgthresh)
          # }
        } else {
          stat_ocr <- stringr::str_trim(tesseract::ocr(img_crop))
          # if (attempt <= 2) {
          plot(img_crop)
          # }
        }
        # print(stat_ocr)
        if (stat_ocr != "") { # Make sure it found something
          cat(paste("OCR found: ", stat_ocr), "\n")
          
          # Sometimes goes off track onto the heatmap page
          if (stat_ocr %in% c("HOT", "UTRA", "COLD")) {
            timestamp()
            # browser()
          }
          stat_int <- suppressWarnings(as.integer(stat_ocr))
          # Make sure it found number
          if(!is.null(stat_int) && !is.na(stat_int) &&
             length(stat_int) == 1 &&
             is.integer(stat_int) && 
             stat_int >= 0 && stat_int <= 100 &&
             (!is_discrete || (stat_int %in% discrete_values))) {
            return(stat_int)
          }
          
        }
        
      }
    }
  }
  print("OCR found nothing")  # If failed, save to folder for review later
  
  # Check if images matches something in labeled images
  label_match <- matching_image_label(img_crop)
  if (!is.na(label_match)) {
    cat("FOUND MATCH IN LABELED IMAGES!!!!!", label_match, "\n")
    stat_int <- as.integer(label_match)
    if(!is.null(stat_int) && is.integer(stat_int) && 
       stat_int >= 0 && stat_int <= 100 &&
       (!is_discrete || (stat_int %in% discrete_values))) {
      return(stat_int)
    } else {
      cat("ISSUE WITH LABEL_MATCH TO STAT_INT", label_match, "\n")
    }
  }
  
  # Otherwise save this in the fails folder
  magick::image_write(
    image=img_crop, 
    path=paste0(
      "./images/ocr/tesseract_fails/", 
      as.character(Sys.time()) %>% stringr::str_replace_all("\\.","_") %>%
        stringr::str_replace_all(":","_"), ".png"))
  return(NA)
}
