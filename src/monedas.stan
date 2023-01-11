data {
  int<lower=0> s_1;
  int<lower=0> s_2;
}
parameters {
  real<lower=0, upper = 1> x;
}
model {
  x ~ uniform(0, 1);
  s_1 ~ binomial(5, x);
  s_2 ~ binomial(5, x);
}
