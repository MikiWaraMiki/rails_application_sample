if Rails.env.test?
    CrrierWave.configure do |config|
        config.enable_processing = false
    end
end