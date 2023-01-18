data {
  int<lower=0> N;
  int<lower=0> n;
}

parameters {
  real<lower=0, upper=1> p; //seroprevalencia

}

transformed parameters {
  real<lower=0, upper=1> prob_pos;

  prob_pos = p;

}
model {
  // modelo de número de positivos
  n ~ binomial(N, prob_pos);
  p ~ beta(1.0, 10.0);
}
