
# Curvas de distribución --------------------------------------------------

años <- rep(1965:2022,12)
meses <- mes <- sort(sprintf("%02d",rep(1:12,58)))
fechas <- sort(paste0(años,meses))

urls <- list()

for (i in fechas) {
  urls[i] <- paste0("https://www.senamhi.gob.pe/mapas/mapa-estaciones-2/_dato_esta_tipo02.php?estaciones=116052&CBOFiltro=",i,"&t_e=M&estado=DIFERIDO&cod_old=158309&cate_esta=CO&alt=4245")
}

data <- list()
for (i in 1:length(urls)) {
  data[i]<-html_table(
    html_nodes(
      read_html(
        as.character(urls[i])
      ), "table"
    )[2],
    header = TRUE,na.strings = c("S/D","T")
  )
}


for (i in 1:length(data)) {
  data[[i]] <- data[[i]][-1,]
  
}

for (i in 1:length(data)) {
  names(data[[i]]) <- c("fecha","tmax","tmin","hum","pp")
  
}


df1 <- Reduce(function(...) merge(..., all=TRUE), data)

df1$fecha <- as.Date(df1$fecha,format = "%Y-%m-%d")
dfx <- df1 %>% mutate_if(is.character,as.numeric)

dfn <- dfx

dfx$pp[dfx$pp>0,] <- NA

dfn$pp <- ifelse(dfn$pp < 0, NA, dfn$pp)
openxlsx::write.xlsx(dfn,"pampa_umalzo_1965-2022.xlsx")
