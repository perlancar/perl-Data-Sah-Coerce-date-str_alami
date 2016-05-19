#!perl

use 5.010001;
use strict;
use warnings;

use Data::Sah::Coerce qw(gen_coercer);
use Test::More 0.98;
use Test::Needs;

subtest "coerce_to=DateTime" => sub {
    test_needs "DateTime";
    test_needs "DateTime::Format::Alami";

    my $c = gen_coercer(type=>"date", coerce_to=>"DateTime", coerce_from=>["str_alami"]);

    # uncoerced
    is_deeply($c->({}), {}, "uncoerced");

    {
        local $ENV{LANG} = 'en_US.UTF-8';

        my $d = $c->("may 19, 2016");
        is(ref($d), 'DateTime');
        is($d->ymd, "2016-05-19");
    }

    # XXX why no workie?
    #{
    #    local $ENV{LANG} = 'id_ID.UTF-8';
    #
    #    my $d = $c->("19 mei 2016");
    #    is(ref($d), 'DateTime');
    #    is($d->ymd, "2016-05-19");
    #}
};

done_testing;
