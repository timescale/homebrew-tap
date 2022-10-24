require_relative 'timescaledb_base'

class TimescaledbAT280 < TimescaledbBase
  version "2.8.0"
  sha256 "a3403447805bb97f8b6f38dfdc9dde24c24e4389cf7f2348358774605ad2687e"
  url "https://github.com/timescale/timescaledb/archive/refs/tags/#{version}.tar.gz"
end
