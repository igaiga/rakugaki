# gem i selenium-webdriver
require "selenium-webdriver"

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
# headless指定すると普段Chromeで指定しているフォント指定が効かなくなる

driver = Selenium::WebDriver.for :chrome, options: options
driver.get("https://igarashikuniaki.net/diary/")
driver.save_screenshot("ss.png")
driver.quit
