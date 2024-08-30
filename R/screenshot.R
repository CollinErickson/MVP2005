# screenshot to get screenshots

# screenshot::install_screenshot()

screenshot::screenshot(file = "./screenshottest.png")

Sys.sleep(2); screenshot::screenshot(file="./screenshottest2.png")


# tesseract to read text
library(tesseract)
eng <- tesseract("eng")
text <- tesseract::ocr("http://jeroen.github.io/images/testocr.png", engine = eng)
cat(text)

tesseract::ocr(image="./images/screenshottest3.png")
# kind of works, but too much text
# Need to crop to focus area

# Use magick to crop to small image
obj <- magick::image_read("./screenshottest2.png")
# Crop: width x height + offset left + offset down
obj2 <- magick::image_crop(obj,geometry="65x45+630+300",gravity="NorthWest",repage=TRUE)
obj2
# magick::image_write(obj2, "./screenshottest2_crop.png")
# Threshold to make it easier to read
obj3 <- magick::image_threshold(obj2)
magick::image_write(obj3, "./screenshottest2_crop.png")
# Now read thatk
tesseract::ocr(image="./screenshottest2_crop.png")
# Gives "SP.\n", need to clean text and check that matches options
# Also catchers have further offset left. Image has "C -", read as "Gs\n"
# 1B worked
# Could just save text for all options, and find closest
# Probably can just do SP/RP, the rest are fielders and can be treated equally