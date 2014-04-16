from itertools import groupby,tee
from operator import itemgetter
import sys

# This is a script that counts the frequency of 
# Note: the data should be sort first (It can be achieved by calling UNIX sort command)
#group several lines by their first field and count the occurrence frequency 
# Sample input:  
#       1   3 
#       1   4
#       1   5
#       2   3
# Sample output:
#       1   3    
#       2   1
# i.e.  "1" occur 3 times, and "2" occur 1 time

# iterate over input source and output values on the fly to save memory and computational power
def read_mapper_output(file, separator='\t'):
	#iterate over input
        for line in file:
		# split line into different fields using separator"\t"
		#output the values on the fly with "yield"
                yield line.rstrip().split(separator)


def main(separator='\t'):
        data = read_mapper_output(sys.stdin, separator=separator)
	#group several lines by their first field and count the occurrence frequency 
	for key, group in groupby(data,itemgetter(0)):
		# calculate the frequency
		count = len(list(group))
		#output
		print "%s\t%s" %(key,count)

# run main function
if __name__ == "__main__":
    main()

