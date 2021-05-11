module NavigationHelper
  def is_current_tab?(tab)
    tab == session[:navigation]
  end
end
