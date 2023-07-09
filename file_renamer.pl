#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;
use Cwd;

# Print the current directory
my $current_directory = getcwd();
print "Current Directory: $current_directory\n";


# Prompt user for directory path and renaming criteria
print "Enter the directory path: ";
my $directory = <STDIN>;
chomp $directory;



# Get list of files in the specified directory
opendir(my $dh, $directory) or die "Cannot open directory: $!";
my @files = readdir($dh);
closedir($dh);

# Print list of files
print "Files in $directory:\n";
foreach my $file (@files) {
    next if ($file =~ /^\./); # Skip hidden files/directories
    print "$file\n";
}

print "Enter the renaming criteria (e.g., prefix_, _suffix, find|replace): ";
my $renaming_criteria = <STDIN>;
chomp $renaming_criteria;

# Iterate over each file and rename it
foreach my $file (@files) {
    next if ($file =~ /^\./); # Skip hidden files/directories

    my $old_name = "$directory/$file";
    my $new_name = apply_renaming_criteria($file, $renaming_criteria);

    # Preview the changes
    print "Renaming '$file' to '$new_name'\n";

    rename($old_name, "$directory/$new_name") or warn "Cannot rename file: $!";
}

sub apply_renaming_criteria {
    my ($file, $criteria) = @_;

    # Applying prefix
    $criteria =~ s/^prefix_//;
    $file = $criteria . $file if ($criteria =~ /^prefix_/);

    # Applying suffix
    $criteria =~ s/_suffix$//;
    $file = $file . $criteria if ($criteria =~ /_suffix$/);

    # Applying find|replace
    if ($criteria =~ /(.+)\|(.+)/) {
        my ($find, $replace) = ($1, $2);
        $file =~ s/$find/$replace/g;
    }

    return $file;
}
