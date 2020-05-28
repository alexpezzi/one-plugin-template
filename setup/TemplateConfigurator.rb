require 'fileutils'
require 'colored2'

module Pod
  class TemplateConfigurator

    attr_reader :pod_name, :pod_plugin_name, :pod_plugin_identifier, :pods_for_podfile, :prefixes, :test_example_file, :username, :email

    def initialize(pod_name)
      @pod_name = pod_name
      @pod_plugin_name = pod_name + 'Plugin'
      @pod_plugin_identifier = 'tv.accedo.one.plugin.' + pod_name.downcase
      @pods_for_podfile = []
      @prefixes = []
      @message_bank = MessageBank.new(self)
    end

    def ask(question)
      answer = ""
      loop do
        puts "\n#{question}?"

        @message_bank.show_prompt
        answer = gets.chomp

        break if answer.length > 0

        print "\nYou need to provide an answer."
      end
      answer
    end

    def ask_with_answers(question, possible_answers)

      print "\n#{question}? ["

      print_info = Proc.new {

        possible_answers_string = possible_answers.each_with_index do |answer, i|
           _answer = (i == 0) ? answer.underlined : answer
           print " " + _answer
           print(" /") if i != possible_answers.length-1
        end
        print " ]\n"
      }
      print_info.call

      answer = ""

      loop do
        @message_bank.show_prompt
        answer = gets.downcase.chomp

        answer = "yes" if answer == "y"
        answer = "no" if answer == "n"

        # default to first answer
        if answer == ""
          answer = possible_answers[0].downcase
          print answer.yellow
        end

        break if possible_answers.map { |a| a.downcase }.include? answer

        print "\nPossible answers are ["
        print_info.call
      end

      answer
    end

    def run
      @message_bank.welcome_message

      ConfigureSwift.perform(configurator: self)

      replace_variables_in_files
      clean_template_files
      rename_template_files
      rename_classes_folder

      @message_bank.farewell_message
    end

    #----------------------------------------#


    def clean_template_files
      [".git", "./**/.gitkeep", "configure", "_CONFIGURE.rb", "README.md", "setup"].each do |asset|
        `rm -rf #{asset}`
      end
    end

    def replace_variables_in_files
      file_names = ['POD_README.md', 'NAME.podspec', 'Pod/Classes/POD_Plugin.swift']
      file_names.each do |file_name|
        text = File.read(file_name)
        text.gsub!("${POD_NAME}", @pod_name)
        text.gsub!("${POD_PLUGIN_NAME}", @pod_plugin_name)
        text.gsub!("${POD_PLUGIN_IDENTIFIER}", @pod_plugin_identifier)
        text.gsub!("${REPO_NAME}", @pod_name.gsub('+', '-'))
        text.gsub!("${USER_NAME}", user_name)
        text.gsub!("${USER_EMAIL}", user_email)
        text.gsub!("${YEAR}", year)
        text.gsub!("${DATE}", date)
        File.open(file_name, "w") { |file| file.puts text }
      end
    end

    def add_line_to_pch line
      @prefixes << line
    end

    def rename_template_files
      FileUtils.mv "POD_README.md", "README.md"
      FileUtils.mv "NAME.podspec", "#{pod_plugin_name}.podspec"
      FileUtils.mv "Pod/Classes/POD_Plugin.swift", "Pod/Classes/#{pod_plugin_name}.swift"
    end

    def rename_classes_folder
      FileUtils.mv "Pod", @pod_name
    end

    def validate_user_details
        return (user_email.length > 0) && (user_name.length > 0)
    end

    #----------------------------------------#

    def user_name
      (ENV['GIT_COMMITTER_NAME'] || github_user_name || `git config user.name` || `<GITHUB_USERNAME>` ).strip
    end

    def github_user_name
      github_user_name = `security find-internet-password -s github.com | grep acct | sed 's/"acct"<blob>="//g' | sed 's/"//g'`.strip
      is_valid = github_user_name.empty? or github_user_name.include? '@'
      return is_valid ? nil : github_user_name
    end

    def user_email
      (ENV['GIT_COMMITTER_EMAIL'] || `git config user.email`).strip
    end

    def year
      Time.now.year.to_s
    end

    def date
      Time.now.strftime "%m/%d/%Y"
    end

    #----------------------------------------#
  end
end
