data {
  int<lower=0> N;
  int<lower=0> n;
  int<lower=0> kit_pos;
  int<lower=0> n_kit_pos;
  int<lower=0> kit_neg;
  int<lower=0> n_kit_neg;
}

parameters {
  real<lower=0, upper=1> p; //seroprevalencia
  real<lower=0, upper=1> sens; //sensibilidad
  real<lower=0, upper=1> esp; //especificidad
}

transformed parameters {
  real<lower=0, upper=1> prob_pos;

  prob_pos = p * sens + (1 - p) * (1 - esp);

}
model {
  // verosimilitud
  n ~ binomial(N, prob_pos);
  // info de kit
  kit_pos ~ binomial(n_kit_pos, sens);
  kit_neg ~ binomial(n_kit_neg, esp);
  // iniciales,
  p ~ beta(1.0, 10.0);
  sens ~ beta(2.0, 1.0);
  esp ~ beta(2.0, 1.0);
}
