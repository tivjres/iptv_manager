namespace :setup do
  task :application do
    begin
      ENV_DIR = '.env_files'
      ENV_TYPES = %w[development test production].freeze

      Dir.mkdir(ENV_DIR) unless Dir.exist?(ENV_DIR)

      ENV_TYPES.each do |env_type|
        file_name = "#{ENV_DIR}/.#{env_type}.env"

        env_data = {
          DB_HOST: '',
          DB_PORT: '',
          DB_USER: '',
          DB_PASS: '',
        }

        show_title("Check exist #{file_name}")

        if File.exists?(file_name)
          show_text("File #{file_name} was found, check exist variables")
          File.readlines(file_name).each do |line|
            next if line.blank?
            key, val = line.split('=').first, line.split('=').last[1..-3]
            show_warning("Found key: #{key}, will be saved with a value: #{make_secret_value(val)}")
            env_data[key.to_sym] = val
          end
        end

        File.open(file_name, 'w') do |f|
          show_text("Start to write variables to #{file_name}")
          env_data.each_pair do |key, val|
            f.puts "#{key}=\"#{val}\""
            show_text("Write #{key} to #{file_name} with a value #{make_secret_value(val)}")
          end
        end
      end
    rescue StandardError => e
      show_error(e.message)
    end
  end

  def make_secret_value(value)
    "\"#{value.size >= 6 ? "#{value[0..1]}#{'*' * (value.size - 4)}#{value[-2..-1]}" : '*' * value.size}\""
  end

  def show_title(title)
    puts title.colorize(color: :red, background: :blue)
  end

  def show_warning(warning)
    puts warning.colorize(color: :light_black, background: :light_yellow)
  end

  def show_text(text)
    puts text.colorize(:green)
  end

  def show_error(error)
    puts error.colorize(:red)
  end
end
