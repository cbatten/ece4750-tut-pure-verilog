#=========================================================================
# ex-sorter Subpackage
#=========================================================================

ex_sorter_deps = vc

ex_sorter_srcs = \
  ex-sorter-SorterFlat.v \
  ex-sorter-MinMaxUnit.v \
  ex-sorter-SorterStruct.v \
  ex-sorter-test-harness.v \
  ex-sorter-sim-harness.v \

ex_sorter_test_srcs = \
  ex-sorter-SorterFlat.t.v \
  ex-sorter-SorterStruct.t.v \

ex_sorter_sim_srcs = \
  ex-sorter-sim-flat.v \
  ex-sorter-sim-struct.v \

ex_sorter_pyv_srcs = \
  ex-sorter-gen-input_random.py.v \
  ex-sorter-gen-input_sorted-fwd.py.v \
  ex-sorter-gen-input_sorted-rev.py.v \

#-------------------------------------------------------------------------
# Evaluation
#-------------------------------------------------------------------------

# List of implementations and inputs to evaluate

ex_sorter_eval_impls  = flat struct
ex_sorter_eval_inputs = random sorted-fwd sorted-rev

# Template used to create rules for each impl/input pair

define ex_sorter_eval_template

ex_sorter_eval_outs += ex-sorter-sim-$(1)-$(2).out

ex-sorter-sim-$(1)-$(2).out : ex-sorter-sim-$(1)
	./$$< +input=$(2) +stats | tee $$@

endef

# Call template for each impl/input pair

$(foreach impl,$(ex_sorter_eval_impls), \
  $(foreach dataset,$(ex_sorter_eval_inputs), \
    $(eval $(call ex_sorter_eval_template,$(impl),$(dataset)))))

# Grep all evaluation results

ex-sorter-eval : $(ex_sorter_eval_outs)
	@echo ""
	@grep avg_num_cycles_per_sort $^ | column -s ":=" -t
	@echo ""

