#!perl

use 5.010001;
use strict;
use warnings;

use Data::Sah::Coerce qw(gen_coercer);
use Test::More 0.98;
use Test::Needs;

subtest "coerce_to=DateTime" => sub {
    test_needs "DateTime";
    test_needs "DateTime::Format::Alami::ID";

    my $c = gen_coercer(type=>"date", coerce_to=>"DateTime", coerce_rules=>["str_alami_id"]);

    # uncoerced
    is_deeply($c->({}), {}, "uncoerced");

    my $d = $c->("19 mei 2016");
    is(ref($d), 'DateTime');
    is($d->ymd, "2016-05-19");
};

done_testing;
