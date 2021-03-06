require 'rake'
require 'rake/clean'

namespace(:tools) do
  namespace(:rubygems) do
    package = RubyInstaller::RubyGems
    interpreter = RubyInstaller::Ruby18
    directory package.target
    CLEAN.include(package.target)

    # Put files for the :download task
    package.files.each do |f|
      file_source = "#{package.url}/#{f}"
      file_target = "downloads/#{f}"
      download file_target => file_source
      
      # depend on downloads directory
      file file_target => "downloads"
      
      # download task need these files as pre-requisites
      task :download => file_target
    end

    task :checkout => "downloads" do
      cd RubyInstaller::ROOT do
        # If is there already a checkout, update instead of checkout"
        if File.exist?(File.join(RubyInstaller::ROOT, package.checkout_target, '.svn'))
          sh "svn update #{package.checkout_target}"
        else
          sh "svn co #{package.checkout} #{package.checkout_target}"
        end
      end
    end

    task :download_or_checkout do
      if ENV['CHECKOUT'] then
        Rake::Task['tools:rubygems:checkout'].invoke
      else
        Rake::Task['tools:rubygems:download'].invoke
      end
    end

    # Prepare the :sandbox, it requires the :download task
    task :extract => [:extract_utils, package.target] do
      # grab the files from the download task
      files = Rake::Task['tools:rubygems:download'].prerequisites

      # use the checkout copy instead of the packaged file
      unless ENV['CHECKOUT']
        files.each { |f|
          extract(File.join(RubyInstaller::ROOT, f), package.target)
        }
      else
        cp_r(package.checkout_target, File.join(RubyInstaller::ROOT, 'sandbox'), :verbose => true, :remove_destination => true)
      end
    end
    ENV['CHECKOUT'] ? task(:extract => :checkout) : task(:extract => :download)

    task :install18 => [package.target, RubyInstaller::Ruby18.target] do
      do_install RubyInstaller::RubyGems, RubyInstaller::Ruby18
    end

    task :install19 => [package.target, RubyInstaller::Ruby19.target] do
      do_install RubyInstaller::RubyGems, RubyInstaller::Ruby19
    end

    private
    def do_install(package, interpreter)
      new_ruby = File.join(RubyInstaller::ROOT, interpreter.install_target, "bin").gsub(File::SEPARATOR, File::ALT_SEPARATOR)
      ENV['PATH'] = "#{new_ruby};#{ENV['PATH']}"
      ['RUBYOPT', 'GEM_HOME', 'GEM_PATH'].each do |var|
        ENV.delete(var)
      end

      cd package.target do
        sh "ruby setup.rb install #{package.configure_options.join(' ')}"
      end

      # now fixes the stub batch files form bin
      Dir.glob("#{interpreter.install_target}/bin/gem.bat").each do |bat|
        script = File.basename(bat).gsub(File.extname(bat), '')
        File.open(bat, 'w') do |f|
          f.puts <<-TEXT
@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
ECHO.This version of Ruby has not been built with support for Windows 95/98/Me.
GOTO :EOF
:WinNT
@"%~dp0ruby.exe" "%~dpn0" %*
TEXT
        end
      end

      # and now, fixes the shebang lines for the scripts
      bang_line = "#!#{File.expand_path(File.join(interpreter.install_target, 'bin', 'ruby.exe'))}"
      Dir.glob("#{interpreter.install_target}/bin/gem").each do |script|
        # only process true scripts!!! (extensionless)
        if File.extname(script) == ""
          contents = File.read(script).gsub(/#{Regexp.escape(bang_line)}/) do |match|
            "#!/usr/bin/env ruby"
          end
          File.open(script, 'w') { |f| f.write(contents) }
        end
      end
    end
  end
end

task :rubygems => [
  'tools:rubygems:download_or_checkout',
  'tools:rubygems:extract'
]

task :rubygems18 => [
  'rubygems',
  'tools:rubygems:install18'
]

task :rubygems19 => [
  'rubygems',
  'tools:rubygems:install19'
]
