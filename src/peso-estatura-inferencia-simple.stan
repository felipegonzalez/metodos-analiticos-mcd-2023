data {
  int<lower=0> N;
  vector[N]  s;
  vector[N]  w;

}

transformed data {
  vector[N] h_c;
  int M;
  // simulaciones
  M = 1000;
  // centrar

}

parameters {
  real gamma_0;
  real gamma_1;
  real gamma_2;
  real<lower=0> sigma_w;
}



transformed parameters {
  vector[N] m_w;

  m_w = gamma_0 + gamma_1 * s;

}

model {

  // modelo para peso
  w ~ normal(m_w, sigma_w);
  gamma_0 ~ normal(50, 30);
  gamma_1 ~ normal(10, 20);
  gamma_2 ~ normal(0, 2);
  sigma_w ~ normal(0, 5);


}
generated quantities {
  real w_mean_male;
  real w_mean_female;
  real dif_male;
  array[M] real w_sim_male;
  array[M] real w_sim_female;

  // simular hombres
  real do_s = 1;
  for(i in 1:M){
    real w_sim_media = gamma_0 + gamma_1 * do_s;
    w_sim_male[i] = normal_rng(w_sim_media, sigma_w);
  }

  do_s = 0;
  for(i in 1:M){
    real w_sim_media = gamma_0 + gamma_1 * do_s;
    w_sim_female[i] = normal_rng(w_sim_media, sigma_w);
  }

  w_mean_male = mean(w_sim_male);
  w_mean_female = mean(w_sim_female);
  dif_male = w_mean_male - w_mean_female;

}
