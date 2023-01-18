data {
  int<lower=0> N;
  vector[N]  s;
  vector[N]  h;
  vector[N]  a;
  vector[N]  w;

}

transformed data {
  vector[N] a_c;
  vector[N] h_c;
  real media_a;
  real media_h;
  int M;
  M = 10000;
  media_a = mean(a);
  media_h = mean(h);
  a_c = a - mean(a);
  h_c = h - mean(h);
}

parameters {
  real alpha;
  real alpha_s;
  real alpha_a;
  real gamma;
  real gamma_s;
  real gamma_a;
  real gamma_h;
  real<lower=0> sigma_h;
  real<lower=0> sigma_w;
}



transformed parameters {
  vector[N] m_h;
  vector[N] m_w;

  m_h = alpha + alpha_s * s + alpha_a * a_c;
  m_w = gamma + gamma_s * s + gamma_a * a_c + gamma_h * h_c;

}

model {
  // modelo para estatura
  h ~ normal(m_h, sigma_h);
  alpha ~ normal(150, 30);
  alpha_s ~ normal(10, 20);
  alpha_a ~ normal(0, 1);
  sigma_h ~ normal(0, 30);

  // modelo para peso
  w ~ normal(m_w, sigma_w);
  gamma ~ normal(50, 30);
  gamma_s ~ normal(10, 20);
  gamma_a ~ normal(0, 1);
  gamma_h ~ normal(0, 2);
  sigma_w ~ normal(0, 5);


}
generated quantities {
  real w_mean_male;
  real w_mean_female;
  real effect_male;
  array[M] real w_sim_male;
  array[M] real w_sim_female;

  real do_s = 1;
  real do_a = 35;
  for(i in 1:M){
    real h_sim_media = alpha + alpha_s * do_s + alpha_a * (35 - media_a);
    real h_sim = normal_rng(h_sim_media, sigma_h);
  //real error_h = h_sim - h_sim_media;
    real w_sim_media = gamma + gamma_s * do_s + gamma_a * (35-media_a) + gamma_h * (h_sim - media_h);
    w_sim_male[i] = normal_rng(w_sim_media, sigma_w);
  }
  //real error_w = w_sim_male - w_sim_media;

  do_s = 0;
  for(i in 1:M){
    real h_sim_media = alpha + alpha_s * do_s + alpha_a * (35 - media_a);
    real h_sim = normal_rng(h_sim_media, sigma_h);
  //real error_h = h_sim - h_sim_media;
    real w_sim_media = gamma + gamma_s * do_s + gamma_a * (35-media_a) + gamma_h * (h_sim - media_h);
    w_sim_female[i] = normal_rng(w_sim_media, sigma_w);
  }

  w_mean_male = mean(w_sim_male);
  w_mean_female = mean(w_sim_female);
  effect_male = w_mean_male - w_mean_female;

}
