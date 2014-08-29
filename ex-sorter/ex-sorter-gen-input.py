#=========================================================================
# ex-sorter-gen-input
#=========================================================================
# Script to generate inputs for sorter unit.

import random
import sys

# Use seed for reproducability

random.seed(0xdeadbeef)

#-------------------------------------------------------------------------
# Helper Functions
#-------------------------------------------------------------------------

def mkstr( data ):
  return "8'h{:0>2x}, 8'h{:0>2x}, 8'h{:0>2x}, 8'h{:0>2x}" \
    .format( data[0], data[1], data[2], data[3] )

def print_dataset( in_, out ):

  size    = len(in_) # number of messages in dataset
  latency = 3        # latency of the sorter unit

  # Print number of inputs

  print "num_inputs =", size, ";"

  # Print data set

  for i in xrange(size+latency):

    # Handle initial few cycles while waiting for pipeline to fill

    if i < latency:
      print "t1( 1,", mkstr(in_[i]), ", 0, 8'h??, 8'h??, 8'h??, 8'h?? );"

    # Handle final few cycles while waiting for pipeline to drain

    elif i >= size:
      print "t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx , 1,", mkstr(out[i-3]), ");"

    # Handle main cycles when pipeline is full and not draining

    else:
      print "t1( 1,", mkstr(in_[i]), ", 1,", mkstr(out[i-3]), ");"

#-------------------------------------------------------------------------
# Random dataset
#-------------------------------------------------------------------------

if sys.argv[1] == "random":

  in_ = []
  out = []

  for i in xrange(100):

    data = [ random.randint(0,0xff) for i in xrange(4) ]
    in_.append( data         )
    out.append( sorted(data) )

  print_dataset( in_, out )

#-------------------------------------------------------------------------
# Sorted forward dataset
#-------------------------------------------------------------------------

elif sys.argv[1] == "sorted-fwd":

  in_ = []
  out = []

  for i in xrange(100):

    data = [ random.randint(0,0xff) for i in xrange(4) ]
    in_.append( sorted(data) )
    out.append( sorted(data) )

  print_dataset( in_, out )

#-------------------------------------------------------------------------
# Sorted reverse dataset
#-------------------------------------------------------------------------

elif sys.argv[1] == "sorted-rev":

  in_ = []
  out = []

  for i in xrange(100):

    data = [ random.randint(0,0xff) for i in xrange(4) ]
    in_.append( sorted(data)[::-1] )
    out.append( sorted(data)       )

  print_dataset( in_, out )

#-------------------------------------------------------------------------
# Unrecognied dataset
#-------------------------------------------------------------------------

else:
  sys.stderr.write("unrecognized command line argument\n")
  exit(1)

exit(0)

