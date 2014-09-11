#=========================================================================
# ex-gcd Subpackage
#=========================================================================

ex_gcd_deps = vc

ex_gcd_srcs = \
  ex-gcd-GcdUnitFL.v \
  ex-gcd-GcdUnit.v \
  ex-gcd-test-harness.v \

ex_gcd_test_srcs = \
  ex-gcd-GcdUnitFL.t.v \
  ex-gcd-GcdUnit.t.v \

ex_gcd_sim_srcs = \
  ex-gcd-sim.v \

ex_gcd_pyv_srcs = \
  ex-gcd-gen-input_random-a.py.v \
  ex-gcd-gen-input_random-b.py.v \

#-------------------------------------------------------------------------
# Evaluation
#-------------------------------------------------------------------------

# List of inputs to evaluate

ex_gcd_eval_inputs = random-a random-b

# Template used to create rules for each input

define ex_gcd_eval_template

ex_gcd_eval_outs += ex-gcd-sim-$(1).out

ex-gcd-sim-$(1).out : ex-gcd-sim
	./$$< +input=$(1) +stats | tee $$@

endef

# Call template for each input

$(foreach dataset,$(ex_gcd_eval_inputs), \
  $(eval $(call ex_gcd_eval_template,$(dataset))))

# Grep all evaluation results

ex-gcd-eval : $(ex_gcd_eval_outs)
	@echo ""
	@grep avg_num_cycles_per_gcd $^ | column -s ":=" -t
	@echo ""

