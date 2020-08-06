package Cpanel::JSON::XS;
our $VERSION = '4.19';
our $XS_VERSION = $VERSION;
# $VERSION = eval $VERSION;
 
our @ISA = qw(Exporter);
our @EXPORT = qw(encode_json decode_json to_json from_json);
 
sub to_json($@) {
   if ($] >= 5.008) {
     require Carp;
     Carp::croak ("Cpanel::JSON::XS::to_json has been renamed to encode_json,".
                  " either downgrade to pre-2.0 versions of Cpanel::JSON::XS or".
                  " rename the call");
   } else {
     _to_json(@_);
   }
}
 
sub from_json($@) {
   if ($] >= 5.008) {
     require Carp;
     Carp::croak ("Cpanel::JSON::XS::from_json has been renamed to decode_json,".
                  " either downgrade to pre-2.0 versions of Cpanel::JSON::XS or".
                  " rename the call");
   } else {
     _from_json(@_);
   }
}
 
use Exporter;
use XSLoader;
 
sub allow_bigint {
    Carp::carp("allow_bigint() is obsoleted. use allow_bignum() instead.");
}
 
BEGIN {
  package
    JSON::PP::Boolean;
 
  require overload;
 
  local $^W; # silence redefine warnings. no warnings 'redefine' does not help
  &overload::import( 'overload', # workaround 5.6 reserved keyword warning
    "0+"     => sub { ${$_[0]} },
    "++"     => sub { $_[0] = ${$_[0]} + 1 },
    "--"     => sub { $_[0] = ${$_[0]} - 1 },
    '""'     => sub { ${$_[0]} == 1 ? '1' : '0' }, # GH 29
    'eq'     => sub {
      my ($obj, $op) = $_[2] ? ($_[1], $_[0]) : ($_[0], $_[1]);
      #warn "eq obj:$obj op:$op len:", length($op) > 0, " swap:$_[2]";
      if (ref $op) { # if 2nd also blessed might recurse endlessly
        return $obj ? 1 == $op : 0 == $op;
      }
      # if string, only accept numbers or true|false or "" (e.g. !!0 / SV_NO)
      elsif ($op !~ /^[0-9]+$/) {
        return "$obj" eq '1' ? 'true' eq $op : 'false' eq $op || "" eq $op;
      }
      else {
        return $obj ? 1 == $op : 0 == $op;
      }
    },
    'ne'     => sub {
      my ($obj, $op) = $_[2] ? ($_[1], $_[0]) : ($_[0], $_[1]);
      #warn "ne obj:$obj op:$op";
      return !($obj eq $op);
    },
    fallback => 1);
}
 
our ($true, $false);
BEGIN {
  if ($INC{'JSON/XS.pm'}
      and $INC{'Types/Serialiser.pm'}
      and $JSON::XS::VERSION ge "3.00") {
    $true  = $Types::Serialiser::true; # readonly if loaded by JSON::XS
    $false = $Types::Serialiser::false;
  } else {
    $true  = do { bless \(my $dummy = 1), "JSON::PP::Boolean" };
    $false = do { bless \(my $dummy = 0), "JSON::PP::Boolean" };
  }
}
 
BEGIN {
  my $const_true  = $true;
  my $const_false = $false;
  *true  = sub () { $const_true  };
  *false = sub () { $const_false };
}
 
sub is_bool($) {
  shift if @_ == 2; # as method call
  (ref($_[0]) and UNIVERSAL::isa( $_[0], JSON::PP::Boolean::))
  or (exists $INC{'Types/Serialiser.pm'} and Types::Serialiser::is_bool($_[0]))
}
 
XSLoader::load 'Cpanel::JSON::XS', $XS_VERSION;
 
1;