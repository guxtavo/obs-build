################################################################
#
# Copyright (c) 1995-2014 SUSE Linux Products GmbH
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 or 3 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program (see the file COPYING); if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
#
################################################################

package Build::Appimage;

use strict;
use Build::Deb;
use Build::Rpm;

eval { require YAML::XS; };
*YAML::XS::LoadFile = sub {die("YAML::XS is not available\n")} unless defined &YAML::XS::LoadFile;

sub parse {
  my ($cf, $fn) = @_;

  my ($yml) = YAML::XS::LoadFile($fn);
  return {'error' => "Failed to parse yml file"} unless $yml;

  my $ret = {};
  $ret->{'name'} = $yml->{'app'};
  $ret->{'version'} = $yml->{'version'} || "0";

  my @packdeps;
  if ($yml->{'ingredients'}) {
    for my $pkg (@{$yml->{'ingredients'}->{'packages'} || {}}) {
      push @packdeps, $pkg;
    }
  }

  $ret->{'deps'} = \@packdeps;

  return $ret;
}

1;
