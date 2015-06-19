require "formula_versions"

raise "Please `brew update` first" unless (HOMEBREW_REPOSITORY/".git").directory?

CADFAEL_BREW_VERSIONS_HELP = <<-EOS
usage: brew versions [--all] FORMULA...

Overview:
  Print version and commit history of FORMULA. By default only the latest
  commit for each FORMULA version is shown.

Options:
  --all        Show all commits that touched FORMULA

Caveats:
  Use --all if there is any confusion about version history, in particular
  reverts.

EOS

if ARGV.include?("--help")
  puts CADFAEL_BREW_VERSIONS_HELP 
  Kernel.exit(0)
end

raise FormulaUnspecifiedError if ARGV.named.empty?

ARGV.formulae.each do |f|
  versions = FormulaVersions.new(f)

  seen_versions = Set.new

  versions.rev_list("HEAD") do |rev|
    oldf = versions.formula_at_revision(rev) { |f| f }
    next if oldf.nil?
    puts "#{oldf.name} #{Tty.white}#{oldf.pkg_version.to_s.ljust(8)}#{Tty.reset} #{rev} #{versions.entry_name}" if ARGV.include?('--all') or seen_versions.add?(oldf.pkg_version)
  end
end


