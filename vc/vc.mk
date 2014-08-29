#=========================================================================
# vc Subpackage
#=========================================================================

vc_deps =

vc_srcs = \
  vc-preprocessor.v \
  vc-test.v \
  vc-trace.v \
  vc-assert.v \
  vc-arithmetic.v \
  vc-muxes.v \
  vc-crossbars.v \
  vc-regs.v \
  vc-regfiles.v \
  vc-srams.v \
  vc-arbiters.v \
  vc-Counter.v \
  vc-RandomNumGen.v \
  vc-TestSource.v \
  vc-TestSink.v \
  vc-TestRandDelay.v \
  vc-TestRandDelaySource.v \
  vc-TestRandDelaySink.v \
  vc-queues.v \

#  vc-TestDelay.v \
#  vc-TestUnorderedSink.v \
#  vc-TestRandDelayUnorderedSink.v \
#  vc-PipeCtrl.v \
#  vc-mem-msgs.v \
#  vc-net-msgs.v \
#  vc-TestMem_1port.v \
#  vc-TestMem_2ports.v \
#  vc-TestRandDelayMem_1port.v \
#  vc-TestRandDelayMem_2ports.v \
#  vc-DropUnit.v \
#  vc-TestNet.v \
#  vc-RandomNumGen.v \

vc_test_srcs = \
  vc-arithmetic.t.v \
  vc-muxes.t.v \
  vc-crossbars.t.v \
  vc-regs.t.v \
  vc-regfiles.t.v \
  vc-srams.t.v \
  vc-arbiters.t.v \
  vc-Counter.t.v \
  vc-TestSink.t.v \
  vc-TestRandDelay.t.v \
  vc-TestRandDelaySource.t.v \
  vc-TestRandDelaySink.t.v \
  vc-queues.t.v \

#  vc-TestDelay.t.v \
#  vc-TestUnorderedSink.t.v \
#  vc-TestRandDelayUnorderedSink.t.v \
#  vc-PipeCtrl.t.v \
#  vc-mem-msgs.t.v \
#  vc-net-msgs.t.v \
#  vc-TestMem_1port.t.v \
#  vc-TestMem_2ports.t.v \
#  vc-TestRandDelayMem_1port.t.v \
#  vc-TestRandDelayMem_2ports.t.v \
#  vc-DropUnit.t.v \
#  vc-TestNet.t.v \
#  vc-RandomNumGen.t.v \

vc_sim_srcs = \

vc_pyv_srcs = \
  vc-test-src-sink-gen-input_ordered.py.v \

#  vc-test-src-sink-gen-input_unordered.py.v \
#  vc-test-net-gen-input.py.v \

