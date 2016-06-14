package Data::Sah::Coerce::perl::date::str_alami_en;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Data::Dmp;

# TMP
our $time_zone;

sub meta {
    +{
        v => 2,
        enable_by_default => 0,
        might_die => 1,
        prio => 60, # a bit lower than normal
        precludes => [qr/\Astr_alami(_.+)?\z/, 'str_natural'],
    };
}

sub coerce {
    my %args = @_;

    my $dt = $args{data_term};
    my $coerce_to = $args{coerce_to} // 'float(epoch)';

    my $res = {};

    $res->{expr_match} = "!ref($dt)";
    $res->{modules}{"DateTime::Format::Alami::EN"} //= 0;
    $res->{expr_coerce} = join(
        "",
        "do { my \$res = DateTime::Format::Alami::EN->new->parse_datetime($dt, {_time_zone => ".dmp($time_zone)."}); ",
        ($coerce_to eq 'float(epoch)' ? "\$res = \$res->epoch; " :
             $coerce_to eq 'Time::Moment' ? "\$res = Time::Moment->from_object(\$res); " :
             $coerce_to eq 'DateTime' ? "" :
             (die "BUG: Unknown coerce_to '$coerce_to'")),
        "\$res }",
    );
    $res;
}

1;
# ABSTRACT: Coerce date from string parsed by DateTime::Format::Alami::EN

=for Pod::Coverage ^(meta|coerce)$

=head1 DESCRIPTION

The rule is not enabled by default. You can enable it in a schema using e.g.:

 ["array*", of=>"date", "x.perl.coerce_to"=>"DateTime", "x.perl.coerce_rules"=>["str_alami_en"]]
