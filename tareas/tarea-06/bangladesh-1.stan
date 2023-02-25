data {
  int<lower=0> N; //número de individuos
  int<lower=0> d; //número distritos
  array[N] int<lower=0> y; // uso de anticonceptivos
  array[N] int<lower=0> distrito; //distrito de cada observación
  array[N] int<lower=0> ur; // status de urbano = 1
  
}
parameters {
  real<lower=0> sigma_alpha;
  real<lower=0> sigma_beta;
  array[d] real alpha_std;
  array[d] real beta_std;
  real alpha_media;
  real beta_media;
}

transformed parameters {
  vector[N] prob_ac;
  array[d] real alpha;
  array[d] real beta;

  for(k in 1:d){
    alpha[k] = alpha_media + sigma_alpha * alpha_std[k];
    beta[k] = beta_media + sigma_beta * beta_std[k];
  }
  
  for(i in 1:N){
    // parámetros para cada distrito
    prob_ac[i] = inv_logit(alpha[distrito[i]] + beta[distrito[i]] * ur[i]);
  }

}

model {
  y ~ bernoulli(prob_ac);
  alpha_std ~ normal(0, 1);
  beta_std ~ normal(0, 1);
  alpha_media ~ normal(0, 1);
  beta_media ~ normal(0, 1);
  // media normal
  sigma_alpha ~ normal(0, 0.5);
  sigma_beta ~ normal(0, 0.5);
}

generated quantities {
  array[d, 2] real<lower=0, upper = 1> prop_uso;
  array[d] real prop_uso_dif;
  
  for(k in 1:d){
    // urbano
    prop_uso[k, 1] = inv_logit(alpha[k] + beta[k] * 1);
    // rural
    prop_uso[k, 2] = inv_logit(alpha[k] + beta[k] * 0);
    prop_uso_dif[k] = prop_uso[k, 1] - prop_uso[k, 2];
  }
  
  
}


