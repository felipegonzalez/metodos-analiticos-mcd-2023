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
  real efecto_nat_dir;
  real efecto_nat_ind;
  real efecto_total;
  real prop_mediador;
  {
    array[2000] real admit_sim_2;
    array[2000] real admit_sim_1;
    // calcular efecto natural directo
    array[2000] int k;

    for(j in 1:2000){
      // extraer una elección de departamento de hombres:
      k[j] = categorical_logit_rng(beta[1]);
      // extraer admisión al departamento si es mujer
      admit_sim_2[j] = bernoulli_logit_rng(alpha[2, k[j]]);
      // extraer admisión al departamento si es hombre
      admit_sim_1[j] = bernoulli_logit_rng(alpha[1, k[j]]);
    }
    efecto_nat_dir = mean(admit_sim_2) - mean(admit_sim_1);
  }
  {
    array[2000] real admit_sim_2;
    array[2000] real admit_sim_1;
    array[2000] int k_1;
    array[2000] int k_2;
    // calcular efecto natural indirecto
    //array[n_d] real dif;
    //array[n_d] real mean_resp;
    //for(k in 1:n_d){
    //  dif[k] = inv_logit(beta[2, k]) - inv_logit(beta[1, k]);
    for(j in 1:2000){

      // escoger depto bajo tratamiento
      k_1[j] = categorical_logit_rng(beta[2]);
      // simular admisión sin tratamiento
      admit_sim_2[j] = bernoulli_logit_rng(alpha[1, k_1[j]]);
      // escoger depto sin tratamiento
      k_2[j] = categorical_logit_rng(beta[1]);
      // simular admisión con tratamiento
      admit_sim_1[j] = bernoulli_logit_rng(alpha[1, k_2[j]]);

     }
    //  mean_resp[k] = mean(admit_sim_2);
      efecto_nat_ind = mean(admit_sim_2) - mean(admit_sim_1);
    }

    //efecto_nat_ind = sum(to_vector(mean_resp) .* to_vector(dif));
    {
    array[2000] real admit_sim_2;
    array[2000] real admit_sim_1;
    array[2000] int k_1;
    array[2000] int k_2;
    // calcular efecto total
    for(j in 1:2000){
      // extraer una elección de departamento para mujeres
      k_1[j] = categorical_logit_rng(beta[2]);
      admit_sim_2[j] = bernoulli_logit_rng(alpha[2, k_1[j]]);
      // extraer una elección de departamento para hombres
      k_2[j] = categorical_logit_rng(beta[1]);
      admit_sim_1[j] = bernoulli_logit_rng(alpha[1, k_2[j]]);
    }
    efecto_total = mean(admit_sim_2) - mean(admit_sim_1);
  }
}


