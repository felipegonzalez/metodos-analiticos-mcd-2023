
simular_datos <- function(n){
  seguro <- rbinom(n, 1, 0.2)
  tipo_casa <- rbinom(n, 1, 0.5)
  p_detector <- ifelse(seguro == 1, 0.95, 0.1 * (1-tipo_casa) + 0.8 * tipo_casa)
  detector <- rbinom(n, 1, p_detector)
  # intensidad de incendio
  incendio <- rexp(n, 1 * tipo_casa + 0.9 * (1 - tipo_casa))
  alarma_activa <- ifelse(detector == 1, 1/(1 + exp(-3 * incendio)), 0.0)
  # pérdidas gamma
  media_perdidas <-  (100 * incendio) * (2500 - 1000 * tipo_casa - 500 * alarma_activa)
  var_perdidas <- media_perdidas * 2
  a <- media_perdidas^2 / var_perdidas
  b <- var_perdidas / media_perdidas
  perdidas <- rgamma(n, a, b)
  # salida
  tibble(seguro, tipo_casa, detector, incendio, alarma_activa, perdidas)
}
