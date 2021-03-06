require 'hanami/view/escape'

module Hanami
  # Presenter pattern implementation
  #
  # It delegates to the wrapped object the missing method invocations.
  #
  # The output of concrete and delegated methods is escaped as XSS prevention.
  #
  # @since 0.1.0
  #
  # @example Basic usage
  #   require 'hanami/view'
  #
  #   class Map
  #     attr_reader :locations
  #
  #     def initialize(locations)
  #       @locations = locations
  #     end
  #
  #     def location_names
  #       @locations.join(', ')
  #     end
  #   end
  #
  #   class MapPresenter
  #     include Hanami::Presenter
  #
  #     def count
  #       locations.count
  #     end
  #
  #     def location_names
  #       super.upcase
  #     end
  #
  #     def inspect_object
  #       @object.inspect
  #     end
  #   end
  #
  #   map = Map.new(['Rome', 'Boston'])
  #   presenter = MapPresenter.new(map)
  #
  #   # access a map method
  #   puts presenter.locations # => ['Rome', 'Boston']
  #
  #   # access presenter concrete methods
  #   puts presenter.count # => 1
  #
  #   # uses super to access original object implementation
  #   puts presenter.location_names # => 'ROME, BOSTON'
  #
  #   # it has private access to the original object
  #   puts presenter.inspect_object # => #<Map:0x007fdeada0b2f0 @locations=["Rome", "Boston"]>
  #
  # @example Escape
  #   require 'hanami/view'
  #
  #   User = Struct.new(:first_name, :last_name)
  #
  #   class UserPresenter
  #     include Hanami::Presenter
  #
  #     def full_name
  #       [first_name, last_name].join(' ')
  #     end
  #
  #     def raw_first_name
  #       _raw first_name
  #     end
  #   end
  #
  #   first_name = '<script>alert('xss')</script>'
  #
  #   user = User.new(first_name, nil)
  #   presenter = UserPresenter.new(user)
  #
  #   presenter.full_name
  #     # => "&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;"
  #
  #   presenter.raw_full_name
  #      # => "<script>alert('xss')</script>"
  module Presenter
    # Inject escape logic into the given class.
    #
    # @since 0.4.0
    # @api private
    #
    # @see Hanami::View::Escape
    def self.included(base)
      base.class_eval do
        include ::Hanami::View::Escape::Presentable
      end
    end
  end
end
