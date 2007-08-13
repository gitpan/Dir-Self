#!perl -w

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 2;

use Dir::Self;
ok 1, 'use Dir::Self';

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

like __DIR__, '/\bt$/';
