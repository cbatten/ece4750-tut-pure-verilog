#=========================================================================
# ex-gcd-gen-input
#=========================================================================
# Script to generate inputs for GCD unit.

import fractions
import random
import sys

# Use seed for reproducability

random.seed(0xdeadbeef)

#-------------------------------------------------------------------------
# Helper Functions
#-------------------------------------------------------------------------

def print_dataset( in0, in1, out ):

  for i in xrange(len(in0)):

    print "init( {:0>2}, 16'h{:0>4x}, 16'h{:0>4x}, 16'h{:0>4x} );" \
      .format( i, in0[i], in1[i], out[i] )

#-------------------------------------------------------------------------
# Random dataset
#-------------------------------------------------------------------------

if sys.argv[1] == "random-a":

  size = 25
  print "num_inputs =", size, ";"

  in0 = []
  in1 = []
  out = []

  for i in xrange(size):

    a = random.randint(0,0xff)
    b = (a * random.randint(0,0xf)) & 0xff
    c = fractions.gcd( a, b )

    in0.append( a )
    in1.append( b )
    out.append( c )

  print_dataset( in0, in1, out )

#-------------------------------------------------------------------------
# Random dataset
#-------------------------------------------------------------------------

elif sys.argv[1] == "random-b":

  size = 25
  print "num_inputs =", size, ";"

  in0 = []
  in1 = []
  out = []

  for i in xrange(size):

    a = random.randint(0,0xffff)
    b = random.randint(0,0xffff)
    c = fractions.gcd( a, b )

    in0.append( a )
    in1.append( b )
    out.append( c )

  print_dataset( in0, in1, out )

#-------------------------------------------------------------------------
# Unrecognied dataset
#-------------------------------------------------------------------------

else:
  sys.stderr.write("unrecognized command line argument\n")
  exit(1)

exit(0)

