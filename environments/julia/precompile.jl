using Catlab
using CombinatorialSpaces
using CombinatorialSpaces.ExteriorCalculus
using CombinatorialSpaces.DiscreteExteriorCalculus: ∧
using Decapodes

Poise = @decapode begin
  P::Form0
  q::Form1
  (R, μ̃ )::Constant

  # Laplacian of q for the viscous effect
  Δq == Δ(q)
  # Gradient of P for the pressure driving force
  ∇P == d(P)

  # Definition of the time derivative of q
  ∂ₜ(q) == q̇

  # The core equation
  q̇ == μ̃  * ∂q(Δq) + ∇P + R * q
end

Poise = expand_operators(Poise)
infer_types!(Poise, op1_inf_rules_1D, op2_inf_rules_1D)
resolve_overloads!(Poise, op1_res_rules_1D, op2_res_rules_1D)