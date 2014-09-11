#=========================================================================
# vc Subpackage
#=========================================================================

vc_deps =

vc_srcs = \
  vc-preprocessor.v \
  vc-arbiters.v \
  vc-arithmetic.v \
  vc-assert.v \
  vc-Counter.v \
  vc-crossbars.v \
  vc-DropUnit.v \
  vc-mem-msgs.v \
  vc-muxes.v \
  vc-net-msgs.v \
  vc-PipeCtrl.v \
  vc-queues.v \
  vc-RandomNumGen.v \
  vc-regfiles.v \
  vc-regs.v \
  vc-srams.v \
  vc-TestDelay.v \
  vc-TestMem_1port.v \
  vc-TestMem_2ports.v \
  vc-TestNet.v \
  vc-TestRandDelayMem_1port.v \
  vc-TestRandDelayMem_2ports.v \
  vc-TestRandDelaySink.v \
  vc-TestRandDelaySource.v \
  vc-TestRandDelayUnorderedSink.v \
  vc-TestRandDelay.v \
  vc-TestSink.v \
  vc-TestSource.v \
  vc-TestUnorderedSink.v \
  vc-test.v \
  vc-trace.v \

vc_test_srcs = \
  vc-arbiters.t.v \
  vc-arithmetic.t.v \
  vc-Counter.t.v \
  vc-crossbars.t.v \
  vc-DropUnit.t.v \
  vc-mem-msgs.t.v \
  vc-muxes.t.v \
  vc-net-msgs.t.v \
  vc-PipeCtrl.t.v \
  vc-queues.t.v \
  vc-RandomNumGen.t.v \
  vc-regfiles.t.v \
  vc-regs.t.v \
  vc-srams.t.v \
  vc-TestDelay.t.v \
  vc-TestMem_1port.t.v \
  vc-TestMem_2ports.t.v \
  vc-TestNet.t.v \
  vc-TestRandDelayMem_1port.t.v \
  vc-TestRandDelayMem_2ports.t.v \
  vc-TestRandDelaySink.t.v \
  vc-TestRandDelaySource.t.v \
  vc-TestRandDelay.t.v \
  vc-TestRandDelayUnorderedSink.t.v \
  vc-TestSink.t.v \
  vc-TestUnorderedSink.t.v \

vc_sim_srcs = \

vc_pyv_srcs = \
  vc-test-src-sink-gen-input_ordered.py.v \
  vc-test-src-sink-gen-input_unordered.py.v \
  vc-test-net-gen-input.py.v \

