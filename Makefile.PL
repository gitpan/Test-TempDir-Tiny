
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.029.
use strict;
use warnings;

use 5.008001;

use ExtUtils::MakeMaker 6.17;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Temporary directories that stick around when tests fail",
  "AUTHOR" => "David Golden <dagolden\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.17"
  },
  "DISTNAME" => "Test-TempDir-Tiny",
  "EXE_FILES" => [],
  "LICENSE" => "apache",
  "MIN_PERL_VERSION" => "5.008001",
  "NAME" => "Test::TempDir::Tiny",
  "PREREQ_PM" => {
    "B" => 0,
    "Carp" => 0,
    "Cwd" => 0,
    "Exporter" => "5.57",
    "File::Path" => "2.01",
    "File::Temp" => 0,
    "Time::HiRes" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "File::Copy" => 0,
    "File::Spec" => 0,
    "Test::More" => 0
  },
  "VERSION" => "0.003",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "B" => 0,
  "Carp" => 0,
  "Cwd" => 0,
  "Exporter" => "5.57",
  "ExtUtils::MakeMaker" => "6.17",
  "File::Copy" => 0,
  "File::Path" => "2.01",
  "File::Spec" => 0,
  "File::Temp" => 0,
  "Test::More" => 0,
  "Time::HiRes" => 0,
  "strict" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



