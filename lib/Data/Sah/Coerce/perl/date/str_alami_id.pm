package Data::Sah::Coerce::perl::date::str_alami_id;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

sub meta {
    +{
        v => 2,
        enable_by_default => 0,
        might_die => 1,
        prio => 60, # a bit lower than normal
        precludes => [qr/^str_alami(_.+)?$/],
    };
}

sub coerce {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};

    unless ($args{coerce_to} eq 'DateTime') {
        die "To use this coercion rule, you must coerce your date to DateTime (e.g. by adding this attribute 'x.perl.coerce_to' => 'DateTime' to your schema)";
    }

    $res->{expr_match} = "!ref($dt)";
    $res->{modules}{"DateTime::Format::Alami::ID"} //= 0;
    $res->{expr_coerce} = "DateTime::Format::Alami::ID->new->parse_datetime($dt)";

    $res;
}

1;
# ABSTRACT: Coerce date from string parsed by DateTime::Format::Alami::ID

=for Pod::Coverage ^(meta|coerce)$

=head1 DESCRIPTION

The rule is not enabled by default. You can enable it in a schema using e.g.:

 ["array*", of=>"date", "x.perl.coerce_to"=>"DateTime", "x.perl.coerce_from"=>["str_alami_id"]]
