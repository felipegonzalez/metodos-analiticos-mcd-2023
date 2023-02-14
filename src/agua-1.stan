data {
  int<lower=0> N;
  array[N] real t_maxima;
  array[N] real unidades;
  array[N] real desabasto_agua;
  array[11] real desabasto_do;
}

transformed data {
    array[N] real logit_desabasto_agua;

    for(i in 1:N){
      logit_desabasto_agua[i] = logit(desabasto_agua[i]);
    }
}
parameters {
  real alpha;
  real beta;
  real alpha_u;
  real beta_t;
  real beta_d;
  real mu_t;
  real<lower=0> sigma_d;
  real<lower=0> sigma_t;
  real<lower=0> sigma_unidades;
}

transformed parameters {
  array[N] real media_unidades;
  array[N] real desabasto_agua_c;

  for(i in 1:N){
    desabasto_agua_c[i] = alpha + beta*(t_maxima[i] - 28);
    media_unidades[i] = alpha_u + beta_t * (t_maxima[i] - 28) + beta_d * desabasto_agua[i];
  }



}
model {
  // modelo de número de temperatura
  t_maxima ~ normal(mu_t + 28, sigma_t);
  sigma_t ~ normal(0, 1);
  mu_t ~ normal(0, 3);
  // modelo de desabasto
  logit_desabasto_agua ~ normal(desabasto_agua_c, sigma_d);
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  sigma_d ~ normal(0, 1);
  // modelo de ventas
  for(i in 1:N){
      unidades[i] ~ normal(10000 * media_unidades[i],
        10000 * sigma_unidades);
  }
  sigma_unidades ~ normal(0, 0.5);
  // iniciales para cantidades no medidas
  alpha_u ~ normal(0, 1);
  beta_t ~ normal(0, 1);
  beta_d ~ normal(0, 1);
}

generated quantities{
  array[11] real unidades_sim;

  for(i in 1:11){
    array[2000] real unidades_sim_1;
    for(k in 1:2000){
      // Extraemos una temperatura
      real t_sim = normal_rng(mu_t + 28, sigma_t);
      // calculamos la media dadas  temperatura y desabasto
      real media_unidades_sim = alpha_u +
      beta_t * (t_sim - 28) + beta_d * desabasto_do[i];
      // simulamos unidades
      unidades_sim_1[k] = normal_rng(10000 * media_unidades_sim,
        10000 * sigma_unidades);
    }
   // promediamos si nos interesa el valor esperado de unidades
    unidades_sim[i] = mean(unidades_sim_1);
  }
}
