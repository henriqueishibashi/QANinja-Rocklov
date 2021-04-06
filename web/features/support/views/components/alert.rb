class Alert
  # falando pro Ruby que a Classe login page precisa conhecer todos os recursos do capybara.
  include Capybara::DSL

  def dark_alert
    return find(".alert-dark").text
  end
end
