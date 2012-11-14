# ----------------------------------------------------------------
# Makefile for PostgreSQL Monitering Kit for Hinemos
#
# Copyright(C) 2012 Uptime Technologies, LLC.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# ----------------------------------------------------------------

PREFIX=/opt/hinemos_agent/bin

all: mon_pgsql

install:
	install -m 755 mon_pgsql $(PREFIX)

clean:
	rm -rf *~
