file_name_has_attribute <- function(file_name, attribute) {
  grepl(paste0(attribute, '='), file_name)
}
if (F) {
  file_name_has_attribute("abc_label=12_def.png", 'label')
  file_name_has_attribute("abc_label=12_def.png", 'labe')
}
file_name_get_attribute <- function(file_name, attribute) {
  stopifnot(length(file_name) == 1)
  if (!all(grepl(paste0(attribute, '='), file_name))) {
    stop("Error in file_name_get_attribute")
  }
  file_name %>% 
    strsplit(".png") %>% .[[1]] %>% .[1] %>%
    strsplit(paste0(attribute, "=")) %>% .[[1]] %>% .[2] %>%
    strsplit("_") %>% .[[1]] %>% .[1]
}
if (F) {
  file_name_get_attribute("abc_label=12_def.png", 'label')
  file_name_get_attribute("abc_label=12_def.png", 'labe')
  file_name_get_attribute("abc_label=12.png", 'label')
}

# read_ocr_object ----
read_ocr_object <- R6::R6Class(
  classname="read_ocr_object",
  public = list(
    name=NULL,
    cts=NULL,
    discrete=NULL,
    char=NULL,
    char_list=NULL,
    folder_path=NULL,
    crop=NULL,
    minval=NULL,
    maxval=NULL,
    all_caps=NULL,
    initialize = function(name, cts=FALSE, discrete=FALSE, char=FALSE,
                          char_list=NULL, crop=NULL,
                          minval=0, maxval=100, all_caps=FALSE) {
      # cat("initialize read_ocr_object", "\n")
      stopifnot(is.character(name), length(name) == 1, nchar(name) > 0,
                cts || discrete || char, cts + discrete + char==1,
                !grepl("label", name))
      self$name <- name
      self$cts <- cts
      self$discrete <- discrete
      self$char <- char
      self$char_list <- char_list
      self$crop <- crop
      self$minval <- minval
      self$maxval <- maxval
      self$folder_path <- paste0("./images/ocr/read_ocr_object/", name, "/")
      if (!dir.exists(self$folder_path)) {
        dir.create(self$folder_path)
      }
      
    },
    ocr = function(ss, crop_geometry=self$crop) {
      stopifnot(!is.null(crop_geometry))
      ss_crop <- magick::image_crop(ss, geometry=crop_geometry)
      # browser()
      ocr_out <- tesseract::ocr(ss_crop)
      ocr_trim <- stringr::str_trim(ocr_out)
      
      if (ocr_trim != "") { # Make sure it found something
        cat(paste("OCR found: ", ocr_trim), "\n")
        
        if (self$cts || self$discrete) {
          
          stat_int <- suppressWarnings(as.integer(ocr_trim))
          
          # Make sure it found number
          if(!is.null(stat_int) && !is.na(stat_int) &&
             length(stat_int) == 1 &&
             is.integer(stat_int) && 
             stat_int >= self$minval && stat_int <= self$maxval &&
             (!self$discrete || (stat_int %in% discrete_values))) {
            return(stat_int)
          }
        } else if (self$char) {
          if (self$all_caps) {
            ocr_trim <- toupper(ocr_trim)
          }
          if (is.null(self$char_list) || (ocr_trim %in% self$char_list)) {
              return(ocr_trim)
            }
          # browser("label_match char bad")
        } else {
          stop('error 0983740')
        }
        
      }
      
      
      
      # Failed to find 
      
      # Check if images matches something in labeled images
      label_match <- NA
      
      labeled_file_names <- list.files(self$folder_path) %>% 
        {.[grepl("label", .)]}
      
      # browser()
      ss_crop_avg <- mean(as.integer(ss_crop[[1]][1:3,,]))
      for (i in seq_along(labeled_file_names)) {
        # Check avg from file name to avoid reading in image when possible
        # browser()
        avg_i <- labeled_file_names[i] %>% 
          # strsplit("=") %>% .[[1]] %>% .[2] %>%
          # strsplit("_unique") %>% .[[1]] %>% .[1] %>% 
          file_name_get_attribute("avg") %>% 
          as.numeric
        if (abs(avg_i - ss_crop_avg) > 1) {
          next
        }
        
        labeled_i <- magick::image_read(paste0(self$folder_path,
                                               labeled_file_names[i]))
        
        if (!all(dim(ss_crop[[1]][1:3,,]) == dim(labeled_i[[1]][1:3,,]))) {
          next
        }
        diff_i <- mean(abs(as.integer(ss_crop[[1]][1:3,,]) -
                             as.integer(labeled_i[[1]][1:3,,])))
        
        if (diff_i < 1) {
          label_match <- labeled_file_names[i] %>% 
            # strsplit("label=")[[1]][2] %>%
            # substring(1,nchar(.)-4)
            file_name_get_attribute("label")
          break
        }
      }
      
      # label_match <- matching_image_label(img_crop)
      if (!is.na(label_match)) {
        cat("FOUND MATCH IN LABELED IMAGES!!!!!", label_match, "\n")
        
        if (self$cts || self$discrete) {
          stat_int <- as.integer(label_match)
          if(!is.null(stat_int) && is.integer(stat_int) && 
             stat_int >= self$minval && stat_int <= self$maxval &&
             (!self$discrete || (stat_int %in% discrete_values))) {
            return(stat_int)
          } else {
            cat("ISSUE WITH LABEL_MATCH TO STAT_INT", label_match, "\n")
          }
        } else if (self$char) {
          if (!is.null(self$char_list)) {
            if ((label_match %in% self$char_list)) {
              return(label_match)              
            }
            # browser("label_match char bad")
          }
        } else {
          stop('bad 320491471097')
        }
      }
      
      # Otherwise save this in the fails folder
      magick::image_write(
        image=ss_crop, 
        path=paste0(
          self$folder_path, 
          as.character(Sys.time()) %>% stringr::str_replace_all("\\.","_") %>%
            stringr::str_replace_all(":","_"), "_avg=", 
          round(mean(as.integer(ss_crop[[1]][1:3,,])), 3), ".png"))
      return(NA)
    }, # end get
    run_unique = function() {
      
      cat("Starting delete_dup_ocr_fails", "\n")
      fnames <- list.files(self$folder_path)
      unique_files <- fnames[grepl("unique", fnames)]
      unique_images <- lapply(
        unique_files,
        function(x) {
          magick::image_read(paste0(self$folder_path,x))})
      non_unique_files <- setdiff(fnames, unique_files)
      iii <- 0
      while (length(non_unique_files) > 0 && iii < 1e3) {
        iii <- iii + 1
        imgnu <- magick::image_read(paste0(self$folder_path,
                                           non_unique_files[[1]]))
        # Delete all black images, only one color channel, not three
        if (dim(imgnu[[1]])[1] == 1) {
          # browser()
          cat("Deleting all black pic\n")
          file.remove(paste0(self$folder_path,
                             non_unique_files[[1]]))
          next
        }
        # try2 <- try(imgnu[[1]][1:3,,])
        # if (inherits(try2, "try-error")) {
        #   print(paste0(self$folder_path,
        #                non_unique_files[[1]]))
        #   browser()
        # }
        
        is_unique <- TRUE
        
        # Loop over unique images to check for match
        for (iu in seq_along(unique_files)) {
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
          magick::image_write(imgnu, paste0(self$folder_path,
                                            new_file_name))
          unique_files <- c(unique_files, new_file_name)
          unique_images <- c(unique_images, imgnu)
        } else {
          # If not unique, delete file, delete from list
          # dup_files <- c(dup_files, non_unique_files[1])
          print('found dup')
        }
        # Either way, the file gets deleted (either b/c dup or it was copied as unique)
        file.remove(paste0(self$folder_path,
                           non_unique_files[[1]]))
        non_unique_files <- non_unique_files[-1]
      }
      cat("Finished delete_dup_ocr_fails", "\n")
    },
    run_labeler = function() {
      
      cat("Starting label_ocr_fails", "\n")
      fnames <- list.files(self$folder_path)
      unlabeled_files <- fnames[grepl("unique", fnames) & !grepl("label", fnames)]
      for (i in seq_along(unlabeled_files)) {
        img <- magick::image_read(paste0(self$folder_path,
                                         unlabeled_files[i]))
        plot(1:10)
        plot(img)
        input <- readline(prompt = "Enter number shown on image: ")
        if (input == "delete") { # Some screenshots are errors
          file.remove(paste0(self$folder_path, unlabeled_files[i]))
        } else {
          if (self$char) {
            stopifnot(input != "")
            if (!is.null(self$char_list)) {
              stopifnot(input %in% self$char_list)
            }
            if (self$all_caps) {
              input <- toupper(input)
            }
          } else if (self$cts) {
            stopifnot(input != "", nchar(input) <= 3, !is.na(as.integer(input)))
          } else if (self$discrete) {
            stopifnot(input != "", nchar(input) <= 3, !is.na(as.integer(input)),
                      as.integer(input) %in% discrete_values)
          }
          # Change file name
          new_file_name <- paste0(substr(unlabeled_files[i], 1, 
                                         nchar(unlabeled_files[i]) - 4),
                                  "_label=",input,".png")
          magick::image_write(img,  paste0(self$folder_path,
                                           new_file_name))
          # Delete old file
          file.remove(paste0(self$folder_path,unlabeled_files[i]))
        }
      }
      cat("Finished label_ocr_fails", "\n")
    }
  )
)
if (F) { # test_int  ----
  roo <- read_ocr_object$new(name="test_int", cts=T, maxval=999)
  roo
  # screenshot::screenshot(file="./images/tmp_read_ocr_object_test.png")
  s1 <- magick::image_read("./images/tmp_read_ocr_object_test.png")
  s1
  magick::image_crop(s1, "50x20+35+555")
  # Check a number
  rooval <- roo$ocr(s1, crop_geometry = "50x20+35+555")
  # Give it some fails, make sure it has a dup to test run_unique
  rooval <- roo$ocr(s1, crop_geometry = "50x20+85+555")
  rooval <- roo$ocr(s1, crop_geometry = "50x20+185+555")
  rooval <- roo$ocr(s1, crop_geometry = "50x20+185+555")
  # Should delete dupes and add unique to name
  roo$run_unique()
  roo$run_labeler()
}

if (F) { # test_char  ----
  roo <- read_ocr_object$new(name="test_char", char=T, char_list = c("SP","RP","C"))
  roo
  # screenshot::screenshot(file="./images/tmp_read_ocr_object_test.png")
  s1 <- magick::image_read("./images/tmp_read_ocr_object_test.png")
  s1
  magick::image_crop(s1, "50x20+35+975")
  # Check C
  rooval <- roo$ocr(s1, crop_geometry = "50x20+35+975")
  # SP
  rooval <- roo$ocr(s1, crop_geometry = "50x20+85+975")
  # Give it some fails, make sure it has a dup to test run_unique
  rooval <- roo$ocr(s1, crop_geometry = "50x20+185+555")
  rooval <- roo$ocr(s1, crop_geometry = "50x20+185+555")
  # Should delete dupes and add unique to name
  roo$run_unique()
  roo$run_labeler()
}