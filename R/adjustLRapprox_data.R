# See how long to hold down buttons to move a specific amount.
# This data is collected using long_press.ahk.
# The first column is the hold duration in that file.
# The second value is how much an attribute changed.
# Need PCSX2 running at 2x.
# This LM is used to create adjustLMapprox in R/helpers.R
tmp <- matrix(c(2000, 44.5,
  1000, 20,
  1500, 32,
  500, 8.5,
  750, 14.5,
  1750, 38.5,
  1250, 26.5,
  2250, 50,
  2350, 53,
  1125, 23.5,
  1375, 29,
  1625, 35.25,
  1775, 39,
  875, 17.25
  #
  ), ncol=2, byrow = T)
tmp
plot(tmp[,1], tmp[,2])
tmpmod <- lm(tmp[, 2] ~ tmp[, 1])
tmpmod
summary(tmpmod)
abline(a=coef(tmpmod)[1], b=coef(tmpmod)[2], col=2)
plot(tmp[,2], tmp[,1])
coef(tmpmod)
curve((x - coef(tmpmod)[1]) / coef(tmpmod)[2], 10, 50, col=2, add=T)
(50 --3.66572375)/  0.02399106
