data {
  int<lower=0> N;
  int<lower=0> n_d;
  array[N] int admit;
  array[N] int gender;
  array[N] int dept;
}
transformed data {
  array[N] int gender_ind;

  for(i in 1:N){
    gender_ind[i] = 0;
    if(gender[i] == 2) {
      gender_ind[i] = 1;
    }
  }
}

parameters {
  real beta_0;
  array[2] vector[n_d] beta;
  matrix[2, n_d] alpha;
}


model {
  for(i in 1:N){
    admit[i] ~ bernoulli_logit(alpha[gender[i], dept[i]]);
    dept[i] ~ categorical_logit(beta[gender[i]]);
  }
  gender_ind ~ bernoulli_logit(beta_0);
  beta_0 ~ normal(0, 0.5);
  for(i in 1:2){
    beta[i] ~ normal(0, 1);
    alpha[i] ~ normal(0, 1);
  }
}

generated quantities{
  real contraste_m_h;
  real admit_prob_mujer;
  real admit_prob_hombre;

  {
    int gender_do = 2;
    array[1000] real admit_prob_mujer_ind;
    for(j in 1:1000){
      int dept_sim = categorical_logit_rng(beta[gender_do]);
      admit_prob_mujer_ind[j] = bernoulli_logit_rng(alpha[gender_do, dept_sim]);
    }
    admit_prob_mujer = mean(admit_prob_mujer_ind);
  }
  {
    int gender_do = 1;
    array[1000] real admit_prob_hombre_ind;
    for(j in 1:1000){
      int dept_sim = categorical_logit_rng(beta[gender_do]);
      admit_prob_hombre_ind[j] = bernoulli_logit_rng(alpha[gender_do, dept_sim]);
    }
    admit_prob_hombre = mean(admit_prob_hombre_ind);
  }

  contraste_m_h = admit_prob_mujer - admit_prob_hombre;

}
