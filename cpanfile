requires "B" => "0";
requires "Carp" => "0";
requires "Cwd" => "0";
requires "Exporter" => "5.57";
requires "File::Path" => "2.01";
requires "File::Temp" => "0";
requires "Time::HiRes" => "0";
requires "perl" => "5.008001";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Copy" => "0";
  requires "File::Spec" => "0";
  requires "Test::More" => "0";
  requires "perl" => "5.008001";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
  recommends "Capture::Tiny" => "0.12";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.17";
  requires "perl" => "5.008001";
};

on 'develop' => sub {
  requires "Dist::Zilla" => "5";
  requires "Dist::Zilla::Plugin::OnlyCorePrereqs" => "0";
  requires "Dist::Zilla::Plugin::Prereqs" => "0";
  requires "Dist::Zilla::PluginBundle::DAGOLDEN" => "0.072";
  requires "File::Spec" => "0";
  requires "File::Temp" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::CPAN::Meta" => "0";
  requires "Test::More" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Spelling" => "0.12";
  requires "Test::Version" => "1";
};
