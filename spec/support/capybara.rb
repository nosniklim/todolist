# frozen_string_literal: true

require 'capybara'
require 'selenium/webdriver'

Capybara.default_max_wait_time = 3
Capybara.server = :puma, { Silent: true } # Pumaサーバーを使用
Capybara.app_host = 'http://app:3000'
Capybara.save_path = 'tmp/capybara'

# Seleniumの設定を登録
Capybara.register_driver :selenium_remote_chrome do |app|
  chrome_options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.add_argument('--headless=new')
  chrome_options.add_argument('--no-sandbox')
  chrome_options.add_argument('--disable-dev-shm-usage')
  chrome_options.add_argument('--window-size=1920,1080')
  # NOTE: renderer disconnected が出る場合は以下を追加
  # chrome_options.add_argument('--disable-features=VizDisplayCompositor')
  # chrome_options.add_argument('--remote-debugging-port=9222')
  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url: "http://#{ENV.fetch('SELENIUM_HOST', 'selenium')}:4444",
                                 options: chrome_options)
end

RSpec.configure do |config|
  config.before(:each, type: :system) { driven_by :rack_test }
  config.before(:each, type: :system, js: true) { driven_by :selenium_remote_chrome }

  config.after(:each, type: :system) do |example|
    # CIかSAVE_FAILURE_ARTIFACTSを明示した場合のみ保存
    if example.exception && (ENV['CI'] || ENV.fetch('SAVE_FAILURE_ARTIFACTS', nil))
      FileUtils.mkdir_p('tmp/capybara')
      timestamp = Time.current.strftime('%Y%m%d-%H%M%S')
      base_path = "#{example.full_description.parameterize}-#{timestamp}"
      # CIのデバッグ用なのでRuboCopを無効化
      # rubocop:disable Lint/Debugger
      page.save_screenshot("#{base_path}.png", full: true)
      save_page("#{base_path}.html")
      # rubocop:enable Lint/Debugger
    end
  end
end
