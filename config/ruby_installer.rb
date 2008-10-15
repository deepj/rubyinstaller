require 'ostruct'

module RubyInstaller
  module Version
    unless defined?(MAJOR)
      MAJOR = 3
      MINOR = 0
      REVISION = 0
    end
  end
  
  unless defined?(ROOT)
    # Root folder
    ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))
    
    # MinGW files
    MinGW = OpenStruct.new(
      :release => 'current',
      :version => '3.4.5',
      :url => "http://easynews.dl.sourceforge.net/mingw",
      :target => 'sandbox/mingw',
      :files => [
        'binutils-2.17.50-20060824-1.tar.gz',
        'gcc-core-3.4.5-20060117-3.tar.gz',
        'gcc-g++-3.4.5-20060117-3.tar.gz',
        'mingw-runtime-3.14.tar.gz',
        'mingw-utils-0.3.tar.gz',
        'w32api-3.11.tar.gz',
        'gdb-6.8-mingw-3.tar.bz2'
      ]
    )

    MSYS = OpenStruct.new(
      :release => 'technology-preview',
      :version => '1.0.11',
      :url => "http://easynews.dl.sourceforge.net/mingw",
      :target => 'sandbox/msys',
      :files => [
        'diffutils-2.8.7-MSYS-1.0.11-snapshot.tar.bz2',
        'findutils-4.3.0-MSYS-1.0.11-snapshot.tar.bz2',
        'gawk-3.1.5-MSYS-1.0.11-snapshot.tar.bz2',
        'msysCORE-1.0.11-2007.01.19-1.tar.bz2',
        'MSYS-1.0.11-20070729.tar.bz2',
        'coreutils-5.97-MSYS-1.0.11-snapshot.tar.bz2',
        'texinfo-4.11-MSYS-1.0.11.tar.bz2',
        'bash-3.1-MSYS-1.0.11-1.tar.bz2',
        'bison-2.3-MSYS-1.0.11.tar.bz2',
        'perl-5.6.1-MSYS-1.0.11.tar.bz2',
        'm4-1.4.7-MSYS.tar.bz2',
        'msys-autoconf-2.59.tar.bz2',
        'msys-automake-1.8.2.tar.bz2',
        'msys-libtool-1.5.tar.bz2'
      ]
    )

    Ruby18 = OpenStruct.new(
      :release => "official",
      :version => "1.8.6-p287",
      :url => "http://ftp.ruby-lang.org/pub/ruby/1.8",
      :checkout => 'http://svn.ruby-lang.org/repos/ruby/branches/ruby_1_8_6',
      :checkout_target => 'downloads/ruby_1_8',
      :target => 'sandbox/ruby_1_8',
      :build_target => 'sandbox/ruby_build',
      :install_target => 'sandbox/ruby_mingw',
      :configure_options => [
        '--enable-shared',
        '--with-winsock2',
        '--disable-install-doc'
      ],
      :files => [
        'ruby-1.8.6-p287.tar.bz2'
      ],
      :dependencies => [
        'readline5.dll',
        'zlib1.dll',
        'libeay32.dll',
        'libssl32.dll',
        'libiconv2.dll',
        'pdcurses.dll',
        'gdbm3.dll'
      ]
    )

    Zlib = OpenStruct.new(
      :release => "official",
      :version => "1.2.3",
      :url => "http://www.zlib.net",
      :target => RubyInstaller::MinGW.target,
      :files => [
        'zlib123-dll.zip'
      ]
    )
    
    # FIXME: using direct mirror for Readline since GnuWin32 seems failing
    # to grab a correct link (stack level too deep due redirections)
    Readline = OpenStruct.new(
      :release => "official",
      :version => "5.0",
      :url => "http://easynews.dl.sourceforge.net/sourceforge/gnuwin32",
      :target => RubyInstaller::MinGW.target,
      :files => [
        'readline-5.0-bin.zip',
        'readline-5.0-lib.zip'
      ]
    )

    PdCurses = OpenStruct.new(
      :version => '3.3',
      :url => "http://downloads.sourceforge.net/pdcurses",
      :target => RubyInstaller::MinGW.target,
      :files => [ 
        'pdc33dll.zip' 
      ]
    )
  
    ExtractUtils = OpenStruct.new(
        :url => "http://easynews.dl.sourceforge.net/sevenzip",
        :target => 'sandbox/extract_utils',
        :files => [
          '7za458.zip'
        ]
    )

    OpenSsl = OpenStruct.new(
      :version => '0.9.8h',
      :url => "http://www.openssl.org/source",
      :target => 'sandbox/openssl',
      :files => [
        'openssl-0.9.8h.tar.gz'
      ]
    )

    Iconv = OpenStruct.new(
      :release => 'official',
      :version => "1.9.2-1",
      :url => "http://easynews.dl.sourceforge.net/gnuwin32",
      :target => RubyInstaller::MinGW.target,
      :files => [
        'libiconv-1.9.2-1-bin.zip',
        'libiconv-1.9.2-1-lib.zip'
      ]
    )

    Gdbm = OpenStruct.new(
      :release => 'official',
      :version => '1.8.3-1',
      :url => "http://easynews.dl.sourceforge.net/gnuwin32",
      :target => RubyInstaller::MinGW.target,
      :files => [
        'gdbm-1.8.3-1-bin.zip',
        'gdbm-1.8.3-1-lib.zip',
        'gdbm-1.8.3-1-src.zip'
      ]
    )
    
    RubyGems = OpenStruct.new(
      :release => 'official',
      :version => '1.3.0',
      :url => 'http://rubyforge.org/frs/download.php/43985',
      :checkout => 'svn://rubyforge.org/var/svn/rubygems/trunk',
      :checkout_target => 'downloads/rubygems',
      :target => 'sandbox/rubygems',
      :install_target => 'sandbox/rubygems_mingw',
      :configure_options => [
        '--no-ri',
        '--no-rdoc'
      ],
      :files => [
        'rubygems-1.3.0.tgz'
      ]
    )
    
    Wix = OpenStruct.new(
      :release => 'stable',
      :version => '2.0.5805.1',
      :url => 'http://easynews.dl.sourceforge.net/wix',
      :target => 'sandbox/wix',
      :files => [
        'wix-2.0.5805.0-binaries.zip'
      ]
    )
    
    Paraffin = OpenStruct.new(
      :release => 'stable',
      :version => '2.0.5805.1',
      :url => 'http://www.wintellect.com/cs/files/folders/4332/download.aspx',
      :target => RubyInstaller::Wix.target,
      :files => [
        'Paraffin-1.03.zip'
      ]
    )
    
    Patches = OpenStruct.new(
     :url => 'http://dump.mmediasys.com/installer3',
     :target => 'sandbox/patches',
     :prepare_target => RubyInstaller::Ruby18.target,
     :files => [
        'patches.zip'
      ]
    )
    
    Runtime = OpenStruct.new(
      :version => '1.8.6-p114',
      :ruby_version_source => RubyInstaller::Ruby18.target,
      :rubygems_version_source => RubyInstaller::RubyGems.target,
      :namespace => 'runtime',
      :source => 'resources/installer',
      :package_name => 'ruby',
      :wix_config => {
          'ProductCode'=> "67F67970-2233-4AF9-9B41-7161F927617C",
          'UpgradeCode'=> "3E145ABF-D25C-4E4C-899E-5F043D3F9A33",
          'Year' =>  "2008",
          'ProductName' =>  "One-Click Ruby Installer 3.0",
          'InstallName' =>  "RubyInstaller",
          'InstallId' =>  "Ruby18",
          'DevKitInstallId' =>  "devkit",
          'ProductVersion' =>  "3.0.0",
          'ProductURL' =>  "http://rubyinstaller.rubyforge.org/",
          'RuntimeTitle' =>  "Ruby runtime",
          'RuntimeDescription' =>  "The Ruby runtime",
          'RubyTitle' =>  "Ruby",
          'RubyVersion' =>  "",
          'RubyDescription' =>  "The Ruby interpreter and standard library",
          'RubyGemsTitle' =>  "RubyGems",
          'RubyGemsDescription' =>  "The RubyGems package management system",
          'RubyGemsVersion' =>  ""
        },
      :config_file => 'config.wxi.erb'
    )
    
    DevKit = OpenStruct.new(
      :version => RubyInstaller::Runtime.version,
      :ruby_version_source => RubyInstaller::Ruby18.target,
      :rubygems_version_source => RubyInstaller::RubyGems.target,
      :namespace => 'devkit',
      :source => RubyInstaller::Runtime.source,
      :package_name => 'ruby_devkit',
      :wix_config   => RubyInstaller::Runtime.wix_config,
      :config_file  => RubyInstaller::Runtime.config_file
    )
   
  end
end
