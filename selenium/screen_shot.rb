# gem i selenium-webdriver
require "selenium-webdriver"

driver = Selenium::WebDriver.for :chrome
driver.get("https://igarashikuniaki.net/diary/")
driver.save_screenshot("ss.png")
driver.quit
