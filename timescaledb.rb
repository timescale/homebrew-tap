class Timescaledb < Formula
  desc "An open-source time-series database optimized for fast ingest and complex queries. Fully compatible with PostgreSQL."
  homepage "https://www.timescaledb.com"
  url "https://timescalereleases.blob.core.windows.net/homebrew/timescaledb-2.3.0.tar.lzma"
  version "2.3.0"
  sha256 "baa8a60230320838c6d5d143846c14edc5238e2979ed2408a980280f05a81b3e"

  depends_on "postgresql"

  depends_on "cmake" => :build
  depends_on "openssl" => :build
  depends_on "xz" => :build
  depends_on "timescaledb-tools" => :recommended

  option "with-oss-only", "Build TimescaleDB with only Apache-2 licensed code"

  def install
    system "./bootstrap -DREGRESS_CHECKS=OFF -DPROJECT_INSTALL_METHOD=\"brew\"#{" -DAPACHE_ONLY=1" if build.with?("oss-only")}"

    (buildpath/"build").cd do
      system "make"

      # CMake installs the files into DESTDIR/$HOMEBREW_PREFIX, so stage it and then unwrap it
      stage = buildpath/"stage"
      stage.mkdir

      system "make install DESTDIR=#{stage}"

      # Something like:
      #   /var/tmp/abc123/stage/usr/local
      #
      # which contains files like
      #   /var/tmp/abc123/stage/usr/local/lib/postgresql/timescaledb.so
      #
      stage_prefix = (stage/HOMEBREW_PREFIX.to_s.delete_prefix("/"))

      prefix.install stage_prefix.children
    end
  end

  test do
    system "test", "-e", "#{lib}/postgresql/timescaledb.so"
  end

  def caveats
    <<~EOS
      RECOMMENDED: Run 'timescaledb-tune' to update your config settings for TimescaleDB.

        timescaledb-tune --quiet --yes --conf-path #{var/"postgres/postgresql.conf"}

      IF NOT, you'll need to make sure to update #{var/"postgres/postgresql.conf"}
      to include the extension:

        shared_preload_libraries = 'timescaledb'

      If PostgreSQL is installed via Homebrew, restart it:

        brew services restart postgresql

    EOS
  end
end
