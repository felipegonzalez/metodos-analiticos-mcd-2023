inv_logit <- \(x) exp(x)/(1 + exp(x))
set.seed(5216)
generar_datos <- function(n){
  ventas_1 <- rnorm(n, 1000, 400)
  prob <- inv_logit( -2 + ventas_1 / 500)
  promo <- rbinom(n, 1, prob)
  ventas_2 <- rnorm(n, 500 + 100 * promo + 0.9 * ventas_1, 400)
  status_oro <- 
    as.numeric((ventas_2 > ventas_1) | (promo == 1))
  tibble(promo = promo, ventas_2 = ventas_2, ventas_1 = ventas_1, 
         status_oro = status_oro)
}
datos_1 <- generar_datos(8000)
datos_analista_1 <- datos_1 |> select(promo, ventas_2)
datos_analista_2 <- datos_1 |> select(promo, ventas_1, ventas_2)
datos_analista_3 <- datos_1 |> select(promo, ventas_1, ventas_2, status_oro)

generar_datos_2 <- function(n){
  ventas_1 <- rnorm(n, 1000, 400)
  #prob <- inv_logit( -2 + ventas_1 / 500)
  #solo cambiamos esto
  promo <- rbinom(n, 1, 0.5)
  ventas_2 <- rnorm(n, 500 + 100 * promo + 0.9 * ventas_1, 400)
  status_oro <- 
    as.numeric((ventas_2 > ventas_1) | (promo == 1))
  tibble(promo = promo, ventas_2 = ventas_2, ventas_1 = ventas_1, 
         status_oro = status_oro)
}

datos_analista_4 <- generar_datos_2(2000)
  