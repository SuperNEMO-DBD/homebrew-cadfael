#:  * `snemo-formula-history` [`--all`] <formulae>:
#:    Print last commit that touched <formulae> and their version at that
#:    commit
#:
#:    If `--all` is passed, show all commits touching <formulae> at a given
#:    version, not just the newest one.
#:
#:    Requires formulae to be hosted in taps, and for each tap to be full 
#:    in order to have the commit history.

require "formula_versions"

class TapIsShallowError < RuntimeError
  attr_reader :formula

  def initialize(formula)
    @formula = formula

    super <<~EOS
      Formula '#{formula}' is in a shallow Tap '#{formula.tap}'

      You should run 'brew tap --full #{formula.tap}' first
    EOS
  end
end


raise FormulaUnspecifiedError if ARGV.named.empty?

ARGV.formulae.each do |f|
  raise "Formula #{f} has no Tap" if f.tap.nil?
  raise TapIsShallowError, f if f.tap.shallow?

  versions = FormulaVersions.new(f)

  seen_versions = Set.new

  versions.rev_list("HEAD") do |rev|
    oldf = versions.formula_at_revision(rev) { |f| f }
    next if oldf.nil?
    puts "#{oldf.name} #{oldf.pkg_version.to_s.ljust(8)} #{rev} #{f.tap} #{versions.entry_name}" if ARGV.include?('--all') or seen_versions.add?(oldf.pkg_version)
  end
end


