# Copyright 2019 sakaki (sakaki@deciban.com)
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_PHP="php7-2"
PHP_EXT_NAME="${PN}"

inherit php-ext-source-r3

DESCRIPTION="Threading extension for PHP"
HOMEPAGE="https://github.com/krakjoe/${PN}/"
SRC_URI="https://github.com/krakjoe/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
LICENSE="PHP-3.01"
SLOT="7"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

# Need ZTS
DEPEND="dev-lang/php:7.2[threads]"
RDEPEND="${DEPEND}"
