
data {
  int<lower=0> N;
  array[N] real y_obs;
  vector[N] intensidad;
  vector[N] t;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real alpha;
  real alpha_0;
  real beta;
  array[2] real<lower=0> sigma;
}

transformed parameters{
  array[N] real media;
  array[N] real u_obs;

  for(i in 1:N){
    media[i] = alpha_0 + alpha * intensidad[i] + beta * t[i];
    u_obs[i] = y_obs[i] - media[i];
  }

}

model {
  for(i in 1:N){
    if(t[i] == 1){
      y_obs[i] ~ normal(media[i], sigma[1]);
    }
    else {
      y_obs[i] ~ normal(media[i], sigma[2]);
    }
  }
  alpha_0 ~ normal(0, 1);
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  sigma ~ normal(0, 1);
}

generated quantities{
  array[N] real y_mis;
  array[N] real efecto_trata_ind;
  real efecto_trata;

  for(i in 1:N){
    // simular contrafactual
    if(t[i] == 1){
      y_mis[i] = alpha_0 + alpha * intensidad[i] + beta * 0 +
        u_obs[i] * sigma[2] / sigma[1];
      efecto_trata_ind[i] = y_obs[i]  - y_mis[i];
    } else {
      y_mis[i] = alpha_0 + alpha * intensidad[i] + beta * 1 +
        u_obs[i] * sigma[1] / sigma[2];
      efecto_trata_ind[i] = y_mis[i] - y_obs[i];
    }
  }
  efecto_trata = mean(efecto_trata_ind);
}

