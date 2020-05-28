module Pod

  class ConfigureSwift
    attr_reader :configurator

    def self.perform(options)
      new(options).perform
    end

    def initialize(options)
      @configurator = options.fetch(:configurator)
    end

    def perform

      # There has to be a single file in the Classes dir
      # or a framework won't be created
      `touch Pod/Classes/ReplaceMe.swift`

      # The Podspec should be 8.0 instead of 7.0
      text = File.read("NAME.podspec")
      text.gsub!("7.0", "8.0")
      File.open("NAME.podspec", "w") { |file| file.puts text }

    end
  end

end
