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
  int<lower=0> s;
  real<lower=0> h;
  real<lower=0> w;

    // simulamos hombre o mujer
    s = bernoulli_rng(0.5);
    // simular estatura dado el sexo
    real m_h = 15 * s + 160;
    h = normal_rng(m_h, 12);
    // simular peso dado estatura y sexo
    real m_w = -50 + 5 * s + 0.7 * h;
    w = normal_rng(m_w, 10);
}
