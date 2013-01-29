require 'json'

module PaczkomatyInpost

  class FileAdapter

    attr_accessor :data_path


    def initialize(data_path)
      self.data_path = Pathname.new(data_path)

      validate_path
    end

    def save_machine_list(data, last_update)
      File.open(File.join(data_path, 'machines.dat'), 'w') do |f|
        f.write data.to_json
      end

      File.open(File.join(data_path, 'machines_date.dat'), 'w') do |f|
        f.write last_update
      end
    end

    def save_price_list(data, last_update)
      File.open(File.join(data_path, 'prices.dat'), 'w') do |f|
        f.write data.to_json
      end

      File.open(File.join(data_path, 'prices_date.dat'), 'w') do |f|
        f.write last_update
      end
    end

    def cached_machines
      data = []
      if File.exist?(File.join(data_path, 'machines.dat'))
        data = JSON.parse(File.read(data_path + 'machines.dat'))
      end

      return data
    end

    def cached_prices
      data = []
      if File.exist?(File.join(data_path, 'prices.dat'))
        data = JSON.parse(File.read(data_path + 'prices.dat'))
      end

      return data
    end

    def last_update_machines
      data = 0
      if File.exist?(File.join(data_path, 'machines_date.dat'))
        data = File.read(data_path + 'machines_date.dat')
      end

      return data
    end

    def last_update_prices
      data = 0
      if File.exist?(File.join(data_path, 'prices_date.dat'))
        data = File.read(data_path + 'prices_date.dat')
      end

      return data
    end


    private

    def validate_path
      if data_path.nil? || !data_path.directory?
        raise Errno::ENOENT, "Invalid path given"
      end

      if data_path.nil? || !data_path.writable?
        raise Errno::EACCES, "Given path is not writeable"
      end
    end

  end
end
