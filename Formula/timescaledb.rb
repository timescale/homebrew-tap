require_relative 'timescaledb_base'
classes = {
  '2.8.1' =>"22a057c4472d23bf08778932e391f38f350ef0307cf99fb8e279c8245667d3e9",
  "2.8.0" => "a3403447805bb97f8b6f38dfdc9dde24c24e4389cf7f2348358774605ad2687e"
}.map do |version, sha256|
  Class.new("TimescaledbAT#{version.tr('.','')}", TimescaledbBase) do
    url "https://github.com/timescale/timescaledb/archive/refs/tags/#{version}.tar.gz"
    version version
    sha256 sha256
  end
end
Timescaledb = classes.first
