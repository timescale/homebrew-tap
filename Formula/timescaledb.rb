require_relative 'timescaledb@2.8.1'

# This is the class that contains a link to the latest version of TimescaleDB
# Only inherits the latest version and require the proper relative.
# Feed the TimescaleDB::VERSION_MAP to keep it up to date.
class Timescaledb < TimescaledbAT281
end
