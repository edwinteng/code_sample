# Perl script
# Output lines containing numbers
#

# open a file and output error if the file is not found
open(FILE,"test.txt") or die "not found file\n";
#iterate through the file
while(<FILE>){
	# test if each line has number
	if($_ =~ /\d+/){
		#print the line
		print $_;
	}
}
#close file
close(FILE);
