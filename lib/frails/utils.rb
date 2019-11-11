# frozen_string_literal: true

module Frails
  class Utils
    def self.camelize(term, first_letter = :upper, convert_slashes: true)
      # If we are not converting slashes, and `first_letter` is `:lower`, this ensures that the
      # first letter after a slash is not capitalized.
      string = if !convert_slashes && first_letter == :lower
                 term.split('/').map { |str| str.camelize :lower }.join('/')
               else
                 term.camelize first_letter
               end

      # Reverses the effect of ActiveSupport::Inflector.camelize converting slashes into `::`. If
      # the keyword argument `convert_slashes:` is false (default: true), we can avoid
      # converting slashes to `::`.
      string.gsub!('::', '/') unless convert_slashes

      string
    end
  end
end
