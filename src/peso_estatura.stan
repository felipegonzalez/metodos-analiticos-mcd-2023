data {
  int<lower=0> N;
}

parameters {
}

transformed parameters {
}

model {

}
generated quantities {
  real<lower=0> h;
  real<lower=0> w;

    h = normal_rng(170, 12);
    real m_w = -50 + 0.7 * h;
    w = normal_rng(m_w, 10);
}
