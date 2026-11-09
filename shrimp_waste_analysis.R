#READING OF THE DATASET
library(readxl)
# READING OF THE DATASET
library(readxl)

tserie <- read_excel("data/shrimp_export_data.xlsx")

# EXPLORATORY ANALYSIS
str(tserie) # Visualize structure
dim(tserie) # Number of rows and columns
nrow(tserie) # Number of observations
ncol(tserie) # Number of variables
names(tserie) # Names of variables

colSums(is.na(tserie)) # Number of missing values per variable
sum(is.na(tserie)) # Total number of missing data points

library(dplyr)
Q1 <- quantile(tserie$`Cant_exportada (kTn)`, 0.25, na.rm = TRUE) # Calculate quartiles
Q3 <- quantile(tserie$`Cant_exportada (kTn)`, 0.75, na.rm = TRUE)

IQR_val <- IQR(tserie$`Cant_exportada (kTn)`, na.rm = TRUE)

LI <- Q1 - 1.5 * IQR_val # Calculate limits
LS <- Q3 + 1.5 * IQR_val

atipicos <- tserie %>%   # Identify outliers
  filter(`Cant_exportada (kTn)` < LI | `Cant_exportada (kTn)` > LS)

print(atipicos)
nrow(atipicos)


library(ggplot2)
ggplot(tserie, aes(y = `Cant_exportada (kTn)`)) +
  geom_boxplot() +
  labs(
    title = "",
    y = "Export volume (kT)",
    x = "", 
  ) +
  theme(
    text = element_text(family = "serif"),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA))

#Identify inconsistencies

tserie %>% 
  count(Fecha) %>%
  filter(n > 1) # Identify duplicate dates

negativos <- tserie %>%
  filter(`Cant_exportada (kTn)` < 0) # Identify negative values

ceros <- tserie %>%
  filter(`Cant_exportada (kTn)` == 0) # Identify values equal to zero

inconsistencias <- tserie %>%
  filter(`Cant_exportada (kTn)` <= 0) # Identify negative values o equal to zero

print(negativos)
print(ceros)
print(inconsistencias)

summary(tserie)
sd(tserie$`Cant_exportada (kTn)`)


# REPRESENTATION OF EXPORTED KT
ggplot(tserie, aes(x = Fecha, y = `Cant_exportada (kTn)`)) +
  geom_line(color = 4,
            linewidth = 1,
            linetype = 1) +
  scale_x_date(
    date_breaks = "4 years",
    date_labels = "%Y"
  ) +
  labs(
    x = "Year",
    y = "Export volume (kT)",
    color = NULL
  ) +
  theme_classic() +
  theme(
    text = element_text(family = "serif"),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )


# REPRESENTATION OF SOLID WASTE VOLUME

library(tidyr)

datos_largos <- tserie %>%
  pivot_longer(
    cols = c(`Low-end scenario`,
             `High-end scenario`),
    names_to = "Variable",
    values_to = "Cantidad"
  )

ggplot(datos_largos, aes(x = Fecha, y = Cantidad,
                         color = Variable)) +
  geom_line(linewidth = 1,
            linetype = 1) +
  scale_x_date(
    date_breaks = "3 years",
    date_labels = "%Y"
  ) +
  labs(
    x = "Year",
    y = "Solid waste generated (kT)",
    color = NULL
  ) +
  theme_classic() +
  theme(
    text = element_text(family = "serif"),
    legend.position = "bottom",
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

# REPRESENTACIÓN OF WASTEWATER VOLUME
ggplot(tserie, aes(x = Fecha, y = `Agua Residual (gal)`)) +
  geom_line(color = 4,
            linewidth = 1,
            linetype = 1) +
  scale_x_date(
    date_breaks = "4 years",
    date_labels = "%Y"
  ) +
  labs(
    x = "Year",
    y = "Wastewater generated (gal)",
    color = NULL
  ) +
  theme_classic() +
  theme(
    text = element_text(family = "serif"),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

###############################################################
#                         TIME SERIES                         #
###############################################################

arima_high<-ts(tserie$`High-end scenario`, frequency=12, start=c(1994,1)) #BD en serie de tiempo escenario alto
arima_low<-ts(tserie$`Low-end scenario`, frequency=12, start=c(1994,1)) #BD en serie de tiempo escenario bajo

library(forecast)
library(tseries) 
library(stats)   

autoplot(arima_high,frequency=12,xlab="Year",ylab="",main="") #Time series plot

# Descomposition of the time series
arima_high_decomp <- decompose(arima_high)
arima_low_decomp  <- decompose(arima_low)

# Layout with two columns and three rows
layout(matrix(c(1, 4,
                2, 5,
                3, 6), nrow = 3, byrow = TRUE))

par(
  mar = c(2.5, 4.5, 2, 1),
  oma = c(1, 1, 3, 1),
  family = "serif",
  bg = "white",
  cex.main = 1.2,
  cex.lab = 1.2,
  cex.axis = 1.1
)

# Panel (a): high_scenary
plot(arima_high_decomp$trend,
     main = "Trend-cycle",
     col = "blue", ylab = "Value")

plot(arima_high_decomp$seasonal,
     main = "Seasonality component",
     col = "red", ylab = "Value")

plot(arima_high_decomp$random,
     main = "Irregular component",
     col = "darkgreen", ylab = "Value")

# Panel (b): low_scenary
plot(arima_low_decomp$trend,
     main = "Trend-cycle",
     col = "blue", ylab = "Value")

plot(arima_low_decomp$seasonal,
     main = "Seasonality component",
     col = "red", ylab = "Value")

plot(arima_low_decomp$random,
     main = "Irregular component",
     col = "darkgreen", ylab = "Value")

mtext("(a)", side = 3, outer = TRUE,
      at = 0.27, line = 1, cex = 0.7, font = 2)

mtext("(b)", side = 3, outer = TRUE,
      at = 0.73, line = 1, cex = 0.7, font = 2)

# Compare both series
all.equal(
  as.numeric(arima_high),
  as.numeric(arima_low)
)

summary(arima_high)
summary(arima_low)

sd(arima_high)
sd(arima_low)

head(cbind(
  Escenario_alto = as.numeric(arima_high),
  Escenario_bajo = as.numeric(arima_low)
), 10)

# Extract the seasonal components

tiempo <- time(arima_high_decomp$x)

tabla_mensual <- data.frame(
  Año = floor(tiempo),
  Mes = cycle(arima_high_decomp$x),
  Valor_observado = as.numeric(arima_high_decomp$x),
  Tendencia = as.numeric(arima_high_decomp$trend),
  Estacionalidad = as.numeric(arima_high_decomp$seasonal),
  Irregularidad = as.numeric(arima_high_decomp$random)
)

head(tabla_mensual, 12)

library(writexl)

write_xlsx(
  tabla_mensual,
  "tabla_mensual.xlsx"
)

resumen_anual <- tabla_mensual %>%
  group_by(Año) %>%
  summarise(
    Exportacion_promedio = mean(Valor_observado, na.rm = TRUE),
    Tendencia_promedio = mean(Tendencia, na.rm = TRUE),
    Estacionalidad_promedio = mean(Estacionalidad, na.rm = TRUE),
    Irregularidad_promedio = mean(Irregularidad, na.rm = TRUE),
    .groups = "drop"
  )

head(resumen_anual)

#Determination of data stationary
adf.test(arima_high)
adf.test(arima_low)

#AUTOARIMA FUNCTION
library(forecast)

modelo_arima_high <- auto.arima(
  arima_high,
  seasonal = FALSE,
  stepwise = FALSE,
  approximation = FALSE
)

summary(modelo_arima_high)

modelo_arima_high


modelo_arima_low <- auto.arima(
  arima_low,
  seasonal = FALSE,
  stepwise = FALSE,
  approximation = FALSE
)

summary(modelo_arima_low)

modelo_arima_low

#Checking the stationarity of the series

serie_diff <- diff(arima_high, differences = 2)

adf.test(serie_diff)


#Comparation of models
cor(arima_low, arima_high) 

modelo_relacion <- lm(arima_high ~ arima_low) #Lineal relationship between scenarios

summary(modelo_relacion)

coef(modelo_relacion) # Slop and intercept

var(residuals(modelo_arima_high)) /
  var(residuals(modelo_arima_low))  # Relatioship between residual variances

#WASTE GENERATION PROJECTION

library(zoo)

# Prediction horizont: 120 months
h <- 120

# Forecast
forecast_low <- forecast(
  modelo_arima_low,
  h = h,
  level = c(80, 95)
)

forecast_high <- forecast(
  modelo_arima_high,
  h = h,
  level = c(80, 95)
)

tabla_forecast <- data.frame(
  Fecha = format(
    as.Date(as.yearmon(time(forecast_low$mean))),
    "%Y-%m"
  ),
  Bajo = as.numeric(forecast_low$mean),
  Bajo_LI95 = as.numeric(forecast_low$lower[, "95%"]),
  Bajo_LS95 = as.numeric(forecast_low$upper[, "95%"]),
  Alto = as.numeric(forecast_high$mean),
  Alto_LI95 = as.numeric(forecast_high$lower[, "95%"]),
  Alto_LS95 = as.numeric(forecast_high$upper[, "95%"])
)

head(tabla_forecast)

write_xlsx(
  tabla_forecast,
  "Resultados_forecast.xlsx"
)

# Historic data
historico <- data.frame(
  Fecha = as.Date(as.yearmon(time(arima_low))),
  Bajo = as.numeric(arima_low),
  Alto = as.numeric(arima_high)
)

# Projected data
proyectado <- data.frame(
  Fecha = as.Date(as.yearmon(time(forecast_low$mean))),
  Bajo = as.numeric(forecast_low$mean),
  Bajo_LI = as.numeric(forecast_low$lower[, "95%"]),
  Bajo_LS = as.numeric(forecast_low$upper[, "95%"]),
  Alto = as.numeric(forecast_high$mean),
  Alto_LI = as.numeric(forecast_high$lower[, "95%"]),
  Alto_LS = as.numeric(forecast_high$upper[, "95%"])
)

# Graphic
ggplot() +
  
  geom_ribbon(
    data = proyectado,
    aes(x = Fecha, ymin = Bajo_LI, ymax = Bajo_LS,
        fill = "Low production scenario"),
    alpha = 0.15
  ) +
  
  geom_ribbon(
    data = proyectado,
    aes(x = Fecha, ymin = Alto_LI, ymax = Alto_LS,
        fill = "High production scenario"),
    alpha = 0.15
  ) +
  
  # Historic series
  geom_line(
    data = historico,
    aes(x = Fecha, y = Bajo, color = "Low production scenario"),
    linewidth = 0.7
  ) +
  
  geom_line(
    data = historico,
    aes(x = Fecha, y = Alto, color = "High production scenario"),
    linewidth = 0.7
  ) +
  
  # Projections
  geom_line(
    data = proyectado,
    aes(x = Fecha, y = Bajo, color = "Low production scenario"),
    linewidth = 0.9,
    linetype = "dashed"
  ) +
  
  geom_line(
    data = proyectado,
    aes(x = Fecha, y = Alto, color = "High production scenario"),
    linewidth = 0.9,
    linetype = "dashed"
  ) +
  
  # Separation between historical data and estimates
  geom_vline(
    xintercept = min(proyectado$Fecha),
    linetype = "dotted",
    linewidth = 0.7
  ) +
  
  scale_x_date(
    date_breaks = "4 years",
    date_labels = "%Y",
    expand = expansion(mult = c(0.01, 0.02))
  ) +
  
  labs(
    title = NULL,
    x = "Year",
    y = "Estimated shrimp waste generation (kT)",
    color = NULL,
    fill = NULL,
    caption = "Dashed lines represent forecasts; shaded areas represent 95% prediction intervals."
  ) +
  theme(
    text = element_text(family = "serif", size = 12),
    axis.text.x = element_text(family = "serif", size = 11, color = "black"),
    axis.text.y = element_text(family = "serif", size = 9, color = "black"),
    axis.title.x = element_text(family = "serif", size = 12, color = "black"),
    axis.title.y = element_text(family = "serif", size = 9, color = "black"),
    axis.line = element_line(color = "black", linewidth = 0.5),
    axis.ticks = element_line(color = "black"),
    legend.text = element_text(family = "serif", size = 11),
    legend.title = element_text(family = "serif", size = 11),
    plot.caption = element_text(family = "serif", size = 9),
    legend.position = "bottom",
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA)
  )