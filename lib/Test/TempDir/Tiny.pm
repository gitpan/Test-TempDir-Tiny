use 5.008001;
use strict;
use warnings;

package Test::TempDir::Tiny;
# ABSTRACT: Temporary directories that stick around when tests fail

our $VERSION = '0.001';

use Exporter 5.57 qw/import/;
our @EXPORT = qw/tempdir/;

use Carp qw/croak/;
use Cwd qw/abs_path/;
{
    no warnings 'numeric'; # loading File::Path has non-numeric warnings on 5.8
    use File::Path 2.01 qw/remove_tree/;
}
use File::Temp;

my ( $ROOT_DIR, $TEST_DIR, %COUNTER );
my ( $ORIGINAL_PID, $ORIGINAL_CWD ) = ( $$, abs_path(".") );

#pod =func tempdir
#pod
#pod     $dir = tempdir();          # .../default_1/
#pod     $dir = tempdir("label");   # .../label_1/
#pod
#pod Creates a directory underneath a test-file-specific temporary directory and
#pod returns the absolute path to it.
#pod
#pod The function takes a single argument as a label for the directory or defaults
#pod to "default". An incremental counter value will be appended to allow a label to
#pod be used within a loop with distinct temporary directories:
#pod
#pod     # t/foo.t
#pod
#pod     for ( 1 .. 3 ) {
#pod         tempdir("in loop");
#pod     }
#pod
#pod     # creates:
#pod     #   ./tmp/t_foo_t/in_loop_1
#pod     #   ./tmp/t_foo_t/in_loop_2
#pod     #   ./tmp/t_foo_t/in_loop_3
#pod
#pod If the label contains any characters besides alphanumerics, underscore
#pod and dash, they will be replaced with underscore.
#pod
#pod     $dir = tempdir("a space"); # .../a_space_1/
#pod     $dir = tempdir("a!bang");  # .../a_bang_1/
#pod
#pod The test-file-specific directory and all directories within it will be cleaned
#pod up with an END block if the current test file passes tests.
#pod
#pod =cut

sub tempdir {
    my $label = defined( $_[0] ) ? $_[0] : 'default';
    $label =~ tr{a-zA-Z0-9_-}{_}cs;

    _init() unless $ROOT_DIR && $TEST_DIR;
    my $suffix = ++$COUNTER{$label};
    my $subdir = "$TEST_DIR/${label}_${suffix}";
    mkdir $subdir or die $!;
    return $subdir;
}

sub _init {
    # ROOT_DIR is ./tmp or a File::Temp object
    if ( -w 't' ) {
        $ROOT_DIR = abs_path('./tmp');
        if ( -e $ROOT_DIR ) {
            croak("$ROOT_DIR is not a directory")
              unless -d $ROOT_DIR;
        }
        else {
            mkdir $ROOT_DIR or die $!;
        }
    }
    else {
        $ROOT_DIR = File::Temp->newdir( TMPDIR => 1 );
    }

    # TEST_DIR is based on .t path under ROOT_DIR
    ( my $dirname = $0 ) =~ tr{\\/.}{_};
    $TEST_DIR = "$ROOT_DIR/$dirname";
    if ( !-d $TEST_DIR ) {
        mkdir $TEST_DIR or die $!;
    }
    else {
        remove_tree( $TEST_DIR, { safe => 0, keep_root => 1 } );
    }
    return;
}

sub _cleanup {
    # A File::Temp::Dir ROOT_DIR always gets to clean itself up
    if ( $ROOT_DIR && !ref $ROOT_DIR && -d $ROOT_DIR ) {
        if ( not $? ) {
            chdir $ORIGINAL_CWD;
            remove_tree( $TEST_DIR, { safe => 0 } ) if -d $TEST_DIR;
        }
        # will fail if there are any children, but we don't care
        rmdir $ROOT_DIR;
    }
}

# for testing
sub _root_dir { return $ROOT_DIR }

END {
    # only clean up in original process, not children
    if ( $$ == $ORIGINAL_PID ) {
        # our clean up must run after Test::More sets $? in its END block
        require B;
        push @{ B::end_av()->object_2svref }, \&_cleanup;
    }
}

1;


# vim: ts=4 sts=4 sw=4 et:

__END__

=pod

=encoding UTF-8

=head1 NAME

Test::TempDir::Tiny - Temporary directories that stick around when tests fail

=head1 VERSION

version 0.001

=head1 SYNOPSIS

    # t/foo.t
    use Test::More;
    use Test::TempDir::Tiny;

    $dir = tempdir();          # ./tmp/t_foo_t/default_1/
    $dir = tempdir("label");   # ./tmp/t_foo_t/label_1/
    $dir = tempdir("label");   # ./tmp/t_foo_t/label_2/

=head1 DESCRIPTION

This module works with L<Test::More> to create temporary directories that stick
around if tests fail.

It is loosely based on L<Test::TempDir>, but with less complexity, greater
portability and zero non-core dependencies.  (L<Capture::Tiny> is recommended
for testing.)

The L</tempdir> function is exported by default.  When called, it constructs a
directory tree to hold temporary directories.

If the current directory is writable, the root for directories will be
F<./tmp>.  Otherwise, a L<File::Temp> directory will be created wherever
temporary directories are stored for your system.

Every F<*.t> file gets its own subdirectory under the root based on the test
filename, but with slashes and periods replaced with underscores.  For example,
F<t/foo.t> would get a test-file-specific subdirectory F<./tmp/t_foo_t/>.
Directories created by L</tempdir> get put in that directory.  This makes it
very easy to find files later if tests fail.

When the test file exits, if all tests passed, then the test-file-specific
directory is recursively removed.

If a test failed and the root directory is F<./tmp>, the test-file-specific
directory sticks around for inspection.  (But if the root is a L<File::Temp>
directory, it is always discarded).

If nothing is left in F<./tmp> (i.e. no other test file failed), then F<./tmp>
is cleaned up as well.

=head1 FUNCTIONS

=head2 tempdir

    $dir = tempdir();          # .../default_1/
    $dir = tempdir("label");   # .../label_1/

Creates a directory underneath a test-file-specific temporary directory and
returns the absolute path to it.

The function takes a single argument as a label for the directory or defaults
to "default". An incremental counter value will be appended to allow a label to
be used within a loop with distinct temporary directories:

    # t/foo.t

    for ( 1 .. 3 ) {
        tempdir("in loop");
    }

    # creates:
    #   ./tmp/t_foo_t/in_loop_1
    #   ./tmp/t_foo_t/in_loop_2
    #   ./tmp/t_foo_t/in_loop_3

If the label contains any characters besides alphanumerics, underscore
and dash, they will be replaced with underscore.

    $dir = tempdir("a space"); # .../a_space_1/
    $dir = tempdir("a!bang");  # .../a_bang_1/

The test-file-specific directory and all directories within it will be cleaned
up with an END block if the current test file passes tests.

=head1 SEE ALSO

=over 4

=item *

L<File::Temp>

=item *

L<Path::Tiny>

=back

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at L<https://github.com/dagolden/Test-TempDir-Tiny/issues>.
You will be notified automatically of any progress on your issue.

=head2 Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

L<https://github.com/dagolden/Test-TempDir-Tiny>

  git clone https://github.com/dagolden/Test-TempDir-Tiny.git

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut
